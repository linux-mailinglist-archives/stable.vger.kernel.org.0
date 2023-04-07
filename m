Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304CA6DAA3B
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbjDGIfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Apr 2023 04:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbjDGIfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Apr 2023 04:35:14 -0400
Received: from loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4114F3C3E;
        Fri,  7 Apr 2023 01:35:09 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.153])
        by gateway (Coremail) with SMTP id _____8Dxj8281S9krscXAA--.36968S3;
        Fri, 07 Apr 2023 16:35:08 +0800 (CST)
Received: from loongson-pc.loongson.cn (unknown [10.20.42.153])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxGL2t1S9kKRwYAA--.21995S4;
        Fri, 07 Apr 2023 16:35:07 +0800 (CST)
From:   Jianmin Lv <lvjianmin@loongson.cn>
To:     Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <maz@kernel.org>
Cc:     linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>,
        loongson-kernel@lists.loongnix.cn, stable@vger.kernel.org
Subject: [PATCH V3 2/5] irqchip/loongson-eiointc: Fix incorrect use of acpi_get_vec_parent
Date:   Fri,  7 Apr 2023 16:34:50 +0800
Message-Id: <20230407083453.6305-3-lvjianmin@loongson.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230407083453.6305-1-lvjianmin@loongson.cn>
References: <20230407083453.6305-1-lvjianmin@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8AxGL2t1S9kKRwYAA--.21995S4
X-CM-SenderInfo: 5oymxthqpl0qxorr0wxvrqhubq/
X-Coremail-Antispam: 1Uk129KBjvJXoWxZw45trW8Jw1xWrW3uF1fCrg_yoW5Ww1UpF
        WUAFWDtr43X3y3uryfKFs8X34rtw1rZanFqa1fCaySyF43uryUGF1rCF1DCryYkrW8WF4Y
        va1YqFyUZF13AwUanT9S1TB71UUUUjDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
        qI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUIcSsGvfJTRUUU
        bfAYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s
        1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
        wVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4
        x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2kK
        e7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYIkI8VC2zVCFFI
        0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280
        aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4
        kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI
        1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
        Wlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj
        6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
        0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
        cSsGvfC2KfnxnUUI43ZEXa7IU8_gA5UUUUU==
X-Spam-Status: No, score=-0.0 required=5.0 tests=SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In eiointc_acpi_init(), a *eiointc* node is passed into
acpi_get_vec_parent() instead of a required *NUMA* node (on some chip
like 3C5000L, a *NUMA* node means a *eiointc* node, but on some chip
like 3C5000, a *NUMA* node contains 4 *eiointc* nodes), and node in
struct acpi_vector_group is essentially a *NUMA* node, which will
lead to no parent matched for passed *eiointc* node. so the patch
adjusts code to use *NUMA* node for parameter node of
acpi_set_vec_parent/acpi_get_vec_parent.

Cc: stable@vger.kernel.org
Signed-off-by: Jianmin Lv <lvjianmin@loongson.cn>
---
 drivers/irqchip/irq-loongson-eiointc.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-loongson-eiointc.c b/drivers/irqchip/irq-loongson-eiointc.c
index 62a632d73991..d16ed64feb3d 100644
--- a/drivers/irqchip/irq-loongson-eiointc.c
+++ b/drivers/irqchip/irq-loongson-eiointc.c
@@ -280,9 +280,6 @@ static void acpi_set_vec_parent(int node, struct irq_domain *parent, struct acpi
 {
 	int i;
 
-	if (cpu_has_flatmode)
-		node = cpu_to_node(node * CORES_PER_EIO_NODE);
-
 	for (i = 0; i < MAX_IO_PICS; i++) {
 		if (node == vec_group[i].node) {
 			vec_group[i].parent = parent;
@@ -349,8 +346,16 @@ static int __init pch_pic_parse_madt(union acpi_subtable_headers *header,
 static int __init pch_msi_parse_madt(union acpi_subtable_headers *header,
 					const unsigned long end)
 {
+	struct irq_domain *parent;
 	struct acpi_madt_msi_pic *pchmsi_entry = (struct acpi_madt_msi_pic *)header;
-	struct irq_domain *parent = acpi_get_vec_parent(eiointc_priv[nr_pics - 1]->node, msi_group);
+	int node;
+
+	if (cpu_has_flatmode)
+		node = cpu_to_node(eiointc_priv[nr_pics - 1]->node * CORES_PER_EIO_NODE);
+	else
+		node = eiointc_priv[nr_pics - 1]->node;
+
+	parent = acpi_get_vec_parent(node, msi_group);
 
 	if (parent)
 		return pch_msi_acpi_init(parent, pchmsi_entry);
@@ -379,6 +384,7 @@ int __init eiointc_acpi_init(struct irq_domain *parent,
 	int i, ret, parent_irq;
 	unsigned long node_map;
 	struct eiointc_priv *priv;
+	int node;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -421,8 +427,12 @@ int __init eiointc_acpi_init(struct irq_domain *parent,
 				  "irqchip/loongarch/intc:starting",
 				  eiointc_router_init, NULL);
 
-	acpi_set_vec_parent(acpi_eiointc->node, priv->eiointc_domain, pch_group);
-	acpi_set_vec_parent(acpi_eiointc->node, priv->eiointc_domain, msi_group);
+	if (cpu_has_flatmode)
+		node = cpu_to_node(acpi_eiointc->node * CORES_PER_EIO_NODE);
+	else
+		node = acpi_eiointc->node;
+	acpi_set_vec_parent(node, priv->eiointc_domain, pch_group);
+	acpi_set_vec_parent(node, priv->eiointc_domain, msi_group);
 	ret = acpi_cascade_irqdomain_init();
 
 	return ret;
-- 
2.31.1

