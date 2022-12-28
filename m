Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9E765746D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 10:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbiL1JHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 04:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiL1JHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 04:07:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFFEBD7
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 01:07:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C75BB8109E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 09:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDBF7C433EF;
        Wed, 28 Dec 2022 09:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672218433;
        bh=9TQ/Yv5D2QgK210QXUqPyfKeaW5kqM8u8mc8uPo4wTk=;
        h=Subject:To:Cc:From:Date:From;
        b=fcdxljs0WkMIthCTSGCiK9WlL2sVyxIo+vnv7tc3PHa8T4Q4s/1ZbyKwpyO8oRafq
         p5nMFTa275ZepouOO5wflTfLztl/P4DdGHDaWDUnGlQ4DZQtpAQxXvoY5KNuVtlyyH
         thMQ+D7ixH6ycTIAiuJaTYUPbJmn21OWxS51pKq8=
Subject: FAILED: patch "[PATCH] usb: dwc3: qcom: Fix memory leak in" failed to apply to 6.0-stable tree
To:     linmq006@gmail.com, Thinh.Nguyen@synopsys.com,
        gregkh@linuxfoundation.org, stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Dec 2022 10:07:09 +0100
Message-ID: <1672218429113125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

97a48da1619b ("usb: dwc3: qcom: Fix memory leak in dwc3_qcom_interconnect_init")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 97a48da1619ba6bd42a0e5da0a03aa490a9496b1 Mon Sep 17 00:00:00 2001
From: Miaoqian Lin <linmq006@gmail.com>
Date: Tue, 6 Dec 2022 12:17:31 +0400
Subject: [PATCH] usb: dwc3: qcom: Fix memory leak in
 dwc3_qcom_interconnect_init

of_icc_get() alloc resources for path handle, we should release it when not
need anymore. Like the release in dwc3_qcom_interconnect_exit() function.
Add icc_put() in error handling to fix this.

Fixes: bea46b981515 ("usb: dwc3: qcom: Add interconnect support in dwc3 driver")
Cc: stable <stable@kernel.org>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20221206081731.818107-1-linmq006@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/dwc3-qcom.c b/drivers/usb/dwc3/dwc3-qcom.c
index 7c40f3ffc054..b0a0351d2d8b 100644
--- a/drivers/usb/dwc3/dwc3-qcom.c
+++ b/drivers/usb/dwc3/dwc3-qcom.c
@@ -261,7 +261,8 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 	if (IS_ERR(qcom->icc_path_apps)) {
 		dev_err(dev, "failed to get apps-usb path: %ld\n",
 				PTR_ERR(qcom->icc_path_apps));
-		return PTR_ERR(qcom->icc_path_apps);
+		ret = PTR_ERR(qcom->icc_path_apps);
+		goto put_path_ddr;
 	}
 
 	max_speed = usb_get_maximum_speed(&qcom->dwc3->dev);
@@ -274,16 +275,22 @@ static int dwc3_qcom_interconnect_init(struct dwc3_qcom *qcom)
 	}
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for usb-ddr path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	ret = icc_set_bw(qcom->icc_path_apps, APPS_USB_AVG_BW, APPS_USB_PEAK_BW);
 	if (ret) {
 		dev_err(dev, "failed to set bandwidth for apps-usb path: %d\n", ret);
-		return ret;
+		goto put_path_apps;
 	}
 
 	return 0;
+
+put_path_apps:
+	icc_put(qcom->icc_path_apps);
+put_path_ddr:
+	icc_put(qcom->icc_path_ddr);
+	return ret;
 }
 
 /**

