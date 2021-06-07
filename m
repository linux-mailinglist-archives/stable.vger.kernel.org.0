Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83DB339E318
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 18:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhFGQVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 12:21:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232207AbhFGQTG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Jun 2021 12:19:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BA1C61629;
        Mon,  7 Jun 2021 16:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623082476;
        bh=d7p5lr8WG2kOoPy/qtHLSOXt63pDSmjvEGscr38ZZHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnUnjep4cXtv9R/91BHiVSwTumCue9LcUKzxiCUr3LRO280g1RVVLCFqHnaRkp9Cf
         9HMsauj8GzQL93gbjE4OeuoOoSBfREC0IPJplesu5CFdtDxDE7TsFbPx/S9PbDRfiB
         h++7ylEHjIm2AC97vcCm87mSEXJJ3ei6+ETpBoD7tD7Pe9JnEUOhg2lQUXMiQoMoq8
         K33IsoWMWCzbrUdh5qzPpRYGCZykqe7HMzNO8xcET6++6t50kE+EM8G+avR+FTfnqi
         1WTCaG5QJp4ugsbd8itjYQNcancTS43touAwj+06atWT/j2tgF8BEWdtcmBgsdcxZi
         eL2yrgBLWWmgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 20/29] nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
Date:   Mon,  7 Jun 2021 12:14:01 -0400
Message-Id: <20210607161410.3584036-20-sashal@kernel.org>
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
index 82b87a4c50f6..b4f5503ae570 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -288,6 +288,7 @@ static void nvme_loop_destroy_io_queues(struct nvme_loop_ctrl *ctrl)
 		clear_bit(NVME_LOOP_Q_LIVE, &ctrl->queues[i].flags);
 		nvmet_sq_destroy(&ctrl->queues[i].nvme_sq);
 	}
+	ctrl->ctrl.queue_count = 1;
 }
 
 static int nvme_loop_init_io_queues(struct nvme_loop_ctrl *ctrl)
-- 
2.30.2

