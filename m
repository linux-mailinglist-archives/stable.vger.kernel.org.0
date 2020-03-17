Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BAC188113
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgCQLME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728987AbgCQLMD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:12:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEC2620658;
        Tue, 17 Mar 2020 11:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443523;
        bh=lW/xQPDNx9Rchc5aT/oz1voqUYIyuWyVlYk7rkwx3L0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cA+EuLj4ZqRxgprvQ+a4pXe2JwJEFGm7QsSw1JhWANPP6xeotMF7s10oCRgtdFZXw
         NQLZTsmKVi+a61nnqjxpGaMsPvHyXnk3lit7Ct57ysc1aBeQAeWUwvH1SoqLcqPR4A
         aFMDWSKYtHB4b/130GG5yQgLD9RG4FGvhhaShR4w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@kernel.org
Subject: [PATCH 5.5 111/151] macintosh: windfarm: fix MODINFO regression
Date:   Tue, 17 Mar 2020 11:55:21 +0100
Message-Id: <20200317103334.343358605@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>

commit bcf3588d8ed3517e6ffaf083f034812aee9dc8e2 upstream.

Commit af503716ac14 made sure OF devices get an OF style modalias with
I2C events. It assumed all in-tree users were converted, yet it missed
some Macintosh drivers.

Add an OF module device table for all windfarm drivers to make them
automatically load again.

Fixes: af503716ac14 ("i2c: core: report OF style module alias for devices registered via OF")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=199471
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org # v4.17+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/macintosh/windfarm_ad7417_sensor.c  |    7 +++++++
 drivers/macintosh/windfarm_fcu_controls.c   |    7 +++++++
 drivers/macintosh/windfarm_lm75_sensor.c    |   16 +++++++++++++++-
 drivers/macintosh/windfarm_lm87_sensor.c    |    7 +++++++
 drivers/macintosh/windfarm_max6690_sensor.c |    7 +++++++
 drivers/macintosh/windfarm_smu_sat.c        |    7 +++++++
 6 files changed, 50 insertions(+), 1 deletion(-)

--- a/drivers/macintosh/windfarm_ad7417_sensor.c
+++ b/drivers/macintosh/windfarm_ad7417_sensor.c
@@ -312,9 +312,16 @@ static const struct i2c_device_id wf_ad7
 };
 MODULE_DEVICE_TABLE(i2c, wf_ad7417_id);
 
+static const struct of_device_id wf_ad7417_of_id[] = {
+	{ .compatible = "ad7417", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wf_ad7417_of_id);
+
 static struct i2c_driver wf_ad7417_driver = {
 	.driver = {
 		.name	= "wf_ad7417",
+		.of_match_table = wf_ad7417_of_id,
 	},
 	.probe		= wf_ad7417_probe,
 	.remove		= wf_ad7417_remove,
--- a/drivers/macintosh/windfarm_fcu_controls.c
+++ b/drivers/macintosh/windfarm_fcu_controls.c
@@ -580,9 +580,16 @@ static const struct i2c_device_id wf_fcu
 };
 MODULE_DEVICE_TABLE(i2c, wf_fcu_id);
 
+static const struct of_device_id wf_fcu_of_id[] = {
+	{ .compatible = "fcu", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wf_fcu_of_id);
+
 static struct i2c_driver wf_fcu_driver = {
 	.driver = {
 		.name	= "wf_fcu",
+		.of_match_table = wf_fcu_of_id,
 	},
 	.probe		= wf_fcu_probe,
 	.remove		= wf_fcu_remove,
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/i2c.h>
+#include <linux/of_device.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
@@ -91,9 +92,14 @@ static int wf_lm75_probe(struct i2c_clie
 			 const struct i2c_device_id *id)
 {	
 	struct wf_lm75_sensor *lm;
-	int rc, ds1775 = id->driver_data;
+	int rc, ds1775;
 	const char *name, *loc;
 
+	if (id)
+		ds1775 = id->driver_data;
+	else
+		ds1775 = !!of_device_get_match_data(&client->dev);
+
 	DBG("wf_lm75: creating  %s device at address 0x%02x\n",
 	    ds1775 ? "ds1775" : "lm75", client->addr);
 
@@ -164,9 +170,17 @@ static const struct i2c_device_id wf_lm7
 };
 MODULE_DEVICE_TABLE(i2c, wf_lm75_id);
 
+static const struct of_device_id wf_lm75_of_id[] = {
+	{ .compatible = "lm75", .data = (void *)0},
+	{ .compatible = "ds1775", .data = (void *)1 },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wf_lm75_of_id);
+
 static struct i2c_driver wf_lm75_driver = {
 	.driver = {
 		.name	= "wf_lm75",
+		.of_match_table = wf_lm75_of_id,
 	},
 	.probe		= wf_lm75_probe,
 	.remove		= wf_lm75_remove,
--- a/drivers/macintosh/windfarm_lm87_sensor.c
+++ b/drivers/macintosh/windfarm_lm87_sensor.c
@@ -166,9 +166,16 @@ static const struct i2c_device_id wf_lm8
 };
 MODULE_DEVICE_TABLE(i2c, wf_lm87_id);
 
+static const struct of_device_id wf_lm87_of_id[] = {
+	{ .compatible = "lm87cimt", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wf_lm87_of_id);
+
 static struct i2c_driver wf_lm87_driver = {
 	.driver = {
 		.name	= "wf_lm87",
+		.of_match_table = wf_lm87_of_id,
 	},
 	.probe		= wf_lm87_probe,
 	.remove		= wf_lm87_remove,
--- a/drivers/macintosh/windfarm_max6690_sensor.c
+++ b/drivers/macintosh/windfarm_max6690_sensor.c
@@ -120,9 +120,16 @@ static const struct i2c_device_id wf_max
 };
 MODULE_DEVICE_TABLE(i2c, wf_max6690_id);
 
+static const struct of_device_id wf_max6690_of_id[] = {
+	{ .compatible = "max6690", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wf_max6690_of_id);
+
 static struct i2c_driver wf_max6690_driver = {
 	.driver = {
 		.name		= "wf_max6690",
+		.of_match_table = wf_max6690_of_id,
 	},
 	.probe		= wf_max6690_probe,
 	.remove		= wf_max6690_remove,
--- a/drivers/macintosh/windfarm_smu_sat.c
+++ b/drivers/macintosh/windfarm_smu_sat.c
@@ -341,9 +341,16 @@ static const struct i2c_device_id wf_sat
 };
 MODULE_DEVICE_TABLE(i2c, wf_sat_id);
 
+static const struct of_device_id wf_sat_of_id[] = {
+	{ .compatible = "smu-sat", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, wf_sat_of_id);
+
 static struct i2c_driver wf_sat_driver = {
 	.driver = {
 		.name		= "wf_smu_sat",
+		.of_match_table = wf_sat_of_id,
 	},
 	.probe		= wf_sat_probe,
 	.remove		= wf_sat_remove,


