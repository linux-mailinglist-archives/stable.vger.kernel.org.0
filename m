Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52AA5B751C
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236510AbiIMPcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236508AbiIMPb6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:31:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B687E820;
        Tue, 13 Sep 2022 07:40:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93BE3B80F6F;
        Tue, 13 Sep 2022 14:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C465FC433C1;
        Tue, 13 Sep 2022 14:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079585;
        bh=QVUIIIchCxxeuUgwWdiExksNAQBR6e7xgJ2M8dTQg50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEGcNpHHRuXatl3hTBnqi53B16yleG8ua70/oD1toP4s3qBTu+ZEiZjHHDaBlZOY/
         4epYEqPRWho0Tsjtm8XiZS7xxCSrCm6OlFztT1UHe6objRyM2cPkSwFtIJdj65Lcj8
         DBhZm/HEmr6KgAmMYQI9hfZIIvsVDJUuwJWd7izU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 76/79] usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup
Date:   Tue, 13 Sep 2022 16:07:34 +0200
Message-Id: <20220913140352.554689442@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c |   14 +++++++++++++-
 drivers/usb/dwc3/host.c      |    1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -173,6 +173,14 @@ static int dwc3_qcom_register_extcon(str
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
@@ -280,7 +288,11 @@ static irqreturn_t qcom_dwc3_resume_irq(
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
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -142,4 +142,5 @@ void dwc3_host_exit(struct dwc3 *dwc)
 	phy_remove_lookup(dwc->usb3_generic_phy, "usb3-phy",
 			  dev_name(dwc->dev));
 	platform_device_unregister(dwc->xhci);
+	dwc->xhci = NULL;
 }


