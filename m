Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23FE955C547
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235120AbiF0LvA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237061AbiF0Lsu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:48:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE871D60;
        Mon, 27 Jun 2022 04:42:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A3DFB80E32;
        Mon, 27 Jun 2022 11:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E01C3411D;
        Mon, 27 Jun 2022 11:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330168;
        bh=iw43diHJtN+Vp2gXJ7OHL4Zzhj+a3l8VTeGf8BfgsPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PHxldZ4cio8tYH+ZgsIbTVrKmcP0OxsfdQr+fJEj2aqvHt6l/fFEOPzzB8bHvi7ZV
         lAWruDPlfthmGVREY8p3Fkn6loCj/40IGF8MoQ87lMtDPLABDI/8QZBeXRuJYbGqu4
         3/q3+KvCwtyk954XrzuqSxZYbRjO7dff7pUlYmMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aidan MacDonald <aidanmacdonald.0x0@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 090/181] regmap-irq: Fix a bug in regmap_irq_enable() for type_in_mask chips
Date:   Mon, 27 Jun 2022 13:21:03 +0200
Message-Id: <20220627111947.169713407@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>

[ Upstream commit 485037ae9a095491beb7f893c909a76cc4f9d1e7 ]

When enabling a type_in_mask irq, the type_buf contents must be
AND'd with the mask of the IRQ we're enabling to avoid enabling
other IRQs by accident, which can happen if several type_in_mask
irqs share a mask register.

Fixes: bc998a730367 ("regmap: irq: handle HW using separate rising/falling edge interrupts")
Signed-off-by: Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
Link: https://lore.kernel.org/r/20220620200644.1961936-2-aidanmacdonald.0x0@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/regmap/regmap-irq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 400c7412a7dc..4f785bc7981c 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -252,6 +252,7 @@ static void regmap_irq_enable(struct irq_data *data)
 	struct regmap_irq_chip_data *d = irq_data_get_irq_chip_data(data);
 	struct regmap *map = d->map;
 	const struct regmap_irq *irq_data = irq_to_regmap_irq(d, data->hwirq);
+	unsigned int reg = irq_data->reg_offset / map->reg_stride;
 	unsigned int mask, type;
 
 	type = irq_data->type.type_falling_val | irq_data->type.type_rising_val;
@@ -268,14 +269,14 @@ static void regmap_irq_enable(struct irq_data *data)
 	 * at the corresponding offset in regmap_irq_set_type().
 	 */
 	if (d->chip->type_in_mask && type)
-		mask = d->type_buf[irq_data->reg_offset / map->reg_stride];
+		mask = d->type_buf[reg] & irq_data->mask;
 	else
 		mask = irq_data->mask;
 
 	if (d->chip->clear_on_unmask)
 		d->clear_status = true;
 
-	d->mask_buf[irq_data->reg_offset / map->reg_stride] &= ~mask;
+	d->mask_buf[reg] &= ~mask;
 }
 
 static void regmap_irq_disable(struct irq_data *data)
-- 
2.35.1



