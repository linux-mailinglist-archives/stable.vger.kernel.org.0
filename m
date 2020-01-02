Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75A9512EF46
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgABWck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:32:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:39114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbgABWch (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:32:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7291D22314;
        Thu,  2 Jan 2020 22:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578004356;
        bh=zmhLVLYo7AmsgDCb5HUMzyyEhu2cun8hHrTua1I/Ek0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sl7dGwuLLVM6Yg/cehXJDaRIp4HtDCp6i2XWJFK95t4sw2FwP6BXb9v2pLidl0k2z
         FJzcMLj2tgNT7WWA8+pGazPTBNuyG4ciCCLoMoujg4n0bKtwlKBSl4JbT+OTjweYfq
         VAimulfdmksnGlJPhzVO7t0WhlynngdV0skP7Bac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 144/171] gpio: mpc8xxx: Dont overwrite default irq_set_type callback
Date:   Thu,  2 Jan 2020 23:07:55 +0100
Message-Id: <20200102220607.157038496@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220546.960200039@linuxfoundation.org>
References: <20200102220546.960200039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 793518a30afe..bd777687233b 100644
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



