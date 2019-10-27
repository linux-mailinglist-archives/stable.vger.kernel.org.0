Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE08DE6825
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbfJ0VYw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732607AbfJ0VYv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:51 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5232A21848;
        Sun, 27 Oct 2019 21:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211490;
        bh=n5SPVYOGa0Hne9esLU2PNZLxEkZ0+lzMCBm6UmU2O58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnlQ/6dQV6iTG8ZitVg8LOVrhposB6kOkGklltZSpEhfFBo2b7QumkI/lEtK5JlL/
         rEXmgZ6GDv4HVMyme1a7ADj0cvVEvqcUm0HS59RJvIFZjMMEj8Q+pdD/Wy0KPOk3n8
         Jn3/nvhyq7ugV9+4zUEnQaLISYVcZIZEaxZxE1uU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.3 169/197] CIFS: Fix use after free of file info structures
Date:   Sun, 27 Oct 2019 22:01:27 +0100
Message-Id: <20191027203403.639707713@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: Stable <stable@vger.kernel.org>
Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/file.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -405,10 +405,11 @@ void _cifsFileInfo_put(struct cifsFileIn
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
@@ -421,9 +422,7 @@ void _cifsFileInfo_put(struct cifsFileIn
 	cifs_add_pending_open_locked(&fid, cifs_file->tlink, &open);
 
 	/* remove it from the lists */
-	spin_lock(&cifsi->open_file_lock);
 	list_del(&cifs_file->flist);
-	spin_unlock(&cifsi->open_file_lock);
 	list_del(&cifs_file->tlist);
 	atomic_dec(&tcon->num_local_opens);
 
@@ -440,6 +439,7 @@ void _cifsFileInfo_put(struct cifsFileIn
 		cifs_set_oplock_level(cifsi, 0);
 	}
 
+	spin_unlock(&cifsi->open_file_lock);
 	spin_unlock(&tcon->open_file_lock);
 
 	oplock_break_cancelled = wait_oplock_handler ?


