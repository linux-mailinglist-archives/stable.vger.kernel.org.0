Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA9D473AFC
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404545AbfGXTzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404541AbfGXTzr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:55:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EBB622ADA;
        Wed, 24 Jul 2019 19:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998145;
        bh=vlTIogb9tzHAuBPAyMF4RNDmYm61QUR+7qMqccJAo1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nkxw5sCiMkC1/QOw2Oou89OY8WDjdZdsuYp+sVM0TBo8OxdBie64ZaLIsGft/37fE
         F5jIgqugq2UynMHedFF2ShjkJA5UTUTSo5lClHrZRolTHJJONG202EtvoCULX3pBmh
         hoFR8LQLH3Qd8VFDZ0wjowQCNgwTR8rXWTS5Te44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, XiaoXiao Liu <sliuuxiaonxiao@gmail.com>,
        Hui Wang <hui.wang@canonical.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.1 263/371] Input: alps - dont handle ALPS cs19 trackpoint-only device
Date:   Wed, 24 Jul 2019 21:20:15 +0200
Message-Id: <20190724191744.220827547@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit 7e4935ccc3236751e5fe4bd6846f86e46bb2e427 upstream.

On a latest Lenovo laptop, the trackpoint and 3 buttons below it
don't work at all, when we move the trackpoint or press those 3
buttons, the kernel will print out:
"Rejected trackstick packet from non DualPoint device"

This device is identified as an alps touchpad but the packet has
trackpoint format, so the alps.c drops the packet and prints out
the message above.

According to XiaoXiao's explanation, this device is named cs19 and
is trackpoint-only device, its firmware is only for trackpoint, it
is independent of touchpad and is a device completely different from
DualPoint ones.

To drive this device with mininal changes to the existing driver, we
just let the alps driver not handle this device, then the trackpoint.c
will be the driver of this device if the trackpoint driver is enabled.
(if not, this device will fallback to a bare PS/2 device)

With the trackpoint.c, this trackpoint and 3 buttons all work well,
they have all features that the trackpoint should have, like
scrolling-screen, drag-and-drop and frame-selection.

Signed-off-by: XiaoXiao Liu <sliuuxiaonxiao@gmail.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Reviewed-by: Pali Rohár <pali.rohar@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/alps.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -24,6 +24,7 @@
 
 #include "psmouse.h"
 #include "alps.h"
+#include "trackpoint.h"
 
 /*
  * Definitions for ALPS version 3 and 4 command mode protocol
@@ -2864,6 +2865,23 @@ static const struct alps_protocol_info *
 	return NULL;
 }
 
+static bool alps_is_cs19_trackpoint(struct psmouse *psmouse)
+{
+	u8 param[2] = { 0 };
+
+	if (ps2_command(&psmouse->ps2dev,
+			param, MAKE_PS2_CMD(0, 2, TP_READ_ID)))
+		return false;
+
+	/*
+	 * param[0] contains the trackpoint device variant_id while
+	 * param[1] contains the firmware_id. So far all alps
+	 * trackpoint-only devices have their variant_ids equal
+	 * TP_VARIANT_ALPS and their firmware_ids are in 0x20~0x2f range.
+	 */
+	return param[0] == TP_VARIANT_ALPS && (param[1] & 0x20);
+}
+
 static int alps_identify(struct psmouse *psmouse, struct alps_data *priv)
 {
 	const struct alps_protocol_info *protocol;
@@ -3165,6 +3183,20 @@ int alps_detect(struct psmouse *psmouse,
 		return error;
 
 	/*
+	 * ALPS cs19 is a trackpoint-only device, and uses different
+	 * protocol than DualPoint ones, so we return -EINVAL here and let
+	 * trackpoint.c drive this device. If the trackpoint driver is not
+	 * enabled, the device will fall back to a bare PS/2 mouse.
+	 * If ps2_command() fails here, we depend on the immediately
+	 * followed psmouse_reset() to reset the device to normal state.
+	 */
+	if (alps_is_cs19_trackpoint(psmouse)) {
+		psmouse_dbg(psmouse,
+			    "ALPS CS19 trackpoint-only device detected, ignoring\n");
+		return -EINVAL;
+	}
+
+	/*
 	 * Reset the device to make sure it is fully operational:
 	 * on some laptops, like certain Dell Latitudes, we may
 	 * fail to properly detect presence of trackstick if device


