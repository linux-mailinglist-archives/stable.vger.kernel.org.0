Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8BC4989EF
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 19:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344094AbiAXS7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 13:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344502AbiAXS4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 13:56:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177ACC0612A9;
        Mon, 24 Jan 2022 10:54:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2EB614C9;
        Mon, 24 Jan 2022 18:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C64C340E5;
        Mon, 24 Jan 2022 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050469;
        bh=6tmTeqTNP3KBX1hcRrZiqO7BaY+kpbpNKJCvnuGuh6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XIkgAJ7frEyXAlx1PnY7TFiw3aQJv8Im+HB/nEce2CFxS/RvkCpb6bAgljwMrsqBY
         YOYv3ZyFi1NDGnr4n273EP5R8nnBIZMBhhJWBEj8CQxVSg/GPbL9/pexzDRMCyHfS0
         7XGgNkpzO265Z3/f97s8MUTp5cVihcBPCxqpH2l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 4.9 005/157] can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
Date:   Mon, 24 Jan 2022 19:41:35 +0100
Message-Id: <20220124183932.959124093@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
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


