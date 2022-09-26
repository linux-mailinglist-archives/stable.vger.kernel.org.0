Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728245EA308
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237549AbiIZLSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbiIZLQx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:16:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A875C52DC6;
        Mon, 26 Sep 2022 03:37:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFF2260CF5;
        Mon, 26 Sep 2022 10:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EFEC433D6;
        Mon, 26 Sep 2022 10:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188565;
        bh=ifYjR/WTwrCGs42mM0GNKu0p7HZPfV0itO0aK/ChxgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cKKOXQj8mZBZxOSNp7wGSskDlg8LPYNY5spwUYxH3oxh9IuBKw4JnWG4u8PBYOlry
         JaHeXxfSkgpf3yYdav9ktqKvrluCTsss8FLLQKxY3cTNF03eVIdfbzpX1z1EZsXxtt
         62iGrd72uaEcyAvNWp+u92v87Zmh8DNvxe966vYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Piyush Mehta <piyush.mehta@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/148] Revert "usb: gadget: udc-xilinx: replace memcpy with memcpy_toio"
Date:   Mon, 26 Sep 2022 12:10:52 +0200
Message-Id: <20220926100756.752703331@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100756.074519146@linuxfoundation.org>
References: <20220926100756.074519146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit fe0a2ac7c627b064c479ad0c3b25e531d342e048 ]

This reverts commit 8cb339f1c1f04baede9d54c1e40ac96247a6393b as it
throws up a bunch of sparse warnings as reported by the kernel test
robot.

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/r/202209020044.CX2PfZzM-lkp@intel.com
Fixes: 8cb339f1c1f0 ("usb: gadget: udc-xilinx: replace memcpy with memcpy_toio")
Cc: stable@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Piyush Mehta <piyush.mehta@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/udc-xilinx.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/udc/udc-xilinx.c b/drivers/usb/gadget/udc/udc-xilinx.c
index 218d9423807a..9cf43731bcd1 100644
--- a/drivers/usb/gadget/udc/udc-xilinx.c
+++ b/drivers/usb/gadget/udc/udc-xilinx.c
@@ -496,11 +496,11 @@ static int xudc_eptxrx(struct xusb_ep *ep, struct xusb_req *req,
 		/* Get the Buffer address and copy the transmit data.*/
 		eprambase = (u32 __force *)(udc->addr + ep->rambase);
 		if (ep->is_in) {
-			memcpy_toio(eprambase, bufferptr, bytestosend);
+			memcpy(eprambase, bufferptr, bytestosend);
 			udc->write_fn(udc->addr, ep->offset +
 				      XUSB_EP_BUF0COUNT_OFFSET, bufferlen);
 		} else {
-			memcpy_toio(bufferptr, eprambase, bytestosend);
+			memcpy(bufferptr, eprambase, bytestosend);
 		}
 		/*
 		 * Enable the buffer for transmission.
@@ -514,11 +514,11 @@ static int xudc_eptxrx(struct xusb_ep *ep, struct xusb_req *req,
 		eprambase = (u32 __force *)(udc->addr + ep->rambase +
 			     ep->ep_usb.maxpacket);
 		if (ep->is_in) {
-			memcpy_toio(eprambase, bufferptr, bytestosend);
+			memcpy(eprambase, bufferptr, bytestosend);
 			udc->write_fn(udc->addr, ep->offset +
 				      XUSB_EP_BUF1COUNT_OFFSET, bufferlen);
 		} else {
-			memcpy_toio(bufferptr, eprambase, bytestosend);
+			memcpy(bufferptr, eprambase, bytestosend);
 		}
 		/*
 		 * Enable the buffer for transmission.
@@ -1020,7 +1020,7 @@ static int __xudc_ep0_queue(struct xusb_ep *ep0, struct xusb_req *req)
 			   udc->addr);
 		length = req->usb_req.actual = min_t(u32, length,
 						     EP0_MAX_PACKET);
-		memcpy_toio(corebuf, req->usb_req.buf, length);
+		memcpy(corebuf, req->usb_req.buf, length);
 		udc->write_fn(udc->addr, XUSB_EP_BUF0COUNT_OFFSET, length);
 		udc->write_fn(udc->addr, XUSB_BUFFREADY_OFFSET, 1);
 	} else {
@@ -1746,7 +1746,7 @@ static void xudc_handle_setup(struct xusb_udc *udc)
 
 	/* Load up the chapter 9 command buffer.*/
 	ep0rambase = (u32 __force *) (udc->addr + XUSB_SETUP_PKT_ADDR_OFFSET);
-	memcpy_toio(&setup, ep0rambase, 8);
+	memcpy(&setup, ep0rambase, 8);
 
 	udc->setup = setup;
 	udc->setup.wValue = cpu_to_le16(setup.wValue);
@@ -1833,7 +1833,7 @@ static void xudc_ep0_out(struct xusb_udc *udc)
 			     (ep0->rambase << 2));
 		buffer = req->usb_req.buf + req->usb_req.actual;
 		req->usb_req.actual = req->usb_req.actual + bytes_to_rx;
-		memcpy_toio(buffer, ep0rambase, bytes_to_rx);
+		memcpy(buffer, ep0rambase, bytes_to_rx);
 
 		if (req->usb_req.length == req->usb_req.actual) {
 			/* Data transfer completed get ready for Status stage */
@@ -1909,7 +1909,7 @@ static void xudc_ep0_in(struct xusb_udc *udc)
 				     (ep0->rambase << 2));
 			buffer = req->usb_req.buf + req->usb_req.actual;
 			req->usb_req.actual = req->usb_req.actual + length;
-			memcpy_toio(ep0rambase, buffer, length);
+			memcpy(ep0rambase, buffer, length);
 		}
 		udc->write_fn(udc->addr, XUSB_EP_BUF0COUNT_OFFSET, count);
 		udc->write_fn(udc->addr, XUSB_BUFFREADY_OFFSET, 1);
-- 
2.35.1



