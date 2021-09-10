Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B458A4061E6
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhIJAoJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:44:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233427AbhIJATw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:19:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DDE8610A3;
        Fri, 10 Sep 2021 00:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233122;
        bh=0GSy/z9oteAShp89i8clV0SqHqaWt0d0zxQWpkUyeRU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y8QOo/BNNrDPok9TzEFO+1ouNmdf3TYbqhu/XwvYdr8n2BaHxJVkbmBFOWQlQmjNY
         Igm5mnnrNQ+o49EFUXiK8YeiWZlbKCBbyRxe1E03LnoLTeoelO0cgPq5nAvjqOlenq
         gVAFgrcTDXijCEj7f+F4Mh2SwEIXNFd49E95Qjc1lUa0lM8uTd/+YTdTh1Ad6I6rnP
         jptCwtx7ei4jRlAk31K1WDTkdj1RjHJqWVJz37hLe8W4n4DYmPf+3i/WACoxzh2gee
         fwd8oIdpofoFt71ktkK4BIcbHxCqgR+L3963dfApkAKutkDsT6ZUSAqwBn853QLQTO
         zJP3d3jQW8baA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Daeho Jeong <daehojeong@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.13 15/88] f2fs: don't sleep while grabing nat_tree_lock
Date:   Thu,  9 Sep 2021 20:17:07 -0400
Message-Id: <20210910001820.174272-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 2eeb0dce728a7eac3e4dfe355d98af40d61f7a26 ]

This tries to fix priority inversion in the below condition resulting in
long checkpoint delay.

f2fs_get_node_info()
 - nat_tree_lock
  -> sleep to grab journal_rwsem by contention

                                     checkpoint
                                     - waiting for nat_tree_lock

In order to let checkpoint go, let's release nat_tree_lock, if there's a
journal_rwsem contention.

Signed-off-by: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e67ce5f13b98..b731d7ff455c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -538,7 +538,7 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 	int i;
 
 	ni->nid = nid;
-
+retry:
 	/* Check nat cache */
 	down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, nid);
@@ -550,10 +550,19 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 		return 0;
 	}
 
-	memset(&ne, 0, sizeof(struct f2fs_nat_entry));
+	/*
+	 * Check current segment summary by trying to grab journal_rwsem first.
+	 * This sem is on the critical path on the checkpoint requiring the above
+	 * nat_tree_lock. Therefore, we should retry, if we failed to grab here
+	 * while not bothering checkpoint.
+	 */
+	if (!rwsem_is_locked(&sbi->cp_global_sem)) {
+		down_read(&curseg->journal_rwsem);
+	} else if (!down_read_trylock(&curseg->journal_rwsem)) {
+		up_read(&nm_i->nat_tree_lock);
+		goto retry;
+	}
 
-	/* Check current segment summary */
-	down_read(&curseg->journal_rwsem);
 	i = f2fs_lookup_journal_in_cursum(journal, NAT_JOURNAL, nid, 0);
 	if (i >= 0) {
 		ne = nat_in_journal(journal, i);
-- 
2.30.2

