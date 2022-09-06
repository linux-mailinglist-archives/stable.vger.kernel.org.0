Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9AB5AEC6F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbiIFOQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240735AbiIFOPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:15:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5017C324;
        Tue,  6 Sep 2022 06:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1509E61523;
        Tue,  6 Sep 2022 13:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7B7C43141;
        Tue,  6 Sep 2022 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662472155;
        bh=B5YKUCOzQi2LrJLBX04dkj5OJAWXgvR0YM6hsEw03Hw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2zsPFBK72ldlrkJxsFKBDNrjpkTK+zbAj6Hth26FGXSWBugwXLrJtjCoT0xkFnW6
         71NBCCRY3oRp5LHpEKgMk0Rq624R7WQer994mZaMlmk8bIuHSgv7NVux0UIRxcZP20
         lluxcyY+NRy+mNbUk/bp6RVunl0zu7pNVuVigEfFitxZVKBmstPpsXkJZsvFqwzUHy
         qFFSC0oUP6SLNG1YisjvqB2wasVxXltEr6H0bkIBRHvNLGSHboQ9OiKAzOCYq4SsY8
         hYLTLzUCqGdVpdF7H3LPAQ3MHI2Lgfi2Zekalyu5adzqaFUn7RQknjoSJI3LQsQrBf
         TFmKqT4qbjgMQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVYx5-00050S-GA; Tue, 06 Sep 2022 15:49:19 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH stable-4.19 2/4] usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
Date:   Tue,  6 Sep 2022 15:49:13 +0200
Message-Id: <20220906134915.19225-3-johan@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220906134915.19225-1-johan@kernel.org>
References: <20220906134915.19225-1-johan@kernel.org>
MIME-Version: 1.0
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

commit  a872ab303d5ddd4c965f9cd868677781a33ce35a upstream.

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
[ johan: adjust context for 5.4 ]
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 14 +++++++++++++-
 drivers/usb/dwc3/host.c      |  1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 5bb5384f3612..9d5320562e81 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -173,6 +173,14 @@ static int dwc3_qcom_register_extcon(struct dwc3_qcom *qcom)
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
@@ -280,7 +288,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
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
index 1a3878a3be78..124e9f80dccd 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -142,4 +142,5 @@ void dwc3_host_exit(struct dwc3 *dwc)
 	phy_remove_lookup(dwc->usb3_generic_phy, "usb3-phy",
 			  dev_name(dwc->dev));
 	platform_device_unregister(dwc->xhci);
+	dwc->xhci = NULL;
 }
-- 
2.35.1

