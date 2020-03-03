Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53D18178117
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387789AbgCCSAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:44382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387795AbgCCSAf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:00:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3310020656;
        Tue,  3 Mar 2020 18:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258433;
        bh=toAKJpVcK8AmIRqax8RohZ3VZLNcWfijpolDJB41s/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbQrGivbtaBzrfG7n4TFEUlS0tpg3jZiBZLdTLl34Edgc3sObqnwwSlCNKB26Y+EK
         7yp+yQk0Ed5Fie5dzYzbiUGkSJZJ+UJbkI2/L8IyMn8Jd/FXJ1nWSVYIfSsRzPUtz6
         hIhcSVLd9xrZKm4469Ve9C0UqwOgFLTWcZ5DH9Vw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erhard Furtner <erhard_f@mailbox.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Michael Ellerman <mpe@ellerman.id.au>, stable@kernel.org
Subject: [PATCH 4.19 47/87] macintosh: therm_windtunnel: fix regression when instantiating devices
Date:   Tue,  3 Mar 2020 18:43:38 +0100
Message-Id: <20200303174354.576969823@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa@the-dreams.de>

commit 38b17afb0ebb9ecd41418d3c08bcf9198af4349d upstream.

Removing attach_adapter from this driver caused a regression for at
least some machines. Those machines had the sensors described in their
DT, too, so they didn't need manual creation of the sensor devices. The
old code worked, though, because manual creation came first. Creation of
DT devices then failed later and caused error logs, but the sensors
worked nonetheless because of the manually created devices.

When removing attach_adaper, manual creation now comes later and loses
the race. The sensor devices were already registered via DT, yet with
another binding, so the driver could not be bound to it.

This fix refactors the code to remove the race and only manually creates
devices if there are no DT nodes present. Also, the DT binding is updated
to match both, the DT and manually created devices. Because we don't
know which device creation will be used at runtime, the code to start
the kthread is moved to do_probe() which will be called by both methods.

Fixes: 3e7bed52719d ("macintosh: therm_windtunnel: drop using attach_adapter")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=201723
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Tested-by: Erhard Furtner <erhard_f@mailbox.org>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Cc: stable@kernel.org # v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/macintosh/therm_windtunnel.c |   52 ++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 21 deletions(-)

--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -300,9 +300,11 @@ static int control_loop(void *dummy)
 /*	i2c probing and setup						*/
 /************************************************************************/
 
-static int
-do_attach( struct i2c_adapter *adapter )
+static void do_attach(struct i2c_adapter *adapter)
 {
+	struct i2c_board_info info = { };
+	struct device_node *np;
+
 	/* scan 0x48-0x4f (DS1775) and 0x2c-2x2f (ADM1030) */
 	static const unsigned short scan_ds1775[] = {
 		0x48, 0x49, 0x4a, 0x4b, 0x4c, 0x4d, 0x4e, 0x4f,
@@ -313,25 +315,24 @@ do_attach( struct i2c_adapter *adapter )
 		I2C_CLIENT_END
 	};
 
-	if( strncmp(adapter->name, "uni-n", 5) )
-		return 0;
-
-	if( !x.running ) {
-		struct i2c_board_info info;
+	if (x.running || strncmp(adapter->name, "uni-n", 5))
+		return;
 
-		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "therm_ds1775", I2C_NAME_SIZE);
+	np = of_find_compatible_node(adapter->dev.of_node, NULL, "MAC,ds1775");
+	if (np) {
+		of_node_put(np);
+	} else {
+		strlcpy(info.type, "MAC,ds1775", I2C_NAME_SIZE);
 		i2c_new_probed_device(adapter, &info, scan_ds1775, NULL);
+	}
 
-		strlcpy(info.type, "therm_adm1030", I2C_NAME_SIZE);
+	np = of_find_compatible_node(adapter->dev.of_node, NULL, "MAC,adm1030");
+	if (np) {
+		of_node_put(np);
+	} else {
+		strlcpy(info.type, "MAC,adm1030", I2C_NAME_SIZE);
 		i2c_new_probed_device(adapter, &info, scan_adm1030, NULL);
-
-		if( x.thermostat && x.fan ) {
-			x.running = 1;
-			x.poll_task = kthread_run(control_loop, NULL, "g4fand");
-		}
 	}
-	return 0;
 }
 
 static int
@@ -404,8 +405,8 @@ out:
 enum chip { ds1775, adm1030 };
 
 static const struct i2c_device_id therm_windtunnel_id[] = {
-	{ "therm_ds1775", ds1775 },
-	{ "therm_adm1030", adm1030 },
+	{ "MAC,ds1775", ds1775 },
+	{ "MAC,adm1030", adm1030 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, therm_windtunnel_id);
@@ -414,6 +415,7 @@ static int
 do_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct i2c_adapter *adapter = cl->adapter;
+	int ret = 0;
 
 	if( !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA
 				     | I2C_FUNC_SMBUS_WRITE_BYTE) )
@@ -421,11 +423,19 @@ do_probe(struct i2c_client *cl, const st
 
 	switch (id->driver_data) {
 	case adm1030:
-		return attach_fan( cl );
+		ret = attach_fan(cl);
+		break;
 	case ds1775:
-		return attach_thermostat(cl);
+		ret = attach_thermostat(cl);
+		break;
 	}
-	return 0;
+
+	if (!x.running && x.thermostat && x.fan) {
+		x.running = 1;
+		x.poll_task = kthread_run(control_loop, NULL, "g4fand");
+	}
+
+	return ret;
 }
 
 static struct i2c_driver g4fan_driver = {


