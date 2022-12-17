Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236F564F9F7
	for <lists+stable@lfdr.de>; Sat, 17 Dec 2022 16:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiLQP3p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Dec 2022 10:29:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbiLQP3H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Dec 2022 10:29:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB351705F;
        Sat, 17 Dec 2022 07:27:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DB26B802C3;
        Sat, 17 Dec 2022 15:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DC4C43392;
        Sat, 17 Dec 2022 15:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671290876;
        bh=wgtxMlx7CjihsMRuaBVm90tUKVAegYDMFYtSba8yGNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzC6iBjQuIUK4ZnW6J3rBH57bWp111YPFTIz+WHJ7UOUmSmvZh2JsP9JdG3N9eaWA
         0gOpM/bVvrj6B5Aq940abyCz3y1Ja7X+SeX5zDfRnD/2DM1diKPxo35SUvVCJxsIPD
         +S8CUXJFszg9ujw4dq+dcTBwGOWtLiemtDQ3qKWcDZLK/1Q3qDRgZ0SCXzNGp114hp
         M9L6nz2832GY2Llbj86rgGXBLeHI4CSgdAqe6OIuszAW4lfBDiwVY56/+USK1Ot3zM
         eiqMrEtCDXFtk7cssF9ABv/FxdQnFASSmYhDGJAEuP/X/M39i3xzR16et6I/VvR195
         TK0Z14tjPgqug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jianmin Lv <lvjianmin@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        bhelgaas@google.com, rafael@kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 16/22] ACPI / PCI: fix LPIC IRQ model default PCI IRQ polarity
Date:   Sat, 17 Dec 2022 10:27:17 -0500
Message-Id: <20221217152727.98061-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221217152727.98061-1-sashal@kernel.org>
References: <20221217152727.98061-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit d0c50cc4b957b2cf6e43cec4998d212b5abe9220 ]

On LoongArch based systems, the PCI devices (e.g. SATA controllers and
PCI-to-PCI bridge controllers) in Loongson chipsets output high-level
interrupt signal to the interrupt controller they are connected (see
Loongson 7A1000 Bridge User Manual v2.00, sec 5.3, "For the bridge chip,
AC97 DMA interrupts are edge triggered, gpio interrupts can be configured
to be level triggered or edge triggered as needed, and the rest of the
interrupts are level triggered and active high."), while the IRQs are
active low from the perspective of PCI (see Conventional PCI spec r3.0,
sec 2.2.6, "Interrupts on PCI are optional and defined as level sensitive,
asserted low."), which means that the interrupt output of PCI devices plugged
into PCI-to-PCI bridges of Loongson chipset will be also converted to high-level.
So high level triggered type is required to be passed to acpi_register_gsi()
when creating mappings for PCI devices.

Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221022075955.11726-2-lvjianmin@loongson.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/pci_irq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
index 08e15774fb9f..ff30ceca2203 100644
--- a/drivers/acpi/pci_irq.c
+++ b/drivers/acpi/pci_irq.c
@@ -387,13 +387,15 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
 	u8 pin;
 	int triggering = ACPI_LEVEL_SENSITIVE;
 	/*
-	 * On ARM systems with the GIC interrupt model, level interrupts
+	 * On ARM systems with the GIC interrupt model, or LoongArch
+	 * systems with the LPIC interrupt model, level interrupts
 	 * are always polarity high by specification; PCI legacy
 	 * IRQs lines are inverted before reaching the interrupt
 	 * controller and must therefore be considered active high
 	 * as default.
 	 */
-	int polarity = acpi_irq_model == ACPI_IRQ_MODEL_GIC ?
+	int polarity = acpi_irq_model == ACPI_IRQ_MODEL_GIC ||
+		       acpi_irq_model == ACPI_IRQ_MODEL_LPIC ?
 				      ACPI_ACTIVE_HIGH : ACPI_ACTIVE_LOW;
 	char *link = NULL;
 	char link_desc[16];
-- 
2.35.1

