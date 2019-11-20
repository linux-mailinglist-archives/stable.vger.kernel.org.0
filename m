Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C458F103EFA
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731866AbfKTPkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52904 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731698AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5X-0004d3-Fk; Wed, 20 Nov 2019 15:40:15 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004OF-Is; Wed, 20 Nov 2019 15:40:13 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ronnie Sahlberg" <lsahlber@redhat.com>,
        "Steve French" <stfrench@microsoft.com>,
        "Pavel Shilovsky" <pshilov@microsoft.com>
Date:   Wed, 20 Nov 2019 15:38:29 +0000
Message-ID: <lsq.1574264230.70362151@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 79/83] CIFS: Fix use after free of file info structures
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Shilovsky <pshilov@microsoft.com>

commit 1a67c415965752879e2e9fad407bc44fc7f25f23 upstream.

Currently the code assumes that if a file info entry belongs
to lists of open file handles of an inode and a tcon then
it has non-zero reference. The recent changes broke that
assumption when putting the last reference of the file info.
There may be a situation when a file is being deleted but
nothing prevents another thread to reference it again
and start using it. This happens because we do not hold
the inode list lock while checking the number of references
of the file info structure. Fix this by doing the proper
locking when doing the check.

Fixes: 487317c99477d ("cifs: add spinlock for the openFileList to cifsInodeInfo")
Fixes: cb248819d209d ("cifs: use cifsInodeInfo->open_file_lock while iterating to avoid a panic")
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -398,10 +398,11 @@ void _cifsFileInfo_put(struct cifsFileIn
 	bool oplock_break_cancelled;
 
 	spin_lock(&tcon->open_file_lock);
-
+	spin_lock(&cifsi->open_file_lock);
 	spin_lock(&cifs_file->file_info_lock);
 	if (--cifs_file->count > 0) {
 		spin_unlock(&cifs_file->file_info_lock);
+		spin_unlock(&cifsi->open_file_lock);
 		spin_unlock(&tcon->open_file_lock);
 		return;
 	}
@@ -414,9 +415,7 @@ void _cifsFileInfo_put(struct cifsFileIn
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
-	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
-	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
 
 	if (list_empty(&cifsi->openFileList)) {
@@ -432,6 +431,7 @@ void _cifsFileInfo_put(struct cifsFileIn
 		cifs_set_oplock_level(cifsi, 0);
 	}
 
+	spin_unlock(&cifsi->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
 	oplock_break_cancelled = wait_oplock_handler ?

