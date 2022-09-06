Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4005AE674
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239605AbiIFLWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233813AbiIFLWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:22:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E4076948
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:22:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD1ECB815F8
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24647C433D7;
        Tue,  6 Sep 2022 11:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463335;
        bh=6ump8WpcK6LFMWAscbl1qCU9gfuME7JJ/gLU3NW2/Zs=;
        h=Subject:To:Cc:From:Date:From;
        b=rs7QMDMyKpzlY9OvUh/HUlHe1fS1bE4LJxCnN1INdAmH+JMEou7UxyxmpYdjhHDru
         JfQkI6W3fievVndAb+TzSTa87qjhPViyWYljhpnGj14I3+8Rd4VmQyht8Ki/djdPQV
         xrVAszUz8GLVLSJJd0gZGqtx73vSLN47bXGZtVfU=
Subject: FAILED: patch "[PATCH] usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup" failed to apply to 5.19-stable tree
To:     johan+linaro@kernel.org, gregkh@linuxfoundation.org,
        manivannan.sadhasivam@linaro.org, mka@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:22:12 +0200
Message-ID: <166246333212989@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a872ab303d5ddd4c965f9cd868677781a33ce35a Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan+linaro@kernel.org>
Date: Thu, 4 Aug 2022 17:09:56 +0200
Subject: [PATCH] usb: dwc3: qcom: fix use-after-free on runtime-PM wakeup

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

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index e9364141661b..6884026b9fad 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -298,6 +298,14 @@ static void dwc3_qcom_interconnect_exit(struct dwc3_qcom *qcom)
 	icc_put(qcom->icc_path_apps);
 }
 
+/* Only usable in contexts where the role can not change. */
+static bool dwc3_qcom_is_host(struct dwc3_qcom *qcom)
+{
+	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
+
+	return dwc->xhci;
+}
+
 static enum usb_device_speed dwc3_qcom_read_usb2_speed(struct dwc3_qcom *qcom)
 {
 	struct dwc3 *dwc = platform_get_drvdata(qcom->dwc3);
@@ -460,7 +468,11 @@ static irqreturn_t qcom_dwc3_resume_irq(int irq, void *data)
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
index f56c30cf151e..f6f13e7f1ba1 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -135,4 +135,5 @@ int dwc3_host_init(struct dwc3 *dwc)
 void dwc3_host_exit(struct dwc3 *dwc)
 {
 	platform_device_unregister(dwc->xhci);
+	dwc->xhci = NULL;
 }

