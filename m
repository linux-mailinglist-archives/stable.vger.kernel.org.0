Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DFD2F9E84
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390364AbhARLmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:36424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390695AbhARLlK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:41:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33C8122D6D;
        Mon, 18 Jan 2021 11:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970051;
        bh=rJMieVPcvB55nuj0k8niIMD5AArTJ9Q5ufrlHNZziSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsYZ8AQtd9pFlSIE893g50491MMQJAaGhxEq1k/LlP3s/m+6Qo1ECb4WIolrWTAey
         mRx+4lom2elqCNGTQ5XtjcdHW6WYQQf4/VIWF40M9ChCkg3DM0UAGUXOLsXW8iUyml
         khbf/y2cmYWQrSyIBWjGrL7Rd2Xtkp+qAO7Pgm9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexandru Gagniuc <mr.nuke.me@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.10 017/152] drm/bridge: sii902x: Enable I/O and core VCC supplies if present
Date:   Mon, 18 Jan 2021 12:33:12 +0100
Message-Id: <20210118113353.603446289@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Gagniuc <mr.nuke.me@gmail.com>

commit cc5f7e2fcbe396f2f461cd67c872af771a334bca upstream.

On the SII9022, the IOVCC and CVCC12 supplies must reach the correct
voltage before the reset sequence is initiated. On most boards, this
assumption is true at boot-up, so initialization succeeds.

However, when we try to initialize the chip with incorrect supply
voltages, it will not respond to I2C requests. sii902x_probe() fails
with -ENXIO.

To resolve this, look for the "iovcc" and "cvcc12" regulators, and
make sure they are enabled before starting the reset sequence. If
these supplies are not available in devicetree, then they will default
to dummy-regulator. In that case everything will work like before.

This was observed on a STM32MP157C-DK2 booting in u-boot falcon mode.
On this board, the supplies would be set by the second stage
bootloader, which does not run in falcon mode.

Signed-off-by: Alexandru Gagniuc <mr.nuke.me@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
[Fix checkpatch warnings]
Link: https://patchwork.freedesktop.org/patch/msgid/20201020221501.260025-2-mr.nuke.me@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/bridge/sii902x.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/gpu/drm/bridge/sii902x.c
+++ b/drivers/gpu/drm/bridge/sii902x.c
@@ -17,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
+#include <linux/regulator/consumer.h>
 #include <linux/clk.h>
 
 #include <drm/drm_atomic_helper.h>
@@ -168,6 +169,7 @@ struct sii902x {
 	struct drm_connector connector;
 	struct gpio_desc *reset_gpio;
 	struct i2c_mux_core *i2cmux;
+	struct regulator_bulk_data supplies[2];
 	/*
 	 * Mutex protects audio and video functions from interfering
 	 * each other, by keeping their i2c command sequences atomic.
@@ -1049,7 +1051,26 @@ static int sii902x_probe(struct i2c_clie
 
 	mutex_init(&sii902x->mutex);
 
+	sii902x->supplies[0].supply = "iovcc";
+	sii902x->supplies[1].supply = "cvcc12";
+	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(sii902x->supplies),
+				      sii902x->supplies);
+	if (ret < 0)
+		return ret;
+
+	ret = regulator_bulk_enable(ARRAY_SIZE(sii902x->supplies),
+				    sii902x->supplies);
+	if (ret < 0) {
+		dev_err_probe(dev, ret, "Failed to enable supplies");
+		return ret;
+	}
+
 	ret = sii902x_init(sii902x);
+	if (ret < 0) {
+		regulator_bulk_disable(ARRAY_SIZE(sii902x->supplies),
+				       sii902x->supplies);
+	}
+
 	return ret;
 }
 
@@ -1060,6 +1081,8 @@ static int sii902x_remove(struct i2c_cli
 
 	i2c_mux_del_adapters(sii902x->i2cmux);
 	drm_bridge_remove(&sii902x->bridge);
+	regulator_bulk_disable(ARRAY_SIZE(sii902x->supplies),
+			       sii902x->supplies);
 
 	return 0;
 }


