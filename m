Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 666173F6553
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238708AbhHXRLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:11:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240144AbhHXRKG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:10:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3764619EC;
        Tue, 24 Aug 2021 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824431;
        bh=9kG7NwmXUQ3s4dNqr6NOaRRcmto2kFoANW/CED7UScs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJRHqsUsGmH8HMLrqz36RFvtmRXNxkfmC8Q3C2thAk8CYHHZV6IKY/aNArcpJWa5u
         wAOTWaNWbNsFDYdh6afl5bJdnWsRAnTlXDz8RxT1eouOMHrapfryOFGxfbnL56L6Dq
         cYtDCNFZtCkXw6y3pXhcDHoYE/oY9XLQi9IN2QYNEZp2EqjdbGHmGmE2k+kVFfRB9z
         TDOuoTGm2HKKdIg9SSIb9KU8Xh1QDbaYiSyBnjNO9D6N1GIB5l0B8yvYuMoeNqz1nQ
         Q5lHktDyO5+HMtM23AjHNRYxJpUg2JAdZQfvpEqxtb/6iLlf4GfAScioE85vS8MWXO
         rfVswRBDGKNqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 82/98] slimbus: ngd: reset dma setup during runtime pm
Date:   Tue, 24 Aug 2021 12:58:52 -0400
Message-Id: <20210824165908.709932-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 50cfd67c2871..d0540376221c 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1065,7 +1065,8 @@ static void qcom_slim_ngd_setup(struct qcom_slim_ngd_ctrl *ctrl)
 {
 	u32 cfg = readl_relaxed(ctrl->ngd->base);
 
-	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN)
+	if (ctrl->state == QCOM_SLIM_NGD_CTRL_DOWN ||
+		ctrl->state == QCOM_SLIM_NGD_CTRL_ASLEEP)
 		qcom_slim_ngd_init_dma(ctrl);
 
 	/* By default enable message queues */
@@ -1116,6 +1117,7 @@ static int qcom_slim_ngd_power_up(struct qcom_slim_ngd_ctrl *ctrl)
 			dev_info(ctrl->dev, "Subsys restart: ADSP active framer\n");
 			return 0;
 		}
+		qcom_slim_ngd_setup(ctrl);
 		return 0;
 	}
 
@@ -1506,6 +1508,7 @@ static int __maybe_unused qcom_slim_ngd_runtime_suspend(struct device *dev)
 	struct qcom_slim_ngd_ctrl *ctrl = dev_get_drvdata(dev);
 	int ret = 0;
 
+	qcom_slim_ngd_exit_dma(ctrl);
 	if (!ctrl->qmi.handle)
 		return 0;
 
-- 
2.30.2

