Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B05268D7A
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 16:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgINOY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 10:24:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:32954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbgINNGf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:06:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830EE221EB;
        Mon, 14 Sep 2020 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088733;
        bh=VhAKm7/Wt9X1ioKpd2cDViKZseRDrXx25umwKfvJkaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Um8PwnTOjY2MTyd4FsBxx8MWcJU13ej72yrT1rJNFypmojCfamqZ5KxMtGEhMr/8j
         f1v+X2V2Zfo2dExTkhC5240YtSC3FKW4NweUQjziZXTVHCP5+61nLmoqJwS6TMFHgQ
         MMpURbEX99f2OBHRtHWhmwUnO4Go39EMN6jsqC5U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 05/15] regulator: pwm: Fix machine constraints application
Date:   Mon, 14 Sep 2020 09:05:16 -0400
Message-Id: <20200914130526.1804913-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130526.1804913-1-sashal@kernel.org>
References: <20200914130526.1804913-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 59ae97a7a9e1499c2070e29841d1c4be4ae2994a ]

If the zero duty cycle doesn't correspond to any voltage in the voltage
table, the PWM regulator returns an -EINVAL from get_voltage_sel() which
results in the core erroring out with a "failed to get the current
voltage" and ending up not applying the machine constraints.

Instead, return -ENOTRECOVERABLE which makes the core set the voltage
since it's at an unknown value.

For example, with this device tree:

	fooregulator {
		compatible = "pwm-regulator";
		pwms = <&foopwm 0 100000>;
		regulator-min-microvolt = <2250000>;
		regulator-max-microvolt = <2250000>;
		regulator-name = "fooregulator";
		regulator-always-on;
		regulator-boot-on;
		voltage-table = <2250000 30>;
	};

Before this patch:

  fooregulator: failed to get the current voltage(-22)

After this patch:

  fooregulator: Setting 2250000-2250000uV
  fooregulator: 2250 mV

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Link: https://lore.kernel.org/r/20200902130952.24880-1-vincent.whitchurch@axis.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pwm-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/pwm-regulator.c b/drivers/regulator/pwm-regulator.c
index a2fd140eff81a..34f3b9778ffa1 100644
--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -285,7 +285,7 @@ static int pwm_regulator_init_table(struct platform_device *pdev,
 		return ret;
 	}
 
-	drvdata->state			= -EINVAL;
+	drvdata->state			= -ENOTRECOVERABLE;
 	drvdata->duty_cycle_table	= duty_cycle_table;
 	memcpy(&drvdata->ops, &pwm_regulator_voltage_table_ops,
 	       sizeof(drvdata->ops));
-- 
2.25.1

