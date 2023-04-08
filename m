Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259286DBA2F
	for <lists+stable@lfdr.de>; Sat,  8 Apr 2023 12:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbjDHKr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Apr 2023 06:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjDHKrk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Apr 2023 06:47:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67ABBDE5;
        Sat,  8 Apr 2023 03:46:58 -0700 (PDT)
Date:   Sat, 08 Apr 2023 10:45:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1680950714;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6HIDf+LY2qkTT6cx/+olkS5apHXrkrXcUlGG2J0qmuc=;
        b=qijBNPJV09tPRPMIMlIC388LQ590WbbWv6m2eDG3EtlzAkqpwg172vXY/qEGB2vDQgbOFz
        cadeCQ85uZVgAXlDWg6Qws1bp/KLTjc/17dHcbPvDFk+p1xdRlTzmuCwscPupUzQU7p3z2
        y0WA/p1BTJDEIdUNc741XhKUdL/qlDXqHxY5dqO4gHjvSC8KSfTMrfxxEXrveNUqNkS6Pc
        5zY7kLvZxTqtOk5jE+kVFyjkU9b+HP+pOCIHsVIO99XU7731ERZlhEnNk8FARGWDUKNM6L
        UtCxChfMZxzyUXhlNX+DK8NH7HVc1Gl1HLxGZrg1j/waTr206CejSsPddo+MLg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1680950714;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6HIDf+LY2qkTT6cx/+olkS5apHXrkrXcUlGG2J0qmuc=;
        b=foYMrjsAmiHST4xxfpxHdjBS9KepAEFLPDHbcv0Z5zr4IwHqJWhIgZuV0JtIEnrVvYyHFn
        Lzg8b3relgz9koAQ==
From:   "irqchip-bot for Jianmin Lv" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-kernel@vger.kernel.org
Subject: [irqchip: irq/irqchip-next] irqchip/loongson-pch-pic: Fix
 pch_pic_acpi_init calling
Cc:     stable@vger.kernel.org, Jianmin Lv <lvjianmin@loongson.cn>,
        Marc Zyngier <maz@kernel.org>, tglx@linutronix.de
In-Reply-To: <20230407083453.6305-6-lvjianmin@loongson.cn>
References: <20230407083453.6305-6-lvjianmin@loongson.cn>
MIME-Version: 1.0
Message-ID: <168095071385.404.4377714261555782246.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/irqchip-next branch of irqchip:

Commit-ID:     48ce2d722f7f108f27bedddf54bee3423a57ce57
Gitweb:        https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms/48ce2d722f7f108f27bedddf54bee3423a57ce57
Author:        Jianmin Lv <lvjianmin@loongson.cn>
AuthorDate:    Fri, 07 Apr 2023 16:34:53 +08:00
Committer:     Marc Zyngier <maz@kernel.org>
CommitterDate: Sat, 08 Apr 2023 11:29:18 +01:00

irqchip/loongson-pch-pic: Fix pch_pic_acpi_init calling

For dual-bridges scenario, pch_pic_acpi_init() will be called
in following path:

cpuintc_acpi_init
  acpi_cascade_irqdomain_init(in cpuintc driver)
    acpi_table_parse_madt
      eiointc_parse_madt
        eiointc_acpi_init /* this will be called two times
                             correspondingto parsing two
                             eiointc entries in MADT under
                             dual-bridges scenario*/
          acpi_cascade_irqdomain_init(in eiointc driver)
            acpi_table_parse_madt
              pch_pic_parse_madt
                pch_pic_acpi_init /* this will be called depend
                                     on valid parent IRQ domain
                                     handle for one or two times
                                     corresponding to parsing
                                     two pchpic entries in MADT
                                     druring calling
                                     eiointc_acpi_init() under
                                     dual-bridges scenario*/

During the first eiointc_acpi_init() calling, the
pch_pic_acpi_init() will be called just one time since only
one valid parent IRQ domain handle will be found for current
eiointc IRQ domain.

During the second eiointc_acpi_init() calling, the
pch_pic_acpi_init() will be called two times since two valid
parent IRQ domain handles will be found. So in pch_pic_acpi_init(),
we must have a reasonable way to prevent from creating second same
pch_pic IRQ domain.

The patch matches gsi base information in created pch_pic IRQ
domains to check if the target domain has been created to avoid the
bug mentioned above.

Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230407083453.6305-6-lvjianmin@loongson.cn
---
 drivers/irqchip/irq-loongson-pch-pic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 64fa67d..e5fe4d5 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -404,6 +404,9 @@ int __init pch_pic_acpi_init(struct irq_domain *parent,
 	int ret, vec_base;
 	struct fwnode_handle *domain_handle;
 
+	if (find_pch_pic(acpi_pchpic->gsi_base) >= 0)
+		return 0;
+
 	vec_base = acpi_pchpic->gsi_base - GSI_MIN_PCH_IRQ;
 
 	domain_handle = irq_domain_alloc_fwnode(&acpi_pchpic->address);
