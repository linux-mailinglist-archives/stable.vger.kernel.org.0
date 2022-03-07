Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390404CF604
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbiCGJbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237433AbiCGJ2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B79868F95;
        Mon,  7 Mar 2022 01:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96B6461140;
        Mon,  7 Mar 2022 09:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED7FC340F3;
        Mon,  7 Mar 2022 09:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645121;
        bh=jtwMzeNb78knVTbeNrlFvDJhAnF3KLfvN0mUgzlUg0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzWScMgAr1Dr8Hpg0OVaz5yDbXGWh7Vh6cI9vhAtoOFfWj+tN4H+atuYxJbZiPDvt
         3FyOLORru5dXgTf0tuqqCdI/2cspI8UFtcyn1lwsq4ItVkFcbFALka1ilZlkCGt29N
         snxWf3ard2aVrs+R3WjrqPznpwdSjrGwtfVS0FCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 45/51] Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()
Date:   Mon,  7 Mar 2022 10:19:20 +0100
Message-Id: <20220307091638.272215684@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.988950823@linuxfoundation.org>
References: <20220307091636.988950823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 81a36d8ce554b82b0a08e2b95d0bd44fcbff339b upstream.

elan_disable_power() is called conditionally on suspend, where as
elan_enable_power() is always called on resume. This leads to
an imbalance in the regulator's enable count.

Move the regulator_[en|dis]able() calls out of elan_[en|dis]able_power()
in preparation of fixing this.

No functional changes intended.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220131135436.29638-1-hdegoede@redhat.com
[dtor: consolidate elan_[en|dis]able() into elan_set_power()]
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/elan_i2c_core.c |   62 ++++++++++++------------------------
 1 file changed, 22 insertions(+), 40 deletions(-)

--- a/drivers/input/mouse/elan_i2c_core.c
+++ b/drivers/input/mouse/elan_i2c_core.c
@@ -140,55 +140,21 @@ static int elan_get_fwinfo(u16 ic_type,
 	return 0;
 }
 
-static int elan_enable_power(struct elan_tp_data *data)
+static int elan_set_power(struct elan_tp_data *data, bool on)
 {
 	int repeat = ETP_RETRY_COUNT;
 	int error;
 
-	error = regulator_enable(data->vcc);
-	if (error) {
-		dev_err(&data->client->dev,
-			"failed to enable regulator: %d\n", error);
-		return error;
-	}
-
 	do {
-		error = data->ops->power_control(data->client, true);
+		error = data->ops->power_control(data->client, on);
 		if (error >= 0)
 			return 0;
 
 		msleep(30);
 	} while (--repeat > 0);
 
-	dev_err(&data->client->dev, "failed to enable power: %d\n", error);
-	return error;
-}
-
-static int elan_disable_power(struct elan_tp_data *data)
-{
-	int repeat = ETP_RETRY_COUNT;
-	int error;
-
-	do {
-		error = data->ops->power_control(data->client, false);
-		if (!error) {
-			error = regulator_disable(data->vcc);
-			if (error) {
-				dev_err(&data->client->dev,
-					"failed to disable regulator: %d\n",
-					error);
-				/* Attempt to power the chip back up */
-				data->ops->power_control(data->client, true);
-				break;
-			}
-
-			return 0;
-		}
-
-		msleep(30);
-	} while (--repeat > 0);
-
-	dev_err(&data->client->dev, "failed to disable power: %d\n", error);
+	dev_err(&data->client->dev, "failed to set power %s: %d\n",
+		on ? "on" : "off", error);
 	return error;
 }
 
@@ -1291,9 +1257,19 @@ static int __maybe_unused elan_suspend(s
 		/* Enable wake from IRQ */
 		data->irq_wake = (enable_irq_wake(client->irq) == 0);
 	} else {
-		ret = elan_disable_power(data);
+		ret = elan_set_power(data, false);
+		if (ret)
+			goto err;
+
+		ret = regulator_disable(data->vcc);
+		if (ret) {
+			dev_err(dev, "error %d disabling regulator\n", ret);
+			/* Attempt to power the chip back up */
+			elan_set_power(data, true);
+		}
 	}
 
+err:
 	mutex_unlock(&data->sysfs_mutex);
 	return ret;
 }
@@ -1309,7 +1285,13 @@ static int __maybe_unused elan_resume(st
 		data->irq_wake = false;
 	}
 
-	error = elan_enable_power(data);
+	error = regulator_enable(data->vcc);
+	if (error) {
+		dev_err(dev, "error %d enabling regulator\n", error);
+		goto err;
+	}
+
+	error = elan_set_power(data, true);
 	if (error) {
 		dev_err(dev, "power up when resuming failed: %d\n", error);
 		goto err;


