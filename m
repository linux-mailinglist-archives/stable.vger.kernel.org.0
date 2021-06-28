Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFEB3B62EE
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbhF1OuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:50:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:54534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236329AbhF1OrX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:47:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFA5561CA8;
        Mon, 28 Jun 2021 14:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624890999;
        bh=x2c4b1/n9pTYYdcPDTBCvUOkjOIDOUolY33xlgn3Wuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e5LnRc9mH1s7H+pFbRbCC5Maxyh/DG3Zym2hJzFHo/q/SaUHkh0eMq9wZig0hcVm9
         9V3ZApHtQwX3W9mYL+KXamHRGOaj5hV4LTx2HX2fPjDR70O0leDE0KtqkTMVdDf7w1
         K+GVowT+5PR0MM8xQP9xccqT7BqW1+h0vMZRtL4hPeM6TE/cjEzPy/ykVyrHZ/Fsq7
         mnc0mm9g/VfI8+8oT7Pw2zF0QG+b4JyJcjldfBqHwcqobjilWjiNWOIp3mqQCEHSEO
         7dnuNrtpT1Fy7Ue7WxwZKrGSoRY4ijYJylhpdAyBU5I7RLJjZUWo/4bAMX4x2qrUQf
         LTwm3eTg7yZXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/88] nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
Date:   Mon, 28 Jun 2021 10:35:10 -0400
Message-Id: <20210628143628.33342-11-sashal@kernel.org>
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

