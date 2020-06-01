Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBEEE1EA52D
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 15:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgFANkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 09:40:42 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:42587 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgFANk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 09:40:29 -0400
Received: by mail-lj1-f195.google.com with SMTP id u10so6932487ljj.9;
        Mon, 01 Jun 2020 06:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0DAbBQDRNyPwe9sfmFlSyawhkSS6P8nN029qVNCibc8=;
        b=Bo5cNG1t2d4wuY5d96RjMAs5Bs/gSg8dy2Q/XRY1Add6MV34ukk9vEJXjCcg39/aKJ
         6tug8jCx77S+u2JX1+HsDiEZ+gndjzO8cwF83GK1Ipu4MLJoXciUe2R8tMr/zdTrnSkn
         bpxSinFwjiOKnOZx/6XTzgfz9NN6mJVlZd3HFrP6wIEQ3MwquvKhNRsqxQ0OO9Fbzh+H
         bhqh2SNIgqWhg2hPBV8xUIXDj3zV4wDDnBIUssXv+U3/PFFTSd/c8hvBsXownr+/Hh6N
         IFE5i/bX/4hoFyO67m2MHF/8Ei4Ncp4yiwlqDxvPtDXbXcwf19RLVu3zNOtSzIedGjWI
         FE0Q==
X-Gm-Message-State: AOAM532TPIUy+5YYFIGW4MtdlRIeP6UgE32394sqMfaudW8zvOC9X+RI
        YbTFyqj4Rrb4Vs6kDchegmuSrQSh
X-Google-Smtp-Source: ABdhPJwKb6SZD3vuagiFT8tzEjSKsYXbndNniCfCAL5OD59Wxa40/IGR0iwEcX/VQ0EfhCh/0jEwzg==
X-Received: by 2002:a2e:a488:: with SMTP id h8mr7627530lji.359.1591018826919;
        Mon, 01 Jun 2020 06:40:26 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id x5sm3370363ljd.123.2020.06.01.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:40:25 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1jfkfp-0003Fy-ED; Mon, 01 Jun 2020 15:40:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc:     Dan Murphy <dmurphy@ti.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 5/6] leds: wm831x-status: fix use-after-free on unbind
Date:   Mon,  1 Jun 2020 15:39:49 +0200
Message-Id: <20200601133950.12420-6-johan@kernel.org>
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

Fixes: 8d3b6a4001ce ("leds: wm831x-status: Use devm_led_classdev_register")
Cc: stable <stable@vger.kernel.org>     # 4.6
Cc: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-wm831x-status.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-wm831x-status.c b/drivers/leds/leds-wm831x-status.c
index 082df7f1dd90..67f4235cb28a 100644
--- a/drivers/leds/leds-wm831x-status.c
+++ b/drivers/leds/leds-wm831x-status.c
@@ -269,12 +269,23 @@ static int wm831x_status_probe(struct platform_device *pdev)
 	drvdata->cdev.blink_set = wm831x_status_blink_set;
 	drvdata->cdev.groups = wm831x_status_groups;
 
-	ret = devm_led_classdev_register(wm831x->dev, &drvdata->cdev);
+	ret = led_classdev_register(wm831x->dev, &drvdata->cdev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register LED: %d\n", ret);
 		return ret;
 	}
 
+	platform_set_drvdata(pdev, drvdata);
+
+	return 0;
+}
+
+static int wm831x_status_remove(struct platform_device *pdev)
+{
+	struct wm831x_status *drvdata = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&drvdata->cdev);
+
 	return 0;
 }
 
@@ -283,6 +294,7 @@ static struct platform_driver wm831x_status_driver = {
 		   .name = "wm831x-status",
 		   },
 	.probe = wm831x_status_probe,
+	.remove = wm831x_status_remove,
 };
 
 module_platform_driver(wm831x_status_driver);
-- 
2.26.2

