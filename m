Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39AF26173D
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbfGGTqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:46:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56996 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727495AbfGGTiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:04 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz2-0006f2-VM; Sun, 07 Jul 2019 20:38:01 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz1-0005YW-D0; Sun, 07 Jul 2019 20:37:59 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jacopo Mondi" <jacopo+renesas@jmondi.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.203969553@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 028/129] media: v4l2: i2c: ov7670: Fix PLL bypass
 register values
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

commit 61da76beef1e4f0b6ba7be4f8d0cf0dac7ce1f55 upstream.

The following commits:
commit f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")
commit 04ee6d92047e ("[media] media: ov7670: add possibility to bypass pll for ov7675")
introduced the ability to bypass PLL multiplier and use input clock (xvclk)
as pixel clock output frequency for ov7675 sensor.

PLL is bypassed using register DBLV[7:6], according to ov7670 and ov7675
sensor manuals. Macros used to set DBLV register seem wrong in the
driver, as their values do not match what reported in the datasheet.

Fix by changing DBLV_* macros to use bits [7:6] and set bits [3:0] to
default 0x0a reserved value (according to datasheets).

While at there, remove a write to DBLV register in
"ov7675_set_framerate()" that over-writes the previous one to the same
register that takes "info->pll_bypass" flag into account instead of setting PLL
multiplier to 4x unconditionally.

And, while at there, since "info->pll_bypass" is only used in
set/get_framerate() functions used by ov7675 only, it is not necessary
to check for the device id at probe time to make sure that when using
ov7670 "info->pll_bypass" is set to false.

Fixes: f6dd927f34d6 ("[media] media: ov7670: calculate framerate properly for ov7675")

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/i2c/ov7670.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -167,10 +167,10 @@ MODULE_PARM_DESC(debug, "Debug level (0-
 #define REG_GFIX	0x69	/* Fix gain control */
 
 #define REG_DBLV	0x6b	/* PLL control an debugging */
-#define   DBLV_BYPASS	  0x00	  /* Bypass PLL */
-#define   DBLV_X4	  0x01	  /* clock x4 */
-#define   DBLV_X6	  0x10	  /* clock x6 */
-#define   DBLV_X8	  0x11	  /* clock x8 */
+#define   DBLV_BYPASS	  0x0a	  /* Bypass PLL */
+#define   DBLV_X4	  0x4a	  /* clock x4 */
+#define   DBLV_X6	  0x8a	  /* clock x6 */
+#define   DBLV_X8	  0xca	  /* clock x8 */
 
 #define REG_REG76	0x76	/* OV's name */
 #define   R76_BLKPCOR	  0x80	  /* Black pixel correction enable */
@@ -845,7 +845,7 @@ static int ov7675_set_framerate(struct v
 	if (ret < 0)
 		return ret;
 
-	return ov7670_write(sd, REG_DBLV, DBLV_X4);
+	return 0;
 }
 
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
@@ -1552,11 +1552,7 @@ static int ov7670_probe(struct i2c_clien
 		if (config->clock_speed)
 			info->clock_speed = config->clock_speed;
 
-		/*
-		 * It should be allowed for ov7670 too when it is migrated to
-		 * the new frame rate formula.
-		 */
-		if (config->pll_bypass && id->driver_data != MODEL_OV7670)
+		if (config->pll_bypass)
 			info->pll_bypass = true;
 
 		if (config->pclk_hb_disable)

