Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1E370D0D
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhEBOIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:50118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233823AbhEBOH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6721C613B0;
        Sun,  2 May 2021 14:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964382;
        bh=VRyj2C4fw0+764fRhWcRU66cC58F8EgHyHp56UeQyrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L1xrMxtCeJgnjzixYNzwk5BuSW1eQ/BJlV0Xip9SH6nd4R1a9DOiKz1X5oAAxKZUu
         O1QdGaxbyd3uWuF592dYQypyrxYzbC4ugJ1GkpQg8zfcHLj07sFCS2XU9LBFuAtCuB
         7ehiMpxrsVMVuAvngS05r3KAWxKAwAPMwRxfb905ns6cCQzpfruVYowkvvundW52/s
         bxbLPZ210Dy1wE0kon1diB+IawSC5NlJ6AqCFi+wLii6qnNfT/TtOJJV5YSObn1edz
         jakg3P9HqlaK3HZfyBUQbl8klXedhs6l7iwi6qRpqZp5tWuOavDujLrQTk8TDzB3M3
         7RvHn01SZRunA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/12] btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s
Date:   Sun,  2 May 2021 10:06:06 -0400
Message-Id: <20210502140606.2720323-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140606.2720323-1-sashal@kernel.org>
References: <20210502140606.2720323-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 7a9213a93546e7eaef90e6e153af6b8fc7553f10 ]

A few BUG_ON()'s in replace_path are purely to keep us from making
logical mistakes, so replace them with ASSERT()'s.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index cd5b86d80e7a..5caf4dbdd801 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1801,8 +1801,8 @@ int replace_path(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-	BUG_ON(src->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(dest->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(src->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(dest->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	last_snapshot = btrfs_root_last_snapshot(&src->root_item);
 again:
@@ -1834,7 +1834,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 	parent = eb;
 	while (1) {
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, level, &slot);
 		if (ret && slot > 0)
-- 
2.30.2

