Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0FC46F397
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 20:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhLITHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 14:07:08 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40722 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhLITHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 14:07:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7903DCE27EF
        for <stable@vger.kernel.org>; Thu,  9 Dec 2021 19:03:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D57C004DD;
        Thu,  9 Dec 2021 19:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639076610;
        bh=hJUGMYJ/crPTieK1Ao2Mm0ZmxsgkCJrFXqmqTeceSzE=;
        h=Subject:To:From:Date:From;
        b=1XFCkWXLw+PizzyIAdhb121fQzAJLJ8o/S2zbzddPNDvSzN78b7mj6W3wrCw21b6D
         VRReogB8vpq/FYijFSLYHKW9bSDV/30cHHjmDHlgTS33DJB5oyagUShZ0DtvJtlxPb
         0/ze5OMGfHCeOhua2pOs4YB+RLwrEsSis9iS2DvM=
Subject: patch "Revert "usb: dwc3: dwc3-qcom: Enable tx-fifo-resize property by" added to usb-linus
To:     dianders@chromium.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, swboyd@chromium.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 09 Dec 2021 20:03:28 +0100
Message-ID: <163907660811496@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "usb: dwc3: dwc3-qcom: Enable tx-fifo-resize property by

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6a97cee39d8f2ed4d6e35a09a302dae1d566db36 Mon Sep 17 00:00:00 2001
From: Douglas Anderson <dianders@chromium.org>
Date: Tue, 7 Dec 2021 09:43:41 -0800
Subject: Revert "usb: dwc3: dwc3-qcom: Enable tx-fifo-resize property by
 default"

This reverts commit cefdd52fa0455c0555c30927386ee466a108b060.

On sc7180-trogdor class devices with 'fw_devlink=permissive' and KASAN
enabled, you'll see a Use-After-Free reported at bootup.

The root of the problem is that dwc3_qcom_of_register_core() is adding
a devm-allocated "tx-fifo-resize" property to its device tree node
using of_add_property().

The issue is that of_add_property() makes a _permanent_ addition to
the device tree that lasts until reboot. That means allocating memory
for the property using "devm" managed memory is a terrible idea since
that memory will be freed upon probe deferral or device unbinding.

Let's revert the patch since the system is still functional without
it. The fact that of_add_property() makes a permanent change is extra
fodder for those folks who were aruging that the device tree isn't
really the right way to pass information between parts of the
driver. It is an exercise left to the reader to submit a patch
re-adding the new feature in a way that makes everyone happier.

Fixes: cefdd52fa045 ("usb: dwc3: dwc3-qcom: Enable tx-fifo-resize property by default")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20211207094327.1.Ie3cde3443039342e2963262a4c3ac36dc2c08b30@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-qcom.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 9abbd01028c5..3cb01cdd02c2 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -649,7 +649,6 @@ static int dwc3_qcom_of_register_core(struct platform_device *pdev)
 	struct dwc3_qcom	*qcom = platform_get_drvdata(pdev);
 	struct device_node	*np = pdev->dev.of_node, *dwc3_np;
 	struct device		*dev = &pdev->dev;
-	struct property		*prop;
 	int			ret;
 
 	dwc3_np = of_get_compatible_child(np, "snps,dwc3");
@@ -658,20 +657,6 @@ static int dwc3_qcom_of_register_core(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	prop = devm_kzalloc(dev, sizeof(*prop), GFP_KERNEL);
-	if (!prop) {
-		ret = -ENOMEM;
-		dev_err(dev, "unable to allocate memory for property\n");
-		goto node_put;
-	}
-
-	prop->name = "tx-fifo-resize";
-	ret = of_add_property(dwc3_np, prop);
-	if (ret) {
-		dev_err(dev, "unable to add property\n");
-		goto node_put;
-	}
-
 	ret = of_platform_populate(np, NULL, NULL, dev);
 	if (ret) {
 		dev_err(dev, "failed to register dwc3 core - %d\n", ret);
-- 
2.34.1


