Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B60615846
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiKBCsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiKBCsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:48:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EAEF6452
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0048EB8206D
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F3EC433D6;
        Wed,  2 Nov 2022 02:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357312;
        bh=IJjDxoyBGd+BxzJAYl7qcNNYEhvwB8p0wPEJBsFklBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kiK2QefovJ2xS2q+Sdc5ELTJJdIApxL1L9NORtkVqLjlOuafBj3MxYRhisgYkntma
         l6awP1maLpVY/08h5menwpEukp6juDDG7hLfdvVHsW/qYvCYJmoOgRg0xOddXjZaO5
         p8fNyl4HT+MZdhWH5YlvkEeLdja524QFnp0A8Fgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 148/240] pinctrl: ocelot: Fix incorrect trigger of the interrupt.
Date:   Wed,  2 Nov 2022 03:32:03 +0100
Message-Id: <20221102022114.724196467@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit e9945b2633deccda74a769d94060df49c53ff181 ]

The interrupt controller can detect only link changes. So in case an
external device generated a level based interrupt, then the interrupt
controller detected correctly the first edge. But the problem was that
the interrupt controller was detecting also the edge when the interrupt
was cleared. So it would generate another interrupt.
The fix for this is to clear the second interrupt but still check the
interrupt line status.

Fixes: c297561bc98a ("pinctrl: ocelot: Fix interrupt controller")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Tested-by: Michael Walle <michael@walle.cc>
Link: https://lore.kernel.org/r/20221018070959.1322606-1-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index c7df8c5fe585..105771ff82e6 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -1863,19 +1863,28 @@ static void ocelot_irq_unmask_level(struct irq_data *data)
 	if (val & bit)
 		ack = true;
 
+	/* Try to clear any rising edges */
+	if (!active && ack)
+		regmap_write_bits(info->map, REG(OCELOT_GPIO_INTR, info, gpio),
+				  bit, bit);
+
 	/* Enable the interrupt now */
 	gpiochip_enable_irq(chip, gpio);
 	regmap_update_bits(info->map, REG(OCELOT_GPIO_INTR_ENA, info, gpio),
 			   bit, bit);
 
 	/*
-	 * In case the interrupt line is still active and the interrupt
-	 * controller has not seen any changes in the interrupt line, then it
-	 * means that there happen another interrupt while the line was active.
+	 * In case the interrupt line is still active then it means that
+	 * there happen another interrupt while the line was active.
 	 * So we missed that one, so we need to kick the interrupt again
 	 * handler.
 	 */
-	if (active && !ack) {
+	regmap_read(info->map, REG(OCELOT_GPIO_IN, info, gpio), &val);
+	if ((!(val & bit) && trigger_level == IRQ_TYPE_LEVEL_LOW) ||
+	      (val & bit && trigger_level == IRQ_TYPE_LEVEL_HIGH))
+		active = true;
+
+	if (active) {
 		struct ocelot_irq_work *work;
 
 		work = kmalloc(sizeof(*work), GFP_ATOMIC);
-- 
2.35.1



