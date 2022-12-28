Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1BF657B00
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbiL1PRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:17:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233227AbiL1PRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:17:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9925613F1F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39DE6B8171C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1ACC433D2;
        Wed, 28 Dec 2022 15:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240620;
        bh=Tacn1Scr7WCtRrRR+AhaqadldxsQPr8WJg4OpZOivFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZcGz9gMhynencaIsj/Riz5BN0VjBb1tWBxaZdD3sTBRj72XSM1VGsa/Krf0JyzBK
         d84PSshcUqkCp3QbesPXKK/2sR28qqhJq2X8S8xGRLWs+tiFWOvwq6EG0vOjx22z/p
         Lr/2S8feWP9+EP56PWZT5qRs0MbwBMtCrFMcjx1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianmin Lv <lvjianmin@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0146/1146] irqchip/loongson-pch-pic: Fix translate callback for DT path
Date:   Wed, 28 Dec 2022 15:28:05 +0100
Message-Id: <20221228144334.111857437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianmin Lv <lvjianmin@loongson.cn>

[ Upstream commit c7c00138015975c8f0e268564249cc47d8de632c ]

In DT path of translate callback, if fwspec->param_count==1
and of_node is non-null, fwspec->param[1] will be accessed,
which is introduced from previous commit bcdd75c596c8
(irqchip/loongson-pch-pic: Add ACPI init support).

Before the patch, for non-null of_node, translate callback
(use irq_domain_translate_twocell()) will return -EINVAL if
fwspec->param_count < 2, so the check in the patch is added.

Fixes: bcdd75c596c8 ("irqchip/loongson-pch-pic: Add ACPI init support")
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221022075955.11726-3-lvjianmin@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-pch-pic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index c01b9c257005..03493cda65a3 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -159,6 +159,9 @@ static int pch_pic_domain_translate(struct irq_domain *d,
 		return -EINVAL;
 
 	if (of_node) {
+		if (fwspec->param_count < 2)
+			return -EINVAL;
+
 		*hwirq = fwspec->param[0] + priv->ht_vec_base;
 		*type = fwspec->param[1] & IRQ_TYPE_SENSE_MASK;
 	} else {
-- 
2.35.1



