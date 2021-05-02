Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066BE370CC2
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhEBOHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233508AbhEBOGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 795AC61625;
        Sun,  2 May 2021 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964344;
        bh=kc0BmSC0uiozPnQOjQ7pg/HG3TZ10+xOGVWL27fT9Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6reyATuvEJB0fWPsTAYwD3dqSH1RJMIML9ofSTR1vT6xWEV6Xe7j5Xfs3qeJo4oj
         vZiJ1NPxaOivxFi3mMOAdwYe2JedkrMh+nhhDJR8fxqxn9JXYKUv+RFgLgOrHkJm3y
         Jj43Os6WLfhzHANB8s8CB+44KWxwoBVAHcuJ2IiwEpJthnowiA/V4XpGkjcaEbMCQX
         nyaVr50/fsC7k6sPOJdUMWTIfQuH6aTy8GB9wrx3OeI1WzLO4PzGOkfTGeQgw5Pm0I
         EEFEJj0E9ZcQAJwuwEi3p5n2HvLddQ2BzC12Kb7kfG34yYw7x59FWjXa63kQKOFrSd
         yaiH+bh1Recuw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/21] btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s
Date:   Sun,  2 May 2021 10:05:17 -0400
Message-Id: <20210502140517.2719912-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
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
index e6e4e6fb2add..06c6a66a991f 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1755,8 +1755,8 @@ int replace_path(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-	BUG_ON(src->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(dest->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(src->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(dest->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	last_snapshot = btrfs_root_last_snapshot(&src->root_item);
 again:
@@ -1790,7 +1790,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 		struct btrfs_key first_key;
 
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, level, &slot);
 		if (ret && slot > 0)
-- 
2.30.2

