Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCA54A44A
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 04:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351448AbiFNCFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 22:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351010AbiFNCFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 22:05:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AAFC340FD;
        Mon, 13 Jun 2022 19:05:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D9EB81699;
        Tue, 14 Jun 2022 02:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA87C341C0;
        Tue, 14 Jun 2022 02:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655172311;
        bh=GNVhN8oxEYeMg60d7RL3ZFYRy4UDTM6B8Kb1KDFy4so=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0Pkfhvrab4dSqeltSceWI10HA6212VbwxeyJ7FFqOliiiP8+6W02dLizQuH8c+ok
         u3pBgpUt46Bc7Sh5OwrPxkyVv9aRzIVj5q3CPe7oNUL5rWZddCj7oEmh10M5RhsRs0
         p4eu0g4Lsm6wi8FCJd6GlZQsPwiq0571y896Zwlc9Fcql7/Er5Y432KRiGCqz5rznK
         j9bFVdQIyUzspLgfLu63qNKWpjhsawF7ArmHNTRjlb959Ny6HiKeejD6urTc7WmVL6
         6ve9/ZzqgNNzqIDWvTNYZ7AtKFBDk/0gj52rM1Z5tQDrIro8gX2ixFKwS8M65Ht8tl
         yjcXKRrXSFPlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jack@suse.com
Subject: [PATCH AUTOSEL 5.18 17/47] quota: Prevent memory allocation recursion while holding dq_lock
Date:   Mon, 13 Jun 2022 22:04:10 -0400
Message-Id: <20220614020441.1098348-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220614020441.1098348-1-sashal@kernel.org>
References: <20220614020441.1098348-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 537e11cdc7a6b3ce94fa25ed41306193df9677b7 ]

As described in commit 02117b8ae9c0 ("f2fs: Set GF_NOFS in
read_cache_page_gfp while doing f2fs_quota_read"), we must not enter
filesystem reclaim while holding the dq_lock.  Prevent this more generally
by using memalloc_nofs_save() while holding the lock.

Link: https://lore.kernel.org/r/20220605143815.2330891-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/dquot.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a74aef99bd3d..09d1307959d0 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -79,6 +79,7 @@
 #include <linux/capability.h>
 #include <linux/quotaops.h>
 #include <linux/blkdev.h>
+#include <linux/sched/mm.h>
 #include "../internal.h" /* ugh */
 
 #include <linux/uaccess.h>
@@ -425,9 +426,11 @@ EXPORT_SYMBOL(mark_info_dirty);
 int dquot_acquire(struct dquot *dquot)
 {
 	int ret = 0, ret2 = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	if (!test_bit(DQ_READ_B, &dquot->dq_flags)) {
 		ret = dqopt->ops[dquot->dq_id.type]->read_dqblk(dquot);
 		if (ret < 0)
@@ -458,6 +461,7 @@ int dquot_acquire(struct dquot *dquot)
 	smp_mb__before_atomic();
 	set_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_iolock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
@@ -469,9 +473,11 @@ EXPORT_SYMBOL(dquot_acquire);
 int dquot_commit(struct dquot *dquot)
 {
 	int ret = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	if (!clear_dquot_dirty(dquot))
 		goto out_lock;
 	/* Inactive dquot can be only if there was error during read/init
@@ -481,6 +487,7 @@ int dquot_commit(struct dquot *dquot)
 	else
 		ret = -EIO;
 out_lock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
@@ -492,9 +499,11 @@ EXPORT_SYMBOL(dquot_commit);
 int dquot_release(struct dquot *dquot)
 {
 	int ret = 0, ret2 = 0;
+	unsigned int memalloc;
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 
 	mutex_lock(&dquot->dq_lock);
+	memalloc = memalloc_nofs_save();
 	/* Check whether we are not racing with some other dqget() */
 	if (dquot_is_busy(dquot))
 		goto out_dqlock;
@@ -510,6 +519,7 @@ int dquot_release(struct dquot *dquot)
 	}
 	clear_bit(DQ_ACTIVE_B, &dquot->dq_flags);
 out_dqlock:
+	memalloc_nofs_restore(memalloc);
 	mutex_unlock(&dquot->dq_lock);
 	return ret;
 }
-- 
2.35.1

