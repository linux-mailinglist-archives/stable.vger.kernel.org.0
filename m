Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 370B511B280
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387938AbfLKPgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388224AbfLKPfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:48 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E0A32464B;
        Wed, 11 Dec 2019 15:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078548;
        bh=99FedI5e9Ep3innRCrj56lEylKtDdkSxQdnA938RCEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJjX97oXd9kOMb5azwfxyaku1bZxkZsF3Ir19RzPRd8T7sksvShL+f4nIEEB3GYv0
         BckIzZWQofojOY0gs8x5lg9GlQKOVVT5D2sJdmy1M4nDpat0CATZJclAK78czboe47
         MiSEFDrPq0XOijQ8AHP0XuvuAQ/ZUu4Ewlas1ssE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 35/42] gpio: mpc8xxx: Don't overwrite default irq_set_type callback
Date:   Wed, 11 Dec 2019 10:35:03 -0500
Message-Id: <20191211153510.23861-35-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 4e50573f39229d5e9c985fa3b4923a8b29619ade ]

The per-SoC devtype structures can contain their own callbacks that
overwrite mpc8xxx_gpio_devtype_default.

The clear intention is that mpc8xxx_irq_set_type is used in case the SoC
does not specify a more specific callback. But what happens is that if
the SoC doesn't specify one, its .irq_set_type is de-facto NULL, and
this overwrites mpc8xxx_irq_set_type to a no-op. This means that the
following SoCs are affected:

- fsl,mpc8572-gpio
- fsl,ls1028a-gpio
- fsl,ls1088a-gpio

On these boards, the irq_set_type does exactly nothing, and the GPIO
controller keeps its GPICR register in the hardware-default state. On
the LS1028A, that is ACTIVE_BOTH, which means 2 interrupts are raised
even if the IRQ client requests LEVEL_HIGH. Another implication is that
the IRQs are not checked (e.g. level-triggered interrupts are not
rejected, although they are not supported).

Fixes: 82e39b0d8566 ("gpio: mpc8xxx: handle differences between incarnations at a single place")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20191115125551.31061-1-olteanv@gmail.com
Tested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-mpc8xxx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index 793518a30afe6..bd777687233b1 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -337,7 +337,8 @@ static int mpc8xxx_probe(struct platform_device *pdev)
 	 * It's assumed that only a single type of gpio controller is available
 	 * on the current machine, so overwriting global data is fine.
 	 */
-	mpc8xxx_irq_chip.irq_set_type = devtype->irq_set_type;
+	if (devtype->irq_set_type)
+		mpc8xxx_irq_chip.irq_set_type = devtype->irq_set_type;
 
 	if (devtype->gpio_dir_out)
 		gc->direction_output = devtype->gpio_dir_out;
-- 
2.20.1

