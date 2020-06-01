Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D971EA535
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 15:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727953AbgFANk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 09:40:56 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41172 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbgFANk1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 09:40:27 -0400
Received: by mail-lj1-f196.google.com with SMTP id 9so6713421ljc.8;
        Mon, 01 Jun 2020 06:40:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p8HfJKXte+/vUD+uOPGuKLv8QTkTUqBjgyWkHyXWfLc=;
        b=Xdd4cr4pvHjRiM1VbDNRVb67sotqLDE2RIo/cA9HW+y+dOx8kC1V5pyVD4qfBNFrOz
         eecKxT9XzuQshkUMKNNmwPVf6AJ9xyPLIRFc7YXblPORprsaPag84lc7QBXce2hudA52
         QouacqOV25Mdseyl2gmgWYNGTg7Anv8O58+cx0nb9YW7+5WNiTJCoPyS5aWmAjvB5xag
         aOojP28otSxTS5BEuDGC0I3UrxAPcJkH+qNpyQwDkGo/hM0PIlm8u1/bXTAt80/SdDXC
         P/CO5COX2eWUDSvlG3FK8Lp0xmzZ3jeMaWvzgq9Z0eZosTGQO2AK41XN1k6WyY202nkE
         4Lmw==
X-Gm-Message-State: AOAM530A59SUUW585EEa231XKl+al3an+2HtOZa/ivol8AX/vo2all2a
        1aX6uKGqqUKXEWylFOyEDxM=
X-Google-Smtp-Source: ABdhPJypzFNCi9I9ZNF5CUH9dJi8WirZXzmy1CKrwunn6Q0sC7/+JBDI6bu7vShJW/hX3Wjsaepw5Q==
X-Received: by 2002:a2e:b0f9:: with SMTP id h25mr11127603ljl.18.1591018824848;
        Mon, 01 Jun 2020 06:40:24 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id t4sm4818597ljo.36.2020.06.01.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:40:23 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1jfkfp-0003Ff-1K; Mon, 01 Jun 2020 15:40:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc:     Dan Murphy <dmurphy@ti.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/6] leds: 88pm860x: fix use-after-free on unbind
Date:   Mon,  1 Jun 2020 15:39:45 +0200
Message-Id: <20200601133950.12420-2-johan@kernel.org>
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

Fixes: 375446df95ee ("leds: 88pm860x: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-88pm860x.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-88pm860x.c b/drivers/leds/leds-88pm860x.c
index b3044c9a8120..465c3755cf2e 100644
--- a/drivers/leds/leds-88pm860x.c
+++ b/drivers/leds/leds-88pm860x.c
@@ -203,21 +203,33 @@ static int pm860x_led_probe(struct platform_device *pdev)
 	data->cdev.brightness_set_blocking = pm860x_led_set;
 	mutex_init(&data->lock);
 
-	ret = devm_led_classdev_register(chip->dev, &data->cdev);
+	ret = led_classdev_register(chip->dev, &data->cdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
 		return ret;
 	}
 	pm860x_led_set(&data->cdev, 0);
+
+	platform_set_drvdata(pdev, data);
+
 	return 0;
 }
 
+static int pm860x_led_remove(struct platform_device *pdev)
+{
+	struct pm860x_led *data = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&data->cdev);
+
+	return 0;
+}
 
 static struct platform_driver pm860x_led_driver = {
 	.driver	= {
 		.name	= "88pm860x-led",
 	},
 	.probe	= pm860x_led_probe,
+	.remove	= pm860x_led_remove,
 };
 
 module_platform_driver(pm860x_led_driver);
-- 
2.26.2

