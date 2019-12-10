Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108621196ED
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbfLJVJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:58968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbfLJVJx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD4E3246AF;
        Tue, 10 Dec 2019 21:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012192;
        bh=RY7/22cQdS0rro6ZXYKwL+zVZFVFfSfqinoLihuH4yI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W19lcYS8Vr0O4/QJC5SOil5QqDrt1R+xNj27gZgF6ipfOxpF9rSeqXhQoKScw1YuJ
         jY5EAOOtv4PnbRoiy3cufZbz0C3+sotlGUy3+U/I6EnQ6rbDm9CwPE6WafmNVDeGRR
         U8BQpGPOlyFPQc89maZJP8zJC2n7fCAGfIClcICA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 147/350] media: ov6650: Fix stored frame interval not in sync with hardware
Date:   Tue, 10 Dec 2019 16:04:12 -0500
Message-Id: <20191210210735.9077-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 43c3f1b6e19ac..a5b2448c0abc2 100644
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

