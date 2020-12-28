Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC152E4170
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438967AbgL1OKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438963AbgL1OKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F7DE206C3;
        Mon, 28 Dec 2020 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164570;
        bh=WZZNQL4waOwc5Rt/nP4qhfP11LZ1Qtc92pWShd0huvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wuxxi6wBJDItqkSEMWwmssJXdapPK1/VwoXGuxDinhtQ3O5qM98Yugd97a4q1lKPb
         zqsEsaeDOkm7JsSZwG/KKZyuRiGTdZ3UAboTUaTR/ZpkoG4d/ZIVA1sz8Jv73mDMWO
         tiq3gJdFtVVOYcKeOnYMzrLuBGmvghm/WdLX5eZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 222/717] slimbus: qcom-ngd-ctrl: Avoid sending power requests without QMI
Date:   Mon, 28 Dec 2020 13:43:40 +0100
Message-Id: <20201228125031.618183747@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 39014ce6d6028614a46395923a2c92d058b6fa87 ]

Attempting to send a power request during PM operations, when the QMI
handle isn't initialized results in a NULL pointer dereference. So check
if the QMI handle has been initialized before attempting to post the
power requests.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20201127102451.17114-7-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 218aefc3531cd..50cfd67c2871e 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1205,6 +1205,9 @@ static int qcom_slim_ngd_runtime_resume(struct device *dev)
 	struct qcom_slim_ngd_ctrl *ctrl = dev_get_drvdata(dev);
 	int ret = 0;
 
+	if (!ctrl->qmi.handle)
+		return 0;
+
 	if (ctrl->state >= QCOM_SLIM_NGD_CTRL_ASLEEP)
 		ret = qcom_slim_ngd_power_up(ctrl);
 	if (ret) {
@@ -1503,6 +1506,9 @@ static int __maybe_unused qcom_slim_ngd_runtime_suspend(struct device *dev)
 	struct qcom_slim_ngd_ctrl *ctrl = dev_get_drvdata(dev);
 	int ret = 0;
 
+	if (!ctrl->qmi.handle)
+		return 0;
+
 	ret = qcom_slim_qmi_power_request(ctrl, false);
 	if (ret && ret != -EBUSY)
 		dev_info(ctrl->dev, "slim resource not idle:%d\n", ret);
-- 
2.27.0



