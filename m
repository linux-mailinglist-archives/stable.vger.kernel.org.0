Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1F93D5FBB
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbhGZPTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:19:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236908AbhGZPRu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:17:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A1BB60F38;
        Mon, 26 Jul 2021 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315098;
        bh=MNJU0L+q1hKxulz/tW3QH2Fq+OigmEg6BfIJcrXGKtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ri4ykVhiYoZP9d6PXPYkS2VkWvh5N0nbwRaW6SIJa+iLRpCzrF2daEX+8kNobdv8P
         YKJZBK5hxZ6TJMFPthu1E72U14N6SKxyj/lVNeWXlNwUFim13UToI3oWp3J9w31sqX
         QLc5QqojxxZYDLcfpDY1AbhNVNRHQqfTxz8Uv0iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vincent Palatin <vpalatin@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/108] Revert "USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem"
Date:   Mon, 26 Jul 2021 17:39:02 +0200
Message-Id: <20210726153833.648811178@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Palatin <vpalatin@chromium.org>

[ Upstream commit f3a1a937f7b240be623d989c8553a6d01465d04f ]

This reverts commit 0bd860493f81eb2a46173f6f5e44cc38331c8dbd.

While the patch was working as stated,ie preventing the L850-GL LTE modem
from crashing on some U3 wake-ups due to a race condition between the
host wake-up and the modem-side wake-up, when using the MBIM interface,
this would force disabling the USB runtime PM on the device.

The increased power consumption is significant for LTE laptops,
and given that with decently recent modem firmwares, when the modem hits
the bug, it automatically recovers (ie it drops from the bus, but
automatically re-enumerates after less than half a second, rather than being
stuck until a power cycle as it was doing with ancient firmware), for
most people, the trade-off now seems in favor of re-enabling it by
default.

For people with access to the platform code, the bug can also be worked-around
successfully by changing the USB3 LFPM polling off-time for the XHCI
controller in the BIOS code.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
Link: https://lore.kernel.org/r/20210721092516.2775971-1-vpalatin@chromium.org
Fixes: 0bd860493f81 ("USB: quirks: ignore remote wake-up on Fibocom L850-GL LTE modem")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index f6a6c54cba35..d97544fd339b 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -502,10 +502,6 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* DJI CineSSD */
 	{ USB_DEVICE(0x2ca3, 0x0031), .driver_info = USB_QUIRK_NO_LPM },
 
-	/* Fibocom L850-GL LTE Modem */
-	{ USB_DEVICE(0x2cb7, 0x0007), .driver_info =
-			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
-
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
-- 
2.30.2



