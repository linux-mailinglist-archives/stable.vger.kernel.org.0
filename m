Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37DE41EA532
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 15:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgFANkr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 09:40:47 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40825 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgFANk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 09:40:29 -0400
Received: by mail-lj1-f196.google.com with SMTP id z13so8163846ljn.7;
        Mon, 01 Jun 2020 06:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9WLwaacWxVJgJAQUy6rPeyp9VmCZjz1WJ6juENBmuJI=;
        b=L7DfhdlbTpPGL9COo0M27WG8/lt1F6mLb4/oVZ45DzZDxQyGFP2OxXPVpdDzQvBL5Y
         4aE3T7+QwRBdsNnSPti8XzmhqU6PdsKGLPGhhJr3BBlRYrbHniPvlAFUC/yWRZDo+FCY
         uQr8EJA/CCtFcqIoPcbl5hzLpfbUvfPJDOAS5GizfV/TzqO9aE3v1X0TYISqdPMZfaT0
         Q3J+m6KnwciYi6hJyDj8bzvSngH2VD0Fp15tFUis0C8lSPll1hi1SzkH5GTU/+0oYqHS
         YRrSLUxw2niB7knH/cYBDcMzDuptHK2ujlG8Rgn3I6AdWVIe/aFpDtM6VSXH9m4/KHJk
         Zzvw==
X-Gm-Message-State: AOAM530vqS2N67sImi8i0dBts6V7u+n+Mg4zylInlqF8+tkDKMBxla20
        UQX5I5JHQ6hwCkccQL+1Lr4=
X-Google-Smtp-Source: ABdhPJxn833jupaamj8VbrnQIBjwbA4RDar5lOpXhyo1jksXZHcHMwIbMN6fnlhc5y6g4fEutsDj8g==
X-Received: by 2002:a2e:8144:: with SMTP id t4mr9937763ljg.412.1591018825203;
        Mon, 01 Jun 2020 06:40:25 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id 193sm2446783ljj.48.2020.06.01.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:40:23 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1jfkfp-0003Fj-4a; Mon, 01 Jun 2020 15:40:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc:     Dan Murphy <dmurphy@ti.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 2/6] leds: da903x: fix use-after-free on unbind
Date:   Mon,  1 Jun 2020 15:39:46 +0200
Message-Id: <20200601133950.12420-3-johan@kernel.org>
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

Fixes: eed16255d66b ("leds: da903x: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-da903x.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-da903x.c b/drivers/leds/leds-da903x.c
index ed1b303f699f..2b5fb00438a2 100644
--- a/drivers/leds/leds-da903x.c
+++ b/drivers/leds/leds-da903x.c
@@ -110,12 +110,23 @@ static int da903x_led_probe(struct platform_device *pdev)
 	led->flags = pdata->flags;
 	led->master = pdev->dev.parent;
 
-	ret = devm_led_classdev_register(led->master, &led->cdev);
+	ret = led_classdev_register(led->master, &led->cdev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register LED %d\n", id);
 		return ret;
 	}
 
+	platform_set_drvdata(pdev, led);
+
+	return 0;
+}
+
+static int da903x_led_remove(struct platform_device *pdev)
+{
+	struct da903x_led *led = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&led->cdev);
+
 	return 0;
 }
 
@@ -124,6 +135,7 @@ static struct platform_driver da903x_led_driver = {
 		.name	= "da903x-led",
 	},
 	.probe		= da903x_led_probe,
+	.remove		= da903x_led_remove,
 };
 
 module_platform_driver(da903x_led_driver);
-- 
2.26.2

