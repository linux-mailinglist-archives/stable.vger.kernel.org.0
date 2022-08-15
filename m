Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F9059358D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 20:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbiHOS13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 14:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243063AbiHOS0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 14:26:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121433122A;
        Mon, 15 Aug 2022 11:19:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D76CCB81071;
        Mon, 15 Aug 2022 18:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2CAC433C1;
        Mon, 15 Aug 2022 18:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660587576;
        bh=D8GDK5X2petZO9FBuzzcie9LQ7EsKqqF49b3DRKH8HM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJeWaYLAIAQ6SX5SgUbbZ7/HSTsPiYPziY/vXr9/oWOIzkC4whnRj2zlK48od8GRd
         vIaIVwIS21CboXMXcQntRyQNJubLKLyr3ajQ0XJdOLcJut0CwHelmBYrLTZdM6BNtn
         KxlyK/03A61pOtHceaZrFIJO0a8lpFO7j9hv5wcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Samuel Holland <samuel@sholland.org>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/779] genirq: GENERIC_IRQ_IPI depends on SMP
Date:   Mon, 15 Aug 2022 19:56:04 +0200
Message-Id: <20220815180342.442547927@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 0f5209fee90b4544c58b4278d944425292789967 ]

The generic IPI code depends on the IRQ affinity mask being allocated
and initialized. This will not be the case if SMP is disabled. Fix up
the remaining driver that selected GENERIC_IRQ_IPI in a non-SMP config.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20220701200056.46555-3-samuel@sholland.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/Kconfig | 2 +-
 kernel/irq/Kconfig      | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
index 8f9c52873338..ae1b9f59abc5 100644
--- a/drivers/irqchip/Kconfig
+++ b/drivers/irqchip/Kconfig
@@ -171,7 +171,7 @@ config MADERA_IRQ
 config IRQ_MIPS_CPU
 	bool
 	select GENERIC_IRQ_CHIP
-	select GENERIC_IRQ_IPI if SYS_SUPPORTS_MULTITHREADING
+	select GENERIC_IRQ_IPI if SMP && SYS_SUPPORTS_MULTITHREADING
 	select IRQ_DOMAIN
 	select GENERIC_IRQ_EFFECTIVE_AFF_MASK
 
diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index fbc54c2a7f23..00d58588ea95 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -82,6 +82,7 @@ config IRQ_FASTEOI_HIERARCHY_HANDLERS
 # Generic IRQ IPI support
 config GENERIC_IRQ_IPI
 	bool
+	depends on SMP
 	select IRQ_DOMAIN_HIERARCHY
 
 # Generic MSI interrupt support
-- 
2.35.1



