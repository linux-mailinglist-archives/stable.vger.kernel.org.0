Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6859D4C7331
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237532AbiB1ReE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237555AbiB1Rcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:32:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69BC8BF3C;
        Mon, 28 Feb 2022 09:29:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C33D26135F;
        Mon, 28 Feb 2022 17:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D744CC340E7;
        Mon, 28 Feb 2022 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069359;
        bh=LC9GLPRNXxE7G7VL7b6l3jW0/NAL6RtstC9Wj+2iMi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7sG9Sdt+CDw5Z5ZpuCyRLnU9wJm7Lk/yk8v7TmLAt0xJPFzFBZUT7O5ALmLy45tQ
         1mdhTslK/S+8aqeWdWSKCL90X9p8VNvk9u6h0rrIPeHee4N7ILZAbZVx25YUI6PTlk
         27N9fZM6DcK2NJq+DONFi/NXzWlb3TLEvptNt0u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Szymon Heidrich <szymon.heidrich@gmail.com>,
        stable <stable@kernel.org>
Subject: [PATCH 4.19 26/34] USB: gadget: validate endpoint index for xilinx udc
Date:   Mon, 28 Feb 2022 18:24:32 +0100
Message-Id: <20220228172210.565401327@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
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
@@ -1613,6 +1613,8 @@ static void xudc_getstatus(struct xusb_u
 		break;
 	case USB_RECIP_ENDPOINT:
 		epnum = udc->setup.wIndex & USB_ENDPOINT_NUMBER_MASK;
+		if (epnum >= XUSB_MAX_ENDPOINTS)
+			goto stall;
 		target_ep = &udc->ep[epnum];
 		epcfgreg = udc->read_fn(udc->addr + target_ep->offset);
 		halt = epcfgreg & XUSB_EP_CFG_STALL_MASK;
@@ -1680,6 +1682,10 @@ static void xudc_set_clear_feature(struc
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


