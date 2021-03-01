Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977E0328C20
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239559AbhCASps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:45:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233299AbhCASjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AACD61601;
        Mon,  1 Mar 2021 17:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620839;
        bh=lmnGDkCeCukMFeQ6kYBRW71PwUV10SDPneHdz5bwiO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=br4TCxq5zD4LueHl1tEjs+T2p/cf/SkGz5MGQ+yOIdr/0g7XcitEJymzk31XqhUEj
         1WMq79rQqy1sielB1aC54VkgLkxt/sZriAdQAH1V+/liW4jG636XAnxJ5Pducpy/3E
         eT8GbeXn3oDpi+f/VfRz+RnFqGyOfSpBC2lfEGuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 268/775] btrfs: clarify error returns values in __load_free_space_cache
Date:   Mon,  1 Mar 2021 17:07:16 +0100
Message-Id: <20210301161214.873578792@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 4d8897879c9cb..71d0d14bc18b3 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -775,8 +775,10 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
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
@@ -785,6 +787,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 		}
 
 		if (!e->bytes) {
+			ret = -1;
 			kmem_cache_free(btrfs_free_space_cachep, e);
 			goto free_cache;
 		}
@@ -805,6 +808,7 @@ static int __load_free_space_cache(struct btrfs_root *root, struct inode *inode,
 			e->bitmap = kmem_cache_zalloc(
 					btrfs_free_space_bitmap_cachep, GFP_NOFS);
 			if (!e->bitmap) {
+				ret = -ENOMEM;
 				kmem_cache_free(
 					btrfs_free_space_cachep, e);
 				goto free_cache;
-- 
2.27.0



