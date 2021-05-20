Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A47738A83C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbhETKsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:48:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:46552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237788AbhETKqN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:46:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06A8F61628;
        Thu, 20 May 2021 09:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504668;
        bh=vw9bmeJyvGs2tTVz99pCPUZL3362gfhABXPXfJqqy9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0dwF96KAnOi9X052t+3RjD8TW4W0Ohxpm1pfhB3J1RSd+CXDBZmQIa0FzglQHC+N
         i9cJOVcqm4SaM2GKp604mNY74VDjGoWF2o0T1hkqR4URy4E5VzaM9PT5P+FhZQN1mw
         lWlqVHV1EmqdClt5r9Jy4t2xBKC4YH8cVsVNmL7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 026/240] btrfs: convert logic BUG_ON()s in replace_path to ASSERT()s
Date:   Thu, 20 May 2021 11:20:18 +0200
Message-Id: <20210520092109.519069535@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
@@ -1834,7 +1834,7 @@ again:
 	parent = eb;
 	while (1) {
 		level = btrfs_header_level(parent);
-		BUG_ON(level < lowest_level);
+		ASSERT(level >= lowest_level);
 
 		ret = btrfs_bin_search(parent, &key, level, &slot);
 		if (ret && slot > 0)
-- 
2.30.2



