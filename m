Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9323C5288
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243613AbhGLHq4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349823AbhGLHos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8DEF613BF;
        Mon, 12 Jul 2021 07:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075687;
        bh=ebzmUuZU3p4ooSnA9888JXX4EL3/ee/C4zDSG9vNCFo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIMU59lKBUrsWopVCFRzk3Tj+EQRcZAfC6PMcTpSRQ0Y8H/A3BKOqEj14FhUiYnQ9
         83/exbbrPuiWo4GpBsCfuI1+fVqLnPeOFdrN7tcVBdAy4WiI/rugq1lJTWHb1KDZ0w
         u6XJ0rJzofju99Uj8+YZlpZC3KLccKWd2//XtN2k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 320/800] hwmon: (pmbus/bpa-rs600) Handle Vin readings >= 256V
Date:   Mon, 12 Jul 2021 08:05:43 +0200
Message-Id: <20210712061000.048528747@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 6e9ef8ca687e69e9d4cc89033d98e06350b0f3e0 ]

The BPA-RS600 doesn't follow the PMBus spec for linear data.
Specifically it treats the mantissa as an unsigned 11-bit value instead
of a two's complement 11-bit value. At this point it's unclear whether
this only affects Vin or if Pin/Pout1 are affected as well. Erring on
the side of caution only Vin is dealt with here.

Fixes: 15b2703e5e02 ("hwmon: (pmbus) Add driver for BluTek BPA-RS600")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20210616034218.25821-1-chris.packham@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/bpa-rs600.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/hwmon/pmbus/bpa-rs600.c b/drivers/hwmon/pmbus/bpa-rs600.c
index f6558ee9dec3..2be69fedfa36 100644
--- a/drivers/hwmon/pmbus/bpa-rs600.c
+++ b/drivers/hwmon/pmbus/bpa-rs600.c
@@ -46,6 +46,32 @@ static int bpa_rs600_read_byte_data(struct i2c_client *client, int page, int reg
 	return ret;
 }
 
+/*
+ * The BPA-RS600 violates the PMBus spec. Specifically it treats the
+ * mantissa as unsigned. Deal with this here to allow the PMBus core
+ * to work with correctly encoded data.
+ */
+static int bpa_rs600_read_vin(struct i2c_client *client)
+{
+	int ret, exponent, mantissa;
+
+	ret = pmbus_read_word_data(client, 0, 0xff, PMBUS_READ_VIN);
+	if (ret < 0)
+		return ret;
+
+	if (ret & BIT(10)) {
+		exponent = ret >> 11;
+		mantissa = ret & 0x7ff;
+
+		exponent++;
+		mantissa >>= 1;
+
+		ret = (exponent << 11) | mantissa;
+	}
+
+	return ret;
+}
+
 static int bpa_rs600_read_word_data(struct i2c_client *client, int page, int phase, int reg)
 {
 	int ret;
@@ -85,6 +111,9 @@ static int bpa_rs600_read_word_data(struct i2c_client *client, int page, int pha
 		/* These commands return data but it is invalid/un-documented */
 		ret = -ENXIO;
 		break;
+	case PMBUS_READ_VIN:
+		ret = bpa_rs600_read_vin(client);
+		break;
 	default:
 		if (reg >= PMBUS_VIRT_BASE)
 			ret = -ENXIO;
-- 
2.30.2



