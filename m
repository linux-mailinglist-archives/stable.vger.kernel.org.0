Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D02AD14B656
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgA1OES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728040AbgA1OEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:04:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FA4A205F4;
        Tue, 28 Jan 2020 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220255;
        bh=n8euAXScR1CSlqLFgVc19vSB9xLj+3ntt9IPjt/ZXH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1xIVkWPVNw8fJ2R1CwrQOx3GRVxWZjwnAcuDagxuhSPJQc+c6PopzaZgOw8uxhEmU
         SWd7jd5AH6FXy7dC28kZDSU52K+W2Pqi3dSUTEcYTlRpHd84Mca+BXJAMJ9hqJZw9Q
         3N73iuKeRmNGcRtnC2pm9hANZWG1zjhX1dG+0awg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gilles Buloz <gilles.buloz@kontron.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 077/104] hwmon: (nct7802) Fix non-working alarm on voltages
Date:   Tue, 28 Jan 2020 15:00:38 +0100
Message-Id: <20200128135827.867956742@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilles Buloz <gilles.buloz@kontron.com>

commit e51a7dda299815e92f43960d620cdfc8dfc144f2 upstream.

No alarm is reported by /sys/.../inX_alarm

In detail:

The SMI Voltage status register is the only register giving a status
for voltages, but it does not work like the non-SMI status registers
used for temperatures and fans.
A bit is set for each input crossing a threshold, in both direction,
but the "inside" or "outside" limits info is not available.
Also this register is cleared on read.
Note : this is not explicitly spelled out in the datasheet, but from
experiment.
As a result if an input is crossing a threshold (min or max in any
direction), the alarm is reported only once even if the input is
still outside limits. Also if the alarm for another input is read
before the one of this input, no alarm is reported at all.

Signed-off-by: Gilles Buloz <gilles.buloz@kontron.com>
Link: https://lore.kernel.org/r/5de0f566.tBga5POKAgHlmd0p%gilles.buloz@kontron.com
Fixes: 3434f3783580 ("hwmon: Driver for Nuvoton NCT7802Y")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/nct7802.c |   71 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 4 deletions(-)

--- a/drivers/hwmon/nct7802.c
+++ b/drivers/hwmon/nct7802.c
@@ -58,6 +58,8 @@ static const u8 REG_VOLTAGE_LIMIT_MSB_SH
 struct nct7802_data {
 	struct regmap *regmap;
 	struct mutex access_lock; /* for multi-byte read and write operations */
+	u8 in_status;
+	struct mutex in_alarm_lock;
 };
 
 static ssize_t temp_type_show(struct device *dev,
@@ -368,6 +370,66 @@ static ssize_t in_store(struct device *d
 	return err ? : count;
 }
 
+static ssize_t in_alarm_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct sensor_device_attribute_2 *sattr = to_sensor_dev_attr_2(attr);
+	struct nct7802_data *data = dev_get_drvdata(dev);
+	int volt, min, max, ret;
+	unsigned int val;
+
+	mutex_lock(&data->in_alarm_lock);
+
+	/*
+	 * The SMI Voltage status register is the only register giving a status
+	 * for voltages. A bit is set for each input crossing a threshold, in
+	 * both direction, but the "inside" or "outside" limits info is not
+	 * available. Also this register is cleared on read.
+	 * Note: this is not explicitly spelled out in the datasheet, but
+	 * from experiment.
+	 * To deal with this we use a status cache with one validity bit and
+	 * one status bit for each input. Validity is cleared at startup and
+	 * each time the register reports a change, and the status is processed
+	 * by software based on current input value and limits.
+	 */
+	ret = regmap_read(data->regmap, 0x1e, &val); /* SMI Voltage status */
+	if (ret < 0)
+		goto abort;
+
+	/* invalidate cached status for all inputs crossing a threshold */
+	data->in_status &= ~((val & 0x0f) << 4);
+
+	/* if cached status for requested input is invalid, update it */
+	if (!(data->in_status & (0x10 << sattr->index))) {
+		ret = nct7802_read_voltage(data, sattr->nr, 0);
+		if (ret < 0)
+			goto abort;
+		volt = ret;
+
+		ret = nct7802_read_voltage(data, sattr->nr, 1);
+		if (ret < 0)
+			goto abort;
+		min = ret;
+
+		ret = nct7802_read_voltage(data, sattr->nr, 2);
+		if (ret < 0)
+			goto abort;
+		max = ret;
+
+		if (volt < min || volt > max)
+			data->in_status |= (1 << sattr->index);
+		else
+			data->in_status &= ~(1 << sattr->index);
+
+		data->in_status |= 0x10 << sattr->index;
+	}
+
+	ret = sprintf(buf, "%u\n", !!(data->in_status & (1 << sattr->index)));
+abort:
+	mutex_unlock(&data->in_alarm_lock);
+	return ret;
+}
+
 static ssize_t temp_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
@@ -660,7 +722,7 @@ static const struct attribute_group nct7
 static SENSOR_DEVICE_ATTR_2_RO(in0_input, in, 0, 0);
 static SENSOR_DEVICE_ATTR_2_RW(in0_min, in, 0, 1);
 static SENSOR_DEVICE_ATTR_2_RW(in0_max, in, 0, 2);
-static SENSOR_DEVICE_ATTR_2_RO(in0_alarm, alarm, 0x1e, 3);
+static SENSOR_DEVICE_ATTR_2_RO(in0_alarm, in_alarm, 0, 3);
 static SENSOR_DEVICE_ATTR_2_RW(in0_beep, beep, 0x5a, 3);
 
 static SENSOR_DEVICE_ATTR_2_RO(in1_input, in, 1, 0);
@@ -668,19 +730,19 @@ static SENSOR_DEVICE_ATTR_2_RO(in1_input
 static SENSOR_DEVICE_ATTR_2_RO(in2_input, in, 2, 0);
 static SENSOR_DEVICE_ATTR_2_RW(in2_min, in, 2, 1);
 static SENSOR_DEVICE_ATTR_2_RW(in2_max, in, 2, 2);
-static SENSOR_DEVICE_ATTR_2_RO(in2_alarm, alarm, 0x1e, 0);
+static SENSOR_DEVICE_ATTR_2_RO(in2_alarm, in_alarm, 2, 0);
 static SENSOR_DEVICE_ATTR_2_RW(in2_beep, beep, 0x5a, 0);
 
 static SENSOR_DEVICE_ATTR_2_RO(in3_input, in, 3, 0);
 static SENSOR_DEVICE_ATTR_2_RW(in3_min, in, 3, 1);
 static SENSOR_DEVICE_ATTR_2_RW(in3_max, in, 3, 2);
-static SENSOR_DEVICE_ATTR_2_RO(in3_alarm, alarm, 0x1e, 1);
+static SENSOR_DEVICE_ATTR_2_RO(in3_alarm, in_alarm, 3, 1);
 static SENSOR_DEVICE_ATTR_2_RW(in3_beep, beep, 0x5a, 1);
 
 static SENSOR_DEVICE_ATTR_2_RO(in4_input, in, 4, 0);
 static SENSOR_DEVICE_ATTR_2_RW(in4_min, in, 4, 1);
 static SENSOR_DEVICE_ATTR_2_RW(in4_max, in, 4, 2);
-static SENSOR_DEVICE_ATTR_2_RO(in4_alarm, alarm, 0x1e, 2);
+static SENSOR_DEVICE_ATTR_2_RO(in4_alarm, in_alarm, 4, 2);
 static SENSOR_DEVICE_ATTR_2_RW(in4_beep, beep, 0x5a, 2);
 
 static struct attribute *nct7802_in_attrs[] = {
@@ -1011,6 +1073,7 @@ static int nct7802_probe(struct i2c_clie
 		return PTR_ERR(data->regmap);
 
 	mutex_init(&data->access_lock);
+	mutex_init(&data->in_alarm_lock);
 
 	ret = nct7802_init_chip(data);
 	if (ret < 0)


