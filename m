Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED8F32F3163
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbhALNSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 08:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389252AbhALM5A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:57:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7927123122;
        Tue, 12 Jan 2021 12:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456148;
        bh=VYWZicGH8KHt/BiWVit0kZO3W1ceCcEV61jX9iqJXCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2fCJU4bCu420l3Ww+oBjr4to0BlEaIT7Yyzl1J5hJEnf6tc5Wf1EUXn6AHksea3K
         JOieB3xxELAe/klP17R0024RQa5XP/JQj3iyTh4OXXZknMZYCyNYuizv4EJr1DlhhF
         NaTCn5dHRhPRJOZgu15P5fCQCujBSIeH1tuKvJyC1fs8P1njx0CeR+6SNCqsxX0hPw
         rgrFpuZ57/wtvyBJrZCBbwk8oa2XZucg3AAoqbsn96aQxVtFF4b/bXRBHJQdJzeTO5
         k/Cg8yPvGd+woBZW2EbY8htyt4TS6iD68YYPaOCsfsXkGgMvcyx+MJLawCzHTTEeyV
         wjMw4gTNdtfSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>, linux-btrfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/51] btrfs: fix async discard stall
Date:   Tue, 12 Jan 2021 07:54:52 -0500
Message-Id: <20210112125534.70280-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125534.70280-1-sashal@kernel.org>
References: <20210112125534.70280-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit ea9ed87c73e87e044b2c58d658eb4ba5216bc488 ]

Might happen that bg->discard_eligible_time was changed without
rescheduling, so btrfs_discard_workfn() wakes up earlier than that new
time, peek_discard_list() returns NULL, and all work halts and goes to
sleep without further rescheduling even there are block groups to
discard.

It happens pretty often, but not so visible from the userspace because
after some time it usually will be kicked off anyway by someone else
calling btrfs_discard_reschedule_work().

Fix it by continue rescheduling if block group discard lists are not
empty.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/discard.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index 741c7e19c32f2..d1a5380e8827d 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -199,16 +199,15 @@ static struct btrfs_block_group *find_next_block_group(
 static struct btrfs_block_group *peek_discard_list(
 					struct btrfs_discard_ctl *discard_ctl,
 					enum btrfs_discard_state *discard_state,
-					int *discard_index)
+					int *discard_index, u64 now)
 {
 	struct btrfs_block_group *block_group;
-	const u64 now = ktime_get_ns();
 
 	spin_lock(&discard_ctl->lock);
 again:
 	block_group = find_next_block_group(discard_ctl, now);
 
-	if (block_group && now > block_group->discard_eligible_time) {
+	if (block_group && now >= block_group->discard_eligible_time) {
 		if (block_group->discard_index == BTRFS_DISCARD_INDEX_UNUSED &&
 		    block_group->used != 0) {
 			if (btrfs_is_block_group_data_only(block_group))
@@ -222,12 +221,11 @@ static struct btrfs_block_group *peek_discard_list(
 			block_group->discard_state = BTRFS_DISCARD_EXTENTS;
 		}
 		discard_ctl->block_group = block_group;
+	}
+	if (block_group) {
 		*discard_state = block_group->discard_state;
 		*discard_index = block_group->discard_index;
-	} else {
-		block_group = NULL;
 	}
-
 	spin_unlock(&discard_ctl->lock);
 
 	return block_group;
@@ -429,13 +427,18 @@ static void btrfs_discard_workfn(struct work_struct *work)
 	int discard_index = 0;
 	u64 trimmed = 0;
 	u64 minlen = 0;
+	u64 now = ktime_get_ns();
 
 	discard_ctl = container_of(work, struct btrfs_discard_ctl, work.work);
 
 	block_group = peek_discard_list(discard_ctl, &discard_state,
-					&discard_index);
+					&discard_index, now);
 	if (!block_group || !btrfs_run_discard_work(discard_ctl))
 		return;
+	if (now < block_group->discard_eligible_time) {
+		btrfs_discard_schedule_work(discard_ctl, false);
+		return;
+	}
 
 	/* Perform discarding */
 	minlen = discard_minlen[discard_index];
-- 
2.27.0

