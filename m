Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B223F6431
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbhHXRBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239229AbhHXRAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:00:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CF3461527;
        Tue, 24 Aug 2021 16:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824265;
        bh=r+V0A17tgxcA82XXwN7/StijCPPl5o6+3j+cTO0dLn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1CBd/KOoYCa5uZjs7lnJwWPLK8qDamF49jbHXjUcZJptm3f/9J+ZO3NIHQDmauWd
         ITa0rCQ25qFQCq6OBB0ko6OfukNpiyrUNesNqWd8ObzdZImDrjFTwT8W0PFVjBUU6I
         TofHb2A4RwdstpihlN6R1hnkyko7lHpgoS8EYGi58GyDzmc6FwSWwJaYon3Vnz0pPW
         r+nFKtmlhed1ZRXj4G4r1tSgNWCQ8orGNBCWj37ruMEpGfCtY8KrOlmxfgj0hyUmrp
         XcSFpjNu5mzcfINv01+4ZH8M6UDIoRtN9/qVLZWmWFbEsJ1jtJTyIQQrewujRudX/N
         O1vBt+FXWhrZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 098/127] slimbus: ngd: set correct device for pm
Date:   Tue, 24 Aug 2021 12:55:38 -0400
Message-Id: <20210824165607.709387-99-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit c0e38eaa8d5102c138e4f16658ea762417d42a8f ]

For some reason we ended up using wrong device in some places for pm_runtime calls.
Fix this so that NGG driver can do runtime pm correctly.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20210809082428.11236-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index c054e83ab636..f3ee8e036372 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -618,7 +618,7 @@ static void qcom_slim_ngd_rx(struct qcom_slim_ngd_ctrl *ctrl, u8 *buf)
 		(mc == SLIM_USR_MC_GENERIC_ACK &&
 		 mt == SLIM_MSG_MT_SRC_REFERRED_USER)) {
 		slim_msg_response(&ctrl->ctrl, &buf[4], buf[3], len - 4);
-		pm_runtime_mark_last_busy(ctrl->dev);
+		pm_runtime_mark_last_busy(ctrl->ctrl.dev);
 	}
 }
 
@@ -1257,13 +1257,14 @@ static int qcom_slim_ngd_enable(struct qcom_slim_ngd_ctrl *ctrl, bool enable)
 		}
 		/* controller state should be in sync with framework state */
 		complete(&ctrl->qmi.qmi_comp);
-		if (!pm_runtime_enabled(ctrl->dev) ||
-				!pm_runtime_suspended(ctrl->dev))
-			qcom_slim_ngd_runtime_resume(ctrl->dev);
+		if (!pm_runtime_enabled(ctrl->ctrl.dev) ||
+			 !pm_runtime_suspended(ctrl->ctrl.dev))
+			qcom_slim_ngd_runtime_resume(ctrl->ctrl.dev);
 		else
-			pm_runtime_resume(ctrl->dev);
-		pm_runtime_mark_last_busy(ctrl->dev);
-		pm_runtime_put(ctrl->dev);
+			pm_runtime_resume(ctrl->ctrl.dev);
+
+		pm_runtime_mark_last_busy(ctrl->ctrl.dev);
+		pm_runtime_put(ctrl->ctrl.dev);
 
 		ret = slim_register_controller(&ctrl->ctrl);
 		if (ret) {
@@ -1389,7 +1390,7 @@ static int qcom_slim_ngd_ssr_pdr_notify(struct qcom_slim_ngd_ctrl *ctrl,
 		/* Make sure the last dma xfer is finished */
 		mutex_lock(&ctrl->tx_lock);
 		if (ctrl->state != QCOM_SLIM_NGD_CTRL_DOWN) {
-			pm_runtime_get_noresume(ctrl->dev);
+			pm_runtime_get_noresume(ctrl->ctrl.dev);
 			ctrl->state = QCOM_SLIM_NGD_CTRL_DOWN;
 			qcom_slim_ngd_down(ctrl);
 			qcom_slim_ngd_exit_dma(ctrl);
-- 
2.30.2

