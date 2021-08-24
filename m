Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F29E93F65FC
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239759AbhHXRSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:18:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240086AbhHXRQu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:16:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E78CD61A62;
        Tue, 24 Aug 2021 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824518;
        bh=ZmpDQaat6ntHOmBtuyXrsXVM9HBlJpFZ52H+jjL0j8E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juaQVBDAAYI050GkwLQ8xns939ApwJlAUCWXLxOgg4eLe3YkYg9bQYWpTBXbFEIFF
         dcnrc1x3Krdffi4SwdLQ04w3oVca5VOe2xWpU8p3p/UhOYXgWgaC4G+16LpDbUdbGb
         t2S8rAdQ08SUMtNTtQRp2ceqImpitHm9P/fUh9JZVe6WhMa+aoc1lJwG0pAN+KbsaB
         bbSMEAthtzhJtfhsjl4gOsKTIJJnBOAB5xh+8fBlW28mqFZhj48FYkQfzrDFxptHmm
         vHKbXt34+xE8VMYsIaRcqV9iPRKezTd448tJCE7+ER8REN1ya7qQPVItMiMLI4wzTA
         THbLYknxeYavA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 51/61] slimbus: ngd: reset dma setup during runtime pm
Date:   Tue, 24 Aug 2021 13:00:56 -0400
Message-Id: <20210824170106.710221-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit d77772538f00b7265deace6e77e555ee18365ad0 ]

During suspend/resume NGD remote instance is power cycled along
with remotely controlled bam dma engine.
So Reset the dma configuration during this suspend resume path
so that we are not dealing with any stale dma setup.

Without this transactions timeout after first suspend resume path.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210809082428.11236-5-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index b60541c3f72d..09ecd1fb24ae 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1061,7 +1061,8 @@ static void qcom_slim_ngd_setup(struct qcom_slim_ngd_ctrl *ctrl)
 {
 	u32 cfg = readl_relaxed(ctrl->ngd->base);
 
-	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN)
+	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN ||
+		ctrl->state == QCOM_SLIM_NGD_CTRL_ASLEEP)
 		qcom_slim_ngd_init_dma(ctrl);
 
 	/* By default enable message queues */
@@ -1112,6 +1113,7 @@ static int qcom_slim_ngd_power_up(struct qcom_slim_ngd_ctrl *ctrl)
 			dev_info(ctrl->dev, "Subsys restart: ADSP active framer\n");
 			return 0;
 		}
+		qcom_slim_ngd_setup(ctrl);
 		return 0;
 	}
 
@@ -1500,6 +1502,7 @@ static int __maybe_unused qcom_slim_ngd_runtime_suspend(struct device *dev)
 	struct qcom_slim_ngd_ctrl *ctrl = dev_get_drvdata(dev);
 	int ret = 0;
 
+	qcom_slim_ngd_exit_dma(ctrl);
 	if (!ctrl->qmi.handle)
 		return 0;
 
-- 
2.30.2

