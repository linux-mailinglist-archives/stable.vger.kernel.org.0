Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB7739E368
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhFGQXn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233033AbhFGQVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:21:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 389A96191A;
        Mon,  7 Jun 2021 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082507;
        bh=PUeCQeC7eBDqGD423o8fbfSxwIRBRYeDk7wm/SM+HG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XktYSR25yx0418OyMIxbf80h6PsMjF+QAy+Bq9kof/7RWIWbbzM4UxcwzcZEumuox
         yh+k5QyyZuUHWRIUcvbmu0ys+4FA8BV/YLEFuMGYkcuRpWQ7oBK+Vowemk001oI7Wc
         7iJIMR0oJnSyraoKTYwtYu3BViMlWHCnfjDU/NpYR4l2po4UfWhL/pGfdDIgAoLLA5
         Y2+Hf2An6j/qk042MMUehh3YS218yQigOA6RX2lgpLVZhB7RZAUEfYi0oMe4LYIU2P
         BqA1SrKtNOBFDKU/6bCrAka9oPbwm/qLFuGMAUhudXGXw58+Cezr+0aAnSPQIeZod0
         eeM1JWT8WnQWg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 14/21] nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
Date:   Mon,  7 Jun 2021 12:14:41 -0400
Message-Id: <20210607161448.3584332-14-sashal@kernel.org>
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
index 137a27fa369c..7b6e44ed299a 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -309,6 +309,7 @@ static void nvme_loop_destroy_io_queues(struct nvme_loop_ctrl *ctrl)
 		clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[i].flags);
 		nvmet_sq_destroy(&ctrl->queues[i].nvme_sq);
 	}
+	ctrl->ctrl.queue_count = 1;
 }
 
 static int nvme_loop_init_io_queues(struct nvme_loop_ctrl *ctrl)
-- 
2.30.2

