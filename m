Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8138690A00
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 14:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjBINaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 08:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjBINao (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 08:30:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43BB1353E;
        Thu,  9 Feb 2023 05:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC6661A7B;
        Thu,  9 Feb 2023 13:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2546C4339C;
        Thu,  9 Feb 2023 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675949442;
        bh=JfSDAiRhoTMhnjXtvFRPr7fYgqO70+KfU+dj+kphkG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdMs14cSNmFrPzA9kK8m+8Y4VUS/4pCWc/BTqJSikcy0h8q4w3abkl8S2QM4rVA6c
         yCXrrNF1MkYxPqpkXWjYt7bYmCEyv9qEgaK+EBkmWk/xRcn8/N5K8/lGopIIuOHkQZ
         Jhor4MahieHrw9hgJ287K9145a+lG49ueI7c7zkaPHFYT4W3b30pJG/HEpuJbyunCZ
         DlbiFr5Djvk/xRNr8E6hN+kijYgXRy1Xe2QgF08mEfHmjcD+eisbqjKvPbSvhB+r7v
         mYq9Cvubouid79vY5o0EW0bwtOk5maoDgHxzcE0A/M/oDcOfMiNEa5239cuxUyumX3
         hcihvWk8wphfw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pQ71G-0001Kj-7k; Thu, 09 Feb 2023 14:31:22 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH v5 02/19] irqdomain: Fix disassociation race
Date:   Thu,  9 Feb 2023 14:23:06 +0100
Message-Id: <20230209132323.4599-3-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209132323.4599-1-johan+linaro@kernel.org>
References: <20230209132323.4599-1-johan+linaro@kernel.org>
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

The global irq_domain_mutex is held when mapping interrupts from
non-hierarchical domains but currently not when disposing them.

This specifically means that updates of the domain mapcount is racy
(currently only used for statistics in debugfs).

Make sure to hold the global irq_domain_mutex also when disposing
mappings from non-hierarchical domains.

Fixes: 9dc6be3d4193 ("genirq/irqdomain: Add map counter")
Cc: stable@vger.kernel.org      # 4.13
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 kernel/irq/irqdomain.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 561689a3f050..981cd636275e 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -538,6 +538,9 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 		return;
 
 	hwirq = irq_data->hwirq;
+
+	mutex_lock(&irq_domain_mutex);
+
 	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 	/* remove chip and handler */
@@ -557,6 +560,8 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 
 	/* Clear reverse map for this hwirq */
 	irq_domain_clear_mapping(domain, hwirq);
+
+	mutex_unlock(&irq_domain_mutex);
 }
 
 static int irq_domain_associate_locked(struct irq_domain *domain, unsigned int virq,
-- 
2.39.1

