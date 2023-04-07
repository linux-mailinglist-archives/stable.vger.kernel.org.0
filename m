Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7518D6DAA39
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 10:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239782AbjDGIfP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 04:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239255AbjDGIfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 04:35:14 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 412EBA5E1;
        Fri,  7 Apr 2023 01:35:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.153])
        by gateway (Coremail) with SMTP id _____8AxUU+81S9kqscXAA--.25363S3;
        Fri, 07 Apr 2023 16:35:08 +0800 (CST)
Received: from loongson-pc.loongson.cn (unknown [10.20.42.153])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxGL2t1S9kKRwYAA--.21995S3;
        Fri, 07 Apr 2023 16:35:06 +0800 (CST)
From:   Jianmin Lv <lvjianmin@loongson.cn>
To:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        loongson-kernel@lists.loongnix.cn, stable@vger.kernel.org
Subject: [PATCH V3 1/5] irqchip/loongson-eiointc: Fix returned value on parsing MADT
Date:   Fri,  7 Apr 2023 16:34:49 +0800
Message-Id: <20230407083453.6305-2-lvjianmin@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230407083453.6305-1-lvjianmin@loongson.cn>
References: <20230407083453.6305-1-lvjianmin@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxGL2t1S9kKRwYAA--.21995S3
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7trWkZF45Kw48uF4rtFWkJFb_yoW8Ww4kpa
        y7ArZ8tr4Yy3yxCr4kt3s8X345A39xuayxtFWrGayFvr4qkrWUXF4fA3W29rn2yFWUG3Wj
        vF4Fqa15uw45A3DanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bfAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_JF0_JFyl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2kK
        e7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
        0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280
        aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4
        kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI
        1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
        Wlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j
        6ryUMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
        0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
        cSsGvfC2KfnxnUUI43ZEXa7IU8Gii3UUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In pch_pic_parse_madt(), a NULL parent pointer will be
returned from acpi_get_vec_parent() for second pch-pic domain
related to second bridge while calling eiointc_acpi_init() at
first time, where the parent of it has not been initialized
yet, and will be initialized during second time calling
eiointc_acpi_init(). So, it's reasonable to return zero so
that failure of acpi_table_parse_madt() will be avoided, or else
acpi_cascade_irqdomain_init() will return and initialization of
followed pch_msi domain will be skipped.

Although it does not matter when pch_msi_parse_madt() returns
-EINVAL if no invalid parent is found, it's also reasonable to
return zero for that.

Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
---
 drivers/irqchip/irq-loongson-eiointc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index d15fd38c1756..62a632d73991 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -343,7 +343,7 @@ static int __init pch_pic_parse_madt(union acpi_subtable_headers *header,
 	if (parent)
 		return pch_pic_acpi_init(parent, pchpic_entry);
 
-	return -EINVAL;
+	return 0;
 }
 
 static int __init pch_msi_parse_madt(union acpi_subtable_headers *header,
@@ -355,7 +355,7 @@ static int __init pch_msi_parse_madt(union acpi_subtable_headers *header,
 	if (parent)
 		return pch_msi_acpi_init(parent, pchmsi_entry);
 
-	return -EINVAL;
+	return 0;
 }
 
 static int __init acpi_cascade_irqdomain_init(void)
-- 
2.31.1

