Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB134B4650
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243923AbiBNJds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:33:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243768AbiBNJd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:33:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE87AE6D;
        Mon, 14 Feb 2022 01:32:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B9D960F87;
        Mon, 14 Feb 2022 09:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17E0C340E9;
        Mon, 14 Feb 2022 09:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831125;
        bh=PlvEcycpV1nvF2g388FL0znRyecBtkKmN44AHTvezXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGrJ4R3k9T7ujOkZr1SAZ7FaOMyo5ejt733EBC3ouX1Y2pWsC6VKDShVUj3eDpPWw
         cA17tqvDJpWGn2SIfLmQtvP6kGaYSV1a+SSQO94R7JtlhA2o2KFpUfJwxguSkJ28V9
         ReOIdbxv6yLSKkJepljnQyjdMfkj+YKjAe7vTgBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Stephan Brunner <s.brunner@stephan-brunner.net>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 39/44] USB: serial: ch341: add support for GW Instek USB2.0-Serial devices
Date:   Mon, 14 Feb 2022 10:26:02 +0100
Message-Id: <20220214092449.168749199@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092447.897544753@linuxfoundation.org>
References: <20220214092447.897544753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Brunner <s.brunner@stephan-brunner.net>

commit fa77ce201f7f2d823b07753575122d1ae5597fbe upstream.

Programmable lab power supplies made by GW Instek, such as the
GPP-2323, have a USB port exposing a serial port to control the device.

Stringing the supplied Windows driver, references to the ch341 chip are
found. Binding the existing ch341 driver to the VID/PID of the GPP-2323
("GW Instek USB2.0-Serial" as per the USB product name) works out of the
box, communication and control is now possible.

This patch should work with any GPP series power supply due to
similarities in the product line.

Signed-off-by: Stephan Brunner <s.brunner@stephan-brunner.net>
Link: https://lore.kernel.org/r/4a47b864-0816-6f6a-efee-aa20e74bcdc6@stephan-brunner.net
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -87,6 +87,7 @@ static const struct usb_device_id id_tab
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },
+	{ USB_DEVICE(0x2184, 0x0057) },
 	{ USB_DEVICE(0x4348, 0x5523) },
 	{ USB_DEVICE(0x9986, 0x7523) },
 	{ },


