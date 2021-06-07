Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5038F39E398
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbhFGQ1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:27:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:33392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233470AbhFGQXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:23:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 751F861935;
        Mon,  7 Jun 2021 16:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082533;
        bh=x2c4b1/n9pTYYdcPDTBCvUOkjOIDOUolY33xlgn3Wuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJwBmtummHxJoYLwvpxbt1qiPyWfLu32ExGj0OXj8zmTttX+LuiaeHOMkho6wTvOj
         vZkSxnu14O3YQFgUNj7mHXKYAgZM5p439uKsjSbtRa0rpY1d2KqbVjKYr8IFZKOhxe
         LschzMeIQs0CL4bPJIkj5fLXvdHlewtYqKlf58m3ib10uFDvN53SE/eADEURxs37Vs
         ONQAvGOQuAMtrWJKHK9MUzuPUhinBkwSqSG4JJHKweVxLzAJNYiu0oivLa7/0+H3yu
         y7kofB9yMthDDFDWynFQU/t988nhMmTuY8P6yWn4k4OwqBizMn1IBSYwPGvscR6d9U
         JzdxMUX6fEjGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 11/18] nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
Date:   Mon,  7 Jun 2021 12:15:09 -0400
Message-Id: <20210607161517.3584577-11-sashal@kernel.org>
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
index 3388d2788fe0..5f33c3a9469b 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -322,6 +322,7 @@ static void nvme_loop_destroy_io_queues(struct nvme_loop_ctrl *ctrl)
 		clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[i].flags);
 		nvmet_sq_destroy(&ctrl->queues[i].nvme_sq);
 	}
+	ctrl->ctrl.queue_count = 1;
 }
 
 static int nvme_loop_init_io_queues(struct nvme_loop_ctrl *ctrl)
-- 
2.30.2

