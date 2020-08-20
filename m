Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF35124B782
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbgHTK4C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:56:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730323AbgHTKOB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:14:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFBEC20724;
        Thu, 20 Aug 2020 10:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918441;
        bh=Vz1IWgRRXlQKFbJAubLEj5+gx2dz54XngUGfMWWbNtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUIayVyxAW5mkD4rK098obgeEh5mZOXraFl2BFStvHeCDtx8oMSGUA27h4KLZaU0C
         JM+U+BXiOwrhUifoCDqe0qMUl/6pNwJn5eCUMd1/VL2OoP/SagWDzWWRP+l55KB/Ch
         Zvxl+0qlm+GZLlJ6WlErU461EQwIYZ7KYH7Z9T4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qiujun Huang <anenbupt@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 153/228] fs/minix: check return value of sb_getblk()
Date:   Thu, 20 Aug 2020 11:22:08 +0200
Message-Id: <20200820091615.228057563@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit da27e0a0e5f655f0d58d4e153c3182bb2b290f64 upstream.

Patch series "fs/minix: fix syzbot bugs and set s_maxbytes".

This series fixes all syzbot bugs in the minix filesystem:

	KASAN: null-ptr-deref Write in get_block
	KASAN: use-after-free Write in get_block
	KASAN: use-after-free Read in get_block
	WARNING in inc_nlink
	KMSAN: uninit-value in get_block
	WARNING in drop_nlink

It also fixes the minix filesystem to set s_maxbytes correctly, so that
userspace sees the correct behavior when exceeding the max file size.

This patch (of 6):

sb_getblk() can fail, so check its return value.

This fixes a NULL pointer dereference.

Originally from Qiujun Huang.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Qiujun Huang <anenbupt@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200628060846.682158-1-ebiggers@kernel.org
Link: http://lkml.kernel.org/r/20200628060846.682158-2-ebiggers@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/minix/itree_common.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/minix/itree_common.c
+++ b/fs/minix/itree_common.c
@@ -75,6 +75,7 @@ static int alloc_branch(struct inode *in
 	int n = 0;
 	int i;
 	int parent = minix_new_block(inode);
+	int err = -ENOSPC;
 
 	branch[0].key = cpu_to_block(parent);
 	if (parent) for (n = 1; n < num; n++) {
@@ -85,6 +86,11 @@ static int alloc_branch(struct inode *in
 			break;
 		branch[n].key = cpu_to_block(nr);
 		bh = sb_getblk(inode->i_sb, parent);
+		if (!bh) {
+			minix_free_block(inode, nr);
+			err = -ENOMEM;
+			break;
+		}
 		lock_buffer(bh);
 		memset(bh->b_data, 0, bh->b_size);
 		branch[n].bh = bh;
@@ -103,7 +109,7 @@ static int alloc_branch(struct inode *in
 		bforget(branch[i].bh);
 	for (i = 0; i < n; i++)
 		minix_free_block(inode, block_to_cpu(branch[i].key));
-	return -ENOSPC;
+	return err;
 }
 
 static inline int splice_branch(struct inode *inode,


