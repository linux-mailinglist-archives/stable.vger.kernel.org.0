Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0EB48E55A
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239533AbiANIRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiANIRc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:17:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0932C061749;
        Fri, 14 Jan 2022 00:17:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EDCA61E06;
        Fri, 14 Jan 2022 08:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57448C36AEA;
        Fri, 14 Jan 2022 08:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148251;
        bh=D2T5KC7pIMXthySgIcc1beZzlYUCQFmw4bhDOk5jX38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iALFba12P0Nr7+FG73FyMy265V3K4ayTNTh/Fn9+5PTRY0HipZqKy0QWroSXsvVjO
         ywXgJwv02Xm0cVAfNqWSBpm+rbC290GuzjFgEXOALd3BlH28mAQAa611BWP3JW5f8a
         5rftWXa1ESv+bemJ1ElWe1IQl0YkwlikuXkHKAJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.4 10/18] can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
Date:   Fri, 14 Jan 2022 09:16:17 +0100
Message-Id: <20220114081541.816823670@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081541.465841464@linuxfoundation.org>
References: <20220114081541.465841464@linuxfoundation.org>
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
@@ -320,7 +320,7 @@ static void gs_usb_receive_bulk_callback
 
 	/* device reports out of range channel id */
 	if (hf->channel >= GS_MAX_INTF)
-		goto resubmit_urb;
+		goto device_detach;
 
 	dev = usbcan->canch[hf->channel];
 
@@ -405,6 +405,7 @@ static void gs_usb_receive_bulk_callback
 
 	/* USB failure take down all interfaces */
 	if (rc == -ENODEV) {
+ device_detach:
 		for (rc = 0; rc < GS_MAX_INTF; rc++) {
 			if (usbcan->canch[rc])
 				netif_device_detach(usbcan->canch[rc]->netdev);


