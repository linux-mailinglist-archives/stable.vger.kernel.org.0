Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23BC4CF5E3
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbiCGJbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237191AbiCGJaj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:30:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76D652E2;
        Mon,  7 Mar 2022 01:29:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E39DB810BF;
        Mon,  7 Mar 2022 09:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C82C340F3;
        Mon,  7 Mar 2022 09:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645349;
        bh=UDiUSxdVlF03zmyCAAJ1XdSqruRRjoof5WO0J5NUuMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCAxd2NX5Wh0HwoYbvRrUtnomkUTwrqwkMS5pbTONVcINyCgIHndz0IBNhCXGz8W8
         H97DJRNGR4ae9RTL7fKAoUzT4oWniWS7/oGJqs+phaBkYuPMgRtA2ciE/W3nQFxAVi
         ttStmJK+hym6uWqgPaivh4A8cKa5hK36yXXJJXvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 54/64] Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()
Date:   Mon,  7 Mar 2022 10:19:27 +0100
Message-Id: <20220307091640.685111676@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
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
@@ -139,55 +139,21 @@ static int elan_get_fwinfo(u16 ic_type,
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
 
@@ -1316,9 +1282,19 @@ static int __maybe_unused elan_suspend(s
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
@@ -1334,7 +1310,13 @@ static int __maybe_unused elan_resume(st
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


