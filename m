Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79AE33109A
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 15:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhCHORr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 09:17:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:42000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230050AbhCHORk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 09:17:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 38F8F651D3;
        Mon,  8 Mar 2021 14:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615213059;
        bh=74SmVLQFtv6tj6t/7qSS/yVf3SBlRcISQTV/xeFhJmw=;
        h=Subject:To:From:Date:From;
        b=uWSe5vFRPNinITz1No4Ogjt0tpF3vIUKO31t7AGuU4s/FalD2YVyichw4Q5CYmtZk
         r9TZ8EXQe25GLkaf4PQuM1CLtsV/Jyl4PVgFcT0BAktpN0vZW9tiCIEvhxp4yeltuN
         Pf6the+twtRE5NuRrQJvZigOI0fmlrYbtYGh7pg4=
Subject: patch "usb: dwc3: qcom: Honor wakeup enabled/disabled state" added to usb-linus
To:     mka@chromium.org, bjorn.andersson@linaro.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Mar 2021 15:17:37 +0100
Message-ID: <1615213057141118@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: qcom: Honor wakeup enabled/disabled state

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From dc649f810a4c1e18dded8d4f1e1c42b40ff6bb2e Mon Sep 17 00:00:00 2001
From: Matthias Kaehlcke <mka@chromium.org>
Date: Tue, 2 Mar 2021 10:37:03 -0800
Subject: usb: dwc3: qcom: Honor wakeup enabled/disabled state

The dwc3-qcom currently enables wakeup interrupts unconditionally
when suspending, however this should not be done when wakeup is
disabled (e.g. through the sysfs attribute power/wakeup). Only
enable wakeup interrupts when device_may_wakeup() returns true.

Fixes: a4333c3a6ba9 ("usb: dwc3: Add Qualcomm DWC3 glue driver")
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210302103659.v2.1.I44954d9e1169f2cf5c44e6454d357c75ddfa99a2@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index d8850f9ccb62..730e8d6a2aa6 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -358,8 +358,10 @@ static int dwc3_qcom_suspend(struct dwc3_qcom *qcom)
 	if (ret)
 		dev_warn(qcom->dev, "failed to disable interconnect: %d\n", ret);
 
+	if (device_may_wakeup(qcom->dev))
+		dwc3_qcom_enable_interrupts(qcom);
+
 	qcom->is_suspended = true;
-	dwc3_qcom_enable_interrupts(qcom);
 
 	return 0;
 }
@@ -372,7 +374,8 @@ static int dwc3_qcom_resume(struct dwc3_qcom *qcom)
 	if (!qcom->is_suspended)
 		return 0;
 
-	dwc3_qcom_disable_interrupts(qcom);
+	if (device_may_wakeup(qcom->dev))
+		dwc3_qcom_disable_interrupts(qcom);
 
 	for (i = 0; i < qcom->num_clocks; i++) {
 		ret = clk_prepare_enable(qcom->clks[i]);
-- 
2.30.1


