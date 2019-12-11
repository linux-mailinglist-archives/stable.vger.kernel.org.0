Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8517311B499
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732497AbfLKPZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732659AbfLKPZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78B124658;
        Wed, 11 Dec 2019 15:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077910;
        bh=yNEKqnYFfGAB5VCK7Vas/fD9z/qwhU9RBGBWkm0MGc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sg6WPDBwiCn/2cnwWEGA65TtRsZ994or3Qgsk8xBKX8fThmVDfBYWH3r7GkHwxOMq
         FreWY1dFEe7GKa9PLTlfNFBp+QStXySso74aUDcn9qKQgpxmzGMf+Q4gIoDOZgXcPY
         q2JjzoJF405bwPV3tJ32KFJLvHYmtFyWhsO94n2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 4.19 217/243] CIFS: Fix SMB2 oplock break processing
Date:   Wed, 11 Dec 2019 16:06:19 +0100
Message-Id: <20191211150353.989552055@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Shilovsky <pshilov@microsoft.com>

commit fa9c2362497fbd64788063288dc4e74daf977ebb upstream.

Even when mounting modern protocol version the server may be
configured without supporting SMB2.1 leases and the client
uses SMB2 oplock to optimize IO performance through local caching.

However there is a problem in oplock break handling that leads
to missing a break notification on the client who has a file
opened. It latter causes big latencies to other clients that
are trying to open the same file.

The problem reproduces when there are multiple shares from the
same server mounted on the client. The processing code tries to
match persistent and volatile file ids from the break notification
with an open file but it skips all share besides the first one.
Fix this by looking up in all shares belonging to the server that
issued the oplock break.

Cc: Stable <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/smb2misc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -673,10 +673,10 @@ smb2_is_valid_oplock_break(char *buffer,
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each(tmp, &server->smb_ses_list) {
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
+
 		list_for_each(tmp1, &ses->tcon_list) {
 			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
 
-			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
 			spin_lock(&tcon->open_file_lock);
 			list_for_each(tmp2, &tcon->openFileList) {
 				cfile = list_entry(tmp2, struct cifsFileInfo,
@@ -688,6 +688,8 @@ smb2_is_valid_oplock_break(char *buffer,
 					continue;
 
 				cifs_dbg(FYI, "file id match, oplock break\n");
+				cifs_stats_inc(
+				    &tcon->stats.cifs_stats.num_oplock_brks);
 				cinode = CIFS_I(d_inode(cfile->dentry));
 				spin_lock(&cfile->file_info_lock);
 				if (!CIFS_CACHE_WRITE(cinode) &&
@@ -720,9 +722,6 @@ smb2_is_valid_oplock_break(char *buffer,
 				return true;
 			}
 			spin_unlock(&tcon->open_file_lock);
-			spin_unlock(&cifs_tcp_ses_lock);
-			cifs_dbg(FYI, "No matching file for oplock break\n");
-			return true;
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);


