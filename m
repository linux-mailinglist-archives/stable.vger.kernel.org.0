Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E609912C7EE
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbfL2Rs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731453AbfL2Rs1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:48:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5E25206A4;
        Sun, 29 Dec 2019 17:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641706;
        bh=nmMR0qkPFrzbwGfUGnfYm5/E5+nndTK1u7MkBFUqGjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GH+VbaXq6192YlLqgRMRkUqEMfKicLY6e23aK7chzSiqnMXQEOWlifq5URsVmZH+x
         UBn7wKhRCQXoF8iVylwFU7z2ObGLK4AhxnOMBvkGgkw+JhKXbrh88v8mKnicenqEWe
         KvG1PrEF4BPYlfSLeCDVMtqmpHv/aQ1j21c1Pfc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 176/434] media: ov6650: Fix stored frame interval not in sync with hardware
Date:   Sun, 29 Dec 2019 18:23:49 +0100
Message-Id: <20191229172713.502378790@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Janusz Krzysztofik <jmkrzyszt@gmail.com>

[ Upstream commit 57822068dd120386b98891cb151dc20107b63ba7 ]

The driver stores a frame interval value supposed to be in line with
hardware state in a device private structure.  Since the driver initial
submission, the respective field of the structure has never been
initialised on device probe.  Moreover, if updated from
.s_frame_interval(), a new value is stored before it is applied on
hardware.  If an error occurs during device update, the stored value
may no longer reflect hardware state and consecutive calls to
.g_frame_interval() may return incorrect information.

Assuming a failed update of the device means its actual state hasn't
changed, update the frame interval field of the device private
structure with a new value only after it is successfully applied on
hardware so it always reflects actual hardware state to the extent
possible.  Also, initialise the field with hardware default frame
interval on device probe.

Signed-off-by: Janusz Krzysztofik <jmkrzyszt@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov6650.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 43c3f1b6e19a..a5b2448c0abc 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -130,6 +130,7 @@
 #define CLKRC_24MHz		0xc0
 #define CLKRC_DIV_MASK		0x3f
 #define GET_CLKRC_DIV(x)	(((x) & CLKRC_DIV_MASK) + 1)
+#define DEF_CLKRC		0x00
 
 #define COMA_RESET		BIT(7)
 #define COMA_QCIF		BIT(5)
@@ -758,19 +759,17 @@ static int ov6650_s_frame_interval(struct v4l2_subdev *sd,
 	else if (div > GET_CLKRC_DIV(CLKRC_DIV_MASK))
 		div = GET_CLKRC_DIV(CLKRC_DIV_MASK);
 
-	/*
-	 * Keep result to be used as tpf limit
-	 * for subsequent clock divider calculations
-	 */
-	priv->tpf.numerator = div;
-	priv->tpf.denominator = FRAME_RATE_MAX;
+	tpf->numerator = div;
+	tpf->denominator = FRAME_RATE_MAX;
 
-	clkrc = to_clkrc(&priv->tpf, priv->pclk_limit, priv->pclk_max);
+	clkrc = to_clkrc(tpf, priv->pclk_limit, priv->pclk_max);
 
 	ret = ov6650_reg_rmw(client, REG_CLKRC, clkrc, CLKRC_DIV_MASK);
 	if (!ret) {
-		tpf->numerator = GET_CLKRC_DIV(clkrc);
-		tpf->denominator = FRAME_RATE_MAX;
+		priv->tpf.numerator = GET_CLKRC_DIV(clkrc);
+		priv->tpf.denominator = FRAME_RATE_MAX;
+
+		*tpf = priv->tpf;
 	}
 
 	return ret;
@@ -1011,6 +1010,10 @@ static int ov6650_probe(struct i2c_client *client,
 	priv->code	  = MEDIA_BUS_FMT_YUYV8_2X8;
 	priv->colorspace  = V4L2_COLORSPACE_JPEG;
 
+	/* Hardware default frame interval */
+	priv->tpf.numerator   = GET_CLKRC_DIV(DEF_CLKRC);
+	priv->tpf.denominator = FRAME_RATE_MAX;
+
 	priv->subdev.internal_ops = &ov6650_internal_ops;
 
 	ret = v4l2_async_register_subdev(&priv->subdev);
-- 
2.20.1



