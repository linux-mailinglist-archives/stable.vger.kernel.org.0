Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3313451A950
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355384AbiEDRMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357007AbiEDRJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC0B4831E;
        Wed,  4 May 2022 09:56:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12F46B827A1;
        Wed,  4 May 2022 16:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C9EC385BB;
        Wed,  4 May 2022 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683414;
        bh=NYarbiEKNJhdMwy43JHI6hW/kY4vKlXNSqwptppxmHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6sS2/b1YAh//7S9evPqcpb1lDWPhU6OOJxPOj2ktBUTntSm8DRJhWNXwp5Qz0AgE
         uG3fp5rppmkgEm4x+dRT0oHSNbyEqcEm8Z3XO5ZKA8/seWc7UgzcEzF8aQDpN1gTJX
         zQ/W3z+cgbYkwErNkFPAVblCwYOhM3ON+ssXTuZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <maz@kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 099/225] pinctrl: stm32: Do not call stm32_gpio_get() for edge triggered IRQs in EOI
Date:   Wed,  4 May 2022 18:45:37 +0200
Message-Id: <20220504153119.592660213@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit e74200ebf7c4f6a7a7d1be9f63833ddba251effa ]

The stm32_gpio_get() should only be called for LEVEL triggered interrupts,
skip calling it for EDGE triggered interrupts altogether to avoid wasting
CPU cycles in EOI handler. On this platform, EDGE triggered interrupts are
the majority and LEVEL triggered interrupts are the exception no less, and
the CPU cycles are not abundant.

Fixes: 47beed513a85b ("pinctrl: stm32: Add level interrupt support to gpio irq chip")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: Fabien Dessenne <fabien.dessenne@foss.st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
To: linux-gpio@vger.kernel.org
Link: https://lore.kernel.org/r/20220415215410.498349-1-marex@denx.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 9ed764731570..df1d6b466fb7 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -311,6 +311,10 @@ static void stm32_gpio_irq_trigger(struct irq_data *d)
 	struct stm32_gpio_bank *bank = d->domain->host_data;
 	int level;
 
+	/* Do not access the GPIO if this is not LEVEL triggered IRQ. */
+	if (!(bank->irq_type[d->hwirq] & IRQ_TYPE_LEVEL_MASK))
+		return;
+
 	/* If level interrupt type then retrig */
 	level = stm32_gpio_get(&bank->gpio_chip, d->hwirq);
 	if ((level == 0 && bank->irq_type[d->hwirq] == IRQ_TYPE_LEVEL_LOW) ||
-- 
2.35.1



