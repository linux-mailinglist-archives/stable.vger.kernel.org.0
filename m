Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58AF24BCF0
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgHTMzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728829AbgHTJm5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:42:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F98E22CAF;
        Thu, 20 Aug 2020 09:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916576;
        bh=n7wzPQ3M0ERQ59sffFXEWhQWFOF761BQYOzZAulle1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEFBcOzUVmycW9Xz7YCCHlApfXzHq5Q2aphTOgLlWd2snx6LmD28w7SmPc9bbPOLW
         R4lfHPPwOfK5cmm7LqAvnEvEcWxhJcKZ5//XBAtDpJ0MrPZo2HcJY+SDGpUq1p8Xx2
         TeETvp3GbQw6ZtzxwPoknnezV97BaWpZbbvLmMZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Qiujun Huang <anenbupt@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 177/204] fs/minix: fix block limit check for V1 filesystems
Date:   Thu, 20 Aug 2020 11:21:14 +0200
Message-Id: <20200820091615.045879304@linuxfoundation.org>
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

[ Upstream commit 0a12c4a8069607247cb8edc3b035a664e636fd9a ]

The minix filesystem reads its maximum file size from its on-disk
superblock.  This value isn't necessarily a multiple of the block size.
When it's not, the V1 block mapping code doesn't allow mapping the last
possible block.  Commit 6ed6a722f9ab ("minixfs: fix block limit check")
fixed this in the V2 mapping code.  Fix it in the V1 mapping code too.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Qiujun Huang <anenbupt@gmail.com>
Link: http://lkml.kernel.org/r/20200628060846.682158-6-ebiggers@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/minix/itree_v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
index c0d418209ead1..405573a79aab4 100644
--- a/fs/minix/itree_v1.c
+++ b/fs/minix/itree_v1.c
@@ -29,7 +29,7 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
 	if (block < 0) {
 		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %pg\n",
 			block, inode->i_sb->s_bdev);
-	} else if (block >= inode->i_sb->s_maxbytes/BLOCK_SIZE) {
+	} else if ((u64)block * BLOCK_SIZE >= inode->i_sb->s_maxbytes) {
 		if (printk_ratelimit())
 			printk("MINIX-fs: block_to_path: "
 			       "block %ld too big on dev %pg\n",
-- 
2.25.1



