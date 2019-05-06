Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2404114DC3
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfEFOqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:46:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728838AbfEFOqX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:46:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 316422087F;
        Mon,  6 May 2019 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153982;
        bh=1kBE+NZDF6goqzCOP7Q49F98RCalj0qAKJg6qhzVuTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJVRvTy1uF9+p++Bmzm/h9WlZvTfKEa0uo3t4GgFKaDK4T/JeITW5B4hCOO9/3fYC
         ghayZmqBD9hqSaqipVFilUYriMdLHl4cILtXJ6AT3fZQ1r1b3FanF3T8GVZvuxEbWr
         NDc7LANissCubCjboAIbsaOLbtUGTIKnWp41h39E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Shyti <andi@etezian.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 69/75] Input: stmfts - acknowledge that setting brightness is a blocking call
Date:   Mon,  6 May 2019 16:33:17 +0200
Message-Id: <20190506143059.520111571@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 937c4e552fd1174784045684740edfcea536159d upstream.

We need to turn regulators on and off when switching brightness, and
that may block, therefore we have to set stmfts_brightness_set() as
LED's brightness_set_blocking() method.

Fixes: 78bcac7b2ae1 ("Input: add support for the STMicroelectronics FingerTip touchscreen")
Acked-by: Andi Shyti <andi@etezian.org>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/stmfts.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -111,27 +111,29 @@ struct stmfts_data {
 	bool running;
 };
 
-static void stmfts_brightness_set(struct led_classdev *led_cdev,
+static int stmfts_brightness_set(struct led_classdev *led_cdev,
 					enum led_brightness value)
 {
 	struct stmfts_data *sdata = container_of(led_cdev,
 					struct stmfts_data, led_cdev);
 	int err;
 
-	if (value == sdata->led_status || !sdata->ledvdd)
-		return;
-
-	if (!value) {
-		regulator_disable(sdata->ledvdd);
-	} else {
-		err = regulator_enable(sdata->ledvdd);
-		if (err)
-			dev_warn(&sdata->client->dev,
-				 "failed to disable ledvdd regulator: %d\n",
-				 err);
+	if (value != sdata->led_status && sdata->ledvdd) {
+		if (!value) {
+			regulator_disable(sdata->ledvdd);
+		} else {
+			err = regulator_enable(sdata->ledvdd);
+			if (err) {
+				dev_warn(&sdata->client->dev,
+					 "failed to disable ledvdd regulator: %d\n",
+					 err);
+				return err;
+			}
+		}
+		sdata->led_status = value;
 	}
 
-	sdata->led_status = value;
+	return 0;
 }
 
 static enum led_brightness stmfts_brightness_get(struct led_classdev *led_cdev)
@@ -613,7 +615,7 @@ static int stmfts_enable_led(struct stmf
 	sdata->led_cdev.name = STMFTS_DEV_NAME;
 	sdata->led_cdev.max_brightness = LED_ON;
 	sdata->led_cdev.brightness = LED_OFF;
-	sdata->led_cdev.brightness_set = stmfts_brightness_set;
+	sdata->led_cdev.brightness_set_blocking = stmfts_brightness_set;
 	sdata->led_cdev.brightness_get = stmfts_brightness_get;
 
 	err = devm_led_classdev_register(&sdata->client->dev, &sdata->led_cdev);


