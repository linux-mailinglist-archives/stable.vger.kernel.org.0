Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38BF6D1F42
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 13:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjCaLjG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 07:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjCaLjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 07:39:04 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E32FC191FB;
        Fri, 31 Mar 2023 04:39:01 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.153])
        by gateway (Coremail) with SMTP id _____8BxIk5UxiZkKe0UAA--.32039S3;
        Fri, 31 Mar 2023 19:39:00 +0800 (CST)
Received: from loongson-pc.loongson.cn (unknown [10.20.42.153])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx57xUxiZkmwASAA--.12675S3;
        Fri, 31 Mar 2023 19:39:00 +0800 (CST)
From:   Jianmin Lv <lvjianmin@loongson.cn>
To:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        loongson-kernel@lists.loongnix.cn, stable@vger.kernel.org
Subject: [PATCH V2 1/5] irqchip/loongson-eiointc: Fix returned value on parsing MADT
Date:   Fri, 31 Mar 2023 19:38:56 +0800
Message-Id: <20230331113900.9105-2-lvjianmin@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230331113900.9105-1-lvjianmin@loongson.cn>
References: <20230331113900.9105-1-lvjianmin@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8Bx57xUxiZkmwASAA--.12675S3
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoW7trWkZF45Kw48uF4rtFWkJFb_yoW8WFW7pa
        y7ArZ8tr4Yy3yxCr4kt3s8X345A39xuayxtFWrG3yFvr4qkrWDXF4fA3Wj9rn2yFWUG3Wj
        vF4Fqa15uw45A3DanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bS8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_JF0_JFyl8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26F4UJVW0owAa
        w2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44
        I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2
        jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262
        kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km
        07C267AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r
        1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8
        JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r
        1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1U
        YxBIdaVFxhVjvjDU0xZFpf9x07jr6p9UUUUU=
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

