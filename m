Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C921780B4
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733262AbgCCR6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:58:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:41116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733240AbgCCR6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50FF020728;
        Tue,  3 Mar 2020 17:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258298;
        bh=4fp9qbx9F3oLx3ltw+sBpkPbmOlFmAruNUKBp51xmhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yJ+oqrX+m90/r5Bz7BBDwlrDeH4gY0Xuufz+g0hSgp85DjPdNxI75O7LuE14m2Mvc
         c7pLvSmj8tXsZazOB9pAL0NJI00iMZ4n23kWKktEw/CsiZyHiYYJpvaNXTa3ETEABh
         ucJX27blWqCGyE2s+cnIZkyQjo3YhjoS6P2hODZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Markus Elfring <elfring@users.sourceforge.net>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>
Subject: [PATCH 5.4 131/152] pwm: omap-dmtimer: put_device() after of_find_device_by_node()
Date:   Tue,  3 Mar 2020 18:43:49 +0100
Message-Id: <20200303174317.693814746@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
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
@@ -256,7 +256,7 @@ static int pwm_omap_dmtimer_probe(struct
 	if (!timer_pdev) {
 		dev_err(&pdev->dev, "Unable to find Timer pdev\n");
 		ret = -ENODEV;
-		goto put;
+		goto err_find_timer_pdev;
 	}
 
 	timer_pdata = dev_get_platdata(&timer_pdev->dev);
@@ -264,7 +264,7 @@ static int pwm_omap_dmtimer_probe(struct
 		dev_dbg(&pdev->dev,
 			 "dmtimer pdata structure NULL, deferring probe\n");
 		ret = -EPROBE_DEFER;
-		goto put;
+		goto err_platdata;
 	}
 
 	pdata = timer_pdata->timer_ops;
@@ -283,19 +283,19 @@ static int pwm_omap_dmtimer_probe(struct
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
@@ -352,7 +352,14 @@ err_pwmchip_add:
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
@@ -372,6 +379,8 @@ static int pwm_omap_dmtimer_remove(struc
 
 	omap->pdata->free(omap->dm_timer);
 
+	put_device(&omap->dm_timer_pdev->dev);
+
 	mutex_destroy(&omap->mutex);
 
 	return 0;


