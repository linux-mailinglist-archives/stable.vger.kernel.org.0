Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52E45498AAE
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344157AbiAXTGZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34454 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344264AbiAXTEJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:04:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFBFA60BB9;
        Mon, 24 Jan 2022 19:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA52CC340E5;
        Mon, 24 Jan 2022 19:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051047;
        bh=6tmTeqTNP3KBX1hcRrZiqO7BaY+kpbpNKJCvnuGuh6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sei37dZnb/b1cjnbP5FhLM4bBaJ5WSsb+paEDKgCHHcJwBBV5+FE3aLMxw5gx9phv
         ESQojyg1jypBF1XHOZJoLNPO+8CPuclC/1RrDGvKcUVAq9ycpEKXxOqEpCTTEsjF5D
         tYzrYMuM6fpgg7ygTJYxJPwSzQqDZU6/d34l3ehc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.14 005/186] can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
Date:   Mon, 24 Jan 2022 19:41:20 +0100
Message-Id: <20220124183937.289648163@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 4a8737ff068724f509d583fef404d349adba80d6 upstream.

The received data contains the channel the received data is associated
with. If the channel number is bigger than the actual number of
channels assume broken or malicious USB device and shut it down.

This fixes the error found by clang:

| drivers/net/can/usb/gs_usb.c:386:6: error: variable 'dev' is used
|                                     uninitialized whenever 'if' condition is true
|         if (hf->channel >= GS_MAX_INTF)
|             ^~~~~~~~~~~~~~~~~~~~~~~~~~
| drivers/net/can/usb/gs_usb.c:474:10: note: uninitialized use occurs here
|                           hf, dev->gs_hf_size, gs_usb_receive_bulk_callback,
|                               ^~~

Link: https://lore.kernel.org/all/20211210091158.408326-1-mkl@pengutronix.de
Fixes: d08e973a77d1 ("can: gs_usb: Added support for the GS_USB CAN devices")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/gs_usb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -328,7 +328,7 @@ static void gs_usb_receive_bulk_callback
 
 	/* device reports out of range channel id */
 	if (hf->channel >= GS_MAX_INTF)
-		goto resubmit_urb;
+		goto device_detach;
 
 	dev = usbcan->canch[hf->channel];
 
@@ -413,6 +413,7 @@ static void gs_usb_receive_bulk_callback
 
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
+ device_detach:
 		for (rc = 0; rc < GS_MAX_INTF; rc++) {
 			if (usbcan->canch[rc])
 				netif_device_detach(usbcan->canch[rc]->netdev);


