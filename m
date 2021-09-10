Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C08406098
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhIJASD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229980AbhIJARf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:17:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D21611C4;
        Fri, 10 Sep 2021 00:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631232984;
        bh=VaBm2al3Cu8b16XZ/MgCLZBRF+tZW045Gp6rlB+4fMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xt25bApc8tH7bS9kgLJRILqMk9JnqJL/j4UELNNao+qSAoxFH9wiOHhAFJu7tXIUG
         C9swJCtFdxuc9NyNV2krjdEfrqqCvk8pBmAXjbpSGEWSBbEyNGnmisOAoLjqO9zyWX
         GqWJ/hXt884g0Qxh4qv6UfBr76/TO3zGW45/Pef5cB8KkbiIvHYj6zEYjPjd3XZEk+
         HfHBUhyzrYxRfGe/PktHaNAoymbNmfwxGsUnzzNuZaNgY9yBH2g7W8ZGlI7pMx2tfw
         ZX26lkgiSbnksKzzh0GxwTLHJCc33wP2/tFNBd3Bz5b9zwNAThUD/Wgjaz+C9kBIMw
         JdlmVEsMkC5bg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Daeho Jeong <daehojeong@google.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.14 19/99] f2fs: don't sleep while grabing nat_tree_lock
Date:   Thu,  9 Sep 2021 20:14:38 -0400
Message-Id: <20210910001558.173296-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001558.173296-1-sashal@kernel.org>
References: <20210910001558.173296-1-sashal@kernel.org>
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
index 0be9e2d7120e..c945a9730f3c 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -552,7 +552,7 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
 	int i;
 
 	ni->nid = nid;
-
+retry:
 	/* Check nat cache */
 	down_read(&nm_i->nat_tree_lock);
 	e = __lookup_nat_cache(nm_i, nid);
@@ -564,10 +564,19 @@ int f2fs_get_node_info(struct f2fs_sb_info *sbi, nid_t nid,
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

