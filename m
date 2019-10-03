Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF6FCA432
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390417AbfJCQW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390411AbfJCQWz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 783B020659;
        Thu,  3 Oct 2019 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119775;
        bh=2G0dztF253cPdRh9s33RdqiI65/0buDPPhCyXdohiho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mbkbop/heSYOjhHCuGGYdC2VgFDO9jOzTZghYgfYIS6mH/tHDVbQhYYFYpNmxk9qC
         iHmeD/4r/PVzzZqZfaK6IQ6PsTvB5NVdzpQ+/78w2hfUFHHkebpeQ+OsyVnS0R4TI1
         cSEBiQRjT3UidSneCMM8u5WK1x2e3QdiBxOydcTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 4.19 187/211] smb3: allow disabling requesting leases
Date:   Thu,  3 Oct 2019 17:54:13 +0200
Message-Id: <20191003154528.113625131@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 3e7a02d47872081f4b6234a9f72500f1d10f060c upstream.

In some cases to work around server bugs or performance
problems it can be helpful to be able to disable requesting
SMB2.1/SMB3 leases on a particular mount (not to all servers
and all shares we are mounted to). Add new mount parm
"nolease" which turns off requesting leases on directory
or file opens.  Currently the only way to disable leases is
globally through a module load parameter. This is more
granular.

Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
CC: Stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifsfs.c   |    2 ++
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/connect.c  |    9 ++++++++-
 fs/cifs/smb2pdu.c  |    2 +-
 4 files changed, 13 insertions(+), 2 deletions(-)

--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -428,6 +428,8 @@ cifs_show_options(struct seq_file *s, st
 	cifs_show_security(s, tcon->ses);
 	cifs_show_cache_flavor(s, cifs_sb);
 
+	if (tcon->no_lease)
+		seq_puts(s, ",nolease");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MULTIUSER)
 		seq_puts(s, ",multiuser");
 	else if (tcon->ses->user_name)
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -543,6 +543,7 @@ struct smb_vol {
 	bool noblocksnd:1;
 	bool noautotune:1;
 	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
+	bool no_lease:1;     /* disable requesting leases */
 	bool fsc:1;	/* enable fscache */
 	bool mfsymlinks:1; /* use Minshall+French Symlinks */
 	bool multiuser:1;
@@ -1004,6 +1005,7 @@ struct cifs_tcon {
 	bool need_reopen_files:1; /* need to reopen tcon file handles */
 	bool use_resilient:1; /* use resilient instead of durable handles */
 	bool use_persistent:1; /* use persistent instead of durable handles */
+	bool no_lease:1;    /* Do not request leases on files or directories */
 	__le32 capabilities;
 	__u32 share_flags;
 	__u32 maximal_access;
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -70,7 +70,7 @@ enum {
 	Opt_user_xattr, Opt_nouser_xattr,
 	Opt_forceuid, Opt_noforceuid,
 	Opt_forcegid, Opt_noforcegid,
-	Opt_noblocksend, Opt_noautotune,
+	Opt_noblocksend, Opt_noautotune, Opt_nolease,
 	Opt_hard, Opt_soft, Opt_perm, Opt_noperm,
 	Opt_mapposix, Opt_nomapposix,
 	Opt_mapchars, Opt_nomapchars, Opt_sfu,
@@ -129,6 +129,7 @@ static const match_table_t cifs_mount_op
 	{ Opt_noforcegid, "noforcegid" },
 	{ Opt_noblocksend, "noblocksend" },
 	{ Opt_noautotune, "noautotune" },
+	{ Opt_nolease, "nolease" },
 	{ Opt_hard, "hard" },
 	{ Opt_soft, "soft" },
 	{ Opt_perm, "perm" },
@@ -1542,6 +1543,9 @@ cifs_parse_mount_options(const char *mou
 		case Opt_noautotune:
 			vol->noautotune = 1;
 			break;
+		case Opt_nolease:
+			vol->no_lease = 1;
+			break;
 		case Opt_hard:
 			vol->retry = 1;
 			break;
@@ -3023,6 +3027,8 @@ static int match_tcon(struct cifs_tcon *
 		return 0;
 	if (tcon->snapshot_time != volume_info->snapshot_time)
 		return 0;
+	if (tcon->no_lease != volume_info->no_lease)
+		return 0;
 	return 1;
 }
 
@@ -3231,6 +3237,7 @@ cifs_get_tcon(struct cifs_ses *ses, stru
 	tcon->nocase = volume_info->nocase;
 	tcon->nohandlecache = volume_info->nohandlecache;
 	tcon->local_lease = volume_info->local_lease;
+	tcon->no_lease = volume_info->no_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
 
 	spin_lock(&cifs_tcp_ses_lock);
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2192,7 +2192,7 @@ SMB2_open_init(struct cifs_tcon *tcon, s
 	iov[1].iov_len = uni_path_len;
 	iov[1].iov_base = path;
 
-	if (!server->oplocks)
+	if ((!server->oplocks) || (tcon->no_lease))
 		*oplock = SMB2_OPLOCK_LEVEL_NONE;
 
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LEASING) ||


