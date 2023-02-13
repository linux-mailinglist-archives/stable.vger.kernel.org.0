Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAFC694316
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 11:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBMKnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 05:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBMKnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 05:43:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20691026B;
        Mon, 13 Feb 2023 02:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 300F360F84;
        Mon, 13 Feb 2023 10:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76AFDC433A0;
        Mon, 13 Feb 2023 10:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676284996;
        bh=m6miDDXDPE0i8gfLkqlExqia0yJKU93vQt0xdTn6QTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sk84GRaAQbVuumMhcjYqbpSugpUuBiGRQaq9vECD1FR1zbOlZ8h7QTpbhbosXX1yE
         fXvXK0nBo3vPUy0Hr42EkPOqvkdjuccYUyuESJGYWkUE/ZdhdwxaD+d5OOHELFU6Xv
         Jb1soYFFI3fI1++n0Wvh+WgO15eJOBBbNtpY73dWEYTzX3fOpuNreTRBz1aQ3Td2j+
         nz7LDi0KwNS7DfidbIKgtuo9S+veuL+IeQmbXRPT1tf91otPfTW1GVIvK+ohhElI3+
         lkhpoHs40MqlGgng4KGA/Nd2wNKzukIC3xTdbMON8qaAfkKSXieuSBdN/q4vPsPvJZ
         OXqv6m1rbkjmA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1pRWJb-0004WN-57; Mon, 13 Feb 2023 11:44:07 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: [PATCH v6 03/20] irqdomain: Drop bogus fwspec-mapping error handling
Date:   Mon, 13 Feb 2023 11:42:45 +0100
Message-Id: <20230213104302.17307-4-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213104302.17307-1-johan+linaro@kernel.org>
References: <20230213104302.17307-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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

