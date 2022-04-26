Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFEFF510318
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 18:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbiDZQWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 12:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352918AbiDZQWs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 12:22:48 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B0EA27C2;
        Tue, 26 Apr 2022 09:19:31 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p12so6710676pfn.0;
        Tue, 26 Apr 2022 09:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bmdntQ+XDhwLD0wJKqmSW3V4VfjLxmlBPzOJXv5Ur0Y=;
        b=A4kDwhpdcjiRDlkza9E1/2wmIazuc49vMN9UsCVdShjPBWrE1rzy8EWz4B7rWcHV5v
         a8E9ShS/AywSgKeHHSzBlA2691lfN4s8LGt4par1iyW0EEqN1nWwpf7VFKJUlgqHC4fz
         o9NWh8zEe/LsDvbjyC/D/0PPlfLYcAgFFpt69RsAJ03dMqhOTxySLcrTtyMbnuh4m8pc
         MaGdhHKvwjHlO8a9xdpfQL5szNiczpUDGXVy3hlUFoI53ExghCH7g0zwd5Nsei+HiOoo
         scBVWAhlMX2cy3tpt/L3dW5oS/p4i6WMtqyFRcERfq5/aQEP6cCIN1U8x2wiV3qHNjmV
         +UeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bmdntQ+XDhwLD0wJKqmSW3V4VfjLxmlBPzOJXv5Ur0Y=;
        b=8JZh/q3t8wYLhEexBVgQMqbsVaYVXEhfzxLOb5y3fOKUflUiEj8jfoqp1TRP74ZlTz
         e5aeB3Q2kEZ3G8DWdniqyEFZHg0f/Ip1JKWmOj+Swbgd3Nps3IS5z8Es8mUBywm8uqE2
         n0IAibCJ4xZYqtTc8qEBxsUKN/pOtJilqiOlo5YvPsruNSYTrXx59Vfy0eem2+ej3qDS
         LntOZd0EWfBEm0FQgofR81BJxdBV9fVMzuFs/ZpG+NlOzWZbna6/sdtToYwinCjLiRKa
         eZgtR5C7I7QOa3mfU4TnBKpbQIq45J6bSukL7oqfmOJlSg+8POK6TR923UqFC/kuL8N5
         NtIA==
X-Gm-Message-State: AOAM531XJ0KE3MbiNTAePQpGcEpBqUsRH+lZAp3mi/MEQa86/xzHwbft
        eyyodvMWycPac+wSCm96blI=
X-Google-Smtp-Source: ABdhPJzW6LxNPz9cxjz2q7L4v/NY7U22AQLwEp/g67gGd7mNesRZfB9sQkCtLfagz0wU7yUfvS3O7Q==
X-Received: by 2002:a05:6a00:1749:b0:50a:8eed:b824 with SMTP id j9-20020a056a00174900b0050a8eedb824mr25342879pfc.50.1650989971296;
        Tue, 26 Apr 2022 09:19:31 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:f93d:1970:9b66:cfb2])
        by smtp.gmail.com with ESMTPSA id g12-20020a056a001a0c00b004e1307b249csm16772437pfv.69.2022.04.26.09.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 09:19:30 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] irqchip: irq-xtensa-mx: fix initial IRQ affinity
Date:   Tue, 26 Apr 2022 09:19:12 -0700
Message-Id: <20220426161912.1113784-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When irq-xtensa-mx chip is used in non-SMP configuration its
irq_set_affinity callback is not called leaving IRQ affinity set empty.
As a result IRQ delivery does not work in that configuration.
Initialize IRQ affinity of the xtensa MX interrupt distributor to CPU 0
for all external IRQ lines.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 drivers/irqchip/irq-xtensa-mx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-xtensa-mx.c b/drivers/irqchip/irq-xtensa-mx.c
index 27933338f7b3..8c581c985aa7 100644
--- a/drivers/irqchip/irq-xtensa-mx.c
+++ b/drivers/irqchip/irq-xtensa-mx.c
@@ -151,14 +151,25 @@ static struct irq_chip xtensa_mx_irq_chip = {
 	.irq_set_affinity = xtensa_mx_irq_set_affinity,
 };
 
+static void __init xtensa_mx_init_common(struct irq_domain *root_domain)
+{
+	unsigned int i;
+
+	irq_set_default_host(root_domain);
+	secondary_init_irq();
+
+	/* Initialize default IRQ routing to CPU 0 */
+	for (i = 0; i < XCHAL_NUM_EXTINTERRUPTS; ++i)
+		set_er(1, MIROUT(i));
+}
+
 int __init xtensa_mx_init_legacy(struct device_node *interrupt_parent)
 {
 	struct irq_domain *root_domain =
 		irq_domain_add_legacy(NULL, NR_IRQS - 1, 1, 0,
 				&xtensa_mx_irq_domain_ops,
 				&xtensa_mx_irq_chip);
-	irq_set_default_host(root_domain);
-	secondary_init_irq();
+	xtensa_mx_init_common(root_domain);
 	return 0;
 }
 
@@ -168,8 +179,7 @@ static int __init xtensa_mx_init(struct device_node *np,
 	struct irq_domain *root_domain =
 		irq_domain_add_linear(np, NR_IRQS, &xtensa_mx_irq_domain_ops,
 				&xtensa_mx_irq_chip);
-	irq_set_default_host(root_domain);
-	secondary_init_irq();
+	xtensa_mx_init_common(root_domain);
 	return 0;
 }
 IRQCHIP_DECLARE(xtensa_mx_irq_chip, "cdns,xtensa-mx", xtensa_mx_init);
-- 
2.30.2

