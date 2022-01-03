Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409A6483242
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbiACO0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:26:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233729AbiACOZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:25:50 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D907C061394;
        Mon,  3 Jan 2022 06:25:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80784CE1109;
        Mon,  3 Jan 2022 14:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BC7C36AED;
        Mon,  3 Jan 2022 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219946;
        bh=+2uNALVy1y7V2oFBo9fj5T5pKlUJG1LE2IJ16//QuEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s56ADg001TNgOja7m/unqz5H1IZXnsfN7xZ5urcVoFzXj3pztv5eSxRCnzcMIbsWe
         GWSxrYWK0OZgNhHkL6ZEA1MKoFXmDcIFVKpQ7+koMlWnZz83FBg0MICQ4Moeoo9wyr
         es5YuRE+XN45aHRBcHfzzB2FX41MpHwroLXPZEaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Leo L. Schwab" <ewhac@ewhac.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 26/27] Input: spaceball - fix parsing of movement data packets
Date:   Mon,  3 Jan 2022 15:24:06 +0100
Message-Id: <20220103142053.015139390@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo L. Schwab <ewhac@ewhac.org>

commit bc7ec91718c49d938849697cfad98fcd9877cc26 upstream.

The spaceball.c module was not properly parsing the movement reports
coming from the device.  The code read axis data as signed 16-bit
little-endian values starting at offset 2.

In fact, axis data in Spaceball movement reports are signed 16-bit
big-endian values starting at offset 3.  This was determined first by
visually inspecting the data packets, and later verified by consulting:
http://spacemice.org/pdf/SpaceBall_2003-3003_Protocol.pdf

If this ever worked properly, it was in the time before Git...

Signed-off-by: Leo L. Schwab <ewhac@ewhac.org>
Link: https://lore.kernel.org/r/20211221101630.1146385-1-ewhac@ewhac.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/spaceball.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/input/joystick/spaceball.c
+++ b/drivers/input/joystick/spaceball.c
@@ -31,6 +31,7 @@
 #include <linux/module.h>
 #include <linux/input.h>
 #include <linux/serio.h>
+#include <asm/unaligned.h>
 
 #define DRIVER_DESC	"SpaceTec SpaceBall 2003/3003/4000 FLX driver"
 
@@ -87,9 +88,15 @@ static void spaceball_process_packet(str
 
 		case 'D':					/* Ball data */
 			if (spaceball->idx != 15) return;
-			for (i = 0; i < 6; i++)
+			/*
+			 * Skip first three bytes; read six axes worth of data.
+			 * Axis values are signed 16-bit big-endian.
+			 */
+			data += 3;
+			for (i = 0; i < ARRAY_SIZE(spaceball_axes); i++) {
 				input_report_abs(dev, spaceball_axes[i],
-					(__s16)((data[2 * i + 3] << 8) | data[2 * i + 2]));
+					(__s16)get_unaligned_be16(&data[i * 2]));
+			}
 			break;
 
 		case 'K':					/* Button data */


