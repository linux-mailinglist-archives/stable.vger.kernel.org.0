Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E466F33BA34
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbhCOOI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhCOOB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F30964E4D;
        Mon, 15 Mar 2021 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816918;
        bh=18j29ErcnQ1AlvxdDfNzMhlNX3P38sse4hPA7HQqMC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nAfxHc48sOnAX065nV+/KCPSU5V2z+dH2eM0inP1P3v7I8m51e2upWwou67X2rX1n
         r2Yt7hhft3GB89/N4GQ6wzsF3j+0+kRpve4JolQ6p4Abzpwl9xbprjSMvZBBLNNSiQ
         7D4eCIewvZvXrjVf6NpqSrD86gcP3TxtSQ1VQybE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 5.11 201/306] usb: dwc3: qcom: Honor wakeup enabled/disabled state
Date:   Mon, 15 Mar 2021 14:54:24 +0100
Message-Id: <20210315135514.428967658@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Matthias Kaehlcke <mka@chromium.org>

commit 2664deb0930643149d61cddbb66ada527ae180bd upstream.

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
 drivers/usb/dwc3/dwc3-qcom.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -358,8 +358,10 @@ static int dwc3_qcom_suspend(struct dwc3
 	if (ret)
 		dev_warn(qcom->dev, "failed to disable interconnect: %d\n", ret);
 
+	if (device_may_wakeup(qcom->dev))
+		dwc3_qcom_enable_interrupts(qcom);
+
 	qcom->is_suspended = true;
-	dwc3_qcom_enable_interrupts(qcom);
 
 	return 0;
 }
@@ -372,7 +374,8 @@ static int dwc3_qcom_resume(struct dwc3_
 	if (!qcom->is_suspended)
 		return 0;
 
-	dwc3_qcom_disable_interrupts(qcom);
+	if (device_may_wakeup(qcom->dev))
+		dwc3_qcom_disable_interrupts(qcom);
 
 	for (i = 0; i < qcom->num_clocks; i++) {
 		ret = clk_prepare_enable(qcom->clks[i]);


