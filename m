Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A97C10E8EA
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfLBKbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:31:20 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37680 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLBKbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:31:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so22598898wmf.2
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Xu8o3osAJau1uC8uDV0Lekp3SIB/QsqNl5IGgTFKaew=;
        b=o1/BVIrw0mQOb7BDYxrHYVuonvD2LXKai3wADGz7eqgkaUOvOU9ZKMXBaS25Hg5iT3
         TUGuxna/ceRcAbe1jf/QQfABA9opeIQOyn+KBQ3RvaDiZwfXtNotw6A/PMct5E3bHQR8
         redW5xCGPbLt1vqFEz7VjBATdtghKCQZOnRTu5Xe6MZlWplfJmkTtRbXcTB/lRPsbzaK
         4s1ohUeJNSSHQTtOnQAsL4ii6MRTpr/17Q3qaUUatdE2ghCA9WIWEjBv7Edsh7VfZCLa
         n2xgBQOLClXLYPPsqLR6yEjpI1jUNlv1WwfvTLxiAG9fCqzTkPP/ukG/D2hX678tcViq
         PDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xu8o3osAJau1uC8uDV0Lekp3SIB/QsqNl5IGgTFKaew=;
        b=JVGnFOeV31oyfTq28fQOE/Q6WIC8hASfAfaEGazjhBBSVRVUkHS51LbzspUXiJ4Si9
         6Y/LvW4zzjRlkbmlsYXUORqkpJUyAHXpYPNP4XnGWWaaaIbIh6GZeK3iAFCDIfhNiNqm
         jEUd18nWFk6pEO7IW/78f7QdjgfrPqdMtOCOE4VsYGsmH+VV4Wyt/+mHS7Y31m56B3ay
         4NUgTbfRkgph1eXBPb9s1nWR+bqAViG6P6iF3j0f/Y3Jxea+rNj1keAYfPKJOdvahvF8
         dyClEPhuGhC+7Rt8XuMXsKNamJIf2hz2tLXJ1aU2OriCemC+qaGXiRkF9woq2vkeu6gl
         x2Bw==
X-Gm-Message-State: APjAAAUoyIco7CSkuiO7gLrIq8FJ3710m+6BbdXBVgDjhva7HVsRfpXJ
        kUt6GPUOy1aBojgi79cgFCGRNxEOyWA=
X-Google-Smtp-Source: APXvYqy3QXTgbROUedi/K3FKsT4/BW1ywdlc5mJICm2sqwPAc2lmvBF1J8jobXbEtTYJIMZBUxwktw==
X-Received: by 2002:a1c:4483:: with SMTP id r125mr14991717wma.97.1575282678676;
        Mon, 02 Dec 2019 02:31:18 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id r6sm26402860wrq.92.2019.12.02.02.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:31:18 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 11/15] pwm: Clear chip_data in pwm_put()
Date:   Mon,  2 Dec 2019 10:30:46 +0000
Message-Id: <20191202103050.2668-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202103050.2668-1-lee.jones@linaro.org>
References: <20191202103050.2668-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit e926b12c611c2095c7976e2ed31753ad6eb5ff1a ]

After a PWM is disposed by its user the per chip data becomes invalid.
Clear the data in common code instead of the device drivers to get
consistent behaviour. Before this patch only three of nine drivers
cleaned up here.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pwm/core.c        | 1 +
 drivers/pwm/pwm-berlin.c  | 1 -
 drivers/pwm/pwm-pca9685.c | 1 -
 drivers/pwm/pwm-samsung.c | 1 -
 4 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index c45e5719ba17..b1b74cfb1571 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -874,6 +874,7 @@ void pwm_put(struct pwm_device *pwm)
 	if (pwm->chip->ops->free)
 		pwm->chip->ops->free(pwm->chip, pwm);
 
+	pwm_set_chip_data(pwm, NULL);
 	pwm->label = NULL;
 
 	module_put(pwm->chip->ops->owner);
diff --git a/drivers/pwm/pwm-berlin.c b/drivers/pwm/pwm-berlin.c
index 7c8d6a168ceb..b91c477cc84b 100644
--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -84,7 +84,6 @@ static void berlin_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct berlin_pwm_channel *channel = pwm_get_chip_data(pwm);
 
-	pwm_set_chip_data(pwm, NULL);
 	kfree(channel);
 }
 
diff --git a/drivers/pwm/pwm-pca9685.c b/drivers/pwm/pwm-pca9685.c
index a7eaf962a95b..567f5e2771c4 100644
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -176,7 +176,6 @@ static void pca9685_pwm_gpio_free(struct gpio_chip *gpio, unsigned int offset)
 	pm_runtime_put(pca->chip.dev);
 	mutex_lock(&pca->lock);
 	pwm = &pca->chip.pwms[offset];
-	pwm_set_chip_data(pwm, NULL);
 	mutex_unlock(&pca->lock);
 }
 
diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index 062f2cfc45ec..3762432dd6a7 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -238,7 +238,6 @@ static int pwm_samsung_request(struct pwm_chip *chip, struct pwm_device *pwm)
 static void pwm_samsung_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	devm_kfree(chip->dev, pwm_get_chip_data(pwm));
-	pwm_set_chip_data(pwm, NULL);
 }
 
 static int pwm_samsung_enable(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
2.24.0

