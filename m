Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC700147F4A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbgAXLBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:01:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387515AbgAXLBI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:01:08 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 700FE2071A;
        Fri, 24 Jan 2020 11:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863667;
        bh=0Pz746ar7iNqyegu0t176P+0xFuC96QAhb2agpaCPSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UormKacNdgHkF814KjBSpYrgteWom2dMxofSkb+I7QmAKnJTeLmaIwlYJ3qO5aFS7
         lAdz/LPm8hnhASkni6crxQ7swNqPVDNKcTyfYi1rqy3lKUF1CJGb/q/FF6TfUlB/rg
         Td/gFdGEqj0u7Igdc+ZR/zeuZ845pQX/wFmrn6iU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonard Crestez <leonard.crestez@nxp.com>,
        Fabio Estevam <festevam@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/639] regulator: fixed: Default enable high on DT regulators
Date:   Fri, 24 Jan 2020 10:23:32 +0100
Message-Id: <20200124093052.717705140@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 28be5f15df2ee6882b0a122693159c96a28203c7 ]

commit efdfeb079cc3
("regulator: fixed: Convert to use GPIO descriptor only")
switched to use gpiod_get() to look up the regulator from the
gpiolib core whether that is device tree or boardfile.

This meant that we activate the code in
a603a2b8d86e ("gpio: of: Add special quirk to parse regulator flags")
which means the descriptors coming from the device tree already
have the right inversion and open drain semantics set up from
the gpiolib core.

As the fixed regulator was inspected again we got the
inverted inversion and things broke.

Fix it by ignoring the config in the device tree for now: the
later patches in the series will push all inversion handling
over to the gpiolib core and set it up properly in the
boardfiles for legacy devices, but I did not finish that
for this kernel cycle.

Fixes: commit efdfeb079cc3 ("regulator: fixed: Convert to use GPIO descriptor only")
Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
Reported-by: Fabio Estevam <festevam@gmail.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fixed.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 988a7472c2ab5..d68ff65a5adc9 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -84,9 +84,14 @@ of_get_fixed_voltage_config(struct device *dev,
 
 	of_property_read_u32(np, "startup-delay-us", &config->startup_delay);
 
-	config->enable_high = of_property_read_bool(np, "enable-active-high");
-	config->gpio_is_open_drain = of_property_read_bool(np,
-							   "gpio-open-drain");
+	/*
+	 * FIXME: we pulled active low/high and open drain handling into
+	 * gpiolib so it will be handled there. Delete this in the second
+	 * step when we also remove the custom inversion handling for all
+	 * legacy boardfiles.
+	 */
+	config->enable_high = 1;
+	config->gpio_is_open_drain = 0;
 
 	if (of_find_property(np, "vin-supply", NULL))
 		config->input_supply = "vin";
-- 
2.20.1



