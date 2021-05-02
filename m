Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C136F370D24
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232984AbhEBOIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:52016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233887AbhEBOID (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:08:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B538261026;
        Sun,  2 May 2021 14:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964396;
        bh=JEspZCQbFc9GEpc4rxMQn3XyrWaUCAPVV5A9ykTBGTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o5FKzBCFlBTQ4BKGY/CKspRCjYqBaTppX0Yjji2a+xKFb7o9mqJDp2vujaTv+SnCt
         fFMWg2Dk/cSwEQ4q5xn+MM0LuBvLOb1ZBjG7XYDH5OmhAiqeUvolOTligaUuMTJvNx
         vsm0LvYA+psgw+ZkQDEUU8dLdIwtTgOrM7Fe2jhvTPDq7Zpr46rjeu516LLYqvFVuN
         iJg9Xyr12RHAsW9lGwGJTR8jfKRe7JRztJoWp+98hjnL1cniPCw2gKWojUB+OA8GdS
         qMqpuUwOTcDu/mlaMY9Za2AY2B4yWd+aUPB957HF0YeuHE/hcCzdS86j7hZGdAOiFQ
         hE9dY7YwqpjNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 10/10] btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s
Date:   Sun,  2 May 2021 10:06:22 -0400
Message-Id: <20210502140623.2720479-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140623.2720479-1-sashal@kernel.org>
References: <20210502140623.2720479-1-sashal@kernel.org>
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
index 5681fc3976ad..628b6a046093 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1785,8 +1785,8 @@ int replace_path(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-	BUG_ON(src->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(dest->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(src->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(dest->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	last_snapshot = btrfs_root_last_snapshot(&src->root_item);
 again:
@@ -1818,7 +1818,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 	parent = eb;
 	while (1) {
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, level, &slot);
 		if (ret && slot > 0)
-- 
2.30.2

