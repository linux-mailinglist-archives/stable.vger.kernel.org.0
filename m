Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71F76909F7
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 14:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjBINaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 08:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjBINao (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 08:30:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D456A23C66;
        Thu,  9 Feb 2023 05:30:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E37861A51;
        Thu,  9 Feb 2023 13:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8A9C433EF;
        Thu,  9 Feb 2023 13:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675949442;
        bh=m6miDDXDPE0i8gfLkqlExqia0yJKU93vQt0xdTn6QTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sa/KsdyjZtn4lNGlYVyABiISMRaa4wwQBRmFtr+M+MjPvP8y+PRzLXqo89kivIomd
         S/PCuMrHmTTouqFOVc51sYPzkBJAh1CO89W1KzQu+w33SmAmW0PJ0+aHDsv0d4PRIb
         POhLEV8bZceaHkWq1M1Jl1P1xV+UEelGyBJFWe3XIspLbOqyhP7frvAjajH46LDiPi
         ObKuQb4r08H88CaO5GAFSC4Tx9igwxJcaE6yhq/+OYeIJeDpy9ldfhIeNXvAa6zog6
         X8cGet21q1o9Of7xfeIVLhj6vsJg4PDJcN77OFOI26NWCu/aM5WeY9WuYpi48SqMk3
         V2Rq26Ho7O1Fg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pQ71G-0001Kl-B0; Thu, 09 Feb 2023 14:31:22 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH v5 03/19] irqdomain: Drop bogus fwspec-mapping error handling
Date:   Thu,  9 Feb 2023 14:23:07 +0100
Message-Id: <20230209132323.4599-4-johan+linaro@kernel.org>
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

In case a newly allocated IRQ ever ends up not having any associated
struct irq_data it would not even be possible to dispose the mapping.

Replace the bogus disposal with a WARN_ON().

This will also be used to fix a shared-interrupt mapping race, hence the
CC-stable tag.

Fixes: 1e2a7d78499e ("irqdomain: Don't set type when mapping an IRQ")
Cc: stable@vger.kernel.org      # 4.8
Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
---
 kernel/irq/irqdomain.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 981cd636275e..b4326c364ae7 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -847,13 +847,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 	}
 
 	irq_data = irq_get_irq_data(virq);
-	if (!irq_data) {
-		if (irq_domain_is_hierarchy(domain))
-			irq_domain_free_irqs(virq, 1);
-		else
-			irq_dispose_mapping(virq);
+	if (WARN_ON(!irq_data))
 		return 0;
-	}
 
 	/* Store trigger type */
 	irqd_set_trigger_type(irq_data, type);
-- 
2.39.1

