Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B0E3C4730
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235868AbhGLGbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235063AbhGLGaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B33326101E;
        Mon, 12 Jul 2021 06:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071287;
        bh=E/hl9tQ8Ht2iK89ka7D2AObl062lU/WuuUpZ92XqVMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSNhxQOFSHZojkx/FPSdUhsybCCNvB/xK2De31y1YBI3arZRZK3Ff8o+o+NmU8ToD
         SR5btV/wqJRr5pttP0CajP2mqKZU4aQ579S6mxjpy4AQd9H2AXZye42hmMzTissThA
         yJu0ouUwAwbbyxk/+e7ZHAH3hI1l4wgcaVCRx7KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 347/348] mmc: vub3000: fix control-request direction
Date:   Mon, 12 Jul 2021 08:12:11 +0200
Message-Id: <20210712060750.184330755@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3c0bb3107703d2c58f7a0a7a2060bb57bc120326 upstream.

The direction of the pipe argument must match the request-type direction
bit or control requests may fail depending on the host-controller-driver
implementation.

Fix the SET_ROM_WAIT_STATES request which erroneously used
usb_rcvctrlpipe().

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Cc: stable@vger.kernel.org      # 3.0
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210521133026.17296-1-johan@kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/vub300.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -2286,7 +2286,7 @@ static int vub300_probe(struct usb_inter
 	if (retval < 0)
 		goto error5;
 	retval =
-		usb_control_msg(vub300->udev, usb_rcvctrlpipe(vub300->udev, 0),
+		usb_control_msg(vub300->udev, usb_sndctrlpipe(vub300->udev, 0),
 				SET_ROM_WAIT_STATES,
 				USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				firmware_rom_wait_states, 0x0000, NULL, 0, HZ);


