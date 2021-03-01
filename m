Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D22328569
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhCAQxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234818AbhCAQrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25A6D64F52;
        Mon,  1 Mar 2021 16:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616289;
        bh=swoUql6U5GzGRUfgYmtUvShcH5CSZ4dqlvaIDvIg/Ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LpO8gMbvQ80a6itO4f1+kI5kcoQvFSLsvvI9v6KvcPDf/NXxDDH/sZrehg1SW9Ald
         LFo33TiqNSY1onvejd4CcNH9rJKt/OXy0OVffO6ul+zq7s0pTbznPxHxNH6mRRiN4t
         QyChIozr4OgujtJiNmLtWXdQoyIqwkLymrdBi9xI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 060/176] btrfs: clarify error returns values in __load_free_space_cache
Date:   Mon,  1 Mar 2021 17:12:13 +0100
Message-Id: <20210301161023.928977693@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 3cc64e7ebfb0d7faaba2438334c43466955a96e8 ]

Return value in __load_free_space_cache is not properly set after
(unlikely) memory allocation failures and 0 is returned instead.
This is not a problem for the caller load_free_space_cache because only
value 1 is considered as 'cache loaded' but for clarity it's better
to set the errors accordingly.

Fixes: a67509c30079 ("Btrfs: add a io_ctl struct and helpers for dealing with the space cache")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/free-space-cache.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 9bf72a9088aca..b272299afb673 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -759,8 +759,10 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 	while (num_entries) {
 		e = kmem_cache_zalloc(btrfs_free_space_cachep,
 				      GFP_NOFS);
-		if (!e)
+		if (!e) {
+			ret = -ENOMEM;
 			goto free_cache;
+		}
 
 		ret = io_ctl_read_entry(&io_ctl, e, &type);
 		if (ret) {
@@ -769,6 +771,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		}
 
 		if (!e->bytes) {
+			ret = -1;
 			kmem_cache_free(btrfs_free_space_cachep, e);
 			goto free_cache;
 		}
@@ -788,6 +791,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			num_bitmaps--;
 			e->bitmap = kzalloc(PAGE_SIZE, GFP_NOFS);
 			if (!e->bitmap) {
+				ret = -ENOMEM;
 				kmem_cache_free(
 					btrfs_free_space_cachep, e);
 				goto free_cache;
-- 
2.27.0



