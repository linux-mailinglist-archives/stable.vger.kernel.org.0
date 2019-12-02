Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA24E10E7F2
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfLBJuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:50:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37125 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfLBJuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:50:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so12391054wru.4
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wN8Wz+OqrhKIKYPYJBtEtZFwg/h6OwVz+bEt3kPQDmY=;
        b=ZBoXUFkbnH8Nk0M78+uLkLXG2r75Jp55gnODei+w5Wzf8ES8AnNWwGP2DhStJrAiSw
         gAR7Pv4lO6AqALrbvke8JAPTsYYHnG11Fz2/1N1SBwTMTIC3Q5QCsmxgRn3D5f+dBl1a
         pm1arcPhf8wrapz+1b7sSCklviJUQTollywnruF+H3Gnpv46MIvMN4zm5FqmvmXFJEBT
         M3YQhtK5Ir/IrNoMOWlHDt42MhlitnP/OGCPvDfsbkl4NckIvaHpGfKQlLiSGZFENebi
         DAgzts4rJYtS5dWQQOfDkkZYo7MdZ6PYZXGJxL4npbE3v53vywwuFy5mNN/mGnjUNY1N
         aIUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wN8Wz+OqrhKIKYPYJBtEtZFwg/h6OwVz+bEt3kPQDmY=;
        b=jzBw9J9oi3lIWin1U9AaRsCeNYaqpXYckwL6SYANtGoMMOE4Ooyrzyzok/ip2VYoaX
         /ahTcRKtnwv8LRleGgJirIhXfp2M3TqDQxGOXlAO3xklPXhicItgIK2QrwcAhgmrFjf7
         OtmxOSCr+lK4As9zssCwotr9gDX+QyPRruimYqV/vCtd2s8Pf7MUf1DkQ39wCTe8KEwU
         kqWZRZ3ag5pwm3XDU+UCcAWDjYCrOzH8C+/kTx9EqRtNhq9yBUeZ5RUQEiJy84WVbVla
         poGsFzgOiUnt2/obp27at0UBaWbOUiR2ukZNDhUD/QikP36xpvaWbsjioEua/ZGnCrmG
         zI6w==
X-Gm-Message-State: APjAAAUrifFZ7HpidXvKl3sMVnl6DqHA3MiHDlasJ9Tt1NOdLfouQIUj
        E9Rg87g/wboQjU43c1uUD11toe2uQlk=
X-Google-Smtp-Source: APXvYqzxxbxMf+2aCniXWeXc0AJIm9uqfELy2siMGGtitMVUo69kJaZ+fhXt+bk8wupdyn720HYIwQ==
X-Received: by 2002:adf:f64b:: with SMTP id x11mr49606523wrp.355.1575280237891;
        Mon, 02 Dec 2019 01:50:37 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id l3sm4629698wrt.29.2019.12.02.01.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:50:37 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.9 6/6] pwm: Clear chip_data in pwm_put()
Date:   Mon,  2 Dec 2019 09:50:12 +0000
Message-Id: <20191202095012.559-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202095012.559-1-lee.jones@linaro.org>
References: <20191202095012.559-1-lee.jones@linaro.org>
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
 drivers/pwm/pwm-samsung.c | 1 -
 3 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index a19246455c13..cc12032ee60d 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -858,6 +858,7 @@ void pwm_put(struct pwm_device *pwm)
 	if (pwm->chip->ops->free)
 		pwm->chip->ops->free(pwm->chip, pwm);
 
+	pwm_set_chip_data(pwm, NULL);
 	pwm->label = NULL;
 
 	module_put(pwm->chip->ops->owner);
diff --git a/drivers/pwm/pwm-berlin.c b/drivers/pwm/pwm-berlin.c
index 01339c152ab0..64d9bb1ac272 100644
--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -78,7 +78,6 @@ static void berlin_pwm_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	struct berlin_pwm_channel *channel = pwm_get_chip_data(pwm);
 
-	pwm_set_chip_data(pwm, NULL);
 	kfree(channel);
 }
 
diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index f113cda47032..219757087995 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -235,7 +235,6 @@ static int pwm_samsung_request(struct pwm_chip *chip, struct pwm_device *pwm)
 static void pwm_samsung_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	devm_kfree(chip->dev, pwm_get_chip_data(pwm));
-	pwm_set_chip_data(pwm, NULL);
 }
 
 static int pwm_samsung_enable(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
2.24.0

