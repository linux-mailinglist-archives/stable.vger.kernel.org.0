Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324555AEBA1
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbiIFOOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241682AbiIFONw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:13:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94407694E;
        Tue,  6 Sep 2022 06:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94AFC614C9;
        Tue,  6 Sep 2022 13:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953B4C433C1;
        Tue,  6 Sep 2022 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471994;
        bh=BLKt3sXsnjJfaikD6GS4b3J1vS+NSVoxDchTvMXSrkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pkGA59EUtXtL17+I/F1sk5Es+/gNXO0xS5xoYAl6lJ8RY3TmG0aWO/j2pmsaKSeo3
         /wd+Ur0vZiecP7MLMEMno+YMEPyba5J++RuzgzZnxkI9ibaaobcD2TP5Fa0gzdgAJ+
         4pY6dByeUs7oS5Zj4mYG+g0nWi50LHZyq8+FlgzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable <stable@kernel.org>,
        Wesley Cheng <quic_wcheng@quicinc.com>
Subject: [PATCH 5.19 111/155] usb: dwc3: gadget: Avoid duplicate requests to enable Run/Stop
Date:   Tue,  6 Sep 2022 15:30:59 +0200
Message-Id: <20220906132834.161346397@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Wesley Cheng <quic_wcheng@quicinc.com>

commit 040f2dbd2010c43f33ad27249e6dac48456f4d99 upstream.

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
---
 drivers/usb/dwc3/gadget.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -2538,9 +2538,6 @@ static int dwc3_gadget_pullup(struct usb
 
 	is_on = !!is_on;
 
-	if (dwc->pullups_connected == is_on)
-		return 0;
-
 	dwc->softconnect = is_on;
 
 	/*
@@ -2564,6 +2561,11 @@ static int dwc3_gadget_pullup(struct usb
 		pm_runtime_put(dwc->dev);
 		return 0;
 	}
+
+	if (dwc->pullups_connected == is_on) {
+		pm_runtime_put(dwc->dev);
+		return 0;
+	}
 
 	if (!is_on) {
 		ret = dwc3_gadget_soft_disconnect(dwc);


