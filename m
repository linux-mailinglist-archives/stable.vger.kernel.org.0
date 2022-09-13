Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBA05B72D2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiIMO4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235057AbiIMOzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:55:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDD967455;
        Tue, 13 Sep 2022 07:27:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DBF0614AA;
        Tue, 13 Sep 2022 14:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9815DC433C1;
        Tue, 13 Sep 2022 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079243;
        bh=YLvaDxd/FE79/q/Iy23pWP/PXEWDZnOJVJRIS3CaBTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPkzLSzH1HycxLkA0Ho+CcccvprpR27smPpC82k9PeNMKfmxgVI6IaN56YNN8EMBy
         R+a+LTb2DLN0NVB1pMvyTeOx7+ANYTmM5VTwEekMjD6bsCbCWcYyzGJYRZhipRhfiu
         IIHqnOzjdcv/83cjYeqMx90GLq3ZdMRjmN4z1Sbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/108] usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
Date:   Tue, 13 Sep 2022 16:06:03 +0200
Message-Id: <20220913140355.026878071@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
References: <20220913140353.549108748@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit a872ab303d5ddd4c965f9cd868677781a33ce35a ]

The Qualcomm dwc3 runtime-PM implementation checks the xhci
platform-device pointer in the wakeup-interrupt handler to determine
whether the controller is in host mode and if so triggers a resume.

After a role switch in OTG mode the xhci platform-device would have been
freed and the next wakeup from runtime suspend would access the freed
memory.

Note that role switching is executed from a freezable workqueue, which
guarantees that the pointer is stable during suspend.

Also note that runtime PM has been broken since commit 2664deb09306
("usb: dwc3: qcom: Honor wakeup enabled/disabled state"), which
incidentally also prevents this issue from being triggered.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Cc: stable@vger.kernel.org      # 4.18
Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20220804151001.23612-5-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
 drivers/usb/dwc3/host.c      |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 7874b97e33227..aed35276e0e0c 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -190,6 +190,14 @@ static int dwc3_qcom_register_extcon(struct dwc3_qcom *qcom)
 	return 0;
 }
 
+/* Only usable in contexts where the role can not change. */
+static bool dwc3_qcom_is_host(struct dwc3_qcom *qcom)
+{
+	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
+
+	return dwc->xhci;
+}
+
 static void dwc3_qcom_disable_interrupts(struct dwc3_qcom *qcom)
 {
 	if (qcom->hs_phy_irq) {
@@ -297,7 +305,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
 	if (qcom->pm_suspended)
 		return IRQ_HANDLED;
 
-	if (dwc->xhci)
+	/*
+	 * This is safe as role switching is done from a freezable workqueue
+	 * and the wakeup interrupts are disabled as part of resume.
+	 */
+	if (dwc3_qcom_is_host(qcom))
 		pm_runtime_resume(&dwc->xhci->dev);
 
 	return IRQ_HANDLED;
diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index fa252870c926f..38bcb079ffc74 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -128,4 +128,5 @@ int dwc3_host_init(struct dwc3 *dwc)
 void dwc3_host_exit(struct dwc3 *dwc)
 {
 	platform_device_unregister(dwc->xhci);
+	dwc->xhci = NULL;
 }
-- 
2.35.1



