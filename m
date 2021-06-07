Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64AF139E321
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhFGQVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:21:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232556AbhFGQTc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:19:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B69D061623;
        Mon,  7 Jun 2021 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082478;
        bh=F1f9BPH9FyVoFFq5kkKgFr6EFrJQ0itBt5/Ly+P/4xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P5VEI8XEdWHwvIgPJP08r5z1yPtB4glAIAhABUZ4vY1gmPkQIF3MWa/INOVxDxinN
         6I09i2OLMJqMsvGuOBYLpbHwxhT0XlmC/FxbhglaJJvkVZR01h8PClTA+i27InHOq2
         PpZQeYUVDRUADfW0QAmNCbRa7kIMyirtPcEnwYt5F7S4LsXbe6NzvtkVAvhnBQpktq
         dXjqcvTjTNKEYpcZqIRsreTwNDMs/qsPtgym3h4P+P09gyJnnhBztfsHjVwOP+y5Ch
         hex/J+DHmDw4AjhaXQduH3S1GBbEwSqAIQobL0/6aBt6QFbq4I7prS8itC8Jjh6g5L
         Iq3aehuAAalPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 22/29] nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()
Date:   Mon,  7 Jun 2021 12:14:03 -0400
Message-Id: <20210607161410.3584036-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161410.3584036-1-sashal@kernel.org>
References: <20210607161410.3584036-1-sashal@kernel.org>
MIME-Version: 1.0
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
index f752e9432676..f657a12bf1fe 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -252,7 +252,8 @@ static const struct blk_mq_ops nvme_loop_admin_mq_ops = {
 
 static void nvme_loop_destroy_admin_queue(struct nvme_loop_ctrl *ctrl)
 {
-	clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags);
+	if (!test_and_clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[0].flags))
+		return;
 	nvmet_sq_destroy(&ctrl->queues[0].nvme_sq);
 	blk_cleanup_queue(ctrl->ctrl.admin_q);
 	blk_cleanup_queue(ctrl->ctrl.fabrics_q);
-- 
2.30.2

