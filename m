Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5480F111E51
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLCXAr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 18:00:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729717AbfLCW5M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:57:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ACB982053B;
        Tue,  3 Dec 2019 22:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413832;
        bh=XI4eYl+AXLPIs4AC6NGottTKKCcMM/rYzhe4Q8RfOow=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmzgoL/dfXfwvWo8VM9hGMAUuu+aOWqOOtbEwtbqUz6txDy6Mhom/8nDCN/O1G+Kh
         pi2rr7p7w78lTf1YG966NDgY/sxv8dsYCWFSayXT5WsSu9hotUNSEUbW9V0Mn2UcOH
         Gr4SdiPr3njIiyWLDGO1KhpYzA5H7BJQCNxXAAYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 279/321] pwm: Clear chip_data in pwm_put()
Date:   Tue,  3 Dec 2019 23:35:45 +0100
Message-Id: <20191203223441.640027205@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit e926b12c611c2095c7976e2ed31753ad6eb5ff1a upstream.

After a PWM is disposed by its user the per chip data becomes invalid.
Clear the data in common code instead of the device drivers to get
consistent behaviour. Before this patch only three of nine drivers
cleaned up here.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pwm/core.c        |    1 +
 drivers/pwm/pwm-berlin.c  |    1 -
 drivers/pwm/pwm-pca9685.c |    1 -
 drivers/pwm/pwm-samsung.c |    1 -
 4 files changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/pwm/core.c
+++ b/drivers/pwm/core.c
@@ -874,6 +874,7 @@ void pwm_put(struct pwm_device *pwm)
 	if (pwm->chip->ops->free)
 		pwm->chip->ops->free(pwm->chip, pwm);
 
+	pwm_set_chip_data(pwm, NULL);
 	pwm->label = NULL;
 
 	module_put(pwm->chip->ops->owner);
--- a/drivers/pwm/pwm-berlin.c
+++ b/drivers/pwm/pwm-berlin.c
@@ -84,7 +84,6 @@ static void berlin_pwm_free(struct pwm_c
 {
 	struct berlin_pwm_channel *channel = pwm_get_chip_data(pwm);
 
-	pwm_set_chip_data(pwm, NULL);
 	kfree(channel);
 }
 
--- a/drivers/pwm/pwm-pca9685.c
+++ b/drivers/pwm/pwm-pca9685.c
@@ -176,7 +176,6 @@ static void pca9685_pwm_gpio_free(struct
 	pm_runtime_put(pca->chip.dev);
 	mutex_lock(&pca->lock);
 	pwm = &pca->chip.pwms[offset];
-	pwm_set_chip_data(pwm, NULL);
 	mutex_unlock(&pca->lock);
 }
 
--- a/drivers/pwm/pwm-samsung.c
+++ b/drivers/pwm/pwm-samsung.c
@@ -238,7 +238,6 @@ static int pwm_samsung_request(struct pw
 static void pwm_samsung_free(struct pwm_chip *chip, struct pwm_device *pwm)
 {
 	devm_kfree(chip->dev, pwm_get_chip_data(pwm));
-	pwm_set_chip_data(pwm, NULL);
 }
 
 static int pwm_samsung_enable(struct pwm_chip *chip, struct pwm_device *pwm)


