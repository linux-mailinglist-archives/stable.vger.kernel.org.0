Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5A4C748C
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236778AbiB1Rpd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239298AbiB1Rn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A58C9D0CA;
        Mon, 28 Feb 2022 09:36:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 890D0B815BA;
        Mon, 28 Feb 2022 17:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81F1C340E7;
        Mon, 28 Feb 2022 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069765;
        bh=uCerF8BX4XGwIHz+tAyMMigidC2NZyRMn7ck9WmU0ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzbyMZ23fHmVGgVETgrGMRCveXNSwpgbVRWxL7dubO5MK8veJZqzy3X+RO8eRq/N7
         srqp+mPz8C8mxjrwlzAL9hTV+vCqiLeMUBW0pIfJ6Hck3moL6a7YYJvld6yqABf9+/
         sf0+aO7eCcxeTbU9fNwaolYqoE5Qa7Dgxvcqxg5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.10 61/80] USB: gadget: validate endpoint index for xilinx udc
Date:   Mon, 28 Feb 2022 18:24:42 +0100
Message-Id: <20220228172319.145029646@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172311.789892158@linuxfoundation.org>
References: <20220228172311.789892158@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Szymon Heidrich <szymon.heidrich@gmail.com>

commit 7f14c7227f342d9932f9b918893c8814f86d2a0d upstream.

Assure that host may not manipulate the index to point
past endpoint array.

Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/udc-xilinx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/gadget/udc/udc-xilinx.c
+++ b/drivers/usb/gadget/udc/udc-xilinx.c
@@ -1612,6 +1612,8 @@ static void xudc_getstatus(struct xusb_u
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = udc->setup.wIndex & USB_ENDPOINT_NUMBER_MASK;
+		if (epnum >= XUSB_MAX_ENDPOINTS)
+			goto stall;
 		target_ep = &udc->ep[epnum];
 		epcfgreg = udc->read_fn(udc->addr + target_ep->offset);
 		halt = epcfgreg & XUSB_EP_CFG_STALL_MASK;
@@ -1679,6 +1681,10 @@ static void xudc_set_clear_feature(struc
 	case USB_RECIP_ENDPOINT:
 		if (!udc->setup.wValue) {
 			endpoint = udc->setup.wIndex & USB_ENDPOINT_NUMBER_MASK;
+			if (endpoint >= XUSB_MAX_ENDPOINTS) {
+				xudc_ep0_stall(udc);
+				return;
+			}
 			target_ep = &udc->ep[endpoint];
 			outinbit = udc->setup.wIndex & USB_ENDPOINT_DIR_MASK;
 			outinbit = outinbit >> 7;


