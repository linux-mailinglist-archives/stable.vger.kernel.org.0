Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84A023783D8
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232461AbhEJKrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233290AbhEJKpf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21B7B61991;
        Mon, 10 May 2021 10:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642939;
        bh=rlXmFOD0y2mNjZoH0cAdD4CXpr/t0xyYl2OHjmqDCC8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vL3+UqZCnPqEcPZbTJJ8dWQfbCJqGquupUnxE5VAdfzkkwDwd+1KWrV0IB4oJgvxw
         9DYFoLP4ha4EPjAepBK4NArTk0QxmgnTvVqQ+sZaVSRQN3Gn8OpaVBFJ5Ugtl2np0V
         WqBzZfCO5kYMpcOSwPOzekZn/75rdx/E7KGvtetw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/299] btrfs: convert logic BUG_ON()s in replace_path to ASSERT()s
Date:   Mon, 10 May 2021 12:18:29 +0200
Message-Id: <20210510102008.655805899@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b3368cfccabf..c21545c5b34b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1205,8 +1205,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 	int ret;
 	int slot;
 
-	BUG_ON(src->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(dest->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(src->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(dest->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	last_snapshot = btrfs_root_last_snapshot(&src->root_item);
 again:
@@ -1241,7 +1241,7 @@ again:
 		struct btrfs_key first_key;
 
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, &slot);
 		if (ret < 0)
-- 
2.30.2



