Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49F524BCBD
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgHTJn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbgHTJnA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:43:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDCD92173E;
        Thu, 20 Aug 2020 09:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916579;
        bh=eZkObATRnty0e7Ot5i/YiemRbDKHfPtcLirUorAG2kc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JdNfKuqgiDffIL5egFDwPeDk0sBmYWzciiL8yeR3JCzRiQWV87RCLoBJdobKdCu0x
         54d6j4avf3MzOVkDWmYSvc1FaLC4IeKa+8ervDCE6NSsi/E4sT6D1VCjF0+6HJcVMU
         6HhztpTQxeren6nQTEGYuonlixToOl92ovFS9HXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Qiujun Huang <anenbupt@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 178/204] fs/minix: remove expected error message in block_to_path()
Date:   Thu, 20 Aug 2020 11:21:15 +0200
Message-Id: <20200820091615.096124816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit f666f9fb9a36f1c833b9d18923572f0e4d304754 ]

When truncating a file to a size within the last allowed logical block,
block_to_path() is called with the *next* block.  This exceeds the limit,
causing the "block %ld too big" error message to be printed.

This case isn't actually an error; there are just no more blocks past that
point.  So, remove this error message.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Link: http://lkml.kernel.org/r/20200628060846.682158-7-ebiggers@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/itree_v1.c | 12 ++++++------
 fs/minix/itree_v2.c | 12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index 405573a79aab4..1fed906042aa8 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -29,12 +29,12 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, inode->i_sb->s_bdev);
-	} else if ((u64)block * BLOCK_SIZE >= inode->i_sb->s_maxbytes) {
-		if (printk_ratelimit())
-			printk("MINIX-fs: block_to_path: "
-			       "block %ld too big on dev %pg\n",
-				block, inode->i_sb->s_bdev);
-	} else if (block < 7) {
+		return 0;
+	}
+	if ((u64)block * BLOCK_SIZE >= inode->i_sb->s_maxbytes)
+		return 0;
+
+	if (block < 7) {
 		offsets[n++] = block;
 	} else if ((block -= 7) < 512) {
 		offsets[n++] = 7;
diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
index ee8af2f9e2828..9d00f31a2d9d1 100644
--- a/fs/minix/itree_v2.c
+++ b/fs/minix/itree_v2.c
@@ -32,12 +32,12 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, sb->s_bdev);
-	} else if ((u64)block * (u64)sb->s_blocksize >= sb->s_maxbytes) {
-		if (printk_ratelimit())
-			printk("MINIX-fs: block_to_path: "
-			       "block %ld too big on dev %pg\n",
-				block, sb->s_bdev);
-	} else if (block < DIRCOUNT) {
+		return 0;
+	}
+	if ((u64)block * (u64)sb->s_blocksize >= sb->s_maxbytes)
+		return 0;
+
+	if (block < DIRCOUNT) {
 		offsets[n++] = block;
 	} else if ((block -= DIRCOUNT) < INDIRCOUNT(sb)) {
 		offsets[n++] = DIRCOUNT;
-- 
2.25.1



