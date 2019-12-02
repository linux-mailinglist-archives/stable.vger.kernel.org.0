Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42B110E7D5
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 10:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfLBJmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 04:42:14 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35237 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726516AbfLBJmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Dec 2019 04:42:14 -0500
Received: by mail-wm1-f66.google.com with SMTP id u8so6828185wmu.0
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 01:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kaD4X+iA+hefnr2SY426Cp6AZq0PIpD1GzWQcMxIds0=;
        b=AX10FchAzj258tGdsEXsMQf+oayOn8Rmx/rDannYqYzO/9kuBXeGWesbgaupbxVDti
         F7R+ztIOU8P+HWp03T8AKFlkcOcGFINVvPgyHZh1g1Bn+FsXlyfcNxmo4Off6677TTBI
         U38teApdACZtqNPxSu41RzLJNqy3HjF6BEPKvl4mnOFmtEKffV9RAxToDn7p/bFGLLpm
         J9UuCYR8l+AVtA3ANQ9yCDKtNaZm9RxYcfAbb+tnM+EH0EQagPiLxtRvPy34aHURJtL4
         sf1IAUWC2oFjCPIsDNs0gz7A4x8LpwbOXCNvXfRGoqqyzzhZfd7xeuSXhahHlCLgeohw
         5pOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kaD4X+iA+hefnr2SY426Cp6AZq0PIpD1GzWQcMxIds0=;
        b=mUbkGvkTpb7AUFC0f4tPhTtcFIHzWfnh6RWweLPvn2n7UUps/aGBuXF8oWEint9qQr
         7At61d3ZMGFQxHlv/BQ4w2ki9imi/1+SKN5uIGLgUVBMP/jisDUYK1a2Ksiw+HYZ5U1q
         qjPJDSIfS2n0OQQjJx87o0j55jdG82+w9KZ5qAMjlSk6b1PsNoFIIWpS+XfbyuIenPkl
         +QjvVC1A2g32dFoyaL3b1mPdf2Z4I4/uqGfcwpAtOPCJ8XYNlDBJQ19Rj6lNi4E0seMw
         fsuIFI2S6sJi2x0sZZZ+LGewq6c0CtUXWYVi0c1t0RBEMQ7slI/bci+AotFiCCOyQwnk
         Sm9g==
X-Gm-Message-State: APjAAAUW+PEqo5c0YPsYHGuY1itrMKTS5icRDqEcq18W/VUT120J438Z
        cUqyyF+bv+pzUeLO1cbMMSc78lVnwsg=
X-Google-Smtp-Source: APXvYqybOD0RGiTAt69HBrNs1bXyMA6SPCSfUzFLEcDAmkLbRWBZ3s300H+hLmW6grxb+AV351CzAw==
X-Received: by 2002:a1c:ed05:: with SMTP id l5mr28968074wmh.161.1575279732668;
        Mon, 02 Dec 2019 01:42:12 -0800 (PST)
Received: from localhost.localdomain ([2.27.35.155])
        by smtp.gmail.com with ESMTPSA id w8sm990381wmm.0.2019.12.02.01.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 01:42:12 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 4/4] pwm: Clear chip_data in pwm_put()
Date:   Mon,  2 Dec 2019 09:41:50 +0000
Message-Id: <20191202094150.32485-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191202094150.32485-1-lee.jones@linaro.org>
References: <20191202094150.32485-1-lee.jones@linaro.org>
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
 drivers/pwm/pwm-samsung.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pwm/core.c b/drivers/pwm/core.c
index 6911f9662300..5e582099ebaa 100644
--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -781,6 +781,7 @@ void pwm_put(struct pwm_device *pwm)
 	if (pwm->chip->ops->free)
 		pwm->chip->ops->free(pwm->chip, pwm);
 
+	pwm_set_chip_data(pwm, NULL);
 	pwm->label = NULL;
 
 	module_put(pwm->chip->ops->owner);
diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
index ada2d326dc3e..42f270ef2f7b 100644
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -226,7 +226,6 @@ static int pwm_samsung_request(struct pwm_chip *chip, struct pwm_device *pwm)
 static void pwm_samsung_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	devm_kfree(chip->dev, pwm_get_chip_data(pwm));
-	pwm_set_chip_data(pwm, NULL);
 }
 
 static int pwm_samsung_enable(struct pwm_chip *chip, struct pwm_device *pwm)
-- 
2.24.0

