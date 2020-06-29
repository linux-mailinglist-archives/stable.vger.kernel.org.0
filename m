Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0622220D766
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730999AbgF2T3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732654AbgF2TZm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45C1C25344;
        Mon, 29 Jun 2020 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445184;
        bh=ihjGdyocaFqppYkjMVdv4mk/Ld1RGtOTZZieHUJPaDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yf/PkQ9ks+ezgmz7gxTyVUENY+/DiWsoqFQ+hp547CyFl2jTJZ7Me4Zbcyhkh9IQW
         CsbdvMpgqPTtuycEAR6VHvMS61Oid4RAM7ODrh7z2+fOQXJjPWoWbHeG6wIY1x4i0n
         XvXjpfY5CpYc4LS0FxFCrgtORivX3vUFJ3UnKBZ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Olga Kornievskaia <olga.kornievskaia@gmail.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        Neil Brown <neilb@suse.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 75/78] NFSv4 fix CLOSE not waiting for direct IO compeletion
Date:   Mon, 29 Jun 2020 11:38:03 -0400
Message-Id: <20200629153806.2494953-76-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153806.2494953-1-sashal@kernel.org>
References: <20200629153806.2494953-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.186-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.186-rc1
X-KernelTest-Deadline: 2020-07-01T15:38+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olga Kornievskaia <olga.kornievskaia@gmail.com>

commit d03727b248d0dae6199569a8d7b629a681154633 upstream.

Figuring out the root case for the REMOVE/CLOSE race and
suggesting the solution was done by Neil Brown.

Currently what happens is that direct IO calls hold a reference
on the open context which is decremented as an asynchronous task
in the nfs_direct_complete(). Before reference is decremented,
control is returned to the application which is free to close the
file. When close is being processed, it decrements its reference
on the open_context but since directIO still holds one, it doesn't
sent a close on the wire. It returns control to the application
which is free to do other operations. For instance, it can delete a
file. Direct IO is finally releasing its reference and triggering
an asynchronous close. Which races with the REMOVE. On the server,
REMOVE can be processed before the CLOSE, failing the REMOVE with
EACCES as the file is still opened.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Suggested-by: Neil Brown <neilb@suse.com>
CC: stable@vger.kernel.org
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/direct.c | 13 +++++++++----
 fs/nfs/file.c   |  1 +
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index e6ea4511c41ce..3cef33b0f7e08 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -396,8 +396,6 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 {
 	struct inode *inode = dreq->inode;
 
-	inode_dio_end(inode);
-
 	if (dreq->iocb) {
 		long res = (long) dreq->error;
 		if (dreq->count != 0) {
@@ -409,7 +407,10 @@ static void nfs_direct_complete(struct nfs_direct_req *dreq)
 
 	complete(&dreq->completion);
 
+	igrab(inode);
 	nfs_direct_req_release(dreq);
+	inode_dio_end(inode);
+	iput(inode);
 }
 
 static void nfs_direct_read_completion(struct nfs_pgio_header *hdr)
@@ -539,8 +540,10 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
 	 * generic layer handle the completion.
 	 */
 	if (requested_bytes == 0) {
-		inode_dio_end(inode);
+		igrab(inode);
 		nfs_direct_req_release(dreq);
+		inode_dio_end(inode);
+		iput(inode);
 		return result < 0 ? result : -EIO;
 	}
 
@@ -957,8 +960,10 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 	 * generic layer handle the completion.
 	 */
 	if (requested_bytes == 0) {
-		inode_dio_end(inode);
+		igrab(inode);
 		nfs_direct_req_release(dreq);
+		inode_dio_end(inode);
+		iput(inode);
 		return result < 0 ? result : -EIO;
 	}
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 81cca49a83750..7da2cea1e7a06 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -82,6 +82,7 @@ nfs_file_release(struct inode *inode, struct file *filp)
 	dprintk("NFS: release(%pD2)\n", filp);
 
 	nfs_inc_stats(inode, NFSIOS_VFSRELEASE);
+	inode_dio_wait(inode);
 	nfs_file_clear_open_context(filp);
 	return 0;
 }
-- 
2.25.1

