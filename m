Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE8D368468
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 18:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236583AbhDVQKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 12:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhDVQKL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 12:10:11 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB24C06174A;
        Thu, 22 Apr 2021 09:09:36 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n10so12626589plc.0;
        Thu, 22 Apr 2021 09:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O+kc4mJNMwcVlHeeaZq20dPDAxDPgMNPRCiAotcbYBA=;
        b=Y1IYZOPJN9mwNDW9Eq7XW1Ayj8MTRsDPcq86Cl3k+zeK3IjdLQ1FswbWEhWeYcmQ65
         +qKjh99A1AIhrRfzn6jffRUPubxkyFaxSUopoM/mqNMnJTn08MqezRAfu6One+gW2HbB
         5l2+oVdRPeBjUtiS11RuagyqQpT/jWxeh5zSMuQTPbn497T7FFtFX2lZKJpw/K64RON5
         UopfQqirqxX7ZAMj0gZ40oGhuFAO5GaU2fhYmb2TrT6Nw6VB/NzXxF1+22XMwfp3smML
         sALnHPBu2Zu63iH6VXzgsAVsiZW6X3i8yDhq71zabFqzBUNReGuv5EoN2oiPKoMQajnl
         m1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O+kc4mJNMwcVlHeeaZq20dPDAxDPgMNPRCiAotcbYBA=;
        b=rO/KlnbYWesD4ToDgVSdhuzqHV4WIdE0lbD7JyopabB5Uxto3K+ted7bCzWM8MASaS
         Q7CdAGLCX0jCoelmZ6g60c6CrZDLCkKvkbjB69sBMlxKN8bou2R96eDv9NIdl/tDG3Qb
         XkpOV0ESn7v9q6CoU748TrzwBQKVjavHtrtcw539AbQXCdWLBbjygawICF35bUCQa5mZ
         vXsD+Sjj0St9G1oJKyWTi+g8DKbuJ3vfp+OKTOoR1lOS1I+xj+Rk7gX34cSjvj+nlDEE
         85YyMkHJi0BCaQzMa4ueadUx6hCZAeLD9s4KjAO2hFojW9Yon0rzqFbdg/8XPy4FxXgb
         Retw==
X-Gm-Message-State: AOAM533sqBIEe+TwEzvg01bhMDwIfkFxvfUbNkXnZfJ1sL4lyybhqmS7
        jL6unc1Cqd04BrrMNcqEabw=
X-Google-Smtp-Source: ABdhPJw0/ANuer1v5o3im1PnTtZ/nXHS61mXtQzzskO/Y4COCHoCkzJGvtmmMYbcBz1LoQqe/EABMg==
X-Received: by 2002:a17:903:1cf:b029:e8:c4ca:be6d with SMTP id e15-20020a17090301cfb02900e8c4cabe6dmr4241196plh.39.1619107776339;
        Thu, 22 Apr 2021 09:09:36 -0700 (PDT)
Received: from localhost.localdomain ([171.61.238.200])
        by smtp.gmail.com with ESMTPSA id y189sm2355713pfy.8.2021.04.22.09.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 09:09:35 -0700 (PDT)
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     mchehab@kernel.org
Cc:     skhan@linuxfoundation.org, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Atul Gopinathan <atulgopinathan@gmail.com>,
        stable@vger.kernel.org,
        syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
Subject: [PATCH] media: gspca: stv06xx: Fix memleak in stv06xx subdrivers
Date:   Thu, 22 Apr 2021 21:37:42 +0530
Message-Id: <20210422160742.7166-1-atulgopinathan@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During probing phase of a gspca driver in "gspca_dev_probe2()", the
stv06xx subdrivers have certain sensor variants (namely, hdcs_1x00,
hdcs_1020 and pb_0100) that allocate memory for their respective sensor
which is passed to the "sd->sensor_priv" field. During the same probe
routine, after "sensor_priv" allocation, there are chances of later
functions invoked to fail which result in the probing routine to end
immediately via "goto out" path. While doing so, the memory allocated
earlier for the sensor isn't taken care of resulting in memory leak.

Fix this by adding operations to the gspca, stv06xx and down to the
sensor levels to free this allocated memory during gspca probe failure.

-
The current level of hierarchy looks something like this:

	gspca (main driver) represented by struct gspca_dev
	   |
___________|_____________________________________
|	|	|	|	|		| (subdrivers)
			|			  represented
 			stv06xx			  by "struct sd"
			|
 	 _______________|_______________
 	 |	|	|	|	|  (sensors)
	 	|			|
 		hdcs_1x00/1020		pb01000
			|_________________|
				|
			These three sensor variants
			allocate memory for
			"sd->sensor_priv" field.

Here, "struct gspca_dev" is the representation used in the top level. In
the sub-driver levels, "gspca_dev" pointer is cast to "struct sd*",
something like this:

	struct sd *sd = (struct sd *)gspca_dev;

This is possible because the first field of "struct sd" is "gspca_dev":

	struct sd {
		struct gspca_dev;
		.
		.
	}

Therefore, to deallocate the "sd->sensor_priv" fields from
"gspca_dev_probe2()" which is at the top level, the patch creates
operations for the subdrivers and sensors to be invoked from the gspca
driver levels. These operations essentially free the "sd->sensor_priv"
which were allocated by the "config" and "init_controls" operations in
the case of stv06xx sub-drivers and the sensor levels.

This patch doesn't affect other sub-drivers or even sensors who never
allocate memory to "sensor_priv". It has also been tested by syzbot and
it returned an "OK" result.

https://syzkaller.appspot.com/bug?id=ab69427f2911374e5f0b347d0d7795bfe384016c
-

Fixes: 4c98834addfe ("V4L/DVB (10048): gspca - stv06xx: New subdriver.")
Cc: stable@vger.kernel.org
Suggested-by: Shuah Khan <skhan@linuxfoundation.org>
Reported-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
Tested-by: syzbot+990626a4ef6f043ed4cd@syzkaller.appspotmail.com
Signed-off-by: Atul Gopinathan <atulgopinathan@gmail.com>
---
 drivers/media/usb/gspca/gspca.c                  |  2 ++
 drivers/media/usb/gspca/gspca.h                  |  1 +
 drivers/media/usb/gspca/stv06xx/stv06xx.c        | 15 +++++++++++++++
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c   |  9 +++++++++
 drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h   |  3 +++
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c |  9 +++++++++
 drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h |  2 ++
 drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h |  3 +++
 8 files changed, 44 insertions(+)

diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 158c8e28ed2c..88298d9f604d 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1577,6 +1577,8 @@ int gspca_dev_probe2(struct usb_interface *intf,
 	v4l2_ctrl_handler_free(gspca_dev->vdev.ctrl_handler);
 	v4l2_device_unregister(&gspca_dev->v4l2_dev);
 	kfree(gspca_dev->usb_buf);
+	if (sd_desc->free_sensor_priv)
+		sd_desc->free_sensor_priv(gspca_dev);
 	kfree(gspca_dev);
 	return ret;
 }
diff --git a/drivers/media/usb/gspca/gspca.h b/drivers/media/usb/gspca/gspca.h
index b0ced2e14006..792f19307b91 100644
--- a/drivers/media/usb/gspca/gspca.h
+++ b/drivers/media/usb/gspca/gspca.h
@@ -119,6 +119,7 @@ struct sd_desc {
 	cam_streamparm_op set_streamparm;
 	cam_format_op try_fmt;
 	cam_frmsize_op enum_framesizes;
+	cam_op free_sensor_priv;
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	cam_set_reg_op set_register;
 	cam_get_reg_op get_register;
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
index 95673fc0a99c..de1daeb1a03c 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
@@ -529,6 +529,8 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
 static int stv06xx_config(struct gspca_dev *gspca_dev,
 			  const struct usb_device_id *id);
 
+static int stv06xx_free_sensor_priv(struct gspca_dev *gspca_dev);
+
 /* sub-driver description */
 static const struct sd_desc sd_desc = {
 	.name = MODULE_NAME,
@@ -540,6 +542,7 @@ static const struct sd_desc sd_desc = {
 	.pkt_scan = stv06xx_pkt_scan,
 	.isoc_init = stv06xx_isoc_init,
 	.isoc_nego = stv06xx_isoc_nego,
+	.free_sensor_priv = stv06xx_free_sensor_priv,
 #if IS_ENABLED(CONFIG_INPUT)
 	.int_pkt_scan = sd_int_pkt_scan,
 #endif
@@ -583,7 +586,19 @@ static int stv06xx_config(struct gspca_dev *gspca_dev,
 	return -ENODEV;
 }
 
+/*
+ * Free the memory allocated to sd->sensor_priv field during initial phases of
+ * gspca (probe/init_control) which later encountered error in the same phase.
+ */
+static int stv06xx_free_sensor_priv(struct gspca_dev *gspca_dev)
+{
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (sd->sensor->free_sensor_priv)
+		sd->sensor->free_sensor_priv(sd);
 
+	return 0;
+}
 
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] = {
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
index 5a47dcbf1c8e..50b7a80a855a 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.c
@@ -529,3 +529,12 @@ static int hdcs_dump(struct sd *sd)
 	}
 	return 0;
 }
+
+static int hdcs_deallocate(struct sd *sd)
+{
+	struct hdcs *hdcs = sd->sensor_priv;
+
+	kfree(hdcs);
+	sd->sensor_priv = NULL;
+	return 0;
+}
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h
index 326a6eb68237..482e1a8e9a3b 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_hdcs.h
@@ -121,6 +121,7 @@ static int hdcs_init(struct sd *sd);
 static int hdcs_init_controls(struct sd *sd);
 static int hdcs_stop(struct sd *sd);
 static int hdcs_dump(struct sd *sd);
+static int hdcs_deallocate(struct sd *sd);
 
 static int hdcs_set_exposure(struct gspca_dev *gspca_dev, __s32 val);
 static int hdcs_set_gain(struct gspca_dev *gspca_dev, __s32 val);
@@ -142,6 +143,7 @@ const struct stv06xx_sensor stv06xx_sensor_hdcs1x00 = {
 	.start = hdcs_start,
 	.stop = hdcs_stop,
 	.dump = hdcs_dump,
+	.free_sensor_priv = hdcs_deallocate,
 };
 
 const struct stv06xx_sensor stv06xx_sensor_hdcs1020 = {
@@ -161,6 +163,7 @@ const struct stv06xx_sensor stv06xx_sensor_hdcs1020 = {
 	.start = hdcs_start,
 	.stop = hdcs_stop,
 	.dump = hdcs_dump,
+	.free_sensor_priv = hdcs_deallocate,
 };
 
 static const u16 stv_bridge_init[][2] = {
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
index ae382b3b5f7f..97ea886698c1 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c
@@ -318,6 +318,15 @@ static int pb0100_dump(struct sd *sd)
 	return 0;
 }
 
+static int pb0100_free_ctrls(struct sd *sd)
+{
+	struct pb0100_ctrls *ctrls = sd->sensor_priv;
+
+	kfree(ctrls);
+	sd->sensor_priv = NULL;
+	return 0;
+}
+
 static int pb0100_set_gain(struct gspca_dev *gspca_dev, __s32 val)
 {
 	int err;
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h
index c5a6614577de..12ec207f6bfa 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.h
@@ -102,6 +102,7 @@ static int pb0100_init(struct sd *sd);
 static int pb0100_init_controls(struct sd *sd);
 static int pb0100_stop(struct sd *sd);
 static int pb0100_dump(struct sd *sd);
+static int pb0100_free_ctrls(struct sd *sd);
 
 /* V4L2 controls supported by the driver */
 static int pb0100_set_gain(struct gspca_dev *gspca_dev, __s32 val);
@@ -126,6 +127,7 @@ const struct stv06xx_sensor stv06xx_sensor_pb0100 = {
 	.start = pb0100_start,
 	.stop = pb0100_stop,
 	.dump = pb0100_dump,
+	.free_sensor_priv = pb0100_free_ctrls,
 };
 
 #endif
diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h b/drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h
index 67c13c689b9c..22c75c528331 100644
--- a/drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h
+++ b/drivers/media/usb/gspca/stv06xx/stv06xx_sensor.h
@@ -69,6 +69,9 @@ struct stv06xx_sensor {
 
 	/* Instructs the sensor to dump all its contents */
 	int (*dump)(struct sd *sd);
+
+	/* Frees sensor_priv field during initial gspca probe errors */
+	int (*free_sensor_priv)(struct sd *sd);
 };
 
 #endif
-- 
2.25.1

