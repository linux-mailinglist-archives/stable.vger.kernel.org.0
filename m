Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04771EA529
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 15:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbgFANk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 09:40:29 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33897 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgFANk2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 09:40:28 -0400
Received: by mail-lf1-f67.google.com with SMTP id e125so3959545lfd.1;
        Mon, 01 Jun 2020 06:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fdhJ6VWEx4je3P4tdqEsJkjBh1tquQqmuINBpODTZ4E=;
        b=ffVbXVURiNGbE3ttohHBaVGQ1GYWKgz+vL3tqb7g+dCspCA4bfpoNZWcBcuy5mAaLd
         EjITtDVFHkwzreoYygLI69LMSVP2LuBrNVLa8WZXnjCM+IDlH2G/b70QkuZNOlrxjwSH
         Y688RjNe5pLEJQr1FmLck6auPb3iYqAg+T4oeHoL5LP/kLyEC6RIfRHXFfaiJole/u6I
         IWOxckMu1B79e3SYVTdA6F/GwpWSs+wQSzv2sF+BkDEdvgL7LX5yj9ISd21+5k+Z6FH5
         I33KMmsx9ZXZssYKvm6kjpLZoxqcguD9iOPNYuQcSujf5hqVdmke+HEBRu60fwAfssTI
         jxfw==
X-Gm-Message-State: AOAM531XCOI3mAF79lAhyOgt5n89XonLBDH666tcJczRt3so6rZbxPg6
        BjtUdyewlbkdYwOUtnoSA+A=
X-Google-Smtp-Source: ABdhPJwAHvBtxCfTE/8M+bI1GpMJD4Vh3qudybO7U/9zvPSI45Xek4v88iHANywVIeJml8lvPIkbIg==
X-Received: by 2002:ac2:5df2:: with SMTP id z18mr11205121lfq.151.1591018825922;
        Mon, 01 Jun 2020 06:40:25 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id k22sm407124ljk.122.2020.06.01.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:40:23 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1jfkfp-0003Fp-7p; Mon, 01 Jun 2020 15:40:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc:     Dan Murphy <dmurphy@ti.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 3/6] leds: lm3533: fix use-after-free on unbind
Date:   Mon,  1 Jun 2020 15:39:47 +0200
Message-Id: <20200601133950.12420-4-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601133950.12420-1-johan@kernel.org>
References: <20200601133950.12420-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Several MFD child drivers register their class devices directly under
the parent device. This means you cannot blindly do devres conversions
so that deregistration ends up being tied to the parent device,
something which leads to use-after-free on driver unbind when the class
device is released while still being registered.

Fixes: 50154e29e5cc ("leds: lm3533: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-lm3533.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lm3533.c b/drivers/leds/leds-lm3533.c
index 9504ad405aef..b3edee703193 100644
--- a/drivers/leds/leds-lm3533.c
+++ b/drivers/leds/leds-lm3533.c
@@ -694,7 +694,7 @@ static int lm3533_led_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, led);
 
-	ret = devm_led_classdev_register(pdev->dev.parent, &led->cdev);
+	ret = led_classdev_register(pdev->dev.parent, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", pdev->id);
 		return ret;
@@ -704,13 +704,18 @@ static int lm3533_led_probe(struct platform_device *pdev)
 
 	ret = lm3533_led_setup(led, pdata);
 	if (ret)
-		return ret;
+		goto err_deregister;
 
 	ret = lm3533_ctrlbank_enable(&led->cb);
 	if (ret)
-		return ret;
+		goto err_deregister;
 
 	return 0;
+
+err_deregister:
+	led_classdev_unregister(&led->cdev);
+
+	return ret;
 }
 
 static int lm3533_led_remove(struct platform_device *pdev)
@@ -720,6 +725,7 @@ static int lm3533_led_remove(struct platform_device *pdev)
 	dev_dbg(&pdev->dev, "%s\n", __func__);
 
 	lm3533_ctrlbank_disable(&led->cb);
+	led_classdev_unregister(&led->cdev);
 
 	return 0;
 }
-- 
2.26.2

