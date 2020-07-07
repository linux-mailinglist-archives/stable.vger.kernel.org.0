Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBDAE21727C
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 17:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728251AbgGGPd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 11:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:59558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgGGPTr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jul 2020 11:19:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1388920663;
        Tue,  7 Jul 2020 15:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594135186;
        bh=bvPcKlwlDuQ39NgeyRvOJPem66G0vhDdmIycbdbyolo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTV6uEiwaeAYLJiBn4Xtl33KdeVpUMBSvx73GmWTcuep5Kt2aIS+C86KREFBCqY0t
         bIUVfu1kB3GfOpwZOvP3g8hVCId47AwfkEZVX9aPO3gzX/GgoC23tVA3yaz4YxXG30
         smz1HeFlsjdPILpamkhpDEzpSCZn3BFqMiUMRnIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Aurich <paul@darkrain42.org>,
        Steve French <stfrench@microsoft.com>,
        Aurelien Aptel <aaptel@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/36] SMB3: Honor posix flag for multiuser mounts
Date:   Tue,  7 Jul 2020 17:17:15 +0200
Message-Id: <20200707145750.232853396@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200707145749.130272978@linuxfoundation.org>
References: <20200707145749.130272978@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Aurich <paul@darkrain42.org>

[ Upstream commit 5391b8e1b7b7e5cfa2dd4ffdc4b8c6b64dfd1866 ]

The flag from the primary tcon needs to be copied into the volume info
so that cifs_get_tcon will try to enable extensions on the per-user
tcon. At that point, since posix extensions must have already been
enabled on the superblock, don't try to needlessly adjust the mount
flags.

Fixes: ce558b0e17f8 ("smb3: Add posix create context for smb3.11 posix mounts")
Fixes: b326614ea215 ("smb3: allow "posix" mount option to enable new SMB311 protocol extensions")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9e569d60c636b..136de62f351a7 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4602,6 +4602,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	vol_info->nohandlecache = master_tcon->nohandlecache;
 	vol_info->local_lease = master_tcon->local_lease;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
+	vol_info->linux_ext = master_tcon->posix_extensions;
 	vol_info->sectype = master_tcon->ses->sectype;
 	vol_info->sign = master_tcon->ses->sign;
 
@@ -4629,10 +4630,6 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 		goto out;
 	}
 
-	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
-	if (tcon->posix_extensions)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
-
 	if (cap_unix(ses))
 		reset_cifs_unix_caps(0, tcon, NULL, vol_info);
 
-- 
2.25.1



