Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2020B52B547
	for <lists+stable@lfdr.de>; Wed, 18 May 2022 11:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbiERIxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 May 2022 04:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiERIx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 May 2022 04:53:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E0F56415;
        Wed, 18 May 2022 01:53:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 664B5616C7;
        Wed, 18 May 2022 08:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE44BC34100;
        Wed, 18 May 2022 08:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652864002;
        bh=vVcnKpUVTHpEga9g3Y/4kvRGCntZDrCClGE8CYjshNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bh31lUHv3sMMWiaE+SLA8EDD5H7HUXH6SguYX3vFaHZ5ReZYhW0UKAvY7JLxRfEZP
         +AGwBfx6jKvjh8pY3RO8OVgBD+F3SQ0gvyBaxOwpfVboZHoRMpECNfv61XiqSEcKzG
         3lQRLGGnZv0rv2gInGhNX0M71Jmmh+FYRmR/tSbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.41
Date:   Wed, 18 May 2022 10:53:13 +0200
Message-Id: <1652863993254247@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <16528639938379@kroah.com>
References: <16528639938379@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index d8003cb5b6ba..c940e6542c8f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 40
+SUBLEVEL = 41
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index f74944c6fe8d..79d246ac93ab 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -436,6 +436,9 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
 extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
 #endif
 
 /*
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 80fb5a4a5c05..2660bdfcad4d 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -479,3 +479,11 @@ void __init early_ioremap_init(void)
 {
 	early_ioremap_setup();
 }
+
+bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+				 unsigned long flags)
+{
+	unsigned long pfn = PHYS_PFN(offset);
+
+	return memblock_is_map_memory(pfn);
+}
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 7fd836bea7eb..3995652daf81 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -192,4 +192,8 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
 extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
+
 #endif	/* __ASM_IO_H */
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 3f1490bfb938..749e31475e41 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -74,6 +74,10 @@ obj-$(CONFIG_ARM64_MTE)			+= mte.o
 obj-y					+= vdso-wrap.o
 obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
 
+# Force dependency (vdso*-wrap.S includes vdso.so through incbin)
+$(obj)/vdso-wrap.o: $(obj)/vdso/vdso.so
+$(obj)/vdso32-wrap.o: $(obj)/vdso32/vdso.so
+
 obj-y					+= probes/
 head-y					:= head.o
 extra-y					+= $(head-y) vmlinux.lds
diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index 945e6bb326e3..b5d8f72e8b32 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -48,9 +48,6 @@ GCOV_PROFILE := n
 targets += vdso.lds
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
-# Force dependency (incbin is bad)
-$(obj)/vdso.o : $(obj)/vdso.so
-
 # Link rule for the .so file, .lds has to be first
 $(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 3514269ac75f..83e9399e3836 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -144,9 +144,6 @@ obj-vdso := $(c-obj-vdso) $(c-obj-vdso-gettimeofday) $(asm-obj-vdso)
 targets += vdso.lds
 CPPFLAGS_vdso.lds += -P -C -U$(ARCH)
 
-# Force dependency (vdso.s includes vdso.so through incbin)
-$(obj)/vdso.o: $(obj)/vdso.so
-
 include/generated/vdso32-offsets.h: $(obj)/vdso.so.dbg FORCE
 	$(call if_changed,vdsosym)
 
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index b7c81dacabf0..b21f91cd830d 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -99,3 +99,11 @@ void __init early_ioremap_init(void)
 {
 	early_ioremap_setup();
 }
+
+bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+				 unsigned long flags)
+{
+	unsigned long pfn = PHYS_PFN(offset);
+
+	return pfn_is_map_memory(pfn);
+}
diff --git a/arch/powerpc/kvm/book3s_32_sr.S b/arch/powerpc/kvm/book3s_32_sr.S
index e3ab9df6cf19..6cfcd20d4668 100644
--- a/arch/powerpc/kvm/book3s_32_sr.S
+++ b/arch/powerpc/kvm/book3s_32_sr.S
@@ -122,11 +122,27 @@
 
 	/* 0x0 - 0xb */
 
-	/* 'current->mm' needs to be in r4 */
-	tophys(r4, r2)
-	lwz	r4, MM(r4)
-	tophys(r4, r4)
-	/* This only clobbers r0, r3, r4 and r5 */
+	/* switch_mmu_context() needs paging, let's enable it */
+	mfmsr   r9
+	ori     r11, r9, MSR_DR
+	mtmsr   r11
+	sync
+
+	/* switch_mmu_context() clobbers r12, rescue it */
+	SAVE_GPR(12, r1)
+
+	/* Calling switch_mmu_context(<inv>, current->mm, <inv>); */
+	lwz	r4, MM(r2)
 	bl	switch_mmu_context
 
+	/* restore r12 */
+	REST_GPR(12, r1)
+
+	/* Disable paging again */
+	mfmsr   r9
+	li      r6, MSR_DR
+	andc    r9, r9, r6
+	mtmsr	r9
+	sync
+
 .endm
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index d4fd1426a822..c7b7a60f6405 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -32,6 +32,16 @@ KBUILD_CFLAGS_DECOMPRESSOR += -fno-stack-protector
 KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, address-of-packed-member)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO),-g)
 KBUILD_CFLAGS_DECOMPRESSOR += $(if $(CONFIG_DEBUG_INFO_DWARF4), $(call cc-option, -gdwarf-4,))
+
+ifdef CONFIG_CC_IS_GCC
+	ifeq ($(call cc-ifversion, -ge, 1200, y), y)
+		ifeq ($(call cc-ifversion, -lt, 1300, y), y)
+			KBUILD_CFLAGS += $(call cc-disable-warning, array-bounds)
+			KBUILD_CFLAGS_DECOMPRESSOR += $(call cc-disable-warning, array-bounds)
+		endif
+	endif
+endif
+
 UTS_MACHINE	:= s390x
 STACK_SIZE	:= $(if $(CONFIG_KASAN),65536,16384)
 CHECKFLAGS	+= -D__s390__ -D__s390x__
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 36098226a957..b01f5d2caad0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -902,6 +902,8 @@ static void __meminit vmemmap_use_sub_pmd(unsigned long start, unsigned long end
 
 static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long end)
 {
+	const unsigned long page = ALIGN_DOWN(start, PMD_SIZE);
+
 	vmemmap_flush_unused_pmd();
 
 	/*
@@ -914,8 +916,7 @@ static void __meminit vmemmap_use_new_sub_pmd(unsigned long start, unsigned long
 	 * Mark with PAGE_UNUSED the unused parts of the new memmap range
 	 */
 	if (!IS_ALIGNED(start, PMD_SIZE))
-		memset((void *)start, PAGE_UNUSED,
-			start - ALIGN_DOWN(start, PMD_SIZE));
+		memset((void *)page, PAGE_UNUSED, start - page);
 
 	/*
 	 * We want to avoid memset(PAGE_UNUSED) when populating the vmemmap of
diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
index ef904b8b112e..04ede46f7512 100644
--- a/drivers/base/firmware_loader/main.c
+++ b/drivers/base/firmware_loader/main.c
@@ -795,6 +795,8 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 		  size_t offset, u32 opt_flags)
 {
 	struct firmware *fw = NULL;
+	struct cred *kern_cred = NULL;
+	const struct cred *old_cred;
 	bool nondirect = false;
 	int ret;
 
@@ -811,6 +813,18 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	if (ret <= 0) /* error or already assigned */
 		goto out;
 
+	/*
+	 * We are about to try to access the firmware file. Because we may have been
+	 * called by a driver when serving an unrelated request from userland, we use
+	 * the kernel credentials to read the file.
+	 */
+	kern_cred = prepare_kernel_cred(NULL);
+	if (!kern_cred) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	old_cred = override_creds(kern_cred);
+
 	ret = fw_get_filesystem_firmware(device, fw->priv, "", NULL);
 
 	/* Only full reads can support decompression, platform, and sysfs. */
@@ -836,6 +850,9 @@ _request_firmware(const struct firmware **firmware_p, const char *name,
 	} else
 		ret = assign_fw(fw, device);
 
+	revert_creds(old_cred);
+	put_cred(kern_cred);
+
  out:
 	if (ret < 0) {
 		fw_abort_batch_reqs(fw);
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 61e20ae7b08b..a1f09437b2b4 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -572,10 +572,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	file->f_mode |= FMODE_LSEEK;
 	dmabuf->file = file;
 
-	ret = dma_buf_stats_setup(dmabuf);
-	if (ret)
-		goto err_sysfs;
-
 	mutex_init(&dmabuf->lock);
 	INIT_LIST_HEAD(&dmabuf->attachments);
 
@@ -583,6 +579,10 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
 	list_add(&dmabuf->list_node, &db_list.head);
 	mutex_unlock(&db_list.lock);
 
+	ret = dma_buf_stats_setup(dmabuf);
+	if (ret)
+		goto err_sysfs;
+
 	return dmabuf;
 
 err_sysfs:
diff --git a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
index 8acdb244b99f..952a8aa69b9e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1386,14 +1386,8 @@ static int smu_disable_dpms(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
-	/*
-	 * TODO: (adev->in_suspend && !adev->in_s0ix) is added to pair
-	 * the workaround which always reset the asic in suspend.
-	 * It's likely that workaround will be dropped in the future.
-	 * Then the change here should be dropped together.
-	 */
 	bool use_baco = !smu->is_apu &&
-		(((amdgpu_in_reset(adev) || (adev->in_suspend && !adev->in_s0ix)) &&
+		((amdgpu_in_reset(adev) &&
 		  (amdgpu_asic_reset_method(adev) == AMD_RESET_METHOD_BACO)) ||
 		 ((adev->in_runpm || adev->in_s4) && amdgpu_asic_supports_baco(adev)));
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index 12965a832f94..aa8ed08fe9a7 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -46,8 +46,9 @@ static bool
 nouveau_get_backlight_name(char backlight_name[BL_NAME_SIZE],
 			   struct nouveau_backlight *bl)
 {
-	const int nb = ida_simple_get(&bl_ida, 0, 0, GFP_KERNEL);
-	if (nb < 0 || nb >= 100)
+	const int nb = ida_alloc_max(&bl_ida, 99, GFP_KERNEL);
+
+	if (nb < 0)
 		return false;
 	if (nb > 0)
 		snprintf(backlight_name, BL_NAME_SIZE, "nv_backlight%d", nb);
@@ -411,7 +412,7 @@ nouveau_backlight_init(struct drm_connector *connector)
 					    nv_encoder, ops, &props);
 	if (IS_ERR(bl->dev)) {
 		if (bl->id >= 0)
-			ida_simple_remove(&bl_ida, bl->id);
+			ida_free(&bl_ida, bl->id);
 		ret = PTR_ERR(bl->dev);
 		goto fail_alloc;
 	}
@@ -439,7 +440,7 @@ nouveau_backlight_fini(struct drm_connector *connector)
 		return;
 
 	if (bl->id >= 0)
-		ida_simple_remove(&bl_ida, bl->id);
+		ida_free(&bl_ida, bl->id);
 
 	backlight_device_unregister(bl->dev);
 	nv_conn->backlight = NULL;
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c
index d0d52c1d4aee..950a3de3e116 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c
@@ -123,7 +123,7 @@ nvkm_device_tegra_probe_iommu(struct nvkm_device_tegra *tdev)
 
 	mutex_init(&tdev->iommu.mutex);
 
-	if (iommu_present(&platform_bus_type)) {
+	if (device_iommu_mapped(dev)) {
 		tdev->iommu.domain = iommu_domain_alloc(&platform_bus_type);
 		if (!tdev->iommu.domain)
 			goto error;
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 07887cbfd9cb..ef7bea7c43a0 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -38,6 +38,7 @@
 #include <drm/drm_scdc_helper.h>
 #include <linux/clk.h>
 #include <linux/component.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/of_address.h>
 #include <linux/of_gpio.h>
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
index a3bfbb6c3e14..162dfeb1cc5a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
@@ -528,7 +528,7 @@ int vmw_cmd_send_fence(struct vmw_private *dev_priv, uint32_t *seqno)
 		*seqno = atomic_add_return(1, &dev_priv->marker_seq);
 	} while (*seqno == 0);
 
-	if (!(vmw_fifo_caps(dev_priv) & SVGA_FIFO_CAP_FENCE)) {
+	if (!vmw_has_fences(dev_priv)) {
 
 		/*
 		 * Don't request hardware to send a fence. The
@@ -675,11 +675,14 @@ int vmw_cmd_emit_dummy_query(struct vmw_private *dev_priv,
  */
 bool vmw_cmd_supported(struct vmw_private *vmw)
 {
-	if ((vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
-				  SVGA_CAP_CMD_BUFFERS_2)) != 0)
-		return true;
+	bool has_cmdbufs =
+		(vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
+				      SVGA_CAP_CMD_BUFFERS_2)) != 0;
+	if (vmw_is_svga_v3(vmw))
+		return (has_cmdbufs &&
+			(vmw->capabilities & SVGA_CAP_GBOBJECTS) != 0);
 	/*
 	 * We have FIFO cmd's
 	 */
-	return vmw->fifo_mem != NULL;
+	return has_cmdbufs || vmw->fifo_mem != NULL;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
index f9f28516ffb4..288e883177be 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.h
@@ -1677,4 +1677,12 @@ static inline void vmw_irq_status_write(struct vmw_private *vmw,
 		outl(status, vmw->io_start + SVGA_IRQSTATUS_PORT);
 }
 
+static inline bool vmw_has_fences(struct vmw_private *vmw)
+{
+	if ((vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
+				  SVGA_CAP_CMD_BUFFERS_2)) != 0)
+		return true;
+	return (vmw_fifo_caps(vmw) & SVGA_FIFO_CAP_FENCE) != 0;
+}
+
 #endif
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
index d18c6a56e3dc..f18ed03a8b2d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fb.c
@@ -490,7 +490,7 @@ static int vmw_fb_kms_detach(struct vmw_fb_par *par,
 
 static int vmw_fb_kms_framebuffer(struct fb_info *info)
 {
-	struct drm_mode_fb_cmd2 mode_cmd;
+	struct drm_mode_fb_cmd2 mode_cmd = {0};
 	struct vmw_fb_par *par = info->par;
 	struct fb_var_screeninfo *var = &info->var;
 	struct drm_framebuffer *cur_fb;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
index b4d9d7258a54..b32ddbb992de 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -85,6 +85,22 @@ fman_from_fence(struct vmw_fence_obj *fence)
 	return container_of(fence->base.lock, struct vmw_fence_manager, lock);
 }
 
+static u32 vmw_fence_goal_read(struct vmw_private *vmw)
+{
+	if ((vmw->capabilities2 & SVGA_CAP2_EXTRA_REGS) != 0)
+		return vmw_read(vmw, SVGA_REG_FENCE_GOAL);
+	else
+		return vmw_fifo_mem_read(vmw, SVGA_FIFO_FENCE_GOAL);
+}
+
+static void vmw_fence_goal_write(struct vmw_private *vmw, u32 value)
+{
+	if ((vmw->capabilities2 & SVGA_CAP2_EXTRA_REGS) != 0)
+		vmw_write(vmw, SVGA_REG_FENCE_GOAL, value);
+	else
+		vmw_fifo_mem_write(vmw, SVGA_FIFO_FENCE_GOAL, value);
+}
+
 /*
  * Note on fencing subsystem usage of irqs:
  * Typically the vmw_fences_update function is called
@@ -400,7 +416,7 @@ static bool vmw_fence_goal_new_locked(struct vmw_fence_manager *fman,
 	if (likely(!fman->seqno_valid))
 		return false;
 
-	goal_seqno = vmw_fifo_mem_read(fman->dev_priv, SVGA_FIFO_FENCE_GOAL);
+	goal_seqno = vmw_fence_goal_read(fman->dev_priv);
 	if (likely(passed_seqno - goal_seqno >= VMW_FENCE_WRAP))
 		return false;
 
@@ -408,9 +424,8 @@ static bool vmw_fence_goal_new_locked(struct vmw_fence_manager *fman,
 	list_for_each_entry(fence, &fman->fence_list, head) {
 		if (!list_empty(&fence->seq_passed_actions)) {
 			fman->seqno_valid = true;
-			vmw_fifo_mem_write(fman->dev_priv,
-					   SVGA_FIFO_FENCE_GOAL,
-					   fence->base.seqno);
+			vmw_fence_goal_write(fman->dev_priv,
+					     fence->base.seqno);
 			break;
 		}
 	}
@@ -442,13 +457,12 @@ static bool vmw_fence_goal_check_locked(struct vmw_fence_obj *fence)
 	if (dma_fence_is_signaled_locked(&fence->base))
 		return false;
 
-	goal_seqno = vmw_fifo_mem_read(fman->dev_priv, SVGA_FIFO_FENCE_GOAL);
+	goal_seqno = vmw_fence_goal_read(fman->dev_priv);
 	if (likely(fman->seqno_valid &&
 		   goal_seqno - fence->base.seqno < VMW_FENCE_WRAP))
 		return false;
 
-	vmw_fifo_mem_write(fman->dev_priv, SVGA_FIFO_FENCE_GOAL,
-			   fence->base.seqno);
+	vmw_fence_goal_write(fman->dev_priv, fence->base.seqno);
 	fman->seqno_valid = true;
 
 	return true;
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
index c5191de365ca..fe4732bf2c9d 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_irq.c
@@ -32,6 +32,14 @@
 
 #define VMW_FENCE_WRAP (1 << 24)
 
+static u32 vmw_irqflag_fence_goal(struct vmw_private *vmw)
+{
+	if ((vmw->capabilities2 & SVGA_CAP2_EXTRA_REGS) != 0)
+		return SVGA_IRQFLAG_REG_FENCE_GOAL;
+	else
+		return SVGA_IRQFLAG_FENCE_GOAL;
+}
+
 /**
  * vmw_thread_fn - Deferred (process context) irq handler
  *
@@ -96,7 +104,7 @@ static irqreturn_t vmw_irq_handler(int irq, void *arg)
 		wake_up_all(&dev_priv->fifo_queue);
 
 	if ((masked_status & (SVGA_IRQFLAG_ANY_FENCE |
-			      SVGA_IRQFLAG_FENCE_GOAL)) &&
+			      vmw_irqflag_fence_goal(dev_priv))) &&
 	    !test_and_set_bit(VMW_IRQTHREAD_FENCE, dev_priv->irqthread_pending))
 		ret = IRQ_WAKE_THREAD;
 
@@ -137,8 +145,7 @@ bool vmw_seqno_passed(struct vmw_private *dev_priv,
 	if (likely(dev_priv->last_read_seqno - seqno < VMW_FENCE_WRAP))
 		return true;
 
-	if (!(vmw_fifo_caps(dev_priv) & SVGA_FIFO_CAP_FENCE) &&
-	    vmw_fifo_idle(dev_priv, seqno))
+	if (!vmw_has_fences(dev_priv) && vmw_fifo_idle(dev_priv, seqno))
 		return true;
 
 	/**
@@ -160,6 +167,7 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 		      unsigned long timeout)
 {
 	struct vmw_fifo_state *fifo_state = dev_priv->fifo;
+	bool fifo_down = false;
 
 	uint32_t count = 0;
 	uint32_t signal_seq;
@@ -176,12 +184,14 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 	 */
 
 	if (fifo_idle) {
-		down_read(&fifo_state->rwsem);
 		if (dev_priv->cman) {
 			ret = vmw_cmdbuf_idle(dev_priv->cman, interruptible,
 					      10*HZ);
 			if (ret)
 				goto out_err;
+		} else if (fifo_state) {
+			down_read(&fifo_state->rwsem);
+			fifo_down = true;
 		}
 	}
 
@@ -218,12 +228,12 @@ int vmw_fallback_wait(struct vmw_private *dev_priv,
 		}
 	}
 	finish_wait(&dev_priv->fence_queue, &__wait);
-	if (ret == 0 && fifo_idle)
+	if (ret == 0 && fifo_idle && fifo_state)
 		vmw_fence_write(dev_priv, signal_seq);
 
 	wake_up_all(&dev_priv->fence_queue);
 out_err:
-	if (fifo_idle)
+	if (fifo_down)
 		up_read(&fifo_state->rwsem);
 
 	return ret;
@@ -266,13 +276,13 @@ void vmw_seqno_waiter_remove(struct vmw_private *dev_priv)
 
 void vmw_goal_waiter_add(struct vmw_private *dev_priv)
 {
-	vmw_generic_waiter_add(dev_priv, SVGA_IRQFLAG_FENCE_GOAL,
+	vmw_generic_waiter_add(dev_priv, vmw_irqflag_fence_goal(dev_priv),
 			       &dev_priv->goal_queue_waiters);
 }
 
 void vmw_goal_waiter_remove(struct vmw_private *dev_priv)
 {
-	vmw_generic_waiter_remove(dev_priv, SVGA_IRQFLAG_FENCE_GOAL,
+	vmw_generic_waiter_remove(dev_priv, vmw_irqflag_fence_goal(dev_priv),
 				  &dev_priv->goal_queue_waiters);
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 14e8f665b13b..50c64e7813be 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1336,7 +1336,6 @@ vmw_kms_new_framebuffer(struct vmw_private *dev_priv,
 		ret = vmw_kms_new_framebuffer_surface(dev_priv, surface, &vfb,
 						      mode_cmd,
 						      is_bo_proxy);
-
 		/*
 		 * vmw_create_bo_proxy() adds a reference that is no longer
 		 * needed
@@ -1398,13 +1397,16 @@ static struct drm_framebuffer *vmw_kms_fb_create(struct drm_device *dev,
 	ret = vmw_user_lookup_handle(dev_priv, tfile,
 				     mode_cmd->handles[0],
 				     &surface, &bo);
-	if (ret)
+	if (ret) {
+		DRM_ERROR("Invalid buffer object handle %u (0x%x).\n",
+			  mode_cmd->handles[0], mode_cmd->handles[0]);
 		goto err_out;
+	}
 
 
 	if (!bo &&
 	    !vmw_kms_srf_ok(dev_priv, mode_cmd->width, mode_cmd->height)) {
-		DRM_ERROR("Surface size cannot exceed %dx%d",
+		DRM_ERROR("Surface size cannot exceed %dx%d\n",
 			dev_priv->texture_max_width,
 			dev_priv->texture_max_height);
 		goto err_out;
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index ccdaeafed0bb..51f1caa10d11 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -944,7 +944,7 @@ config SENSORS_LTC4261
 
 config SENSORS_LTQ_CPUTEMP
 	bool "Lantiq cpu temperature sensor driver"
-	depends on LANTIQ
+	depends on SOC_XWAY
 	help
 	  If you say yes here you get support for the temperature
 	  sensor inside your CPU.
diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 4dec793fd07d..94b35723ee7a 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -1577,8 +1577,9 @@ static ssize_t show_temp(struct device *dev, struct device_attribute *devattr,
 		temp *= 125;
 		if (sign)
 			temp -= 128000;
-	} else
-		temp = data->temp[nr] * 1000;
+	} else {
+		temp = ((s8)data->temp[nr]) * 1000;
+	}
 
 	return sprintf(buf, "%d\n", temp);
 }
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 9dc210b55e69..48466b0a4bb0 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -730,10 +730,21 @@ static int tmp401_probe(struct i2c_client *client)
 	return 0;
 }
 
+static const struct of_device_id __maybe_unused tmp4xx_of_match[] = {
+	{ .compatible = "ti,tmp401", },
+	{ .compatible = "ti,tmp411", },
+	{ .compatible = "ti,tmp431", },
+	{ .compatible = "ti,tmp432", },
+	{ .compatible = "ti,tmp435", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, tmp4xx_of_match);
+
 static struct i2c_driver tmp401_driver = {
 	.class		= I2C_CLASS_HWMON,
 	.driver = {
 		.name	= "tmp401",
+		.of_match_table = of_match_ptr(tmp4xx_of_match),
 	},
 	.probe_new	= tmp401_probe,
 	.id_table	= tmp401_id,
diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 082a3ddb0fa3..632f65e53b63 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -3242,15 +3242,10 @@ enum irdma_status_code irdma_setup_cm_core(struct irdma_device *iwdev,
  */
 void irdma_cleanup_cm_core(struct irdma_cm_core *cm_core)
 {
-	unsigned long flags;
-
 	if (!cm_core)
 		return;
 
-	spin_lock_irqsave(&cm_core->ht_lock, flags);
-	if (timer_pending(&cm_core->tcp_timer))
-		del_timer_sync(&cm_core->tcp_timer);
-	spin_unlock_irqrestore(&cm_core->ht_lock, flags);
+	del_timer_sync(&cm_core->tcp_timer);
 
 	destroy_workqueue(cm_core->event_wq);
 	cm_core->dev->ws_reset(&cm_core->iwdev->vsi);
diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index 9050ca1f4285..808f6e7a8048 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -1087,9 +1087,15 @@ static int of_count_icc_providers(struct device_node *np)
 {
 	struct device_node *child;
 	int count = 0;
+	const struct of_device_id __maybe_unused ignore_list[] = {
+		{ .compatible = "qcom,sc7180-ipa-virt" },
+		{ .compatible = "qcom,sdx55-ipa-virt" },
+		{}
+	};
 
 	for_each_available_child_of_node(np, child) {
-		if (of_property_read_bool(child, "#interconnect-cells"))
+		if (of_property_read_bool(child, "#interconnect-cells") &&
+		    likely(!of_match_node(ignore_list, child)))
 			count++;
 		count += of_count_icc_providers(child);
 	}
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
index 01e9b50b10a1..87bf522b9d2e 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c
@@ -258,6 +258,34 @@ static void nvidia_smmu_probe_finalize(struct arm_smmu_device *smmu, struct devi
 			dev_name(dev), err);
 }
 
+static int nvidia_smmu_init_context(struct arm_smmu_domain *smmu_domain,
+				    struct io_pgtable_cfg *pgtbl_cfg,
+				    struct device *dev)
+{
+	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	const struct device_node *np = smmu->dev->of_node;
+
+	/*
+	 * Tegra194 and Tegra234 SoCs have the erratum that causes walk cache
+	 * entries to not be invalidated correctly. The problem is that the walk
+	 * cache index generated for IOVA is not same across translation and
+	 * invalidation requests. This is leading to page faults when PMD entry
+	 * is released during unmap and populated with new PTE table during
+	 * subsequent map request. Disabling large page mappings avoids the
+	 * release of PMD entry and avoid translations seeing stale PMD entry in
+	 * walk cache.
+	 * Fix this by limiting the page mappings to PAGE_SIZE on Tegra194 and
+	 * Tegra234.
+	 */
+	if (of_device_is_compatible(np, "nvidia,tegra234-smmu") ||
+	    of_device_is_compatible(np, "nvidia,tegra194-smmu")) {
+		smmu->pgsize_bitmap = PAGE_SIZE;
+		pgtbl_cfg->pgsize_bitmap = smmu->pgsize_bitmap;
+	}
+
+	return 0;
+}
+
 static const struct arm_smmu_impl nvidia_smmu_impl = {
 	.read_reg = nvidia_smmu_read_reg,
 	.write_reg = nvidia_smmu_write_reg,
@@ -268,10 +296,12 @@ static const struct arm_smmu_impl nvidia_smmu_impl = {
 	.global_fault = nvidia_smmu_global_fault,
 	.context_fault = nvidia_smmu_context_fault,
 	.probe_finalize = nvidia_smmu_probe_finalize,
+	.init_context = nvidia_smmu_init_context,
 };
 
 static const struct arm_smmu_impl nvidia_smmu_single_impl = {
 	.probe_finalize = nvidia_smmu_probe_finalize,
+	.init_context = nvidia_smmu_init_context,
 };
 
 struct arm_smmu_device *nvidia_smmu_impl_init(struct arm_smmu_device *smmu)
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 2e314e3021d8..b3a43a3d90e4 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -796,6 +796,9 @@ static void bcm_sf2_sw_mac_link_down(struct dsa_switch *ds, int port,
 	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
 	u32 reg, offset;
 
+	if (priv->wol_ports_mask & BIT(port))
+		return;
+
 	if (port != core_readl(priv, CORE_IMP0_PRT_ID)) {
 		if (priv->type == BCM4908_DEVICE_ID ||
 		    priv->type == BCM7445_DEVICE_ID)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 3a529ee8c834..831833911a52 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -449,7 +449,7 @@ static int aq_pm_freeze(struct device *dev)
 
 static int aq_pm_suspend_poweroff(struct device *dev)
 {
-	return aq_suspend_common(dev, false);
+	return aq_suspend_common(dev, true);
 }
 
 static int aq_pm_thaw(struct device *dev)
@@ -459,7 +459,7 @@ static int aq_pm_thaw(struct device *dev)
 
 static int aq_pm_resume_restore(struct device *dev)
 {
-	return atl_resume_common(dev, false);
+	return atl_resume_common(dev, true);
 }
 
 static const struct dev_pm_ops aq_pm_ops = {
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 8bcc39b1575c..ea1391753752 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3950,6 +3950,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		goto err;
 	}
 	priv->wol_irq = platform_get_irq_optional(pdev, 2);
+	if (priv->wol_irq == -EPROBE_DEFER) {
+		err = priv->wol_irq;
+		goto err;
+	}
 
 	priv->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(priv->base)) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 64144b6171d7..b1c9f65ab10f 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2793,14 +2793,14 @@ int t4_get_raw_vpd_params(struct adapter *adapter, struct vpd_params *p)
 		goto out;
 	na = ret;
 
-	memcpy(p->id, vpd + id, min_t(int, id_len, ID_LEN));
+	memcpy(p->id, vpd + id, min_t(unsigned int, id_len, ID_LEN));
 	strim(p->id);
-	memcpy(p->sn, vpd + sn, min_t(int, sn_len, SERNUM_LEN));
+	memcpy(p->sn, vpd + sn, min_t(unsigned int, sn_len, SERNUM_LEN));
 	strim(p->sn);
-	memcpy(p->pn, vpd + pn, min_t(int, pn_len, PN_LEN));
+	memcpy(p->pn, vpd + pn, min_t(unsigned int, pn_len, PN_LEN));
 	strim(p->pn);
-	memcpy(p->na, vpd + na, min_t(int, na_len, MACADDR_LEN));
-	strim((char *)p->na);
+	memcpy(p->na, vpd + na, min_t(unsigned int, na_len, MACADDR_LEN));
+	strim(p->na);
 
 out:
 	vfree(vpd);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ad73dd2540e7..29387f0814e9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7535,42 +7535,43 @@ static void i40e_free_macvlan_channels(struct i40e_vsi *vsi)
 static int i40e_fwd_ring_up(struct i40e_vsi *vsi, struct net_device *vdev,
 			    struct i40e_fwd_adapter *fwd)
 {
+	struct i40e_channel *ch = NULL, *ch_tmp, *iter;
 	int ret = 0, num_tc = 1,  i, aq_err;
-	struct i40e_channel *ch, *ch_tmp;
 	struct i40e_pf *pf = vsi->back;
 	struct i40e_hw *hw = &pf->hw;
 
-	if (list_empty(&vsi->macvlan_list))
-		return -EINVAL;
-
 	/* Go through the list and find an available channel */
-	list_for_each_entry_safe(ch, ch_tmp, &vsi->macvlan_list, list) {
-		if (!i40e_is_channel_macvlan(ch)) {
-			ch->fwd = fwd;
+	list_for_each_entry_safe(iter, ch_tmp, &vsi->macvlan_list, list) {
+		if (!i40e_is_channel_macvlan(iter)) {
+			iter->fwd = fwd;
 			/* record configuration for macvlan interface in vdev */
 			for (i = 0; i < num_tc; i++)
 				netdev_bind_sb_channel_queue(vsi->netdev, vdev,
 							     i,
-							     ch->num_queue_pairs,
-							     ch->base_queue);
-			for (i = 0; i < ch->num_queue_pairs; i++) {
+							     iter->num_queue_pairs,
+							     iter->base_queue);
+			for (i = 0; i < iter->num_queue_pairs; i++) {
 				struct i40e_ring *tx_ring, *rx_ring;
 				u16 pf_q;
 
-				pf_q = ch->base_queue + i;
+				pf_q = iter->base_queue + i;
 
 				/* Get to TX ring ptr */
 				tx_ring = vsi->tx_rings[pf_q];
-				tx_ring->ch = ch;
+				tx_ring->ch = iter;
 
 				/* Get the RX ring ptr */
 				rx_ring = vsi->rx_rings[pf_q];
-				rx_ring->ch = ch;
+				rx_ring->ch = iter;
 			}
+			ch = iter;
 			break;
 		}
 	}
 
+	if (!ch)
+		return -EINVAL;
+
 	/* Guarantee all rings are updated before we update the
 	 * MAC address filter.
 	 */
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index df65bb494695..89bca2ed895a 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -452,6 +452,7 @@ struct ice_pf {
 	struct mutex avail_q_mutex;	/* protects access to avail_[rx|tx]qs */
 	struct mutex sw_mutex;		/* lock for protecting VSI alloc flow */
 	struct mutex tc_mutex;		/* lock to protect TC changes */
+	struct mutex adev_mutex;	/* lock to protect aux device access */
 	u32 msg_enable;
 	struct ice_ptp ptp;
 	u16 num_rdma_msix;		/* Total MSIX vectors for RDMA driver */
diff --git a/drivers/net/ethernet/intel/ice/ice_idc.c b/drivers/net/ethernet/intel/ice/ice_idc.c
index a2714988dd96..1dd3622991c6 100644
--- a/drivers/net/ethernet/intel/ice/ice_idc.c
+++ b/drivers/net/ethernet/intel/ice/ice_idc.c
@@ -37,14 +37,17 @@ void ice_send_event_to_aux(struct ice_pf *pf, struct iidc_event *event)
 	if (WARN_ON_ONCE(!in_task()))
 		return;
 
+	mutex_lock(&pf->adev_mutex);
 	if (!pf->adev)
-		return;
+		goto finish;
 
 	device_lock(&pf->adev->dev);
 	iadrv = ice_get_auxiliary_drv(pf);
 	if (iadrv && iadrv->event_handler)
 		iadrv->event_handler(pf, event);
 	device_unlock(&pf->adev->dev);
+finish:
+	mutex_unlock(&pf->adev_mutex);
 }
 
 /**
@@ -285,7 +288,6 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 		return -ENOMEM;
 
 	adev = &iadev->adev;
-	pf->adev = adev;
 	iadev->pf = pf;
 
 	adev->id = pf->aux_idx;
@@ -295,18 +297,20 @@ int ice_plug_aux_dev(struct ice_pf *pf)
 
 	ret = auxiliary_device_init(adev);
 	if (ret) {
-		pf->adev = NULL;
 		kfree(iadev);
 		return ret;
 	}
 
 	ret = auxiliary_device_add(adev);
 	if (ret) {
-		pf->adev = NULL;
 		auxiliary_device_uninit(adev);
 		return ret;
 	}
 
+	mutex_lock(&pf->adev_mutex);
+	pf->adev = adev;
+	mutex_unlock(&pf->adev_mutex);
+
 	return 0;
 }
 
@@ -315,12 +319,17 @@ int ice_plug_aux_dev(struct ice_pf *pf)
  */
 void ice_unplug_aux_dev(struct ice_pf *pf)
 {
-	if (!pf->adev)
-		return;
+	struct auxiliary_device *adev;
 
-	auxiliary_device_delete(pf->adev);
-	auxiliary_device_uninit(pf->adev);
+	mutex_lock(&pf->adev_mutex);
+	adev = pf->adev;
 	pf->adev = NULL;
+	mutex_unlock(&pf->adev_mutex);
+
+	if (adev) {
+		auxiliary_device_delete(adev);
+		auxiliary_device_uninit(adev);
+	}
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index f330bd0acf9f..27b5c75ce386 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3447,6 +3447,7 @@ u16 ice_get_avail_rxq_count(struct ice_pf *pf)
 static void ice_deinit_pf(struct ice_pf *pf)
 {
 	ice_service_task_stop(pf);
+	mutex_destroy(&pf->adev_mutex);
 	mutex_destroy(&pf->sw_mutex);
 	mutex_destroy(&pf->tc_mutex);
 	mutex_destroy(&pf->avail_q_mutex);
@@ -3527,6 +3528,7 @@ static int ice_init_pf(struct ice_pf *pf)
 
 	mutex_init(&pf->sw_mutex);
 	mutex_init(&pf->tc_mutex);
+	mutex_init(&pf->adev_mutex);
 
 	INIT_HLIST_HEAD(&pf->aq_wait_list);
 	spin_lock_init(&pf->aq_wait_lock);
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index eb9193682579..ef26ff351b57 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1375,6 +1375,7 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
 
 /**
  * ice_ptp_tx_tstamp_cleanup - Cleanup old timestamp requests that got dropped
+ * @hw: pointer to the hw struct
  * @tx: PTP Tx tracker to clean up
  *
  * Loop through the Tx timestamp requests and see if any of them have been
@@ -1383,7 +1384,7 @@ ice_ptp_init_tx_e810(struct ice_pf *pf, struct ice_ptp_tx *tx)
  * timestamp will never be captured. This might happen if the packet gets
  * discarded before it reaches the PHY timestamping block.
  */
-static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
+static void ice_ptp_tx_tstamp_cleanup(struct ice_hw *hw, struct ice_ptp_tx *tx)
 {
 	u8 idx;
 
@@ -1392,11 +1393,16 @@ static void ice_ptp_tx_tstamp_cleanup(struct ice_ptp_tx *tx)
 
 	for_each_set_bit(idx, tx->in_use, tx->len) {
 		struct sk_buff *skb;
+		u64 raw_tstamp;
 
 		/* Check if this SKB has been waiting for too long */
 		if (time_is_after_jiffies(tx->tstamps[idx].start + 2 * HZ))
 			continue;
 
+		/* Read tstamp to be able to use this register again */
+		ice_read_phy_tstamp(hw, tx->quad, idx + tx->quad_offset,
+				    &raw_tstamp);
+
 		spin_lock(&tx->lock);
 		skb = tx->tstamps[idx].skb;
 		tx->tstamps[idx].skb = NULL;
@@ -1418,7 +1424,7 @@ static void ice_ptp_periodic_work(struct kthread_work *work)
 
 	ice_ptp_update_cached_phctime(pf);
 
-	ice_ptp_tx_tstamp_cleanup(&pf->ptp.port.tx);
+	ice_ptp_tx_tstamp_cleanup(&pf->hw, &pf->ptp.port.tx);
 
 	/* Run twice a second */
 	kthread_queue_delayed_work(ptp->kworker, &ptp->work,
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 3ad10c793308..66298e2235c9 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -395,7 +395,7 @@ static void mtk_ppe_init_foe_table(struct mtk_ppe *ppe)
 	static const u8 skip[] = { 12, 25, 38, 51, 76, 89, 102 };
 	int i, k;
 
-	memset(ppe->foe_table, 0, MTK_PPE_ENTRIES * sizeof(ppe->foe_table));
+	memset(ppe->foe_table, 0, MTK_PPE_ENTRIES * sizeof(*ppe->foe_table));
 
 	if (!IS_ENABLED(CONFIG_SOC_MT7621))
 		return;
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index f1323af99b0c..a3a5ad5dbb0e 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -206,9 +206,10 @@ static int ocelot_flower_parse_action(struct ocelot *ocelot, int port,
 			filter->type = OCELOT_VCAP_FILTER_OFFLOAD;
 			break;
 		case FLOW_ACTION_TRAP:
-			if (filter->block_id != VCAP_IS2) {
+			if (filter->block_id != VCAP_IS2 ||
+			    filter->lookup != 0) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Trap action can only be offloaded to VCAP IS2");
+						   "Trap action can only be offloaded to VCAP IS2 lookup 0");
 				return -EOPNOTSUPP;
 			}
 			if (filter->goto_target != -1) {
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 99d7376a70a7..732a4ef22518 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -373,7 +373,6 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			 OCELOT_VCAP_BIT_0);
 	vcap_key_set(vcap, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
 		     ~filter->ingress_port_mask);
-	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_HOST_MATCH,
 			 OCELOT_VCAP_BIT_ANY);
 	vcap_key_bit_set(vcap, &data, VCAP_IS2_HK_L2_MC, filter->dmac_mc);
@@ -1153,6 +1152,8 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i - 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
@@ -1192,7 +1193,11 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 	struct ocelot_vcap_filter del_filter;
 	int i, index;
 
+	/* Need to inherit the block_id so that vcap_entry_set()
+	 * does not get confused and knows where to install it.
+	 */
 	memset(&del_filter, 0, sizeof(del_filter));
+	del_filter.block_id = filter->block_id;
 
 	/* Gets index of the filter */
 	index = ocelot_vcap_block_get_filter_index(block, filter);
@@ -1207,6 +1212,8 @@ int ocelot_vcap_filter_del(struct ocelot *ocelot,
 		struct ocelot_vcap_filter *tmp;
 
 		tmp = ocelot_vcap_block_find_filter_by_index(block, i);
+		/* Read back the filter's counters before moving it */
+		vcap_entry_get(ocelot, i + 1, tmp);
 		vcap_entry_set(ocelot, i, tmp);
 	}
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 40fa5bce2ac2..d324c292318b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -255,7 +255,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = ionic_map_bars(ionic);
 	if (err)
-		goto err_out_pci_disable_device;
+		goto err_out_pci_release_regions;
 
 	/* Configure the device */
 	err = ionic_setup(ionic);
@@ -359,6 +359,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 err_out_unmap_bars:
 	ionic_unmap_bars(ionic);
+err_out_pci_release_regions:
 	pci_release_regions(pdev);
 err_out_pci_disable_device:
 	pci_disable_device(pdev);
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index e7e2223aebbf..f5a4d8f4fd11 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -3579,6 +3579,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 		n_parts++;
 	}
 
+	if (!n_parts) {
+		kfree(parts);
+		return 0;
+	}
+
 	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
 fail:
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 1f8cfd806008..d5f2ccd3bca4 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -844,7 +844,9 @@ static void efx_set_xdp_channels(struct efx_nic *efx)
 
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 {
-	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
+	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel,
+			   *ptp_channel = efx_ptp_channel(efx);
+	struct efx_ptp_data *ptp_data = efx->ptp_data;
 	unsigned int i, next_buffer_table = 0;
 	u32 old_rxq_entries, old_txq_entries;
 	int rc, rc2;
@@ -897,11 +899,8 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	old_txq_entries = efx->txq_entries;
 	efx->rxq_entries = rxq_entries;
 	efx->txq_entries = txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
+	for (i = 0; i < efx->n_channels; i++)
+		swap(efx->channel[i], other_channel[i]);
 
 	/* Restart buffer table allocation */
 	efx->next_buffer_table = next_buffer_table;
@@ -918,6 +917,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 
 	efx_set_xdp_channels(efx);
 out:
+	efx->ptp_data = NULL;
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
 		channel = other_channel[i];
@@ -928,6 +928,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		}
 	}
 
+	efx->ptp_data = ptp_data;
 	rc2 = efx_soft_enable_interrupts(efx);
 	if (rc2) {
 		rc = rc ? rc : rc2;
@@ -944,11 +945,9 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	/* Swap back */
 	efx->rxq_entries = old_rxq_entries;
 	efx->txq_entries = old_txq_entries;
-	for (i = 0; i < efx->n_channels; i++) {
-		channel = efx->channel[i];
-		efx->channel[i] = other_channel[i];
-		other_channel[i] = channel;
-	}
+	for (i = 0; i < efx->n_channels; i++)
+		swap(efx->channel[i], other_channel[i]);
+	efx_ptp_update_channel(efx, ptp_channel);
 	goto out;
 }
 
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 797e51802ccb..725b0f38813a 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -45,6 +45,7 @@
 #include "farch_regs.h"
 #include "tx.h"
 #include "nic.h" /* indirectly includes ptp.h */
+#include "efx_channels.h"
 
 /* Maximum number of events expected to make up a PTP event */
 #define	MAX_EVENT_FRAGS			3
@@ -541,6 +542,12 @@ struct efx_channel *efx_ptp_channel(struct efx_nic *efx)
 	return efx->ptp_data ? efx->ptp_data->channel : NULL;
 }
 
+void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel)
+{
+	if (efx->ptp_data)
+		efx->ptp_data->channel = channel;
+}
+
 static u32 last_sync_timestamp_major(struct efx_nic *efx)
 {
 	struct efx_channel *channel = efx_ptp_channel(efx);
@@ -1443,6 +1450,11 @@ int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
 	int rc = 0;
 	unsigned int pos;
 
+	if (efx->ptp_data) {
+		efx->ptp_data->channel = channel;
+		return 0;
+	}
+
 	ptp = kzalloc(sizeof(struct efx_ptp_data), GFP_KERNEL);
 	efx->ptp_data = ptp;
 	if (!efx->ptp_data)
@@ -2179,7 +2191,7 @@ static const struct efx_channel_type efx_ptp_channel_type = {
 	.pre_probe		= efx_ptp_probe_channel,
 	.post_remove		= efx_ptp_remove_channel,
 	.get_name		= efx_ptp_get_channel_name,
-	/* no copy operation; there is no need to reallocate this channel */
+	.copy                   = efx_copy_channel,
 	.receive_skb		= efx_ptp_rx,
 	.want_txqs		= efx_ptp_want_txqs,
 	.keep_eventq		= false,
diff --git a/drivers/net/ethernet/sfc/ptp.h b/drivers/net/ethernet/sfc/ptp.h
index 9855e8c9e544..7b1ef7002b3f 100644
--- a/drivers/net/ethernet/sfc/ptp.h
+++ b/drivers/net/ethernet/sfc/ptp.h
@@ -16,6 +16,7 @@ struct ethtool_ts_info;
 int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel);
 void efx_ptp_defer_probe_with_channel(struct efx_nic *efx);
 struct efx_channel *efx_ptp_channel(struct efx_nic *efx);
+void efx_ptp_update_channel(struct efx_nic *efx, struct efx_channel *channel);
 void efx_ptp_remove(struct efx_nic *efx);
 int efx_ptp_set_ts_config(struct efx_nic *efx, struct ifreq *ifr);
 int efx_ptp_get_ts_config(struct efx_nic *efx, struct ifreq *ifr);
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 642472de5a08..97c1d1ecba34 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -934,8 +934,6 @@ static int xemaclite_open(struct net_device *dev)
 	xemaclite_disable_interrupts(lp);
 
 	if (lp->phy_node) {
-		u32 bmcr;
-
 		lp->phy_dev = of_phy_connect(lp->ndev, lp->phy_node,
 					     xemaclite_adjust_link, 0,
 					     PHY_INTERFACE_MODE_MII);
@@ -946,19 +944,6 @@ static int xemaclite_open(struct net_device *dev)
 
 		/* EmacLite doesn't support giga-bit speeds */
 		phy_set_max_speed(lp->phy_dev, SPEED_100);
-
-		/* Don't advertise 1000BASE-T Full/Half duplex speeds */
-		phy_write(lp->phy_dev, MII_CTRL1000, 0);
-
-		/* Advertise only 10 and 100mbps full/half duplex speeds */
-		phy_write(lp->phy_dev, MII_ADVERTISE, ADVERTISE_ALL |
-			  ADVERTISE_CSMA);
-
-		/* Restart auto negotiation */
-		bmcr = phy_read(lp->phy_dev, MII_BMCR);
-		bmcr |= (BMCR_ANENABLE | BMCR_ANRESTART);
-		phy_write(lp->phy_dev, MII_BMCR, bmcr);
-
 		phy_start(lp->phy_dev);
 	}
 
diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index e2ac61f44c94..64d829ed9887 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1544,6 +1544,7 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KS8737",
 	/* PHY_BASIC_FEATURES */
 	.driver_data	= &ks8737_type,
+	.probe		= kszphy_probe,
 	.config_init	= kszphy_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
@@ -1669,8 +1670,8 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz8061_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index beb2b66da132..f122026c4682 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -970,8 +970,13 @@ static irqreturn_t phy_interrupt(int irq, void *phy_dat)
 {
 	struct phy_device *phydev = phy_dat;
 	struct phy_driver *drv = phydev->drv;
+	irqreturn_t ret;
 
-	return drv->handle_interrupt(phydev);
+	mutex_lock(&phydev->lock);
+	ret = drv->handle_interrupt(phydev);
+	mutex_unlock(&phydev->lock);
+
+	return ret;
 }
 
 /**
diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 4720b24ca51b..90dfefc1f5f8 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -250,6 +250,7 @@ struct sfp {
 	struct sfp_eeprom_id id;
 	unsigned int module_power_mW;
 	unsigned int module_t_start_up;
+	bool tx_fault_ignore;
 
 #if IS_ENABLED(CONFIG_HWMON)
 	struct sfp_diag diag;
@@ -1945,6 +1946,12 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
 	else
 		sfp->module_t_start_up = T_START_UP;
 
+	if (!memcmp(id.base.vendor_name, "HUAWEI          ", 16) &&
+	    !memcmp(id.base.vendor_pn, "MA5671A         ", 16))
+		sfp->tx_fault_ignore = true;
+	else
+		sfp->tx_fault_ignore = false;
+
 	return 0;
 }
 
@@ -2397,7 +2404,10 @@ static void sfp_check_state(struct sfp *sfp)
 	mutex_lock(&sfp->st_mutex);
 	state = sfp_get_state(sfp);
 	changed = state ^ sfp->state;
-	changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
+	if (sfp->tx_fault_ignore)
+		changed &= SFP_F_PRESENT | SFP_F_LOS;
+	else
+		changed &= SFP_F_PRESENT | SFP_F_LOS | SFP_F_TX_FAULT;
 
 	for (i = 0; i < GPIO_MAX; i++)
 		if (changed & BIT(i))
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
index 125479b5c0d6..fc4197bf2478 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c
@@ -322,7 +322,7 @@ void iwl_dbg_tlv_del_timers(struct iwl_trans *trans)
 	struct iwl_dbg_tlv_timer_node *node, *tmp;
 
 	list_for_each_entry_safe(node, tmp, timer_list, list) {
-		del_timer(&node->timer);
+		del_timer_sync(&node->timer);
 		list_del(&node->list);
 		kfree(node);
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0aeb1e1ec93f..c3189e2c7c93 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2336,11 +2336,13 @@ static void hw_scan_work(struct work_struct *work)
 			if (req->ie_len)
 				skb_put_data(probe, req->ie, req->ie_len);
 
+			rcu_read_lock();
 			if (!ieee80211_tx_prepare_skb(hwsim->hw,
 						      hwsim->hw_scan_vif,
 						      probe,
 						      hwsim->tmp_chan->band,
 						      NULL)) {
+				rcu_read_unlock();
 				kfree_skb(probe);
 				continue;
 			}
@@ -2348,6 +2350,7 @@ static void hw_scan_work(struct work_struct *work)
 			local_bh_disable();
 			mac80211_hwsim_tx_frame(hwsim->hw, probe,
 						hwsim->tmp_chan);
+			rcu_read_unlock();
 			local_bh_enable();
 		}
 	}
diff --git a/drivers/platform/surface/aggregator/core.c b/drivers/platform/surface/aggregator/core.c
index c61bbeeec2df..54f86df77a37 100644
--- a/drivers/platform/surface/aggregator/core.c
+++ b/drivers/platform/surface/aggregator/core.c
@@ -816,7 +816,7 @@ static int __init ssam_core_init(void)
 err_bus:
 	return status;
 }
-module_init(ssam_core_init);
+subsys_initcall(ssam_core_init);
 
 static void __exit ssam_core_exit(void)
 {
diff --git a/drivers/s390/net/ctcm_mpc.c b/drivers/s390/net/ctcm_mpc.c
index f0436f555c62..be03cb123ef4 100644
--- a/drivers/s390/net/ctcm_mpc.c
+++ b/drivers/s390/net/ctcm_mpc.c
@@ -626,8 +626,6 @@ static void mpc_rcvd_sweep_resp(struct mpcg_info *mpcginfo)
 		ctcm_clear_busy_do(dev);
 	}
 
-	kfree(mpcginfo);
-
 	return;
 
 }
@@ -1192,10 +1190,10 @@ static void ctcmpc_unpack_skb(struct channel *ch, struct sk_buff *pskb)
 						CTCM_FUNTAIL, dev->name);
 			priv->stats.rx_dropped++;
 			/* mpcginfo only used for non-data transfers */
-			kfree(mpcginfo);
 			if (do_debug_data)
 				ctcmpc_dump_skb(pskb, -8);
 		}
+		kfree(mpcginfo);
 	}
 done:
 
@@ -1977,7 +1975,6 @@ static void mpc_action_rcvd_xid0(fsm_instance *fsm, int event, void *arg)
 		}
 		break;
 	}
-	kfree(mpcginfo);
 
 	CTCM_PR_DEBUG("ctcmpc:%s() %s xid2:%i xid7:%i xidt_p2:%i \n",
 		__func__, ch->id, grp->outstanding_xid2,
@@ -2038,7 +2035,6 @@ static void mpc_action_rcvd_xid7(fsm_instance *fsm, int event, void *arg)
 		mpc_validate_xid(mpcginfo);
 		break;
 	}
-	kfree(mpcginfo);
 	return;
 }
 
diff --git a/drivers/s390/net/ctcm_sysfs.c b/drivers/s390/net/ctcm_sysfs.c
index ded1930a00b2..e3813a7aa5e6 100644
--- a/drivers/s390/net/ctcm_sysfs.c
+++ b/drivers/s390/net/ctcm_sysfs.c
@@ -39,11 +39,12 @@ static ssize_t ctcm_buffer_write(struct device *dev,
 	struct ctcm_priv *priv = dev_get_drvdata(dev);
 	int rc;
 
-	ndev = priv->channel[CTCM_READ]->netdev;
-	if (!(priv && priv->channel[CTCM_READ] && ndev)) {
+	if (!(priv && priv->channel[CTCM_READ] &&
+	      priv->channel[CTCM_READ]->netdev)) {
 		CTCM_DBF_TEXT(SETUP, CTC_DBF_ERROR, "bfnondev");
 		return -ENODEV;
 	}
+	ndev = priv->channel[CTCM_READ]->netdev;
 
 	rc = kstrtouint(buf, 0, &bs1);
 	if (rc)
diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 440219bcaa2b..06a322bdced6 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1735,10 +1735,11 @@ lcs_get_control(struct lcs_card *card, struct lcs_cmd *cmd)
 			lcs_schedule_recovery(card);
 			break;
 		case LCS_CMD_STOPLAN:
-			pr_warn("Stoplan for %s initiated by LGW\n",
-				card->dev->name);
-			if (card->dev)
+			if (card->dev) {
+				pr_warn("Stoplan for %s initiated by LGW\n",
+					card->dev->name);
 				netif_carrier_off(card->dev);
+			}
 			break;
 		default:
 			LCS_DBF_TEXT(5, trace, "noLGWcmd");
diff --git a/drivers/slimbus/qcom-ctrl.c b/drivers/slimbus/qcom-ctrl.c
index f04b961b96cd..ec58091fc948 100644
--- a/drivers/slimbus/qcom-ctrl.c
+++ b/drivers/slimbus/qcom-ctrl.c
@@ -510,9 +510,9 @@ static int qcom_slim_probe(struct platform_device *pdev)
 	}
 
 	ctrl->irq = platform_get_irq(pdev, 0);
-	if (!ctrl->irq) {
+	if (ctrl->irq < 0) {
 		dev_err(&pdev->dev, "no slimbus IRQ\n");
-		return -ENODEV;
+		return ctrl->irq;
 	}
 
 	sctrl = &ctrl->ctrl;
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 2294d5b633b5..1767503de744 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1587,6 +1587,7 @@ static void gsm_dlci_data(struct gsm_dlci *dlci, const u8 *data, int clen)
 			if (len == 0)
 				return;
 		}
+		len--;
 		slen++;
 		tty = tty_port_tty_get(port);
 		if (tty) {
@@ -2275,6 +2276,7 @@ static void gsm_copy_config_values(struct gsm_mux *gsm,
 
 static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 {
+	int ret = 0;
 	int need_close = 0;
 	int need_restart = 0;
 
@@ -2342,10 +2344,13 @@ static int gsm_config(struct gsm_mux *gsm, struct gsm_config *c)
 	 * FIXME: We need to separate activation/deactivation from adding
 	 * and removing from the mux array
 	 */
-	if (need_restart)
-		gsm_activate_mux(gsm);
-	if (gsm->initiator && need_close)
-		gsm_dlci_begin_open(gsm->dlci[0]);
+	if (gsm->dead) {
+		ret = gsm_activate_mux(gsm);
+		if (ret)
+			return ret;
+		if (gsm->initiator)
+			gsm_dlci_begin_open(gsm->dlci[0]);
+	}
 	return 0;
 }
 
diff --git a/drivers/tty/serial/8250/8250_mtk.c b/drivers/tty/serial/8250/8250_mtk.c
index fb65dc601b23..de48a58460f4 100644
--- a/drivers/tty/serial/8250/8250_mtk.c
+++ b/drivers/tty/serial/8250/8250_mtk.c
@@ -37,6 +37,7 @@
 #define MTK_UART_IER_RTSI	0x40	/* Enable RTS Modem status interrupt */
 #define MTK_UART_IER_CTSI	0x80	/* Enable CTS Modem status interrupt */
 
+#define MTK_UART_EFR		38	/* I/O: Extended Features Register */
 #define MTK_UART_EFR_EN		0x10	/* Enable enhancement feature */
 #define MTK_UART_EFR_RTS	0x40	/* Enable hardware rx flow control */
 #define MTK_UART_EFR_CTS	0x80	/* Enable hardware tx flow control */
@@ -53,6 +54,9 @@
 #define MTK_UART_TX_TRIGGER	1
 #define MTK_UART_RX_TRIGGER	MTK_UART_RX_SIZE
 
+#define MTK_UART_XON1		40	/* I/O: Xon character 1 */
+#define MTK_UART_XOFF1		42	/* I/O: Xoff character 1 */
+
 #ifdef CONFIG_SERIAL_8250_DMA
 enum dma_rx_status {
 	DMA_RX_START = 0,
@@ -169,7 +173,7 @@ static void mtk8250_dma_enable(struct uart_8250_port *up)
 		   MTK_UART_DMA_EN_RX | MTK_UART_DMA_EN_TX);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 
 	if (dmaengine_slave_config(dma->rxchan, &dma->rxconf) != 0)
@@ -232,7 +236,7 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 	int lcr = serial_in(up, UART_LCR);
 
 	serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-	serial_out(up, UART_EFR, UART_EFR_ECB);
+	serial_out(up, MTK_UART_EFR, UART_EFR_ECB);
 	serial_out(up, UART_LCR, lcr);
 	lcr = serial_in(up, UART_LCR);
 
@@ -241,7 +245,7 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 		serial_out(up, MTK_UART_ESCAPE_DAT, MTK_UART_ESCAPE_CHAR);
 		serial_out(up, MTK_UART_ESCAPE_EN, 0x00);
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
-		serial_out(up, UART_EFR, serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK)));
 		serial_out(up, UART_LCR, lcr);
 		mtk8250_disable_intrs(up, MTK_UART_IER_XOFFI |
@@ -255,8 +259,8 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable hw flow control*/
-		serial_out(up, UART_EFR, MTK_UART_EFR_HW_FC |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_HW_FC |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
 		serial_out(up, UART_LCR, lcr);
@@ -270,12 +274,12 @@ static void mtk8250_set_flow_ctrl(struct uart_8250_port *up, int mode)
 		serial_out(up, UART_LCR, UART_LCR_CONF_MODE_B);
 
 		/*enable sw flow control */
-		serial_out(up, UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
-			(serial_in(up, UART_EFR) &
+		serial_out(up, MTK_UART_EFR, MTK_UART_EFR_XON1_XOFF1 |
+			(serial_in(up, MTK_UART_EFR) &
 			(~(MTK_UART_EFR_HW_FC | MTK_UART_EFR_SW_FC_MASK))));
 
-		serial_out(up, UART_XON1, START_CHAR(port->state->port.tty));
-		serial_out(up, UART_XOFF1, STOP_CHAR(port->state->port.tty));
+		serial_out(up, MTK_UART_XON1, START_CHAR(port->state->port.tty));
+		serial_out(up, MTK_UART_XOFF1, STOP_CHAR(port->state->port.tty));
 		serial_out(up, UART_LCR, lcr);
 		mtk8250_disable_intrs(up, MTK_UART_IER_CTSI|MTK_UART_IER_RTSI);
 		mtk8250_enable_intrs(up, MTK_UART_IER_XOFFI);
diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index 13ac36e2da4f..c7f81aa1ce91 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -471,11 +471,10 @@ static int digicolor_uart_probe(struct platform_device *pdev)
 	if (IS_ERR(uart_clk))
 		return PTR_ERR(uart_clk);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	dp->port.mapbase = res->start;
-	dp->port.membase = devm_ioremap_resource(&pdev->dev, res);
+	dp->port.membase = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(dp->port.membase))
 		return PTR_ERR(dp->port.membase);
+	dp->port.mapbase = res->start;
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index ac5112def40d..33e5eba6ff04 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2650,6 +2650,7 @@ static int lpuart_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	struct lpuart_port *sport;
 	struct resource *res;
+	irq_handler_t handler;
 	int ret;
 
 	sport = devm_kzalloc(&pdev->dev, sizeof(*sport), GFP_KERNEL);
@@ -2727,17 +2728,11 @@ static int lpuart_probe(struct platform_device *pdev)
 
 	if (lpuart_is_32(sport)) {
 		lpuart_reg.cons = LPUART32_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart32_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart32_int;
 	} else {
 		lpuart_reg.cons = LPUART_CONSOLE;
-		ret = devm_request_irq(&pdev->dev, sport->port.irq, lpuart_int, 0,
-					DRIVER_NAME, sport);
+		handler = lpuart_int;
 	}
-
-	if (ret)
-		goto failed_irq_request;
-
 	ret = uart_add_one_port(&lpuart_reg, &sport->port);
 	if (ret)
 		goto failed_attach_port;
@@ -2759,13 +2754,18 @@ static int lpuart_probe(struct platform_device *pdev)
 
 	sport->port.rs485_config(&sport->port, &sport->port.rs485);
 
+	ret = devm_request_irq(&pdev->dev, sport->port.irq, handler, 0,
+				DRIVER_NAME, sport);
+	if (ret)
+		goto failed_irq_request;
+
 	return 0;
 
+failed_irq_request:
 failed_get_rs485:
 failed_reset:
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
-failed_irq_request:
 	lpuart_disable_clks(sport);
 failed_clock_enable:
 failed_out_of_range:
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index fdf79bcf7eb0..0d99ba64ea52 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -774,6 +774,7 @@ static int wdm_release(struct inode *inode, struct file *file)
 			poison_urbs(desc);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
+			clear_bit(WDM_RESPONDING, &desc->flags);
 			spin_unlock_irq(&desc->iuspin);
 			desc->manage_power(desc->intf, 0);
 			unpoison_urbs(desc);
diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 9d87c0fb8f92..bf0a3fc2d776 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -884,17 +884,42 @@ static void uvc_free(struct usb_function *f)
 	kfree(uvc);
 }
 
-static void uvc_unbind(struct usb_configuration *c, struct usb_function *f)
+static void uvc_function_unbind(struct usb_configuration *c,
+				struct usb_function *f)
 {
 	struct usb_composite_dev *cdev = c->cdev;
 	struct uvc_device *uvc = to_uvc(f);
+	long wait_ret = 1;
 
-	uvcg_info(f, "%s\n", __func__);
+	uvcg_info(f, "%s()\n", __func__);
+
+	/* If we know we're connected via v4l2, then there should be a cleanup
+	 * of the device from userspace either via UVC_EVENT_DISCONNECT or
+	 * though the video device removal uevent. Allow some time for the
+	 * application to close out before things get deleted.
+	 */
+	if (uvc->func_connected) {
+		uvcg_dbg(f, "waiting for clean disconnect\n");
+		wait_ret = wait_event_interruptible_timeout(uvc->func_connected_queue,
+				uvc->func_connected == false, msecs_to_jiffies(500));
+		uvcg_dbg(f, "done waiting with ret: %ld\n", wait_ret);
+	}
 
 	device_remove_file(&uvc->vdev.dev, &dev_attr_function_name);
 	video_unregister_device(&uvc->vdev);
 	v4l2_device_unregister(&uvc->v4l2_dev);
 
+	if (uvc->func_connected) {
+		/* Wait for the release to occur to ensure there are no longer any
+		 * pending operations that may cause panics when resources are cleaned
+		 * up.
+		 */
+		uvcg_warn(f, "%s no clean disconnect, wait for release\n", __func__);
+		wait_ret = wait_event_interruptible_timeout(uvc->func_connected_queue,
+				uvc->func_connected == false, msecs_to_jiffies(1000));
+		uvcg_dbg(f, "done waiting for release with ret: %ld\n", wait_ret);
+	}
+
 	usb_ep_free_request(cdev->gadget->ep0, uvc->control_req);
 	kfree(uvc->control_buf);
 
@@ -913,6 +938,7 @@ static struct usb_function *uvc_alloc(struct usb_function_instance *fi)
 
 	mutex_init(&uvc->video.mutex);
 	uvc->state = UVC_STATE_DISCONNECTED;
+	init_waitqueue_head(&uvc->func_connected_queue);
 	opts = fi_to_f_uvc_opts(fi);
 
 	mutex_lock(&opts->lock);
@@ -943,7 +969,7 @@ static struct usb_function *uvc_alloc(struct usb_function_instance *fi)
 	/* Register the function. */
 	uvc->func.name = "uvc";
 	uvc->func.bind = uvc_function_bind;
-	uvc->func.unbind = uvc_unbind;
+	uvc->func.unbind = uvc_function_unbind;
 	uvc->func.get_alt = uvc_function_get_alt;
 	uvc->func.set_alt = uvc_function_set_alt;
 	uvc->func.disable = uvc_function_disable;
diff --git a/drivers/usb/gadget/function/uvc.h b/drivers/usb/gadget/function/uvc.h
index 9d5f17b551bb..0966c5aa2492 100644
--- a/drivers/usb/gadget/function/uvc.h
+++ b/drivers/usb/gadget/function/uvc.h
@@ -14,6 +14,7 @@
 #include <linux/spinlock.h>
 #include <linux/usb/composite.h>
 #include <linux/videodev2.h>
+#include <linux/wait.h>
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-dev.h>
@@ -127,6 +128,7 @@ struct uvc_device {
 	struct usb_function func;
 	struct uvc_video video;
 	bool func_connected;
+	wait_queue_head_t func_connected_queue;
 
 	/* Descriptors */
 	struct {
diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
index 197c26f7aec6..65abd55ce234 100644
--- a/drivers/usb/gadget/function/uvc_v4l2.c
+++ b/drivers/usb/gadget/function/uvc_v4l2.c
@@ -252,10 +252,11 @@ uvc_v4l2_subscribe_event(struct v4l2_fh *fh,
 
 static void uvc_v4l2_disable(struct uvc_device *uvc)
 {
-	uvc->func_connected = false;
 	uvc_function_disconnect(uvc);
 	uvcg_video_enable(&uvc->video, 0);
 	uvcg_free_buffers(&uvc->video.queue);
+	uvc->func_connected = false;
+	wake_up_interruptible(&uvc->func_connected_queue);
 }
 
 static int
diff --git a/drivers/usb/host/xhci-mtk-sch.c b/drivers/usb/host/xhci-mtk-sch.c
index b4c84b363507..f91a30432056 100644
--- a/drivers/usb/host/xhci-mtk-sch.c
+++ b/drivers/usb/host/xhci-mtk-sch.c
@@ -465,7 +465,7 @@ static int check_fs_bus_bw(struct mu3h_sch_ep_info *sch_ep, int offset)
 		 */
 		for (j = 0; j < sch_ep->num_budget_microframes; j++) {
 			k = XHCI_MTK_BW_INDEX(base + j);
-			tmp = tt->fs_bus_bw[k] + sch_ep->bw_budget_table[j];
+			tmp = tt->fs_bus_bw[k] + sch_ep->bw_cost_per_microframe;
 			if (tmp > FS_PAYLOAD_MAX)
 				return -ESCH_BW_OVERFLOW;
 		}
@@ -539,19 +539,17 @@ static int check_sch_tt(struct mu3h_sch_ep_info *sch_ep, u32 offset)
 static void update_sch_tt(struct mu3h_sch_ep_info *sch_ep, bool used)
 {
 	struct mu3h_sch_tt *tt = sch_ep->sch_tt;
+	int bw_updated;
 	u32 base;
-	int i, j, k;
+	int i, j;
+
+	bw_updated = sch_ep->bw_cost_per_microframe * (used ? 1 : -1);
 
 	for (i = 0; i < sch_ep->num_esit; i++) {
 		base = sch_ep->offset + i * sch_ep->esit;
 
-		for (j = 0; j < sch_ep->num_budget_microframes; j++) {
-			k = XHCI_MTK_BW_INDEX(base + j);
-			if (used)
-				tt->fs_bus_bw[k] += sch_ep->bw_budget_table[j];
-			else
-				tt->fs_bus_bw[k] -= sch_ep->bw_budget_table[j];
-		}
+		for (j = 0; j < sch_ep->num_budget_microframes; j++)
+			tt->fs_bus_bw[XHCI_MTK_BW_INDEX(base + j)] += bw_updated;
 	}
 
 	if (used)
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 1364ce7f0abf..152ad882657d 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2123,10 +2123,14 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(3) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
+	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x1782, 0x4d11, 0xff) },			/* Fibocom L610 (ECM/RNDIS mode) */
 	{ USB_DEVICE(0x2cb7, 0x0104),						/* Fibocom NL678 series */
 	  .driver_info = RSVD(4) | RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
 	  .driver_info = RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0106, 0xff) },			/* Fibocom MA510 (ECM mode w/ diag intf.) */
+	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x010a, 0xff) },			/* Fibocom MA510 (ECM mode) */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 88b284d61681..1d878d05a658 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -106,6 +106,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM220_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LCM960_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LM920_PRODUCT_ID) },
+	{ USB_DEVICE(HP_VENDOR_ID, HP_LM930_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_LM940_PRODUCT_ID) },
 	{ USB_DEVICE(HP_VENDOR_ID, HP_TD620_PRODUCT_ID) },
 	{ USB_DEVICE(CRESSI_VENDOR_ID, CRESSI_EDY_PRODUCT_ID) },
diff --git a/drivers/usb/serial/pl2303.h b/drivers/usb/serial/pl2303.h
index c5406452b774..732f9b13ad5d 100644
--- a/drivers/usb/serial/pl2303.h
+++ b/drivers/usb/serial/pl2303.h
@@ -135,6 +135,7 @@
 #define HP_TD620_PRODUCT_ID	0x0956
 #define HP_LD960_PRODUCT_ID	0x0b39
 #define HP_LD381_PRODUCT_ID	0x0f7f
+#define HP_LM930_PRODUCT_ID	0x0f9b
 #define HP_LCM220_PRODUCT_ID	0x3139
 #define HP_LCM960_PRODUCT_ID	0x3239
 #define HP_LD220_PRODUCT_ID	0x3524
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index c18bf8164bc2..586ef5551e76 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -166,6 +166,8 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
 	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
 	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
+	{DEVICE_SWI(0x1199, 0xc080)},	/* Sierra Wireless EM7590 QDL */
+	{DEVICE_SWI(0x1199, 0xc081)},	/* Sierra Wireless EM7590 */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
index 7d540afdb7cc..64e248117c41 100644
--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -877,7 +877,7 @@ static int tcpci_remove(struct i2c_client *client)
 	/* Disable chip interrupts before unregistering port */
 	err = tcpci_write16(chip->tcpci, TCPC_ALERT_MASK, 0);
 	if (err < 0)
-		return err;
+		dev_warn(&client->dev, "Failed to disable irqs (%pe)\n", ERR_PTR(err));
 
 	tcpci_unregister_port(chip->tcpci);
 
diff --git a/drivers/usb/typec/tcpm/tcpci_mt6360.c b/drivers/usb/typec/tcpm/tcpci_mt6360.c
index f1bd9e09bc87..8a952eaf9016 100644
--- a/drivers/usb/typec/tcpm/tcpci_mt6360.c
+++ b/drivers/usb/typec/tcpm/tcpci_mt6360.c
@@ -15,6 +15,9 @@
 
 #include "tcpci.h"
 
+#define MT6360_REG_PHYCTRL1	0x80
+#define MT6360_REG_PHYCTRL3	0x82
+#define MT6360_REG_PHYCTRL7	0x86
 #define MT6360_REG_VCONNCTRL1	0x8C
 #define MT6360_REG_MODECTRL2	0x8F
 #define MT6360_REG_SWRESET	0xA0
@@ -22,6 +25,8 @@
 #define MT6360_REG_DRPCTRL1	0xA2
 #define MT6360_REG_DRPCTRL2	0xA3
 #define MT6360_REG_I2CTORST	0xBF
+#define MT6360_REG_PHYCTRL11	0xCA
+#define MT6360_REG_RXCTRL1	0xCE
 #define MT6360_REG_RXCTRL2	0xCF
 #define MT6360_REG_CTDCTRL2	0xEC
 
@@ -106,6 +111,27 @@ static int mt6360_tcpc_init(struct tcpci *tcpci, struct tcpci_data *tdata)
 	if (ret)
 		return ret;
 
+	/* BMC PHY */
+	ret = mt6360_tcpc_write16(regmap, MT6360_REG_PHYCTRL1, 0x3A70);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, MT6360_REG_PHYCTRL3,  0x82);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, MT6360_REG_PHYCTRL7, 0x36);
+	if (ret)
+		return ret;
+
+	ret = mt6360_tcpc_write16(regmap, MT6360_REG_PHYCTRL11, 0x3C60);
+	if (ret)
+		return ret;
+
+	ret = regmap_write(regmap, MT6360_REG_RXCTRL1, 0xE8);
+	if (ret)
+		return ret;
+
 	/* Set shipping mode off, AUTOIDLE on */
 	return regmap_write(regmap, MT6360_REG_MODECTRL2, 0x7A);
 }
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index ea42ba6445b2..b3d5f884c544 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -243,6 +243,10 @@ static void efifb_show_boot_graphics(struct fb_info *info)
 static inline void efifb_show_boot_graphics(struct fb_info *info) {}
 #endif
 
+/*
+ * fb_ops.fb_destroy is called by the last put_fb_info() call at the end
+ * of unregister_framebuffer() or fb_release(). Do any cleanup here.
+ */
 static void efifb_destroy(struct fb_info *info)
 {
 	if (efifb_pci_dev)
@@ -254,10 +258,13 @@ static void efifb_destroy(struct fb_info *info)
 		else
 			memunmap(info->screen_base);
 	}
+
 	if (request_mem_succeeded)
 		release_mem_region(info->apertures->ranges[0].base,
 				   info->apertures->ranges[0].size);
 	fb_dealloc_cmap(&info->cmap);
+
+	framebuffer_release(info);
 }
 
 static const struct fb_ops efifb_ops = {
@@ -620,9 +627,9 @@ static int efifb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 
+	/* efifb_destroy takes care of info cleanup */
 	unregister_framebuffer(info);
 	sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
-	framebuffer_release(info);
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/simplefb.c b/drivers/video/fbdev/simplefb.c
index b63074fd892e..a2e3a4690025 100644
--- a/drivers/video/fbdev/simplefb.c
+++ b/drivers/video/fbdev/simplefb.c
@@ -70,12 +70,18 @@ struct simplefb_par;
 static void simplefb_clocks_destroy(struct simplefb_par *par);
 static void simplefb_regulators_destroy(struct simplefb_par *par);
 
+/*
+ * fb_ops.fb_destroy is called by the last put_fb_info() call at the end
+ * of unregister_framebuffer() or fb_release(). Do any cleanup here.
+ */
 static void simplefb_destroy(struct fb_info *info)
 {
 	simplefb_regulators_destroy(info->par);
 	simplefb_clocks_destroy(info->par);
 	if (info->screen_base)
 		iounmap(info->screen_base);
+
+	framebuffer_release(info);
 }
 
 static const struct fb_ops simplefb_ops = {
@@ -520,8 +526,8 @@ static int simplefb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 
+	/* simplefb_destroy takes care of info cleanup */
 	unregister_framebuffer(info);
-	framebuffer_release(info);
 
 	return 0;
 }
diff --git a/drivers/video/fbdev/vesafb.c b/drivers/video/fbdev/vesafb.c
index df6de5a9dd4c..e25e8de5ff67 100644
--- a/drivers/video/fbdev/vesafb.c
+++ b/drivers/video/fbdev/vesafb.c
@@ -179,6 +179,10 @@ static int vesafb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	return err;
 }
 
+/*
+ * fb_ops.fb_destroy is called by the last put_fb_info() call at the end
+ * of unregister_framebuffer() or fb_release(). Do any cleanup here.
+ */
 static void vesafb_destroy(struct fb_info *info)
 {
 	struct vesafb_par *par = info->par;
@@ -188,6 +192,8 @@ static void vesafb_destroy(struct fb_info *info)
 	if (info->screen_base)
 		iounmap(info->screen_base);
 	release_mem_region(info->apertures->ranges[0].base, info->apertures->ranges[0].size);
+
+	framebuffer_release(info);
 }
 
 static struct fb_ops vesafb_ops = {
@@ -484,10 +490,10 @@ static int vesafb_remove(struct platform_device *pdev)
 {
 	struct fb_info *info = platform_get_drvdata(pdev);
 
+	/* vesafb_destroy takes care of info cleanup */
 	unregister_framebuffer(info);
 	if (((struct vesafb_par *)(info->par))->region)
 		release_region(0x3c0, 32);
-	framebuffer_release(info);
 
 	return 0;
 }
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6180df6f8e61..e34d52df4a13 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -592,9 +592,15 @@ static int ceph_finish_async_create(struct inode *dir, struct dentry *dentry,
 	iinfo.change_attr = 1;
 	ceph_encode_timespec64(&iinfo.btime, &now);
 
-	iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
-	iinfo.xattr_data = xattr_buf;
-	memset(iinfo.xattr_data, 0, iinfo.xattr_len);
+	if (req->r_pagelist) {
+		iinfo.xattr_len = req->r_pagelist->length;
+		iinfo.xattr_data = req->r_pagelist->mapped_tail;
+	} else {
+		/* fake it */
+		iinfo.xattr_len = ARRAY_SIZE(xattr_buf);
+		iinfo.xattr_data = xattr_buf;
+		memset(iinfo.xattr_data, 0, iinfo.xattr_len);
+	}
 
 	in.ino = cpu_to_le64(vino.ino);
 	in.snapid = cpu_to_le64(CEPH_NOSNAP);
@@ -706,6 +712,10 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 		err = ceph_security_init_secctx(dentry, mode, &as_ctx);
 		if (err < 0)
 			goto out_ctx;
+		/* Async create can't handle more than a page of xattrs */
+		if (as_ctx.pagelist &&
+		    !list_is_singular(&as_ctx.pagelist->head))
+			try_async = false;
 	} else if (!d_in_lookup(dentry)) {
 		/* If it's not being looked up, it's negative */
 		return -ENOENT;
diff --git a/fs/file_table.c b/fs/file_table.c
index 45437f8e1003..e8c9016703ad 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -375,6 +375,7 @@ void __fput_sync(struct file *file)
 }
 
 EXPORT_SYMBOL(fput);
+EXPORT_SYMBOL(__fput_sync);
 
 void __init files_init(void)
 {
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 81ec192ce067..85b4259f104a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1739,6 +1739,10 @@ static int writeback_single_inode(struct inode *inode,
 	 */
 	if (!(inode->i_state & I_DIRTY_ALL))
 		inode_cgwb_move_to_attached(inode, wb);
+	else if (!(inode->i_state & I_SYNC_QUEUED) &&
+		 (inode->i_state & I_DIRTY))
+		redirty_tail_locked(inode, wb);
+
 	spin_unlock(&wb->list_lock);
 	inode_sync_complete(inode);
 out:
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index fbdb7a30470a..f785af2aa23c 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1154,13 +1154,12 @@ static int gfs2_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	if (length != written && (iomap->flags & IOMAP_F_NEW)) {
 		/* Deallocate blocks that were just allocated. */
-		loff_t blockmask = i_blocksize(inode) - 1;
-		loff_t end = (pos + length) & ~blockmask;
+		loff_t hstart = round_up(pos + written, i_blocksize(inode));
+		loff_t hend = iomap->offset + iomap->length;
 
-		pos = (pos + written + blockmask) & ~blockmask;
-		if (pos < end) {
-			truncate_pagecache_range(inode, pos, end - 1);
-			punch_hole(ip, pos, end - pos);
+		if (hstart < hend) {
+			truncate_pagecache_range(inode, hstart, hend - 1);
+			punch_hole(ip, hstart, hend - hstart);
 		}
 	}
 
diff --git a/fs/nfs/fs_context.c b/fs/nfs/fs_context.c
index 0d444a90f513..fb3cad38b149 100644
--- a/fs/nfs/fs_context.c
+++ b/fs/nfs/fs_context.c
@@ -514,7 +514,7 @@ static int nfs_fs_context_parse_param(struct fs_context *fc,
 		if (result.negated)
 			ctx->flags &= ~NFS_MOUNT_SOFTREVAL;
 		else
-			ctx->flags &= NFS_MOUNT_SOFTREVAL;
+			ctx->flags |= NFS_MOUNT_SOFTREVAL;
 		break;
 	case Opt_posix:
 		if (result.negated)
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 172c86270b31..913bef0d2a36 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -72,7 +72,7 @@ static int seq_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static int seq_fdinfo_open(struct inode *inode, struct file *file)
+static int proc_fdinfo_access_allowed(struct inode *inode)
 {
 	bool allowed = false;
 	struct task_struct *task = get_proc_task(inode);
@@ -86,6 +86,16 @@ static int seq_fdinfo_open(struct inode *inode, struct file *file)
 	if (!allowed)
 		return -EACCES;
 
+	return 0;
+}
+
+static int seq_fdinfo_open(struct inode *inode, struct file *file)
+{
+	int ret = proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
 	return single_open(file, seq_show, inode);
 }
 
@@ -348,12 +358,23 @@ static int proc_readfdinfo(struct file *file, struct dir_context *ctx)
 				  proc_fdinfo_instantiate);
 }
 
+static int proc_open_fdinfo(struct inode *inode, struct file *file)
+{
+	int ret = proc_fdinfo_access_allowed(inode);
+
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 const struct inode_operations proc_fdinfo_inode_operations = {
 	.lookup		= proc_lookupfdinfo,
 	.setattr	= proc_setattr,
 };
 
 const struct file_operations proc_fdinfo_operations = {
+	.open		= proc_open_fdinfo,
 	.read		= generic_read_dir,
 	.iterate_shared	= proc_readfdinfo,
 	.llseek		= generic_file_llseek,
diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 2c6b9e416225..7c2d77d75a88 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -169,7 +169,7 @@ enum {
 #define NETIF_F_HW_HSR_FWD	__NETIF_F(HW_HSR_FWD)
 #define NETIF_F_HW_HSR_DUP	__NETIF_F(HW_HSR_DUP)
 
-/* Finds the next feature with the highest number of the range of start till 0.
+/* Finds the next feature with the highest number of the range of start-1 till 0.
  */
 static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 {
@@ -188,7 +188,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 	for ((bit) = find_next_netdev_feature((mask_addr),		\
 					      NETDEV_FEATURE_COUNT);	\
 	     (bit) >= 0;						\
-	     (bit) = find_next_netdev_feature((mask_addr), (bit) - 1))
+	     (bit) = find_next_netdev_feature((mask_addr), (bit)))
 
 /* Features valid for ethtool to change */
 /* = all defined minus driver/device-class-related */
diff --git a/include/linux/sunrpc/clnt.h b/include/linux/sunrpc/clnt.h
index a4661646adc9..9fcf5ffc4f9a 100644
--- a/include/linux/sunrpc/clnt.h
+++ b/include/linux/sunrpc/clnt.h
@@ -159,6 +159,7 @@ struct rpc_add_xprt_test {
 #define RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT	(1UL << 9)
 #define RPC_CLNT_CREATE_SOFTERR		(1UL << 10)
 #define RPC_CLNT_CREATE_REUSEPORT	(1UL << 11)
+#define RPC_CLNT_CREATE_CONNECTED	(1UL << 12)
 
 struct rpc_clnt *rpc_create(struct rpc_create_args *args);
 struct rpc_clnt	*rpc_bind_new_program(struct rpc_clnt *,
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index f72ec113ae56..98e1ec1a14f0 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -425,7 +425,7 @@ static inline void sk_rcv_saddr_set(struct sock *sk, __be32 addr)
 }
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-			struct sock *sk, u32 port_offset,
+			struct sock *sk, u64 port_offset,
 			int (*check_established)(struct inet_timewait_death_row *,
 						 struct sock *, __u16,
 						 struct inet_timewait_sock **));
diff --git a/include/net/secure_seq.h b/include/net/secure_seq.h
index d7d2495f83c2..dac91aa38c5a 100644
--- a/include/net/secure_seq.h
+++ b/include/net/secure_seq.h
@@ -4,8 +4,8 @@
 
 #include <linux/types.h>
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport);
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport);
 u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 		   __be16 sport, __be16 dport);
diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index 748cf87a4d7e..3e02709a1df6 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -14,6 +14,7 @@ struct tcf_pedit {
 	struct tc_action	common;
 	unsigned char		tcfp_nkeys;
 	unsigned char		tcfp_flags;
+	u32			tcfp_off_max_hint;
 	struct tc_pedit_key	*tcfp_keys;
 	struct tcf_pedit_key_ex	*tcfp_keys_ex;
 };
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index 6bcb8c7a3175..2a598fb45bf4 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -976,7 +976,6 @@ DEFINE_RPC_XPRT_LIFETIME_EVENT(connect);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_auto);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_done);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_force);
-DEFINE_RPC_XPRT_LIFETIME_EVENT(disconnect_cleanup);
 DEFINE_RPC_XPRT_LIFETIME_EVENT(destroy);
 
 DECLARE_EVENT_CLASS(rpc_xprt_event,
diff --git a/include/uapi/linux/virtio_ids.h b/include/uapi/linux/virtio_ids.h
index 80d76b75bccd..7aa2eb766205 100644
--- a/include/uapi/linux/virtio_ids.h
+++ b/include/uapi/linux/virtio_ids.h
@@ -73,12 +73,12 @@
  * Virtio Transitional IDs
  */
 
-#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
-#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
-#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
-#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
-#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
-#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
-#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
+#define VIRTIO_TRANS_ID_NET		0x1000 /* transitional virtio net */
+#define VIRTIO_TRANS_ID_BLOCK		0x1001 /* transitional virtio block */
+#define VIRTIO_TRANS_ID_BALLOON		0x1002 /* transitional virtio balloon */
+#define VIRTIO_TRANS_ID_CONSOLE		0x1003 /* transitional virtio console */
+#define VIRTIO_TRANS_ID_SCSI		0x1004 /* transitional virtio SCSI */
+#define VIRTIO_TRANS_ID_RNG		0x1005 /* transitional virtio rng */
+#define VIRTIO_TRANS_ID_9P		0x1009 /* transitional virtio 9p console */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f6794602ab10..31f94c6ea0a5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3347,8 +3347,11 @@ static struct notifier_block cpuset_track_online_nodes_nb = {
  */
 void __init cpuset_init_smp(void)
 {
-	cpumask_copy(top_cpuset.cpus_allowed, cpu_active_mask);
-	top_cpuset.mems_allowed = node_states[N_MEMORY];
+	/*
+	 * cpus_allowd/mems_allowed set to v2 values in the initial
+	 * cpuset_bind() call will be reset to v1 values in another
+	 * cpuset_bind() call when v1 cpuset is mounted.
+	 */
 	top_cpuset.old_mems_allowed = top_cpuset.mems_allowed;
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
diff --git a/lib/dim/net_dim.c b/lib/dim/net_dim.c
index 06811d866775..53f6b9c6e936 100644
--- a/lib/dim/net_dim.c
+++ b/lib/dim/net_dim.c
@@ -12,41 +12,41 @@
  *        Each profile size must be of NET_DIM_PARAMS_NUM_PROFILES
  */
 #define NET_DIM_PARAMS_NUM_PROFILES 5
-#define NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE 256
-#define NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE 128
+#define NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE 256
+#define NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE 128
 #define NET_DIM_DEF_PROFILE_CQE 1
 #define NET_DIM_DEF_PROFILE_EQE 1
 
 #define NET_DIM_RX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
-	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
+	{.usec = 1,   .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 8,   .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 64,  .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 128, .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}, \
+	{.usec = 256, .pkts = NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE,}  \
 }
 
 #define NET_DIM_RX_CQE_PROFILES { \
-	{2,  256},             \
-	{8,  128},             \
-	{16, 64},              \
-	{32, 64},              \
-	{64, 64}               \
+	{.usec = 2,  .pkts = 256,},             \
+	{.usec = 8,  .pkts = 128,},             \
+	{.usec = 16, .pkts = 64,},              \
+	{.usec = 32, .pkts = 64,},              \
+	{.usec = 64, .pkts = 64,}               \
 }
 
 #define NET_DIM_TX_EQE_PROFILES { \
-	{1,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{8,   NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{32,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{64,  NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE},  \
-	{128, NET_DIM_DEFAULT_TX_CQ_MODERATION_PKTS_FROM_EQE}   \
+	{.usec = 1,   .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 8,   .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 32,  .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 64,  .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,},  \
+	{.usec = 128, .pkts = NET_DIM_DEFAULT_TX_CQ_PKTS_FROM_EQE,}   \
 }
 
 #define NET_DIM_TX_CQE_PROFILES { \
-	{5,  128},  \
-	{8,  64},  \
-	{16, 32},  \
-	{32, 32},  \
-	{64, 32}   \
+	{.usec = 5,  .pkts = 128,},  \
+	{.usec = 8,  .pkts = 64,},  \
+	{.usec = 16, .pkts = 32,},  \
+	{.usec = 32, .pkts = 32,},  \
+	{.usec = 64, .pkts = 32,}   \
 }
 
 static const struct dim_cq_moder
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c5142d237e48..8cc150a88361 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2617,11 +2617,16 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	struct address_space *mapping = NULL;
 	int extra_pins, ret;
 	pgoff_t end;
+	bool is_hzp;
 
-	VM_BUG_ON_PAGE(is_huge_zero_page(head), head);
 	VM_BUG_ON_PAGE(!PageLocked(head), head);
 	VM_BUG_ON_PAGE(!PageCompound(head), head);
 
+	is_hzp = is_huge_zero_page(head);
+	VM_WARN_ON_ONCE_PAGE(is_hzp, head);
+	if (is_hzp)
+		return -EBUSY;
+
 	if (PageWriteback(head))
 		return -EBUSY;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 6b1556b4972e..c3ceb7436933 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1217,7 +1217,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 	}
 out:
 	if (ret == -EIO)
-		dump_page(p, "hwpoison: unhandlable page");
+		pr_err("Memory failure: %#lx: unhandlable page.\n", page_to_pfn(p));
 
 	return ret;
 }
@@ -1691,19 +1691,6 @@ int memory_failure(unsigned long pfn, int flags)
 	}
 
 	if (PageTransHuge(hpage)) {
-		/*
-		 * Bail out before SetPageHasHWPoisoned() if hpage is
-		 * huge_zero_page, although PG_has_hwpoisoned is not
-		 * checked in set_huge_zero_page().
-		 *
-		 * TODO: Handle memory failure of huge_zero_page thoroughly.
-		 */
-		if (is_huge_zero_page(hpage)) {
-			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_IGNORED);
-			res = -EBUSY;
-			goto unlock_mutex;
-		}
-
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index 0899a729a23f..c120c7c6d25f 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -475,6 +475,17 @@ int batadv_frag_send_packet(struct sk_buff *skb,
 		goto free_skb;
 	}
 
+	/* GRO might have added fragments to the fragment list instead of
+	 * frags[]. But this is not handled by skb_split and must be
+	 * linearized to avoid incorrect length information after all
+	 * batman-adv fragments were created and submitted to the
+	 * hard-interface
+	 */
+	if (skb_has_frag_list(skb) && __skb_linearize(skb)) {
+		ret = -ENOMEM;
+		goto free_skb;
+	}
+
 	/* Create one header to be copied to all fragments */
 	frag_header.packet_type = BATADV_UNICAST_FRAG;
 	frag_header.version = BATADV_COMPAT_VERSION;
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index b5bc680d4755..7131cd1fb2ad 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -22,6 +22,8 @@
 static siphash_key_t net_secret __read_mostly;
 static siphash_key_t ts_secret __read_mostly;
 
+#define EPHEMERAL_PORT_SHUFFLE_PERIOD (10 * HZ)
+
 static __always_inline void net_secret_init(void)
 {
 	net_get_random_once(&net_secret, sizeof(net_secret));
@@ -94,17 +96,19 @@ u32 secure_tcpv6_seq(const __be32 *saddr, const __be32 *daddr,
 }
 EXPORT_SYMBOL(secure_tcpv6_seq);
 
-u32 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
+u64 secure_ipv6_port_ephemeral(const __be32 *saddr, const __be32 *daddr,
 			       __be16 dport)
 {
 	const struct {
 		struct in6_addr saddr;
 		struct in6_addr daddr;
+		unsigned int timeseed;
 		__be16 dport;
 	} __aligned(SIPHASH_ALIGNMENT) combined = {
 		.saddr = *(struct in6_addr *)saddr,
 		.daddr = *(struct in6_addr *)daddr,
-		.dport = dport
+		.timeseed = jiffies / EPHEMERAL_PORT_SHUFFLE_PERIOD,
+		.dport = dport,
 	};
 	net_secret_init();
 	return siphash(&combined, offsetofend(typeof(combined), dport),
@@ -142,11 +146,13 @@ u32 secure_tcp_seq(__be32 saddr, __be32 daddr,
 }
 EXPORT_SYMBOL_GPL(secure_tcp_seq);
 
-u32 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
+u64 secure_ipv4_port_ephemeral(__be32 saddr, __be32 daddr, __be16 dport)
 {
 	net_secret_init();
-	return siphash_3u32((__force u32)saddr, (__force u32)daddr,
-			    (__force u16)dport, &net_secret);
+	return siphash_4u32((__force u32)saddr, (__force u32)daddr,
+			    (__force u16)dport,
+			    jiffies / EPHEMERAL_PORT_SHUFFLE_PERIOD,
+			    &net_secret);
 }
 EXPORT_SYMBOL_GPL(secure_ipv4_port_ephemeral);
 #endif
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7bd1e10086f0..ee9c587031b4 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -504,7 +504,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet_sk_port_offset(const struct sock *sk)
+static u64 inet_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -726,15 +726,17 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
- * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
- * we use 256 instead to really give more isolation and
- * privacy, this only consumes 1 KB of kernel memory.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
+ * attacks were since demonstrated, thus we use 65536 instead to really
+ * give more isolation and privacy, at the expense of 256kB of kernel
+ * memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 8
-static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+#define INET_TABLE_PERTURB_SHIFT 16
+#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
-		struct sock *sk, u32 port_offset,
+		struct sock *sk, u64 port_offset,
 		int (*check_established)(struct inet_timewait_death_row *,
 			struct sock *, __u16, struct inet_timewait_sock **))
 {
@@ -774,10 +776,13 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	net_get_random_once(table_perturb, sizeof(table_perturb));
-	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
+	net_get_random_once(table_perturb,
+			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
+	index = port_offset & (INET_TABLE_PERTURB_SIZE - 1);
+
+	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
+	offset %= remaining;
 
-	offset = (READ_ONCE(table_perturb[index]) + port_offset) % remaining;
 	/* In first pass we try ports of @low parity.
 	 * inet_csk_get_port() does the opposite choice.
 	 */
@@ -831,11 +836,12 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 
 ok:
-	/* If our first attempt found a candidate, skip next candidate
-	 * in 1/16 of cases to add some noise.
+	/* Here we want to add a little bit of randomness to the next source
+	 * port that will be chosen. We use a max() with a random here so that
+	 * on low contention the randomness is maximal and on high contention
+	 * it may be inexistent.
 	 */
-	if (!i && !(prandom_u32() % 16))
-		i = 2;
+	i = max_t(int, i, (prandom_u32() & 7) * 2);
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */
@@ -859,7 +865,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet_sk_port_offset(sk);
@@ -909,6 +915,12 @@ void __init inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 					    low_limit,
 					    high_limit);
 	init_hashinfo_lhash2(h);
+
+	/* this one is used for source ports of outgoing connections */
+	table_perturb = kmalloc_array(INET_TABLE_PERTURB_SIZE,
+				      sizeof(*table_perturb), GFP_KERNEL);
+	if (!table_perturb)
+		panic("TCP: failed to alloc table_perturb");
 }
 
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h)
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 36e89b687387..c4a2565da280 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -305,6 +305,7 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 	struct net *net = sock_net(sk);
 	if (sk->sk_family == AF_INET) {
 		struct sockaddr_in *addr = (struct sockaddr_in *) uaddr;
+		u32 tb_id = RT_TABLE_LOCAL;
 		int chk_addr_ret;
 
 		if (addr_len < sizeof(*addr))
@@ -320,8 +321,10 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 
 		if (addr->sin_addr.s_addr == htonl(INADDR_ANY))
 			chk_addr_ret = RTN_LOCAL;
-		else
-			chk_addr_ret = inet_addr_type(net, addr->sin_addr.s_addr);
+		else {
+			tb_id = l3mdev_fib_table_by_index(net, sk->sk_bound_dev_if) ? : tb_id;
+			chk_addr_ret = inet_addr_type_table(net, addr->sin_addr.s_addr, tb_id);
+		}
 
 		if ((!inet_can_nonlocal_bind(net, isk) &&
 		     chk_addr_ret != RTN_LOCAL) ||
@@ -359,6 +362,14 @@ static int ping_check_bind_addr(struct sock *sk, struct inet_sock *isk,
 				return -ENODEV;
 			}
 		}
+
+		if (!dev && sk->sk_bound_dev_if) {
+			dev = dev_get_by_index_rcu(net, sk->sk_bound_dev_if);
+			if (!dev) {
+				rcu_read_unlock();
+				return -ENODEV;
+			}
+		}
 		has_addr = pingv6_ops.ipv6_chk_addr(net, &addr->sin6_addr, dev,
 						    scoped);
 		rcu_read_unlock();
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index ed9b6842a9a0..6e8020a3bd67 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1754,6 +1754,7 @@ static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 #endif
 	RT_CACHE_STAT_INC(in_slow_mc);
 
+	skb_dst_drop(skb);
 	skb_dst_set(skb, &rth->dst);
 	return 0;
 }
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 0a2e7f228391..40203255ed88 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -308,7 +308,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 	return -EADDRNOTAVAIL;
 }
 
-static u32 inet6_sk_port_offset(const struct sock *sk)
+static u64 inet6_sk_port_offset(const struct sock *sk)
 {
 	const struct inet_sock *inet = inet_sk(sk);
 
@@ -320,7 +320,7 @@ static u32 inet6_sk_port_offset(const struct sock *sk)
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 		       struct sock *sk)
 {
-	u32 port_offset = 0;
+	u64 port_offset = 0;
 
 	if (!inet_sk(sk)->inet_num)
 		port_offset = inet6_sk_port_offset(sk);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8332452c118..1548f532dc1a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3541,6 +3541,12 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 				cbss->transmitted_bss->bssid);
 		bss_conf->bssid_indicator = cbss->max_bssid_indicator;
 		bss_conf->bssid_index = cbss->bssid_index;
+	} else {
+		bss_conf->nontransmitted = false;
+		memset(bss_conf->transmitter_bssid, 0,
+		       sizeof(bss_conf->transmitter_bssid));
+		bss_conf->bssid_indicator = 0;
+		bss_conf->bssid_index = 0;
 	}
 
 	/*
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index fb7f7b17c78c..974d32632ef4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1996,7 +1996,6 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		copied = len;
 	}
 
-	skb_reset_transport_header(data_skb);
 	err = skb_copy_datagram_msg(data_skb, 0, msg, copied);
 
 	if (msg->msg_name) {
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c6c862c459cc..cfadd613644a 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -149,7 +149,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	struct nlattr *pattr;
 	struct tcf_pedit *p;
 	int ret = 0, err;
-	int ksize;
+	int i, ksize;
 	u32 index;
 
 	if (!nla) {
@@ -228,6 +228,18 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 		p->tcfp_nkeys = parm->nkeys;
 	}
 	memcpy(p->tcfp_keys, parm->keys, ksize);
+	p->tcfp_off_max_hint = 0;
+	for (i = 0; i < p->tcfp_nkeys; ++i) {
+		u32 cur = p->tcfp_keys[i].off;
+
+		/* The AT option can read a single byte, we can bound the actual
+		 * value with uchar max.
+		 */
+		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
+
+		/* Each key touches 4 bytes starting from the computed offset */
+		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
+	}
 
 	p->tcfp_flags = parm->flags;
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
@@ -308,13 +320,18 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			 struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	u32 max_offset;
 	int i;
 
-	if (skb_unclone(skb, GFP_ATOMIC))
-		return p->tcf_action;
-
 	spin_lock(&p->tcf_lock);
 
+	max_offset = (skb_transport_header_was_set(skb) ?
+		      skb_transport_offset(skb) :
+		      skb_network_offset(skb)) +
+		     p->tcfp_off_max_hint;
+	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
+		goto unlock;
+
 	tcf_lastuse_update(&p->tcf_tm);
 
 	if (p->tcfp_nkeys > 0) {
@@ -403,6 +420,7 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 	p->tcf_qstats.overlimits++;
 done:
 	bstats_update(&p->tcf_bstats, skb);
+unlock:
 	spin_unlock(&p->tcf_lock);
 	return p->tcf_action;
 }
diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
index 170b733bc736..45b0575520da 100644
--- a/net/smc/smc_rx.c
+++ b/net/smc/smc_rx.c
@@ -354,12 +354,12 @@ int smc_rx_recvmsg(struct smc_sock *smc, struct msghdr *msg,
 				}
 				break;
 			}
+			if (!timeo)
+				return -EAGAIN;
 			if (signal_pending(current)) {
 				read_done = sock_intr_errno(timeo);
 				break;
 			}
-			if (!timeo)
-				return -EAGAIN;
 		}
 
 		if (!smc_rx_data_available(conn)) {
diff --git a/net/sunrpc/auth_gss/gss_rpc_upcall.c b/net/sunrpc/auth_gss/gss_rpc_upcall.c
index 61c276bddaf2..f549e4c05def 100644
--- a/net/sunrpc/auth_gss/gss_rpc_upcall.c
+++ b/net/sunrpc/auth_gss/gss_rpc_upcall.c
@@ -98,6 +98,7 @@ static int gssp_rpc_create(struct net *net, struct rpc_clnt **_clnt)
 		 * done without the correct namespace:
 		 */
 		.flags		= RPC_CLNT_CREATE_NOPING |
+				  RPC_CLNT_CREATE_CONNECTED |
 				  RPC_CLNT_CREATE_NO_IDLE_TIMEOUT
 	};
 	struct rpc_clnt *clnt;
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index e4b9a38f12e0..0a0818e55879 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -76,6 +76,7 @@ static int	rpc_encode_header(struct rpc_task *task,
 static int	rpc_decode_header(struct rpc_task *task,
 				  struct xdr_stream *xdr);
 static int	rpc_ping(struct rpc_clnt *clnt);
+static int	rpc_ping_noreply(struct rpc_clnt *clnt);
 static void	rpc_check_timeout(struct rpc_task *task);
 
 static void rpc_register_client(struct rpc_clnt *clnt)
@@ -483,6 +484,12 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
 			rpc_shutdown_client(clnt);
 			return ERR_PTR(err);
 		}
+	} else if (args->flags & RPC_CLNT_CREATE_CONNECTED) {
+		int err = rpc_ping_noreply(clnt);
+		if (err != 0) {
+			rpc_shutdown_client(clnt);
+			return ERR_PTR(err);
+		}
 	}
 
 	clnt->cl_softrtry = 1;
@@ -2704,6 +2711,10 @@ static const struct rpc_procinfo rpcproc_null = {
 	.p_decode = rpcproc_decode_null,
 };
 
+static const struct rpc_procinfo rpcproc_null_noreply = {
+	.p_encode = rpcproc_encode_null,
+};
+
 static void
 rpc_null_call_prepare(struct rpc_task *task, void *data)
 {
@@ -2757,6 +2768,28 @@ static int rpc_ping(struct rpc_clnt *clnt)
 	return status;
 }
 
+static int rpc_ping_noreply(struct rpc_clnt *clnt)
+{
+	struct rpc_message msg = {
+		.rpc_proc = &rpcproc_null_noreply,
+	};
+	struct rpc_task_setup task_setup_data = {
+		.rpc_client = clnt,
+		.rpc_message = &msg,
+		.callback_ops = &rpc_null_ops,
+		.flags = RPC_TASK_SOFT | RPC_TASK_SOFTCONN | RPC_TASK_NULLCREDS,
+	};
+	struct rpc_task	*task;
+	int status;
+
+	task = rpc_run_task(&task_setup_data);
+	if (IS_ERR(task))
+		return PTR_ERR(task);
+	status = task->tk_status;
+	rpc_put_task(task);
+	return status;
+}
+
 struct rpc_cb_add_xprt_calldata {
 	struct rpc_xprt_switch *xps;
 	struct rpc_xprt *xprt;
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index e4adb780b69e..2db834318d14 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -929,12 +929,7 @@ void xprt_connect(struct rpc_task *task)
 	if (!xprt_lock_write(xprt, task))
 		return;
 
-	if (test_and_clear_bit(XPRT_CLOSE_WAIT, &xprt->state)) {
-		trace_xprt_disconnect_cleanup(xprt);
-		xprt->ops->close(xprt);
-	}
-
-	if (!xprt_connected(xprt)) {
+	if (!xprt_connected(xprt) && !test_bit(XPRT_CLOSE_WAIT, &xprt->state)) {
 		task->tk_rqstp->rq_connect_cookie = xprt->connect_cookie;
 		rpc_sleep_on_timeout(&xprt->pending, task, NULL,
 				xprt_request_timeout(task->tk_rqstp));
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 95a86f3fb5c6..897dfce7dd27 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -880,7 +880,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 
 	/* Close the stream if the previous transmission was incomplete */
 	if (xs_send_request_was_aborted(transport, req)) {
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		return -ENOTCONN;
 	}
 
@@ -918,7 +918,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 			-status);
 		fallthrough;
 	case -EPIPE:
-		xs_close(xprt);
+		xprt_force_disconnect(xprt);
 		status = -ENOTCONN;
 	}
 
@@ -1205,6 +1205,16 @@ static void xs_reset_transport(struct sock_xprt *transport)
 
 	if (sk == NULL)
 		return;
+	/*
+	 * Make sure we're calling this in a context from which it is safe
+	 * to call __fput_sync(). In practice that means rpciod and the
+	 * system workqueue.
+	 */
+	if (!(current->flags & PF_WQ_WORKER)) {
+		WARN_ON_ONCE(1);
+		set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+		return;
+	}
 
 	if (atomic_read(&transport->xprt.swapper))
 		sk_clear_memalloc(sk);
@@ -1228,7 +1238,7 @@ static void xs_reset_transport(struct sock_xprt *transport)
 	mutex_unlock(&transport->recv_mutex);
 
 	trace_rpc_socket_close(xprt, sock);
-	fput(filp);
+	__fput_sync(filp);
 
 	xprt_disconnect_done(xprt);
 }
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a40553e83f8b..f3e3d009cf1c 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1347,7 +1347,10 @@ static int tls_device_down(struct net_device *netdev)
 
 		/* Device contexts for RX and TX will be freed in on sk_destruct
 		 * by tls_device_free_ctx. rx_conf and tx_conf stay in TLS_HW.
+		 * Now release the ref taken above.
 		 */
+		if (refcount_dec_and_test(&ctx->refcount))
+			tls_device_free_ctx(ctx);
 	}
 
 	up_write(&device_offload_lock);
diff --git a/sound/soc/codecs/max98090.c b/sound/soc/codecs/max98090.c
index b45ec35cd63c..62b41ca050a2 100644
--- a/sound/soc/codecs/max98090.c
+++ b/sound/soc/codecs/max98090.c
@@ -413,6 +413,9 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 
 	val = (val >> mc->shift) & mask;
 
+	if (sel < 0 || sel > mc->max)
+		return -EINVAL;
+
 	*select = sel;
 
 	/* Setting a volume is only valid if it is already On */
@@ -427,7 +430,7 @@ static int max98090_put_enab_tlv(struct snd_kcontrol *kcontrol,
 		mask << mc->shift,
 		sel << mc->shift);
 
-	return 0;
+	return *select != val;
 }
 
 static const char *max98090_perf_pwr_text[] =
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 63ee35ebeaab..f32ba64c5dda 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -519,7 +519,15 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	unsigned int mask = (1 << fls(max)) - 1;
 	unsigned int invert = mc->invert;
 	unsigned int val, val_mask;
-	int err, ret;
+	int err, ret, tmp;
+
+	tmp = ucontrol->value.integer.value[0];
+	if (tmp < 0)
+		return -EINVAL;
+	if (mc->platform_max && tmp > mc->platform_max)
+		return -EINVAL;
+	if (tmp > mc->max - mc->min + 1)
+		return -EINVAL;
 
 	if (invert)
 		val = (max - ucontrol->value.integer.value[0]) & mask;
@@ -534,6 +542,14 @@ int snd_soc_put_volsw_range(struct snd_kcontrol *kcontrol,
 	ret = err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
+		tmp = ucontrol->value.integer.value[1];
+		if (tmp < 0)
+			return -EINVAL;
+		if (mc->platform_max && tmp > mc->platform_max)
+			return -EINVAL;
+		if (tmp > mc->max - mc->min + 1)
+			return -EINVAL;
+
 		if (invert)
 			val = (max - ucontrol->value.integer.value[1]) & mask;
 		else
diff --git a/sound/soc/sof/sof-pci-dev.c b/sound/soc/sof/sof-pci-dev.c
index bc9e70765678..b773289c928d 100644
--- a/sound/soc/sof/sof-pci-dev.c
+++ b/sound/soc/sof/sof-pci-dev.c
@@ -129,6 +129,11 @@ int sof_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 
 	dev_dbg(&pci->dev, "PCI DSP detected");
 
+	if (!desc) {
+		dev_err(dev, "error: no matching PCI descriptor\n");
+		return -ENODEV;
+	}
+
 	if (!desc->ops) {
 		dev_err(dev, "error: no matching PCI descriptor ops\n");
 		return -ENODEV;
diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
index a7fde142e814..d8ae7cc01274 100644
--- a/tools/testing/selftests/vm/Makefile
+++ b/tools/testing/selftests/vm/Makefile
@@ -54,9 +54,9 @@ CAN_BUILD_I386 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_32bit_prog
 CAN_BUILD_X86_64 := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_64bit_program.c)
 CAN_BUILD_WITH_NOPIE := $(shell ./../x86/check_cc.sh "$(CC)" ../x86/trivial_program.c -no-pie)
 
-TARGETS := protection_keys
-BINARIES_32 := $(TARGETS:%=%_32)
-BINARIES_64 := $(TARGETS:%=%_64)
+VMTARGETS := protection_keys
+BINARIES_32 := $(VMTARGETS:%=%_32)
+BINARIES_64 := $(VMTARGETS:%=%_64)
 
 ifeq ($(CAN_BUILD_WITH_NOPIE),1)
 CFLAGS += -no-pie
@@ -109,7 +109,7 @@ $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
-$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-32,$(t))))
+$(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif
 
 ifeq ($(CAN_BUILD_X86_64),1)
@@ -117,7 +117,7 @@ $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
-$(foreach t,$(TARGETS),$(eval $(call gen-target-rule-64,$(t))))
+$(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif
 
 # x86_64 users should be encouraged to install 32-bit libraries
