Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177FC4188C4
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 14:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhIZMvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 08:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231534AbhIZMvb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 08:51:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1999D60F93;
        Sun, 26 Sep 2021 12:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632660595;
        bh=yl6pXq8k140Toj8GBeJgznltpKx0+4TuPmRJpG/VCik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCDJA/Ia7X32oINgnxw49eg1l+gQNxm/0ib4/FaTMwQnuwWqdeTaclUZsqDih8ZWt
         sLHFgS0ruYmOrMG2zck9+8sV4+HPWZ+GniipQJeOdUmJRSbLtgW3ZkkHLabX0lzRei
         v+aT+nh/w+fVc4kZpXzd34g5Rl0o9l5vXL+AXjlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.248
Date:   Sun, 26 Sep 2021 14:49:43 +0200
Message-Id: <163266058386242@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <16326605830170@kroah.com>
References: <16326605830170@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index b05401adeaf5..7999f2fbd0f8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 247
+SUBLEVEL = 248
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 1241e365af5d..60029baaa72a 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -592,10 +592,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		EMIT4(0xb9080000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_ADD | BPF_K: /* dst = (u32) dst + (u32) imm */
-		if (!imm)
-			break;
-		/* alfi %dst,imm */
-		EMIT6_IMM(0xc20b0000, dst_reg, imm);
+		if (imm != 0) {
+			/* alfi %dst,imm */
+			EMIT6_IMM(0xc20b0000, dst_reg, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_ADD | BPF_K: /* dst = dst + imm */
@@ -617,10 +617,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		EMIT4(0xb9090000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_SUB | BPF_K: /* dst = (u32) dst - (u32) imm */
-		if (!imm)
-			break;
-		/* alfi %dst,-imm */
-		EMIT6_IMM(0xc20b0000, dst_reg, -imm);
+		if (imm != 0) {
+			/* alfi %dst,-imm */
+			EMIT6_IMM(0xc20b0000, dst_reg, -imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_SUB | BPF_K: /* dst = dst - imm */
@@ -647,10 +647,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		EMIT4(0xb90c0000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_MUL | BPF_K: /* dst = (u32) dst * (u32) imm */
-		if (imm == 1)
-			break;
-		/* msfi %r5,imm */
-		EMIT6_IMM(0xc2010000, dst_reg, imm);
+		if (imm != 1) {
+			/* msfi %r5,imm */
+			EMIT6_IMM(0xc2010000, dst_reg, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_MUL | BPF_K: /* dst = dst * imm */
@@ -711,6 +711,8 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 			if (BPF_OP(insn->code) == BPF_MOD)
 				/* lhgi %dst,0 */
 				EMIT4_IMM(0xa7090000, dst_reg, 0);
+			else
+				EMIT_ZERO(dst_reg);
 			break;
 		}
 		/* lhi %w0,0 */
@@ -803,10 +805,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		EMIT4(0xb9820000, dst_reg, src_reg);
 		break;
 	case BPF_ALU | BPF_XOR | BPF_K: /* dst = (u32) dst ^ (u32) imm */
-		if (!imm)
-			break;
-		/* xilf %dst,imm */
-		EMIT6_IMM(0xc0070000, dst_reg, imm);
+		if (imm != 0) {
+			/* xilf %dst,imm */
+			EMIT6_IMM(0xc0070000, dst_reg, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_XOR | BPF_K: /* dst = dst ^ imm */
@@ -827,10 +829,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		EMIT6_DISP_LH(0xeb000000, 0x000d, dst_reg, dst_reg, src_reg, 0);
 		break;
 	case BPF_ALU | BPF_LSH | BPF_K: /* dst = (u32) dst << (u32) imm */
-		if (imm == 0)
-			break;
-		/* sll %dst,imm(%r0) */
-		EMIT4_DISP(0x89000000, dst_reg, REG_0, imm);
+		if (imm != 0) {
+			/* sll %dst,imm(%r0) */
+			EMIT4_DISP(0x89000000, dst_reg, REG_0, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_LSH | BPF_K: /* dst = dst << imm */
@@ -852,10 +854,10 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i
 		EMIT6_DISP_LH(0xeb000000, 0x000c, dst_reg, dst_reg, src_reg, 0);
 		break;
 	case BPF_ALU | BPF_RSH | BPF_K: /* dst = (u32) dst >> (u32) imm */
-		if (imm == 0)
-			break;
-		/* srl %dst,imm(%r0) */
-		EMIT4_DISP(0x88000000, dst_reg, REG_0, imm);
+		if (imm != 0) {
+			/* srl %dst,imm(%r0) */
+			EMIT4_DISP(0x88000000, dst_reg, REG_0, imm);
+		}
 		EMIT_ZERO(dst_reg);
 		break;
 	case BPF_ALU64 | BPF_RSH | BPF_K: /* dst = dst >> imm */
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index a8cd7b3d9647..fcbbe2e45a2b 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2414,6 +2414,7 @@ int blk_throtl_init(struct request_queue *q)
 void blk_throtl_exit(struct request_queue *q)
 {
 	BUG_ON(!q->td);
+	del_timer_sync(&q->td->service_queue.pending_timer);
 	throtl_shutdown_wq(q);
 	blkcg_deactivate_policy(q, &blkcg_policy_throtl);
 	free_percpu(q->td->latency_buckets);
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 830d03115efb..5d39da4d2e02 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -816,7 +816,7 @@ static void talitos_unregister_rng(struct device *dev)
  * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
  */
 #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-#ifdef CONFIG_CRYPTO_DEV_TALITOS_SEC2
+#ifdef CONFIG_CRYPTO_DEV_TALITOS2
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA512_BLOCK_SIZE)
 #else
 #define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + SHA256_BLOCK_SIZE)
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index ff69feefc1c6..5ea37d133f24 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -262,7 +262,7 @@ config INTEL_IDMA64
 
 config INTEL_IOATDMA
 	tristate "Intel I/OAT DMA support"
-	depends on PCI && X86_64
+	depends on PCI && X86_64 && !UML
 	select DMA_ENGINE
 	select DMA_ENGINE_RAID
 	select DCA
diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
index 8d99c84361cb..22ec10c71d81 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -72,10 +72,14 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
 
 	si = (const struct acpi_csrt_shared_info *)&grp[1];
 
-	/* Match device by MMIO and IRQ */
+	/* Match device by MMIO */
 	if (si->mmio_base_low != lower_32_bits(mem) ||
-	    si->mmio_base_high != upper_32_bits(mem) ||
-	    si->gsi_interrupt != irq)
+	    si->mmio_base_high != upper_32_bits(mem))
+		return 0;
+
+	/* Match device by Linux vIRQ */
+	ret = acpi_register_gsi(NULL, si->gsi_interrupt, si->interrupt_mode, si->interrupt_polarity);
+	if (ret != irq)
 		return 0;
 
 	dev_dbg(&adev->dev, "matches with %.4s%04X (rev %u)\n",
diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 21203e3a54fd..3c2084766a31 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2585,7 +2585,7 @@ static int xilinx_dma_probe(struct platform_device *pdev)
 		xdev->ext_addr = false;
 
 	/* Set the dma mask bits */
-	dma_set_mask(xdev->dev, DMA_BIT_MASK(addr_width));
+	dma_set_mask_and_coherent(xdev->dev, DMA_BIT_MASK(addr_width));
 
 	/* Initialize the DMA engine */
 	xdev->common.dev = &pdev->dev;
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
index b0ece71aefde..ce774579c89d 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/ctrl.c
@@ -57,7 +57,7 @@ nvkm_control_mthd_pstate_info(struct nvkm_control *ctrl, void *data, u32 size)
 		args->v0.count = 0;
 		args->v0.ustate_ac = NVIF_CONTROL_PSTATE_INFO_V0_USTATE_DISABLE;
 		args->v0.ustate_dc = NVIF_CONTROL_PSTATE_INFO_V0_USTATE_DISABLE;
-		args->v0.pwrsrc = -ENOSYS;
+		args->v0.pwrsrc = -ENODEV;
 		args->v0.pstate = NVIF_CONTROL_PSTATE_INFO_V0_PSTATE_UNKNOWN;
 	}
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 8bed46630857..c11515bdac83 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -160,15 +160,6 @@ struct dino_device
 	(struct dino_device *)__pdata; })
 
 
-/* Check if PCI device is behind a Card-mode Dino. */
-static int pci_dev_is_behind_card_dino(struct pci_dev *dev)
-{
-	struct dino_device *dino_dev;
-
-	dino_dev = DINO_DEV(parisc_walk_tree(dev->bus->bridge));
-	return is_card_dino(&dino_dev->hba.dev->id);
-}
-
 /*
  * Dino Configuration Space Accessor Functions
  */
@@ -452,6 +443,15 @@ static void quirk_cirrus_cardbus(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_6832, quirk_cirrus_cardbus );
 
 #ifdef CONFIG_TULIP
+/* Check if PCI device is behind a Card-mode Dino. */
+static int pci_dev_is_behind_card_dino(struct pci_dev *dev)
+{
+	struct dino_device *dino_dev;
+
+	dino_dev = DINO_DEV(parisc_walk_tree(dev->bus->bridge));
+	return is_card_dino(&dino_dev->hba.dev->id);
+}
+
 static void pci_fixup_tulip(struct pci_dev *dev)
 {
 	if (!pci_dev_is_behind_card_dino(dev))
diff --git a/drivers/pwm/pwm-lpc32xx.c b/drivers/pwm/pwm-lpc32xx.c
index a9b3cff96aac..ed8e9406b4af 100644
--- a/drivers/pwm/pwm-lpc32xx.c
+++ b/drivers/pwm/pwm-lpc32xx.c
@@ -124,17 +124,17 @@ static int lpc32xx_pwm_probe(struct platform_device *pdev)
 	lpc32xx->chip.npwm = 1;
 	lpc32xx->chip.base = -1;
 
+	/* If PWM is disabled, configure the output to the default value */
+	val = readl(lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+	val &= ~PWM_PIN_LEVEL;
+	writel(val, lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
+
 	ret = pwmchip_add(&lpc32xx->chip);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to add PWM chip, error %d\n", ret);
 		return ret;
 	}
 
-	/* When PWM is disable, configure the output to the default value */
-	val = readl(lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
-	val &= ~PWM_PIN_LEVEL;
-	writel(val, lpc32xx->base + (lpc32xx->chip.pwms[0].hwpwm << 2));
-
 	platform_set_drvdata(pdev, lpc32xx);
 
 	return 0;
diff --git a/drivers/pwm/pwm-rockchip.c b/drivers/pwm/pwm-rockchip.c
index 48bcc853d57a..cf34fb00c054 100644
--- a/drivers/pwm/pwm-rockchip.c
+++ b/drivers/pwm/pwm-rockchip.c
@@ -392,20 +392,6 @@ static int rockchip_pwm_remove(struct platform_device *pdev)
 {
 	struct rockchip_pwm_chip *pc = platform_get_drvdata(pdev);
 
-	/*
-	 * Disable the PWM clk before unpreparing it if the PWM device is still
-	 * running. This should only happen when the last PWM user left it
-	 * enabled, or when nobody requested a PWM that was previously enabled
-	 * by the bootloader.
-	 *
-	 * FIXME: Maybe the core should disable all PWM devices in
-	 * pwmchip_remove(). In this case we'd only have to call
-	 * clk_unprepare() after pwmchip_remove().
-	 *
-	 */
-	if (pwm_is_enabled(pc->chip.pwms))
-		clk_disable(pc->clk);
-
 	clk_unprepare(pc->pclk);
 	clk_unprepare(pc->clk);
 
diff --git a/drivers/thermal/samsung/exynos_tmu.c b/drivers/thermal/samsung/exynos_tmu.c
index d60069b5dc98..b147f5f3dba2 100644
--- a/drivers/thermal/samsung/exynos_tmu.c
+++ b/drivers/thermal/samsung/exynos_tmu.c
@@ -1371,6 +1371,7 @@ static int exynos_tmu_probe(struct platform_device *pdev)
 		data->sclk = devm_clk_get(&pdev->dev, "tmu_sclk");
 		if (IS_ERR(data->sclk)) {
 			dev_err(&pdev->dev, "Failed to get sclk\n");
+			ret = PTR_ERR(data->sclk);
 			goto err_clk;
 		} else {
 			ret = clk_prepare_enable(data->sclk);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index b077b9a6bf95..a0168d9bb85d 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1657,6 +1657,8 @@ static int __mark_caps_flushing(struct inode *inode,
  * try to invalidate mapping pages without blocking.
  */
 static int try_nonblocking_invalidate(struct inode *inode)
+	__releases(ci->i_ceph_lock)
+	__acquires(ci->i_ceph_lock)
 {
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u32 invalidating_gen = ci->i_rdcache_gen;
diff --git a/fs/nilfs2/sysfs.c b/fs/nilfs2/sysfs.c
index e9903bceb2bf..33fba75aa9f3 100644
--- a/fs/nilfs2/sysfs.c
+++ b/fs/nilfs2/sysfs.c
@@ -73,11 +73,9 @@ static const struct sysfs_ops nilfs_##name##_attr_ops = { \
 #define NILFS_DEV_INT_GROUP_TYPE(name, parent_name) \
 static void nilfs_##name##_attr_release(struct kobject *kobj) \
 { \
-	struct nilfs_sysfs_##parent_name##_subgroups *subgroups; \
-	struct the_nilfs *nilfs = container_of(kobj->parent, \
-						struct the_nilfs, \
-						ns_##parent_name##_kobj); \
-	subgroups = nilfs->ns_##parent_name##_subgroups; \
+	struct nilfs_sysfs_##parent_name##_subgroups *subgroups = container_of(kobj, \
+						struct nilfs_sysfs_##parent_name##_subgroups, \
+						sg_##name##_kobj); \
 	complete(&subgroups->sg_##name##_kobj_unregister); \
 } \
 static struct kobj_type nilfs_##name##_ktype = { \
@@ -103,12 +101,12 @@ static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 	err = kobject_init_and_add(kobj, &nilfs_##name##_ktype, parent, \
 				    #name); \
 	if (err) \
-		return err; \
-	return 0; \
+		kobject_put(kobj); \
+	return err; \
 } \
 static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
-	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
+	kobject_put(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
 
 /************************************************************************
@@ -219,14 +217,14 @@ int nilfs_sysfs_create_snapshot_group(struct nilfs_root *root)
 	}
 
 	if (err)
-		return err;
+		kobject_put(&root->snapshot_kobj);
 
-	return 0;
+	return err;
 }
 
 void nilfs_sysfs_delete_snapshot_group(struct nilfs_root *root)
 {
-	kobject_del(&root->snapshot_kobj);
+	kobject_put(&root->snapshot_kobj);
 }
 
 /************************************************************************
@@ -1010,7 +1008,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	err = kobject_init_and_add(&nilfs->ns_dev_kobj, &nilfs_dev_ktype, NULL,
 				    "%s", sb->s_id);
 	if (err)
-		goto free_dev_subgroups;
+		goto cleanup_dev_kobject;
 
 	err = nilfs_sysfs_create_mounted_snapshots_group(nilfs);
 	if (err)
@@ -1047,9 +1045,7 @@ int nilfs_sysfs_create_device_group(struct super_block *sb)
 	nilfs_sysfs_delete_mounted_snapshots_group(nilfs);
 
 cleanup_dev_kobject:
-	kobject_del(&nilfs->ns_dev_kobj);
-
-free_dev_subgroups:
+	kobject_put(&nilfs->ns_dev_kobj);
 	kfree(nilfs->ns_dev_subgroups);
 
 failed_create_device_group:
diff --git a/kernel/profile.c b/kernel/profile.c
index 9aa2a4445b0d..efa58f63dc1b 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -40,7 +40,8 @@ struct profile_hit {
 #define NR_PROFILE_GRP		(NR_PROFILE_HIT/PROFILE_GRPSZ)
 
 static atomic_t *prof_buffer;
-static unsigned long prof_len, prof_shift;
+static unsigned long prof_len;
+static unsigned short int prof_shift;
 
 int prof_on __read_mostly;
 EXPORT_SYMBOL_GPL(prof_on);
@@ -66,8 +67,8 @@ int profile_setup(char *str)
 		if (str[strlen(sleepstr)] == ',')
 			str += strlen(sleepstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel sleep profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel sleep profiling enabled (shift: %u)\n",
 			prof_shift);
 #else
 		pr_warn("kernel sleep profiling requires CONFIG_SCHEDSTATS\n");
@@ -77,21 +78,21 @@ int profile_setup(char *str)
 		if (str[strlen(schedstr)] == ',')
 			str += strlen(schedstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel schedule profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel schedule profiling enabled (shift: %u)\n",
 			prof_shift);
 	} else if (!strncmp(str, kvmstr, strlen(kvmstr))) {
 		prof_on = KVM_PROFILING;
 		if (str[strlen(kvmstr)] == ',')
 			str += strlen(kvmstr) + 1;
 		if (get_option(&str, &par))
-			prof_shift = par;
-		pr_info("kernel KVM profiling enabled (shift: %ld)\n",
+			prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
+		pr_info("kernel KVM profiling enabled (shift: %u)\n",
 			prof_shift);
 	} else if (get_option(&str, &par)) {
-		prof_shift = par;
+		prof_shift = clamp(par, 0, BITS_PER_LONG - 1);
 		prof_on = CPU_PROFILING;
-		pr_info("kernel profiling enabled (shift: %ld)\n",
+		pr_info("kernel profiling enabled (shift: %u)\n",
 			prof_shift);
 	}
 	return 1;
@@ -467,7 +468,7 @@ read_profile(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	unsigned long p = *ppos;
 	ssize_t read;
 	char *pnt;
-	unsigned int sample_step = 1 << prof_shift;
+	unsigned long sample_step = 1UL << prof_shift;
 
 	profile_flip_buffers();
 	if (p >= (prof_len+1)*sizeof(unsigned int))
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 46d61b597731..f90d10c1c3c8 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -534,7 +534,7 @@ static void rcu_exp_wait_wake(struct rcu_state *rsp, unsigned long s)
 			spin_unlock(&rnp->exp_lock);
 		}
 		smp_mb(); /* All above changes before wakeup. */
-		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp->expedited_sequence) & 0x3]);
+		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
 	}
 	trace_rcu_exp_grace_period(rsp->name, s, TPS("endwake"));
 	mutex_unlock(&rsp->exp_wake_mutex);
diff --git a/kernel/sys.c b/kernel/sys.c
index 2e4f017f7c5a..65701dd2707e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1873,13 +1873,6 @@ static int validate_prctl_map(struct prctl_mm_map *prctl_map)
 
 	error = -EINVAL;
 
-	/*
-	 * @brk should be after @end_data in traditional maps.
-	 */
-	if (prctl_map->start_brk <= prctl_map->end_data ||
-	    prctl_map->brk <= prctl_map->end_data)
-		goto out;
-
 	/*
 	 * Neither we should allow to override limits if they set.
 	 */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e1df563cdfe7..428eaf16a1d2 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -816,7 +816,6 @@ config HARDLOCKUP_DETECTOR
 	depends on HAVE_HARDLOCKUP_DETECTOR_PERF || HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select LOCKUP_DETECTOR
 	select HARDLOCKUP_DETECTOR_PERF if HAVE_HARDLOCKUP_DETECTOR_PERF
-	select HARDLOCKUP_DETECTOR_ARCH if HAVE_HARDLOCKUP_DETECTOR_ARCH
 	help
 	  Say Y here to enable the kernel to act as a watchdog to detect
 	  hard lockups.
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index f88911cffa1a..c6a46e8e9eda 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -602,7 +602,7 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 	chan->vc_wq = kmalloc(sizeof(wait_queue_head_t), GFP_KERNEL);
 	if (!chan->vc_wq) {
 		err = -ENOMEM;
-		goto out_free_tag;
+		goto out_remove_file;
 	}
 	init_waitqueue_head(chan->vc_wq);
 	chan->ring_bufs_avail = 1;
@@ -620,6 +620,8 @@ static int p9_virtio_probe(struct virtio_device *vdev)
 
 	return 0;
 
+out_remove_file:
+	sysfs_remove_file(&vdev->dev.kobj, &dev_attr_mount_tag.attr);
 out_free_tag:
 	kfree(tag);
 out_free_vq:
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 90428c59cfaf..89a24de23086 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -1118,6 +1118,9 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	union sctp_addr_param *param;
 	union sctp_addr paddr;
 
+	if (ntohs(ch->length) < sizeof(*asconf) + sizeof(struct sctp_paramhdr))
+		return NULL;
+
 	/* Skip over the ADDIP header and find the Address parameter */
 	param = (union sctp_addr_param *)(asconf + 1);
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 3a7bee87054a..591d6a1d1b21 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2161,9 +2161,16 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 		break;
 
 	case SCTP_PARAM_SET_PRIMARY:
-		if (net->sctp.addip_enable)
-			break;
-		goto fallthrough;
+		if (!net->sctp.addip_enable)
+			goto fallthrough;
+
+		if (ntohs(param.p->length) < sizeof(struct sctp_addip_param) +
+					     sizeof(struct sctp_paramhdr)) {
+			sctp_process_inv_paramlength(asoc, param.p,
+						     chunk, err_chunk);
+			retval = SCTP_IERROR_ABORT;
+		}
+		break;
 
 	case SCTP_PARAM_HOST_NAME_ADDRESS:
 		/* Tell the peer, we won't support this param.  */
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 5341d8e52a2b..afd3e06e8fdd 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -1900,9 +1900,6 @@ int __aafs_ns_mkdir(struct aa_ns *ns, struct dentry *parent, const char *name,
 	return error;
 }
 
-
-#define list_entry_is_head(pos, head, member) (&pos->member == (head))
-
 /**
  * __next_ns - find the next namespace to list
  * @root: root namespace to stop search at (NOT NULL)
