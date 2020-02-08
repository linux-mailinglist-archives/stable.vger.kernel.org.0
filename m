Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6B615670E
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbgBHS3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33436 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727530AbgBHS3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:32 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrD-0003aS-71; Sat, 08 Feb 2020 18:29:31 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrC-000CJT-01; Sat, 08 Feb 2020 18:29:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        "Janusz Krzysztofik" <jmkrzyszt@gmail.com>
Date:   Sat, 08 Feb 2020 18:19:13 +0000
Message-ID: <lsq.1581185940.839553487@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 014/148] media: ov6650: Fix stored frame format not
 in sync with hardware
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

commit 3143b459de4cdcce67b36827476c966e93c1cf01 upstream.

The driver stores frame format settings supposed to be in line with
hardware state in a device private structure.  Since the driver initial
submission, those settings are updated before they are actually applied
on hardware.  If an error occurs on device update, the stored settings
my not reflect hardware state anymore and consecutive calls to
.get_fmt() may return incorrect information.  That in turn may affect
ability of a bridge device to use correct DMA transfer settings if such
incorrect informmation on active frame format returned by .get_fmt() is
used.

Assuming a failed device update means its state hasn't changed, update
frame format related settings stored in the device private structure
only after they are successfully applied so the stored values always
reflect hardware state as closely as possible.

Fixes: 2f6e2404799a ("[media] SoC Camera: add driver for OV6650 sensor")
Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
[bwh: Backported to 3.16: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/media/i2c/soc_camera/ov6650.c
+++ b/drivers/media/i2c/soc_camera/ov6650.c
@@ -605,7 +605,6 @@ static int ov6650_s_fmt(struct v4l2_subd
 		dev_err(&client->dev, "Pixel format not handled: 0x%x\n", code);
 		return -EINVAL;
 	}
-	priv->code = code;
 
 	if (code == V4L2_MBUS_FMT_Y8_1X8 ||
 			code == V4L2_MBUS_FMT_SBGGR8_1X8) {
@@ -626,7 +625,6 @@ static int ov6650_s_fmt(struct v4l2_subd
 		dev_dbg(&client->dev, "max resolution: CIF\n");
 		coma_mask |= COMA_QCIF;
 	}
-	priv->half_scale = half_scale;
 
 	if (sense) {
 		if (sense->master_clock == 8000000) {
@@ -666,10 +664,14 @@ static int ov6650_s_fmt(struct v4l2_subd
 		ret = ov6650_reg_rmw(client, REG_COMA, coma_set, coma_mask);
 	if (!ret)
 		ret = ov6650_reg_write(client, REG_CLKRC, clkrc);
-	if (!ret)
+	if (!ret) {
+		priv->half_scale = half_scale;
+
 		ret = ov6650_reg_rmw(client, REG_COML, coml_set, coml_mask);
+	}
 
 	if (!ret) {
+		priv->code = code;
 		mf->width = priv->rect.width >> half_scale;
 		mf->height = priv->rect.height >> half_scale;
 	}

