Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3DB4C7575
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiB1RzG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239726AbiB1RxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B74AB45C;
        Mon, 28 Feb 2022 09:40:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6980B815B3;
        Mon, 28 Feb 2022 17:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA35C340F1;
        Mon, 28 Feb 2022 17:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070050;
        bh=uCerF8BX4XGwIHz+tAyMMigidC2NZyRMn7ck9WmU0ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JYwiOUvPp7KR4gir9LGF6R13Q5f/C2S1J3H4fx5jE0zHyBh6030X1/vd2gIiRnsK2
         hiduJtQmEvYn53qKh13uhO3NlonZI+6KYcT4DRgkianLa7x3r6QAv4cblCP5hIKZar
         0g2p6jXbDtv7AOGZ93X/09SD9wdy86RxnYeKSN+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 5.15 107/139] USB: gadget: validate endpoint index for xilinx udc
Date:   Mon, 28 Feb 2022 18:24:41 +0100
Message-Id: <20220228172358.911729878@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
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


