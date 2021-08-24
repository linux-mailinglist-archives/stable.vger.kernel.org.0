Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5893F66C0
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbhHXR1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239080AbhHXRZI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:25:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86C5361B30;
        Tue, 24 Aug 2021 17:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824644;
        bh=NPo+8Ivt2aQl8y9Gq0eDPfl2mR8M05s168erWJN/Yzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6iI0j1sUOrgnq9cjJJNVJzQxX6CgPjiM4KoMr249y6UMsYhAkVjYuSYaPvnKJaM6
         +QcqaolC5y4yL9tHXgrRmvp7HBsdPz6X1y6eGa0Yb0Q09X0DInvTEkchlapiYcN1SV
         iyDz0ZjWnjZebWlV/bS7Fw6z+usUSSV0XQoXDGQ9pjRQHtYnPcRm/ygFeGmHfVRjv8
         tXhE03Gz0/YLqmt+QAmsBYW+blYEjJcfaXDAyHn3vRr0VBp1SwuNs5xcPlwDev98O0
         gYOIR+N27ZIziOIsOch+X4P/DY4sN88Xx+HzrJ/MKiigvsacS7YOy56EZi+7mclo5c
         Fs/8/0A7Uyr6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 75/84] slimbus: ngd: reset dma setup during runtime pm
Date:   Tue, 24 Aug 2021 13:02:41 -0400
Message-Id: <20210824170250.710392-76-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
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
index 44021620d101..1a5311fb45a5 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1060,7 +1060,8 @@ static void qcom_slim_ngd_setup(struct qcom_slim_ngd_ctrl *ctrl)
 {
 	u32 cfg = readl_relaxed(ctrl->ngd->base);
 
-	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN)
+	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN ||
+		ctrl->state == QCOM_SLIM_NGD_CTRL_ASLEEP)
 		qcom_slim_ngd_init_dma(ctrl);
 
 	/* By default enable message queues */
@@ -1111,6 +1112,7 @@ static int qcom_slim_ngd_power_up(struct qcom_slim_ngd_ctrl *ctrl)
 			dev_info(ctrl->dev, "Subsys restart: ADSP active framer\n");
 			return 0;
 		}
+		qcom_slim_ngd_setup(ctrl);
 		return 0;
 	}
 
@@ -1496,6 +1498,7 @@ static int __maybe_unused qcom_slim_ngd_runtime_suspend(struct device *dev)
 	struct qcom_slim_ngd_ctrl *ctrl = dev_get_drvdata(dev);
 	int ret = 0;
 
+	qcom_slim_ngd_exit_dma(ctrl);
 	if (!ctrl->qmi.handle)
 		return 0;
 
-- 
2.30.2

