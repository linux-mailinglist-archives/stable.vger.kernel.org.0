Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A461656F3A
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232767AbiL0Ujr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiL0UjD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:39:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC8DEE2D;
        Tue, 27 Dec 2022 12:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA10E6123B;
        Tue, 27 Dec 2022 20:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20633C433EF;
        Tue, 27 Dec 2022 20:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173307;
        bh=vuiIbG0tYp4irGtC8KLAai5YKViHEnA21sm9flQ+CG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQqOWqFcyJ9VJag4Ze4dlAHSDMdDyutxZO3HvtXuaQI9m138FFyTMu3EzxuRRdJno
         kKOyH7a/2N6YC+cqXab7NZi4jd77ptgsPTObBwr/egClJL2EfuxmCyD0bTtnuSPeQr
         93CTfu1qeE8Z42jw0TSMUYMdwF9g4/s3xkLMIrS+rXOUqfGDM9NCuopw7Esh55Fp0I
         dkXP1APKPFZf/OXZ8DdBB6ghHMXxzx2YdY1uL+QbWxm3AFwNt1i+ZG10FXY70oKZmW
         KoZLL/4TJowBvk331jo4tAHy4YsZrMXOMREuGonDwQWYrNdE6PGuyXrt838LtR7lRu
         nW6Bq1RYkmiVg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, windhl@126.com, joel@jms.id.au,
        Julia.Lawall@inria.fr, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.15 20/22] powerpc/msi: Fix deassociation of MSI descriptors
Date:   Tue, 27 Dec 2022 15:34:30 -0500
Message-Id: <20221227203433.1214255-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203433.1214255-1-sashal@kernel.org>
References: <20221227203433.1214255-1-sashal@kernel.org>
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
index f630693c8de7..2bcd9c54bce3 100644
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
index c55ccec0a169..173d585c1be8 100644
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

