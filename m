Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11AE656F73
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbiL0Uog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:44:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiL0Unp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:43:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BE51006C;
        Tue, 27 Dec 2022 12:36:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E60FCB81023;
        Tue, 27 Dec 2022 20:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B405C433D2;
        Tue, 27 Dec 2022 20:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173350;
        bh=+iNmgMDoMDdmr19M/i6MDi7Tdf1j3cRnTNhxJo6WPUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvpuEMoJkGudbmT1mGr76zsrWaHhvH7hjuGB97SxuAusSJ1ZRCwBV4EwgonNUYphJ
         wnc3bf5SHCl9gl0FT8lUvf1GftL2oHUfbi8DEtsbRsyHNZiIQSy4qwn4GYgig+62Ou
         3WCoXfpHVitLYtiBBrcTCA7ViRUjvCaCXZqVswKcUNL2cv2pnF26EndmArznvJJ1OG
         jtHTO8hSER334mX4XJQhiPCXqvt58T1OYeimEL/euLxavEz3yexEMqgYM40yzBkGKb
         FvEPGCZZJxbfbqjKPo3FMnA/PpJYsi0uXt4NXClYfV7+8OAdGgNo7KjBPXdn4wXy5y
         aNggF6TDC1doA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, windhl@126.com, Julia.Lawall@inria.fr,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.4 5/7] powerpc/msi: Fix deassociation of MSI descriptors
Date:   Tue, 27 Dec 2022 15:35:30 -0500
Message-Id: <20221227203534.1214640-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203534.1214640-1-sashal@kernel.org>
References: <20221227203534.1214640-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 4545c6a3d6ba71747eaa984c338ddd745e56e23f ]

Since 2f2940d16823 ("genirq/msi: Remove filter from
msi_free_descs_free_range()"), the core MSI code relies on the
msi_desc->irq field to have been cleared before the descriptor
can be freed, as it indicates that there is no association with
a device anymore.

The irq domain code provides this guarantee, and so does s390,
which is one of the two architectures not using irq domains for
MSIs.

Powerpc, however, is missing this particular requirements,
leading in a splat and leaked MSI descriptors.

Adding the now required irq reset to the handful of powerpc backends
that implement MSIs fixes that particular problem.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/70dab88e-6119-0c12-7c6a-61bcbe239f66@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/4xx/hsta_msi.c  | 1 +
 arch/powerpc/platforms/cell/axon_msi.c | 1 +
 arch/powerpc/platforms/pasemi/msi.c    | 1 +
 arch/powerpc/sysdev/fsl_msi.c          | 1 +
 arch/powerpc/sysdev/mpic_u3msi.c       | 1 +
 5 files changed, 5 insertions(+)

diff --git a/arch/powerpc/platforms/4xx/hsta_msi.c b/arch/powerpc/platforms/4xx/hsta_msi.c
index c950fed43b32..4f65bd0cf111 100644
--- a/arch/powerpc/platforms/4xx/hsta_msi.c
+++ b/arch/powerpc/platforms/4xx/hsta_msi.c
@@ -117,6 +117,7 @@ static void hsta_teardown_msi_irqs(struct pci_dev *dev)
 		msi_bitmap_free_hwirqs(&ppc4xx_hsta_msi.bmp, irq, 1);
 		pr_debug("%s: Teardown IRQ %u (index %u)\n", __func__,
 			 entry->irq, irq);
+		entry->irq = 0;
 	}
 }
 
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index ba33140e671d..d141f64150e8 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -295,6 +295,7 @@ static void axon_msi_teardown_msi_irqs(struct pci_dev *dev)
 
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 	}
 }
 
diff --git a/arch/powerpc/platforms/pasemi/msi.c b/arch/powerpc/platforms/pasemi/msi.c
index d38944a1e258..76393c158ada 100644
--- a/arch/powerpc/platforms/pasemi/msi.c
+++ b/arch/powerpc/platforms/pasemi/msi.c
@@ -69,6 +69,7 @@ static void pasemi_msi_teardown_msi_irqs(struct pci_dev *pdev)
 		hwirq = virq_to_hw(entry->irq);
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 		msi_bitmap_free_hwirqs(&msi_mpic->msi_bitmap, hwirq, ALLOC_CHUNK);
 	}
 
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index d276c5e96445..5c3f3173638e 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -132,6 +132,7 @@ static void fsl_teardown_msi_irqs(struct pci_dev *pdev)
 		msi_data = irq_get_chip_data(entry->irq);
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 		msi_bitmap_free_hwirqs(&msi_data->bitmap, hwirq, 1);
 	}
 
diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
index 3861023d378a..43686c82e483 100644
--- a/arch/powerpc/sysdev/mpic_u3msi.c
+++ b/arch/powerpc/sysdev/mpic_u3msi.c
@@ -111,6 +111,7 @@ static void u3msi_teardown_msi_irqs(struct pci_dev *pdev)
 		hwirq = virq_to_hw(entry->irq);
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 		msi_bitmap_free_hwirqs(&msi_mpic->msi_bitmap, hwirq, 1);
 	}
 
-- 
2.35.1

