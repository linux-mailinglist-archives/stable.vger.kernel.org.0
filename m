Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464624AFB3F
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240305AbiBISoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240543AbiBISnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:43:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B03C094C95;
        Wed,  9 Feb 2022 10:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30B1AB82385;
        Wed,  9 Feb 2022 18:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FB4C340E7;
        Wed,  9 Feb 2022 18:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644432146;
        bh=Vtv6KT5exuM3xReEC3QRHzlvCVnagmx6SAxc1y/h220=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JqLEIPqQRR04KqDz20fxNp8mSVLtWD8g0Wir1O1kNTxkSsOqdbHR42Nabq7YlDlPv
         0daq+oOm70s8N7WlaPw9wEc4qVYQwGYigxsevGgeOQpYSLQm6eZUrwJxT6bQOUZWqs
         0uqVNFYVLgUw3dqGbp3pVq2KqbtYvvW1CucEO32GplP4Nb8jd5Z0apMhtODRgCsZa+
         O0ehgQvbwiE8VD/b/tZUUYSX/THNTNdwf7G60yL7rcsfd6gNBcXz6e5mwfIax3JwYc
         5R65VTMpKxc9L/Jl+QhcP1XTFz4Dg4zBopfULEYOeU5wF9321UfhgNjXicRqL2D7TS
         U0afJaCZhcjWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Su Yue <l@damenly.su>, David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/27] btrfs: tree-checker: check item_size for dev_item
Date:   Wed,  9 Feb 2022 13:40:52 -0500
Message-Id: <20220209184103.47635-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209184103.47635-1-sashal@kernel.org>
References: <20220209184103.47635-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Su Yue <l@damenly.su>

[ Upstream commit ea1d1ca4025ac6c075709f549f9aa036b5b6597d ]

Check item size before accessing the device item to avoid out of bound
access, similar to inode_item check.

Signed-off-by: Su Yue <l@damenly.su>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index d4a3a56726aa8..4a5ee516845f7 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -947,6 +947,7 @@ static int check_dev_item(struct extent_buffer *leaf,
 			  struct btrfs_key *key, int slot)
 {
 	struct btrfs_dev_item *ditem;
+	const u32 item_size = btrfs_item_size(leaf, slot);
 
 	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
 		dev_item_err(leaf, slot,
@@ -954,6 +955,13 @@ static int check_dev_item(struct extent_buffer *leaf,
 			     key->objectid, BTRFS_DEV_ITEMS_OBJECTID);
 		return -EUCLEAN;
 	}
+
+	if (unlikely(item_size != sizeof(*ditem))) {
+		dev_item_err(leaf, slot, "invalid item size: has %u expect %zu",
+			     item_size, sizeof(*ditem));
+		return -EUCLEAN;
+	}
+
 	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
 	if (btrfs_device_id(leaf, ditem) != key->offset) {
 		dev_item_err(leaf, slot,
-- 
2.34.1

