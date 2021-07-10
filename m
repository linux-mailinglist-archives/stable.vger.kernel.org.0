Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87DB3C3117
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhGJCkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235799AbhGJCjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1B216142C;
        Sat, 10 Jul 2021 02:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884557;
        bh=yD6W4/r6M9zDVJ64wHXlrnyWoD3qTyHoWwz14c6ixt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ntqts4jD31AxpPOwIkz1StiTwLbhT8t+x/LDMNxKGVLu0XFAJsmfmJ83LzRss7Zjk
         woMhRzR7nL9lCZhEUGBGpvfmTMbSRmaciPsqyp6+KPDYJk6Kc78UqPO+kohMynZdS0
         OSoxgpkp5/brs6YXLfn4DgiGt8KudFZ42YPCDXouZevZnwkzEAOrdCpUr2zLBbHL8D
         sX6SKKsL6opzMHrifbWBmXmd181Uc1fnh/zQ2XCbU8XSE1oCeMAmFjAGGVjUeKGG0E
         BuT3ohlVbhIt6oRtHkBDGGXIY66Lu3aeIYawkxmvE8P0z1Mm8tPBmYUXXoUa/VSxq1
         pe6EqQnc0I8Ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+0a89a7b56db04c21a656@syzkaller.appspotmail.com,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.14 29/33] jfs: fix GPF in diFree
Date:   Fri,  9 Jul 2021 22:35:11 -0400
Message-Id: <20210710023516.3172075-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023516.3172075-1-sashal@kernel.org>
References: <20210710023516.3172075-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 9d574f985fe33efd6911f4d752de6f485a1ea732 ]

Avoid passing inode with
JFS_SBI(inode->i_sb)->ipimap == NULL to
diFree()[1]. GFP will appear:

	struct inode *ipimap = JFS_SBI(ip->i_sb)->ipimap;
	struct inomap *imap = JFS_IP(ipimap)->i_imap;

JFS_IP() will return invalid pointer when ipimap == NULL

Call Trace:
 diFree+0x13d/0x2dc0 fs/jfs/jfs_imap.c:853 [1]
 jfs_evict_inode+0x2c9/0x370 fs/jfs/inode.c:154
 evict+0x2ed/0x750 fs/inode.c:578
 iput_final fs/inode.c:1654 [inline]
 iput.part.0+0x3fe/0x820 fs/inode.c:1680
 iput+0x58/0x70 fs/inode.c:1670

Reported-and-tested-by: syzbot+0a89a7b56db04c21a656@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 054cc761b426..87b41edc800d 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -161,7 +161,8 @@ void jfs_evict_inode(struct inode *inode)
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			diFree(inode);
+			if (JFS_SBI(inode->i_sb)->ipimap)
+				diFree(inode);
 
 			/*
 			 * Free the inode from the quota allocation.
-- 
2.30.2

