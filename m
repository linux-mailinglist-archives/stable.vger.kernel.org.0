Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5CF20C661
	for <lists+stable@lfdr.de>; Sun, 28 Jun 2020 08:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgF1GKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jun 2020 02:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgF1GKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 28 Jun 2020 02:10:35 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CD5F2070A;
        Sun, 28 Jun 2020 06:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593324634;
        bh=zRFRnZHsu8UqKgRipuT2ilTa85dm6dD+2rTnXyb6J/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IhPGksD6L55r+If240YgFFLbucUtAzcblC42feZjzCgBSuYQQghPP7TKTErsMy/c/
         zkanAXQ9DltLswIK0Fbm/iXN46gIb2uy5KWTvp3Lc4ihLuvGmB219OY7jlnW1TjQGq
         43BtsGf8QPG/F9nHU3LbCSUEjKXR2fFrrqvrmic8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, Qiujun Huang <hqjagain@gmail.com>,
        stable@vger.kernel.org,
        syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
Subject: [PATCH 1/6] fs/minix: check return value of sb_getblk()
Date:   Sat, 27 Jun 2020 23:08:40 -0700
Message-Id: <20200628060846.682158-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200628060846.682158-1-ebiggers@kernel.org>
References: <20200628060846.682158-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

sb_getblk() can fail, so check its return value.

This fixes a NULL pointer dereference.

Reported-by: syzbot+4a88b2b9dc280f47baf4@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Originally-from: Qiujun Huang <anenbupt@gmail.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/minix/itree_common.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/minix/itree_common.c b/fs/minix/itree_common.c
index 043c3fdbc8e7..446148792f41 100644
--- a/fs/minix/itree_common.c
+++ b/fs/minix/itree_common.c
@@ -75,6 +75,7 @@ static int alloc_branch(struct inode *inode,
 	int n = 0;
 	int i;
 	int parent = minix_new_block(inode);
+	int err = -ENOSPC;
 
 	branch[0].key = cpu_to_block(parent);
 	if (parent) for (n = 1; n < num; n++) {
@@ -85,6 +86,11 @@ static int alloc_branch(struct inode *inode,
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
@@ -103,7 +109,7 @@ static int alloc_branch(struct inode *inode,
 		bforget(branch[i].bh);
 	for (i = 0; i < n; i++)
 		minix_free_block(inode, block_to_cpu(branch[i].key));
-	return -ENOSPC;
+	return err;
 }
 
 static inline int splice_branch(struct inode *inode,
-- 
2.27.0

