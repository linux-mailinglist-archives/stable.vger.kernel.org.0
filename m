Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19D4268BC4
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 15:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgINNH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 09:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726694AbgINNHL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Sep 2020 09:07:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8455822225;
        Mon, 14 Sep 2020 13:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600088751;
        bh=iyOyMnAeI6n5S6e4ZMfAm2gtsObhSoCSqfL5PHc7l6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mW/CX3/1OTdPvVYDiiFv2lT9wiYBeIINPBCZ2dGc8xORirwvLYMaUzPFp/8EPQI2z
         EdclTKBSY2hguUcqJI50bQ51y8TI9goEwa2zLyc2TGAWMbOO9ixU8uYlcIxJ78xnEn
         qjFX8WV791C0WUAGVUQXxVRoXZudDsBT2f6cfqIE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 04/10] regulator: pwm: Fix machine constraints application
Date:   Mon, 14 Sep 2020 09:05:39 -0400
Message-Id: <20200914130545.1805084-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914130545.1805084-1-sashal@kernel.org>
References: <20200914130545.1805084-1-sashal@kernel.org>
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
index 1b88e0e15a70c..e91bceff4ff7e 100644
--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -287,7 +287,7 @@ static int pwm_regulator_init_table(struct platform_device *pdev,
 		return ret;
 	}
 
-	drvdata->state			= -EINVAL;
+	drvdata->state			= -ENOTRECOVERABLE;
 	drvdata->duty_cycle_table	= duty_cycle_table;
 	memcpy(&drvdata->ops, &pwm_regulator_voltage_table_ops,
 	       sizeof(drvdata->ops));
-- 
2.25.1

