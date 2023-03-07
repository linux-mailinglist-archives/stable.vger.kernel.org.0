Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39DC6AF2B6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbjCGSzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbjCGSzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:55:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F8F227BB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BAF7EB819D2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C38AC433D2;
        Tue,  7 Mar 2023 18:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214260;
        bh=8iqDb8A50Fit+bU6TpV6GHH/ef8lYltVMLVwrAyQhpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FunJblDmiRMNeZEHGedHC27NktA7gJ77QClZsN5uOBJw97XaKKvOSbq3s9yYNFH2i
         isMbA6cyMKFXzyhT1pi7jEb6WDkNxG9YyFrotwEPvsl2363z4dBgVHYJLLEYRryZx4
         ZfNVe/6D7AC7Mn2PaVySqLhXZAy4/Zg0c17eou5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Johan Hovold <johan+linaro@kernel.org>,
        Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 774/885] irqdomain: Fix association race
Date:   Tue,  7 Mar 2023 18:01:48 +0100
Message-Id: <20230307170035.581890033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit b06730a571a9ff1ba5bd6b20bf9e50e5a12f1ec6 upstream.

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
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irqdomain.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -559,8 +559,8 @@ static void irq_domain_disassociate(stru
 	irq_domain_clear_mapping(domain, hwirq);
 }
 
-int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
-			 irq_hw_number_t hwirq)
+static int irq_domain_associate_locked(struct irq_domain *domain, unsigned int virq,
+				       irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 	int ret;
@@ -573,7 +573,6 @@ int irq_domain_associate(struct irq_doma
 	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map) {
@@ -590,7 +589,6 @@ int irq_domain_associate(struct irq_doma
 			}
 			irq_data->domain = NULL;
 			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -601,12 +599,23 @@ int irq_domain_associate(struct irq_doma
 
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


