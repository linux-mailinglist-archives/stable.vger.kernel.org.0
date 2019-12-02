Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE5410E829
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 11:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfLBKED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 05:04:03 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38357 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfLBKED (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 05:04:03 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so9607516wmi.3
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 02:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=VvMatzEvj4EF7V/05uwq5RXOQ+lvILIgL3z5k3oCXqs=;
        b=ZmyIMB9BzKYSyE9JoYGgQ8+5aMvPeDcMs6TTzc2VIeNumTj//K1aI5tYA9GvBJR4Z4
         XPZCz2rDWdbRZpVz1DkvPaIZckTF7hzc4ZUNOX18ktbq7oWa/tuwghGwWsdK0Dc0qSTm
         wgw+EPTyW6JbuoIAHsxop5whDcqGbhGbeI6DQJasbAsXB/RB5IoGTCmXTagC1yPCkvgd
         a8q7N0xWT3gs7y+Y1gkrvOIKOuxd7QnU9+oeyWtEoxg+qCD/BPlDjGaieMc+J0rmfJjC
         tsQ+g83KJdS2Iy6k93Gnv2zI6ThW9YDOFuJkZx1Jy6UwKO4eDSiAPnI/vUHyNoOGjvKk
         ZCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VvMatzEvj4EF7V/05uwq5RXOQ+lvILIgL3z5k3oCXqs=;
        b=RD7uYYebLnofcL039qGsbFbW9KtanN80VEjA9ChaB1JZJu6R64+iCQPF67EgrUZSjF
         tzuFQGExTGtXnGSxNhndgyWANV5JzNk0eGKOT3X2YPEbMAenNi8OnTIoJnOJIOlqD+80
         1lmTZAy3aT84zqDkv/jeo4mXsPr0nQW05LSGI3JLbNzjSuumF2+rS1oaZn6Yi863q2bn
         6zHO0IIQ2OY6E3tDnirPiCdASkHLcBpxmdjQDw5tCe9Ewl8qHqeiLTzIapYW0CnCnZsC
         X+VzAhYVOcSJtWxFl3OsPqWdW2hhZjqeoQMAB4NXXAdkYWy9Xbw979dw/PQOOPLsbYlB
         HDgg==
X-Gm-Message-State: APjAAAVzf3YysINapTD/T5aYYuZxnfThgIJKc/3yAnnr5M84FAStA2kG
        hhtBTXWD0ztsICwJaDJTgPfek7JJSI8=
X-Google-Smtp-Source: APXvYqwYfFmA8AQtsOcnLXfasG4Kn5AhERLV/f8dkH4rgeTRGeT/5oM/P3SBo3dHCACs8oLOid6mBA==
X-Received: by 2002:a05:600c:2218:: with SMTP id z24mr17961043wml.50.1575281039617;
        Mon, 02 Dec 2019 02:03:59 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id h8sm22975665wrx.63.2019.12.02.02.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 02:03:58 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 10/14] pwm: Clear chip_data in pwm_put()
Date:   Mon,  2 Dec 2019 10:03:08 +0000
Message-Id: <20191202100312.1397-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202100312.1397-1-lee.jones@linaro.org>
References: <20191202100312.1397-1-lee.jones@linaro.org>
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
index 771859aca4be..7bb819e3c0c1 100644
--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -78,7 +78,6 @@ static void berlin_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
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

