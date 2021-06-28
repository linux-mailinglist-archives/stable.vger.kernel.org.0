Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1F03B62F1
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235200AbhF1Ou2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235259AbhF1OsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DCB261CAE;
        Mon, 28 Jun 2021 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624891001;
        bh=KHivZezR9oMQs9gSBQACCCzHXGLWeaXo5az7edNEM6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YhrOhd988U/TvJrI1z8APaSCah05ecXyouDFAv0EQh2+sbj5xIxAJ2pYr5kF4uj+I
         Lyf84KhQF8bi24/r9hPQN1OLWLAAxbNpw5hLGfULYDtQttOsQ5K6xCwNAZMqkx7w+D
         f4zBIPwCc5s9YbFT9Cf+p9yE1R1FgzKFvc1uSVlwnqLlKkSZ9+7u/E+QAEp5PKHkmG
         XsxiVYwZ253Fbc0FiQu8czY5HbIThdKTfJyrw1OZa+5J+bWBL/+a/iP0zU73lw5yS3
         KuR3bNOJqLpSgzYdP9jGJwXdTkgyYPKp/eZyDYFILNEPaQ5C7bQcTWx7E2saEF6o+9
         /iM+hLAj5TY7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/88] nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()
Date:   Mon, 28 Jun 2021 10:35:12 -0400
Message-Id: <20210628143628.33342-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628143628.33342-1-sashal@kernel.org>
References: <20210628143628.33342-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.238-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.238-rc1
X-KernelTest-Deadline: 2021-06-30T14:36+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 4237de2f73a669e4f89ac0aa2b44fb1a1d9ec583 ]

We need to check the NVME_LOOP_Q_LIVE flag in
nvme_loop_destroy_admin_queue() to protect against duplicate
invocations eg during concurrent reset and remove calls.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 963d8de932d1..7a0a10777cd1 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -287,7 +287,8 @@ static const struct blk_mq_ops nvme_loop_admin_mq_ops = {
 
 static void nvme_loop_destroy_admin_queue(struct nvme_loop_ctrl *ctrl)
 {
-	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
+	if (!test_and_clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags))
+		return;
 	nvmet_sq_destroy(&ctrl->queues[0].nvme_sq);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 	blk_mq_free_tag_set(&ctrl->admin_tag_set);
-- 
2.30.2

