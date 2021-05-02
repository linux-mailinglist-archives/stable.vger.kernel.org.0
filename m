Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69978370CF0
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233889AbhEBOIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233178AbhEBOHT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2AC2614A7;
        Sun,  2 May 2021 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964365;
        bh=/4OKuc2h/XwrurRmvCYHqa216Pl+UMPBlgZzmVDIm0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lb+Fhk/XOIc5mDU6dYRHXlyNrofk0ojqt5bdiVuEYqujgmxonWxJIWqyrbkJAa/dF
         c/M81eqULKJkKzRR83dlUksYDE0xEeQex3DGknwV27mc6+35HluEoXp0tDV4ose5eL
         9n6vazgYzII5dTLlRCh7c4sGK+475EtZ8+SHZvHRP7S4NYLCW9TBATFGSL3HH/wwLw
         HI7LKdFotlLM+X+HDFU2Kp+/a6gPTtCb9XyX+jzDVS0R+G36oA0LqGZ0fAVT5Kb4Cz
         Rd+OEI7cN62gMQ9dXZqxa7AGtmD6RmlsczHliE/nupfjXOdGRWKhkW3wf3mQr/HNWO
         1KgIOuFLTJHDg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 16/16] btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s
Date:   Sun,  2 May 2021 10:05:44 -0400
Message-Id: <20210502140544.2720138-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140544.2720138-1-sashal@kernel.org>
References: <20210502140544.2720138-1-sashal@kernel.org>
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
index c01239d1f1e6..313547442a6e 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1808,8 +1808,8 @@ int replace_path(struct btrfs_trans_handle *trans,
 	int ret;
 	int slot;
 
-	BUG_ON(src->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(dest->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(src->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(dest->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	last_snapshot = btrfs_root_last_snapshot(&src->root_item);
 again:
@@ -1841,7 +1841,7 @@ int replace_path(struct btrfs_trans_handle *trans,
 	parent = eb;
 	while (1) {
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, level, &slot);
 		if (ret && slot > 0)
-- 
2.30.2

