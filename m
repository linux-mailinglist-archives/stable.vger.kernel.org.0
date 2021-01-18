Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574132FA39C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404890AbhAROb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390367AbhARLnJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:43:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 486FD22227;
        Mon, 18 Jan 2021 11:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970165;
        bh=SW8pekvyeoZLTf4z4Px0rpMAaFdnyZ0SHKFlEoYSM0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nnnNn+RMdQ4Wq/TKK4+BTDuekM7i+XWLUtfE240xsbI7YyXLuH51ggiPcOMU5CAId
         63+jjpop3zXgRoKsnU8VD7pDTnlmn14Hok/WFQVHOERNeysHhsLnqn/IKUXoUYaBHs
         RGHhvAJ7KSDxGtzVwh5FIwIuwi5w1RXuKhlgMnm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        David Sterba <dsterba@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 063/152] btrfs: fix async discard stall
Date:   Mon, 18 Jan 2021 12:33:58 +0100
Message-Id: <20210118113355.813131517@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -222,12 +221,11 @@ again:
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



