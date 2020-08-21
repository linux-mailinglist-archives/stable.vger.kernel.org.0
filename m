Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B49824CB20
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 05:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgHUDGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 23:06:52 -0400
Received: from gateway31.websitewelcome.com ([192.185.143.51]:35722 "EHLO
        gateway31.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725852AbgHUDGv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 23:06:51 -0400
X-Greylist: delayed 1424 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2020 23:06:51 EDT
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 7A2CF1C215
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 21:43:05 -0500 (CDT)
Received: from br540.hostgator.com.br ([108.179.252.180])
        by cmsmtp with SMTP
        id 8x1FkW3NHOIGp8x1Fk8bqz; Thu, 20 Aug 2020 21:43:05 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=mpdesouza.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=mqMipfFxAhFP9IXccuiRfTgI9EhL9JTdB+RkoJtnolI=; b=pRlD8xLCWlfRtNoWKbKm+7SWzN
        iJdeAd1OKKgY4WWHVAqK4rmS9SUIDjWkp6Uaes41S3M20eXWgL+Pqr1jYtaYzJPo+LUNOLYNSBMVK
        bBnKQqdrjT1Bld3fFZgKz4yiiJpwAkpYwKfy8f430GKSJNeeqop5USxIjIv8UAQXjeBCajHwtby2b
        STPO7ClblZIYHrhv5U06XYRVu1xcVe2wTEqlpm+EkuzPd0AztPXa4FdpJBoLRJ77jbmZe+jQrIKs5
        jt/RcsFHAbAmd8Oao/RFRtZ5IAgW6PXH/+YqrTpcCeKueukU0REzAeOhFbhwgm6EhuEpIg132AWHG
        SpGwJnxw==;
Received: from [191.248.104.145] (port=44546 helo=hephaestus.suse.de)
        by br540.hostgator.com.br with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <marcos@mpdesouza.com>)
        id 1k8x1E-000UJv-Uo; Thu, 20 Aug 2020 23:43:05 -0300
From:   Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     linux-kernel@vger.kernel.org
Cc:     dsterba@suse.com, wqu@suse.com, linux-btrfs@vger.kernel.org,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        stable@vger.kernel.org
Subject: [PATCH] btrfs: block-group: Fix free-space bitmap threshould
Date:   Thu, 20 Aug 2020 23:42:31 -0300
Message-Id: <20200821024231.16256-1-marcos@mpdesouza.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - br540.hostgator.com.br
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mpdesouza.com
X-BWhitelist: no
X-Source-IP: 191.248.104.145
X-Source-L: No
X-Exim-ID: 1k8x1E-000UJv-Uo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (hephaestus.suse.de) [191.248.104.145]:44546
X-Source-Auth: marcos@mpdesouza.com
X-Email-Count: 1
X-Source-Cap: bXBkZXNvNTM7bXBkZXNvNTM7YnI1NDAuaG9zdGdhdG9yLmNvbS5icg==
X-Local-Domain: yes
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[BUG]
After commit 9afc66498a0b ("btrfs: block-group: refactor how we read one
block group item"), cache->length is being assigned after calling
btrfs_create_block_group_cache. This causes a problem since
set_free_space_tree_thresholds is calculate the free-space threshould to
decide is the free-space tree should convert from extents to bitmaps.

The current code calls set_free_space_tree_thresholds with cache->length
being 0, which then makes cache->bitmap_high_thresh being zero. This
implies the system will always use bitmap instead of extents, which is
not desired if the block group is not fragmented.

This behavior can be seen by a test that expects to repair systems
with FREE_SPACE_EXTENT and FREE_SPACE_BITMAP, but the current code only
created FREE_SPACE_BITMAP.

[FIX]
Call set_free_space_tree_thresholds after setting cache->length.

Link: https://github.com/kdave/btrfs-progs/issues/251
Fixes: 9afc66498a0b ("btrfs: block-group: refactor how we read one block group item")
CC: stable@vger.kernel.org # 5.8+
Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 fs/btrfs/block-group.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 44fdfa2eeb2e..01e8ba1da1d3 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1798,7 +1798,6 @@ static struct btrfs_block_group *btrfs_create_block_group_cache(
 
 	cache->fs_info = fs_info;
 	cache->full_stripe_len = btrfs_full_stripe_len(fs_info, start);
-	set_free_space_tree_thresholds(cache);
 
 	cache->discard_index = BTRFS_DISCARD_INDEX_UNUSED;
 
@@ -1908,6 +1907,8 @@ static int read_one_block_group(struct btrfs_fs_info *info,
 
 	read_block_group_item(cache, path, key);
 
+	set_free_space_tree_thresholds(cache);
+
 	if (need_clear) {
 		/*
 		 * When we mount with old space cache, we need to
@@ -2128,6 +2129,7 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 		return -ENOMEM;
 
 	cache->length = size;
+	set_free_space_tree_thresholds(cache);
 	cache->used = bytes_used;
 	cache->flags = type;
 	cache->last_byte_to_unpin = (u64)-1;
-- 
2.28.0

