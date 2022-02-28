Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BAC4C75E7
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236442AbiB1R45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239656AbiB1RxR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:53:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4404AA2CC;
        Mon, 28 Feb 2022 09:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4A0761543;
        Mon, 28 Feb 2022 17:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A976DC340F1;
        Mon, 28 Feb 2022 17:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070045;
        bh=rzjIv3Y6uxvOnI6bDTKnF+WA7ReFM5LSD1pxUEbn0uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzDHxZxEkvWpxAsNHYnHBh+F95+rgQc61TAVYD2eM1kEEScZcLv/DkIq13evai/5F
         8kOLNMUHgsuQI4v6Epv5TkvHSDVdOBj3X7MOXuyGZPd3dUoRJLqlB8+IOUT4mSmTBY
         9VPdsoIa+0IK+dgK07W/Kfyj53T4u77oXGs7VQ9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Bagrii <dimich.dmb@gmail.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 105/139] Revert "USB: serial: ch341: add new Product ID for CH341A"
Date:   Mon, 28 Feb 2022 18:24:39 +0100
Message-Id: <20220228172358.709035674@linuxfoundation.org>
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


