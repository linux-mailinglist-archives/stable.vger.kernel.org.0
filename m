Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FF73BE839
	for <lists+stable@lfdr.de>; Wed,  7 Jul 2021 14:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhGGMuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Jul 2021 08:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhGGMuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Jul 2021 08:50:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ABCE961CB9;
        Wed,  7 Jul 2021 12:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625662079;
        bh=h0w2AUulzMdGWvct8mEio5e0WbYK73fiHC1xU5kohCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pcx8G05o4F1WtX0hRIUHr0vZF+VywB87kV9BXSHUJQQhDjXPvQBQELBK8+7R+goS5
         00ZAx4cER5tJwAJ9yZ0jPl6MnQFUXRaH2LtLR1Ep/E/gXAyPyYfacJP4e9OphcARPV
         4JlEEzpDYcOfIefTznh5aLyAnALH4Q4kAsPEshIHKcHXIa3GuMiCs/YadrSp/r0BMF
         ViwSOCFajQWxz36I0gz0V9vSAmqfxtZbOp1Ptwt/shhIKK9ymjh0LwnB8BFNoOQsMh
         hY2T1iDBYaUEZT9Cobb0acK0dV+oQOqTVRCHLKDynboZJQvr0Xgm7bFwIl8gWDtfIG
         74Zl+H7g1ZOgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc:     lwn@lwn.net, jslaby@suse.cz, gregkh@linuxfoundation.org
Subject: Re: Linux 5.12.15
Date:   Wed,  7 Jul 2021 08:47:56 -0400
Message-Id: <20210707124756.2443365-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210707124756.2443365-1-sashal@kernel.org>
References: <20210707124756.2443365-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 433f164f9ee0..09e1a0967bab 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 12
-SUBLEVEL = 14
+SUBLEVEL = 15
 EXTRAVERSION =
 NAME = Frozen Wasteland
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index eec2dcca2f39..ac7c786fa09f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -307,6 +307,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_pke:1;
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
+		unsigned int cr4_la57:1;
 		unsigned int maxphyaddr:6;
 	};
 };
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 676ec0d1e6be..fb2231cf19b5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4463,6 +4463,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
 	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
+	ext.cr4_la57 = !!kvm_read_cr4_bits(vcpu, X86_CR4_LA57);
 	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index e3607ec4c2e8..fb365aef336b 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1361,6 +1361,7 @@ config GPIO_TPS68470
 config GPIO_TQMX86
 	tristate "TQ-Systems QTMX86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
 	help
 	  This driver supports GPIO on the TQMX86 IO controller.
@@ -1428,6 +1429,7 @@ menu "PCI GPIO expanders"
 config GPIO_AMD8111
 	tristate "AMD 8111 GPIO driver"
 	depends on X86 || COMPILE_TEST
+	depends on HAS_IOPORT_MAP
 	help
 	  The AMD 8111 south bridge contains 32 GPIO pins which can be used.
 
diff --git a/drivers/gpio/gpio-mxc.c b/drivers/gpio/gpio-mxc.c
index 157106e1e438..b9fdf05d7669 100644
--- a/drivers/gpio/gpio-mxc.c
+++ b/drivers/gpio/gpio-mxc.c
@@ -334,7 +334,7 @@ static int mxc_gpio_init_gc(struct mxc_gpio_port *port, int irq_base)
 	ct->chip.irq_unmask = irq_gc_mask_set_bit;
 	ct->chip.irq_set_type = gpio_set_irq_type;
 	ct->chip.irq_set_wake = gpio_set_wake_irq;
-	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND;
+	ct->chip.flags = IRQCHIP_MASK_ON_SUSPEND | IRQCHIP_ENABLE_WAKEUP_ON_SUSPEND;
 	ct->regs.ack = GPIO_ISR;
 	ct->regs.mask = GPIO_IMR;
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index f2720a006199..0a47a2a5553d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -549,7 +549,7 @@ nouveau_bo_sync_for_device(struct nouveau_bo *nvbo)
 	struct ttm_tt *ttm_dma = (struct ttm_tt *)nvbo->bo.ttm;
 	int i, j;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 	if (!ttm_dma->pages) {
 		NV_DEBUG(drm, "ttm_dma 0x%p: pages NULL\n", ttm_dma);
@@ -585,7 +585,7 @@ nouveau_bo_sync_for_cpu(struct nouveau_bo *nvbo)
 	struct ttm_tt *ttm_dma = (struct ttm_tt *)nvbo->bo.ttm;
 	int i, j;
 
-	if (!ttm_dma)
+	if (!ttm_dma || !ttm_dma->dma_address)
 		return;
 	if (!ttm_dma->pages) {
 		NV_DEBUG(drm, "ttm_dma 0x%p: pages NULL\n", ttm_dma);
diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 6946a7e26eff..ef5e792c665f 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -366,16 +366,6 @@ static int vfio_ap_mdev_remove(struct mdev_device *mdev)
 	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
 
 	mutex_lock(&matrix_dev->lock);
-
-	/*
-	 * If the KVM pointer is in flux or the guest is running, disallow
-	 * un-assignment of control domain.
-	 */
-	if (matrix_mdev->kvm_busy || matrix_mdev->kvm) {
-		mutex_unlock(&matrix_dev->lock);
-		return -EBUSY;
-	}
-
 	vfio_ap_mdev_reset_queues(mdev);
 	list_del(&matrix_mdev->node);
 	kfree(matrix_mdev);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index e4633b84c556..7815ed642d43 100644
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
 
