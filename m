Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B1039E224
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhFGQPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:15:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231739AbhFGQOv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:14:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB5BB613DB;
        Mon,  7 Jun 2021 16:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082380;
        bh=45JLVJqfviyJdxA8LcjD9n3/BRyIxOebcdNmA3Perj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjUxzmN7NRUKuJ9OyghhIdOzKN1rlq5RBLqlSkqeqcS0AFfOPnv9soWduU6lKniqu
         B2fmU9q3xFTnZURuAZ1QdaMM605joFDsSwdRZPT22NcgdqEYmoJny9HbjNKxKBf3QH
         porDuwd4LOsuTO0tVNEGrp1Og4IYB3vLX66b+A67qM2Bod44ue7nu4A6Z8l4q/Unjg
         2PM3zuIsdksK9j/c9ddEV6dytYQn4reDliIptdDCdlPg3sgl6+TQnoaRP9F/L6FNQk
         ja5lIqwKqp1bqlirk/cj5DOvvn9PNQ7byMWCcUbse8X/YG0ge/7aXgiAsxR/sPgEig
         oLCHplNhuQWXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 36/49] nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
Date:   Mon,  7 Jun 2021 12:12:02 -0400
Message-Id: <20210607161215.3583176-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161215.3583176-1-sashal@kernel.org>
References: <20210607161215.3583176-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit a6c144f3d2e230f2b3ac5ed8c51e0f0391556197 ]

The queue count is increased in nvme_loop_init_io_queues(), so we
need to reset it to 1 at the end of nvme_loop_destroy_io_queues().
Otherwise the function is not re-entrant safe, and crash will happen
during concurrent reset and remove calls.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 14913a4588ec..4b2a6330feb5 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -297,6 +297,7 @@ static void nvme_loop_destroy_io_queues(struct nvme_loop_ctrl *ctrl)
 		clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[i].flags);
 		nvmet_sq_destroy(&ctrl->queues[i].nvme_sq);
 	}
+	ctrl->ctrl.queue_count = 1;
 }
 
 static int nvme_loop_init_io_queues(struct nvme_loop_ctrl *ctrl)
-- 
2.30.2

