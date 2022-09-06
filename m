Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE215AE66E
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239372AbiIFLVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239281AbiIFLVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:21:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704963207D
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:21:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C0BB815F8
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D20EC433C1;
        Tue,  6 Sep 2022 11:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662463306;
        bh=4J15u3Jym+0s8t747BZ7SCk+1UZW2QNTPU8R/4YfFNU=;
        h=Subject:To:Cc:From:Date:From;
        b=0oJ3745RyXzktDwKAimiPvJdj94X/D790VMpewHcahbnewRlpiAtZFey1ol8cJKHZ
         Q0FasVzl6rxySs1ZGKsPKKfCk/1bJ4ZRmcNPbtXmSuhRncn0fyXnLrmvSZgEftopx6
         Sx7azq5bS6uSiHmuLXl627+NYZ0CowQ8IT/Mbl/Q=
Subject: FAILED: patch "[PATCH] usb: dwc3: gadget: Avoid duplicate requests to enable" failed to apply to 5.4-stable tree
To:     quic_wcheng@quicinc.com, gregkh@linuxfoundation.org,
        stable@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:21:36 +0200
Message-ID: <166246329636182@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 040f2dbd2010c43f33ad27249e6dac48456f4d99 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <quic_wcheng@quicinc.com>
Date: Wed, 27 Jul 2022 19:06:47 -0700
Subject: [PATCH] usb: dwc3: gadget: Avoid duplicate requests to enable
 Run/Stop

Relocate the pullups_connected check until after it is ensured that there
are no runtime PM transitions.  If another context triggered the DWC3
core's runtime resume, it may have already enabled the Run/Stop.  Do not
re-run the entire pullup sequence again, as it may issue a core soft
reset while Run/Stop is already set.

This patch depends on
  commit 69e131d1ac4e ("usb: dwc3: gadget: Prevent repeat pullup()")

Fixes: 77adb8bdf422 ("usb: dwc3: gadget: Allow runtime suspend if UDC unbinded")
Cc: stable <stable@kernel.org>
Signed-off-by: Wesley Cheng <quic_wcheng@quicinc.com>
Link: https://lore.kernel.org/r/20220728020647.9377-1-quic_wcheng@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index aeeec751c53c..eca945feeec3 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2539,9 +2539,6 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
 	is_on = !!is_on;
 
-	if (dwc->pullups_connected == is_on)
-		return 0;
-
 	dwc->softconnect = is_on;
 
 	/*
@@ -2566,6 +2563,11 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 		return 0;
 	}
 
+	if (dwc->pullups_connected == is_on) {
+		pm_runtime_put(dwc->dev);
+		return 0;
+	}
+
 	if (!is_on) {
 		ret = dwc3_gadget_soft_disconnect(dwc);
 	} else {

