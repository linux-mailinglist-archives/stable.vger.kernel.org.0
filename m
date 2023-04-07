Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2C36DAA3E
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 10:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239613AbjDGIfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 04:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbjDGIfP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 04:35:15 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C162F46B0;
        Fri,  7 Apr 2023 01:35:10 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.153])
        by gateway (Coremail) with SMTP id _____8DxEzS91S9kxccXAA--.37008S3;
        Fri, 07 Apr 2023 16:35:09 +0800 (CST)
Received: from loongson-pc.loongson.cn (unknown [10.20.42.153])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxGL2t1S9kKRwYAA--.21995S7;
        Fri, 07 Apr 2023 16:35:08 +0800 (CST)
From:   Jianmin Lv <lvjianmin@loongson.cn>
To:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        loongson-kernel@lists.loongnix.cn, stable@vger.kernel.org
Subject: [PATCH V3 5/5] irqchip/loongson-pch-pic: Fix pch_pic_acpi_init calling
Date:   Fri,  7 Apr 2023 16:34:53 +0800
Message-Id: <20230407083453.6305-6-lvjianmin@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230407083453.6305-1-lvjianmin@loongson.cn>
References: <20230407083453.6305-1-lvjianmin@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxGL2t1S9kKRwYAA--.21995S7
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7tw17uw1xJw4DGF1UCFy7Awb_yoW8ur47pF
        W2q39Iyr48JFyxCFZ2kw45Xry3A3sxC3y2gF4rC3yrZr4qka4kCr1xAa1Uur4kCFsrGF4a
        vF4FqF1jk3WUAaDanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bS8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84
        ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0owAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Wrv_ZF1lYx0Ex4A2
        jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262
        kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km
        07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
        1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW7
        JVWDJwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r
        1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1U
        YxBIdaVFxhVjvjDU0xZFpf9x07j6rWOUUUUU=
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/irqchip/irq-loongson-pch-pic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 64fa67d4ee7a..e5fe4d50be05 100644
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
-- 
2.31.1

