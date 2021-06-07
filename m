Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EAF39E294
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbhFGQRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:17:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232296AbhFGQQM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:16:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5090361417;
        Mon,  7 Jun 2021 16:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082432;
        bh=x1MZ4T89cpK8WojkI5GTgel4Y/xWbJa32tpk/siI8tI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CjfQvFH9sa1aAavj2lXbshNGm+djsQzOlGiMHk7kSpZ5RPIYn88zsneVTiqriGPv9
         zC+6lQ78OtTHRsB/cDkbcUj3pnON+u6ziTCIINdQQH8q7Ju7T8DbKkxzYIEjlPNDIQ
         48gMeNWcLjyGCE4diewV0ZTvCcmO5GenB7A1bsskFHrvd/IKQ6DnqJ6vsqRa+7yOg4
         HDOmTYM9ISxk2bsIoVZIwPRfrzmBe8Dw/AcQ/iyvW1LAaSZrRt415cDKg5Fav7Ir3d
         /hzepQLVaHcRpsm66gJF5R2YhTGBih+uwF1QsUc0u8DyWSRehw7oXRBu7c+J3ErTHC
         yhFvvppxcmvHQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 26/39] nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
Date:   Mon,  7 Jun 2021 12:13:05 -0400
Message-Id: <20210607161318.3583636-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210607161318.3583636-1-sashal@kernel.org>
References: <20210607161318.3583636-1-sashal@kernel.org>
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
index b869b686e962..1d3185c82596 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -287,6 +287,7 @@ static void nvme_loop_destroy_io_queues(struct nvme_loop_ctrl *ctrl)
 		clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[i].flags);
 		nvmet_sq_destroy(&ctrl->queues[i].nvme_sq);
 	}
+	ctrl->ctrl.queue_count = 1;
 }
 
 static int nvme_loop_init_io_queues(struct nvme_loop_ctrl *ctrl)
-- 
2.30.2

