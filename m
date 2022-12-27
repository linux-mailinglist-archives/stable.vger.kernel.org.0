Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BB6656F8B
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbiL0Ur3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232852AbiL0UqP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:46:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A201182B;
        Tue, 27 Dec 2022 12:37:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2C726123D;
        Tue, 27 Dec 2022 20:36:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C954C433D2;
        Tue, 27 Dec 2022 20:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173396;
        bh=4DbaLyjK+L8FjEtEwqJJcQ0TUOVDi51mZo3PubrDSKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKGlMheghJpXKstyhtDdD9z+xCD3BqE3omDO4cK7BJ+f5lEajsQzkrVKczPb8wrhF
         SCrixB50afzhVB7+EYRnhUkIa9fJz/1p9tGpJ035Wb3159DR7Qp0y6lggl1nlNblWX
         Hfmp5yg2HBzj733mZosq4vnr78/+og30AkJOvdH3WlKUdFJ+SWRvGeDexS7TL6tAYj
         eb4wcVu9BtTBNXyYtzAsREe+wbMv1MLq9wmdU2skQr1YUZinCTqx78goMzQ8Y+UUx3
         cjugNpRmQO2wyn0DRZJpym4Gb/7M78fMyLUyTpY368Ro0djH8FtyvTfkYYC5vW7JlK
         7XkoeD/tbFXpw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        christophe.leroy@csgroup.eu, windhl@126.com, Julia.Lawall@inria.fr,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 2/3] powerpc/msi: Fix deassociation of MSI descriptors
Date:   Tue, 27 Dec 2022 15:36:24 -0500
Message-Id: <20221227203626.1214890-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203626.1214890-1-sashal@kernel.org>
References: <20221227203626.1214890-1-sashal@kernel.org>
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
 arch/powerpc/platforms/cell/axon_msi.c | 1 +
 arch/powerpc/platforms/pasemi/msi.c    | 1 +
 arch/powerpc/sysdev/fsl_msi.c          | 1 +
 arch/powerpc/sysdev/mpic_u3msi.c       | 1 +
 arch/powerpc/sysdev/ppc4xx_hsta_msi.c  | 1 +
 5 files changed, 5 insertions(+)

diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 8b55c5f19d4c..f78dc043f370 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -298,6 +298,7 @@ static void axon_msi_teardown_msi_irqs(struct pci_dev *dev)
 
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 	}
 }
 
diff --git a/arch/powerpc/platforms/pasemi/msi.c b/arch/powerpc/platforms/pasemi/msi.c
index d9cd510c8865..6e54377663db 100644
--- a/arch/powerpc/platforms/pasemi/msi.c
+++ b/arch/powerpc/platforms/pasemi/msi.c
@@ -74,6 +74,7 @@ static void pasemi_msi_teardown_msi_irqs(struct pci_dev *pdev)
 		hwirq = virq_to_hw(entry->irq);
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 		msi_bitmap_free_hwirqs(&msi_mpic->msi_bitmap, hwirq, ALLOC_CHUNK);
 	}
 
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 8a244828782e..aa9dd3a92f2a 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -137,6 +137,7 @@ static void fsl_teardown_msi_irqs(struct pci_dev *pdev)
 		msi_data = irq_get_chip_data(entry->irq);
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 		msi_bitmap_free_hwirqs(&msi_data->bitmap, hwirq, 1);
 	}
 
diff --git a/arch/powerpc/sysdev/mpic_u3msi.c b/arch/powerpc/sysdev/mpic_u3msi.c
index cfc1c57d760f..26db91c8feff 100644
--- a/arch/powerpc/sysdev/mpic_u3msi.c
+++ b/arch/powerpc/sysdev/mpic_u3msi.c
@@ -116,6 +116,7 @@ static void u3msi_teardown_msi_irqs(struct pci_dev *pdev)
 		hwirq = virq_to_hw(entry->irq);
 		irq_set_msi_desc(entry->irq, NULL);
 		irq_dispose_mapping(entry->irq);
+		entry->irq = 0;
 		msi_bitmap_free_hwirqs(&msi_mpic->msi_bitmap, hwirq, 1);
 	}
 
diff --git a/arch/powerpc/sysdev/ppc4xx_hsta_msi.c b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
index 9926ad67af76..ac5fbb2492aa 100644
--- a/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
+++ b/arch/powerpc/sysdev/ppc4xx_hsta_msi.c
@@ -121,6 +121,7 @@ static void hsta_teardown_msi_irqs(struct pci_dev *dev)
 		msi_bitmap_free_hwirqs(&ppc4xx_hsta_msi.bmp, irq, 1);
 		pr_debug("%s: Teardown IRQ %u (index %u)\n", __func__,
 			 entry->irq, irq);
+		entry->irq = 0;
 	}
 }
 
-- 
2.35.1

