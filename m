Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0787A3785E5
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhEJLCX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234722AbhEJK4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99FDD61C28;
        Mon, 10 May 2021 10:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643715;
        bh=Bi4AUe/NOMETypyFJ+dhWbsxha3tEgPZJ+RfZ5dLWbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Spzq9GIreox+99py3otr6gHkQzkD2HwHPpPwazvfK8PUNPcqRkPjwOIQ1MHU+L8ke
         bkoIMFgAqWDYKoEIZHh4PMBrQrT8X7h3snIc4HvQ7EvrtLeKktXqE0Ihy9H71Sz6BM
         0c98x0E6pqi2JizwsI8x2M4TyQbmBy4go9qAx290=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 127/342] btrfs: convert logic BUG_ON()s in replace_path to ASSERT()s
Date:   Mon, 10 May 2021 12:18:37 +0200
Message-Id: <20210510102014.276378446@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
index 73dcfe6e18f2..efe3ce88b8ef 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1204,8 +1204,8 @@ int replace_path(struct btrfs_trans_handle *trans, struct reloc_control *rc,
 	int ret;
 	int slot;
 
-	BUG_ON(src->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
-	BUG_ON(dest->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(src->root_key.objectid == BTRFS_TREE_RELOC_OBJECTID);
+	ASSERT(dest->root_key.objectid != BTRFS_TREE_RELOC_OBJECTID);
 
 	last_snapshot = btrfs_root_last_snapshot(&src->root_item);
 again:
@@ -1236,7 +1236,7 @@ again:
 	parent = eb;
 	while (1) {
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, &slot);
 		if (ret < 0)
-- 
2.30.2



