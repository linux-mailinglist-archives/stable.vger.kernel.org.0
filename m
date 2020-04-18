Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6C91AEFCB
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgDROoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 10:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgDROoy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Apr 2020 10:44:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7113322250;
        Sat, 18 Apr 2020 14:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587221093;
        bh=/hbFuv6W4bAgGS1r/lRqpWFE7EgMEMRTh9NpIFTXlr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RS0lIqmzfvA0BqV5eZ5SDjKIfGgU1PyGxzRR2yY1xyRCXsWEqc3ZKfvvAMAdJb+cE
         4HFbQiBHOOgGQrwufGKSg+Z/T3qD3kR9yZZF5rTNpQXc9pio/KofBIOHirx8OSemcV
         S/wmQgC8mKr8a/Dx6FLlWSz9D7DtLBDEn4wSo6lk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pwm@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.4 13/19] pwm: bcm2835: Dynamically allocate base
Date:   Sat, 18 Apr 2020 10:44:30 -0400
Message-Id: <20200418144436.10818-13-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200418144436.10818-1-sashal@kernel.org>
References: <20200418144436.10818-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 2c25b07e5ec119cab609e41407a1fb3fa61442f5 ]

The newer 2711 and 7211 chips have two PWM controllers and failure to
dynamically allocate the PWM base would prevent the second PWM
controller instance being probed for succeeding with an -EEXIST error
from alloc_pwms().

Fixes: e5a06dc5ac1f ("pwm: Add BCM2835 PWM driver")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-bcm2835.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pwm/pwm-bcm2835.c b/drivers/pwm/pwm-bcm2835.c
index b4c7f956b6fa6..388a9fa5c1d24 100644
--- a/drivers/pwm/pwm-bcm2835.c
+++ b/drivers/pwm/pwm-bcm2835.c
@@ -160,6 +160,7 @@ static int bcm2835_pwm_probe(struct platform_device *pdev)
 
 	pc->chip.dev = &pdev->dev;
 	pc->chip.ops = &bcm2835_pwm_ops;
+	pc->chip.base = -1;
 	pc->chip.npwm = 2;
 
 	platform_set_drvdata(pdev, pc);
-- 
2.20.1

