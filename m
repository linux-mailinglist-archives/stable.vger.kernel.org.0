Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0BC4727AF
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbhLMKEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:30 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48198 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240141AbhLMJ7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:59:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08FBFCE0F5A;
        Mon, 13 Dec 2021 09:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA484C34601;
        Mon, 13 Dec 2021 09:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389587;
        bh=Vk+cAtJjbarT6hIf/i7eUKGqI55drVQlzH+2KXSsRXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwEVtpkeueJHhbhyFyPav9q2m7rDmZk4HCBYSF99Mkk/yf0lU8TgJkMQC8MEi5Hpp
         ezqQ+3eS1oR6wd9rGxz+wkeDsThThtt+Mlb9ms6QcN18uMiPXg/Jg9W4SkMIIPkMbb
         1Mrn1iR4XS24LJvd0yEBB3EPC6XSZ9WHcABkMktg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 5.15 138/171] Revert "usb: dwc3: dwc3-qcom: Enable tx-fifo-resize property by default"
Date:   Mon, 13 Dec 2021 10:30:53 +0100
Message-Id: <20211213092949.681679426@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Douglas Anderson <dianders@chromium.org>

commit 6a97cee39d8f2ed4d6e35a09a302dae1d566db36 upstream.

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
 drivers/usb/dwc3/dwc3-qcom.c |   15 ---------------
 1 file changed, 15 deletions(-)

--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -649,7 +649,6 @@ static int dwc3_qcom_of_register_core(st
 	struct dwc3_qcom	*qcom = platform_get_drvdata(pdev);
 	struct device_node	*np = pdev->dev.of_node, *dwc3_np;
 	struct device		*dev = &pdev->dev;
-	struct property		*prop;
 	int			ret;
 
 	dwc3_np = of_get_compatible_child(np, "snps,dwc3");
@@ -658,20 +657,6 @@ static int dwc3_qcom_of_register_core(st
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


