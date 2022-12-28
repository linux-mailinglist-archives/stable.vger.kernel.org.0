Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE16A65814C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbiL1Q1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiL1Q0W (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:26:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F05A1C914
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:22:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3EF9B81717
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20791C433D2;
        Wed, 28 Dec 2022 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244571;
        bh=tCKhIKES01vCm26ZLEvARUQHAFuL/43QG7Or5OiUYno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x0SPvMhWrJORFBY6N2KQkc0hpLLcwxdmlQ8GjJNThOnnif5Gz+7OFDrcdQ1BUwn4Y
         g3zfoytNgpjfWHaAySFNC1VAx9n2adKTRnXSa8bso3B+fNA3ilgX5M6vySeVDSQRo7
         iDgwIgusRgocqbijXwbgUAKK1wdkGAFh+IayFjJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0696/1146] usb: fotg210-udc: Fix ages old endianness issues
Date:   Wed, 28 Dec 2022 15:37:15 +0100
Message-Id: <20221228144349.048773011@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 46ed6026ca2181c917c8334a82e3eaf40a6234dd ]

The code in the FOTG210 driver isn't entirely endianness-agnostic
as reported by the kernel robot sparse testing. This came to
the surface while moving the files around.

The driver is only used on little-endian systems, so this causes
no real-world regression, but it is nice to be strict and have
some compile coverage also on big endian machines, so fix it
up with the right LE accessors.

Fixes: b84a8dee23fd ("usb: gadget: add Faraday fotg210_udc driver")
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/linux-usb/202211110910.0dJ7nZCn-lkp@intel.com/
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20221111090317.94228-1-linus.walleij@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fotg210-udc.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index fdca28e72a3b..d0e051beb3af 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -629,10 +629,10 @@ static void fotg210_request_error(struct fotg210_udc *fotg210)
 static void fotg210_set_address(struct fotg210_udc *fotg210,
 				struct usb_ctrlrequest *ctrl)
 {
-	if (ctrl->wValue >= 0x0100) {
+	if (le16_to_cpu(ctrl->wValue) >= 0x0100) {
 		fotg210_request_error(fotg210);
 	} else {
-		fotg210_set_dev_addr(fotg210, ctrl->wValue);
+		fotg210_set_dev_addr(fotg210, le16_to_cpu(ctrl->wValue));
 		fotg210_set_cxdone(fotg210);
 	}
 }
@@ -713,17 +713,17 @@ static void fotg210_get_status(struct fotg210_udc *fotg210,
 
 	switch (ctrl->bRequestType & USB_RECIP_MASK) {
 	case USB_RECIP_DEVICE:
-		fotg210->ep0_data = 1 << USB_DEVICE_SELF_POWERED;
+		fotg210->ep0_data = cpu_to_le16(1 << USB_DEVICE_SELF_POWERED);
 		break;
 	case USB_RECIP_INTERFACE:
-		fotg210->ep0_data = 0;
+		fotg210->ep0_data = cpu_to_le16(0);
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = ctrl->wIndex & USB_ENDPOINT_NUMBER_MASK;
 		if (epnum)
 			fotg210->ep0_data =
-				fotg210_is_epnstall(fotg210->ep[epnum])
-				<< USB_ENDPOINT_HALT;
+				cpu_to_le16(fotg210_is_epnstall(fotg210->ep[epnum])
+					    << USB_ENDPOINT_HALT);
 		else
 			fotg210_request_error(fotg210);
 		break;
-- 
2.35.1



