Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5061A6675DE
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbjALO0r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237053AbjALOZ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:25:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B676E55677
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51E5A61F4A
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41546C433D2;
        Thu, 12 Jan 2023 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533028;
        bh=B6wX+t6GMFdV9GNaBgL5Qboch01ltcUnf44piY6YoCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzJKIBosTuSFItF3MLtKEjBK6SoPqrPPtV2M1u3Pe3U8kbVAhJ96iPjVbOH5hRNoO
         4S4jH7p3mYnbCkla/h0B0Uu7IpZm/11HxeB3ozwvzJ6FnxCc87NQbxDGOz4b9sMeLt
         HFJCAS+hICXTIJ6gBP1EeT3m7EeJGk4p2DkMFbio=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/783] usb: fotg210-udc: Fix ages old endianness issues
Date:   Thu, 12 Jan 2023 14:51:03 +0100
Message-Id: <20230112135540.404293419@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index 75bf446f4a66..11712bc89635 100644
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



