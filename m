Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8944C747F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbiB1RpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239239AbiB1Rnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:43:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C468695A2D;
        Mon, 28 Feb 2022 09:36:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58AFF614CD;
        Mon, 28 Feb 2022 17:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B3CC340E7;
        Mon, 28 Feb 2022 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069759;
        bh=rzjIv3Y6uxvOnI6bDTKnF+WA7ReFM5LSD1pxUEbn0uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IrOXe58J1BRT9GBFuaZYZUaV40EeQkPpyaf/cvAlFcNmescUv/cc8aXAk6F2hPYr9
         ExVuBbRztgmqknApWz6yG5wphtnBcXUzUmtDOHNxhBeZSrVnS7dg+Nnxs8mB8XBdWi
         1yRR4FpODSwLUgkmHAm5WW2Vgdx26viqWgcm7tPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Bagrii <dimich.dmb@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 59/80] Revert "USB: serial: ch341: add new Product ID for CH341A"
Date:   Mon, 28 Feb 2022 18:24:40 +0100
Message-Id: <20220228172318.877750584@linuxfoundation.org>
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

From: Dmytro Bagrii <dimich.dmb@gmail.com>

commit 198a7ebd5fa17b4d0be8cb70240ee1be885175c0 upstream.

This reverts commit 46ee4abb10a07bd8f8ce910ee6b4ae6a947d7f63.

CH341 has Product ID 0x5512 in EPP/MEM mode which is used for
I2C/SPI/GPIO interfaces. In asynchronous serial interface mode
CH341 has PID 0x5523 which is already in the table.

Mode is selected by corresponding jumper setting.

Signed-off-by: Dmytro Bagrii <dimich.dmb@gmail.com>
Link: https://lore.kernel.org/r/20220210164137.4376-1-dimich.dmb@gmail.com
Link: https://lore.kernel.org/r/YJ0OCS/sh+1ifD/q@hovoldconsulting.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/ch341.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -81,7 +81,6 @@
 #define CH341_QUIRK_SIMULATE_BREAK	BIT(1)
 
 static const struct usb_device_id id_table[] = {
-	{ USB_DEVICE(0x1a86, 0x5512) },
 	{ USB_DEVICE(0x1a86, 0x5523) },
 	{ USB_DEVICE(0x1a86, 0x7522) },
 	{ USB_DEVICE(0x1a86, 0x7523) },


