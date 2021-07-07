Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C053BE841
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhGGMvD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:51:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGGMvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A361E61CBB;
        Wed,  7 Jul 2021 12:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662102;
        bh=yzDNPJRst6QjXAneojtBIKy2pA4Qr4wPPz6Fi14/Zcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UgYkm3DIGiFEhLwl0YnwQ11lNaUAVz7rP0OTl5JmsTQvH3FJ8iFVa/cnLml4+Kpwh
         a4tje0bF/LOibQhX5MwnTqIuKYTFqEcrN+QO9iyesnxslyRcGPRVIiHBvFipMpfbJW
         kKN0PWmMcVM7jWC349Gxusgu4o1tVPx1Co8ADBa7X3pLrjLdMt8XbIyvLCWmnxLaw6
         voz9HrpNvtwzAfPKxFy+g2VwuYqSLgjxo4T8iy2TBYTMWxxo4Axt3QXq/6/3B3mB/4
         BHlMaC+klnn/Z56J3AEic8qVozje76hRrsxxfHlwbSsnEB4q7nlPKdr7C6xKosCwFo
         MlI0bzE8r6brg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: Linux 5.10.48
Date:   Wed,  7 Jul 2021 08:48:19 -0400
Message-Id: <20210707124819.2443474-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707124819.2443474-1-sashal@kernel.org>
References: <20210707124819.2443474-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index fb2937bca41b..52dcfe3371c4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 47
+SUBLEVEL = 48
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ef56780022c3..d1ac2de41ea8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -296,6 +296,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
+		unsigned int cr4_la57:1;
 		unsigned int maxphyaddr:6;
 	};
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b794344c02d..f2eeaf197294 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4442,6 +4442,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
+	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
 	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 14751c7ccd1f..d1300fc003ed 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1337,6 +1337,7 @@ config GPIO_TPS68470
 config GPIO_TQMX86
 	tristate "TQ-Systems QTMX86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
 	help
 	  This driver supports GPIO on the TQMX86 IO controller.
@@ -1404,6 +1405,7 @@ menu "PCI GPIO expanders"
 config GPIO_AMD8111
 	tristate "AMD 8111 GPIO driver"
 	depends on X86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	help
 	  The AMD 8111 south bridge contains 32 GPIO pins which can be used.
 
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 643f4c557ac2..ba6ed2a413f5 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -361,7 +361,7 @@ static int mxc_gpio_init_gc(struct mxc_gpio_port *port, int irq_base)
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = gpio_set_irq_type;
 	ct->chip.irq_set_wake = gpio_set_wake_irq;
-	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND;
+	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND;
 	ct->regs.ack = GPIO_ISR;
 	ct->regs.mask = GPIO_IMR;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 7daa12eec01b..b4946b595d86 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -590,7 +590,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
@@ -610,7 +610,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_dma_tt *ttm_dma = (struct ttm_dma_tt *)nvbo->bo.ttm;
 	int i;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 
 	/* Don't waste time looping if the object is coherent */
diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 13d50b178166..b3391ecedda7 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -2136,6 +2136,13 @@ static int UVERBS_HANDLER(MLX5_IB_METHOD_FLOW_MATCHER_CREATE)(
 	if (err)
 		goto end;
 
+	if (obj->ns_type == MLX5_FLOW_NAMESPACE_FDB &&
+	    mlx5_eswitch_mode(dev->mdev->priv.eswitch) !=
+			      MLX5_ESWITCH_OFFLOADS) {
+		err = -EINVAL;
+		goto end;
+	}
+
 	uobj->object = obj;
 	obj->mdev = dev->mdev;
 	atomic_set(&obj->usecnt, 0);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fd4b582110b2..77961f058367 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -220,6 +220,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
