Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92702345DF3
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 13:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhCWMVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 08:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229893AbhCWMVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 08:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 615726197F;
        Tue, 23 Mar 2021 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616502096;
        bh=RI5170tCSUUeQJ1+Ni2aMo7e5RxRgaInLvxkZx5/Kyw=;
        h=Subject:To:From:Date:From;
        b=jGSOYyUN2JzzGaWzxUJG0TZ8oAgo9o33YvcEkhXJJw7jxkfUTf/nGhBZhR9d2yWRA
         7hrMtMLf5HUQUqL8TEX5IjpT9jZQnxwajeImbCMVgM+K5KURsOwYQTmETafA4kgyxC
         s7kblRN9bk5b1qal4XilkAu2Lfg/9oqN28XHVzEs=
Subject: patch "usb: dwc3: qcom: skip interconnect init for ACPI probe" added to usb-linus
To:     shawn.guo@linaro.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Mar 2021 13:21:33 +0100
Message-ID: <1616502093225143@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: qcom: skip interconnect init for ACPI probe

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e4010e36a58978e42b2ee13739ff9b50209c830 Mon Sep 17 00:00:00 2001
From: Shawn Guo <shawn.guo@linaro.org>
Date: Thu, 11 Mar 2021 14:03:18 +0800
Subject: usb: dwc3: qcom: skip interconnect init for ACPI probe

The ACPI probe starts failing since commit bea46b981515 ("usb: dwc3:
qcom: Add interconnect support in dwc3 driver"), because there is no
interconnect support for ACPI, and of_icc_get() call in
dwc3_qcom_interconnect_init() will just return -EINVAL.

Fix the problem by skipping interconnect init for ACPI probe, and then
the NULL icc_path_ddr will simply just scheild all ICC calls.

Fixes: bea46b981515 ("usb: dwc3: qcom: Add interconnect support in dwc3 driver")
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210311060318.25418-1-shawn.guo@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index fcaf04483ad0..3de291ab951a 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -244,6 +244,9 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 	struct device *dev = qcom->dev;
 	int ret;
 
+	if (has_acpi_companion(dev))
+		return 0;
+
 	qcom->icc_path_ddr = of_icc_get(dev, "usb-ddr");
 	if (IS_ERR(qcom->icc_path_ddr)) {
 		dev_err(dev, "failed to get usb-ddr path: %ld\n",
-- 
2.31.0


