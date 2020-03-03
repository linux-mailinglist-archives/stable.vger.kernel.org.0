Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E21B178189
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731984AbgCCSDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:03:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388080AbgCCSBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:01:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80FEB2072D;
        Tue,  3 Mar 2020 18:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258512;
        bh=TJRLZVqpjrDKwuU1vo4afdslkSMUlhhhwY6hrgN7a3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8CUET52wLudwI2Dxt64XHFhFR4o2a0RubVlAgKZBy5yf3tnLimF5vLe3lPkFQeMY
         t5Z/4cNTF29z+i5rQ/fUR4heeu3UKGBRj7p0PrsENemqUmg5wobSLTY8dfyR+beNNP
         6ddcHkvmfkcki8r/PE55xBvJkL+aXKNo8X8q0n5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Elfring <elfring@users.sourceforge.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 4.19 78/87] pwm: omap-dmtimer: put_device() after of_find_device_by_node()
Date:   Tue,  3 Mar 2020 18:44:09 +0100
Message-Id: <20200303174357.270372755@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit c7cb3a1dd53f63c64fb2b567d0be130b92a44d91 upstream.

This was found by coccicheck:

	drivers/pwm/pwm-omap-dmtimer.c:304:2-8: ERROR: missing put_device;
	call of_find_device_by_node on line 255, but without a corresponding
	object release within this function.

Reported-by: Markus Elfring <elfring@users.sourceforge.net>
Fixes: 6604c6556db9 ("pwm: Add PWM driver for OMAP using dual-mode timers")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/pwm-omap-dmtimer.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/pwm/pwm-omap-dmtimer.c
+++ b/drivers/pwm/pwm-omap-dmtimer.c
@@ -259,7 +259,7 @@ static int pwm_omap_dmtimer_probe(struct
 	if (!timer_pdev) {
 		dev_err(&pdev->dev, "Unable to find Timer pdev\n");
 		ret = -ENODEV;
-		goto put;
+		goto err_find_timer_pdev;
 	}
 
 	timer_pdata = dev_get_platdata(&timer_pdev->dev);
@@ -267,7 +267,7 @@ static int pwm_omap_dmtimer_probe(struct
 		dev_dbg(&pdev->dev,
 			 "dmtimer pdata structure NULL, deferring probe\n");
 		ret = -EPROBE_DEFER;
-		goto put;
+		goto err_platdata;
 	}
 
 	pdata = timer_pdata->timer_ops;
@@ -286,19 +286,19 @@ static int pwm_omap_dmtimer_probe(struct
 	    !pdata->write_counter) {
 		dev_err(&pdev->dev, "Incomplete dmtimer pdata structure\n");
 		ret = -EINVAL;
-		goto put;
+		goto err_platdata;
 	}
 
 	if (!of_get_property(timer, "ti,timer-pwm", NULL)) {
 		dev_err(&pdev->dev, "Missing ti,timer-pwm capability\n");
 		ret = -ENODEV;
-		goto put;
+		goto err_timer_property;
 	}
 
 	dm_timer = pdata->request_by_node(timer);
 	if (!dm_timer) {
 		ret = -EPROBE_DEFER;
-		goto put;
+		goto err_request_timer;
 	}
 
 	omap = devm_kzalloc(&pdev->dev, sizeof(*omap), GFP_KERNEL);
@@ -355,7 +355,14 @@ err_pwmchip_add:
 err_alloc_omap:
 
 	pdata->free(dm_timer);
-put:
+err_request_timer:
+
+err_timer_property:
+err_platdata:
+
+	put_device(&timer_pdev->dev);
+err_find_timer_pdev:
+
 	of_node_put(timer);
 
 	return ret;
@@ -375,6 +382,8 @@ static int pwm_omap_dmtimer_remove(struc
 
 	omap->pdata->free(omap->dm_timer);
 
+	put_device(&omap->dm_timer_pdev->dev);
+
 	mutex_destroy(&omap->mutex);
 
 	return 0;


