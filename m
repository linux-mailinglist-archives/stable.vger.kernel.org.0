Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA1E1EA52A
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 15:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgFANka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 09:40:30 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:32780 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbgFANk3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 09:40:29 -0400
Received: by mail-lj1-f194.google.com with SMTP id s1so8196025ljo.0;
        Mon, 01 Jun 2020 06:40:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xogX+/HMn9VwXk21eS3NybTvvt+scM3zuXM4cDsVR1I=;
        b=HshcVNguOZDyN9ZBfB7eavMcVcxHG950L2j5dSpSxZVCOUHMnDeTW2cSl1C+OKkUPj
         On/F9AA0xg6mflmETNO2W10DKTYENHS2sNEXdpgnfuNyXivG+vgcNSUUME25SgSSfglB
         MGSj0E+ea+jr8MRLHY9PYNjtgiHtXMMPrA5jGiqAfde6lO/cD3fA4EE9hTuIUEA+hN3D
         iTZ4GG+dSfK6pA1dXyvD2niHCInVZeZoPrjOLy2BmmxmMzGXrpCmVbNn902wrDNzp/mK
         HJ8Ns/O3YELH4yJPZvr6A1armqcC6KBR+t8vhkafTYXX6j79jbZVw6j0kVSBJCPAzWMr
         joOA==
X-Gm-Message-State: AOAM53359/olQVlkhmwi1+JVTvZ7VLZqzi8ni4HaOyPtH7MrxZuLJhsN
        ltCdPH+oXtlEJQq4di8S/Kk=
X-Google-Smtp-Source: ABdhPJyGdTndUURnSIMsVN/nWnTSLPdElU+VwLb7BRl5J6H908x2AsDfFMMifwI0BYnsL0VZULvJWw==
X-Received: by 2002:a05:651c:112c:: with SMTP id e12mr11153302ljo.127.1591018826484;
        Mon, 01 Jun 2020 06:40:26 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id y28sm4068376ljn.4.2020.06.01.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:40:25 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1jfkfp-0003Ft-B4; Mon, 01 Jun 2020 15:40:17 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Pavel Machek <pavel@ucw.cz>
Cc:     Dan Murphy <dmurphy@ti.com>,
        Amitoj Kaur Chawla <amitoj1606@gmail.com>,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 4/6] leds: lm36274: fix use-after-free on unbind
Date:   Mon,  1 Jun 2020 15:39:48 +0200
Message-Id: <20200601133950.12420-5-johan@kernel.org>
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
the parent device. This means you cannot use devres so that
deregistration ends up being tied to the parent device, something which
leads to use-after-free on driver unbind when the class device is
released while still being registered.

Fixes: 11e1bbc116a7 ("leds: lm36274: Introduce the TI LM36274 LED driver")
Cc: stable <stable@vger.kernel.org>     # 5.3
Cc: Dan Murphy <dmurphy@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/leds-lm36274.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-lm36274.c b/drivers/leds/leds-lm36274.c
index 836b60c9a2b8..db842eeb7ca2 100644
--- a/drivers/leds/leds-lm36274.c
+++ b/drivers/leds/leds-lm36274.c
@@ -133,7 +133,7 @@ static int lm36274_probe(struct platform_device *pdev)
 	lm36274_data->pdev = pdev;
 	lm36274_data->dev = lmu->dev;
 	lm36274_data->regmap = lmu->regmap;
-	dev_set_drvdata(&pdev->dev, lm36274_data);
+	platform_set_drvdata(pdev, lm36274_data);
 
 	ret = lm36274_parse_dt(lm36274_data);
 	if (ret) {
@@ -147,8 +147,16 @@ static int lm36274_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	return devm_led_classdev_register(lm36274_data->dev,
-					 &lm36274_data->led_dev);
+	return led_classdev_register(lm36274_data->dev, &lm36274_data->led_dev);
+}
+
+static int lm36274_remove(struct platform_device *pdev)
+{
+	struct lm36274 *lm36274_data = platform_get_drvdata(pdev);
+
+	led_classdev_unregister(&lm36274_data->led_dev);
+
+	return 0;
 }
 
 static const struct of_device_id of_lm36274_leds_match[] = {
@@ -159,6 +167,7 @@ MODULE_DEVICE_TABLE(of, of_lm36274_leds_match);
 
 static struct platform_driver lm36274_driver = {
 	.probe  = lm36274_probe,
+	.remove = lm36274_remove,
 	.driver = {
 		.name = "lm36274-leds",
 	},
-- 
2.26.2

