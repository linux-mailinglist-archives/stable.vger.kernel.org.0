Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6C039E363
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhFGQXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:23:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:33404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233039AbhFGQVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B1FD6186A;
        Mon,  7 Jun 2021 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082509;
        bh=0kW4LCoGznNzXqduOXjRaq8hiTvCc8gYT1K4vZYcHSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohg9xqINQ+W8S5kxokGLbmwcw4wj50ChTfJcagLV+tzqgAtiVHEY/Es4dNfmb4TCx
         aE02ZPHnkmJZN7yaN9HGpHM2Flw3UI1nWWVCaeU6SijcONNHUIfxqrRH9XYmqMLBBf
         WPb1DmVFs9KJNtu08J5CyqYYu1x3psgTeVHnmNqIIFs9eukY0esoUSqgyzs5NeX5ND
         G+BM/UmyG7DVZQ9UseY+lFnA1DXgKSpLrTWsh5XHUJxGt5c+trDAoqsCkF2/Ik0L04
         m1VZH3VIdRz+v0pvQW4WdnMrivW7wKKdLR0MLVQy5lrm0Z4tdWaChF39e73aDurTBp
         BFs5UuNwwhRvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 16/21] nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()
Date:   Mon,  7 Jun 2021 12:14:43 -0400
Message-Id: <20210607161448.3584332-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161448.3584332-1-sashal@kernel.org>
References: <20210607161448.3584332-1-sashal@kernel.org>
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
index dba0b0145f48..08b52f3ed0c3 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -274,7 +274,8 @@ static const struct blk_mq_ops nvme_loop_admin_mq_ops = {
 
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

