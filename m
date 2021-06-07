Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EFA39E392
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhFGQ1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233473AbhFGQXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BAAB6192A;
        Mon,  7 Jun 2021 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082535;
        bh=KHivZezR9oMQs9gSBQACCCzHXGLWeaXo5az7edNEM6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gip1zh7V9+UO5YT7oeniyNKH7tN7iE82MNHWa+89zBgzH/UXdFyWZVSQ845E5XU+9
         Pi4T+R2hzu/jXCO7RW4IH++f3mTXN5naAHObLeRNgKdXQicH3/TpkTxlfZiulK5148
         AYjy0Pg/yjqBFFByzCChO+abCnsX8Z3jrgsukE1Rv9yhlHpJaoWKngW4lOc0xYq1EL
         BV9IeIMkbhXQfcTegK6C+IvXVSJg0fEG0C45+HUiAJKSe0tFbkB4CSfbbxTiYZBa5G
         Cmy1IufviPSSkWEmpxkyDC0R5qpeUhVnhMAiLabsb06RPKWqU2AjX6QndqKa6i+CZs
         JlHh4uQmf/3XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 13/18] nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()
Date:   Mon,  7 Jun 2021 12:15:11 -0400
Message-Id: <20210607161517.3584577-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161517.3584577-1-sashal@kernel.org>
References: <20210607161517.3584577-1-sashal@kernel.org>
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

