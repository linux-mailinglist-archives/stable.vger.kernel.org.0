Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96090262622
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 06:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbgIIEN4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 00:13:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgIIENz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 00:13:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A69C061573;
        Tue,  8 Sep 2020 21:13:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z19so998701pfn.8;
        Tue, 08 Sep 2020 21:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SK7c8zygBhocwtQGCubxomcP9y8grV0ZdMS3bUk6cLE=;
        b=aMeBodJOsaAEBMAf80kY/k/JsoGhhCSWrHBwCDJUHUDUxC4bD6GtzD/SoujJfLUlc4
         hwyAXE3/aiFyptIsDSWvAfWb6PjcIYwpVtx/cToi2/pEbh5KUcv4t95tL4jlnso+h57c
         2D/Jp6uxvTRDKwhxyFKDwfUh+UT4CCndBz21Mf9PUlKNj6cAzQYsKF5XxjQl8zQpodUP
         8yFY8Y8x0y8F566n0tWypTMkTjj+CQ5mfkiFSsZTmsZzdf6XG4SSN2NuuWa/Etc1jOpe
         ndh8/BVTPYR/UD3d1r+p+8IQeh5eoYKy31USSLPHIJPA+hx9SwdPmUjmpZ+DygEZxl/8
         m8Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=SK7c8zygBhocwtQGCubxomcP9y8grV0ZdMS3bUk6cLE=;
        b=lEJ0HmwNeKDdY2gO/9okWOb/7Tu/g1e8x4oT+I29ah74T0BdGArBY+QbJx7VXW12P4
         yVoPv84n997AbWiDeNhpCTzi5f9gjoeQ434/t4sOwn3K4jr6NyR43NwMmf2jzizwBMSl
         9/SD2Y+xlywfumOBWF3QiQNyo+7gYWtMCIBfBs1Sj72YI28Tysuz4TWJLMpbQJn5l2II
         ZVWZkkUEpMt2y4Rx4y8n6QYgtYBougZ24NiwoUiH99uiwducjC6SqAS6/KwMF3DO/TcK
         gKkg77ip+TFRiVppqwud51pemHiorIGg9xRqEGKttbtdBP2jRoVNHWBybhJmAk723+6I
         1gGw==
X-Gm-Message-State: AOAM531NInV52zlccgLQsewsDHZCcZcHsmX8Od0VzCGjWexEMgVcIsdC
        mwJkXbpie6ZyZDPFEXCl5dQ=
X-Google-Smtp-Source: ABdhPJyzsiula4D1EMgUXWX1+1iQpgQ7943H2ofj5WzT7GrW0SMIuI3z1jFAuoymws5igFtl9CF2kw==
X-Received: by 2002:a17:902:aa0b:b029:d0:89f4:6229 with SMTP id be11-20020a170902aa0bb02900d089f46229mr2245361plb.17.1599624834939;
        Tue, 08 Sep 2020 21:13:54 -0700 (PDT)
Received: from software.domain.org ([45.77.13.216])
        by smtp.gmail.com with ESMTPSA id m7sm901436pfm.31.2020.09.08.21.13.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Sep 2020 21:13:54 -0700 (PDT)
From:   Huacai Chen <chenhc@lemote.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <maz@kernel.org>
Cc:     linux-mips@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>, stable@vger.kernel.org
Subject: [PATCH 3/3] irqchip/loongson-pch-pic: Reserve legacy LPC irqs
Date:   Wed,  9 Sep 2020 12:09:12 +0800
Message-Id: <1599624552-17523-3-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 2.7.0
In-Reply-To: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
References: <1599624552-17523-1-git-send-email-chenhc@lemote.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reserve legacy LPC irqs (0~15) to avoid spurious interrupts.

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhc@lemote.com>
---
 drivers/irqchip/irq-loongson-pch-pic.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-pic.c b/drivers/irqchip/irq-loongson-pch-pic.c
index 9bf6b9a..9f6719c 100644
--- a/drivers/irqchip/irq-loongson-pch-pic.c
+++ b/drivers/irqchip/irq-loongson-pch-pic.c
@@ -35,6 +35,7 @@
 
 struct pch_pic {
 	void __iomem		*base;
+	struct irq_domain	*lpc_domain;
 	struct irq_domain	*pic_domain;
 	u32			ht_vec_base;
 	raw_spinlock_t		pic_lock;
@@ -184,9 +185,9 @@ static void pch_pic_reset(struct pch_pic *priv)
 static int pch_pic_of_init(struct device_node *node,
 				struct device_node *parent)
 {
+	int i, base, err;
 	struct pch_pic *priv;
 	struct irq_domain *parent_domain;
-	int err;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -213,6 +214,22 @@ static int pch_pic_of_init(struct device_node *node,
 		goto iounmap_base;
 	}
 
+	base = irq_alloc_descs(-1, 0, NR_IRQS_LEGACY, 0);
+	if (base < 0) {
+		pr_err("Failed to allocate LPC IRQ numbers\n");
+		goto iounmap_base;
+	}
+
+	priv->lpc_domain = irq_domain_add_legacy(node, NR_IRQS_LEGACY, 0, 0,
+						 &irq_domain_simple_ops, NULL);
+	if (!priv->lpc_domain) {
+		pr_err("Failed to add irqdomain for LPC controller");
+		goto iounmap_base;
+	}
+
+	for (i = 0; i < NR_IRQS_LEGACY; i++)
+		irq_set_chip_and_handler(i, &dummy_irq_chip, handle_simple_irq);
+
 	priv->pic_domain = irq_domain_create_hierarchy(parent_domain, 0,
 						       PIC_COUNT,
 						       of_node_to_fwnode(node),
-- 
2.7.0

