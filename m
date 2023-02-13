Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCBE694313
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 11:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjBMKnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 05:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBMKnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 05:43:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B908C15C8D;
        Mon, 13 Feb 2023 02:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CB2960F83;
        Mon, 13 Feb 2023 10:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7436DC4339C;
        Mon, 13 Feb 2023 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676284996;
        bh=tBqk6KgtGtAPTVEMAxcaZIoN23hQcgfod3xymk/Evn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8JmyFZDOQ/VlOFXXXAXIsgTHc6eS1nRIwrxjtuFja8L1KQuiwz0XmDoxXYl2gJQk
         fVaXTHx9RhOuqZxoK5vBKO6/bunDNKw2+q71FE3I/dbARWIKJu9U5DnBfoFkBS82+3
         4mOHsvCBTUM7DLa+oWN/+f6pqmDv08dlIQq+gkRzxs0xyEXjY6UjsH7ITeT10pE65v
         tB+MrNuUh/EwsjhiPTmLdF0n5A+fX66v+dj6/xAjKolq5sDGSAJqyrTIDtACf7eg4r
         uzivYFN/YiiVd1Ir4uRA/MzK5EO+deZ3ign3e+10TWsNhzQsGsKGmUc1HXNrCVUvaK
         sCQ+UECB3ETnw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pRWJa-0004WJ-Vd; Mon, 13 Feb 2023 11:44:07 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH v6 01/20] irqdomain: Fix association race
Date:   Mon, 13 Feb 2023 11:42:43 +0100
Message-Id: <20230213104302.17307-2-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213104302.17307-1-johan+linaro@kernel.org>
References: <20230213104302.17307-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The sanity check for an already mapped virq is done outside of the
irq_domain_mutex-protected section which means that an (unlikely) racing
association may not be detected.

Fix this by factoring out the association implementation, which will
also be used in a follow-on change to fix a shared-interrupt mapping
race.

Fixes: ddaf144c61da ("irqdomain: Refactor irq_domain_associate_many()")
Cc: stable@vger.kernel.org      # 3.11
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 kernel/irq/irqdomain.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 798a9042421f..561689a3f050 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -559,8 +559,8 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 	irq_domain_clear_mapping(domain, hwirq);
 }
 
-int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
-			 irq_hw_number_t hwirq)
+static int irq_domain_associate_locked(struct irq_domain *domain, unsigned int virq,
+				       irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 	int ret;
@@ -573,7 +573,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map) {
@@ -590,7 +589,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 			}
 			irq_data->domain = NULL;
 			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -601,12 +599,23 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 
 	domain->mapcount++;
 	irq_domain_set_mapping(domain, hwirq, irq_data);
-	mutex_unlock(&irq_domain_mutex);
 
 	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	return 0;
 }
+
+int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq)
+{
+	int ret;
+
+	mutex_lock(&irq_domain_mutex);
+	ret = irq_domain_associate_locked(domain, virq, hwirq);
+	mutex_unlock(&irq_domain_mutex);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(irq_domain_associate);
 
 void irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
-- 
2.39.1

