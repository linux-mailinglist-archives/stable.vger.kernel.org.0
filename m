Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F3A6583EB
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbiL1Qx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbiL1Qwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:52:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB35E1DDED
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:47:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46233B816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B798C433D2;
        Wed, 28 Dec 2022 16:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246041;
        bh=SsZLdHxV3v0ozemZuINALEFC99IXb8xrVlBR4IvXihw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrwqo+hgf6NIHuJyJIhRLSk/aVTU1+7SxiOvv/Hx5PkZGHy+zCw/wGDPJI5x4xyCZ
         pZ7ypDR2vOSbFAFAuJB71N8WmZOEEnvqCICDBq9MOp9++kZ5QQP8pS47/XivyZRH5K
         ist6pYX2OVMUIOq9xGbwJ9CMNWB04iR8z0/T9oVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0962/1146] btrfs: do not panic if we cant allocate a prealloc extent state
Date:   Wed, 28 Dec 2022 15:41:41 +0100
Message-Id: <20221228144356.449916844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 5a75034e71ef5ec0fce983afcb6c9cb0147cd5b9 ]

We sometimes have to allocate new extent states when clearing or setting
new bits in an extent io tree.  Generally we preallocate this before
taking the tree spin lock, but we can use this preallocated extent state
sometimes and then need to try to do a GFP_ATOMIC allocation under the
lock.

Unfortunately sometimes this fails, and then we hit the BUG_ON() and
bring the box down.  This happens roughly 20 times a week in our fleet.

However the vast majority of callers use GFP_NOFS, which means that if
this GFP_ATOMIC allocation fails, we could simply drop the spin lock, go
back and allocate a new extent state with our given gfp mask, and begin
again from where we left off.

For the remaining callers that do not use GFP_NOFS, they are generally
using GFP_NOWAIT, which still allows for some reclaim.  So allow these
allocations to attempt to happen outside of the spin lock so we don't
need to rely on GFP_ATOMIC allocations.

This in essence creates an infinite loop for anything that isn't
GFP_NOFS.  To address this we may want to migrate to using mempools for
extent states so that we will always have emergency reserves in order to
make our allocations.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent-io-tree.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 83cb0378096f..3676580c2d97 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -572,7 +572,7 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	if (bits & (EXTENT_LOCKED | EXTENT_BOUNDARY))
 		clear = 1;
 again:
-	if (!prealloc && gfpflags_allow_blocking(mask)) {
+	if (!prealloc) {
 		/*
 		 * Don't care for allocation failure here because we might end
 		 * up not needing the pre-allocated extent state at all, which
@@ -636,7 +636,8 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 
 	if (state->start < start) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			goto search_again;
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -657,7 +658,8 @@ int __clear_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	 */
 	if (state->start <= end && state->end > end) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			goto search_again;
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -966,7 +968,7 @@ static int __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	else
 		ASSERT(failed_start == NULL);
 again:
-	if (!prealloc && gfpflags_allow_blocking(mask)) {
+	if (!prealloc) {
 		/*
 		 * Don't care for allocation failure here because we might end
 		 * up not needing the pre-allocated extent state at all, which
@@ -991,7 +993,8 @@ static int __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 	state = tree_search_for_insert(tree, start, &p, &parent);
 	if (!state) {
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			goto search_again;
 		prealloc->start = start;
 		prealloc->end = end;
 		insert_state_fast(tree, prealloc, p, parent, bits, changeset);
@@ -1062,7 +1065,8 @@ static int __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		}
 
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			goto search_again;
 		err = split_state(tree, state, prealloc, start);
 		if (err)
 			extent_io_tree_panic(tree, err);
@@ -1099,7 +1103,8 @@ static int __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 			this_end = last_start - 1;
 
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			goto search_again;
 
 		/*
 		 * Avoid to free 'prealloc' if it can be merged with the later
@@ -1130,7 +1135,8 @@ static int __set_extent_bit(struct extent_io_tree *tree, u64 start, u64 end,
 		}
 
 		prealloc = alloc_extent_state_atomic(prealloc);
-		BUG_ON(!prealloc);
+		if (!prealloc)
+			goto search_again;
 		err = split_state(tree, state, prealloc, end + 1);
 		if (err)
 			extent_io_tree_panic(tree, err);
-- 
2.35.1



