Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A10650AD6
	for <lists+stable@lfdr.de>; Mon, 19 Dec 2022 12:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiLSLmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 06:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiLSLma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 06:42:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1361A634B;
        Mon, 19 Dec 2022 03:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 899D560F12;
        Mon, 19 Dec 2022 11:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7791EC433D2;
        Mon, 19 Dec 2022 11:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671450148;
        bh=sxyH3R+XZpxjmmbADWVJ9T8WX5jN9r4jTew6/qWeq5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2I7S1iNlQo2O/VYRa/ZQB1gyaDMYJiieQMDsiu7iWL1DlfA2f1i32ecnmkorWE6n
         wf3e3PbYN4VSx9h3rzCLU4D9gyMSDal4qTascBc3KFd7SZyI6SLq3lJJSRFN4BdpsS
         sgTmnLEKHPdVeoCHlU+jxg1rJ4hOzRiHRh96aVDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.228
Date:   Mon, 19 Dec 2022 12:42:16 +0100
Message-Id: <1671450135482@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <1671450135165176@kroah.com>
References: <1671450135165176@kroah.com>
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

diff --git a/Makefile b/Makefile
index 111f7c91ed6f..d70676d900f5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 227
+SUBLEVEL = 228
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.c b/arch/x86/kernel/cpu/mtrr/mtrr.c
index 507039c20128..4482819bb13c 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.c
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.c
@@ -794,8 +794,6 @@ void mtrr_ap_init(void)
 	if (!use_intel() || mtrr_aps_delayed_init)
 		return;
 
-	rcu_cpu_starting(smp_processor_id());
-
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
 	 * changed, but this routine will be called in cpu boot time,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 8367bd7a9a81..1699d18bd154 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -224,6 +224,7 @@ static void notrace start_secondary(void *unused)
 #endif
 	load_current_idt();
 	cpu_init();
+	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
 	preempt_disable();
 	smp_callin();
diff --git a/block/partition-generic.c b/block/partition-generic.c
index aee643ce13d1..e69452c1f5ad 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -272,6 +272,7 @@ void delete_partition(struct gendisk *disk, int partno)
 	struct disk_part_tbl *ptbl =
 		rcu_dereference_protected(disk->part_tbl, 1);
 	struct hd_struct *part;
+	struct block_device *bdev;
 
 	if (partno >= ptbl->len)
 		return;
@@ -292,6 +293,12 @@ void delete_partition(struct gendisk *disk, int partno)
 	 * "in-use" until we really free the gendisk.
 	 */
 	blk_invalidate_devt(part_devt(part));
+
+	bdev = bdget(part_devt(part));
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	hd_struct_kill(part);
 }
 
diff --git a/drivers/net/can/usb/mcba_usb.c b/drivers/net/can/usb/mcba_usb.c
index 957e51a77d4d..16fb4fc26518 100644
--- a/drivers/net/can/usb/mcba_usb.c
+++ b/drivers/net/can/usb/mcba_usb.c
@@ -47,6 +47,10 @@
 #define MCBA_VER_REQ_USB 1
 #define MCBA_VER_REQ_CAN 2
 
+/* Drive the CAN_RES signal LOW "0" to activate R24 and R25 */
+#define MCBA_VER_TERMINATION_ON 0
+#define MCBA_VER_TERMINATION_OFF 1
+
 #define MCBA_SIDL_EXID_MASK 0x8
 #define MCBA_DLC_MASK 0xf
 #define MCBA_DLC_RTR_MASK 0x40
@@ -469,7 +473,7 @@ static void mcba_usb_process_ka_usb(struct mcba_priv *priv,
 		priv->usb_ka_first_pass = false;
 	}
 
-	if (msg->termination_state)
+	if (msg->termination_state == MCBA_VER_TERMINATION_ON)
 		priv->can.termination = MCBA_TERMINATION_ENABLED;
 	else
 		priv->can.termination = MCBA_TERMINATION_DISABLED;
@@ -789,9 +793,9 @@ static int mcba_set_termination(struct net_device *netdev, u16 term)
 	};
 
 	if (term == MCBA_TERMINATION_ENABLED)
-		usb_msg.termination = 1;
+		usb_msg.termination = MCBA_VER_TERMINATION_ON;
 	else
-		usb_msg.termination = 0;
+		usb_msg.termination = MCBA_VER_TERMINATION_OFF;
 
 	mcba_usb_xmit_cmd(priv, (struct mcba_usb_msg *)&usb_msg);
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
index 6ef48eb3a77d..b163489489e9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
+++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_cppcore.c
@@ -874,7 +874,6 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 	}
 
 	/* Adjust the start address to be cache size aligned */
-	cache->id = id;
 	cache->addr = addr & ~(u64)(cache->size - 1);
 
 	/* Re-init to the new ID and address */
@@ -894,6 +893,8 @@ area_cache_get(struct nfp_cpp *cpp, u32 id,
 		return NULL;
 	}
 
+	cache->id = id;
+
 exit:
 	/* Adjust offset */
 	*offset = addr - cache->addr;
diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index 7e526bcf5e0b..24502dfeb83f 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -277,12 +277,15 @@ static struct irq_chip mtk_eint_irq_chip = {
 
 static unsigned int mtk_eint_hw_init(struct mtk_eint *eint)
 {
-	void __iomem *reg = eint->base + eint->regs->dom_en;
+	void __iomem *dom_en = eint->base + eint->regs->dom_en;
+	void __iomem *mask_set = eint->base + eint->regs->mask_set;
 	unsigned int i;
 
 	for (i = 0; i < eint->hw->ap_num; i += 32) {
-		writel(0xffffffff, reg);
-		reg += 4;
+		writel(0xffffffff, dom_en);
+		writel(0xffffffff, mask_set);
+		dom_en += 4;
+		mask_set += 4;
 	}
 
 	return 0;
diff --git a/include/linux/can/platform/sja1000.h b/include/linux/can/platform/sja1000.h
index 5755ae5a4712..6a869682c120 100644
--- a/include/linux/can/platform/sja1000.h
+++ b/include/linux/can/platform/sja1000.h
@@ -14,7 +14,7 @@
 #define OCR_MODE_TEST     0x01
 #define OCR_MODE_NORMAL   0x02
 #define OCR_MODE_CLOCK    0x03
-#define OCR_MODE_MASK     0x07
+#define OCR_MODE_MASK     0x03
 #define OCR_TX0_INVERT    0x04
 #define OCR_TX0_PULLDOWN  0x08
 #define OCR_TX0_PULLUP    0x10
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index cef70d6e1657..c7507135c2a0 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -127,8 +127,8 @@ struct page *follow_huge_addr(struct mm_struct *mm, unsigned long address,
 struct page *follow_huge_pd(struct vm_area_struct *vma,
 			    unsigned long address, hugepd_t hpd,
 			    int flags, int pdshift);
-struct page *follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-				pmd_t *pmd, int flags);
+struct page *follow_huge_pmd_pte(struct vm_area_struct *vma, unsigned long address,
+				 int flags);
 struct page *follow_huge_pud(struct mm_struct *mm, unsigned long address,
 				pud_t *pud, int flags);
 struct page *follow_huge_pgd(struct mm_struct *mm, unsigned long address,
@@ -175,7 +175,7 @@ static inline void hugetlb_show_meminfo(void)
 {
 }
 #define follow_huge_pd(vma, addr, hpd, flags, pdshift) NULL
-#define follow_huge_pmd(mm, addr, pmd, flags)	NULL
+#define follow_huge_pmd_pte(vma, addr, flags)	NULL
 #define follow_huge_pud(mm, addr, pud, flags)	NULL
 #define follow_huge_pgd(mm, addr, pgd, flags)	NULL
 #define prepare_hugepage_range(file, addr, len)	(-EINVAL)
diff --git a/mm/gup.c b/mm/gup.c
index 7ec083fe1c50..2cff8b4d412c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -188,6 +188,17 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pte_t *ptep, pte;
 
+	/*
+	 * Considering PTE level hugetlb, like continuous-PTE hugetlb on
+	 * ARM64 architecture.
+	 */
+	if (is_vm_hugetlb_page(vma)) {
+		page = follow_huge_pmd_pte(vma, address, flags);
+		if (page)
+			return page;
+		return no_page_table(vma, flags);
+	}
+
 retry:
 	if (unlikely(pmd_bad(*pmd)))
 		return no_page_table(vma, flags);
@@ -333,7 +344,7 @@ static struct page *follow_pmd_mask(struct vm_area_struct *vma,
 	if (pmd_none(pmdval))
 		return no_page_table(vma, flags);
 	if (pmd_huge(pmdval) && vma->vm_flags & VM_HUGETLB) {
-		page = follow_huge_pmd(mm, address, pmd, flags);
+		page = follow_huge_pmd_pte(vma, address, flags);
 		if (page)
 			return page;
 		return no_page_table(vma, flags);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2126d78f053d..e4478b62d0f7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5157,30 +5157,30 @@ follow_huge_pd(struct vm_area_struct *vma,
 }
 
 struct page * __weak
-follow_huge_pmd(struct mm_struct *mm, unsigned long address,
-		pmd_t *pmd, int flags)
+follow_huge_pmd_pte(struct vm_area_struct *vma, unsigned long address, int flags)
 {
+	struct hstate *h = hstate_vma(vma);
+	struct mm_struct *mm = vma->vm_mm;
 	struct page *page = NULL;
 	spinlock_t *ptl;
-	pte_t pte;
+	pte_t *ptep, pte;
+
 retry:
-	ptl = pmd_lockptr(mm, pmd);
-	spin_lock(ptl);
-	/*
-	 * make sure that the address range covered by this pmd is not
-	 * unmapped from other threads.
-	 */
-	if (!pmd_huge(*pmd))
-		goto out;
-	pte = huge_ptep_get((pte_t *)pmd);
+	ptep = huge_pte_offset(mm, address, huge_page_size(h));
+	if (!ptep)
+		return NULL;
+
+	ptl = huge_pte_lock(h, mm, ptep);
+	pte = huge_ptep_get(ptep);
 	if (pte_present(pte)) {
-		page = pmd_page(*pmd) + ((address & ~PMD_MASK) >> PAGE_SHIFT);
+		page = pte_page(pte) +
+			((address & ~huge_page_mask(h)) >> PAGE_SHIFT);
 		if (flags & FOLL_GET)
 			get_page(page);
 	} else {
 		if (is_hugetlb_entry_migration(pte)) {
 			spin_unlock(ptl);
-			__migration_entry_wait(mm, (pte_t *)pmd, ptl);
+			__migration_entry_wait(mm, ptep, ptl);
 			goto retry;
 		}
 		/*
@@ -5188,7 +5188,7 @@ follow_huge_pmd(struct mm_struct *mm, unsigned long address,
 		 * follow_page_mask().
 		 */
 	}
-out:
+
 	spin_unlock(ptl);
 	return page;
 }
diff --git a/net/core/filter.c b/net/core/filter.c
index 72bf78032f45..e81f7772161a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6196,6 +6196,8 @@ tc_cls_act_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 		return &bpf_skb_adjust_room_proto;
 	case BPF_FUNC_skb_change_tail:
 		return &bpf_skb_change_tail_proto;
+	case BPF_FUNC_skb_change_head:
+		return &bpf_skb_change_head_proto;
 	case BPF_FUNC_skb_get_tunnel_key:
 		return &bpf_skb_get_tunnel_key_proto;
 	case BPF_FUNC_skb_set_tunnel_key:
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 2faf95d4bb75..e01f3bf3ef17 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -458,8 +458,15 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 		return err;
 
 	if (snd_soc_volsw_is_stereo(mc)) {
+		val2 = ucontrol->value.integer.value[1];
+
+		if (mc->platform_max && val2 > mc->platform_max)
+			return -EINVAL;
+		if (val2 > max)
+			return -EINVAL;
+
 		val_mask = mask << rshift;
-		val2 = (ucontrol->value.integer.value[1] + min) & mask;
+		val2 = (val2 + min) & mask;
 		val2 = val2 << rshift;
 
 		err = snd_soc_component_update_bits(component, reg2, val_mask,
