Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30229272DCC
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbgIUQnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729562AbgIUQnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1639235F9;
        Mon, 21 Sep 2020 16:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706600;
        bh=AV4Eaj7jrOJ68D6Rsb5R/SK1Yx16OhK4Q+b+JiZaeQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1X5/bZsFJvNVy36cVcrl9pr43Ckvhwl8bQNNP9vsdHetKEWU7BJ6q1yj6EaUYNM6A
         A1fmSaTEIFcozymyKodQvQniKLO8cFklW0cTZOggNPrPF/607H0Jt1WY4GfsmJP36C
         eoRfip/IMBGVcUNhh0kBhUC+qnH+Zb9OPJubUt1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 018/118] regulator: pwm: Fix machine constraints application
Date:   Mon, 21 Sep 2020 18:27:10 +0200
Message-Id: <20200921162037.166382938@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
index 638329bd0745e..62ad7c4e7e7c8 100644
--- a/drivers/regulator/pwm-regulator.c
+++ b/drivers/regulator/pwm-regulator.c
@@ -279,7 +279,7 @@ static int pwm_regulator_init_table(struct platform_device *pdev,
 		return ret;
 	}
 
-	drvdata->state			= -EINVAL;
+	drvdata->state			= -ENOTRECOVERABLE;
 	drvdata->duty_cycle_table	= duty_cycle_table;
 	drvdata->desc.ops = &pwm_regulator_voltage_table_ops;
 	drvdata->desc.n_voltages	= length / sizeof(*duty_cycle_table);
-- 
2.25.1



