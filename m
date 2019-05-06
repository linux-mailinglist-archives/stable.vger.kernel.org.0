Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFA214DAA
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfEFOqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728182AbfEFOqm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12D9220C01;
        Mon,  6 May 2019 14:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154001;
        bh=sHy/FoXKHRlDm12wEPwDLFBNoQwXGl5GzK/ulLVo4Qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XAeOa06Y9zRLo+2DFBuHT+c+SQRC3d2pKh1r49y2xM0OEyjVRFfap1W0Ks7Sr+U8t
         NYePu7UGP2Y0k+LSimvkemJ0MuOneEHE1ACyKkrcB34+dIbqPk3fWXq4OtKfk6k6J6
         jXoU+jXTIW/0QladpVedSev1baLcxyizxZmHEynY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 4.14 75/75] media: v4l2: i2c: ov7670: Fix PLL bypass register values
Date:   Mon,  6 May 2019 16:33:23 +0200
Message-Id: <20190506143100.156710696@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143053.287515952@linuxfoundation.org>
References: <20190506143053.287515952@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/ov7670.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -158,10 +158,10 @@ MODULE_PARM_DESC(debug, "Debug level (0-
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
@@ -837,7 +837,7 @@ static int ov7675_set_framerate(struct v
 	if (ret < 0)
 		return ret;
 
-	return ov7670_write(sd, REG_DBLV, DBLV_X4);
+	return 0;
 }
 
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
@@ -1601,11 +1601,7 @@ static int ov7670_probe(struct i2c_clien
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


