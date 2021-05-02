Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DABC370C91
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbhEBOGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:06:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233304AbhEBOGJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D1CB613BB;
        Sun,  2 May 2021 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964316;
        bh=dkzwH/wVV0iqR8w1V17JL7gNCDwzVGoS76o93ETgnn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mH+wstVTrXE3LB7iAiwKrWOartDsUnG53vzAnNjaG2XXAKKKRSn/1vMZAxUYgn3nt
         Y6LSiMVIxz/J/gTjMSWx0EVWHIqVIjDifZqlAHyWi0g7DMdtjf7KfaPMuBJ04Zd3On
         CIFjLWLidn2QG6ysARq6rQ6SU2LSAH2DRAvSuT4U+fhxyRIJ23/eXArasb/LwI1oGR
         HveARJ0JGkdZArDVy3Jck/JGyp+Sm4Yojv9zPSYNFQl5Ju5ocFWznwoqTvAYgmbpeN
         18Jv0VP3/GeF0ugT7dMIJe71ZxO1bR/ARYiqtH6L0FL3f3C6GuVou19sNlB875Ez1I
         Z42DKz75OF7UQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 34/34] btrfs: convert logic BUG_ON()'s in replace_path to ASSERT()'s
Date:   Sun,  2 May 2021 10:04:34 -0400
Message-Id: <20210502140434.2719553-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140434.2719553-1-sashal@kernel.org>
References: <20210502140434.2719553-1-sashal@kernel.org>
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
index 68b5d7c4aa49..ba68b0b41dff 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1836,8 +1836,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 	int ret;
 	int slot;
 
-	BUG_ON(src->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(dest->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(src->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(dest->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	last_snapshot = btrfs_root_last_snapshot(&src->root_item);
 again:
@@ -1871,7 +1871,7 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 		struct btrfs_key first_key;
 
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, level, &slot);
 		if (ret < 0)
-- 
2.30.2

