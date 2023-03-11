Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964B06B5CB6
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 15:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjCKORp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 09:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCKORk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 09:17:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790A1132A8A;
        Sat, 11 Mar 2023 06:17:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E645B82561;
        Sat, 11 Mar 2023 14:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7414C433EF;
        Sat, 11 Mar 2023 14:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678544238;
        bh=XxH/W8dSxwwottnJVVetjmIS0cd3kV/7GNlQiFMUoP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjGq9F/noedTKmqWSldla+U4DiGUF0SqsNcCP+gKKWjUwAJtAVF1vN16o6UUELkhu
         QQA7KXCYtRr7KQSJWInztDJ+1UECbHN2nqr6sgZjYayuxfGL58POxjMpDQmJCwfw4y
         yhwGjG+93bLkloYZMzw3s02ixnMbTdJD/ECFC7oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.18
Date:   Sat, 11 Mar 2023 15:17:06 +0100
Message-Id: <1678544225180202@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <16785442252966@kroah.com>
References: <16785442252966@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
index 611b23e6488d..feb3f2cc0c16 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -52,7 +52,7 @@ Date:		Dec 2014
 KernelVersion:	4.0
 Description:	Default output terminal descriptors
 
-		All attributes read only:
+		All attributes read only except bSourceID:
 
 		==============	=============================================
 		iTerminal	index of string descriptor
diff --git a/Makefile b/Makefile
index db482a420dca..a825361f7162 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 17
+SUBLEVEL = 18
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/boot/dts/spear320-hmi.dts b/arch/arm/boot/dts/spear320-hmi.dts
index 34503ac9c51c..721e5ee7b680 100644
--- a/arch/arm/boot/dts/spear320-hmi.dts
+++ b/arch/arm/boot/dts/spear320-hmi.dts
@@ -241,7 +241,7 @@ stmpe811@41 {
 					irq-trigger = <0x1>;
 
 					stmpegpio: stmpe-gpio {
-						compatible = "stmpe,gpio";
+						compatible = "st,stmpe-gpio";
 						reg = <0>;
 						gpio-controller;
 						#gpio-cells = <2>;
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index b13c22046de5..62c846be2d76 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -33,7 +33,7 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 ({									\
 	efi_virtmap_load();						\
 	__efi_fpsimd_begin();						\
-	spin_lock(&efi_rt_lock);					\
+	raw_spin_lock(&efi_rt_lock);					\
 })
 
 #undef arch_efi_call_virt
@@ -42,12 +42,12 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
 
 #define arch_efi_call_virt_teardown()					\
 ({									\
-	spin_unlock(&efi_rt_lock);					\
+	raw_spin_unlock(&efi_rt_lock);					\
 	__efi_fpsimd_end();						\
 	efi_virtmap_unload();						\
 })
 
-extern spinlock_t efi_rt_lock;
+extern raw_spinlock_t efi_rt_lock;
 extern u64 *efi_rt_stack_top;
 efi_status_t __efi_rt_asm_wrapper(void *, const char *, ...);
 
diff --git a/arch/arm64/include/asm/mte.h b/arch/arm64/include/asm/mte.h
index 760c62f8e22f..3f8199ba265a 100644
--- a/arch/arm64/include/asm/mte.h
+++ b/arch/arm64/include/asm/mte.h
@@ -37,6 +37,29 @@ void mte_free_tag_storage(char *storage);
 /* track which pages have valid allocation tags */
 #define PG_mte_tagged	PG_arch_2
 
+static inline void set_page_mte_tagged(struct page *page)
+{
+	/*
+	 * Ensure that the tags written prior to this function are visible
+	 * before the page flags update.
+	 */
+	smp_wmb();
+	set_bit(PG_mte_tagged, &page->flags);
+}
+
+static inline bool page_mte_tagged(struct page *page)
+{
+	bool ret = test_bit(PG_mte_tagged, &page->flags);
+
+	/*
+	 * If the page is tagged, ensure ordering with a likely subsequent
+	 * read of the tags.
+	 */
+	if (ret)
+		smp_rmb();
+	return ret;
+}
+
 void mte_zero_clear_page_tags(void *addr);
 void mte_sync_tags(pte_t old_pte, pte_t pte);
 void mte_copy_page_tags(void *kto, const void *kfrom);
@@ -56,6 +79,13 @@ size_t mte_probe_user_range(const char __user *uaddr, size_t size);
 /* unused if !CONFIG_ARM64_MTE, silence the compiler */
 #define PG_mte_tagged	0
 
+static inline void set_page_mte_tagged(struct page *page)
+{
+}
+static inline bool page_mte_tagged(struct page *page)
+{
+	return false;
+}
 static inline void mte_zero_clear_page_tags(void *addr)
 {
 }
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index f1cfc44ef52f..5d0f1f7b7600 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1050,7 +1050,7 @@ static inline void arch_swap_invalidate_area(int type)
 static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 {
 	if (system_supports_mte() && mte_restore_tags(entry, &folio->page))
-		set_bit(PG_mte_tagged, &folio->flags);
+		set_page_mte_tagged(&folio->page);
 }
 
 #endif /* CONFIG_ARM64_MTE */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 86b2f7ec6c67..b3eb53847c96 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2074,8 +2074,10 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 	 * Clear the tags in the zero page. This needs to be done via the
 	 * linear map which has the Tagged attribute.
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &ZERO_PAGE(0)->flags))
+	if (!page_mte_tagged(ZERO_PAGE(0))) {
 		mte_clear_page_tags(lm_alias(empty_zero_page));
+		set_page_mte_tagged(ZERO_PAGE(0));
+	}
 
 	kasan_init_hw_tags_cpu();
 }
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b273900f4566..a30dbe4b95cd 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -146,7 +146,7 @@ asmlinkage efi_status_t efi_handle_corrupted_x18(efi_status_t s, const char *f)
 	return s;
 }
 
-DEFINE_SPINLOCK(efi_rt_lock);
+DEFINE_RAW_SPINLOCK(efi_rt_lock);
 
 asmlinkage u64 *efi_rt_stack_top __ro_after_init;
 
diff --git a/arch/arm64/kernel/elfcore.c b/arch/arm64/kernel/elfcore.c
index 662a61e5e75e..2e94d20c4ac7 100644
--- a/arch/arm64/kernel/elfcore.c
+++ b/arch/arm64/kernel/elfcore.c
@@ -46,7 +46,7 @@ static int mte_dump_tag_range(struct coredump_params *cprm,
 		 * Pages mapped in user space as !pte_access_permitted() (e.g.
 		 * PROT_EXEC only) may not have the PG_mte_tagged flag set.
 		 */
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			put_page(page);
 			dump_skip(cprm, MTE_PAGE_TAG_STORAGE);
 			continue;
diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index af5df48ba915..788597a6b6a2 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -271,7 +271,7 @@ static int swsusp_mte_save_tags(void)
 			if (!page)
 				continue;
 
-			if (!test_bit(PG_mte_tagged, &page->flags))
+			if (!page_mte_tagged(page))
 				continue;
 
 			ret = save_tags(page, pfn);
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 7467217c1eaf..84a085d536f8 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -41,8 +41,10 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	if (check_swap && is_swap_pte(old_pte)) {
 		swp_entry_t entry = pte_to_swp_entry(old_pte);
 
-		if (!non_swap_entry(entry) && mte_restore_tags(entry, page))
+		if (!non_swap_entry(entry) && mte_restore_tags(entry, page)) {
+			set_page_mte_tagged(page);
 			return;
+		}
 	}
 
 	if (!pte_is_tagged)
@@ -52,8 +54,10 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
 	 * Test PG_mte_tagged again in case it was racing with another
 	 * set_pte_at().
 	 */
-	if (!test_and_set_bit(PG_mte_tagged, &page->flags))
+	if (!page_mte_tagged(page)) {
 		mte_clear_page_tags(page_address(page));
+		set_page_mte_tagged(page);
+	}
 }
 
 void mte_sync_tags(pte_t old_pte, pte_t pte)
@@ -69,9 +73,11 @@ void mte_sync_tags(pte_t old_pte, pte_t pte)
 
 	/* if PG_mte_tagged is set, tags have already been initialised */
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_bit(PG_mte_tagged, &page->flags))
+		if (!page_mte_tagged(page)) {
 			mte_sync_page_tags(page, old_pte, check_swap,
 					   pte_is_tagged);
+			set_page_mte_tagged(page);
+		}
 	}
 
 	/* ensure the tags are visible before the PTE is set */
@@ -96,8 +102,7 @@ int memcmp_pages(struct page *page1, struct page *page2)
 	 * pages is tagged, set_pte_at() may zero or change the tags of the
 	 * other page via mte_sync_tags().
 	 */
-	if (test_bit(PG_mte_tagged, &page1->flags) ||
-	    test_bit(PG_mte_tagged, &page2->flags))
+	if (page_mte_tagged(page1) || page_mte_tagged(page2))
 		return addr1 != addr2;
 
 	return ret;
@@ -454,7 +459,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 			put_page(page);
 			break;
 		}
-		WARN_ON_ONCE(!test_bit(PG_mte_tagged, &page->flags));
+		WARN_ON_ONCE(!page_mte_tagged(page));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 2ff13a3f8479..817fdd1ab778 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -1059,7 +1059,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 		maddr = page_address(page);
 
 		if (!write) {
-			if (test_bit(PG_mte_tagged, &page->flags))
+			if (page_mte_tagged(page))
 				num_tags = mte_copy_tags_to_user(tags, maddr,
 							MTE_GRANULES_PER_PAGE);
 			else
@@ -1076,7 +1076,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
 			 * completed fully
 			 */
 			if (num_tags == MTE_GRANULES_PER_PAGE)
-				set_bit(PG_mte_tagged, &page->flags);
+				set_page_mte_tagged(page);
 
 			kvm_release_pfn_dirty(pfn);
 		}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 60ee3d9f01f8..2c3759f1f2c5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1110,9 +1110,9 @@ static int sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
 		return -EFAULT;
 
 	for (i = 0; i < nr_pages; i++, page++) {
-		if (!test_bit(PG_mte_tagged, &page->flags)) {
+		if (!page_mte_tagged(page)) {
 			mte_clear_page_tags(page_address(page));
-			set_bit(PG_mte_tagged, &page->flags);
+			set_page_mte_tagged(page);
 		}
 	}
 
diff --git a/arch/arm64/mm/copypage.c b/arch/arm64/mm/copypage.c
index 24913271e898..6dbc822332f2 100644
--- a/arch/arm64/mm/copypage.c
+++ b/arch/arm64/mm/copypage.c
@@ -21,9 +21,11 @@ void copy_highpage(struct page *to, struct page *from)
 
 	copy_page(kto, kfrom);
 
-	if (system_supports_mte() && test_bit(PG_mte_tagged, &from->flags)) {
-		set_bit(PG_mte_tagged, &to->flags);
+	if (system_supports_mte() && page_mte_tagged(from)) {
+		if (kasan_hw_tags_enabled())
+			page_kasan_tag_reset(to);
 		mte_copy_page_tags(kto, kfrom);
+		set_page_mte_tagged(to);
 	}
 }
 EXPORT_SYMBOL(copy_highpage);
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 3eb2825d08cf..4ee20280133e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -944,5 +944,5 @@ struct page *alloc_zeroed_user_highpage_movable(struct vm_area_struct *vma,
 void tag_clear_highpage(struct page *page)
 {
 	mte_zero_clear_page_tags(page_address(page));
-	set_bit(PG_mte_tagged, &page->flags);
+	set_page_mte_tagged(page);
 }
diff --git a/arch/arm64/mm/mteswap.c b/arch/arm64/mm/mteswap.c
index bed803d8e158..70f913205db9 100644
--- a/arch/arm64/mm/mteswap.c
+++ b/arch/arm64/mm/mteswap.c
@@ -24,7 +24,7 @@ int mte_save_tags(struct page *page)
 {
 	void *tag_storage, *ret;
 
-	if (!test_bit(PG_mte_tagged, &page->flags))
+	if (!page_mte_tagged(page))
 		return 0;
 
 	tag_storage = mte_allocate_tag_storage();
diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index ded7c47d2fbe..131b7cb29576 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -767,6 +767,7 @@ static int vector_config(char *str, char **error_out)
 
 	if (parsed == NULL) {
 		*error_out = "vector_config failed to parse parameters";
+		kfree(params);
 		return -EINVAL;
 	}
 
diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index 3ac220dafec4..5472b1a0a039 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -132,8 +132,11 @@ static int um_pci_send_cmd(struct um_pci_device *dev,
 				out ? 1 : 0,
 				posted ? cmd : HANDLE_NO_FREE(cmd),
 				GFP_ATOMIC);
-	if (ret)
+	if (ret) {
+		if (posted)
+			kfree(cmd);
 		goto out;
+	}
 
 	if (posted) {
 		virtqueue_kick(dev->cmd_vq);
@@ -623,22 +626,33 @@ static void um_pci_virtio_remove(struct virtio_device *vdev)
 	struct um_pci_device *dev = vdev->priv;
 	int i;
 
-        /* Stop all virtqueues */
-        virtio_reset_device(vdev);
-        vdev->config->del_vqs(vdev);
-
 	device_set_wakeup_enable(&vdev->dev, false);
 
 	mutex_lock(&um_pci_mtx);
 	for (i = 0; i < MAX_DEVICES; i++) {
 		if (um_pci_devices[i].dev != dev)
 			continue;
+
 		um_pci_devices[i].dev = NULL;
 		irq_free_desc(dev->irq);
+
+		break;
 	}
 	mutex_unlock(&um_pci_mtx);
 
-	um_pci_rescan();
+	if (i < MAX_DEVICES) {
+		struct pci_dev *pci_dev;
+
+		pci_dev = pci_get_slot(bridge->bus, i);
+		if (pci_dev)
+			pci_stop_and_remove_bus_device_locked(pci_dev);
+	}
+
+	/* Stop all virtqueues */
+	virtio_reset_device(vdev);
+	dev->cmd_vq = NULL;
+	dev->irq_vq = NULL;
+	vdev->config->del_vqs(vdev);
 
 	kfree(dev);
 }
diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 588930a0ced1..ddd080f6dd82 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -168,7 +168,8 @@ static void vhost_user_check_reset(struct virtio_uml_device *vu_dev,
 	if (!vu_dev->registered)
 		return;
 
-	virtio_break_device(&vu_dev->vdev);
+	vu_dev->registered = 0;
+
 	schedule_work(&pdata->conn_broken_wk);
 }
 
@@ -1136,6 +1137,15 @@ void virtio_uml_set_no_vq_suspend(struct virtio_device *vdev,
 
 static void vu_of_conn_broken(struct work_struct *wk)
 {
+	struct virtio_uml_platform_data *pdata;
+	struct virtio_uml_device *vu_dev;
+
+	pdata = container_of(wk, struct virtio_uml_platform_data, conn_broken_wk);
+
+	vu_dev = platform_get_drvdata(pdata->pdev);
+
+	virtio_break_device(&vu_dev->vdev);
+
 	/*
 	 * We can't remove the device from the devicetree so the only thing we
 	 * can do is warn.
@@ -1266,8 +1276,14 @@ static int vu_unregister_cmdline_device(struct device *dev, void *data)
 static void vu_conn_broken(struct work_struct *wk)
 {
 	struct virtio_uml_platform_data *pdata;
+	struct virtio_uml_device *vu_dev;
 
 	pdata = container_of(wk, struct virtio_uml_platform_data, conn_broken_wk);
+
+	vu_dev = platform_get_drvdata(pdata->pdev);
+
+	virtio_break_device(&vu_dev->vdev);
+
 	vu_unregister_cmdline_device(&pdata->pdev->dev, NULL);
 }
 
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index d24b04ebf950..a4641d68eaba 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
@@ -51,7 +51,7 @@ DECLARE_STATIC_KEY_FALSE(rdt_mon_enable_key);
  *   simple as possible.
  * Must be called with preemption disabled.
  */
-static void __resctrl_sched_in(void)
+static inline void __resctrl_sched_in(struct task_struct *tsk)
 {
 	struct resctrl_pqr_state *state = this_cpu_ptr(&pqr_state);
 	u32 closid = state->default_closid;
@@ -63,13 +63,13 @@ static void __resctrl_sched_in(void)
 	 * Else use the closid/rmid assigned to this cpu.
 	 */
 	if (static_branch_likely(&rdt_alloc_enable_key)) {
-		tmp = READ_ONCE(current->closid);
+		tmp = READ_ONCE(tsk->closid);
 		if (tmp)
 			closid = tmp;
 	}
 
 	if (static_branch_likely(&rdt_mon_enable_key)) {
-		tmp = READ_ONCE(current->rmid);
+		tmp = READ_ONCE(tsk->rmid);
 		if (tmp)
 			rmid = tmp;
 	}
@@ -90,17 +90,17 @@ static inline unsigned int resctrl_arch_round_mon_val(unsigned int val)
 	return val * scale;
 }
 
-static inline void resctrl_sched_in(void)
+static inline void resctrl_sched_in(struct task_struct *tsk)
 {
 	if (static_branch_likely(&rdt_enable_key))
-		__resctrl_sched_in();
+		__resctrl_sched_in(tsk);
 }
 
 void resctrl_cpu_detect(struct cpuinfo_x86 *c);
 
 #else
 
-static inline void resctrl_sched_in(void) {}
+static inline void resctrl_sched_in(struct task_struct *tsk) {}
 static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
 
 #endif /* CONFIG_X86_CPU_RESCTRL */
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 5993da21d822..87b670d540b8 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -314,7 +314,7 @@ static void update_cpu_closid_rmid(void *info)
 	 * executing task might have its own closid selected. Just reuse
 	 * the context switch code.
 	 */
-	resctrl_sched_in();
+	resctrl_sched_in(current);
 }
 
 /*
@@ -535,7 +535,7 @@ static void _update_task_closid_rmid(void *task)
 	 * Otherwise, the MSR is updated when the task is scheduled in.
 	 */
 	if (task == current)
-		resctrl_sched_in();
+		resctrl_sched_in(task);
 }
 
 static void update_task_closid_rmid(struct task_struct *t)
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 2f314b170c9f..ceab14b6118f 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -212,7 +212,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	switch_fpu_finish();
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6b3418bff326..7f94dbbc397b 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -656,7 +656,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	}
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/um/vdso/um_vdso.c b/arch/x86/um/vdso/um_vdso.c
index 2112b8d14668..ff0f3b4b6c45 100644
--- a/arch/x86/um/vdso/um_vdso.c
+++ b/arch/x86/um/vdso/um_vdso.c
@@ -17,8 +17,10 @@ int __vdso_clock_gettime(clockid_t clock, struct __kernel_old_timespec *ts)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_clock_gettime), "D" (clock), "S" (ts)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
@@ -29,8 +31,10 @@ int __vdso_gettimeofday(struct __kernel_old_timeval *tv, struct timezone *tz)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_gettimeofday), "D" (tv), "S" (tz)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 97450f4003cc..f007116a8427 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -484,6 +484,25 @@ void acpi_dev_power_up_children_with_adr(struct acpi_device *adev)
 	acpi_dev_for_each_child(adev, acpi_power_up_if_adr_present, NULL);
 }
 
+/**
+ * acpi_dev_power_state_for_wake - Deepest power state for wakeup signaling
+ * @adev: ACPI companion of the target device.
+ *
+ * Evaluate _S0W for @adev and return the value produced by it or return
+ * ACPI_STATE_UNKNOWN on errors (including _S0W not present).
+ */
+u8 acpi_dev_power_state_for_wake(struct acpi_device *adev)
+{
+	unsigned long long state;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(adev->handle, "_S0W", NULL, &state);
+	if (ACPI_FAILURE(status))
+		return ACPI_STATE_UNKNOWN;
+
+	return state;
+}
+
 #ifdef CONFIG_PM
 static DEFINE_MUTEX(acpi_pm_notifier_lock);
 static DEFINE_MUTEX(acpi_pm_notifier_install_lock);
diff --git a/drivers/auxdisplay/hd44780.c b/drivers/auxdisplay/hd44780.c
index 8b2a0eb3f32a..d56a5d508ccd 100644
--- a/drivers/auxdisplay/hd44780.c
+++ b/drivers/auxdisplay/hd44780.c
@@ -322,8 +322,10 @@ static int hd44780_probe(struct platform_device *pdev)
 static int hd44780_remove(struct platform_device *pdev)
 {
 	struct charlcd *lcd = platform_get_drvdata(pdev);
+	struct hd44780_common *hdc = lcd->drvdata;
 
 	charlcd_unregister(lcd);
+	kfree(hdc->hd44780);
 	kfree(lcd->drvdata);
 
 	kfree(lcd);
diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 4b5cd08c5a65..f30256a524be 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -251,7 +251,7 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 {
 	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
 	struct cacheinfo *this_leaf, *sib_leaf;
-	unsigned int index;
+	unsigned int index, sib_index;
 	int ret = 0;
 
 	if (this_cpu_ci->cpu_map_populated)
@@ -279,11 +279,13 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 
 			if (i == cpu || !sib_cpu_ci->info_list)
 				continue;/* skip if itself or no cacheinfo */
-
-			sib_leaf = per_cpu_cacheinfo_idx(i, index);
-			if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
-				cpumask_set_cpu(cpu, &sib_leaf->shared_cpu_map);
-				cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+			for (sib_index = 0; sib_index < cache_leaves(i); sib_index++) {
+				sib_leaf = per_cpu_cacheinfo_idx(i, sib_index);
+				if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
+					cpumask_set_cpu(cpu, &sib_leaf->shared_cpu_map);
+					cpumask_set_cpu(i, &this_leaf->shared_cpu_map);
+					break;
+				}
 			}
 		}
 		/* record the maximum cache line size */
@@ -297,7 +299,7 @@ static int cache_shared_cpu_map_setup(unsigned int cpu)
 static void cache_shared_cpu_map_remove(unsigned int cpu)
 {
 	struct cacheinfo *this_leaf, *sib_leaf;
-	unsigned int sibling, index;
+	unsigned int sibling, index, sib_index;
 
 	for (index = 0; index < cache_leaves(cpu); index++) {
 		this_leaf = per_cpu_cacheinfo_idx(cpu, index);
@@ -308,9 +310,14 @@ static void cache_shared_cpu_map_remove(unsigned int cpu)
 			if (sibling == cpu || !sib_cpu_ci->info_list)
 				continue;/* skip if itself or no cacheinfo */
 
-			sib_leaf = per_cpu_cacheinfo_idx(sibling, index);
-			cpumask_clear_cpu(cpu, &sib_leaf->shared_cpu_map);
-			cpumask_clear_cpu(sibling, &this_leaf->shared_cpu_map);
+			for (sib_index = 0; sib_index < cache_leaves(sibling); sib_index++) {
+				sib_leaf = per_cpu_cacheinfo_idx(sibling, sib_index);
+				if (cache_leaves_are_shared(this_leaf, sib_leaf)) {
+					cpumask_clear_cpu(cpu, &sib_leaf->shared_cpu_map);
+					cpumask_clear_cpu(sibling, &this_leaf->shared_cpu_map);
+					break;
+				}
+			}
 		}
 		if (of_have_populated_dt())
 			of_node_put(this_leaf->fw_token);
diff --git a/drivers/base/component.c b/drivers/base/component.c
index 5eadeac6c532..7dbf14a1d915 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -125,7 +125,7 @@ static void component_debugfs_add(struct aggregate_device *m)
 
 static void component_debugfs_del(struct aggregate_device *m)
 {
-	debugfs_remove(debugfs_lookup(dev_name(m->parent), component_debugfs_dir));
+	debugfs_lookup_and_remove(dev_name(m->parent), component_debugfs_dir);
 }
 
 #else
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 9ae2b5c4fc49..c463173f1fb1 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -372,7 +372,7 @@ late_initcall(deferred_probe_initcall);
 
 static void __exit deferred_probe_exit(void)
 {
-	debugfs_remove_recursive(debugfs_lookup("devices_deferred", NULL));
+	debugfs_lookup_and_remove("devices_deferred", NULL);
 }
 __exitcall(deferred_probe_exit);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index df628e30bca4..981464e561df 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -977,13 +977,13 @@ loop_set_status_from_info(struct loop_device *lo,
 		return -EINVAL;
 	}
 
+	/* Avoid assigning overflow values */
+	if (info->lo_offset > LLONG_MAX || info->lo_sizelimit > LLONG_MAX)
+		return -EOVERFLOW;
+
 	lo->lo_offset = info->lo_offset;
 	lo->lo_sizelimit = info->lo_sizelimit;
 
-	/* loff_t vars have been assigned __u64 */
-	if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
-		return -EOVERFLOW;
-
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
 	lo->lo_flags = info->lo_flags;
diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 9c4288681841..357c61c12ce5 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -219,7 +219,7 @@ static int mhi_ep_process_cmd_ring(struct mhi_ep_ring *ring, struct mhi_ring_ele
 		mutex_unlock(&mhi_chan->lock);
 		break;
 	case MHI_PKT_TYPE_RESET_CHAN_CMD:
-		dev_dbg(dev, "Received STOP command for channel (%u)\n", ch_id);
+		dev_dbg(dev, "Received RESET command for channel (%u)\n", ch_id);
 		if (!ch_ring->started) {
 			dev_err(dev, "Channel (%u) not opened\n", ch_id);
 			return -ENODEV;
diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index 7882d4b3f2be..f06fdacc9bc8 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -264,6 +264,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"Lenovo ideapad D330-10IGM"),
 		},
 	},
+	{
+		/* Lenovo IdeaPad Duet 3 10IGL5 with 1200x1920 portrait screen */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"IdeaPad Duet 3 10IGL5"),
+		},
+	},
 	{},
 };
 
diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 4ca37261584a..e77c674b37ca 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3309,8 +3309,13 @@ int drm_dp_add_payload_part1(struct drm_dp_mst_topology_mgr *mgr,
 	int ret;
 
 	port = drm_dp_mst_topology_get_port_validated(mgr, payload->port);
-	if (!port)
+	if (!port) {
+		drm_dbg_kms(mgr->dev,
+			    "VCPI %d for port %p not in topology, not creating a payload\n",
+			    payload->vcpi, payload->port);
+		payload->vc_start_slot = -1;
 		return 0;
+	}
 
 	if (mgr->payload_count == 0)
 		mgr->next_start_slot = mst_state->start_slot;
@@ -3644,6 +3649,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
 		mgr->payload_id_table_cleared = false;
+
+		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
+		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
 	}
 
 out_unlock:
@@ -3856,7 +3864,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_sideband_msg_rx *msg = &mgr->down_rep_recv;
 
 	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb))
-		goto out;
+		goto out_clear_reply;
 
 	/* Multi-packet message transmission, don't clear the reply */
 	if (!msg->have_eomt)
@@ -5354,28 +5362,53 @@ struct drm_dp_mst_topology_state *drm_atomic_get_mst_topology_state(struct drm_a
 }
 EXPORT_SYMBOL(drm_atomic_get_mst_topology_state);
 
+/**
+ * drm_atomic_get_old_mst_topology_state: get old MST topology state in atomic state, if any
+ * @state: global atomic state
+ * @mgr: MST topology manager, also the private object in this case
+ *
+ * This function wraps drm_atomic_get_old_private_obj_state() passing in the MST atomic
+ * state vtable so that the private object state returned is that of a MST
+ * topology object.
+ *
+ * Returns:
+ *
+ * The old MST topology state, or NULL if there's no topology state for this MST mgr
+ * in the global atomic state
+ */
+struct drm_dp_mst_topology_state *
+drm_atomic_get_old_mst_topology_state(struct drm_atomic_state *state,
+				      struct drm_dp_mst_topology_mgr *mgr)
+{
+	struct drm_private_state *old_priv_state =
+		drm_atomic_get_old_private_obj_state(state, &mgr->base);
+
+	return old_priv_state ? to_dp_mst_topology_state(old_priv_state) : NULL;
+}
+EXPORT_SYMBOL(drm_atomic_get_old_mst_topology_state);
+
 /**
  * drm_atomic_get_new_mst_topology_state: get new MST topology state in atomic state, if any
  * @state: global atomic state
  * @mgr: MST topology manager, also the private object in this case
  *
- * This function wraps drm_atomic_get_priv_obj_state() passing in the MST atomic
+ * This function wraps drm_atomic_get_new_private_obj_state() passing in the MST atomic
  * state vtable so that the private object state returned is that of a MST
  * topology object.
  *
  * Returns:
  *
- * The MST topology state, or NULL if there's no topology state for this MST mgr
+ * The new MST topology state, or NULL if there's no topology state for this MST mgr
  * in the global atomic state
  */
 struct drm_dp_mst_topology_state *
 drm_atomic_get_new_mst_topology_state(struct drm_atomic_state *state,
 				      struct drm_dp_mst_topology_mgr *mgr)
 {
-	struct drm_private_state *priv_state =
+	struct drm_private_state *new_priv_state =
 		drm_atomic_get_new_private_obj_state(state, &mgr->base);
 
-	return priv_state ? to_dp_mst_topology_state(priv_state) : NULL;
+	return new_priv_state ? to_dp_mst_topology_state(new_priv_state) : NULL;
 }
 EXPORT_SYMBOL(drm_atomic_get_new_mst_topology_state);
 
diff --git a/drivers/gpu/drm/i915/Kconfig b/drivers/gpu/drm/i915/Kconfig
index 3efce05d7b57..3a6e176d77aa 100644
--- a/drivers/gpu/drm/i915/Kconfig
+++ b/drivers/gpu/drm/i915/Kconfig
@@ -107,9 +107,6 @@ config DRM_I915_USERPTR
 
 	  If in doubt, say "Y".
 
-config DRM_I915_GVT
-	bool
-
 config DRM_I915_GVT_KVMGT
 	tristate "Enable KVM host support Intel GVT-g graphics virtualization"
 	depends on DRM_I915
@@ -160,3 +157,6 @@ menu "drm/i915 Unstable Evolution"
 	depends on DRM_I915
 	source "drivers/gpu/drm/i915/Kconfig.unstable"
 endmenu
+
+config DRM_I915_GVT
+	bool
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index de77054195c6..4bbb84847ecb 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -5969,6 +5969,10 @@ int intel_modeset_all_pipes(struct intel_atomic_state *state)
 		if (ret)
 			return ret;
 
+		ret = intel_dp_mst_add_topology_state_for_crtc(state, crtc);
+		if (ret)
+			return ret;
+
 		ret = intel_atomic_add_affected_planes(state, crtc);
 		if (ret)
 			return ret;
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 03604a37931c..27c2098dd707 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -1003,3 +1003,64 @@ bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_state)
 	return crtc_state->mst_master_transcoder != INVALID_TRANSCODER &&
 	       crtc_state->mst_master_transcoder != crtc_state->cpu_transcoder;
 }
+
+/**
+ * intel_dp_mst_add_topology_state_for_connector - add MST topology state for a connector
+ * @state: atomic state
+ * @connector: connector to add the state for
+ * @crtc: the CRTC @connector is attached to
+ *
+ * Add the MST topology state for @connector to @state.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int
+intel_dp_mst_add_topology_state_for_connector(struct intel_atomic_state *state,
+					      struct intel_connector *connector,
+					      struct intel_crtc *crtc)
+{
+	struct drm_dp_mst_topology_state *mst_state;
+
+	if (!connector->mst_port)
+		return 0;
+
+	mst_state = drm_atomic_get_mst_topology_state(&state->base,
+						      &connector->mst_port->mst_mgr);
+	if (IS_ERR(mst_state))
+		return PTR_ERR(mst_state);
+
+	mst_state->pending_crtc_mask |= drm_crtc_mask(&crtc->base);
+
+	return 0;
+}
+
+/**
+ * intel_dp_mst_add_topology_state_for_crtc - add MST topology state for a CRTC
+ * @state: atomic state
+ * @crtc: CRTC to add the state for
+ *
+ * Add the MST topology state for @crtc to @state.
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *state,
+					     struct intel_crtc *crtc)
+{
+	struct drm_connector *_connector;
+	struct drm_connector_state *conn_state;
+	int i;
+
+	for_each_new_connector_in_state(&state->base, _connector, conn_state, i) {
+		struct intel_connector *connector = to_intel_connector(_connector);
+		int ret;
+
+		if (conn_state->crtc != &crtc->base)
+			continue;
+
+		ret = intel_dp_mst_add_topology_state_for_connector(state, connector, crtc);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.h b/drivers/gpu/drm/i915/display/intel_dp_mst.h
index f7301de6cdfb..f1815bb72267 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.h
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.h
@@ -8,6 +8,8 @@
 
 #include <linux/types.h>
 
+struct intel_atomic_state;
+struct intel_crtc;
 struct intel_crtc_state;
 struct intel_digital_port;
 struct intel_dp;
@@ -18,5 +20,7 @@ int intel_dp_mst_encoder_active_links(struct intel_digital_port *dig_port);
 bool intel_dp_mst_is_master_trans(const struct intel_crtc_state *crtc_state);
 bool intel_dp_mst_is_slave_trans(const struct intel_crtc_state *crtc_state);
 bool intel_dp_mst_source_support(struct intel_dp *intel_dp);
+int intel_dp_mst_add_topology_state_for_crtc(struct intel_atomic_state *state,
+					     struct intel_crtc *crtc);
 
 #endif /* __INTEL_DP_MST_H__ */
diff --git a/drivers/gpu/drm/i915/display/intel_fbdev.c b/drivers/gpu/drm/i915/display/intel_fbdev.c
index 112aa0447a0d..9899b5dcd291 100644
--- a/drivers/gpu/drm/i915/display/intel_fbdev.c
+++ b/drivers/gpu/drm/i915/display/intel_fbdev.c
@@ -624,7 +624,13 @@ void intel_fbdev_set_suspend(struct drm_device *dev, int state, bool synchronous
 	struct intel_fbdev *ifbdev = dev_priv->display.fbdev.fbdev;
 	struct fb_info *info;
 
-	if (!ifbdev || !ifbdev->vma)
+	if (!ifbdev)
+		return;
+
+	if (drm_WARN_ON(&dev_priv->drm, !HAS_DISPLAY(dev_priv)))
+		return;
+
+	if (!ifbdev->vma)
 		goto set_suspend;
 
 	info = ifbdev->helper.fbdev;
diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index 64ca7d7a9673..b898f865fb87 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -296,9 +296,12 @@ int mma9551_read_config_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_NS(mma9551_read_config_word, IIO_MMA9551);
 
@@ -354,9 +357,12 @@ int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_NS(mma9551_read_status_word, IIO_MMA9551);
 
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 26d1772179b8..8730674ceb2e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -479,13 +479,20 @@ static int compare_netdev_and_ip(int ifindex_a, struct sockaddr *sa,
 	if (sa->sa_family != sb->sa_family)
 		return sa->sa_family - sb->sa_family;
 
-	if (sa->sa_family == AF_INET)
-		return memcmp((char *)&((struct sockaddr_in *)sa)->sin_addr,
-			      (char *)&((struct sockaddr_in *)sb)->sin_addr,
+	if (sa->sa_family == AF_INET &&
+	    __builtin_object_size(sa, 0) >= sizeof(struct sockaddr_in)) {
+		return memcmp(&((struct sockaddr_in *)sa)->sin_addr,
+			      &((struct sockaddr_in *)sb)->sin_addr,
 			      sizeof(((struct sockaddr_in *)sa)->sin_addr));
+	}
+
+	if (sa->sa_family == AF_INET6 &&
+	    __builtin_object_size(sa, 0) >= sizeof(struct sockaddr_in6)) {
+		return ipv6_addr_cmp(&((struct sockaddr_in6 *)sa)->sin6_addr,
+				     &((struct sockaddr_in6 *)sb)->sin6_addr);
+	}
 
-	return ipv6_addr_cmp(&((struct sockaddr_in6 *)sa)->sin6_addr,
-			     &((struct sockaddr_in6 *)sb)->sin6_addr);
+	return -1;
 }
 
 static int cma_add_id_to_tree(struct rdma_id_private *node_id_priv)
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index ebe970f76232..90b672feed83 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1056,7 +1056,7 @@ static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
 static void handle_temp_err(struct hfi1_devdata *dd);
 static void dc_shutdown(struct hfi1_devdata *dd);
 static void dc_start(struct hfi1_devdata *dd);
-static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+static int qos_rmt_entries(unsigned int n_krcv_queues, unsigned int *mp,
 			   unsigned int *np);
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd);
 static int wait_link_transfer_active(struct hfi1_devdata *dd, int wait_ms);
@@ -13362,7 +13362,6 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	int ret;
 	unsigned ngroups;
 	int rmt_count;
-	int user_rmt_reduced;
 	u32 n_usr_ctxts;
 	u32 send_contexts = chip_send_contexts(dd);
 	u32 rcv_contexts = chip_rcv_contexts(dd);
@@ -13421,28 +13420,34 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 					 (num_kernel_contexts + n_usr_ctxts),
 					 &node_affinity.real_cpu_mask);
 	/*
-	 * The RMT entries are currently allocated as shown below:
-	 * 1. QOS (0 to 128 entries);
-	 * 2. FECN (num_kernel_context - 1 + num_user_contexts +
-	 *    num_netdev_contexts);
-	 * 3. netdev (num_netdev_contexts).
-	 * It should be noted that FECN oversubscribe num_netdev_contexts
-	 * entries of RMT because both netdev and PSM could allocate any receive
-	 * context between dd->first_dyn_alloc_text and dd->num_rcv_contexts,
-	 * and PSM FECN must reserve an RMT entry for each possible PSM receive
-	 * context.
+	 * RMT entries are allocated as follows:
+	 * 1. QOS (0 to 128 entries)
+	 * 2. FECN (num_kernel_context - 1 [a] + num_user_contexts +
+	 *          num_netdev_contexts [b])
+	 * 3. netdev (NUM_NETDEV_MAP_ENTRIES)
+	 *
+	 * Notes:
+	 * [a] Kernel contexts (except control) are included in FECN if kernel
+	 *     TID_RDMA is active.
+	 * [b] Netdev and user contexts are randomly allocated from the same
+	 *     context pool, so FECN must cover all contexts in the pool.
 	 */
-	rmt_count = qos_rmt_entries(dd, NULL, NULL) + (num_netdev_contexts * 2);
-	if (HFI1_CAP_IS_KSET(TID_RDMA))
-		rmt_count += num_kernel_contexts - 1;
-	if (rmt_count + n_usr_ctxts > NUM_MAP_ENTRIES) {
-		user_rmt_reduced = NUM_MAP_ENTRIES - rmt_count;
-		dd_dev_err(dd,
-			   "RMT size is reducing the number of user receive contexts from %u to %d\n",
-			   n_usr_ctxts,
-			   user_rmt_reduced);
-		/* recalculate */
-		n_usr_ctxts = user_rmt_reduced;
+	rmt_count = qos_rmt_entries(num_kernel_contexts - 1, NULL, NULL)
+		    + (HFI1_CAP_IS_KSET(TID_RDMA) ? num_kernel_contexts - 1
+						  : 0)
+		    + n_usr_ctxts
+		    + num_netdev_contexts
+		    + NUM_NETDEV_MAP_ENTRIES;
+	if (rmt_count > NUM_MAP_ENTRIES) {
+		int over = rmt_count - NUM_MAP_ENTRIES;
+		/* try to squish user contexts, minimum of 1 */
+		if (over >= n_usr_ctxts) {
+			dd_dev_err(dd, "RMT overflow: reduce the requested number of contexts\n");
+			return -EINVAL;
+		}
+		dd_dev_err(dd, "RMT overflow: reducing # user contexts from %u to %u\n",
+			   n_usr_ctxts, n_usr_ctxts - over);
+		n_usr_ctxts -= over;
 	}
 
 	/* the first N are kernel contexts, the rest are user/netdev contexts */
@@ -14299,15 +14304,15 @@ static void clear_rsm_rule(struct hfi1_devdata *dd, u8 rule_index)
 }
 
 /* return the number of RSM map table entries that will be used for QOS */
-static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+static int qos_rmt_entries(unsigned int n_krcv_queues, unsigned int *mp,
 			   unsigned int *np)
 {
 	int i;
 	unsigned int m, n;
-	u8 max_by_vl = 0;
+	uint max_by_vl = 0;
 
 	/* is QOS active at all? */
-	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
+	if (n_krcv_queues < MIN_KERNEL_KCTXTS ||
 	    num_vls == 1 ||
 	    krcvqsset <= 1)
 		goto no_qos;
@@ -14365,7 +14370,7 @@ static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 
 	if (!rmt)
 		goto bail;
-	rmt_entries = qos_rmt_entries(dd, &m, &n);
+	rmt_entries = qos_rmt_entries(dd->n_krcv_queues - 1, &m, &n);
 	if (rmt_entries == 0)
 		goto bail;
 	qpns_per_vl = 1 << m;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 968e5e6668b2..20adb9b323d8 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1712,27 +1712,29 @@ static int pdev_pri_ats_enable(struct pci_dev *pdev)
 	/* Only allow access to user-accessible pages */
 	ret = pci_enable_pasid(pdev, 0);
 	if (ret)
-		goto out_err;
+		return ret;
 
 	/* First reset the PRI state of the device */
 	ret = pci_reset_pri(pdev);
 	if (ret)
-		goto out_err;
+		goto out_err_pasid;
 
 	/* Enable PRI */
 	/* FIXME: Hardcode number of outstanding requests for now */
 	ret = pci_enable_pri(pdev, 32);
 	if (ret)
-		goto out_err;
+		goto out_err_pasid;
 
 	ret = pci_enable_ats(pdev, PAGE_SHIFT);
 	if (ret)
-		goto out_err;
+		goto out_err_pri;
 
 	return 0;
 
-out_err:
+out_err_pri:
 	pci_disable_pri(pdev);
+
+out_err_pasid:
 	pci_disable_pasid(pdev);
 
 	return ret;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index fd8c8aeb3c50..bfb2f163c691 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2089,8 +2089,22 @@ static int __iommu_attach_group(struct iommu_domain *domain,
 
 	ret = __iommu_group_for_each_dev(group, domain,
 					 iommu_group_do_attach_device);
-	if (ret == 0)
+	if (ret == 0) {
 		group->domain = domain;
+	} else {
+		/*
+		 * To recover from the case when certain device within the
+		 * group fails to attach to the new domain, we need force
+		 * attaching all devices back to the old domain. The old
+		 * domain is compatible for all devices in the group,
+		 * hence the iommu driver should always return success.
+		 */
+		struct iommu_domain *old_domain = group->domain;
+
+		group->domain = NULL;
+		WARN(__iommu_group_set_domain(group, old_domain),
+		     "iommu driver failed to attach a compatible domain");
+	}
 
 	return ret;
 }
diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 44b0cfb8ee1c..067b43a1cb3e 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
@@ -1509,6 +1510,10 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	/* The barrier is needed to synchronize with uvc_status_stop(). */
+	if (smp_load_acquire(&dev->flush_status))
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index abfe735f6ea3..a9cdef07e6b1 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -252,14 +252,10 @@ static int uvc_parse_format(struct uvc_device *dev,
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
 
 		if (fmtdesc != NULL) {
-			strscpy(format->name, fmtdesc->name,
-				sizeof(format->name));
 			format->fcc = fmtdesc->fcc;
 		} else {
 			dev_info(&streaming->intf->dev,
 				 "Unknown video format %pUl\n", &buffer[5]);
-			snprintf(format->name, sizeof(format->name), "%pUl\n",
-				&buffer[5]);
 			format->fcc = 0;
 		}
 
@@ -271,8 +267,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 		 */
 		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
 			if (format->fcc == V4L2_PIX_FMT_YUYV) {
-				strscpy(format->name, "Greyscale 8-bit (Y8  )",
-					sizeof(format->name));
 				format->fcc = V4L2_PIX_FMT_GREY;
 				format->bpp = 8;
 				width_multiplier = 2;
@@ -313,7 +307,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strscpy(format->name, "MJPEG", sizeof(format->name));
 		format->fcc = V4L2_PIX_FMT_MJPEG;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		format->bpp = 0;
@@ -329,17 +322,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		switch (buffer[8] & 0x7f) {
-		case 0:
-			strscpy(format->name, "SD-DV", sizeof(format->name));
-			break;
-		case 1:
-			strscpy(format->name, "SDL-DV", sizeof(format->name));
-			break;
-		case 2:
-			strscpy(format->name, "HD-DV", sizeof(format->name));
-			break;
-		default:
+		if ((buffer[8] & 0x7f) > 2) {
 			uvc_dbg(dev, DESCR,
 				"device %d videostreaming interface %d: unknown DV format %u\n",
 				dev->udev->devnum,
@@ -347,9 +330,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
-			sizeof(format->name));
-
 		format->fcc = V4L2_PIX_FMT_DV;
 		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
 		format->bpp = 0;
@@ -376,7 +356,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	uvc_dbg(dev, DESCR, "Found format %s\n", format->name);
+	uvc_dbg(dev, DESCR, "Found format %p4cc", &format->fcc);
 
 	buflen -= buffer[0];
 	buffer += buffer[0];
@@ -880,10 +860,8 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 					       + n;
 		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
 
-		if (buffer[24+p+2*n] != 0)
-			usb_string(udev, buffer[24+p+2*n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[24+p+2*n] == 0 ||
+		    usb_string(udev, buffer[24+p+2*n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1007,15 +985,15 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
 		}
 
-		if (buffer[7] != 0)
-			usb_string(udev, buffer[7], term->name,
-				   sizeof(term->name));
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
-			sprintf(term->name, "Camera %u", buffer[3]);
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
-			sprintf(term->name, "Media %u", buffer[3]);
-		else
-			sprintf(term->name, "Input %u", buffer[3]);
+		if (buffer[7] == 0 ||
+		    usb_string(udev, buffer[7], term->name, sizeof(term->name)) < 0) {
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
+				sprintf(term->name, "Camera %u", buffer[3]);
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
+				sprintf(term->name, "Media %u", buffer[3]);
+			else
+				sprintf(term->name, "Input %u", buffer[3]);
+		}
 
 		list_add_tail(&term->list, &dev->entities);
 		break;
@@ -1048,10 +1026,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(term->baSourceID, &buffer[7], 1);
 
-		if (buffer[8] != 0)
-			usb_string(udev, buffer[8], term->name,
-				   sizeof(term->name));
-		else
+		if (buffer[8] == 0 ||
+		    usb_string(udev, buffer[8], term->name, sizeof(term->name)) < 0)
 			sprintf(term->name, "Output %u", buffer[3]);
 
 		list_add_tail(&term->list, &dev->entities);
@@ -1073,10 +1049,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
-		if (buffer[5+p] != 0)
-			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[5+p] == 0 ||
+		    usb_string(udev, buffer[5+p], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1106,10 +1080,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		if (dev->uvc_version >= 0x0110)
 			unit->processing.bmVideoStandards = buffer[9+n];
 
-		if (buffer[8+n] != 0)
-			usb_string(udev, buffer[8+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[8+n] == 0 ||
+		    usb_string(udev, buffer[8+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Processing %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1137,10 +1109,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->extension.bmControls = (u8 *)unit + sizeof(*unit);
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
-		if (buffer[23+p+n] != 0)
-			usb_string(udev, buffer[23+p+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[23+p+n] == 0 ||
+		    usb_string(udev, buffer[23+p+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -2483,6 +2453,24 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
+	/* Logitech, Webcam C910 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0821,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_WAKE_AUTOSUSPEND)},
+	/* Logitech, Webcam B910 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0823,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_WAKE_AUTOSUSPEND)},
 	/* Logitech Quickcam Fusion */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 7c4d2f93d351..cc68dd24eb42 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -37,7 +37,7 @@ static int uvc_mc_create_links(struct uvc_video_chain *chain,
 			continue;
 
 		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
-		if (remote == NULL)
+		if (remote == NULL || remote->num_pads == 0)
 			return -EINVAL;
 
 		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 7518ffce22ed..4a92c989cf33 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -309,5 +310,41 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	/*
+	 * Prevent the asynchronous control handler from requeing the URB. The
+	 * barrier is needed so the flush_status change is visible to other
+	 * CPUs running the asynchronous handler before usb_kill_urb() is
+	 * called below.
+	 */
+	smp_store_release(&dev->flush_status, true);
+
+	/*
+	 * Cancel any pending asynchronous work. If any status event was queued,
+	 * process it synchronously.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/* Kill the urb. */
 	usb_kill_urb(dev->int_urb);
+
+	/*
+	 * The URB completion handler may have queued asynchronous work. This
+	 * won't resubmit the URB as flush_status is set, but it needs to be
+	 * cancelled before returning or it could then race with a future
+	 * uvc_status_start() call.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/*
+	 * From this point, there are no events on the queue and the status URB
+	 * is dead. No events will be queued until uvc_status_start() is called.
+	 * The barrier is needed to make sure that flush_status is visible to
+	 * uvc_ctrl_status_event_work() when uvc_status_start() will be called
+	 * again.
+	 */
+	smp_store_release(&dev->flush_status, false);
 }
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 0774a11360c0..950b42d78a10 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -661,8 +661,6 @@ static int uvc_ioctl_enum_fmt(struct uvc_streaming *stream,
 	fmt->flags = 0;
 	if (format->flags & UVC_FMT_FLAG_COMPRESSED)
 		fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-	strscpy(fmt->description, format->name, sizeof(fmt->description));
-	fmt->description[sizeof(fmt->description) - 1] = 0;
 	fmt->pixelformat = format->fcc;
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index d2eb9066e4dc..0d3a3b697b2d 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1352,7 +1352,9 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
 	if (has_scr)
 		memcpy(stream->clock.last_scr, scr, 6);
 
-	memcpy(&meta->length, mem, length);
+	meta->length = mem[0];
+	meta->flags  = mem[1];
+	memcpy(meta->buf, &mem[2], length - 2);
 	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
 
 	uvc_dbg(stream->dev, FRAME,
@@ -1965,6 +1967,17 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
 			"Selecting alternate setting %u (%u B/frame bandwidth)\n",
 			altsetting, best_psize);
 
+		/*
+		 * Some devices, namely the Logitech C910 and B910, are unable
+		 * to recover from a USB autosuspend, unless the alternate
+		 * setting of the streaming interface is toggled.
+		 */
+		if (stream->dev->quirks & UVC_QUIRK_WAKE_AUTOSUSPEND) {
+			usb_set_interface(stream->dev->udev, intfnum,
+					  altsetting);
+			usb_set_interface(stream->dev->udev, intfnum, 0);
+		}
+
 		ret = usb_set_interface(stream->dev->udev, intfnum, altsetting);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 1227ae63f85b..33e7475d4e64 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -74,6 +74,7 @@
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
 #define UVC_QUIRK_FORCE_BPP		0x00001000
+#define UVC_QUIRK_WAKE_AUTOSUSPEND	0x00002000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -264,8 +265,6 @@ struct uvc_format {
 	u32 fcc;
 	u32 flags;
 
-	char name[32];
-
 	unsigned int nframes;
 	struct uvc_frame *frame;
 };
@@ -559,6 +558,7 @@ struct uvc_device {
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
+	bool flush_status;
 	u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 61c288d40375..7343dbb79c9f 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -162,14 +162,36 @@ static const struct regmap_access_table rpcif_volatile_table = {
 	.n_yes_ranges	= ARRAY_SIZE(rpcif_volatile_ranges),
 };
 
+struct rpcif_priv {
+	struct device *dev;
+	void __iomem *base;
+	void __iomem *dirmap;
+	struct regmap *regmap;
+	struct reset_control *rstc;
+	struct platform_device *vdev;
+	size_t size;
+	enum rpcif_type type;
+	enum rpcif_data_dir dir;
+	u8 bus_size;
+	u8 xfer_size;
+	void *buffer;
+	u32 xferlen;
+	u32 smcr;
+	u32 smadr;
+	u32 command;		/* DRCMR or SMCMR */
+	u32 option;		/* DROPR or SMOPR */
+	u32 enable;		/* DRENR or SMENR */
+	u32 dummy;		/* DRDMCR or SMDMCR */
+	u32 ddr;		/* DRDRENR or SMDRENR */
+};
 
 /*
  * Custom accessor functions to ensure SM[RW]DR[01] are always accessed with
- * proper width.  Requires rpcif.xfer_size to be correctly set before!
+ * proper width.  Requires rpcif_priv.xfer_size to be correctly set before!
  */
 static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 {
-	struct rpcif *rpc = context;
+	struct rpcif_priv *rpc = context;
 
 	switch (reg) {
 	case RPCIF_SMRDR0:
@@ -205,7 +227,7 @@ static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 
 static int rpcif_reg_write(void *context, unsigned int reg, unsigned int val)
 {
-	struct rpcif *rpc = context;
+	struct rpcif_priv *rpc = context;
 
 	switch (reg) {
 	case RPCIF_SMWDR0:
@@ -252,39 +274,18 @@ static const struct regmap_config rpcif_regmap_config = {
 	.volatile_table	= &rpcif_volatile_table,
 };
 
-int rpcif_sw_init(struct rpcif *rpc, struct device *dev)
+int rpcif_sw_init(struct rpcif *rpcif, struct device *dev)
 {
-	struct platform_device *pdev = to_platform_device(dev);
-	struct resource *res;
+	struct rpcif_priv *rpc = dev_get_drvdata(dev);
 
-	rpc->dev = dev;
-
-	rpc->base = devm_platform_ioremap_resource_byname(pdev, "regs");
-	if (IS_ERR(rpc->base))
-		return PTR_ERR(rpc->base);
-
-	rpc->regmap = devm_regmap_init(&pdev->dev, NULL, rpc, &rpcif_regmap_config);
-	if (IS_ERR(rpc->regmap)) {
-		dev_err(&pdev->dev,
-			"failed to init regmap for rpcif, error %ld\n",
-			PTR_ERR(rpc->regmap));
-		return	PTR_ERR(rpc->regmap);
-	}
-
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
-	rpc->dirmap = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(rpc->dirmap))
-		return PTR_ERR(rpc->dirmap);
-	rpc->size = resource_size(res);
-
-	rpc->type = (uintptr_t)of_device_get_match_data(dev);
-	rpc->rstc = devm_reset_control_get_exclusive(&pdev->dev, NULL);
-
-	return PTR_ERR_OR_ZERO(rpc->rstc);
+	rpcif->dev = dev;
+	rpcif->dirmap = rpc->dirmap;
+	rpcif->size = rpc->size;
+	return 0;
 }
 EXPORT_SYMBOL(rpcif_sw_init);
 
-static void rpcif_rzg2l_timing_adjust_sdr(struct rpcif *rpc)
+static void rpcif_rzg2l_timing_adjust_sdr(struct rpcif_priv *rpc)
 {
 	regmap_write(rpc->regmap, RPCIF_PHYWR, 0xa5390000);
 	regmap_write(rpc->regmap, RPCIF_PHYADD, 0x80000000);
@@ -298,8 +299,9 @@ static void rpcif_rzg2l_timing_adjust_sdr(struct rpcif *rpc)
 	regmap_write(rpc->regmap, RPCIF_PHYADD, 0x80000032);
 }
 
-int rpcif_hw_init(struct rpcif *rpc, bool hyperflash)
+int rpcif_hw_init(struct rpcif *rpcif, bool hyperflash)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	u32 dummy;
 
 	pm_runtime_get_sync(rpc->dev);
@@ -360,7 +362,7 @@ int rpcif_hw_init(struct rpcif *rpc, bool hyperflash)
 }
 EXPORT_SYMBOL(rpcif_hw_init);
 
-static int wait_msg_xfer_end(struct rpcif *rpc)
+static int wait_msg_xfer_end(struct rpcif_priv *rpc)
 {
 	u32 sts;
 
@@ -369,7 +371,7 @@ static int wait_msg_xfer_end(struct rpcif *rpc)
 					USEC_PER_SEC);
 }
 
-static u8 rpcif_bits_set(struct rpcif *rpc, u32 nbytes)
+static u8 rpcif_bits_set(struct rpcif_priv *rpc, u32 nbytes)
 {
 	if (rpc->bus_size == 2)
 		nbytes /= 2;
@@ -382,9 +384,11 @@ static u8 rpcif_bit_size(u8 buswidth)
 	return buswidth > 4 ? 2 : ilog2(buswidth);
 }
 
-void rpcif_prepare(struct rpcif *rpc, const struct rpcif_op *op, u64 *offs,
+void rpcif_prepare(struct rpcif *rpcif, const struct rpcif_op *op, u64 *offs,
 		   size_t *len)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
+
 	rpc->smcr = 0;
 	rpc->smadr = 0;
 	rpc->enable = 0;
@@ -468,8 +472,9 @@ void rpcif_prepare(struct rpcif *rpc, const struct rpcif_op *op, u64 *offs,
 }
 EXPORT_SYMBOL(rpcif_prepare);
 
-int rpcif_manual_xfer(struct rpcif *rpc)
+int rpcif_manual_xfer(struct rpcif *rpcif)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	u32 smenr, smcr, pos = 0, max = rpc->bus_size == 2 ? 8 : 4;
 	int ret = 0;
 
@@ -589,7 +594,7 @@ int rpcif_manual_xfer(struct rpcif *rpc)
 err_out:
 	if (reset_control_reset(rpc->rstc))
 		dev_err(rpc->dev, "Failed to reset HW\n");
-	rpcif_hw_init(rpc, rpc->bus_size == 2);
+	rpcif_hw_init(rpcif, rpc->bus_size == 2);
 	goto exit;
 }
 EXPORT_SYMBOL(rpcif_manual_xfer);
@@ -636,8 +641,9 @@ static void memcpy_fromio_readw(void *to,
 	}
 }
 
-ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
+ssize_t rpcif_dirmap_read(struct rpcif *rpcif, u64 offs, size_t len, void *buf)
 {
+	struct rpcif_priv *rpc = dev_get_drvdata(rpcif->dev);
 	loff_t from = offs & (rpc->size - 1);
 	size_t size = rpc->size - from;
 
@@ -670,8 +676,11 @@ EXPORT_SYMBOL(rpcif_dirmap_read);
 
 static int rpcif_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct platform_device *vdev;
 	struct device_node *flash;
+	struct rpcif_priv *rpc;
+	struct resource *res;
 	const char *name;
 	int ret;
 
@@ -692,11 +701,40 @@ static int rpcif_probe(struct platform_device *pdev)
 	}
 	of_node_put(flash);
 
+	rpc = devm_kzalloc(&pdev->dev, sizeof(*rpc), GFP_KERNEL);
+	if (!rpc)
+		return -ENOMEM;
+
+	rpc->base = devm_platform_ioremap_resource_byname(pdev, "regs");
+	if (IS_ERR(rpc->base))
+		return PTR_ERR(rpc->base);
+
+	rpc->regmap = devm_regmap_init(dev, NULL, rpc, &rpcif_regmap_config);
+	if (IS_ERR(rpc->regmap)) {
+		dev_err(dev, "failed to init regmap for rpcif, error %ld\n",
+			PTR_ERR(rpc->regmap));
+		return	PTR_ERR(rpc->regmap);
+	}
+
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "dirmap");
+	rpc->dirmap = devm_ioremap_resource(dev, res);
+	if (IS_ERR(rpc->dirmap))
+		return PTR_ERR(rpc->dirmap);
+	rpc->size = resource_size(res);
+
+	rpc->type = (uintptr_t)of_device_get_match_data(dev);
+	rpc->rstc = devm_reset_control_get_exclusive(dev, NULL);
+	if (IS_ERR(rpc->rstc))
+		return PTR_ERR(rpc->rstc);
+
 	vdev = platform_device_alloc(name, pdev->id);
 	if (!vdev)
 		return -ENOMEM;
 	vdev->dev.parent = &pdev->dev;
-	platform_set_drvdata(pdev, vdev);
+
+	rpc->dev = &pdev->dev;
+	rpc->vdev = vdev;
+	platform_set_drvdata(pdev, rpc);
 
 	ret = platform_device_add(vdev);
 	if (ret) {
@@ -709,9 +747,9 @@ static int rpcif_probe(struct platform_device *pdev)
 
 static int rpcif_remove(struct platform_device *pdev)
 {
-	struct platform_device *vdev = platform_get_drvdata(pdev);
+	struct rpcif_priv *rpc = platform_get_drvdata(pdev);
 
-	platform_device_unregister(vdev);
+	platform_device_unregister(rpc->vdev);
 
 	return 0;
 }
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index cbf1dd90b70d..b1c53e040771 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -45,7 +45,7 @@ int arizona_clk32k_enable(struct arizona *arizona)
 	if (arizona->clk32k_ref == 1) {
 		switch (arizona->pdata.clk32k_src) {
 		case ARIZONA_32KZ_MCLK1:
-			ret = pm_runtime_get_sync(arizona->dev);
+			ret = pm_runtime_resume_and_get(arizona->dev);
 			if (ret != 0)
 				goto err_ref;
 			ret = clk_prepare_enable(arizona->mclk[ARIZONA_MCLK1]);
diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index 71fbf0bc8453..5eeb4d04c096 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -151,7 +151,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 	ret = __mei_cl_send(cldev->cl, (u8 *)&req, sizeof(req), 0,
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd\n");
+		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -163,7 +163,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 		 * Should be at least one version block,
 		 * error out if nothing found
 		 */
-		dev_err(&cldev->dev, "Could not read FW version\n");
+		dev_err(&cldev->dev, "Could not read FW version ret = %d\n", bytes_recv);
 		return -EIO;
 	}
 
@@ -376,7 +376,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	ret = __mei_cl_send(cl, (u8 *)&cmd, sizeof(cmd), 0,
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(bus->dev, "Could not send IF version cmd\n");
+		dev_err(bus->dev, "Could not send IF version cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -391,7 +391,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length, &vtag,
 				   0, 0);
 	if (bytes_recv < 0 || (size_t)bytes_recv < if_version_length) {
-		dev_err(bus->dev, "Could not read IF version\n");
+		dev_err(bus->dev, "Could not read IF version ret = %d\n", bytes_recv);
 		ret = -EIO;
 		goto err;
 	}
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 61a2be712bf7..9ce9b9e0e9b6 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1709,7 +1709,7 @@ static void __init vmballoon_debugfs_init(struct vmballoon *b)
 static void __exit vmballoon_debugfs_exit(struct vmballoon *b)
 {
 	static_key_disable(&balloon_stat_enabled.key);
-	debugfs_remove(debugfs_lookup("vmmemctl", NULL));
+	debugfs_lookup_and_remove("vmmemctl", NULL);
 	kfree(b->stats);
 	b->stats = NULL;
 }
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index a901f8edfa41..7f65af169751 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -468,6 +468,7 @@ static int uif_init(struct ubi_device *ubi)
 			err = ubi_add_volume(ubi, ubi->volumes[i]);
 			if (err) {
 				ubi_err(ubi, "cannot add volume %d", i);
+				ubi->volumes[i] = NULL;
 				goto out_volumes;
 			}
 		}
@@ -663,6 +664,12 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
 	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);
 
+	if (ubi->vid_hdr_offset && ((ubi->vid_hdr_offset + UBI_VID_HDR_SIZE) >
+	    ubi->vid_hdr_alsize)) {
+		ubi_err(ubi, "VID header offset %d too large.", ubi->vid_hdr_offset);
+		return -EINVAL;
+	}
+
 	dbg_gen("min_io_size      %d", ubi->min_io_size);
 	dbg_gen("max_write_size   %d", ubi->max_write_size);
 	dbg_gen("hdrs_min_io_size %d", ubi->hdrs_min_io_size);
diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 0ee452275578..863f571f1adb 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -146,13 +146,15 @@ void ubi_refill_pools(struct ubi_device *ubi)
 	if (ubi->fm_anchor) {
 		wl_tree_add(ubi->fm_anchor, &ubi->free);
 		ubi->free_count++;
+		ubi->fm_anchor = NULL;
 	}
 
-	/*
-	 * All available PEBs are in ubi->free, now is the time to get
-	 * the best anchor PEBs.
-	 */
-	ubi->fm_anchor = ubi_wl_get_fm_peb(ubi, 1);
+	if (!ubi->fm_disabled)
+		/*
+		 * All available PEBs are in ubi->free, now is the time to get
+		 * the best anchor PEBs.
+		 */
+		ubi->fm_anchor = ubi_wl_get_fm_peb(ubi, 1);
 
 	for (;;) {
 		enough = 0;
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 8fcc0bdf0635..2c867d16f89f 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -464,7 +464,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		for (i = 0; i < -pebs; i++) {
 			err = ubi_eba_unmap_leb(ubi, vol, reserved_pebs + i);
 			if (err)
-				goto out_acc;
+				goto out_free;
 		}
 		spin_lock(&ubi->volumes_lock);
 		ubi->rsvd_pebs += pebs;
@@ -512,8 +512,10 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		ubi->avail_pebs += pebs;
 		spin_unlock(&ubi->volumes_lock);
 	}
+	return err;
+
 out_free:
-	kfree(new_eba_tbl);
+	ubi_eba_destroy_table(new_eba_tbl);
 	return err;
 }
 
@@ -580,6 +582,7 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	if (err) {
 		ubi_err(ubi, "cannot add character device for volume %d, error %d",
 			vol_id, err);
+		vol_release(&vol->dev);
 		return err;
 	}
 
@@ -590,15 +593,14 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	vol->dev.groups = volume_dev_groups;
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
 	err = device_register(&vol->dev);
-	if (err)
-		goto out_cdev;
+	if (err) {
+		cdev_del(&vol->cdev);
+		put_device(&vol->dev);
+		return err;
+	}
 
 	self_check_volumes(ubi);
 	return err;
-
-out_cdev:
-	cdev_del(&vol->cdev);
-	return err;
 }
 
 /**
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 68eb0f21b3fe..9e14319225c9 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -890,8 +890,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
-		if (e2)
+		if (e2) {
+			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e2);
+			spin_unlock(&ubi->wl_lock);
+		}
 		goto out_ro;
 	}
 
@@ -973,11 +976,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	spin_lock(&ubi->wl_lock);
 	ubi->move_from = ubi->move_to = NULL;
 	ubi->move_to_put = ubi->wl_scheduled = 0;
+	wl_entry_destroy(ubi, e1);
+	wl_entry_destroy(ubi, e2);
 	spin_unlock(&ubi->wl_lock);
 
 	ubi_free_vid_buf(vidb);
-	wl_entry_destroy(ubi, e1);
-	wl_entry_destroy(ubi, e2);
 
 out_ro:
 	ubi_ro_mode(ubi);
@@ -1130,14 +1133,18 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		/* Re-schedule the LEB for erasure */
 		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
 		if (err1) {
+			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
+			spin_unlock(&ubi->wl_lock);
 			err = err1;
 			goto out_ro;
 		}
 		return err;
 	}
 
+	spin_lock(&ubi->wl_lock);
 	wl_entry_destroy(ubi, e);
+	spin_unlock(&ubi->wl_lock);
 	if (err != -EIO)
 		/*
 		 * If this is not %-EIO, we have no idea what to do. Scheduling
@@ -1253,6 +1260,18 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 retry:
 	spin_lock(&ubi->wl_lock);
 	e = ubi->lookuptbl[pnum];
+	if (!e) {
+		/*
+		 * This wl entry has been removed for some errors by other
+		 * process (eg. wear leveling worker), corresponding process
+		 * (except __erase_worker, which cannot concurrent with
+		 * ubi_wl_put_peb) will set ubi ro_mode at the same time,
+		 * just ignore this wl entry.
+		 */
+		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_protect);
+		return 0;
+	}
 	if (e == ubi->move_from) {
 		/*
 		 * User is putting the physical eraseblock which was selected to
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 26a35ae322d1..cc89cff029e1 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -513,7 +513,7 @@ static const char * const vsc9959_resource_names[TARGET_MAX] = {
  * SGMII/QSGMII MAC PCS can be found.
  */
 static const struct resource vsc9959_imdio_res =
-	DEFINE_RES_MEM_NAMED(0x8030, 0x8040, "imdio");
+	DEFINE_RES_MEM_NAMED(0x8030, 0x10, "imdio");
 
 static const struct reg_field vsc9959_regfields[REGFIELD_MAX] = {
 	[ANA_ADVLEARN_VLAN_CHK] = REG_FIELD(ANA_ADVLEARN, 6, 6),
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 7af33b2c685d..c2863d6d870f 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -923,8 +923,8 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	rc = mscc_miim_setup(dev, &bus, "VSC9953 internal MDIO bus",
 			     ocelot->targets[GCB],
-			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK]);
-
+			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
+			     true);
 	if (rc) {
 		dev_err(dev, "failed to setup MDIO bus\n");
 		return rc;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 709fc0114fbd..0f7345a96965 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -765,7 +765,7 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 
 		/* NPC profile doesn't extract AH/ESP header fields */
 		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
-		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
+		    (ah_esp_mask->tclass & ah_esp_hdr->tclass))
 			return -EOPNOTSUPP;
 
 		if (flow_type == AH_V6_FLOW)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index ef10aef3cda0..7045fedfd73a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -10,6 +10,7 @@
 #include <net/tso.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <net/ip6_checksum.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -699,7 +700,7 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 
 static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
 			     int alg, u64 iova, int ptp_offset,
-			     u64 base_ns, int udp_csum)
+			     u64 base_ns, bool udp_csum_crt)
 {
 	struct nix_sqe_mem_s *mem;
 
@@ -711,7 +712,7 @@ static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
 
 	if (ptp_offset) {
 		mem->start_offset = ptp_offset;
-		mem->udp_csum_crt = udp_csum;
+		mem->udp_csum_crt = !!udp_csum_crt;
 		mem->base_ns = base_ns;
 		mem->step_type = 1;
 	}
@@ -986,10 +987,11 @@ static bool otx2_validate_network_transport(struct sk_buff *skb)
 	return false;
 }
 
-static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_csum)
+static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, bool *udp_csum_crt)
 {
 	struct ethhdr *eth = (struct ethhdr *)(skb->data);
 	u16 nix_offload_hlen = 0, inner_vhlen = 0;
+	bool udp_hdr_present = false, is_sync;
 	u8 *data = skb->data, *msgtype;
 	__be16 proto = eth->h_proto;
 	int network_depth = 0;
@@ -1029,45 +1031,81 @@ static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_csum)
 		if (!otx2_validate_network_transport(skb))
 			return false;
 
-		*udp_csum = 1;
 		*offset = nix_offload_hlen + skb_transport_offset(skb) +
 			  sizeof(struct udphdr);
+		udp_hdr_present = true;
+
 	}
 
 	msgtype = data + *offset;
-
 	/* Check PTP messageId is SYNC or not */
-	return (*msgtype & 0xf) == 0;
+	is_sync = !(*msgtype & 0xf);
+	if (is_sync)
+		*udp_csum_crt = udp_hdr_present;
+	else
+		*offset = 0;
+
+	return is_sync;
 }
 
 static void otx2_set_txtstamp(struct otx2_nic *pfvf, struct sk_buff *skb,
 			      struct otx2_snd_queue *sq, int *offset)
 {
+	struct ethhdr	*eth = (struct ethhdr *)(skb->data);
 	struct ptpv2_tstamp *origin_tstamp;
-	int ptp_offset = 0, udp_csum = 0;
+	bool udp_csum_crt = false;
+	unsigned int udphoff;
 	struct timespec64 ts;
+	int ptp_offset = 0;
+	__wsum skb_csum;
 	u64 iova;
 
 	if (unlikely(!skb_shinfo(skb)->gso_size &&
 		     (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))) {
-		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC)) {
-			if (otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum)) {
-				origin_tstamp = (struct ptpv2_tstamp *)
-						((u8 *)skb->data + ptp_offset +
-						 PTP_SYNC_SEC_OFFSET);
-				ts = ns_to_timespec64(pfvf->ptp->tstamp);
-				origin_tstamp->seconds_msb = htons((ts.tv_sec >> 32) & 0xffff);
-				origin_tstamp->seconds_lsb = htonl(ts.tv_sec & 0xffffffff);
-				origin_tstamp->nanoseconds = htonl(ts.tv_nsec);
-				/* Point to correction field in PTP packet */
-				ptp_offset += 8;
+		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC &&
+			     otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum_crt))) {
+			origin_tstamp = (struct ptpv2_tstamp *)
+					((u8 *)skb->data + ptp_offset +
+					 PTP_SYNC_SEC_OFFSET);
+			ts = ns_to_timespec64(pfvf->ptp->tstamp);
+			origin_tstamp->seconds_msb = htons((ts.tv_sec >> 32) & 0xffff);
+			origin_tstamp->seconds_lsb = htonl(ts.tv_sec & 0xffffffff);
+			origin_tstamp->nanoseconds = htonl(ts.tv_nsec);
+			/* Point to correction field in PTP packet */
+			ptp_offset += 8;
+
+			/* When user disables hw checksum, stack calculates the csum,
+			 * but it does not cover ptp timestamp which is added later.
+			 * Recalculate the checksum manually considering the timestamp.
+			 */
+			if (udp_csum_crt) {
+				struct udphdr *uh = udp_hdr(skb);
+
+				if (skb->ip_summed != CHECKSUM_PARTIAL && uh->check != 0) {
+					udphoff = skb_transport_offset(skb);
+					uh->check = 0;
+					skb_csum = skb_checksum(skb, udphoff, skb->len - udphoff,
+								0);
+					if (ntohs(eth->h_proto) == ETH_P_IPV6)
+						uh->check = csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+									    &ipv6_hdr(skb)->daddr,
+									    skb->len - udphoff,
+									    ipv6_hdr(skb)->nexthdr,
+									    skb_csum);
+					else
+						uh->check = csum_tcpudp_magic(ip_hdr(skb)->saddr,
+									      ip_hdr(skb)->daddr,
+									      skb->len - udphoff,
+									      IPPROTO_UDP,
+									      skb_csum);
+				}
 			}
 		} else {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		}
 		iova = sq->timestamps->iova + (sq->head * sizeof(u64));
 		otx2_sqe_add_mem(sq, offset, NIX_SENDMEMALG_E_SETTSTMP, iova,
-				 ptp_offset, pfvf->ptp->base_ns, udp_csum);
+				 ptp_offset, pfvf->ptp->base_ns, udp_csum_crt);
 	} else {
 		skb_tx_timestamp(skb);
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index cdc87ecae5d3..d000236ddbac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -90,4 +90,8 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_HOST_PF]);
 	if (err)
 		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n", err);
+
+	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]);
+	if (err)
+		mlx5_core_warn(dev, "Timeout reclaiming external host VFs pages err(%d)\n", err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 8469e9c38670..ae75e230170b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -86,7 +86,19 @@ static bool mlx5e_ptp_ts_cqe_drop(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb
 	return (ptpsq->ts_cqe_ctr_mask && (skb_cc != skb_id));
 }
 
-static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc, u16 skb_id)
+static bool mlx5e_ptp_ts_cqe_ooo(struct mlx5e_ptpsq *ptpsq, u16 skb_id)
+{
+	u16 skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
+	u16 skb_pc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_pc);
+
+	if (PTP_WQE_CTR2IDX(skb_id - skb_cc) >= PTP_WQE_CTR2IDX(skb_pc - skb_cc))
+		return true;
+
+	return false;
+}
+
+static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_cc,
+					     u16 skb_id, int budget)
 {
 	struct skb_shared_hwtstamps hwts = {};
 	struct sk_buff *skb;
@@ -98,6 +110,7 @@ static void mlx5e_ptp_skb_fifo_ts_cqe_resync(struct mlx5e_ptpsq *ptpsq, u16 skb_
 		hwts.hwtstamp = mlx5e_skb_cb_get_hwts(skb)->cqe_hwtstamp;
 		skb_tstamp_tx(skb, &hwts);
 		ptpsq->cq_stats->resync_cqe++;
+		napi_consume_skb(skb, budget);
 		skb_cc = PTP_WQE_CTR2IDX(ptpsq->skb_fifo_cc);
 	}
 }
@@ -118,8 +131,14 @@ static void mlx5e_ptp_handle_ts_cqe(struct mlx5e_ptpsq *ptpsq,
 		goto out;
 	}
 
-	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id))
-		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id);
+	if (mlx5e_ptp_ts_cqe_drop(ptpsq, skb_cc, skb_id)) {
+		if (mlx5e_ptp_ts_cqe_ooo(ptpsq, skb_id)) {
+			/* already handled by a previous resync */
+			ptpsq->cq_stats->ooo_cqe_drop++;
+			return;
+		}
+		mlx5e_ptp_skb_fifo_ts_cqe_resync(ptpsq, skb_cc, skb_id, budget);
+	}
 
 	skb = mlx5e_skb_fifo_pop(&ptpsq->skb_fifo);
 	hwtstamp = mlx5e_cqe_ts_to_ns(sq->ptp_cyc2time, sq->clock, get_cqe_ts(cqe));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index 853f312cd757..1b3a65325ece 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -81,7 +81,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq);
 static inline bool
 mlx5e_skb_fifo_has_room(struct mlx5e_skb_fifo *fifo)
 {
-	return (*fifo->pc - *fifo->cc) < fifo->mask;
+	return (u16)(*fifo->pc - *fifo->cc) < fifo->mask;
 }
 
 static inline bool
@@ -297,6 +297,8 @@ void mlx5e_skb_fifo_push(struct mlx5e_skb_fifo *fifo, struct sk_buff *skb)
 static inline
 struct sk_buff *mlx5e_skb_fifo_pop(struct mlx5e_skb_fifo *fifo)
 {
+	WARN_ON_ONCE(*fifo->pc == *fifo->cc);
+
 	return *mlx5e_skb_fifo_get(fifo, (*fifo->cc)++);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 03c1841970f1..f7f54550a8bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -2121,6 +2121,7 @@ static const struct counter_desc ptp_cq_stats_desc[] = {
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, abort_abs_diff_ns) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_cqe) },
 	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, resync_event) },
+	{ MLX5E_DECLARE_PTP_CQ_STAT(struct mlx5e_ptp_cq_stats, ooo_cqe_drop) },
 };
 
 static const struct counter_desc ptp_rq_stats_desc[] = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
index 9f781085be47..52a67efafcd3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -459,6 +459,7 @@ struct mlx5e_ptp_cq_stats {
 	u64 abort_abs_diff_ns;
 	u64 resync_cqe;
 	u64 resync_event;
+	u64 ooo_cqe_drop;
 };
 
 struct mlx5e_stats {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index b4e263e8cfb8..235f6f0a7052 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1043,7 +1043,8 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
 	dest.vport.flags |= MLX5_FLOW_DEST_VPORT_VHCA_ID;
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 
-	if (rep->vport == MLX5_VPORT_UPLINK)
+	if (MLX5_CAP_ESW_FLOWTABLE(on_esw->dev, flow_source) &&
+	    rep->vport == MLX5_VPORT_UPLINK)
 		spec->flow_context.flow_source = MLX5_FLOW_CONTEXT_FLOW_SOURCE_LOCAL_VPORT;
 
 	flow_rule = mlx5_add_flow_rules(on_esw->fdb_table.offloads.slow_fdb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
index 23361a9ae4fa..6dc83e871cd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
@@ -105,6 +105,7 @@ int mlx5_geneve_tlv_option_add(struct mlx5_geneve *geneve, struct geneve_opt *op
 		geneve->opt_type = opt->type;
 		geneve->obj_id = res;
 		geneve->refcount++;
+		res = 0;
 	}
 
 unlock:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 3008e9ce2bbf..20d7662c10fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -147,6 +147,10 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 
 	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
+	/* For ECPFs, skip waiting for host VF pages until ECPF is destroyed */
+	if (mlx5_core_is_ecpf(dev))
+		return;
+
 	if (mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 1c16548415cd..b0c7ab74a82e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -2894,8 +2894,10 @@ static int happy_meal_pci_probe(struct pci_dev *pdev,
 		goto err_out_clear_quattro;
 	}
 
-	hpreg_res = devm_request_region(&pdev->dev, pci_resource_start(pdev, 0),
-					pci_resource_len(pdev, 0), DRV_NAME);
+	hpreg_res = devm_request_mem_region(&pdev->dev,
+					    pci_resource_start(pdev, 0),
+					    pci_resource_len(pdev, 0),
+					    DRV_NAME);
 	if (!hpreg_res) {
 		err = -EBUSY;
 		dev_err(&pdev->dev, "Cannot obtain PCI resources, aborting.\n");
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 51f68daac152..34b87389788b 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -52,6 +52,7 @@ struct mscc_miim_info {
 struct mscc_miim_dev {
 	struct regmap *regs;
 	int mii_status_offset;
+	bool ignore_read_errors;
 	struct regmap *phy_regs;
 	const struct mscc_miim_info *info;
 	struct clk *clk;
@@ -138,7 +139,7 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 		goto out;
 	}
 
-	if (val & MSCC_MIIM_DATA_ERROR) {
+	if (!miim->ignore_read_errors && !!(val & MSCC_MIIM_DATA_ERROR)) {
 		ret = -EIO;
 		goto out;
 	}
@@ -218,7 +219,8 @@ static const struct regmap_config mscc_miim_phy_regmap_config = {
 };
 
 int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
-		    struct regmap *mii_regmap, int status_offset)
+		    struct regmap *mii_regmap, int status_offset,
+		    bool ignore_read_errors)
 {
 	struct mscc_miim_dev *miim;
 	struct mii_bus *bus;
@@ -240,6 +242,7 @@ int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const char *name,
 
 	miim->regs = mii_regmap;
 	miim->mii_status_offset = status_offset;
+	miim->ignore_read_errors = ignore_read_errors;
 
 	*pbus = bus;
 
@@ -291,7 +294,7 @@ static int mscc_miim_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(phy_regmap),
 				     "Unable to create phy register regmap\n");
 
-	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0);
+	ret = mscc_miim_setup(dev, &bus, "mscc_miim", mii_regmap, 0, false);
 	if (ret < 0) {
 		dev_err(dev, "Unable to setup the MDIO bus\n");
 		return ret;
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index ec87dd21e054..b2f1ced8e6dd 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -672,6 +672,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
 					ST_NCI_EVT_TRANSMIT_DATA, apdu,
 					apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index df8d27cf2956..dae288bebcb5 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -236,6 +236,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
 					ST21NFCA_EVT_TRANSMIT_DATA,
 					apdu, apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 5acc9ae225df..2031fd960549 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -38,6 +38,7 @@ struct nvme_ns_info {
 	bool is_shared;
 	bool is_readonly;
 	bool is_ready;
+	bool is_removed;
 };
 
 unsigned int admin_timeout = 60;
@@ -1439,16 +1440,8 @@ static int nvme_identify_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	error = nvme_submit_sync_cmd(ctrl->admin_q, &c, *id, sizeof(**id));
 	if (error) {
 		dev_warn(ctrl->device, "Identify namespace failed (%d)\n", error);
-		goto out_free_id;
+		kfree(*id);
 	}
-
-	error = NVME_SC_INVALID_NS | NVME_SC_DNR;
-	if ((*id)->ncap == 0) /* namespace not allocated or attached */
-		goto out_free_id;
-	return 0;
-
-out_free_id:
-	kfree(*id);
 	return error;
 }
 
@@ -1462,6 +1455,13 @@ static int nvme_ns_info_from_identify(struct nvme_ctrl *ctrl,
 	ret = nvme_identify_ns(ctrl, info->nsid, &id);
 	if (ret)
 		return ret;
+
+	if (id->ncap == 0) {
+		/* namespace not allocated or attached */
+		info->is_removed = true;
+		return -ENODEV;
+	}
+
 	info->anagrpid = id->anagrpid;
 	info->is_shared = id->nmic & NVME_NS_NMIC_SHARED;
 	info->is_readonly = id->nsattr & NVME_NS_ATTR_RO;
@@ -4388,6 +4388,7 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 {
 	struct nvme_ns_info info = { .nsid = nsid };
 	struct nvme_ns *ns;
+	int ret;
 
 	if (nvme_identify_ns_descs(ctrl, &info))
 		return;
@@ -4404,19 +4405,19 @@ static void nvme_scan_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 	 * set up a namespace.  If not fall back to the legacy version.
 	 */
 	if ((ctrl->cap & NVME_CAP_CRMS_CRIMS) ||
-	    (info.ids.csi != NVME_CSI_NVM && info.ids.csi != NVME_CSI_ZNS)) {
-		if (nvme_ns_info_from_id_cs_indep(ctrl, &info))
-			return;
-	} else {
-		if (nvme_ns_info_from_identify(ctrl, &info))
-			return;
-	}
+	    (info.ids.csi != NVME_CSI_NVM && info.ids.csi != NVME_CSI_ZNS))
+		ret = nvme_ns_info_from_id_cs_indep(ctrl, &info);
+	else
+		ret = nvme_ns_info_from_identify(ctrl, &info);
+
+	if (info.is_removed)
+		nvme_ns_remove_by_nsid(ctrl, nsid);
 
 	/*
 	 * Ignore the namespace if it is not ready. We will get an AEN once it
 	 * becomes ready and restart the scan.
 	 */
-	if (!info.is_ready)
+	if (ret || !info.is_ready)
 		return;
 
 	ns = nvme_find_get_ns(ctrl, nsid);
diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index a6e22116e139..dcac3df8a5f7 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -189,7 +189,8 @@ nvmf_ctlr_matches_baseopts(struct nvme_ctrl *ctrl,
 
 static inline char *nvmf_ctrl_subsysnqn(struct nvme_ctrl *ctrl)
 {
-	if (!ctrl->subsys)
+	if (!ctrl->subsys ||
+	    !strcmp(ctrl->opts->subsysnqn, NVME_DISC_SUBSYS_NAME))
 		return ctrl->opts->subsysnqn;
 	return ctrl->subsys->subnqn;
 }
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 1dc7c733c7e3..bb80192c16b6 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2488,6 +2488,10 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 
 	len = nvmf_get_address(ctrl, buf, size);
 
+	mutex_lock(&queue->queue_lock);
+
+	if (!test_bit(NVME_TCP_Q_LIVE, &queue->flags))
+		goto done;
 	ret = kernel_getsockname(queue->sock, (struct sockaddr *)&src_addr);
 	if (ret > 0) {
 		if (len > 0)
@@ -2495,6 +2499,8 @@ static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
 		len += scnprintf(buf + len, size - len, "%ssrc_addr=%pISc\n",
 				(len) ? "," : "", &src_addr);
 	}
+done:
+	mutex_unlock(&queue->queue_lock);
 
 	return len;
 }
diff --git a/drivers/pci/controller/pci-loongson.c b/drivers/pci/controller/pci-loongson.c
index 05c50408f13b..fe0f732f6e43 100644
--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -15,9 +15,14 @@
 #include "../pci.h"
 
 /* Device IDs */
-#define DEV_PCIE_PORT_0	0x7a09
-#define DEV_PCIE_PORT_1	0x7a19
-#define DEV_PCIE_PORT_2	0x7a29
+#define DEV_LS2K_PCIE_PORT0	0x1a05
+#define DEV_LS7A_PCIE_PORT0	0x7a09
+#define DEV_LS7A_PCIE_PORT1	0x7a19
+#define DEV_LS7A_PCIE_PORT2	0x7a29
+#define DEV_LS7A_PCIE_PORT3	0x7a39
+#define DEV_LS7A_PCIE_PORT4	0x7a49
+#define DEV_LS7A_PCIE_PORT5	0x7a59
+#define DEV_LS7A_PCIE_PORT6	0x7a69
 
 #define DEV_LS2K_APB	0x7a02
 #define DEV_LS7A_GMAC	0x7a03
@@ -53,11 +58,11 @@ static void bridge_class_quirk(struct pci_dev *dev)
 	dev->class = PCI_CLASS_BRIDGE_PCI_NORMAL;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_0, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT0, bridge_class_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_1, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT1, bridge_class_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_2, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT2, bridge_class_quirk);
 
 static void system_bus_quirk(struct pci_dev *pdev)
 {
@@ -75,37 +80,33 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 			DEV_LS7A_LPC, system_bus_quirk);
 
-static void loongson_mrrs_quirk(struct pci_dev *dev)
+static void loongson_mrrs_quirk(struct pci_dev *pdev)
 {
-	struct pci_bus *bus = dev->bus;
-	struct pci_dev *bridge;
-	static const struct pci_device_id bridge_devids[] = {
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_0) },
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_1) },
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_2) },
-		{ 0, },
-	};
-
-	/* look for the matching bridge */
-	while (!pci_is_root_bus(bus)) {
-		bridge = bus->self;
-		bus = bus->parent;
-		/*
-		 * Some Loongson PCIe ports have a h/w limitation of
-		 * 256 bytes maximum read request size. They can't handle
-		 * anything larger than this. So force this limit on
-		 * any devices attached under these ports.
-		 */
-		if (pci_match_id(bridge_devids, bridge)) {
-			if (pcie_get_readrq(dev) > 256) {
-				pci_info(dev, "limiting MRRS to 256\n");
-				pcie_set_readrq(dev, 256);
-			}
-			break;
-		}
-	}
+	/*
+	 * Some Loongson PCIe ports have h/w limitations of maximum read
+	 * request size. They can't handle anything larger than this. So
+	 * force this limit on any devices attached under these ports.
+	 */
+	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
+
+	bridge->no_inc_mrrs = 1;
 }
-DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS2K_PCIE_PORT0, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT0, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT1, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT2, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT3, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT4, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT5, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT6, loongson_mrrs_quirk);
 
 static void loongson_pci_pin_quirk(struct pci_dev *pdev)
 {
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 040ae076ec0e..112c8f401ac4 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1086,6 +1086,8 @@ static void quirk_cmd_compl(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x010e,
+			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0110,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0400,
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index a46fec776ad7..1698205dd73c 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -976,24 +976,41 @@ bool acpi_pci_power_manageable(struct pci_dev *dev)
 bool acpi_pci_bridge_d3(struct pci_dev *dev)
 {
 	struct pci_dev *rpdev;
-	struct acpi_device *adev;
-	acpi_status status;
-	unsigned long long state;
+	struct acpi_device *adev, *rpadev;
 	const union acpi_object *obj;
 
 	if (acpi_pci_disabled || !dev->is_hotplug_bridge)
 		return false;
 
-	/* Assume D3 support if the bridge is power-manageable by ACPI. */
-	if (acpi_pci_power_manageable(dev))
-		return true;
+	adev = ACPI_COMPANION(&dev->dev);
+	if (adev) {
+		/*
+		 * If the bridge has _S0W, whether or not it can go into D3
+		 * depends on what is returned by that object.  In particular,
+		 * if the power state returned by _S0W is D2 or shallower,
+		 * entering D3 should not be allowed.
+		 */
+		if (acpi_dev_power_state_for_wake(adev) <= ACPI_STATE_D2)
+			return false;
+
+		/*
+		 * Otherwise, assume that the bridge can enter D3 so long as it
+		 * is power-manageable via ACPI.
+		 */
+		if (acpi_device_power_manageable(adev))
+			return true;
+	}
 
 	rpdev = pcie_find_root_port(dev);
 	if (!rpdev)
 		return false;
 
-	adev = ACPI_COMPANION(&rpdev->dev);
-	if (!adev)
+	if (rpdev == dev)
+		rpadev = adev;
+	else
+		rpadev = ACPI_COMPANION(&rpdev->dev);
+
+	if (!rpadev)
 		return false;
 
 	/*
@@ -1001,15 +1018,15 @@ bool acpi_pci_bridge_d3(struct pci_dev *dev)
 	 * doesn't supply a wakeup GPE via _PRW, it cannot signal hotplug
 	 * events from low-power states including D3hot and D3cold.
 	 */
-	if (!adev->wakeup.flags.valid)
+	if (!rpadev->wakeup.flags.valid)
 		return false;
 
 	/*
-	 * If the Root Port cannot wake itself from D3hot or D3cold, we
-	 * can't use D3.
+	 * In the bridge-below-a-Root-Port case, evaluate _S0W for the Root Port
+	 * to verify whether or not it can signal wakeup from D3.
 	 */
-	status = acpi_evaluate_integer(adev->handle, "_S0W", NULL, &state);
-	if (ACPI_SUCCESS(status) && state < ACPI_STATE_D3_HOT)
+	if (rpadev != adev &&
+	    acpi_dev_power_state_for_wake(rpadev) <= ACPI_STATE_D2)
 		return false;
 
 	/*
@@ -1018,7 +1035,7 @@ bool acpi_pci_bridge_d3(struct pci_dev *dev)
 	 * bridges *below* that Root Port can also signal hotplug events
 	 * while in D3.
 	 */
-	if (!acpi_dev_get_property(adev, "HotPlugSupportInD3",
+	if (!acpi_dev_get_property(rpadev, "HotPlugSupportInD3",
 				   ACPI_TYPE_INTEGER, &obj) &&
 	    obj->integer.value == 1)
 		return true;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index c20e95fd48ce..98d841a7b45b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6017,6 +6017,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 {
 	u16 v;
 	int ret;
+	struct pci_host_bridge *bridge = pci_find_host_bridge(dev->bus);
 
 	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
 		return -EINVAL;
@@ -6035,6 +6036,15 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 
 	v = (ffs(rq) - 8) << 12;
 
+	if (bridge->no_inc_mrrs) {
+		int max_mrrs = pcie_get_readrq(dev);
+
+		if (rq > max_mrrs) {
+			pci_info(dev, "can't set Max_Read_Request_Size to %d; max is %d\n", rq, max_mrrs);
+			return -EINVAL;
+		}
+	}
+
 	ret = pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
 						  PCI_EXP_DEVCTL_READRQ, v);
 
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 20ac67d59034..494fa46f5767 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4835,6 +4835,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+/*
+ * Wangxun 10G/1G NICs have no ACS capability, and on multi-function
+ * devices, peer-to-peer transactions are not be used between the functions.
+ * So add an ACS quirk for below devices to isolate functions.
+ * SFxxx 1G NICs(em).
+ * RP1000/RP2000 10G NICs(sp).
+ */
+static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	switch (dev->device) {
+	case 0x0100 ... 0x010F:
+	case 0x1001:
+	case 0x2001:
+		return pci_acs_ctrl_enabled(acs_flags,
+			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	}
+
+	return false;
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
@@ -4980,6 +5000,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
+	/* Wangxun nics */
+	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
 	{ 0 }
 };
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index b4096598dbcb..c690572b10ce 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1765,12 +1765,70 @@ static void adjust_bridge_window(struct pci_dev *bridge, struct resource *res,
 		add_size = size - new_size;
 		pci_dbg(bridge, "bridge window %pR shrunken by %pa\n", res,
 			&add_size);
+	} else {
+		return;
 	}
 
 	res->end = res->start + new_size - 1;
-	remove_from_list(add_list, res);
+
+	/* If the resource is part of the add_list, remove it now */
+	if (add_list)
+		remove_from_list(add_list, res);
+}
+
+static void remove_dev_resource(struct resource *avail, struct pci_dev *dev,
+				struct resource *res)
+{
+	resource_size_t size, align, tmp;
+
+	size = resource_size(res);
+	if (!size)
+		return;
+
+	align = pci_resource_alignment(dev, res);
+	align = align ? ALIGN(avail->start, align) - avail->start : 0;
+	tmp = align + size;
+	avail->start = min(avail->start + tmp, avail->end + 1);
+}
+
+static void remove_dev_resources(struct pci_dev *dev, struct resource *io,
+				 struct resource *mmio,
+				 struct resource *mmio_pref)
+{
+	int i;
+
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		struct resource *res = &dev->resource[i];
+
+		if (resource_type(res) == IORESOURCE_IO) {
+			remove_dev_resource(io, dev, res);
+		} else if (resource_type(res) == IORESOURCE_MEM) {
+
+			/*
+			 * Make sure prefetchable memory is reduced from
+			 * the correct resource. Specifically we put 32-bit
+			 * prefetchable memory in non-prefetchable window
+			 * if there is an 64-bit pretchable window.
+			 *
+			 * See comments in __pci_bus_size_bridges() for
+			 * more information.
+			 */
+			if ((res->flags & IORESOURCE_PREFETCH) &&
+			    ((res->flags & IORESOURCE_MEM_64) ==
+			     (mmio_pref->flags & IORESOURCE_MEM_64)))
+				remove_dev_resource(mmio_pref, dev, res);
+			else
+				remove_dev_resource(mmio, dev, res);
+		}
+	}
 }
 
+/*
+ * io, mmio and mmio_pref contain the total amount of bridge window space
+ * available. This includes the minimal space needed to cover all the
+ * existing devices on the bus and the possible extra space that can be
+ * shared with the bridges.
+ */
 static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 					    struct list_head *add_list,
 					    struct resource io,
@@ -1780,7 +1838,7 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 	unsigned int normal_bridges = 0, hotplug_bridges = 0;
 	struct resource *io_res, *mmio_res, *mmio_pref_res;
 	struct pci_dev *dev, *bridge = bus->self;
-	resource_size_t io_per_hp, mmio_per_hp, mmio_pref_per_hp, align;
+	resource_size_t io_per_b, mmio_per_b, mmio_pref_per_b, align;
 
 	io_res = &bridge->resource[PCI_BRIDGE_IO_WINDOW];
 	mmio_res = &bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -1824,94 +1882,88 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 			normal_bridges++;
 	}
 
+	if (!(hotplug_bridges + normal_bridges))
+		return;
+
 	/*
-	 * There is only one bridge on the bus so it gets all available
-	 * resources which it can then distribute to the possible hotplug
-	 * bridges below.
+	 * Calculate the amount of space we can forward from "bus" to any
+	 * downstream buses, i.e., the space left over after assigning the
+	 * BARs and windows on "bus".
 	 */
-	if (hotplug_bridges + normal_bridges == 1) {
-		dev = list_first_entry(&bus->devices, struct pci_dev, bus_list);
-		if (dev->subordinate)
-			pci_bus_distribute_available_resources(dev->subordinate,
-				add_list, io, mmio, mmio_pref);
-		return;
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->is_virtfn)
+			remove_dev_resources(dev, &io, &mmio, &mmio_pref);
 	}
 
-	if (hotplug_bridges == 0)
-		return;
-
 	/*
-	 * Calculate the total amount of extra resource space we can
-	 * pass to bridges below this one.  This is basically the
-	 * extra space reduced by the minimal required space for the
-	 * non-hotplug bridges.
+	 * If there is at least one hotplug bridge on this bus it gets all
+	 * the extra resource space that was left after the reductions
+	 * above.
+	 *
+	 * If there are no hotplug bridges the extra resource space is
+	 * split between non-hotplug bridges. This is to allow possible
+	 * hotplug bridges below them to get the extra space as well.
 	 */
+	if (hotplug_bridges) {
+		io_per_b = div64_ul(resource_size(&io), hotplug_bridges);
+		mmio_per_b = div64_ul(resource_size(&mmio), hotplug_bridges);
+		mmio_pref_per_b = div64_ul(resource_size(&mmio_pref),
+					   hotplug_bridges);
+	} else {
+		io_per_b = div64_ul(resource_size(&io), normal_bridges);
+		mmio_per_b = div64_ul(resource_size(&mmio), normal_bridges);
+		mmio_pref_per_b = div64_ul(resource_size(&mmio_pref),
+					   normal_bridges);
+	}
+
 	for_each_pci_bridge(dev, bus) {
-		resource_size_t used_size;
 		struct resource *res;
+		struct pci_bus *b;
 
-		if (dev->is_hotplug_bridge)
+		b = dev->subordinate;
+		if (!b)
+			continue;
+		if (hotplug_bridges && !dev->is_hotplug_bridge)
 			continue;
 
+		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
+
 		/*
-		 * Reduce the available resource space by what the
-		 * bridge and devices below it occupy.
+		 * Make sure the split resource space is properly aligned
+		 * for bridge windows (align it down to avoid going above
+		 * what is available).
 		 */
-		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(io.start, align) - io.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			io.start = min(io.start + used_size, io.end + 1);
+		io.end = align ? io.start + ALIGN_DOWN(io_per_b, align) - 1
+			       : io.start + io_per_b - 1;
+
+		/*
+		 * The x_per_b holds the extra resource space that can be
+		 * added for each bridge but there is the minimal already
+		 * reserved as well so adjust x.start down accordingly to
+		 * cover the whole space.
+		 */
+		io.start -= resource_size(res);
 
 		res = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(mmio.start, align) - mmio.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			mmio.start = min(mmio.start + used_size, mmio.end + 1);
+		mmio.end = align ? mmio.start + ALIGN_DOWN(mmio_per_b, align) - 1
+				 : mmio.start + mmio_per_b - 1;
+		mmio.start -= resource_size(res);
 
 		res = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(mmio_pref.start, align) -
-			mmio_pref.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			mmio_pref.start = min(mmio_pref.start + used_size,
-				mmio_pref.end + 1);
-	}
-
-	io_per_hp = div64_ul(resource_size(&io), hotplug_bridges);
-	mmio_per_hp = div64_ul(resource_size(&mmio), hotplug_bridges);
-	mmio_pref_per_hp = div64_ul(resource_size(&mmio_pref),
-		hotplug_bridges);
-
-	/*
-	 * Go over devices on this bus and distribute the remaining
-	 * resource space between hotplug bridges.
-	 */
-	for_each_pci_bridge(dev, bus) {
-		struct pci_bus *b;
-
-		b = dev->subordinate;
-		if (!b || !dev->is_hotplug_bridge)
-			continue;
-
-		/*
-		 * Distribute available extra resources equally between
-		 * hotplug-capable downstream ports taking alignment into
-		 * account.
-		 */
-		io.end = io.start + io_per_hp - 1;
-		mmio.end = mmio.start + mmio_per_hp - 1;
-		mmio_pref.end = mmio_pref.start + mmio_pref_per_hp - 1;
+		mmio_pref.end = align ? mmio_pref.start +
+					ALIGN_DOWN(mmio_pref_per_b, align) - 1
+				      : mmio_pref.start + mmio_pref_per_b - 1;
+		mmio_pref.start -= resource_size(res);
 
 		pci_bus_distribute_available_resources(b, add_list, io, mmio,
 						       mmio_pref);
 
-		io.start += io_per_hp;
-		mmio.start += mmio_per_hp;
-		mmio_pref.start += mmio_pref_per_hp;
+		io.start += io.end + 1;
+		mmio.start += mmio.end + 1;
+		mmio_pref.start += mmio_pref.end + 1;
 	}
 }
 
@@ -1923,6 +1975,8 @@ static void pci_bridge_distribute_available_resources(struct pci_dev *bridge,
 	if (!bridge->is_hotplug_bridge)
 		return;
 
+	pci_dbg(bridge, "distributing available resources\n");
+
 	/* Take the initial extra resources from the hotplug port */
 	available_io = bridge->resource[PCI_BRIDGE_IO_WINDOW];
 	available_mmio = bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -1934,6 +1988,54 @@ static void pci_bridge_distribute_available_resources(struct pci_dev *bridge,
 					       available_mmio_pref);
 }
 
+static bool pci_bridge_resources_not_assigned(struct pci_dev *dev)
+{
+	const struct resource *r;
+
+	/*
+	 * If the child device's resources are not yet assigned it means we
+	 * are configuring them (not the boot firmware), so we should be
+	 * able to extend the upstream bridge resources in the same way we
+	 * do with the normal hotplug case.
+	 */
+	r = &dev->resource[PCI_BRIDGE_IO_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+	r = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+	r = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
+	if (r->flags && !(r->flags & IORESOURCE_STARTALIGN))
+		return false;
+
+	return true;
+}
+
+static void
+pci_root_bus_distribute_available_resources(struct pci_bus *bus,
+					    struct list_head *add_list)
+{
+	struct pci_dev *dev, *bridge = bus->self;
+
+	for_each_pci_bridge(dev, bus) {
+		struct pci_bus *b;
+
+		b = dev->subordinate;
+		if (!b)
+			continue;
+
+		/*
+		 * Need to check "bridge" here too because it is NULL
+		 * in case of root bus.
+		 */
+		if (bridge && pci_bridge_resources_not_assigned(dev))
+			pci_bridge_distribute_available_resources(bridge,
+								  add_list);
+		else
+			pci_root_bus_distribute_available_resources(b, add_list);
+	}
+}
+
 /*
  * First try will not touch PCI bridge res.
  * Second and later try will clear small leaf bridge res.
@@ -1973,6 +2075,8 @@ void pci_assign_unassigned_root_bus_resources(struct pci_bus *bus)
 	 */
 	__pci_bus_size_bridges(bus, add_list);
 
+	pci_root_bus_distribute_available_resources(bus, add_list);
+
 	/* Depth last, allocate resources and update the hardware. */
 	__pci_bus_assign_resources(bus, add_list, &fail_head);
 	if (add_list)
diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index 6aea512e5d4e..39db8acde61a 100644
--- a/drivers/phy/rockchip/phy-rockchip-typec.c
+++ b/drivers/phy/rockchip/phy-rockchip-typec.c
@@ -808,9 +808,8 @@ static int tcphy_get_mode(struct rockchip_typec_phy *tcphy)
 	struct extcon_dev *edev = tcphy->extcon;
 	union extcon_property_value property;
 	unsigned int id;
-	bool ufp, dp;
 	u8 mode;
-	int ret;
+	int ret, ufp, dp;
 
 	if (!edev)
 		return MODE_DFP_USB;
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 77918a2c6701..75f58fc468a7 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -66,7 +66,7 @@ struct ptp_vclock {
 	struct hlist_node vclock_hash_node;
 	struct cyclecounter cc;
 	struct timecounter tc;
-	spinlock_t lock;	/* protects tc/cc */
+	struct mutex lock;	/* protects tc/cc */
 };
 
 /*
diff --git a/drivers/ptp/ptp_vclock.c b/drivers/ptp/ptp_vclock.c
index 1c0ed4805c0a..dcf752c9e045 100644
--- a/drivers/ptp/ptp_vclock.c
+++ b/drivers/ptp/ptp_vclock.c
@@ -43,16 +43,16 @@ static void ptp_vclock_hash_del(struct ptp_vclock *vclock)
 static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 	s64 adj;
 
 	adj = (s64)scaled_ppm << PTP_VCLOCK_FADJ_SHIFT;
 	adj = div_s64(adj, PTP_VCLOCK_FADJ_DENOMINATOR);
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	timecounter_read(&vclock->tc);
 	vclock->cc.mult = PTP_VCLOCK_CC_MULT + adj;
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -60,11 +60,11 @@ static int ptp_vclock_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 static int ptp_vclock_adjtime(struct ptp_clock_info *ptp, s64 delta)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	timecounter_adjtime(&vclock->tc, delta);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -73,12 +73,12 @@ static int ptp_vclock_gettime(struct ptp_clock_info *ptp,
 			      struct timespec64 *ts)
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
-	unsigned long flags;
 	u64 ns;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	ns = timecounter_read(&vclock->tc);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 	*ts = ns_to_timespec64(ns);
 
 	return 0;
@@ -91,7 +91,6 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct ptp_clock *pptp = vclock->pclock;
 	struct timespec64 pts;
-	unsigned long flags;
 	int err;
 	u64 ns;
 
@@ -99,9 +98,10 @@ static int ptp_vclock_gettimex(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	ns = timecounter_cyc2time(&vclock->tc, timespec64_to_ns(&pts));
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	*ts = ns_to_timespec64(ns);
 
@@ -113,11 +113,11 @@ static int ptp_vclock_settime(struct ptp_clock_info *ptp,
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	u64 ns = timespec64_to_ns(ts);
-	unsigned long flags;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	timecounter_init(&vclock->tc, &vclock->cc, ns);
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	return 0;
 }
@@ -127,7 +127,6 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 {
 	struct ptp_vclock *vclock = info_to_vclock(ptp);
 	struct ptp_clock *pptp = vclock->pclock;
-	unsigned long flags;
 	int err;
 	u64 ns;
 
@@ -135,9 +134,10 @@ static int ptp_vclock_getcrosststamp(struct ptp_clock_info *ptp,
 	if (err)
 		return err;
 
-	spin_lock_irqsave(&vclock->lock, flags);
+	if (mutex_lock_interruptible(&vclock->lock))
+		return -EINTR;
 	ns = timecounter_cyc2time(&vclock->tc, ktime_to_ns(xtstamp->device));
-	spin_unlock_irqrestore(&vclock->lock, flags);
+	mutex_unlock(&vclock->lock);
 
 	xtstamp->device = ns_to_ktime(ns);
 
@@ -205,7 +205,7 @@ struct ptp_vclock *ptp_vclock_register(struct ptp_clock *pclock)
 
 	INIT_HLIST_NODE(&vclock->vclock_hash_node);
 
-	spin_lock_init(&vclock->lock);
+	mutex_init(&vclock->lock);
 
 	vclock->clock = ptp_clock_register(&vclock->info, &pclock->dev);
 	if (IS_ERR_OR_NULL(vclock->clock)) {
@@ -269,7 +269,6 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 {
 	unsigned int hash = vclock_index % HASH_SIZE(vclock_hash);
 	struct ptp_vclock *vclock;
-	unsigned long flags;
 	u64 ns;
 	u64 vclock_ns = 0;
 
@@ -281,9 +280,10 @@ ktime_t ptp_convert_timestamp(const ktime_t *hwtstamp, int vclock_index)
 		if (vclock->clock->index != vclock_index)
 			continue;
 
-		spin_lock_irqsave(&vclock->lock, flags);
+		if (mutex_lock_interruptible(&vclock->lock))
+			break;
 		vclock_ns = timecounter_cyc2time(&vclock->tc, ns);
-		spin_unlock_irqrestore(&vclock->lock, flags);
+		mutex_unlock(&vclock->lock);
 		break;
 	}
 
diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index bb7239313401..89d53a0f91e6 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -159,7 +159,13 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	mutex_lock(&ddata->lock);
 	if (state->period != ddata->approx_period) {
-		if (ddata->user_count != 1) {
+		/*
+		 * Don't let a 2nd user change the period underneath the 1st user.
+		 * However if ddate->approx_period == 0 this is the first time we set
+		 * any period, so let whoever gets here first set the period so other
+		 * users who agree on the period won't fail.
+		 */
+		if (ddata->user_count != 1 && ddata->approx_period) {
 			mutex_unlock(&ddata->lock);
 			return -EBUSY;
 		}
diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 3115abb3f52a..61a1c87cd501 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -127,7 +127,7 @@ static int stm32_pwm_lp_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	/* ensure CMP & ARR registers are properly written */
 	ret = regmap_read_poll_timeout(priv->regmap, STM32_LPTIM_ISR, val,
-				       (val & STM32_LPTIM_CMPOK_ARROK),
+				       (val & STM32_LPTIM_CMPOK_ARROK) == STM32_LPTIM_CMPOK_ARROK,
 				       100, 1000);
 	if (ret) {
 		dev_err(priv->chip.dev, "ARR/CMP registers write issue\n");
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 9edd662c69ac..3d0fbc644f57 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -392,7 +392,7 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 		return err;
 	if (!rtc->ops) {
 		err = -ENODEV;
-	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features) || !rtc->ops->read_alarm) {
+	} else if (!test_bit(RTC_FEATURE_ALARM, rtc->features)) {
 		err = -EINVAL;
 	} else {
 		memset(alarm, 0, sizeof(struct rtc_wkalrm));
diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index ed5516089e9a..7038f47d77ff 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -136,7 +136,6 @@ struct sun6i_rtc_clk_data {
 	unsigned int fixed_prescaler : 16;
 	unsigned int has_prescaler : 1;
 	unsigned int has_out_clk : 1;
-	unsigned int export_iosc : 1;
 	unsigned int has_losc_en : 1;
 	unsigned int has_auto_swt : 1;
 };
@@ -271,10 +270,8 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 	/* Yes, I know, this is ugly. */
 	sun6i_rtc = rtc;
 
-	/* Only read IOSC name from device tree if it is exported */
-	if (rtc->data->export_iosc)
-		of_property_read_string_index(node, "clock-output-names", 2,
-					      &iosc_name);
+	of_property_read_string_index(node, "clock-output-names", 2,
+				      &iosc_name);
 
 	rtc->int_osc = clk_hw_register_fixed_rate_with_accuracy(NULL,
 								iosc_name,
@@ -315,13 +312,10 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 		goto err_register;
 	}
 
-	clk_data->num = 2;
+	clk_data->num = 3;
 	clk_data->hws[0] = &rtc->hw;
 	clk_data->hws[1] = __clk_get_hw(rtc->ext_losc);
-	if (rtc->data->export_iosc) {
-		clk_data->hws[2] = rtc->int_osc;
-		clk_data->num = 3;
-	}
+	clk_data->hws[2] = rtc->int_osc;
 	of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	return;
 
@@ -361,7 +355,6 @@ static const struct sun6i_rtc_clk_data sun8i_h3_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 };
 
 static void __init sun8i_h3_rtc_clk_init(struct device_node *node)
@@ -379,7 +372,6 @@ static const struct sun6i_rtc_clk_data sun50i_h6_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 	.has_losc_en = 1,
 	.has_auto_swt = 1,
 };
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 2022ffb45041..8c062afb2918 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1516,23 +1516,22 @@ static void ipr_process_ccn(struct ipr_cmnd *ipr_cmd)
 }
 
 /**
- * strip_and_pad_whitespace - Strip and pad trailing whitespace.
- * @i:		index into buffer
- * @buf:		string to modify
+ * strip_whitespace - Strip and pad trailing whitespace.
+ * @i:		size of buffer
+ * @buf:	string to modify
  *
- * This function will strip all trailing whitespace, pad the end
- * of the string with a single space, and NULL terminate the string.
+ * This function will strip all trailing whitespace and
+ * NUL terminate the string.
  *
- * Return value:
- * 	new length of string
  **/
-static int strip_and_pad_whitespace(int i, char *buf)
+static void strip_whitespace(int i, char *buf)
 {
+	if (i < 1)
+		return;
+	i--;
 	while (i && buf[i] == ' ')
 		i--;
-	buf[i+1] = ' ';
-	buf[i+2] = '\0';
-	return i + 2;
+	buf[i+1] = '\0';
 }
 
 /**
@@ -1547,19 +1546,21 @@ static int strip_and_pad_whitespace(int i, char *buf)
 static void ipr_log_vpd_compact(char *prefix, struct ipr_hostrcb *hostrcb,
 				struct ipr_vpd *vpd)
 {
-	char buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN + IPR_SERIAL_NUM_LEN + 3];
-	int i = 0;
+	char vendor_id[IPR_VENDOR_ID_LEN + 1];
+	char product_id[IPR_PROD_ID_LEN + 1];
+	char sn[IPR_SERIAL_NUM_LEN + 1];
 
-	memcpy(buffer, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
-	i = strip_and_pad_whitespace(IPR_VENDOR_ID_LEN - 1, buffer);
+	memcpy(vendor_id, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
+	strip_whitespace(IPR_VENDOR_ID_LEN, vendor_id);
 
-	memcpy(&buffer[i], vpd->vpids.product_id, IPR_PROD_ID_LEN);
-	i = strip_and_pad_whitespace(i + IPR_PROD_ID_LEN - 1, buffer);
+	memcpy(product_id, vpd->vpids.product_id, IPR_PROD_ID_LEN);
+	strip_whitespace(IPR_PROD_ID_LEN, product_id);
 
-	memcpy(&buffer[i], vpd->sn, IPR_SERIAL_NUM_LEN);
-	buffer[IPR_SERIAL_NUM_LEN + i] = '\0';
+	memcpy(sn, vpd->sn, IPR_SERIAL_NUM_LEN);
+	strip_whitespace(IPR_SERIAL_NUM_LEN, sn);
 
-	ipr_hcam_err(hostrcb, "%s VPID/SN: %s\n", prefix, buffer);
+	ipr_hcam_err(hostrcb, "%s VPID/SN: %s %s %s\n", prefix,
+		     vendor_id, product_id, sn);
 }
 
 /**
diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index def4c5e15cd8..8a438f248a82 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -955,19 +955,16 @@ struct scmd_priv {
  * @chain_buf_count: Chain buffer count
  * @chain_buf_pool: Chain buffer pool
  * @chain_sgl_list: Chain SGL list
- * @chain_bitmap_sz: Chain buffer allocator bitmap size
  * @chain_bitmap: Chain buffer allocator bitmap
  * @chain_buf_lock: Chain buffer list lock
  * @bsg_cmds: Command tracker for BSG command
  * @host_tm_cmds: Command tracker for task management commands
  * @dev_rmhs_cmds: Command tracker for device removal commands
  * @evtack_cmds: Command tracker for event ack commands
- * @devrem_bitmap_sz: Device removal bitmap size
  * @devrem_bitmap: Device removal bitmap
- * @dev_handle_bitmap_sz: Device handle bitmap size
+ * @dev_handle_bitmap_bits: Number of bits in device handle bitmap
  * @removepend_bitmap: Remove pending bitmap
  * @delayed_rmhs_list: Delayed device removal list
- * @evtack_cmds_bitmap_sz: Event Ack bitmap size
  * @evtack_cmds_bitmap: Event Ack bitmap
  * @delayed_evtack_cmds_list: Delayed event acknowledgment list
  * @ts_update_counter: Timestamp update counter
@@ -1128,7 +1125,6 @@ struct mpi3mr_ioc {
 	u32 chain_buf_count;
 	struct dma_pool *chain_buf_pool;
 	struct chain_element *chain_sgl_list;
-	u16  chain_bitmap_sz;
 	void *chain_bitmap;
 	spinlock_t chain_buf_lock;
 
@@ -1136,12 +1132,10 @@ struct mpi3mr_ioc {
 	struct mpi3mr_drv_cmd host_tm_cmds;
 	struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
 	struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
-	u16 devrem_bitmap_sz;
 	void *devrem_bitmap;
-	u16 dev_handle_bitmap_sz;
+	u16 dev_handle_bitmap_bits;
 	void *removepend_bitmap;
 	struct list_head delayed_rmhs_list;
-	u16 evtack_cmds_bitmap_sz;
 	void *evtack_cmds_bitmap;
 	struct list_head delayed_evtack_cmds_list;
 
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 0c4aabaefdcc..1e4467ea8472 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1128,7 +1128,6 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
 static int
 mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 {
-	u16 dev_handle_bitmap_sz;
 	void *removepend_bitmap;
 
 	if (mrioc->facts.reply_sz > mrioc->reply_sz) {
@@ -1160,25 +1159,23 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
 		    "\tcontroller while sas transport support is enabled at the\n"
 		    "\tdriver, please reboot the system or reload the driver\n");
 
-	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
-	if (mrioc->facts.max_devhandle % 8)
-		dev_handle_bitmap_sz++;
-	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
-		removepend_bitmap = krealloc(mrioc->removepend_bitmap,
-		    dev_handle_bitmap_sz, GFP_KERNEL);
+	if (mrioc->facts.max_devhandle > mrioc->dev_handle_bitmap_bits) {
+		removepend_bitmap = bitmap_zalloc(mrioc->facts.max_devhandle,
+						  GFP_KERNEL);
 		if (!removepend_bitmap) {
 			ioc_err(mrioc,
-			    "failed to increase removepend_bitmap sz from: %d to %d\n",
-			    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
+				"failed to increase removepend_bitmap bits from %d to %d\n",
+				mrioc->dev_handle_bitmap_bits,
+				mrioc->facts.max_devhandle);
 			return -EPERM;
 		}
-		memset(removepend_bitmap + mrioc->dev_handle_bitmap_sz, 0,
-		    dev_handle_bitmap_sz - mrioc->dev_handle_bitmap_sz);
+		bitmap_free(mrioc->removepend_bitmap);
 		mrioc->removepend_bitmap = removepend_bitmap;
 		ioc_info(mrioc,
-		    "increased dev_handle_bitmap_sz from %d to %d\n",
-		    mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
-		mrioc->dev_handle_bitmap_sz = dev_handle_bitmap_sz;
+			 "increased bits of dev_handle_bitmap from %d to %d\n",
+			 mrioc->dev_handle_bitmap_bits,
+			 mrioc->facts.max_devhandle);
+		mrioc->dev_handle_bitmap_bits = mrioc->facts.max_devhandle;
 	}
 
 	return 0;
@@ -2957,27 +2954,18 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
 	if (!mrioc->pel_abort_cmd.reply)
 		goto out_failed;
 
-	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
-	if (mrioc->facts.max_devhandle % 8)
-		mrioc->dev_handle_bitmap_sz++;
-	mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
-	    GFP_KERNEL);
+	mrioc->dev_handle_bitmap_bits = mrioc->facts.max_devhandle;
+	mrioc->removepend_bitmap = bitmap_zalloc(mrioc->dev_handle_bitmap_bits,
+						 GFP_KERNEL);
 	if (!mrioc->removepend_bitmap)
 		goto out_failed;
 
-	mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
-	if (MPI3MR_NUM_DEVRMCMD % 8)
-		mrioc->devrem_bitmap_sz++;
-	mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
-	    GFP_KERNEL);
+	mrioc->devrem_bitmap = bitmap_zalloc(MPI3MR_NUM_DEVRMCMD, GFP_KERNEL);
 	if (!mrioc->devrem_bitmap)
 		goto out_failed;
 
-	mrioc->evtack_cmds_bitmap_sz = MPI3MR_NUM_EVTACKCMD / 8;
-	if (MPI3MR_NUM_EVTACKCMD % 8)
-		mrioc->evtack_cmds_bitmap_sz++;
-	mrioc->evtack_cmds_bitmap = kzalloc(mrioc->evtack_cmds_bitmap_sz,
-	    GFP_KERNEL);
+	mrioc->evtack_cmds_bitmap = bitmap_zalloc(MPI3MR_NUM_EVTACKCMD,
+						  GFP_KERNEL);
 	if (!mrioc->evtack_cmds_bitmap)
 		goto out_failed;
 
@@ -3415,10 +3403,7 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
 		if (!mrioc->chain_sgl_list[i].addr)
 			goto out_failed;
 	}
-	mrioc->chain_bitmap_sz = num_chains / 8;
-	if (num_chains % 8)
-		mrioc->chain_bitmap_sz++;
-	mrioc->chain_bitmap = kzalloc(mrioc->chain_bitmap_sz, GFP_KERNEL);
+	mrioc->chain_bitmap = bitmap_zalloc(num_chains, GFP_KERNEL);
 	if (!mrioc->chain_bitmap)
 		goto out_failed;
 	return retval;
@@ -4190,10 +4175,11 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
 		for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
 			memset(mrioc->evtack_cmds[i].reply, 0,
 			    sizeof(*mrioc->evtack_cmds[i].reply));
-		memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
-		memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
-		memset(mrioc->evtack_cmds_bitmap, 0,
-		    mrioc->evtack_cmds_bitmap_sz);
+		bitmap_clear(mrioc->removepend_bitmap, 0,
+			     mrioc->dev_handle_bitmap_bits);
+		bitmap_clear(mrioc->devrem_bitmap, 0, MPI3MR_NUM_DEVRMCMD);
+		bitmap_clear(mrioc->evtack_cmds_bitmap, 0,
+			     MPI3MR_NUM_EVTACKCMD);
 	}
 
 	for (i = 0; i < mrioc->num_queues; i++) {
@@ -4319,16 +4305,16 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		mrioc->evtack_cmds[i].reply = NULL;
 	}
 
-	kfree(mrioc->removepend_bitmap);
+	bitmap_free(mrioc->removepend_bitmap);
 	mrioc->removepend_bitmap = NULL;
 
-	kfree(mrioc->devrem_bitmap);
+	bitmap_free(mrioc->devrem_bitmap);
 	mrioc->devrem_bitmap = NULL;
 
-	kfree(mrioc->evtack_cmds_bitmap);
+	bitmap_free(mrioc->evtack_cmds_bitmap);
 	mrioc->evtack_cmds_bitmap = NULL;
 
-	kfree(mrioc->chain_bitmap);
+	bitmap_free(mrioc->chain_bitmap);
 	mrioc->chain_bitmap = NULL;
 
 	kfree(mrioc->transport_cmds.reply);
@@ -4887,9 +4873,10 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
 
 	mpi3mr_flush_delayed_cmd_lists(mrioc);
 	mpi3mr_flush_drv_cmds(mrioc);
-	memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
-	memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
-	memset(mrioc->evtack_cmds_bitmap, 0, mrioc->evtack_cmds_bitmap_sz);
+	bitmap_clear(mrioc->devrem_bitmap, 0, MPI3MR_NUM_DEVRMCMD);
+	bitmap_clear(mrioc->removepend_bitmap, 0,
+		     mrioc->dev_handle_bitmap_bits);
+	bitmap_clear(mrioc->evtack_cmds_bitmap, 0, MPI3MR_NUM_EVTACKCMD);
 	mpi3mr_flush_host_io(mrioc);
 	mpi3mr_cleanup_fwevt_list(mrioc);
 	mpi3mr_invalidate_devhandles(mrioc);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 3fc897336b5e..3b61815979da 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1280,7 +1280,7 @@ void mpi3mr_sas_host_add(struct mpi3mr_ioc *mrioc)
 
 	if (mrioc->sas_hba.enclosure_handle) {
 		if (!(mpi3mr_cfg_get_enclosure_pg0(mrioc, &ioc_status,
-		    &encl_pg0, sizeof(dev_pg0),
+		    &encl_pg0, sizeof(encl_pg0),
 		    MPI3_ENCLOS_PGAD_FORM_HANDLE,
 		    mrioc->sas_hba.enclosure_handle)) &&
 		    (ioc_status == MPI3_IOCSTATUS_SUCCESS))
diff --git a/drivers/soc/mediatek/mt8186-pm-domains.h b/drivers/soc/mediatek/mt8186-pm-domains.h
index 108af61854a3..fce86f79c505 100644
--- a/drivers/soc/mediatek/mt8186-pm-domains.h
+++ b/drivers/soc/mediatek/mt8186-pm-domains.h
@@ -304,7 +304,6 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 		.ctl_offs = 0x9FC,
 		.pwr_sta_offs = 0x16C,
 		.pwr_sta2nd_offs = 0x170,
-		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8186_POWER_DOMAIN_ADSP_INFRA] = {
 		.name = "adsp_infra",
@@ -312,7 +311,6 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 		.ctl_offs = 0x9F8,
 		.pwr_sta_offs = 0x16C,
 		.pwr_sta2nd_offs = 0x170,
-		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8186_POWER_DOMAIN_ADSP_TOP] = {
 		.name = "adsp_top",
@@ -332,7 +330,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8186[] = {
 				MT8186_TOP_AXI_PROT_EN_3_CLR,
 				MT8186_TOP_AXI_PROT_EN_3_STA),
 		},
-		.caps = MTK_SCPD_SRAM_ISO | MTK_SCPD_KEEP_DEFAULT_OFF | MTK_SCPD_ACTIVE_WAKEUP,
+		.caps = MTK_SCPD_SRAM_ISO | MTK_SCPD_ACTIVE_WAKEUP,
 	},
 };
 
diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 0469c9dfeb04..00526fd37d7b 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -1324,7 +1324,7 @@ static int svs_init01(struct svs_platform *svsp)
 				svsb->pm_runtime_enabled_count++;
 			}
 
-			ret = pm_runtime_get_sync(svsb->opp_dev);
+			ret = pm_runtime_resume_and_get(svsb->opp_dev);
 			if (ret < 0) {
 				dev_err(svsb->dev, "mtcmos on fail: %d\n", ret);
 				goto svs_init01_resume_cpuidle;
@@ -1461,6 +1461,7 @@ static int svs_init02(struct svs_platform *svsp)
 {
 	struct svs_bank *svsb;
 	unsigned long flags, time_left;
+	int ret;
 	u32 idx;
 
 	for (idx = 0; idx < svsp->bank_max; idx++) {
@@ -1479,7 +1480,8 @@ static int svs_init02(struct svs_platform *svsp)
 							msecs_to_jiffies(5000));
 		if (!time_left) {
 			dev_err(svsb->dev, "init02 completion timeout\n");
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out_of_init02;
 		}
 	}
 
@@ -1497,12 +1499,30 @@ static int svs_init02(struct svs_platform *svsp)
 		if (svsb->type == SVSB_HIGH || svsb->type == SVSB_LOW) {
 			if (svs_sync_bank_volts_from_opp(svsb)) {
 				dev_err(svsb->dev, "sync volt fail\n");
-				return -EPERM;
+				ret = -EPERM;
+				goto out_of_init02;
 			}
 		}
 	}
 
 	return 0;
+
+out_of_init02:
+	for (idx = 0; idx < svsp->bank_max; idx++) {
+		svsb = &svsp->banks[idx];
+
+		spin_lock_irqsave(&svs_lock, flags);
+		svsp->pbank = svsb;
+		svs_switch_bank(svsp);
+		svs_writel_relaxed(svsp, SVSB_PTPEN_OFF, SVSEN);
+		svs_writel_relaxed(svsp, SVSB_INTSTS_VAL_CLEAN, INTSTS);
+		spin_unlock_irqrestore(&svs_lock, flags);
+
+		svsb->phase = SVSB_PHASE_ERROR;
+		svs_adjust_pm_opp_volts(svsb);
+	}
+
+	return ret;
 }
 
 static void svs_mon_mode(struct svs_platform *svsp)
@@ -1594,12 +1614,16 @@ static int svs_resume(struct device *dev)
 
 	ret = svs_init02(svsp);
 	if (ret)
-		goto out_of_resume;
+		goto svs_resume_reset_assert;
 
 	svs_mon_mode(svsp);
 
 	return 0;
 
+svs_resume_reset_assert:
+	dev_err(svsp->dev, "assert reset: %d\n",
+		reset_control_assert(svsp->rst));
+
 out_of_resume:
 	clk_disable_unprepare(svsp->main_clk);
 	return ret;
@@ -2385,14 +2409,6 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_free_resource;
 	}
 
-	ret = devm_request_threaded_irq(svsp->dev, svsp_irq, NULL, svs_isr,
-					IRQF_ONESHOT, svsp->name, svsp);
-	if (ret) {
-		dev_err(svsp->dev, "register irq(%d) failed: %d\n",
-			svsp_irq, ret);
-		goto svs_probe_free_resource;
-	}
-
 	svsp->main_clk = devm_clk_get(svsp->dev, "main");
 	if (IS_ERR(svsp->main_clk)) {
 		dev_err(svsp->dev, "failed to get clock: %ld\n",
@@ -2414,6 +2430,14 @@ static int svs_probe(struct platform_device *pdev)
 		goto svs_probe_clk_disable;
 	}
 
+	ret = devm_request_threaded_irq(svsp->dev, svsp_irq, NULL, svs_isr,
+					IRQF_ONESHOT, svsp->name, svsp);
+	if (ret) {
+		dev_err(svsp->dev, "register irq(%d) failed: %d\n",
+			svsp_irq, ret);
+		goto svs_probe_iounmap;
+	}
+
 	ret = svs_start(svsp);
 	if (ret) {
 		dev_err(svsp->dev, "svs start fail: %d\n", ret);
diff --git a/drivers/soc/qcom/qcom_stats.c b/drivers/soc/qcom/qcom_stats.c
index 121ea409fafc..b252bedf0cf1 100644
--- a/drivers/soc/qcom/qcom_stats.c
+++ b/drivers/soc/qcom/qcom_stats.c
@@ -92,7 +92,7 @@ static int qcom_subsystem_sleep_stats_show(struct seq_file *s, void *unused)
 	/* Items are allocated lazily, so lookup pointer each time */
 	stat = qcom_smem_get(subsystem->pid, subsystem->smem_item, NULL);
 	if (IS_ERR(stat))
-		return -EIO;
+		return 0;
 
 	qcom_print_stats(s, stat);
 
@@ -170,20 +170,14 @@ static void qcom_create_soc_sleep_stat_files(struct dentry *root, void __iomem *
 static void qcom_create_subsystem_stat_files(struct dentry *root,
 					     const struct stats_config *config)
 {
-	const struct sleep_stats *stat;
 	int i;
 
 	if (!config->subsystem_stats_in_smem)
 		return;
 
-	for (i = 0; i < ARRAY_SIZE(subsystems); i++) {
-		stat = qcom_smem_get(subsystems[i].pid, subsystems[i].smem_item, NULL);
-		if (IS_ERR(stat))
-			continue;
-
+	for (i = 0; i < ARRAY_SIZE(subsystems); i++)
 		debugfs_create_file(subsystems[i].name, 0400, root, (void *)&subsystems[i],
 				    &qcom_subsystem_sleep_stats_fops);
-	}
 }
 
 static int qcom_stats_probe(struct platform_device *pdev)
diff --git a/drivers/soc/xilinx/xlnx_event_manager.c b/drivers/soc/xilinx/xlnx_event_manager.c
index 2de082765bef..c76381899ef4 100644
--- a/drivers/soc/xilinx/xlnx_event_manager.c
+++ b/drivers/soc/xilinx/xlnx_event_manager.c
@@ -116,8 +116,10 @@ static int xlnx_add_cb_for_notify_event(const u32 node_id, const u32 event, cons
 		INIT_LIST_HEAD(&eve_data->cb_list_head);
 
 		cb_data = kmalloc(sizeof(*cb_data), GFP_KERNEL);
-		if (!cb_data)
+		if (!cb_data) {
+			kfree(eve_data);
 			return -ENOMEM;
+		}
 		cb_data->eve_cb = cb_fun;
 		cb_data->agent_data = data;
 
diff --git a/drivers/soundwire/bus_type.c b/drivers/soundwire/bus_type.c
index 04b3529f8929..963498db0fd2 100644
--- a/drivers/soundwire/bus_type.c
+++ b/drivers/soundwire/bus_type.c
@@ -105,20 +105,19 @@ static int sdw_drv_probe(struct device *dev)
 	if (ret)
 		return ret;
 
-	mutex_lock(&slave->sdw_dev_lock);
-
 	ret = drv->probe(slave, id);
 	if (ret) {
 		name = drv->name;
 		if (!name)
 			name = drv->driver.name;
-		mutex_unlock(&slave->sdw_dev_lock);
 
 		dev_err(dev, "Probe of %s failed: %d\n", name, ret);
 		dev_pm_domain_detach(dev, false);
 		return ret;
 	}
 
+	mutex_lock(&slave->sdw_dev_lock);
+
 	/* device is probed so let's read the properties now */
 	if (drv->ops && drv->ops->read_prop)
 		drv->ops->read_prop(slave);
@@ -167,14 +166,12 @@ static int sdw_drv_remove(struct device *dev)
 	int ret = 0;
 
 	mutex_lock(&slave->sdw_dev_lock);
-
 	slave->probed = false;
+	mutex_unlock(&slave->sdw_dev_lock);
 
 	if (drv->remove)
 		ret = drv->remove(slave);
 
-	mutex_unlock(&slave->sdw_dev_lock);
-
 	dev_pm_domain_detach(dev, false);
 
 	return ret;
diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index b65cdf2a7593..e7da7d7b213f 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -555,6 +555,29 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
 	return SDW_CMD_OK;
 }
 
+static void cdns_read_response(struct sdw_cdns *cdns)
+{
+	u32 num_resp, cmd_base;
+	int i;
+
+	/* RX_FIFO_AVAIL can be 2 entries more than the FIFO size */
+	BUILD_BUG_ON(ARRAY_SIZE(cdns->response_buf) < CDNS_MCP_CMD_LEN + 2);
+
+	num_resp = cdns_readl(cdns, CDNS_MCP_FIFOSTAT);
+	num_resp &= CDNS_MCP_RX_FIFO_AVAIL;
+	if (num_resp > ARRAY_SIZE(cdns->response_buf)) {
+		dev_warn(cdns->dev, "RX AVAIL %d too long\n", num_resp);
+		num_resp = ARRAY_SIZE(cdns->response_buf);
+	}
+
+	cmd_base = CDNS_MCP_CMD_BASE;
+
+	for (i = 0; i < num_resp; i++) {
+		cdns->response_buf[i] = cdns_readl(cdns, cmd_base);
+		cmd_base += CDNS_MCP_CMD_WORD_LEN;
+	}
+}
+
 static enum sdw_command_response
 _cdns_xfer_msg(struct sdw_cdns *cdns, struct sdw_msg *msg, int cmd,
 	       int offset, int count, bool defer)
@@ -596,6 +619,10 @@ _cdns_xfer_msg(struct sdw_cdns *cdns, struct sdw_msg *msg, int cmd,
 		dev_err(cdns->dev, "IO transfer timed out, cmd %d device %d addr %x len %d\n",
 			cmd, msg->dev_num, msg->addr, msg->len);
 		msg->len = 0;
+
+		/* Drain anything in the RX_FIFO */
+		cdns_read_response(cdns);
+
 		return SDW_CMD_TIMEOUT;
 	}
 
@@ -769,22 +796,6 @@ EXPORT_SYMBOL(cdns_read_ping_status);
  * IRQ handling
  */
 
-static void cdns_read_response(struct sdw_cdns *cdns)
-{
-	u32 num_resp, cmd_base;
-	int i;
-
-	num_resp = cdns_readl(cdns, CDNS_MCP_FIFOSTAT);
-	num_resp &= CDNS_MCP_RX_FIFO_AVAIL;
-
-	cmd_base = CDNS_MCP_CMD_BASE;
-
-	for (i = 0; i < num_resp; i++) {
-		cdns->response_buf[i] = cdns_readl(cdns, cmd_base);
-		cmd_base += CDNS_MCP_CMD_WORD_LEN;
-	}
-}
-
 static int cdns_update_slave_status(struct sdw_cdns *cdns,
 				    u64 slave_intstat)
 {
diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index ca9e805bab88..51e6ecc027cb 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -8,6 +8,12 @@
 #define SDW_CADENCE_GSYNC_KHZ		4 /* 4 kHz */
 #define SDW_CADENCE_GSYNC_HZ		(SDW_CADENCE_GSYNC_KHZ * 1000)
 
+/*
+ * The Cadence IP supports up to 32 entries in the FIFO, though implementations
+ * can configure the IP to have a smaller FIFO.
+ */
+#define CDNS_MCP_IP_MAX_CMD_LEN		32
+
 /**
  * struct sdw_cdns_pdi: PDI (Physical Data Interface) instance
  *
@@ -114,7 +120,12 @@ struct sdw_cdns {
 	struct sdw_bus bus;
 	unsigned int instance;
 
-	u32 response_buf[0x80];
+	/*
+	 * The datasheet says the RX FIFO AVAIL can be 2 entries more
+	 * than the FIFO capacity, so allow for this.
+	 */
+	u32 response_buf[CDNS_MCP_IP_MAX_CMD_LEN + 2];
+
 	struct completion tx_complete;
 	struct sdw_defer *defer;
 
diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 9f356612ba7e..06c54d49076a 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1156,6 +1156,10 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 				ret = -EIO;
 				goto exit;
 			}
+			if (!xfer->cs_change) {
+				tegra_qspi_transfer_end(spi);
+				spi_transfer_delay_exec(xfer);
+			}
 			break;
 		default:
 			ret = -EINVAL;
@@ -1164,14 +1168,14 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 		msg->actual_length += xfer->len;
 		transfer_phase++;
 	}
-	if (!xfer->cs_change) {
-		tegra_qspi_transfer_end(spi);
-		spi_transfer_delay_exec(xfer);
-	}
 	ret = 0;
 
 exit:
 	msg->status = ret;
+	if (ret < 0) {
+		tegra_qspi_transfer_end(spi);
+		spi_transfer_delay_exec(xfer);
+	}
 
 	return ret;
 }
@@ -1297,7 +1301,7 @@ static bool tegra_qspi_validate_cmb_seq(struct tegra_qspi *tqspi,
 	if (xfer->len > 4 || xfer->len < 3)
 		return false;
 	xfer = list_next_entry(xfer, transfer_list);
-	if (!tqspi->soc_data->has_dma || xfer->len > (QSPI_FIFO_DEPTH << 2))
+	if (!tqspi->soc_data->has_dma && xfer->len > (QSPI_FIFO_DEPTH << 2))
 		return false;
 
 	return true;
diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index b6abd3770e81..edd20a03f7a2 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -2590,10 +2590,15 @@ static int nbu2ss_ep_queue(struct usb_ep *_ep,
 		req->unaligned = false;
 
 	if (req->unaligned) {
-		if (!ep->virt_buf)
+		if (!ep->virt_buf) {
 			ep->virt_buf = dma_alloc_coherent(udc->dev, PAGE_SIZE,
 							  &ep->phys_buf,
 							  GFP_ATOMIC | GFP_DMA);
+			if (!ep->virt_buf) {
+				spin_unlock_irqrestore(&udc->lock, flags);
+				return -ENOMEM;
+			}
+		}
 		if (ep->epnum > 0)  {
 			if (ep->direct == USB_DIR_IN)
 				memcpy(ep->virt_buf, req->req.buf,
diff --git a/drivers/staging/pi433/pi433_if.c b/drivers/staging/pi433/pi433_if.c
index d4e06a3929f3..b59f6a4cb611 100644
--- a/drivers/staging/pi433/pi433_if.c
+++ b/drivers/staging/pi433/pi433_if.c
@@ -55,6 +55,7 @@
 static dev_t pi433_dev;
 static DEFINE_IDR(pi433_idr);
 static DEFINE_MUTEX(minor_lock); /* Protect idr accesses */
+static struct dentry *root_dir;	/* debugfs root directory for the driver */
 
 static struct class *pi433_class; /* mainly for udev to create /dev/pi433 */
 
@@ -1306,8 +1307,7 @@ static int pi433_probe(struct spi_device *spi)
 	/* spi setup */
 	spi_set_drvdata(spi, device);
 
-	entry = debugfs_create_dir(dev_name(device->dev),
-				   debugfs_lookup(KBUILD_MODNAME, NULL));
+	entry = debugfs_create_dir(dev_name(device->dev), root_dir);
 	debugfs_create_file("regs", 0400, entry, device, &pi433_debugfs_regs_fops);
 
 	return 0;
@@ -1333,9 +1333,8 @@ static int pi433_probe(struct spi_device *spi)
 static void pi433_remove(struct spi_device *spi)
 {
 	struct pi433_device	*device = spi_get_drvdata(spi);
-	struct dentry *mod_entry = debugfs_lookup(KBUILD_MODNAME, NULL);
 
-	debugfs_remove(debugfs_lookup(dev_name(device->dev), mod_entry));
+	debugfs_lookup_and_remove(dev_name(device->dev), root_dir);
 
 	/* free GPIOs */
 	free_gpio(device);
@@ -1408,7 +1407,7 @@ static int __init pi433_init(void)
 		return PTR_ERR(pi433_class);
 	}
 
-	debugfs_create_dir(KBUILD_MODNAME, NULL);
+	root_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
 
 	status = spi_register_driver(&pi433_spi_driver);
 	if (status < 0) {
@@ -1427,7 +1426,7 @@ static void __exit pi433_exit(void)
 	spi_unregister_driver(&pi433_spi_driver);
 	class_destroy(pi433_class);
 	unregister_chrdev(MAJOR(pi433_dev), pi433_spi_driver.driver.name);
-	debugfs_remove_recursive(debugfs_lookup(KBUILD_MODNAME, NULL));
+	debugfs_remove(root_dir);
 }
 module_exit(pi433_exit);
 
diff --git a/drivers/thermal/intel/Kconfig b/drivers/thermal/intel/Kconfig
index f0c845679250..e3cfad10d5dd 100644
--- a/drivers/thermal/intel/Kconfig
+++ b/drivers/thermal/intel/Kconfig
@@ -64,7 +64,8 @@ endmenu
 
 config INTEL_BXT_PMIC_THERMAL
 	tristate "Intel Broxton PMIC thermal driver"
-	depends on X86 && INTEL_SOC_PMIC_BXTWC && REGMAP
+	depends on X86 && INTEL_SOC_PMIC_BXTWC
+	select REGMAP
 	help
 	  Select this driver for Intel Broxton PMIC with ADC channels monitoring
 	  system temperature measurements and alerts.
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 3eafc6b0e6c3..b43fbd5eaa6b 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -415,22 +415,14 @@ MODULE_DEVICE_TABLE(x86cpu, qrk_thermal_ids);
 
 static int __init intel_quark_thermal_init(void)
 {
-	int err = 0;
-
 	if (!x86_match_cpu(qrk_thermal_ids) || !iosf_mbi_available())
 		return -ENODEV;
 
 	soc_dts = alloc_soc_dts();
-	if (IS_ERR(soc_dts)) {
-		err = PTR_ERR(soc_dts);
-		goto err_free;
-	}
+	if (IS_ERR(soc_dts))
+		return PTR_ERR(soc_dts);
 
 	return 0;
-
-err_free:
-	free_soc_dts(soc_dts);
-	return err;
 }
 
 static void __exit intel_quark_thermal_exit(void)
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 13a6cd0116a1..f9d667ce1619 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1468,12 +1468,32 @@ static void lpuart_break_ctl(struct uart_port *port, int break_state)
 
 static void lpuart32_break_ctl(struct uart_port *port, int break_state)
 {
-	unsigned long temp;
+	unsigned long temp, modem;
+	struct tty_struct *tty;
+	unsigned int cflag = 0;
+
+	tty = tty_port_tty_get(&port->state->port);
+	if (tty) {
+		cflag = tty->termios.c_cflag;
+		tty_kref_put(tty);
+	}
 
 	temp = lpuart32_read(port, UARTCTRL) & ~UARTCTRL_SBK;
+	modem = lpuart32_read(port, UARTMODIR);
 
-	if (break_state != 0)
+	if (break_state != 0) {
 		temp |= UARTCTRL_SBK;
+		/*
+		 * LPUART CTS has higher priority than SBK, need to disable CTS before
+		 * asserting SBK to avoid any interference if flow control is enabled.
+		 */
+		if (cflag & CRTSCTS && modem & UARTMODIR_TXCTSE)
+			lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
+	} else {
+		/* Re-enable the CTS when break off. */
+		if (cflag & CRTSCTS && !(modem & UARTMODIR_TXCTSE))
+			lpuart32_write(port, modem | UARTMODIR_TXCTSE, UARTMODIR);
+	}
 
 	lpuart32_write(port, temp, UARTCTRL);
 }
diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 83f35b7b0897..abff1c6470f6 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1779,7 +1779,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	char name[32];
 
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
-	debugfs_remove(debugfs_lookup(name, NULL));
+	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
 	free_page((unsigned long)priv->rxbuf.buf);
 }
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 524921360ca7..93cf5f788817 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1426,25 +1426,6 @@ static int sc16is7xx_probe(struct device *dev,
 	}
 	sched_set_fifo(s->kworker_task);
 
-#ifdef CONFIG_GPIOLIB
-	if (devtype->nr_gpio) {
-		/* Setup GPIO cotroller */
-		s->gpio.owner		 = THIS_MODULE;
-		s->gpio.parent		 = dev;
-		s->gpio.label		 = dev_name(dev);
-		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
-		s->gpio.get		 = sc16is7xx_gpio_get;
-		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
-		s->gpio.set		 = sc16is7xx_gpio_set;
-		s->gpio.base		 = -1;
-		s->gpio.ngpio		 = devtype->nr_gpio;
-		s->gpio.can_sleep	 = 1;
-		ret = gpiochip_add_data(&s->gpio, s);
-		if (ret)
-			goto out_thread;
-	}
-#endif
-
 	/* reset device, purging any pending irq / data */
 	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG << SC16IS7XX_REG_SHIFT,
 			SC16IS7XX_IOCONTROL_SRESET_BIT);
@@ -1521,6 +1502,25 @@ static int sc16is7xx_probe(struct device *dev,
 				s->p[u].irda_mode = true;
 	}
 
+#ifdef CONFIG_GPIOLIB
+	if (devtype->nr_gpio) {
+		/* Setup GPIO cotroller */
+		s->gpio.owner		 = THIS_MODULE;
+		s->gpio.parent		 = dev;
+		s->gpio.label		 = dev_name(dev);
+		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
+		s->gpio.get		 = sc16is7xx_gpio_get;
+		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
+		s->gpio.set		 = sc16is7xx_gpio_set;
+		s->gpio.base		 = -1;
+		s->gpio.ngpio		 = devtype->nr_gpio;
+		s->gpio.can_sleep	 = 1;
+		ret = gpiochip_add_data(&s->gpio, s);
+		if (ret)
+			goto out_thread;
+	}
+#endif
+
 	/*
 	 * Setup interrupt. We first try to acquire the IRQ line as level IRQ.
 	 * If that succeeds, we can allow sharing the interrupt as well.
@@ -1540,18 +1540,19 @@ static int sc16is7xx_probe(struct device *dev,
 	if (!ret)
 		return 0;
 
-out_ports:
-	for (i--; i >= 0; i--) {
-		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
-	}
-
 #ifdef CONFIG_GPIOLIB
 	if (devtype->nr_gpio)
 		gpiochip_remove(&s->gpio);
 
 out_thread:
 #endif
+
+out_ports:
+	for (i--; i >= 0; i--) {
+		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
+		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
+	}
+
 	kthread_stop(s->kworker_task);
 
 out_clk:
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index de06c3c2ff70..1ac6784ea1f9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1224,14 +1224,16 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 {
 	struct tty_struct *tty;
 
-	if (driver->ops->lookup)
+	if (driver->ops->lookup) {
 		if (!file)
 			tty = ERR_PTR(-EIO);
 		else
 			tty = driver->ops->lookup(driver, file, idx);
-	else
+	} else {
+		if (idx >= driver->num)
+			return ERR_PTR(-EINVAL);
 		tty = driver->ttys[idx];
-
+	}
 	if (!IS_ERR(tty))
 		tty_kref_get(tty);
 	return tty;
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 71e091f879f0..1dc07f9214d5 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -415,10 +415,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 */
 		size = vcs_size(vc, attr, uni_mode);
 		if (size < 0) {
-			if (read)
-				break;
 			ret = size;
-			goto unlock_out;
+			break;
 		}
 		if (pos >= size)
 			break;
diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
index faf6b078b6c4..bbc610e5bd69 100644
--- a/drivers/usb/chipidea/debug.c
+++ b/drivers/usb/chipidea/debug.c
@@ -364,5 +364,5 @@ void dbg_create_files(struct ci_hdrc *ci)
  */
 void dbg_remove_files(struct ci_hdrc *ci)
 {
-	debugfs_remove(debugfs_lookup(dev_name(ci->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(ci->dev), usb_debug_root);
 }
diff --git a/drivers/usb/common/ulpi.c b/drivers/usb/common/ulpi.c
index d7c8461976ce..38703781ee2d 100644
--- a/drivers/usb/common/ulpi.c
+++ b/drivers/usb/common/ulpi.c
@@ -271,7 +271,7 @@ static int ulpi_regs_show(struct seq_file *seq, void *data)
 }
 DEFINE_SHOW_ATTRIBUTE(ulpi_regs);
 
-#define ULPI_ROOT debugfs_lookup(KBUILD_MODNAME, NULL)
+static struct dentry *ulpi_root;
 
 static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 {
@@ -301,7 +301,7 @@ static int ulpi_register(struct device *dev, struct ulpi *ulpi)
 		return ret;
 	}
 
-	root = debugfs_create_dir(dev_name(dev), ULPI_ROOT);
+	root = debugfs_create_dir(dev_name(dev), ulpi_root);
 	debugfs_create_file("regs", 0444, root, ulpi, &ulpi_regs_fops);
 
 	dev_dbg(&ulpi->dev, "registered ULPI PHY: vendor %04x, product %04x\n",
@@ -349,8 +349,7 @@ EXPORT_SYMBOL_GPL(ulpi_register_interface);
  */
 void ulpi_unregister_interface(struct ulpi *ulpi)
 {
-	debugfs_remove_recursive(debugfs_lookup(dev_name(&ulpi->dev),
-						ULPI_ROOT));
+	debugfs_lookup_and_remove(dev_name(&ulpi->dev), ulpi_root);
 	device_unregister(&ulpi->dev);
 }
 EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
@@ -360,12 +359,11 @@ EXPORT_SYMBOL_GPL(ulpi_unregister_interface);
 static int __init ulpi_init(void)
 {
 	int ret;
-	struct dentry *root;
 
-	root = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	ulpi_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
 	ret = bus_register(&ulpi_bus);
 	if (ret)
-		debugfs_remove(root);
+		debugfs_remove(ulpi_root);
 	return ret;
 }
 subsys_initcall(ulpi_init);
@@ -373,7 +371,7 @@ subsys_initcall(ulpi_init);
 static void __exit ulpi_exit(void)
 {
 	bus_unregister(&ulpi_bus);
-	debugfs_remove_recursive(ULPI_ROOT);
+	debugfs_remove(ulpi_root);
 }
 module_exit(ulpi_exit);
 
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 11b15d7b357a..a415206cab04 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -998,7 +998,7 @@ static void usb_debugfs_init(void)
 
 static void usb_debugfs_cleanup(void)
 {
-	debugfs_remove(debugfs_lookup("devices", usb_debug_root));
+	debugfs_lookup_and_remove("devices", usb_debug_root);
 }
 
 /*
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 8f9959ba9fd4..582ebd9cf9c2 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1117,6 +1117,7 @@ struct dwc3_scratchpad_array {
  *		     address.
  * @num_ep_resized: carries the current number endpoints which have had its tx
  *		    fifo resized.
+ * @debug_root: root debugfs directory for this device to put its files in.
  */
 struct dwc3 {
 	struct work_struct	drd_work;
@@ -1332,6 +1333,7 @@ struct dwc3 {
 	int			max_cfg_eps;
 	int			last_fifo_depth;
 	int			num_ep_resized;
+	struct dentry		*debug_root;
 };
 
 #define INCRX_BURST_MODE 0
diff --git a/drivers/usb/dwc3/debug.h b/drivers/usb/dwc3/debug.h
index 48b44b88dc25..8bb2c9e3b9ac 100644
--- a/drivers/usb/dwc3/debug.h
+++ b/drivers/usb/dwc3/debug.h
@@ -414,11 +414,14 @@ static inline const char *dwc3_gadget_generic_cmd_status_string(int status)
 
 #ifdef CONFIG_DEBUG_FS
 extern void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep);
+extern void dwc3_debugfs_remove_endpoint_dir(struct dwc3_ep *dep);
 extern void dwc3_debugfs_init(struct dwc3 *d);
 extern void dwc3_debugfs_exit(struct dwc3 *d);
 #else
 static inline void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
 {  }
+static inline void dwc3_debugfs_remove_endpoint_dir(struct dwc3_ep *dep)
+{  }
 static inline void dwc3_debugfs_init(struct dwc3 *d)
 {  }
 static inline void dwc3_debugfs_exit(struct dwc3 *d)
diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index f2b7675c7f62..850df0e6bcab 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -873,27 +873,23 @@ static const struct dwc3_ep_file_map dwc3_ep_file_map[] = {
 	{ "GDBGEPINFO", &dwc3_ep_info_register_fops, },
 };
 
-static void dwc3_debugfs_create_endpoint_files(struct dwc3_ep *dep,
-		struct dentry *parent)
+void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
 {
+	struct dentry		*dir;
 	int			i;
 
+	dir = debugfs_create_dir(dep->name, dep->dwc->debug_root);
 	for (i = 0; i < ARRAY_SIZE(dwc3_ep_file_map); i++) {
 		const struct file_operations *fops = dwc3_ep_file_map[i].fops;
 		const char *name = dwc3_ep_file_map[i].name;
 
-		debugfs_create_file(name, 0444, parent, dep, fops);
+		debugfs_create_file(name, 0444, dir, dep, fops);
 	}
 }
 
-void dwc3_debugfs_create_endpoint_dir(struct dwc3_ep *dep)
+void dwc3_debugfs_remove_endpoint_dir(struct dwc3_ep *dep)
 {
-	struct dentry		*dir;
-	struct dentry		*root;
-
-	root = debugfs_lookup(dev_name(dep->dwc->dev), usb_debug_root);
-	dir = debugfs_create_dir(dep->name, root);
-	dwc3_debugfs_create_endpoint_files(dep, dir);
+	debugfs_lookup_and_remove(dep->name, dep->dwc->debug_root);
 }
 
 void dwc3_debugfs_init(struct dwc3 *dwc)
@@ -911,6 +907,7 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 	dwc->regset->base = dwc->regs - DWC3_GLOBALS_REGS_START;
 
 	root = debugfs_create_dir(dev_name(dwc->dev), usb_debug_root);
+	dwc->debug_root = root;
 	debugfs_create_regset32("regdump", 0444, root, dwc->regset);
 	debugfs_create_file("lsp_dump", 0644, root, dwc, &dwc3_lsp_fops);
 
@@ -929,6 +926,6 @@ void dwc3_debugfs_init(struct dwc3 *dwc)
 
 void dwc3_debugfs_exit(struct dwc3 *dwc)
 {
-	debugfs_remove(debugfs_lookup(dev_name(dwc->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(dwc->dev), usb_debug_root);
 	kfree(dwc->regset);
 }
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index ed958da0e1c9..df1ce96fa228 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3184,9 +3184,7 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
 			list_del(&dep->endpoint.ep_list);
 		}
 
-		debugfs_remove_recursive(debugfs_lookup(dep->name,
-				debugfs_lookup(dev_name(dep->dwc->dev),
-					       usb_debug_root)));
+		dwc3_debugfs_remove_endpoint_dir(dep);
 		kfree(dep);
 	}
 }
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 4303a3283ba0..015a7bbd9bbf 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -483,11 +483,68 @@ UVC_ATTR_RO(uvcg_default_output_, cname, aname)
 UVCG_DEFAULT_OUTPUT_ATTR(b_terminal_id, bTerminalID, 8);
 UVCG_DEFAULT_OUTPUT_ATTR(w_terminal_type, wTerminalType, 16);
 UVCG_DEFAULT_OUTPUT_ATTR(b_assoc_terminal, bAssocTerminal, 8);
-UVCG_DEFAULT_OUTPUT_ATTR(b_source_id, bSourceID, 8);
 UVCG_DEFAULT_OUTPUT_ATTR(i_terminal, iTerminal, 8);
 
 #undef UVCG_DEFAULT_OUTPUT_ATTR
 
+static ssize_t uvcg_default_output_b_source_id_show(struct config_item *item,
+						    char *page)
+{
+	struct config_group *group = to_config_group(item);
+	struct f_uvc_opts *opts;
+	struct config_item *opts_item;
+	struct mutex *su_mutex = &group->cg_subsys->su_mutex;
+	struct uvc_output_terminal_descriptor *cd;
+	int result;
+
+	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
+
+	opts_item = group->cg_item.ci_parent->ci_parent->
+			ci_parent->ci_parent;
+	opts = to_f_uvc_opts(opts_item);
+	cd = &opts->uvc_output_terminal;
+
+	mutex_lock(&opts->lock);
+	result = sprintf(page, "%u\n", le8_to_cpu(cd->bSourceID));
+	mutex_unlock(&opts->lock);
+
+	mutex_unlock(su_mutex);
+
+	return result;
+}
+
+static ssize_t uvcg_default_output_b_source_id_store(struct config_item *item,
+						     const char *page, size_t len)
+{
+	struct config_group *group = to_config_group(item);
+	struct f_uvc_opts *opts;
+	struct config_item *opts_item;
+	struct mutex *su_mutex = &group->cg_subsys->su_mutex;
+	struct uvc_output_terminal_descriptor *cd;
+	int result;
+	u8 num;
+
+	result = kstrtou8(page, 0, &num);
+	if (result)
+		return result;
+
+	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
+
+	opts_item = group->cg_item.ci_parent->ci_parent->
+			ci_parent->ci_parent;
+	opts = to_f_uvc_opts(opts_item);
+	cd = &opts->uvc_output_terminal;
+
+	mutex_lock(&opts->lock);
+	cd->bSourceID = num;
+	mutex_unlock(&opts->lock);
+
+	mutex_unlock(su_mutex);
+
+	return len;
+}
+UVC_ATTR(uvcg_default_output_, b_source_id, bSourceID);
+
 static struct configfs_attribute *uvcg_default_output_attrs[] = {
 	&uvcg_default_output_attr_b_terminal_id,
 	&uvcg_default_output_attr_w_terminal_type,
diff --git a/drivers/usb/gadget/udc/bcm63xx_udc.c b/drivers/usb/gadget/udc/bcm63xx_udc.c
index d04d72f5816e..8d5892891300 100644
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -2258,7 +2258,7 @@ static void bcm63xx_udc_init_debugfs(struct bcm63xx_udc *udc)
  */
 static void bcm63xx_udc_cleanup_debugfs(struct bcm63xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(udc->gadget.name, usb_debug_root));
+	debugfs_lookup_and_remove(udc->gadget.name, usb_debug_root);
 }
 
 /***********************************************************************
diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 85cdc0af3bf9..09762559912d 100644
--- a/drivers/usb/gadget/udc/gr_udc.c
+++ b/drivers/usb/gadget/udc/gr_udc.c
@@ -215,7 +215,7 @@ static void gr_dfs_create(struct gr_udc *dev)
 
 static void gr_dfs_delete(struct gr_udc *dev)
 {
-	debugfs_remove(debugfs_lookup(dev_name(dev->dev), usb_debug_root));
+	debugfs_lookup_and_remove(dev_name(dev->dev), usb_debug_root);
 }
 
 #else /* !CONFIG_USB_GADGET_DEBUG_FS */
diff --git a/drivers/usb/gadget/udc/lpc32xx_udc.c b/drivers/usb/gadget/udc/lpc32xx_udc.c
index cea10cdb83ae..fe62db32dd0e 100644
--- a/drivers/usb/gadget/udc/lpc32xx_udc.c
+++ b/drivers/usb/gadget/udc/lpc32xx_udc.c
@@ -532,7 +532,7 @@ static void create_debug_file(struct lpc32xx_udc *udc)
 
 static void remove_debug_file(struct lpc32xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(debug_filename, NULL));
+	debugfs_lookup_and_remove(debug_filename, NULL);
 }
 
 #else
diff --git a/drivers/usb/gadget/udc/pxa25x_udc.c b/drivers/usb/gadget/udc/pxa25x_udc.c
index c593fc383481..9e01ddf2b417 100644
--- a/drivers/usb/gadget/udc/pxa25x_udc.c
+++ b/drivers/usb/gadget/udc/pxa25x_udc.c
@@ -1340,7 +1340,7 @@ DEFINE_SHOW_ATTRIBUTE(udc_debug);
 		debugfs_create_file(dev->gadget.name, \
 			S_IRUGO, NULL, dev, &udc_debug_fops); \
 	} while (0)
-#define remove_debug_files(dev) debugfs_remove(debugfs_lookup(dev->gadget.name, NULL))
+#define remove_debug_files(dev) debugfs_lookup_and_remove(dev->gadget.name, NULL)
 
 #else	/* !CONFIG_USB_GADGET_DEBUG_FILES */
 
diff --git a/drivers/usb/gadget/udc/pxa27x_udc.c b/drivers/usb/gadget/udc/pxa27x_udc.c
index ac980d6a4740..0ecdfd2ba9e9 100644
--- a/drivers/usb/gadget/udc/pxa27x_udc.c
+++ b/drivers/usb/gadget/udc/pxa27x_udc.c
@@ -215,7 +215,7 @@ static void pxa_init_debugfs(struct pxa_udc *udc)
 
 static void pxa_cleanup_debugfs(struct pxa_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(udc->gadget.name, usb_debug_root));
+	debugfs_lookup_and_remove(udc->gadget.name, usb_debug_root);
 }
 
 #else
diff --git a/drivers/usb/host/fotg210-hcd.c b/drivers/usb/host/fotg210-hcd.c
index 3d1dbcf4c073..c4c1fbc12b4c 100644
--- a/drivers/usb/host/fotg210-hcd.c
+++ b/drivers/usb/host/fotg210-hcd.c
@@ -862,7 +862,7 @@ static inline void remove_debug_files(struct fotg210_hcd *fotg210)
 {
 	struct usb_bus *bus = &fotg210_to_hcd(fotg210)->self;
 
-	debugfs_remove(debugfs_lookup(bus->bus_name, fotg210_debug_root));
+	debugfs_lookup_and_remove(bus->bus_name, fotg210_debug_root);
 }
 
 /* handshake - spin reading hc until handshake completes or fails
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 4f564d71bb0b..49ae01487af4 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1205,7 +1205,7 @@ static void create_debug_file(struct isp116x *isp116x)
 
 static void remove_debug_file(struct isp116x *isp116x)
 {
-	debugfs_remove(debugfs_lookup(hcd_name, usb_debug_root));
+	debugfs_lookup_and_remove(hcd_name, usb_debug_root);
 }
 
 #else
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 0e14d1d07709..b0da143ef4be 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2170,7 +2170,7 @@ static void create_debug_file(struct isp1362_hcd *isp1362_hcd)
 
 static void remove_debug_file(struct isp1362_hcd *isp1362_hcd)
 {
-	debugfs_remove(debugfs_lookup("isp1362", usb_debug_root));
+	debugfs_lookup_and_remove("isp1362", usb_debug_root);
 }
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index d206bd95c7bb..b8b90eec9107 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -1501,7 +1501,7 @@ static void create_debug_file(struct sl811 *sl811)
 
 static void remove_debug_file(struct sl811 *sl811)
 {
-	debugfs_remove(debugfs_lookup("sl811h", usb_debug_root));
+	debugfs_lookup_and_remove("sl811h", usb_debug_root);
 }
 
 /*-------------------------------------------------------------------------*/
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index c22b51af83fc..7cdc2fa7c28f 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -536,8 +536,8 @@ static void release_uhci(struct uhci_hcd *uhci)
 	uhci->is_initialized = 0;
 	spin_unlock_irq(&uhci->lock);
 
-	debugfs_remove(debugfs_lookup(uhci_to_hcd(uhci)->self.bus_name,
-				      uhci_debugfs_root));
+	debugfs_lookup_and_remove(uhci_to_hcd(uhci)->self.bus_name,
+				  uhci_debugfs_root);
 
 	for (i = 0; i < UHCI_NUM_SKELQH; i++)
 		uhci_free_qh(uhci, uhci->skelqh[i]);
@@ -700,7 +700,7 @@ static int uhci_start(struct usb_hcd *hcd)
 			uhci->frame, uhci->frame_dma_handle);
 
 err_alloc_frame:
-	debugfs_remove(debugfs_lookup(hcd->self.bus_name, uhci_debugfs_root));
+	debugfs_lookup_and_remove(hcd->self.bus_name, uhci_debugfs_root);
 
 	return retval;
 }
diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 60651a50770f..87f1597a0e5a 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -32,7 +32,7 @@ static void xhci_mvebu_mbus_config(void __iomem *base,
 
 	/* Program each DRAM CS in a seperate window */
 	for (win = 0; win < dram->num_cs; win++) {
-		const struct mbus_dram_window *cs = dram->cs + win;
+		const struct mbus_dram_window *cs = &dram->cs[win];
 
 		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
 		       (dram->mbus_dram_target_id << 4) | 1,
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 6012603f3630..97c66c0d91f4 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -939,7 +939,7 @@ static int ms_lib_process_bootblock(struct us_data *us, u16 PhyBlock, u8 *PageDa
 	struct ms_lib_type_extdat ExtraData;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	PageBuffer = kzalloc(MS_BYTES_PER_PAGE * 2, GFP_KERNEL);
 	if (PageBuffer == NULL)
 		return (u32)-1;
 
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
index 3e4486bfa0b7..3ec5ca3aefe1 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -10,11 +10,6 @@
 
 #include "ifcvf_base.h"
 
-struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw)
-{
-	return container_of(hw, struct ifcvf_adapter, vf);
-}
-
 u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector)
 {
 	struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
@@ -37,8 +32,6 @@ u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector)
 static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 				  struct virtio_pci_cap *cap)
 {
-	struct ifcvf_adapter *ifcvf;
-	struct pci_dev *pdev;
 	u32 length, offset;
 	u8 bar;
 
@@ -46,17 +39,14 @@ static void __iomem *get_cap_addr(struct ifcvf_hw *hw,
 	offset = le32_to_cpu(cap->offset);
 	bar = cap->bar;
 
-	ifcvf= vf_to_adapter(hw);
-	pdev = ifcvf->pdev;
-
 	if (bar >= IFCVF_PCI_MAX_RESOURCE) {
-		IFCVF_DBG(pdev,
+		IFCVF_DBG(hw->pdev,
 			  "Invalid bar number %u to get capabilities\n", bar);
 		return NULL;
 	}
 
-	if (offset + length > pci_resource_len(pdev, bar)) {
-		IFCVF_DBG(pdev,
+	if (offset + length > pci_resource_len(hw->pdev, bar)) {
+		IFCVF_DBG(hw->pdev,
 			  "offset(%u) + len(%u) overflows bar%u's capability\n",
 			  offset, length, bar);
 		return NULL;
@@ -92,6 +82,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
 		IFCVF_ERR(pdev, "Failed to read PCI capability list\n");
 		return -EIO;
 	}
+	hw->pdev = pdev;
 
 	while (pos) {
 		ret = ifcvf_read_config_range(pdev, (u32 *)&cap,
@@ -220,10 +211,8 @@ u64 ifcvf_get_features(struct ifcvf_hw *hw)
 
 int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
 {
-	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
-
 	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
-		IFCVF_ERR(ifcvf->pdev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
+		IFCVF_ERR(hw->pdev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
 		return -EINVAL;
 	}
 
@@ -232,13 +221,11 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
 
 u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
 {
-	struct ifcvf_adapter *adapter;
 	u32 net_config_size = sizeof(struct virtio_net_config);
 	u32 blk_config_size = sizeof(struct virtio_blk_config);
 	u32 cap_size = hw->cap_dev_config_size;
 	u32 config_size;
 
-	adapter = vf_to_adapter(hw);
 	/* If the onboard device config space size is greater than
 	 * the size of struct virtio_net/blk_config, only the spec
 	 * implementing contents size is returned, this is very
@@ -253,7 +240,7 @@ u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
 		break;
 	default:
 		config_size = 0;
-		IFCVF_ERR(adapter->pdev, "VIRTIO ID %u not supported\n", hw->dev_type);
+		IFCVF_ERR(hw->pdev, "VIRTIO ID %u not supported\n", hw->dev_type);
 	}
 
 	return config_size;
@@ -301,14 +288,11 @@ static void ifcvf_set_features(struct ifcvf_hw *hw, u64 features)
 
 static int ifcvf_config_features(struct ifcvf_hw *hw)
 {
-	struct ifcvf_adapter *ifcvf;
-
-	ifcvf = vf_to_adapter(hw);
 	ifcvf_set_features(hw, hw->req_features);
 	ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
 
 	if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
-		IFCVF_ERR(ifcvf->pdev, "Failed to set FEATURES_OK status\n");
+		IFCVF_ERR(hw->pdev, "Failed to set FEATURES_OK status\n");
 		return -EIO;
 	}
 
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index f5563f665cc6..25bd4e927b27 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -39,7 +39,7 @@
 #define IFCVF_INFO(pdev, fmt, ...)	dev_info(&pdev->dev, fmt, ##__VA_ARGS__)
 
 #define ifcvf_private_to_vf(adapter) \
-	(&((struct ifcvf_adapter *)adapter)->vf)
+	(((struct ifcvf_adapter *)adapter)->vf)
 
 /* all vqs and config interrupt has its own vector */
 #define MSIX_VECTOR_PER_VQ_AND_CONFIG		1
@@ -89,12 +89,13 @@ struct ifcvf_hw {
 	u16 nr_vring;
 	/* VIRTIO_PCI_CAP_DEVICE_CFG size */
 	u32 cap_dev_config_size;
+	struct pci_dev *pdev;
 };
 
 struct ifcvf_adapter {
 	struct vdpa_device vdpa;
 	struct pci_dev *pdev;
-	struct ifcvf_hw vf;
+	struct ifcvf_hw *vf;
 };
 
 struct ifcvf_vring_lm_cfg {
@@ -109,6 +110,7 @@ struct ifcvf_lm_cfg {
 
 struct ifcvf_vdpa_mgmt_dev {
 	struct vdpa_mgmt_dev mdev;
+	struct ifcvf_hw vf;
 	struct ifcvf_adapter *adapter;
 	struct pci_dev *pdev;
 };
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index 44b29289aa19..d5036f49f161 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -69,10 +69,9 @@ static void ifcvf_free_irq_vectors(void *data)
 	pci_free_irq_vectors(data);
 }
 
-static void ifcvf_free_per_vq_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_per_vq_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i;
 
 	for (i = 0; i < vf->nr_vring; i++) {
@@ -83,10 +82,9 @@ static void ifcvf_free_per_vq_irq(struct ifcvf_adapter *adapter)
 	}
 }
 
-static void ifcvf_free_vqs_reused_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_vqs_reused_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	if (vf->vqs_reused_irq != -EINVAL) {
 		devm_free_irq(&pdev->dev, vf->vqs_reused_irq, vf);
@@ -95,20 +93,17 @@ static void ifcvf_free_vqs_reused_irq(struct ifcvf_adapter *adapter)
 
 }
 
-static void ifcvf_free_vq_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_vq_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
-
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		ifcvf_free_per_vq_irq(adapter);
+		ifcvf_free_per_vq_irq(vf);
 	else
-		ifcvf_free_vqs_reused_irq(adapter);
+		ifcvf_free_vqs_reused_irq(vf);
 }
 
-static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_config_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	if (vf->config_irq == -EINVAL)
 		return;
@@ -123,12 +118,12 @@ static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
 	}
 }
 
-static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
+	struct pci_dev *pdev = vf->pdev;
 
-	ifcvf_free_vq_irq(adapter);
-	ifcvf_free_config_irq(adapter);
+	ifcvf_free_vq_irq(vf);
+	ifcvf_free_config_irq(vf);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -137,10 +132,9 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
  * It returns the number of allocated vectors, negative
  * return value when fails.
  */
-static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
+static int ifcvf_alloc_vectors(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int max_intr, ret;
 
 	/* all queues and config interrupt  */
@@ -160,10 +154,9 @@ static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
 	return ret;
 }
 
-static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_per_vq_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vf->vqs_reused_irq = -EINVAL;
@@ -190,15 +183,14 @@ static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
 
-static int ifcvf_request_vqs_reused_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vqs_reused_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vector = 0;
@@ -224,15 +216,14 @@ static int ifcvf_request_vqs_reused_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
 
-static int ifcvf_request_dev_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_dev_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vector = 0;
@@ -265,29 +256,27 @@ static int ifcvf_request_dev_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 
 }
 
-static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vq_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
 	int ret;
 
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		ret = ifcvf_request_per_vq_irq(adapter);
+		ret = ifcvf_request_per_vq_irq(vf);
 	else
-		ret = ifcvf_request_vqs_reused_irq(adapter);
+		ret = ifcvf_request_vqs_reused_irq(vf);
 
 	return ret;
 }
 
-static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_config_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int config_vector, ret;
 
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
@@ -320,17 +309,16 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
 
-static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
 	int nvectors, ret, max_intr;
 
-	nvectors = ifcvf_alloc_vectors(adapter);
+	nvectors = ifcvf_alloc_vectors(vf);
 	if (nvectors <= 0)
 		return -EFAULT;
 
@@ -341,16 +329,16 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
 
 	if (nvectors == 1) {
 		vf->msix_vector_status = MSIX_VECTOR_DEV_SHARED;
-		ret = ifcvf_request_dev_irq(adapter);
+		ret = ifcvf_request_dev_irq(vf);
 
 		return ret;
 	}
 
-	ret = ifcvf_request_vq_irq(adapter);
+	ret = ifcvf_request_vq_irq(vf);
 	if (ret)
 		return ret;
 
-	ret = ifcvf_request_config_irq(adapter);
+	ret = ifcvf_request_config_irq(vf);
 
 	if (ret)
 		return ret;
@@ -414,7 +402,7 @@ static struct ifcvf_hw *vdpa_to_vf(struct vdpa_device *vdpa_dev)
 {
 	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
 
-	return &adapter->vf;
+	return adapter->vf;
 }
 
 static u64 ifcvf_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
@@ -479,7 +467,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
 
 	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
 	    !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
-		ret = ifcvf_request_irq(adapter);
+		ret = ifcvf_request_irq(vf);
 		if (ret) {
 			status = ifcvf_get_status(vf);
 			status |= VIRTIO_CONFIG_S_FAILED;
@@ -511,7 +499,7 @@ static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
 
 	if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
 		ifcvf_stop_datapath(adapter);
-		ifcvf_free_irq(adapter);
+		ifcvf_free_irq(vf);
 	}
 
 	ifcvf_reset_vring(adapter);
@@ -758,12 +746,20 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	int ret;
 
 	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
-	if (!ifcvf_mgmt_dev->adapter)
-		return -EOPNOTSUPP;
+	vf = &ifcvf_mgmt_dev->vf;
+	pdev = vf->pdev;
+	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
+				    &pdev->dev, &ifc_vdpa_ops, 1, 1, NULL, false);
+	if (IS_ERR(adapter)) {
+		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
+		return PTR_ERR(adapter);
+	}
 
-	adapter = ifcvf_mgmt_dev->adapter;
-	vf = &adapter->vf;
-	pdev = adapter->pdev;
+	ifcvf_mgmt_dev->adapter = adapter;
+	adapter->pdev = pdev;
+	adapter->vdpa.dma_dev = &pdev->dev;
+	adapter->vdpa.mdev = mdev;
+	adapter->vf = vf;
 	vdpa_dev = &adapter->vdpa;
 
 	if (name)
@@ -781,7 +777,6 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	return 0;
 }
 
-
 static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
@@ -800,7 +795,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 	struct device *dev = &pdev->dev;
-	struct ifcvf_adapter *adapter;
 	struct ifcvf_hw *vf;
 	u32 dev_type;
 	int ret, i;
@@ -831,20 +825,16 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	pci_set_master(pdev);
-
-	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, 1, 1, NULL, false);
-	if (IS_ERR(adapter)) {
-		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
-		return PTR_ERR(adapter);
+	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
+	if (!ifcvf_mgmt_dev) {
+		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
+		return -ENOMEM;
 	}
 
-	vf = &adapter->vf;
+	vf = &ifcvf_mgmt_dev->vf;
 	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
-
-	adapter->pdev = pdev;
-	adapter->vdpa.dma_dev = &pdev->dev;
+	vf->pdev = pdev;
 
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
@@ -858,16 +848,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	vf->hw_features = ifcvf_get_hw_features(vf);
 	vf->config_size = ifcvf_get_config_size(vf);
 
-	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
-	if (!ifcvf_mgmt_dev) {
-		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
-		return -ENOMEM;
-	}
-
-	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
-	ifcvf_mgmt_dev->mdev.device = dev;
-	ifcvf_mgmt_dev->adapter = adapter;
-
 	dev_type = get_dev_type(pdev);
 	switch (dev_type) {
 	case VIRTIO_ID_NET:
@@ -882,12 +862,11 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 
+	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
+	ifcvf_mgmt_dev->mdev.device = dev;
 	ifcvf_mgmt_dev->mdev.max_supported_vqs = vf->nr_vring;
 	ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
 
-	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
-
-
 	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
 	if (ret) {
 		IFCVF_ERR(pdev,
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 292b5a1ca831..fed7be246442 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -206,10 +206,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
 
 	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
-		err = request_irq(wdt->irq, wdt_interrupt,
-				  IRQF_SHARED | IRQF_IRQPOLL |
-				  IRQF_NO_SUSPEND,
-				  pdev->name, wdt);
+		err = devm_request_irq(dev, wdt->irq, wdt_interrupt,
+				       IRQF_SHARED | IRQF_IRQPOLL | IRQF_NO_SUSPEND,
+				       pdev->name, wdt);
 		if (err)
 			return err;
 	}
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index 1bdaf17c1d38..8202f0a6b093 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -325,7 +325,8 @@ static int usb_pcwd_set_heartbeat(struct usb_pcwd_private *usb_pcwd, int t)
 static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 							int *temperature)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	usb_pcwd_send_command(usb_pcwd, CMD_READ_TEMP, &msb, &lsb);
 
@@ -341,7 +342,8 @@ static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd,
 								int *time_left)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	/* Read the time that's left before rebooting */
 	/* Note: if the board is not yet armed then we will read 0xFFFF */
diff --git a/drivers/watchdog/rzg2l_wdt.c b/drivers/watchdog/rzg2l_wdt.c
index 974a4194a8fd..d404953d0e0f 100644
--- a/drivers/watchdog/rzg2l_wdt.c
+++ b/drivers/watchdog/rzg2l_wdt.c
@@ -8,6 +8,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -35,6 +36,8 @@
 
 #define F2CYCLE_NSEC(f)			(1000000000 / (f))
 
+#define RZV2M_A_NSEC			730
+
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
 MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
@@ -51,11 +54,35 @@ struct rzg2l_wdt_priv {
 	struct reset_control *rstc;
 	unsigned long osc_clk_rate;
 	unsigned long delay;
+	unsigned long minimum_assertion_period;
 	struct clk *pclk;
 	struct clk *osc_clk;
 	enum rz_wdt_type devtype;
 };
 
+static int rzg2l_wdt_reset(struct rzg2l_wdt_priv *priv)
+{
+	int err, status;
+
+	if (priv->devtype == WDT_RZV2M) {
+		/* WDT needs TYPE-B reset control */
+		err = reset_control_assert(priv->rstc);
+		if (err)
+			return err;
+		ndelay(priv->minimum_assertion_period);
+		err = reset_control_deassert(priv->rstc);
+		if (err)
+			return err;
+		err = read_poll_timeout(reset_control_status, status,
+					status != 1, 0, 1000, false,
+					priv->rstc);
+	} else {
+		err = reset_control_reset(priv->rstc);
+	}
+
+	return err;
+}
+
 static void rzg2l_wdt_wait_delay(struct rzg2l_wdt_priv *priv)
 {
 	/* delay timer when change the setting register */
@@ -115,25 +142,23 @@ static int rzg2l_wdt_stop(struct watchdog_device *wdev)
 {
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
+	rzg2l_wdt_reset(priv);
 	pm_runtime_put(wdev->parent);
-	reset_control_reset(priv->rstc);
 
 	return 0;
 }
 
 static int rzg2l_wdt_set_timeout(struct watchdog_device *wdev, unsigned int timeout)
 {
-	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
-
 	wdev->timeout = timeout;
 
 	/*
 	 * If the watchdog is active, reset the module for updating the WDTSET
-	 * register so that it is updated with new timeout values.
+	 * register by calling rzg2l_wdt_stop() (which internally calls reset_control_reset()
+	 * to reset the module) so that it is updated with new timeout values.
 	 */
 	if (watchdog_active(wdev)) {
-		pm_runtime_put(wdev->parent);
-		reset_control_reset(priv->rstc);
+		rzg2l_wdt_stop(wdev);
 		rzg2l_wdt_start(wdev);
 	}
 
@@ -156,6 +181,7 @@ static int rzg2l_wdt_restart(struct watchdog_device *wdev,
 		rzg2l_wdt_write(priv, PEEN_FORCE, PEEN);
 	} else {
 		/* RZ/V2M doesn't have parity error registers */
+		rzg2l_wdt_reset(priv);
 
 		wdev->timeout = 0;
 
@@ -253,6 +279,13 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 
 	priv->devtype = (uintptr_t)of_device_get_match_data(dev);
 
+	if (priv->devtype == WDT_RZV2M) {
+		priv->minimum_assertion_period = RZV2M_A_NSEC +
+			3 * F2CYCLE_NSEC(pclk_rate) + 5 *
+			max(F2CYCLE_NSEC(priv->osc_clk_rate),
+			    F2CYCLE_NSEC(pclk_rate));
+	}
+
 	pm_runtime_enable(&pdev->dev);
 
 	priv->wdev.info = &rzg2l_wdt_ident;
diff --git a/drivers/watchdog/sbsa_gwdt.c b/drivers/watchdog/sbsa_gwdt.c
index 9791c74aebd4..63862803421f 100644
--- a/drivers/watchdog/sbsa_gwdt.c
+++ b/drivers/watchdog/sbsa_gwdt.c
@@ -150,6 +150,7 @@ static int sbsa_gwdt_set_timeout(struct watchdog_device *wdd,
 	struct sbsa_gwdt *gwdt = watchdog_get_drvdata(wdd);
 
 	wdd->timeout = timeout;
+	timeout = clamp_t(unsigned int, timeout, 1, wdd->max_hw_heartbeat_ms / 1000);
 
 	if (action)
 		sbsa_gwdt_reg_write(gwdt->clk * timeout, gwdt);
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 55574ed42504..fdffa6859dde 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1061,8 +1061,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			put_device(&wd_data->dev);
 		}
+		put_device(&wd_data->dev);
 		return err;
 	}
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4e739902dc03..a2bc440743ae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1529,6 +1529,7 @@ struct ext4_sb_info {
 	unsigned int s_mount_opt2;
 	unsigned long s_mount_flags;
 	unsigned int s_def_mount_opt;
+	unsigned int s_def_mount_opt2;
 	ext4_fsblk_t s_sb_block;
 	atomic64_t s_resv_clusters;
 	kuid_t s_resuid;
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 7ed71c652f67..1110bfa0a5b7 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1354,8 +1354,14 @@ struct dentry_info_args {
 	char *dname;
 };
 
+/* Same as struct ext4_fc_tl, but uses native endianness fields */
+struct ext4_fc_tl_mem {
+	u16 fc_tag;
+	u16 fc_len;
+};
+
 static inline void tl_to_darg(struct dentry_info_args *darg,
-			      struct ext4_fc_tl *tl, u8 *val)
+			      struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_dentry_info fcd;
 
@@ -1367,16 +1373,18 @@ static inline void tl_to_darg(struct dentry_info_args *darg,
 	darg->dname_len = tl->fc_len - sizeof(struct ext4_fc_dentry_info);
 }
 
-static inline void ext4_fc_get_tl(struct ext4_fc_tl *tl, u8 *val)
+static inline void ext4_fc_get_tl(struct ext4_fc_tl_mem *tl, u8 *val)
 {
-	memcpy(tl, val, EXT4_FC_TAG_BASE_LEN);
-	tl->fc_len = le16_to_cpu(tl->fc_len);
-	tl->fc_tag = le16_to_cpu(tl->fc_tag);
+	struct ext4_fc_tl tl_disk;
+
+	memcpy(&tl_disk, val, EXT4_FC_TAG_BASE_LEN);
+	tl->fc_len = le16_to_cpu(tl_disk.fc_len);
+	tl->fc_tag = le16_to_cpu(tl_disk.fc_tag);
 }
 
 /* Unlink replay function */
-static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl,
-				 u8 *val)
+static int ext4_fc_replay_unlink(struct super_block *sb,
+				 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode, *old_parent;
 	struct qstr entry;
@@ -1473,8 +1481,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 }
 
 /* Link replay function */
-static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl,
-			       u8 *val)
+static int ext4_fc_replay_link(struct super_block *sb,
+			       struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct dentry_info_args darg;
@@ -1528,8 +1536,8 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
 /*
  * Inode replay function
  */
-static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
-				u8 *val)
+static int ext4_fc_replay_inode(struct super_block *sb,
+				struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_inode fc_inode;
 	struct ext4_inode *raw_inode;
@@ -1631,8 +1639,8 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
  * inode for which we are trying to create a dentry here, should already have
  * been replayed before we start here.
  */
-static int ext4_fc_replay_create(struct super_block *sb, struct ext4_fc_tl *tl,
-				 u8 *val)
+static int ext4_fc_replay_create(struct super_block *sb,
+				 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	int ret = 0;
 	struct inode *inode = NULL;
@@ -1730,7 +1738,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 
 /* Replay add range tag */
 static int ext4_fc_replay_add_range(struct super_block *sb,
-				    struct ext4_fc_tl *tl, u8 *val)
+				    struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_add_range fc_add_ex;
 	struct ext4_extent newex, *ex;
@@ -1850,8 +1858,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 /* Replay DEL_RANGE tag */
 static int
-ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
-			 u8 *val)
+ext4_fc_replay_del_range(struct super_block *sb,
+			 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct ext4_fc_del_range lrange;
@@ -2047,7 +2055,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	struct ext4_fc_replay_state *state;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_add_range ext;
-	struct ext4_fc_tl tl;
+	struct ext4_fc_tl_mem tl;
 	struct ext4_fc_tail tail;
 	__u8 *start, *end, *cur, *val;
 	struct ext4_fc_head head;
@@ -2166,7 +2174,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_fc_tl tl;
+	struct ext4_fc_tl_mem tl;
 	__u8 *start, *end, *cur, *val;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_replay_state *state = &sbi->s_fc_replay_state;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index aa4f65663fad..801160099958 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2146,7 +2146,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		return 0;
 	case Opt_commit:
 		if (result.uint_32 == 0)
-			ctx->s_commit_interval = JBD2_DEFAULT_MAX_COMMIT_AGE;
+			result.uint_32 = JBD2_DEFAULT_MAX_COMMIT_AGE;
 		else if (result.uint_32 > INT_MAX / HZ) {
 			ext4_msg(NULL, KERN_ERR,
 				 "Invalid commit interval %d, "
@@ -2894,7 +2894,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	int def_errors, def_mount_opt = sbi->s_def_mount_opt;
+	int def_errors;
 	const struct mount_opts *m;
 	char sep = nodefs ? '\n' : ',';
 
@@ -2906,15 +2906,28 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 
 	for (m = ext4_mount_opts; m->token != Opt_err; m++) {
 		int want_set = m->flags & MOPT_SET;
+		int opt_2 = m->flags & MOPT_2;
+		unsigned int mount_opt, def_mount_opt;
+
 		if (((m->flags & (MOPT_SET|MOPT_CLEAR)) == 0) ||
 		    m->flags & MOPT_SKIP)
 			continue;
-		if (!nodefs && !(m->mount_opt & (sbi->s_mount_opt ^ def_mount_opt)))
-			continue; /* skip if same as the default */
+
+		if (opt_2) {
+			mount_opt = sbi->s_mount_opt2;
+			def_mount_opt = sbi->s_def_mount_opt2;
+		} else {
+			mount_opt = sbi->s_mount_opt;
+			def_mount_opt = sbi->s_def_mount_opt;
+		}
+		/* skip if same as the default */
+		if (!nodefs && !(m->mount_opt & (mount_opt ^ def_mount_opt)))
+			continue;
+		/* select Opt_noFoo vs Opt_Foo */
 		if ((want_set &&
-		     (sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
-		    (!want_set && (sbi->s_mount_opt & m->mount_opt)))
-			continue; /* select Opt_noFoo vs Opt_Foo */
+		     (mount_opt & m->mount_opt) != m->mount_opt) ||
+		    (!want_set && (mount_opt & m->mount_opt)))
+			continue;
 		SEQ_OPTS_PRINT("%s", token2str(m->token));
 	}
 
@@ -2942,7 +2955,7 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 	if (nodefs || sbi->s_stripe)
 		SEQ_OPTS_PRINT("stripe=%lu", sbi->s_stripe);
 	if (nodefs || EXT4_MOUNT_DATA_FLAGS &
-			(sbi->s_mount_opt ^ def_mount_opt)) {
+			(sbi->s_mount_opt ^ sbi->s_def_mount_opt)) {
 		if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_JOURNAL_DATA)
 			SEQ_OPTS_PUTS("data=journal");
 		else if (test_opt(sb, DATA_FLAGS) == EXT4_MOUNT_ORDERED_DATA)
@@ -5087,6 +5100,7 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount;
 
 	sbi->s_def_mount_opt = sbi->s_mount_opt;
+	sbi->s_def_mount_opt2 = sbi->s_mount_opt2;
 
 	err = ext4_check_opt_consistency(fc, sb);
 	if (err < 0)
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 5f4519af9821..f92899bfcbd5 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -4138,20 +4138,24 @@ static int f2fs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
 	 */
 	map.m_len = fscrypt_limit_io_blocks(inode, map.m_lblk, map.m_len);
 
-	if (map.m_flags & (F2FS_MAP_MAPPED | F2FS_MAP_UNWRITTEN)) {
-		iomap->length = blks_to_bytes(inode, map.m_len);
-		if (map.m_flags & F2FS_MAP_MAPPED) {
-			iomap->type = IOMAP_MAPPED;
-			iomap->flags |= IOMAP_F_MERGED;
-		} else {
-			iomap->type = IOMAP_UNWRITTEN;
-		}
-		if (WARN_ON_ONCE(!__is_valid_data_blkaddr(map.m_pblk)))
-			return -EINVAL;
+	/*
+	 * We should never see delalloc or compressed extents here based on
+	 * prior flushing and checks.
+	 */
+	if (WARN_ON_ONCE(map.m_pblk == NEW_ADDR))
+		return -EINVAL;
+	if (WARN_ON_ONCE(map.m_pblk == COMPRESS_ADDR))
+		return -EINVAL;
 
+	if (map.m_pblk != NULL_ADDR) {
+		iomap->length = blks_to_bytes(inode, map.m_len);
+		iomap->type = IOMAP_MAPPED;
+		iomap->flags |= IOMAP_F_MERGED;
 		iomap->bdev = map.m_bdev;
 		iomap->addr = blks_to_bytes(inode, map.m_pblk);
 	} else {
+		if (flags & IOMAP_WRITE)
+			return -ENOTBLK;
 		iomap->length = blks_to_bytes(inode, next_pgofs) -
 				iomap->offset;
 		iomap->type = IOMAP_HOLE;
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 8b9f0b3c7723..87664c309b3c 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -764,6 +764,7 @@ enum {
 	FI_COMPRESS_RELEASED,	/* compressed blocks were released */
 	FI_ALIGNED_WRITE,	/* enable aligned write */
 	FI_COW_FILE,		/* indicate COW file */
+	FI_ATOMIC_COMMITTED,	/* indicate atomic commit completed except disk sync */
 	FI_MAX,			/* max flag, never be used */
 };
 
@@ -822,6 +823,7 @@ struct f2fs_inode_info {
 	unsigned int i_cluster_size;		/* cluster size */
 
 	unsigned int atomic_write_cnt;
+	loff_t original_i_size;		/* original i_size before atomic write */
 };
 
 static inline void get_extent_info(struct extent_info *ext,
@@ -3072,6 +3074,8 @@ static inline void f2fs_i_blocks_write(struct inode *inode,
 		set_inode_flag(inode, FI_AUTO_RECOVER);
 }
 
+static inline bool f2fs_is_atomic_file(struct inode *inode);
+
 static inline void f2fs_i_size_write(struct inode *inode, loff_t i_size)
 {
 	bool clean = !is_inode_flag_set(inode, FI_DIRTY_INODE);
@@ -3081,6 +3085,10 @@ static inline void f2fs_i_size_write(struct inode *inode, loff_t i_size)
 		return;
 
 	i_size_write(inode, i_size);
+
+	if (f2fs_is_atomic_file(inode))
+		return;
+
 	f2fs_mark_inode_dirty_sync(inode, true);
 	if (clean || recover)
 		set_inode_flag(inode, FI_AUTO_RECOVER);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index f96bbfa8b399..773b3ddc2cd7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1865,7 +1865,10 @@ static int f2fs_release_file(struct inode *inode, struct file *filp)
 			atomic_read(&inode->i_writecount) != 1)
 		return 0;
 
+	inode_lock(inode);
 	f2fs_abort_atomic_write(inode, true);
+	inode_unlock(inode);
+
 	return 0;
 }
 
@@ -1879,8 +1882,13 @@ static int f2fs_file_flush(struct file *file, fl_owner_t id)
 	 * until all the writers close its file. Since this should be done
 	 * before dropping file lock, it needs to do in ->flush.
 	 */
-	if (F2FS_I(inode)->atomic_write_task == current)
+	if (F2FS_I(inode)->atomic_write_task == current &&
+				(current->flags & PF_EXITING)) {
+		inode_lock(inode);
 		f2fs_abort_atomic_write(inode, true);
+		inode_unlock(inode);
+	}
+
 	return 0;
 }
 
@@ -2041,6 +2049,7 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	struct f2fs_inode_info *fi = F2FS_I(inode);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct inode *pinode;
+	loff_t isize;
 	int ret;
 
 	if (!inode_owner_or_capable(mnt_userns, inode))
@@ -2085,27 +2094,39 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 		goto out;
 	}
 
-	/* Create a COW inode for atomic write */
-	pinode = f2fs_iget(inode->i_sb, fi->i_pino);
-	if (IS_ERR(pinode)) {
-		f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-		ret = PTR_ERR(pinode);
-		goto out;
-	}
+	/* Check if the inode already has a COW inode */
+	if (fi->cow_inode == NULL) {
+		/* Create a COW inode for atomic write */
+		pinode = f2fs_iget(inode->i_sb, fi->i_pino);
+		if (IS_ERR(pinode)) {
+			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
+			ret = PTR_ERR(pinode);
+			goto out;
+		}
 
-	ret = f2fs_get_tmpfile(mnt_userns, pinode, &fi->cow_inode);
-	iput(pinode);
-	if (ret) {
-		f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-		goto out;
+		ret = f2fs_get_tmpfile(mnt_userns, pinode, &fi->cow_inode);
+		iput(pinode);
+		if (ret) {
+			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
+			goto out;
+		}
+
+		set_inode_flag(fi->cow_inode, FI_COW_FILE);
+		clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
+	} else {
+		/* Reuse the already created COW inode */
+		f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
 	}
-	f2fs_i_size_write(fi->cow_inode, i_size_read(inode));
+
+	f2fs_write_inode(inode, NULL);
+
+	isize = i_size_read(inode);
+	fi->original_i_size = isize;
+	f2fs_i_size_write(fi->cow_inode, isize);
 
 	stat_inc_atomic_inode(inode);
 
 	set_inode_flag(inode, FI_ATOMIC_FILE);
-	set_inode_flag(fi->cow_inode, FI_COW_FILE);
-	clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
 	f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 
 	f2fs_update_time(sbi, REQ_TIME);
@@ -2137,16 +2158,14 @@ static int f2fs_ioc_commit_atomic_write(struct file *filp)
 
 	if (f2fs_is_atomic_file(inode)) {
 		ret = f2fs_commit_atomic_write(inode);
-		if (ret)
-			goto unlock_out;
-
-		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 0, true);
 		if (!ret)
-			f2fs_abort_atomic_write(inode, false);
+			ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 0, true);
+
+		f2fs_abort_atomic_write(inode, ret);
 	} else {
 		ret = f2fs_do_sync_file(filp, 0, LLONG_MAX, 1, false);
 	}
-unlock_out:
+
 	inode_unlock(inode);
 	mnt_drop_write_file(filp);
 	return ret;
@@ -2326,6 +2345,7 @@ static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
 {
 	struct inode *inode = file_inode(filp);
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
+	u8 encrypt_pw_salt[16];
 	int err;
 
 	if (!f2fs_sb_has_encrypt(sbi))
@@ -2350,12 +2370,14 @@ static int f2fs_ioc_get_encryption_pwsalt(struct file *filp, unsigned long arg)
 		goto out_err;
 	}
 got_it:
-	if (copy_to_user((__u8 __user *)arg, sbi->raw_super->encrypt_pw_salt,
-									16))
-		err = -EFAULT;
+	memcpy(encrypt_pw_salt, sbi->raw_super->encrypt_pw_salt, 16);
 out_err:
 	f2fs_up_write(&sbi->sb_lock);
 	mnt_drop_write_file(filp);
+
+	if (!err && copy_to_user((__u8 __user *)arg, encrypt_pw_salt, 16))
+		err = -EFAULT;
+
 	return err;
 }
 
@@ -3930,7 +3952,7 @@ static int f2fs_ioc_set_compress_option(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (inode->i_size != 0) {
+	if (F2FS_HAS_BLOCKS(inode)) {
 		ret = -EFBIG;
 		goto out;
 	}
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 5d6fd824f74f..229ddc2f7b07 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -621,9 +621,12 @@ void f2fs_update_inode(struct inode *inode, struct page *node_page)
 	ri->i_uid = cpu_to_le32(i_uid_read(inode));
 	ri->i_gid = cpu_to_le32(i_gid_read(inode));
 	ri->i_links = cpu_to_le32(inode->i_nlink);
-	ri->i_size = cpu_to_le64(i_size_read(inode));
 	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(inode->i_blocks) + 1);
 
+	if (!f2fs_is_atomic_file(inode) ||
+			is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))
+		ri->i_size = cpu_to_le64(i_size_read(inode));
+
 	if (et) {
 		read_lock(&et->lock);
 		set_raw_extent(&et->largest, &ri->i_ext);
@@ -761,11 +764,18 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 void f2fs_evict_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	nid_t xnid = fi->i_xattr_nid;
 	int err = 0;
 
 	f2fs_abort_atomic_write(inode, true);
 
+	if (fi->cow_inode) {
+		clear_inode_flag(fi->cow_inode, FI_COW_FILE);
+		iput(fi->cow_inode);
+		fi->cow_inode = NULL;
+	}
+
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
 
@@ -852,7 +862,7 @@ void f2fs_evict_inode(struct inode *inode)
 	stat_dec_inline_inode(inode);
 	stat_dec_compr_inode(inode);
 	stat_sub_compr_blocks(inode,
-			atomic_read(&F2FS_I(inode)->i_compr_blocks));
+			atomic_read(&fi->i_compr_blocks));
 
 	if (likely(!f2fs_cp_error(sbi) &&
 				!is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
diff --git a/fs/f2fs/iostat.c b/fs/f2fs/iostat.c
index 3166a8939ed4..02393c95c9f8 100644
--- a/fs/f2fs/iostat.c
+++ b/fs/f2fs/iostat.c
@@ -227,8 +227,12 @@ static inline void __update_iostat_latency(struct bio_iostat_ctx *iostat_ctx,
 		return;
 
 	ts_diff = jiffies - iostat_ctx->submit_ts;
-	if (iotype >= META_FLUSH)
+	if (iotype == META_FLUSH) {
 		iotype = META;
+	} else if (iotype >= NR_PAGE_TYPE) {
+		f2fs_warn(sbi, "%s: %d over NR_PAGE_TYPE", __func__, iotype);
+		return;
+	}
 
 	if (rw == 0) {
 		idx = READ_IO;
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index c1d0713666ee..8d1e8c537daf 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -192,14 +192,18 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 	if (!f2fs_is_atomic_file(inode))
 		return;
 
-	if (clean)
-		truncate_inode_pages_final(inode->i_mapping);
-	clear_inode_flag(fi->cow_inode, FI_COW_FILE);
-	iput(fi->cow_inode);
-	fi->cow_inode = NULL;
 	release_atomic_write_cnt(inode);
+	clear_inode_flag(inode, FI_ATOMIC_COMMITTED);
 	clear_inode_flag(inode, FI_ATOMIC_FILE);
 	stat_dec_atomic_inode(inode);
+
+	F2FS_I(inode)->atomic_write_task = NULL;
+
+	if (clean) {
+		truncate_inode_pages_final(inode->i_mapping);
+		f2fs_i_size_write(inode, fi->original_i_size);
+		fi->original_i_size = 0;
+	}
 }
 
 static int __replace_atomic_write_block(struct inode *inode, pgoff_t index,
@@ -250,6 +254,9 @@ static int __replace_atomic_write_block(struct inode *inode, pgoff_t index,
 	}
 
 	f2fs_put_dnode(&dn);
+
+	trace_f2fs_replace_atomic_write_block(inode, F2FS_I(inode)->cow_inode,
+					index, *old_addr, new_addr, recover);
 	return 0;
 }
 
@@ -335,10 +342,12 @@ static int __f2fs_commit_atomic_write(struct inode *inode)
 	}
 
 out:
-	if (ret)
+	if (ret) {
 		sbi->revoked_atomic_block += fi->atomic_write_cnt;
-	else
+	} else {
 		sbi->committed_atomic_block += fi->atomic_write_cnt;
+		set_inode_flag(inode, FI_ATOMIC_COMMITTED);
+	}
 
 	__complete_revoke_list(inode, &revoke_list, ret ? true : false);
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index eaabb85cb4dd..14c87399efea 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1416,8 +1416,6 @@ static int f2fs_drop_inode(struct inode *inode)
 			atomic_inc(&inode->i_count);
 			spin_unlock(&inode->i_lock);
 
-			f2fs_abort_atomic_write(inode, true);
-
 			/* should remain fi->extent_tree for writepage */
 			f2fs_destroy_extent_node(inode);
 
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index c352fff88a5e..3f4f3295f1c6 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -81,7 +81,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = aops->write_begin(NULL, mapping, pos, n, &page, &fsdata);
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 765838578a72..a3eb1e826947 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -193,7 +193,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
-	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) {
+	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG ||
+	    bmp->db_agl2size < 0) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index e8b9b756f0ac..d76eb7b39f56 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -209,11 +209,10 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
 	subtract_lebs += 1;
 
 	/*
-	 * The GC journal head LEB is not really accessible. And since
-	 * different write types go to different heads, we may count only on
-	 * one head's space.
+	 * Since different write types go to different heads, we should
+	 * reserve one leb for each head.
 	 */
-	subtract_lebs += c->jhead_cnt - 1;
+	subtract_lebs += c->jhead_cnt;
 
 	/* We also reserve one LEB for deletions, which bypass budgeting */
 	subtract_lebs += 1;
@@ -400,7 +399,7 @@ static int calc_dd_growth(const struct ubifs_info *c,
 	dd_growth = req->dirtied_page ? c->bi.page_budget : 0;
 
 	if (req->dirtied_ino)
-		dd_growth += c->bi.inode_budget << (req->dirtied_ino - 1);
+		dd_growth += c->bi.inode_budget * req->dirtied_ino;
 	if (req->mod_dent)
 		dd_growth += c->bi.dent_budget;
 	dd_growth += req->dirtied_ino_d;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 0f29cf201136..5e6bcce94e64 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1151,7 +1151,6 @@ static int ubifs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	int err, sz_change, len = strlen(symname);
 	struct fscrypt_str disk_link;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = ALIGN(len, 8),
 					.dirtied_ino = 1 };
 	struct fscrypt_name nm;
 
@@ -1167,6 +1166,7 @@ static int ubifs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	 * Budget request settings: new inode, new direntry and changing parent
 	 * directory inode.
 	 */
+	req.new_ino_d = ALIGN(disk_link.len - 1, 8);
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
@@ -1324,6 +1324,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlink) {
 		ubifs_assert(c, inode_is_locked(new_inode));
 
+		/* Budget for old inode's data when its nlink > 1. */
+		req.dirtied_ino_d = ALIGN(ubifs_inode(new_inode)->data_len, 8);
 		err = ubifs_purge_xattrs(new_inode);
 		if (err)
 			return err;
@@ -1576,6 +1578,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1601,6 +1607,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index f2353dd676ef..10c1779af9c5 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1032,7 +1032,7 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
 		if (page->index >= synced_i_size >> PAGE_SHIFT) {
 			err = inode->i_sb->s_op->write_inode(inode, NULL);
 			if (err)
-				goto out_unlock;
+				goto out_redirty;
 			/*
 			 * The inode has been written, but the write-buffer has
 			 * not been synchronized, so in case of an unclean
@@ -1060,11 +1060,17 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
 	if (i_size > synced_i_size) {
 		err = inode->i_sb->s_op->write_inode(inode, NULL);
 		if (err)
-			goto out_unlock;
+			goto out_redirty;
 	}
 
 	return do_writepage(page, len);
-
+out_redirty:
+	/*
+	 * redirty_page_for_writepage() won't call ubifs_dirty_inode() because
+	 * it passes I_DIRTY_PAGES flag while calling __mark_inode_dirty(), so
+	 * there is no need to do space budget for dirty inode.
+	 */
+	redirty_page_for_writepage(wbc, page);
 out_unlock:
 	unlock_page(page);
 	return err;
@@ -1466,14 +1472,23 @@ static bool ubifs_release_folio(struct folio *folio, gfp_t unused_gfp_flags)
 	struct inode *inode = folio->mapping->host;
 	struct ubifs_info *c = inode->i_sb->s_fs_info;
 
-	/*
-	 * An attempt to release a dirty page without budgeting for it - should
-	 * not happen.
-	 */
 	if (folio_test_writeback(folio))
 		return false;
+
+	/*
+	 * Page is private but not dirty, weird? There is one condition
+	 * making it happened. ubifs_writepage skipped the page because
+	 * page index beyonds isize (for example. truncated by other
+	 * process named A), then the page is invalidated by fadvise64
+	 * syscall before being truncated by process A.
+	 */
 	ubifs_assert(c, folio_test_private(folio));
-	ubifs_assert(c, 0);
+	if (folio_test_checked(folio))
+		release_new_page_budget(c);
+	else
+		release_existing_page_budget(c);
+
+	atomic_long_dec(&c->dirty_pg_cnt);
 	folio_detach_private(folio);
 	folio_clear_checked(folio);
 	return true;
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index d0c9a09988bc..32cb14759796 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -833,7 +833,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		INIT_LIST_HEAD(&c->jheads[i].buds_list);
 		err = ubifs_wbuf_init(c, &c->jheads[i].wbuf);
 		if (err)
-			return err;
+			goto out_wbuf;
 
 		c->jheads[i].wbuf.sync_callback = &bud_wbuf_callback;
 		c->jheads[i].wbuf.jhead = i;
@@ -841,7 +841,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		c->jheads[i].log_hash = ubifs_hash_get_desc(c);
 		if (IS_ERR(c->jheads[i].log_hash)) {
 			err = PTR_ERR(c->jheads[i].log_hash);
-			goto out;
+			goto out_log_hash;
 		}
 	}
 
@@ -854,9 +854,18 @@ static int alloc_wbufs(struct ubifs_info *c)
 
 	return 0;
 
-out:
-	while (i--)
+out_log_hash:
+	kfree(c->jheads[i].wbuf.buf);
+	kfree(c->jheads[i].wbuf.inodes);
+
+out_wbuf:
+	while (i--) {
+		kfree(c->jheads[i].wbuf.buf);
+		kfree(c->jheads[i].wbuf.inodes);
 		kfree(c->jheads[i].log_hash);
+	}
+	kfree(c->jheads);
+	c->jheads = NULL;
 
 	return err;
 }
diff --git a/fs/ubifs/sysfs.c b/fs/ubifs/sysfs.c
index 06ad8fa1fcfb..54270ad36321 100644
--- a/fs/ubifs/sysfs.c
+++ b/fs/ubifs/sysfs.c
@@ -144,6 +144,8 @@ int __init ubifs_sysfs_init(void)
 	kobject_set_name(&ubifs_kset.kobj, "ubifs");
 	ubifs_kset.kobj.parent = fs_kobj;
 	ret = kset_register(&ubifs_kset);
+	if (ret)
+		kset_put(&ubifs_kset);
 
 	return ret;
 }
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 488f3da7a6c6..2469f72eeaab 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -267,11 +267,18 @@ static struct ubifs_znode *dirty_cow_znode(struct ubifs_info *c,
 	if (zbr->len) {
 		err = insert_old_idx(c, zbr->lnum, zbr->offs);
 		if (unlikely(err))
-			return ERR_PTR(err);
+			/*
+			 * Obsolete znodes will be freed by tnc_destroy_cnext()
+			 * or free_obsolete_znodes(), copied up znodes should
+			 * be added back to tnc and freed by
+			 * ubifs_destroy_tnc_subtree().
+			 */
+			goto out;
 		err = add_idx_dirt(c, zbr->lnum, zbr->len);
 	} else
 		err = 0;
 
+out:
 	zbr->znode = zn;
 	zbr->lnum = 0;
 	zbr->offs = 0;
@@ -3053,6 +3060,21 @@ static void tnc_destroy_cnext(struct ubifs_info *c)
 		cnext = cnext->cnext;
 		if (ubifs_zn_obsolete(znode))
 			kfree(znode);
+		else if (!ubifs_zn_cow(znode)) {
+			/*
+			 * Don't forget to update clean znode count after
+			 * committing failed, because ubifs will check this
+			 * count while closing tnc. Non-obsolete znode could
+			 * be re-dirtied during committing process, so dirty
+			 * flag is untrustable. The flag 'COW_ZNODE' is set
+			 * for each dirty znode before committing, and it is
+			 * cleared as long as the znode become clean, so we
+			 * can statistic clean znode count according to this
+			 * flag.
+			 */
+			atomic_long_inc(&c->clean_zn_cnt);
+			atomic_long_inc(&ubifs_clean_zn_cnt);
+		}
 	} while (cnext && cnext != c->cnext);
 }
 
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 478bbbb5382f..2f1f31581094 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1623,8 +1623,13 @@ static inline int ubifs_check_hmac(const struct ubifs_info *c,
 	return crypto_memneq(expected, got, c->hmac_desc_len);
 }
 
+#ifdef CONFIG_UBIFS_FS_AUTHENTICATION
 void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
 		    const u8 *hash, int lnum, int offs);
+#else
+static inline void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
+				  const u8 *hash, int lnum, int offs) {};
+#endif
 
 int __ubifs_node_check_hash(const struct ubifs_info *c, const void *buf,
 			  const u8 *expected);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index ab2d6266038a..6badc50ec4e6 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -534,6 +534,7 @@ int acpi_bus_update_power(acpi_handle handle, int *state_p);
 int acpi_device_update_power(struct acpi_device *device, int *state_p);
 bool acpi_bus_power_manageable(acpi_handle handle);
 void acpi_dev_power_up_children_with_adr(struct acpi_device *adev);
+u8 acpi_dev_power_state_for_wake(struct acpi_device *adev);
 int acpi_device_power_add_dependent(struct acpi_device *adev,
 				    struct device *dev);
 void acpi_device_power_remove_dependent(struct acpi_device *adev,
diff --git a/include/drm/display/drm_dp_mst_helper.h b/include/drm/display/drm_dp_mst_helper.h
index 41fd8352ab65..6c0c3dc3d3ac 100644
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -867,6 +867,9 @@ struct drm_dp_mst_topology_state *
 drm_atomic_get_mst_topology_state(struct drm_atomic_state *state,
 				  struct drm_dp_mst_topology_mgr *mgr);
 struct drm_dp_mst_topology_state *
+drm_atomic_get_old_mst_topology_state(struct drm_atomic_state *state,
+				      struct drm_dp_mst_topology_mgr *mgr);
+struct drm_dp_mst_topology_state *
 drm_atomic_get_new_mst_topology_state(struct drm_atomic_state *state,
 				      struct drm_dp_mst_topology_mgr *mgr);
 struct drm_dp_mst_atomic_payload *
diff --git a/include/linux/bootconfig.h b/include/linux/bootconfig.h
index 1611f9db878e..ca73940e26df 100644
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -59,7 +59,7 @@ struct xbc_node {
 /* Maximum size of boot config is 32KB - 1 */
 #define XBC_DATA_MAX	(XBC_VALUE - 1)
 
-#define XBC_NODE_MAX	1024
+#define XBC_NODE_MAX	8192
 #define XBC_KEYLEN_MAX	256
 #define XBC_DEPTH_MAX	16
 
diff --git a/include/linux/mdio/mdio-mscc-miim.h b/include/linux/mdio/mdio-mscc-miim.h
index 5b4ed2c3cbb9..1ce699740af6 100644
--- a/include/linux/mdio/mdio-mscc-miim.h
+++ b/include/linux/mdio/mdio-mscc-miim.h
@@ -14,6 +14,6 @@
 
 int mscc_miim_setup(struct device *device, struct mii_bus **bus,
 		    const char *name, struct regmap *mii_regmap,
-		    int status_offset);
+		    int status_offset, bool ignore_read_errors);
 
 #endif
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d8817d381c14..bef8db9d6c08 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -488,4 +488,9 @@ extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
  */
 DECLARE_PER_CPU(bool, nf_skb_duplicated);
 
+/**
+ * Contains bitmask of ctnetlink event subscribers, if any.
+ * Can't be pernet due to NETLINK_LISTEN_ALL_NSID setsockopt flag.
+ */
+extern u8 nf_ctnetlink_has_listener;
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 2bda4a4e47e8..cb538bc57971 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -570,6 +570,7 @@ struct pci_host_bridge {
 	void		*release_data;
 	unsigned int	ignore_reset_delay:1;	/* For entire hierarchy */
 	unsigned int	no_ext_tags:1;		/* No Extended Tags */
+	unsigned int	no_inc_mrrs:1;		/* No Increase MRRS */
 	unsigned int	native_aer:1;		/* OS may use PCIe AER */
 	unsigned int	native_pcie_hotplug:1;	/* OS may use PCIe hotplug */
 	unsigned int	native_shpc_hotplug:1;	/* OS may use SHPC hotplug */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index b362d90eb9b0..bc8f484cdcf3 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3012,6 +3012,8 @@
 #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
+#define PCI_VENDOR_ID_WANGXUN		0x8088
+
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
 
diff --git a/include/media/v4l2-uvc.h b/include/media/v4l2-uvc.h
index f83e31661333..b010a36fc1d9 100644
--- a/include/media/v4l2-uvc.h
+++ b/include/media/v4l2-uvc.h
@@ -99,6 +99,9 @@
 #define UVC_GUID_FORMAT_BGR3 \
 	{ 0x7d, 0xeb, 0x36, 0xe4, 0x4f, 0x52, 0xce, 0x11, \
 	 0x9f, 0x53, 0x00, 0x20, 0xaf, 0x0b, 0xa7, 0x70}
+#define UVC_GUID_FORMAT_BGR4 \
+	{ 0x7e, 0xeb, 0x36, 0xe4, 0x4f, 0x52, 0xce, 0x11, \
+	 0x9f, 0x53, 0x00, 0x20, 0xaf, 0x0b, 0xa7, 0x70}
 #define UVC_GUID_FORMAT_M420 \
 	{ 'M',  '4',  '2',  '0', 0x00, 0x00, 0x10, 0x00, \
 	 0x80, 0x00, 0x00, 0xaa, 0x00, 0x38, 0x9b, 0x71}
@@ -266,6 +269,11 @@ static struct uvc_format_desc uvc_fmts[] = {
 		.guid		= UVC_GUID_FORMAT_BGR3,
 		.fcc		= V4L2_PIX_FMT_BGR24,
 	},
+	{
+		.name		= "BGRA/X 8:8:8:8 (BGR4)",
+		.guid		= UVC_GUID_FORMAT_BGR4,
+		.fcc		= V4L2_PIX_FMT_XBGR32,
+	},
 	{
 		.name		= "H.264",
 		.guid		= UVC_GUID_FORMAT_H264,
diff --git a/include/memory/renesas-rpc-if.h b/include/memory/renesas-rpc-if.h
index 9c0ad64b8d29..ddf94356752d 100644
--- a/include/memory/renesas-rpc-if.h
+++ b/include/memory/renesas-rpc-if.h
@@ -64,24 +64,8 @@ enum rpcif_type {
 
 struct rpcif {
 	struct device *dev;
-	void __iomem *base;
 	void __iomem *dirmap;
-	struct regmap *regmap;
-	struct reset_control *rstc;
 	size_t size;
-	enum rpcif_type type;
-	enum rpcif_data_dir dir;
-	u8 bus_size;
-	u8 xfer_size;
-	void *buffer;
-	u32 xferlen;
-	u32 smcr;
-	u32 smadr;
-	u32 command;		/* DRCMR or SMCMR */
-	u32 option;		/* DROPR or SMOPR */
-	u32 enable;		/* DRENR or SMENR */
-	u32 dummy;		/* DRDMCR or SMDMCR */
-	u32 ddr;		/* DRDRENR or SMDRENR */
 };
 
 int rpcif_sw_init(struct rpcif *rpc, struct device *dev);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e1290c159184..1f463b3957c7 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -95,7 +95,6 @@ struct nf_ip_net {
 
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	u8 ctnetlink_has_listener;
 	bool ecache_dwork_pending;
 #endif
 	u8			sysctl_log_invalid; /* Log invalid packets */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 350f250b0dc7..00ee9eb601a6 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1409,6 +1409,7 @@ struct sctp_stream_priorities {
 	/* The next stream in line */
 	struct sctp_stream_out_ext *next;
 	__u16 prio;
+	__u16 users;
 };
 
 struct sctp_stream_out_ext {
diff --git a/include/net/tc_act/tc_pedit.h b/include/net/tc_act/tc_pedit.h
index 3e02709a1df6..83fe39931781 100644
--- a/include/net/tc_act/tc_pedit.h
+++ b/include/net/tc_act/tc_pedit.h
@@ -4,22 +4,29 @@
 
 #include <net/act_api.h>
 #include <linux/tc_act/tc_pedit.h>
+#include <linux/types.h>
 
 struct tcf_pedit_key_ex {
 	enum pedit_header_type htype;
 	enum pedit_cmd cmd;
 };
 
-struct tcf_pedit {
-	struct tc_action	common;
-	unsigned char		tcfp_nkeys;
-	unsigned char		tcfp_flags;
-	u32			tcfp_off_max_hint;
+struct tcf_pedit_parms {
 	struct tc_pedit_key	*tcfp_keys;
 	struct tcf_pedit_key_ex	*tcfp_keys_ex;
+	u32 tcfp_off_max_hint;
+	unsigned char tcfp_nkeys;
+	unsigned char tcfp_flags;
+	struct rcu_head rcu;
+};
+
+struct tcf_pedit {
+	struct tc_action common;
+	struct tcf_pedit_parms __rcu *parms;
 };
 
 #define to_pedit(a) ((struct tcf_pedit *)a)
+#define to_pedit_parms(a) (rcu_dereference(to_pedit(a)->parms))
 
 static inline bool is_tcf_pedit(const struct tc_action *a)
 {
@@ -32,37 +39,81 @@ static inline bool is_tcf_pedit(const struct tc_action *a)
 
 static inline int tcf_pedit_nkeys(const struct tc_action *a)
 {
-	return to_pedit(a)->tcfp_nkeys;
+	struct tcf_pedit_parms *parms;
+	int nkeys;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	nkeys = parms->tcfp_nkeys;
+	rcu_read_unlock();
+
+	return nkeys;
 }
 
 static inline u32 tcf_pedit_htype(const struct tc_action *a, int index)
 {
-	if (to_pedit(a)->tcfp_keys_ex)
-		return to_pedit(a)->tcfp_keys_ex[index].htype;
+	u32 htype = TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	struct tcf_pedit_parms *parms;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	if (parms->tcfp_keys_ex)
+		htype = parms->tcfp_keys_ex[index].htype;
+	rcu_read_unlock();
 
-	return TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
+	return htype;
 }
 
 static inline u32 tcf_pedit_cmd(const struct tc_action *a, int index)
 {
-	if (to_pedit(a)->tcfp_keys_ex)
-		return to_pedit(a)->tcfp_keys_ex[index].cmd;
+	struct tcf_pedit_parms *parms;
+	u32 cmd = __PEDIT_CMD_MAX;
 
-	return __PEDIT_CMD_MAX;
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	if (parms->tcfp_keys_ex)
+		cmd = parms->tcfp_keys_ex[index].cmd;
+	rcu_read_unlock();
+
+	return cmd;
 }
 
 static inline u32 tcf_pedit_mask(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].mask;
+	struct tcf_pedit_parms *parms;
+	u32 mask;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	mask = parms->tcfp_keys[index].mask;
+	rcu_read_unlock();
+
+	return mask;
 }
 
 static inline u32 tcf_pedit_val(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].val;
+	struct tcf_pedit_parms *parms;
+	u32 val;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	val = parms->tcfp_keys[index].val;
+	rcu_read_unlock();
+
+	return val;
 }
 
 static inline u32 tcf_pedit_offset(const struct tc_action *a, int index)
 {
-	return to_pedit(a)->tcfp_keys[index].off;
+	struct tcf_pedit_parms *parms;
+	u32 off;
+
+	rcu_read_lock();
+	parms = to_pedit_parms(a);
+	off = parms->tcfp_keys[index].off;
+	rcu_read_unlock();
+
+	return off;
 }
 #endif /* __NET_TC_PED_H */
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index ff57e7f9914c..e57f867191ef 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -1286,6 +1286,43 @@ DEFINE_EVENT(f2fs__page, f2fs_vm_page_mkwrite,
 	TP_ARGS(page, type)
 );
 
+TRACE_EVENT(f2fs_replace_atomic_write_block,
+
+	TP_PROTO(struct inode *inode, struct inode *cow_inode, pgoff_t index,
+			block_t old_addr, block_t new_addr, bool recovery),
+
+	TP_ARGS(inode, cow_inode, index, old_addr, new_addr, recovery),
+
+	TP_STRUCT__entry(
+		__field(dev_t,	dev)
+		__field(ino_t,	ino)
+		__field(ino_t,	cow_ino)
+		__field(pgoff_t, index)
+		__field(block_t, old_addr)
+		__field(block_t, new_addr)
+		__field(bool, recovery)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->cow_ino	= cow_inode->i_ino;
+		__entry->index		= index;
+		__entry->old_addr	= old_addr;
+		__entry->new_addr	= new_addr;
+		__entry->recovery	= recovery;
+	),
+
+	TP_printk("dev = (%d,%d), ino = %lu, cow_ino = %lu, index = %lu, "
+			"old_addr = 0x%llx, new_addr = 0x%llx, recovery = %d",
+		show_dev_ino(__entry),
+		__entry->cow_ino,
+		(unsigned long)__entry->index,
+		(unsigned long long)__entry->old_addr,
+		(unsigned long long)__entry->new_addr,
+		__entry->recovery)
+);
+
 TRACE_EVENT(f2fs_filemap_fault,
 
 	TP_PROTO(struct inode *inode, pgoff_t index, unsigned long ret),
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index bfdae12cdacf..c58854fb7d94 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -179,6 +179,36 @@
 #define UVC_CONTROL_CAP_AUTOUPDATE			(1 << 3)
 #define UVC_CONTROL_CAP_ASYNCHRONOUS			(1 << 4)
 
+/* 3.9.2.6 Color Matching Descriptor Values */
+enum uvc_color_primaries_values {
+	UVC_COLOR_PRIMARIES_UNSPECIFIED,
+	UVC_COLOR_PRIMARIES_BT_709_SRGB,
+	UVC_COLOR_PRIMARIES_BT_470_2_M,
+	UVC_COLOR_PRIMARIES_BT_470_2_B_G,
+	UVC_COLOR_PRIMARIES_SMPTE_170M,
+	UVC_COLOR_PRIMARIES_SMPTE_240M,
+};
+
+enum uvc_transfer_characteristics_values {
+	UVC_TRANSFER_CHARACTERISTICS_UNSPECIFIED,
+	UVC_TRANSFER_CHARACTERISTICS_BT_709,
+	UVC_TRANSFER_CHARACTERISTICS_BT_470_2_M,
+	UVC_TRANSFER_CHARACTERISTICS_BT_470_2_B_G,
+	UVC_TRANSFER_CHARACTERISTICS_SMPTE_170M,
+	UVC_TRANSFER_CHARACTERISTICS_SMPTE_240M,
+	UVC_TRANSFER_CHARACTERISTICS_LINEAR,
+	UVC_TRANSFER_CHARACTERISTICS_SRGB,
+};
+
+enum uvc_matrix_coefficients {
+	UVC_MATRIX_COEFFICIENTS_UNSPECIFIED,
+	UVC_MATRIX_COEFFICIENTS_BT_709,
+	UVC_MATRIX_COEFFICIENTS_FCC,
+	UVC_MATRIX_COEFFICIENTS_BT_470_2_B_G,
+	UVC_MATRIX_COEFFICIENTS_SMPTE_170M,
+	UVC_MATRIX_COEFFICIENTS_SMPTE_240M,
+};
+
 /* ------------------------------------------------------------------------
  * UVC structures
  */
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index 8288137387c0..a9d0a64007ba 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -86,7 +86,7 @@ struct uvc_xu_control_query {
  * struct. The first two fields are added by the driver, they can be used for
  * clock synchronisation. The rest is an exact copy of a UVC payload header.
  * Only complete objects with complete buffers are included. Therefore it's
- * always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes large.
+ * always sizeof(meta->ns) + sizeof(meta->sof) + meta->length bytes large.
  */
 struct uvc_meta_buf {
 	__u64 ns;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index e2c46889d5fa..746b137b96e9 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -509,7 +509,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	}
 
 	pages = io_pin_pages(reg.ring_addr,
-			     struct_size(br, bufs, reg.ring_entries),
+			     flex_array_size(br, bufs, reg.ring_entries),
 			     &nr_pages);
 	if (IS_ERR(pages)) {
 		kfree(free_bl);
diff --git a/io_uring/net.c b/io_uring/net.c
index 55d822beaf08..4fdc2770bbe4 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -126,13 +126,15 @@ static struct io_async_msghdr *io_msg_alloc_async(struct io_kiocb *req,
 	struct io_cache_entry *entry;
 	struct io_async_msghdr *hdr;
 
-	if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-	    (entry = io_alloc_cache_get(&ctx->netmsg_cache)) != NULL) {
-		hdr = container_of(entry, struct io_async_msghdr, cache);
-		hdr->free_iov = NULL;
-		req->flags |= REQ_F_ASYNC_DATA;
-		req->async_data = hdr;
-		return hdr;
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->netmsg_cache);
+		if (entry) {
+			hdr = container_of(entry, struct io_async_msghdr, cache);
+			hdr->free_iov = NULL;
+			req->flags |= REQ_F_ASYNC_DATA;
+			req->async_data = hdr;
+			return hdr;
+		}
 	}
 
 	if (!io_alloc_async_data(req)) {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index ab5ae475840f..56dbd1863c78 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -668,6 +668,14 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
+/*
+ * We can't reliably detect loops in repeated poll triggers and issue
+ * subsequently failing. But rather than fail these immediately, allow a
+ * certain amount of retries before we give up. Given that this condition
+ * should _rarely_ trigger even once, we should be fine with a larger value.
+ */
+#define APOLL_MAX_RETRY		128
+
 static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 					     unsigned issue_flags)
 {
@@ -678,16 +686,23 @@ static struct async_poll *io_req_alloc_apoll(struct io_kiocb *req,
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
-	} else if (!(issue_flags & IO_URING_F_UNLOCKED) &&
-		   (entry = io_alloc_cache_get(&ctx->apoll_cache)) != NULL) {
+	} else if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		entry = io_alloc_cache_get(&ctx->apoll_cache);
+		if (entry == NULL)
+			goto alloc_apoll;
 		apoll = container_of(entry, struct async_poll, cache);
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	} else {
+alloc_apoll:
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 		if (unlikely(!apoll))
 			return NULL;
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
+	if (unlikely(!--apoll->poll.retries))
+		return NULL;
 	return apoll;
 }
 
@@ -709,8 +724,6 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 		return IO_APOLL_ABORTED;
 	if (!file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT))
 		mask |= EPOLLONESHOT;
 
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 5f3bae50fc81..b2393b403a2c 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -12,6 +12,7 @@ struct io_poll {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				retries;
 	struct wait_queue_entry		wait;
 };
 
diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index a7ccd2930c5f..d971a0189319 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -163,10 +163,7 @@ static void fei_debugfs_add_attr(struct fei_attr *attr)
 
 static void fei_debugfs_remove_attr(struct fei_attr *attr)
 {
-	struct dentry *dir;
-
-	dir = debugfs_lookup(attr->kp.symbol_name, fei_debugfs_dir);
-	debugfs_remove_recursive(dir);
+	debugfs_lookup_and_remove(attr->kp.symbol_name, fei_debugfs_dir);
 }
 
 static int fei_kprobe_handler(struct kprobe *kp, struct pt_regs *regs)
diff --git a/kernel/irq/ipi.c b/kernel/irq/ipi.c
index bbd945bacef0..961d4af76af3 100644
--- a/kernel/irq/ipi.c
+++ b/kernel/irq/ipi.c
@@ -188,9 +188,9 @@ EXPORT_SYMBOL_GPL(ipi_get_hwirq);
 static int ipi_send_verify(struct irq_chip *chip, struct irq_data *data,
 			   const struct cpumask *dest, unsigned int cpu)
 {
-	const struct cpumask *ipimask = irq_data_get_affinity_mask(data);
+	const struct cpumask *ipimask;
 
-	if (!chip || !ipimask)
+	if (!chip || !data)
 		return -EINVAL;
 
 	if (!chip->ipi_send_single && !chip->ipi_send_mask)
@@ -199,6 +199,10 @@ static int ipi_send_verify(struct irq_chip *chip, struct irq_data *data,
 	if (cpu >= nr_cpu_ids)
 		return -EINVAL;
 
+	ipimask = irq_data_get_affinity_mask(data);
+	if (!ipimask)
+		return -EINVAL;
+
 	if (dest) {
 		if (!cpumask_subset(dest, ipimask))
 			return -EINVAL;
diff --git a/kernel/printk/index.c b/kernel/printk/index.c
index c85be186a783..a6b27526baaf 100644
--- a/kernel/printk/index.c
+++ b/kernel/printk/index.c
@@ -145,7 +145,7 @@ static void pi_create_file(struct module *mod)
 #ifdef CONFIG_MODULES
 static void pi_remove_file(struct module *mod)
 {
-	debugfs_remove(debugfs_lookup(pi_get_module_name(mod), dfs_index));
+	debugfs_lookup_and_remove(pi_get_module_name(mod), dfs_index);
 }
 
 static int pi_module_notify(struct notifier_block *nb, unsigned long op,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index c35e08b74014..361bd8beafdf 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5588,11 +5588,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
  */
 void ring_buffer_free_read_page(struct trace_buffer *buffer, int cpu, void *data)
 {
-	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_data_page *bpage = data;
 	struct page *page = virt_to_page(bpage);
 	unsigned long flags;
 
+	if (!buffer || !buffer->buffers || !buffer->buffers[cpu])
+		return;
+
+	cpu_buffer = buffer->buffers[cpu];
+
 	/* If the page is still in use someplace else, we can't reuse it */
 	if (page_ref_count(page) > 1)
 		goto out;
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index e9a830c69058..29a9292303ea 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -386,6 +386,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int ret;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -403,7 +404,12 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	wr.wr_cqe = &c->cqe;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
-	return ib_post_recv(rdma->qp, &wr, NULL);
+
+	ret = ib_post_recv(rdma->qp, &wr, NULL);
+	if (ret)
+		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+				    client->msize, DMA_FROM_DEVICE);
+	return ret;
 
  error:
 	p9_debug(P9_DEBUG_ERROR, "EIO\n");
@@ -500,7 +506,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto dma_unmap;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -510,11 +516,14 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	WRITE_ONCE(req->status, REQ_STATUS_SENT);
 	err = ib_post_send(rdma->qp, &wr, NULL);
 	if (err)
-		goto send_error;
+		goto dma_unmap;
 
 	/* Success */
 	return 0;
 
+dma_unmap:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    c->req->tc.size, DMA_TO_DEVICE);
  /* Handle errors that happened during or while preparing the send: */
  send_error:
 	WRITE_ONCE(req->status, REQ_STATUS_ERROR);
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index cf1b89ba522b..75c03a82baf3 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -371,19 +371,24 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 	return ret;
 }
 
-static int xen_9pfs_front_probe(struct xenbus_device *dev,
-				const struct xenbus_device_id *id)
+static int xen_9pfs_front_init(struct xenbus_device *dev)
 {
 	int ret, i;
 	struct xenbus_transaction xbt;
-	struct xen_9pfs_front_priv *priv = NULL;
-	char *versions;
+	struct xen_9pfs_front_priv *priv = dev_get_drvdata(&dev->dev);
+	char *versions, *v;
 	unsigned int max_rings, max_ring_order, len = 0;
 
 	versions = xenbus_read(XBT_NIL, dev->otherend, "versions", &len);
 	if (IS_ERR(versions))
 		return PTR_ERR(versions);
-	if (strcmp(versions, "1")) {
+	for (v = versions; *v; v++) {
+		if (simple_strtoul(v, &v, 10) == 1) {
+			v = NULL;
+			break;
+		}
+	}
+	if (v) {
 		kfree(versions);
 		return -EINVAL;
 	}
@@ -398,11 +403,6 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	if (p9_xen_trans.maxsize > XEN_FLEX_RING_SIZE(max_ring_order))
 		p9_xen_trans.maxsize = XEN_FLEX_RING_SIZE(max_ring_order) / 2;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->dev = dev;
 	priv->num_rings = XEN_9PFS_NUM_RINGS;
 	priv->rings = kcalloc(priv->num_rings, sizeof(*priv->rings),
 			      GFP_KERNEL);
@@ -461,23 +461,35 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 		goto error;
 	}
 
-	write_lock(&xen_9pfs_lock);
-	list_add_tail(&priv->list, &xen_9pfs_devs);
-	write_unlock(&xen_9pfs_lock);
-	dev_set_drvdata(&dev->dev, priv);
-	xenbus_switch_state(dev, XenbusStateInitialised);
-
 	return 0;
 
  error_xenbus:
 	xenbus_transaction_end(xbt, 1);
 	xenbus_dev_fatal(dev, ret, "writing xenstore");
  error:
-	dev_set_drvdata(&dev->dev, NULL);
 	xen_9pfs_front_free(priv);
 	return ret;
 }
 
+static int xen_9pfs_front_probe(struct xenbus_device *dev,
+				const struct xenbus_device_id *id)
+{
+	struct xen_9pfs_front_priv *priv = NULL;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+	dev_set_drvdata(&dev->dev, priv);
+
+	write_lock(&xen_9pfs_lock);
+	list_add_tail(&priv->list, &xen_9pfs_devs);
+	write_unlock(&xen_9pfs_lock);
+
+	return 0;
+}
+
 static int xen_9pfs_front_resume(struct xenbus_device *dev)
 {
 	dev_warn(&dev->dev, "suspend/resume unsupported\n");
@@ -496,6 +508,8 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
+		if (!xen_9pfs_front_init(dev))
+			xenbus_switch_state(dev, XenbusStateInitialised);
 		break;
 
 	case XenbusStateConnected:
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ce5dfa3babd2..757ec46fc45a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1090,7 +1090,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
 			AUDIT_XT_OP_REPLACE, GFP_KERNEL);
-	return ret;
+	return 0;
 
 free_unlock:
 	mutex_unlock(&ebt_mutex);
diff --git a/net/core/dev.c b/net/core/dev.c
index 7a2a4650a898..24eae99dfe05 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3146,8 +3146,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	if (in_hardirq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
+	else if (unlikely(reason == SKB_REASON_DROPPED))
+		kfree_skb(skb);
 	else
-		dev_kfree_skb(skb);
+		consume_skb(skb);
 }
 EXPORT_SYMBOL(__dev_kfree_skb_any);
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ffc0cab7cf18..2407066b0fec 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1525,6 +1525,10 @@ int arpt_register_table(struct net *net,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct arpt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2ed7c58b471a..da5998011ab9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1045,7 +1045,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_counters *counters;
 	struct ipt_entry *iter;
 
-	ret = 0;
 	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
@@ -1091,7 +1090,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	return ret;
+	return 0;
 
  put_module:
 	module_put(t->me);
@@ -1742,6 +1741,10 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ipt_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index c375f603a16c..7f37e7da6467 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -580,6 +580,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process context.
+ *       Otherwise, this is from BH context.
  */
 
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -731,7 +734,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 					  &tcp_rsk(req)->last_oow_ack_time))
 			req->rsk_ops->send_ack(sk, skb, req);
 		if (paws_reject)
-			__NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
 	}
 
@@ -750,7 +753,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 *	   "fourth, check the SYN bit"
 	 */
 	if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 		goto embryonic_reset;
 	}
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2d816277f2c5..0ce0ed17c758 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1062,7 +1062,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_counters *counters;
 	struct ip6t_entry *iter;
 
-	ret = 0;
 	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
@@ -1108,7 +1107,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("ip6tables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	return ret;
+	return 0;
 
  put_module:
 	module_put(t->me);
@@ -1751,6 +1750,10 @@ int ip6t_register_table(struct net *net, const struct xt_table *table,
 
 	new_table = xt_register_table(net, table, &bootstrap, newinfo);
 	if (IS_ERR(new_table)) {
+		struct ip6t_entry *iter;
+
+		xt_entry_foreach(iter, loc_cpu_entry, newinfo->size)
+			cleanup_entry(iter, net);
 		xt_free_table_info(newinfo);
 		return PTR_ERR(new_table);
 	}
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index a01d9b842bd0..67c87a88cde4 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -72,7 +72,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2f355f0ec32a..0b060cb8681f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5540,16 +5540,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
 		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
 					 &nexthop_len);
 	} else {
+		struct fib6_info *sibling, *next_sibling;
 		struct fib6_nh *nh = f6i->fib6_nh;
 
 		nexthop_len = 0;
 		if (f6i->fib6_nsiblings) {
-			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
-				    + NLA_ALIGN(sizeof(struct rtnexthop))
-				    + nla_total_size(16) /* RTA_GATEWAY */
-				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
+			rt6_nh_nlmsg_size(nh, &nexthop_len);
 
-			nexthop_len *= f6i->fib6_nsiblings;
+			list_for_each_entry_safe(sibling, next_sibling,
+						 &f6i->fib6_siblings, fib6_siblings) {
+				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
+			}
 		}
 		nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
 	}
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5a6705a0e4ec..6e80f0f6149e 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -669,6 +669,9 @@ const struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_hook);
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
+u8 nf_ctnetlink_has_listener;
+EXPORT_SYMBOL_GPL(nf_ctnetlink_has_listener);
+
 const struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_hook);
 
diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
index 8639e7efd0e2..adae86e8e02e 100644
--- a/net/netfilter/nf_conntrack_bpf.c
+++ b/net/netfilter/nf_conntrack_bpf.c
@@ -384,7 +384,6 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
 	struct nf_conn *nfct = (struct nf_conn *)nfct_i;
 	int err;
 
-	nfct->status |= IPS_CONFIRMED;
 	err = nf_conntrack_hash_check_insert(nfct);
 	if (err < 0) {
 		nf_conntrack_free(nfct);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 23b3fedd619a..7f0f3bcaae03 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -890,10 +890,8 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	zone = nf_ct_zone(ct);
 
-	if (!nf_ct_ext_valid_pre(ct->ext)) {
-		NF_CT_STAT_INC_ATOMIC(net, insert_failed);
-		return -ETIMEDOUT;
-	}
+	if (!nf_ct_ext_valid_pre(ct->ext))
+		return -EAGAIN;
 
 	local_bh_disable();
 	do {
@@ -928,6 +926,19 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 			goto chaintoolong;
 	}
 
+	/* If genid has changed, we can't insert anymore because ct
+	 * extensions could have stale pointers and nf_ct_iterate_destroy
+	 * might have completed its table scan already.
+	 *
+	 * Increment of the ext genid right after this check is fine:
+	 * nf_ct_iterate_destroy blocks until locks are released.
+	 */
+	if (!nf_ct_ext_valid_post(ct->ext)) {
+		err = -EAGAIN;
+		goto out;
+	}
+
+	ct->status |= IPS_CONFIRMED;
 	smp_wmb();
 	/* The caller holds a reference to this object */
 	refcount_set(&ct->ct_general.use, 2);
@@ -936,12 +947,6 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 	NF_CT_STAT_INC(net, insert);
 	local_bh_enable();
 
-	if (!nf_ct_ext_valid_post(ct->ext)) {
-		nf_ct_kill(ct);
-		NF_CT_STAT_INC_ATOMIC(net, drop);
-		return -ETIMEDOUT;
-	}
-
 	return 0;
 chaintoolong:
 	NF_CT_STAT_INC(net, chaintoolong);
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 8698b3424646..69948e1d6974 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -309,7 +309,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 			break;
 		return true;
 	case 2: /* autodetect: no event listener, don't allocate extension. */
-		if (!READ_ONCE(net->ct.ctnetlink_has_listener))
+		if (!READ_ONCE(nf_ctnetlink_has_listener))
 			return true;
 		fallthrough;
 	case 1:
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1286ae7d4609..733bb56950c1 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2316,9 +2316,6 @@ ctnetlink_create_conntrack(struct net *net,
 	nfct_seqadj_ext_add(ct);
 	nfct_synproxy_ext_add(ct);
 
-	/* we must add conntrack extensions before confirmation. */
-	ct->status |= IPS_CONFIRMED;
-
 	if (cda[CTA_STATUS]) {
 		err = ctnetlink_change_status(ct, cda);
 		if (err < 0)
@@ -2375,12 +2372,15 @@ ctnetlink_create_conntrack(struct net *net,
 
 	err = nf_conntrack_hash_check_insert(ct);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	rcu_read_unlock();
 
 	return ct;
 
+err3:
+	if (ct->master)
+		nf_ct_put(ct->master);
 err2:
 	rcu_read_unlock();
 err1:
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dca5352bdf3d..1a9d759d0a02 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5439,7 +5439,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
-				 genmask, NETLINK_CB(skb).portid);
+				 genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
 		return PTR_ERR(table);
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 6d18fb346868..81c7737c803a 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -29,6 +29,7 @@
 
 #include <net/netlink.h>
 #include <net/netns/generic.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 
 MODULE_LICENSE("GPL");
@@ -685,12 +686,12 @@ static void nfnetlink_bind_event(struct net *net, unsigned int group)
 	group_bit = (1 << group);
 
 	spin_lock(&nfnl_grp_active_lock);
-	v = READ_ONCE(net->ct.ctnetlink_has_listener);
+	v = READ_ONCE(nf_ctnetlink_has_listener);
 	if ((v & group_bit) == 0) {
 		v |= group_bit;
 
 		/* read concurrently without nfnl_grp_active_lock held. */
-		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
+		WRITE_ONCE(nf_ctnetlink_has_listener, v);
 	}
 
 	spin_unlock(&nfnl_grp_active_lock);
@@ -744,12 +745,12 @@ static void nfnetlink_unbind(struct net *net, int group)
 
 	spin_lock(&nfnl_grp_active_lock);
 	if (!nfnetlink_has_listeners(net, group)) {
-		u8 v = READ_ONCE(net->ct.ctnetlink_has_listener);
+		u8 v = READ_ONCE(nf_ctnetlink_has_listener);
 
 		v &= ~group_bit;
 
 		/* read concurrently without nfnl_grp_active_lock held. */
-		WRITE_ONCE(net->ct.ctnetlink_has_listener, v);
+		WRITE_ONCE(nf_ctnetlink_has_listener, v);
 	}
 	spin_unlock(&nfnl_grp_active_lock);
 #endif
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 1873da3a945a..9fbfad13176f 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -30,8 +30,7 @@ static bool
 length_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
-	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
-				 sizeof(struct ipv6hdr);
+	u32 pktlen = skb->len;
 
 	return (pktlen >= info->min && pktlen <= info->max) ^ info->invert;
 }
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 1fc339084d89..348bf561bc9f 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1442,7 +1442,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	rc = dev->ops->se_io(dev, se_idx, apdu,
 			apdu_length, cb, cb_context);
 
+	device_unlock(&dev->dev);
+	return rc;
+
 error:
+	kfree(cb_context);
 	device_unlock(&dev->dev);
 	return rc;
 }
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 4662a6ce8a7e..bcdd6e925343 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -503,17 +503,6 @@ config NET_CLS_BASIC
 	  To compile this code as a module, choose M here: the
 	  module will be called cls_basic.
 
-config NET_CLS_TCINDEX
-	tristate "Traffic-Control Index (TCINDEX)"
-	select NET_CLS
-	help
-	  Say Y here if you want to be able to classify packets based on
-	  traffic control indices. You will want this feature if you want
-	  to implement Differentiated Services together with DSMARK.
-
-	  To compile this code as a module, choose M here: the
-	  module will be called cls_tcindex.
-
 config NET_CLS_ROUTE4
 	tristate "Routing decision (ROUTE)"
 	depends on INET
diff --git a/net/sched/Makefile b/net/sched/Makefile
index dd14ef413fda..b7dbac5c519f 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -70,7 +70,6 @@ obj-$(CONFIG_NET_CLS_U32)	+= cls_u32.o
 obj-$(CONFIG_NET_CLS_ROUTE4)	+= cls_route.o
 obj-$(CONFIG_NET_CLS_FW)	+= cls_fw.o
 obj-$(CONFIG_NET_CLS_RSVP)	+= cls_rsvp.o
-obj-$(CONFIG_NET_CLS_TCINDEX)	+= cls_tcindex.o
 obj-$(CONFIG_NET_CLS_RSVP6)	+= cls_rsvp6.o
 obj-$(CONFIG_NET_CLS_BASIC)	+= cls_basic.o
 obj-$(CONFIG_NET_CLS_FLOW)	+= cls_flow.o
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index ea5959094adb..f24f997a7aaf 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -188,40 +188,67 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	parm = nla_data(tb[TCA_MPLS_PARMS]);
 	index = parm->index;
 
+	err = tcf_idr_check_alloc(tn, &index, a, bind);
+	if (err < 0)
+		return err;
+	exists = err;
+	if (exists && bind)
+		return 0;
+
+	if (!exists) {
+		ret = tcf_idr_create(tn, index, est, a, &act_mpls_ops, bind,
+				     true, flags);
+		if (ret) {
+			tcf_idr_cleanup(tn, index);
+			return ret;
+		}
+
+		ret = ACT_P_CREATED;
+	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+		tcf_idr_release(*a, bind);
+		return -EEXIST;
+	}
+
 	/* Verify parameters against action type. */
 	switch (parm->m_action) {
 	case TCA_MPLS_ACT_POP:
 		if (!tb[TCA_MPLS_PROTO]) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol must be set for MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (!eth_proto_is_802_3(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
 			NL_SET_ERR_MSG_MOD(extack, "Invalid protocol type for MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (tb[TCA_MPLS_LABEL] || tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] ||
 		    tb[TCA_MPLS_BOS]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC or BOS cannot be used with MPLS pop");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	case TCA_MPLS_ACT_DEC_TTL:
 		if (tb[TCA_MPLS_PROTO] || tb[TCA_MPLS_LABEL] ||
 		    tb[TCA_MPLS_TTL] || tb[TCA_MPLS_TC] || tb[TCA_MPLS_BOS]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label, TTL, TC, BOS or protocol cannot be used with MPLS dec_ttl");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	case TCA_MPLS_ACT_PUSH:
 	case TCA_MPLS_ACT_MAC_PUSH:
 		if (!tb[TCA_MPLS_LABEL]) {
 			NL_SET_ERR_MSG_MOD(extack, "Label is required for MPLS push");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		if (tb[TCA_MPLS_PROTO] &&
 		    !eth_p_mpls(nla_get_be16(tb[TCA_MPLS_PROTO]))) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol must be an MPLS type for MPLS push");
-			return -EPROTONOSUPPORT;
+			err = -EPROTONOSUPPORT;
+			goto release_idr;
 		}
 		/* Push needs a TTL - if not specified, set a default value. */
 		if (!tb[TCA_MPLS_TTL]) {
@@ -236,33 +263,14 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
 	case TCA_MPLS_ACT_MODIFY:
 		if (tb[TCA_MPLS_PROTO]) {
 			NL_SET_ERR_MSG_MOD(extack, "Protocol cannot be used with MPLS modify");
-			return -EINVAL;
+			err = -EINVAL;
+			goto release_idr;
 		}
 		break;
 	default:
 		NL_SET_ERR_MSG_MOD(extack, "Unknown MPLS action");
-		return -EINVAL;
-	}
-
-	err = tcf_idr_check_alloc(tn, &index, a, bind);
-	if (err < 0)
-		return err;
-	exists = err;
-	if (exists && bind)
-		return 0;
-
-	if (!exists) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_mpls_ops, bind, true, flags);
-		if (ret) {
-			tcf_idr_cleanup(tn, index);
-			return ret;
-		}
-
-		ret = ACT_P_CREATED;
-	} else if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
-		tcf_idr_release(*a, bind);
-		return -EEXIST;
+		err = -EINVAL;
+		goto release_idr;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 94ed5857ce67..238759c3192e 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -133,6 +133,17 @@ static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
 	return -EINVAL;
 }
 
+static void tcf_pedit_cleanup_rcu(struct rcu_head *head)
+{
+	struct tcf_pedit_parms *parms =
+		container_of(head, struct tcf_pedit_parms, rcu);
+
+	kfree(parms->tcfp_keys_ex);
+	kfree(parms->tcfp_keys);
+
+	kfree(parms);
+}
+
 static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 			  struct nlattr *est, struct tc_action **a,
 			  struct tcf_proto *tp, u32 flags,
@@ -140,10 +151,9 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 {
 	struct tc_action_net *tn = net_generic(net, act_pedit_ops.net_id);
 	bool bind = flags & TCA_ACT_FLAGS_BIND;
-	struct nlattr *tb[TCA_PEDIT_MAX + 1];
 	struct tcf_chain *goto_ch = NULL;
-	struct tc_pedit_key *keys = NULL;
-	struct tcf_pedit_key_ex *keys_ex;
+	struct tcf_pedit_parms *oparms, *nparms;
+	struct nlattr *tb[TCA_PEDIT_MAX + 1];
 	struct tc_pedit *parm;
 	struct nlattr *pattr;
 	struct tcf_pedit *p;
@@ -170,109 +180,125 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	parm = nla_data(pattr);
-	if (!parm->nkeys) {
-		NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
-		return -EINVAL;
-	}
-	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
-	if (nla_len(pattr) < sizeof(*parm) + ksize) {
-		NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
-		return -EINVAL;
-	}
-
-	keys_ex = tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
-	if (IS_ERR(keys_ex))
-		return PTR_ERR(keys_ex);
 
 	index = parm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_pedit_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_pedit_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
-			goto out_free;
+			return ret;
 		}
 		ret = ACT_P_CREATED;
 	} else if (err > 0) {
 		if (bind)
-			goto out_free;
+			return 0;
 		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
 			ret = -EEXIST;
 			goto out_release;
 		}
 	} else {
-		ret = err;
+		return err;
+	}
+
+	if (!parm->nkeys) {
+		NL_SET_ERR_MSG_MOD(extack, "Pedit requires keys to be passed");
+		ret = -EINVAL;
+		goto out_release;
+	}
+	ksize = parm->nkeys * sizeof(struct tc_pedit_key);
+	if (nla_len(pattr) < sizeof(*parm) + ksize) {
+		NL_SET_ERR_MSG_ATTR(extack, pattr, "Length of TCA_PEDIT_PARMS or TCA_PEDIT_PARMS_EX pedit attribute is invalid");
+		ret = -EINVAL;
+		goto out_release;
+	}
+
+	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
+	if (!nparms) {
+		ret = -ENOMEM;
+		goto out_release;
+	}
+
+	nparms->tcfp_keys_ex =
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+	if (IS_ERR(nparms->tcfp_keys_ex)) {
+		ret = PTR_ERR(nparms->tcfp_keys_ex);
 		goto out_free;
 	}
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0) {
 		ret = err;
-		goto out_release;
+		goto out_free_ex;
 	}
-	p = to_pedit(*a);
-	spin_lock_bh(&p->tcf_lock);
 
-	if (ret == ACT_P_CREATED ||
-	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
-		keys = kmalloc(ksize, GFP_ATOMIC);
-		if (!keys) {
-			spin_unlock_bh(&p->tcf_lock);
-			ret = -ENOMEM;
-			goto put_chain;
-		}
-		kfree(p->tcfp_keys);
-		p->tcfp_keys = keys;
-		p->tcfp_nkeys = parm->nkeys;
+	nparms->tcfp_off_max_hint = 0;
+	nparms->tcfp_flags = parm->flags;
+	nparms->tcfp_nkeys = parm->nkeys;
+
+	nparms->tcfp_keys = kmalloc(ksize, GFP_KERNEL);
+	if (!nparms->tcfp_keys) {
+		ret = -ENOMEM;
+		goto put_chain;
 	}
-	memcpy(p->tcfp_keys, parm->keys, ksize);
-	p->tcfp_off_max_hint = 0;
-	for (i = 0; i < p->tcfp_nkeys; ++i) {
-		u32 cur = p->tcfp_keys[i].off;
+
+	memcpy(nparms->tcfp_keys, parm->keys, ksize);
+
+	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
+		u32 cur = nparms->tcfp_keys[i].off;
 
 		/* sanitize the shift value for any later use */
-		p->tcfp_keys[i].shift = min_t(size_t, BITS_PER_TYPE(int) - 1,
-					      p->tcfp_keys[i].shift);
+		nparms->tcfp_keys[i].shift = min_t(size_t,
+						   BITS_PER_TYPE(int) - 1,
+						   nparms->tcfp_keys[i].shift);
 
 		/* The AT option can read a single byte, we can bound the actual
 		 * value with uchar max.
 		 */
-		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
+		cur += (0xff & nparms->tcfp_keys[i].offmask) >> nparms->tcfp_keys[i].shift;
 
 		/* Each key touches 4 bytes starting from the computed offset */
-		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
+		nparms->tcfp_off_max_hint =
+			max(nparms->tcfp_off_max_hint, cur + 4);
 	}
 
-	p->tcfp_flags = parm->flags;
+	p = to_pedit(*a);
+
+	spin_lock_bh(&p->tcf_lock);
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+	oparms = rcu_replace_pointer(p->parms, nparms, 1);
+	spin_unlock_bh(&p->tcf_lock);
 
-	kfree(p->tcfp_keys_ex);
-	p->tcfp_keys_ex = keys_ex;
+	if (oparms)
+		call_rcu(&oparms->rcu, tcf_pedit_cleanup_rcu);
 
-	spin_unlock_bh(&p->tcf_lock);
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
+
 	return ret;
 
 put_chain:
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
+out_free_ex:
+	kfree(nparms->tcfp_keys_ex);
+out_free:
+	kfree(nparms);
 out_release:
 	tcf_idr_release(*a, bind);
-out_free:
-	kfree(keys_ex);
 	return ret;
-
 }
 
 static void tcf_pedit_cleanup(struct tc_action *a)
 {
 	struct tcf_pedit *p = to_pedit(a);
-	struct tc_pedit_key *keys = p->tcfp_keys;
+	struct tcf_pedit_parms *parms;
 
-	kfree(keys);
-	kfree(p->tcfp_keys_ex);
+	parms = rcu_dereference_protected(p->parms, 1);
+
+	if (parms)
+		call_rcu(&parms->rcu, tcf_pedit_cleanup_rcu);
 }
 
 static bool offset_valid(struct sk_buff *skb, int offset)
@@ -323,28 +349,30 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 			 struct tcf_result *res)
 {
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_parms *parms;
 	u32 max_offset;
 	int i;
 
-	spin_lock(&p->tcf_lock);
+	parms = rcu_dereference_bh(p->parms);
 
 	max_offset = (skb_transport_header_was_set(skb) ?
 		      skb_transport_offset(skb) :
 		      skb_network_offset(skb)) +
-		     p->tcfp_off_max_hint;
+		     parms->tcfp_off_max_hint;
 	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
-		goto unlock;
+		goto done;
 
 	tcf_lastuse_update(&p->tcf_tm);
+	tcf_action_update_bstats(&p->common, skb);
 
-	if (p->tcfp_nkeys > 0) {
-		struct tc_pedit_key *tkey = p->tcfp_keys;
-		struct tcf_pedit_key_ex *tkey_ex = p->tcfp_keys_ex;
+	if (parms->tcfp_nkeys > 0) {
+		struct tc_pedit_key *tkey = parms->tcfp_keys;
+		struct tcf_pedit_key_ex *tkey_ex = parms->tcfp_keys_ex;
 		enum pedit_header_type htype =
 			TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK;
 		enum pedit_cmd cmd = TCA_PEDIT_KEY_EX_CMD_SET;
 
-		for (i = p->tcfp_nkeys; i > 0; i--, tkey++) {
+		for (i = parms->tcfp_nkeys; i > 0; i--, tkey++) {
 			u32 *ptr, hdata;
 			int offset = tkey->off;
 			int hoffset;
@@ -420,11 +448,10 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
 	}
 
 bad:
+	spin_lock(&p->tcf_lock);
 	p->tcf_qstats.overlimits++;
-done:
-	bstats_update(&p->tcf_bstats, skb);
-unlock:
 	spin_unlock(&p->tcf_lock);
+done:
 	return p->tcf_action;
 }
 
@@ -443,30 +470,33 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
 {
 	unsigned char *b = skb_tail_pointer(skb);
 	struct tcf_pedit *p = to_pedit(a);
+	struct tcf_pedit_parms *parms;
 	struct tc_pedit *opt;
 	struct tcf_t t;
 	int s;
 
-	s = struct_size(opt, keys, p->tcfp_nkeys);
+	spin_lock_bh(&p->tcf_lock);
+	parms = rcu_dereference_protected(p->parms, 1);
+	s = struct_size(opt, keys, parms->tcfp_nkeys);
 
-	/* netlink spinlocks held above us - must use ATOMIC */
 	opt = kzalloc(s, GFP_ATOMIC);
-	if (unlikely(!opt))
+	if (unlikely(!opt)) {
+		spin_unlock_bh(&p->tcf_lock);
 		return -ENOBUFS;
+	}
 
-	spin_lock_bh(&p->tcf_lock);
-	memcpy(opt->keys, p->tcfp_keys, flex_array_size(opt, keys, p->tcfp_nkeys));
+	memcpy(opt->keys, parms->tcfp_keys,
+	       flex_array_size(opt, keys, parms->tcfp_nkeys));
 	opt->index = p->tcf_index;
-	opt->nkeys = p->tcfp_nkeys;
-	opt->flags = p->tcfp_flags;
+	opt->nkeys = parms->tcfp_nkeys;
+	opt->flags = parms->tcfp_flags;
 	opt->action = p->tcf_action;
 	opt->refcnt = refcount_read(&p->tcf_refcnt) - ref;
 	opt->bindcnt = atomic_read(&p->tcf_bindcnt) - bind;
 
-	if (p->tcfp_keys_ex) {
-		if (tcf_pedit_key_ex_dump(skb,
-					  p->tcfp_keys_ex,
-					  p->tcfp_nkeys))
+	if (parms->tcfp_keys_ex) {
+		if (tcf_pedit_key_ex_dump(skb, parms->tcfp_keys_ex,
+					  parms->tcfp_nkeys))
 			goto nla_put_failure;
 
 		if (nla_put(skb, TCA_PEDIT_PARMS_EX, s, opt))
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 7a25477f5d99..09735a33e57e 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -54,8 +54,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
-	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
-	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
+
+	if (!tb[TCA_SAMPLE_PARMS])
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
@@ -79,6 +79,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		tcf_idr_release(*a, bind);
 		return -EEXIST;
 	}
+
+	if (!tb[TCA_SAMPLE_RATE] || !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
+		NL_SET_ERR_MSG(extack, "sample rate and group are required");
+		err = -EINVAL;
+		goto release_idr;
+	}
+
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
deleted file mode 100644
index eea8e185fcdb..000000000000
--- a/net/sched/cls_tcindex.c
+++ /dev/null
@@ -1,741 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * net/sched/cls_tcindex.c	Packet classifier for skb->tc_index
- *
- * Written 1998,1999 by Werner Almesberger, EPFL ICA
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/skbuff.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <linux/refcount.h>
-#include <linux/rcupdate.h>
-#include <net/act_api.h>
-#include <net/netlink.h>
-#include <net/pkt_cls.h>
-#include <net/sch_generic.h>
-
-/*
- * Passing parameters to the root seems to be done more awkwardly than really
- * necessary. At least, u32 doesn't seem to use such dirty hacks. To be
- * verified. FIXME.
- */
-
-#define PERFECT_HASH_THRESHOLD	64	/* use perfect hash if not bigger */
-#define DEFAULT_HASH_SIZE	64	/* optimized for diffserv */
-
-
-struct tcindex_data;
-
-struct tcindex_filter_result {
-	struct tcf_exts		exts;
-	struct tcf_result	res;
-	struct tcindex_data	*p;
-	struct rcu_work		rwork;
-};
-
-struct tcindex_filter {
-	u16 key;
-	struct tcindex_filter_result result;
-	struct tcindex_filter __rcu *next;
-	struct rcu_work rwork;
-};
-
-
-struct tcindex_data {
-	struct tcindex_filter_result *perfect; /* perfect hash; NULL if none */
-	struct tcindex_filter __rcu **h; /* imperfect hash; */
-	struct tcf_proto *tp;
-	u16 mask;		/* AND key with mask */
-	u32 shift;		/* shift ANDed key to the right */
-	u32 hash;		/* hash table size; 0 if undefined */
-	u32 alloc_hash;		/* allocated size */
-	u32 fall_through;	/* 0: only classify if explicit match */
-	refcount_t refcnt;	/* a temporary refcnt for perfect hash */
-	struct rcu_work rwork;
-};
-
-static inline int tcindex_filter_is_set(struct tcindex_filter_result *r)
-{
-	return tcf_exts_has_actions(&r->exts) || r->res.classid;
-}
-
-static void tcindex_data_get(struct tcindex_data *p)
-{
-	refcount_inc(&p->refcnt);
-}
-
-static void tcindex_data_put(struct tcindex_data *p)
-{
-	if (refcount_dec_and_test(&p->refcnt)) {
-		kfree(p->perfect);
-		kfree(p->h);
-		kfree(p);
-	}
-}
-
-static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
-						    u16 key)
-{
-	if (p->perfect) {
-		struct tcindex_filter_result *f = p->perfect + key;
-
-		return tcindex_filter_is_set(f) ? f : NULL;
-	} else if (p->h) {
-		struct tcindex_filter __rcu **fp;
-		struct tcindex_filter *f;
-
-		fp = &p->h[key % p->hash];
-		for (f = rcu_dereference_bh_rtnl(*fp);
-		     f;
-		     fp = &f->next, f = rcu_dereference_bh_rtnl(*fp))
-			if (f->key == key)
-				return &f->result;
-	}
-
-	return NULL;
-}
-
-
-static int tcindex_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			    struct tcf_result *res)
-{
-	struct tcindex_data *p = rcu_dereference_bh(tp->root);
-	struct tcindex_filter_result *f;
-	int key = (skb->tc_index & p->mask) >> p->shift;
-
-	pr_debug("tcindex_classify(skb %p,tp %p,res %p),p %p\n",
-		 skb, tp, res, p);
-
-	f = tcindex_lookup(p, key);
-	if (!f) {
-		struct Qdisc *q = tcf_block_q(tp->chain->block);
-
-		if (!p->fall_through)
-			return -1;
-		res->classid = TC_H_MAKE(TC_H_MAJ(q->handle), key);
-		res->class = 0;
-		pr_debug("alg 0x%x\n", res->classid);
-		return 0;
-	}
-	*res = f->res;
-	pr_debug("map 0x%x\n", res->classid);
-
-	return tcf_exts_exec(skb, &f->exts, res);
-}
-
-
-static void *tcindex_get(struct tcf_proto *tp, u32 handle)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r;
-
-	pr_debug("tcindex_get(tp %p,handle 0x%08x)\n", tp, handle);
-	if (p->perfect && handle >= p->alloc_hash)
-		return NULL;
-	r = tcindex_lookup(p, handle);
-	return r && tcindex_filter_is_set(r) ? r : NULL;
-}
-
-static int tcindex_init(struct tcf_proto *tp)
-{
-	struct tcindex_data *p;
-
-	pr_debug("tcindex_init(tp %p)\n", tp);
-	p = kzalloc(sizeof(struct tcindex_data), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	p->mask = 0xffff;
-	p->hash = DEFAULT_HASH_SIZE;
-	p->fall_through = 1;
-	refcount_set(&p->refcnt, 1); /* Paired with tcindex_destroy_work() */
-
-	rcu_assign_pointer(tp->root, p);
-	return 0;
-}
-
-static void __tcindex_destroy_rexts(struct tcindex_filter_result *r)
-{
-	tcf_exts_destroy(&r->exts);
-	tcf_exts_put_net(&r->exts);
-	tcindex_data_put(r->p);
-}
-
-static void tcindex_destroy_rexts_work(struct work_struct *work)
-{
-	struct tcindex_filter_result *r;
-
-	r = container_of(to_rcu_work(work),
-			 struct tcindex_filter_result,
-			 rwork);
-	rtnl_lock();
-	__tcindex_destroy_rexts(r);
-	rtnl_unlock();
-}
-
-static void __tcindex_destroy_fexts(struct tcindex_filter *f)
-{
-	tcf_exts_destroy(&f->result.exts);
-	tcf_exts_put_net(&f->result.exts);
-	kfree(f);
-}
-
-static void tcindex_destroy_fexts_work(struct work_struct *work)
-{
-	struct tcindex_filter *f = container_of(to_rcu_work(work),
-						struct tcindex_filter,
-						rwork);
-
-	rtnl_lock();
-	__tcindex_destroy_fexts(f);
-	rtnl_unlock();
-}
-
-static int tcindex_delete(struct tcf_proto *tp, void *arg, bool *last,
-			  bool rtnl_held, struct netlink_ext_ack *extack)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r = arg;
-	struct tcindex_filter __rcu **walk;
-	struct tcindex_filter *f = NULL;
-
-	pr_debug("tcindex_delete(tp %p,arg %p),p %p\n", tp, arg, p);
-	if (p->perfect) {
-		if (!r->res.class)
-			return -ENOENT;
-	} else {
-		int i;
-
-		for (i = 0; i < p->hash; i++) {
-			walk = p->h + i;
-			for (f = rtnl_dereference(*walk); f;
-			     walk = &f->next, f = rtnl_dereference(*walk)) {
-				if (&f->result == r)
-					goto found;
-			}
-		}
-		return -ENOENT;
-
-found:
-		rcu_assign_pointer(*walk, rtnl_dereference(f->next));
-	}
-	tcf_unbind_filter(tp, &r->res);
-	/* all classifiers are required to call tcf_exts_destroy() after rcu
-	 * grace period, since converted-to-rcu actions are relying on that
-	 * in cleanup() callback
-	 */
-	if (f) {
-		if (tcf_exts_get_net(&f->result.exts))
-			tcf_queue_work(&f->rwork, tcindex_destroy_fexts_work);
-		else
-			__tcindex_destroy_fexts(f);
-	} else {
-		tcindex_data_get(p);
-
-		if (tcf_exts_get_net(&r->exts))
-			tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
-		else
-			__tcindex_destroy_rexts(r);
-	}
-
-	*last = false;
-	return 0;
-}
-
-static void tcindex_destroy_work(struct work_struct *work)
-{
-	struct tcindex_data *p = container_of(to_rcu_work(work),
-					      struct tcindex_data,
-					      rwork);
-
-	tcindex_data_put(p);
-}
-
-static inline int
-valid_perfect_hash(struct tcindex_data *p)
-{
-	return  p->hash > (p->mask >> p->shift);
-}
-
-static const struct nla_policy tcindex_policy[TCA_TCINDEX_MAX + 1] = {
-	[TCA_TCINDEX_HASH]		= { .type = NLA_U32 },
-	[TCA_TCINDEX_MASK]		= { .type = NLA_U16 },
-	[TCA_TCINDEX_SHIFT]		= { .type = NLA_U32 },
-	[TCA_TCINDEX_FALL_THROUGH]	= { .type = NLA_U32 },
-	[TCA_TCINDEX_CLASSID]		= { .type = NLA_U32 },
-};
-
-static int tcindex_filter_result_init(struct tcindex_filter_result *r,
-				      struct tcindex_data *p,
-				      struct net *net)
-{
-	memset(r, 0, sizeof(*r));
-	r->p = p;
-	return tcf_exts_init(&r->exts, net, TCA_TCINDEX_ACT,
-			     TCA_TCINDEX_POLICE);
-}
-
-static void tcindex_free_perfect_hash(struct tcindex_data *cp);
-
-static void tcindex_partial_destroy_work(struct work_struct *work)
-{
-	struct tcindex_data *p = container_of(to_rcu_work(work),
-					      struct tcindex_data,
-					      rwork);
-
-	rtnl_lock();
-	if (p->perfect)
-		tcindex_free_perfect_hash(p);
-	kfree(p);
-	rtnl_unlock();
-}
-
-static void tcindex_free_perfect_hash(struct tcindex_data *cp)
-{
-	int i;
-
-	for (i = 0; i < cp->hash; i++)
-		tcf_exts_destroy(&cp->perfect[i].exts);
-	kfree(cp->perfect);
-}
-
-static int tcindex_alloc_perfect_hash(struct net *net, struct tcindex_data *cp)
-{
-	int i, err = 0;
-
-	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
-			      GFP_KERNEL | __GFP_NOWARN);
-	if (!cp->perfect)
-		return -ENOMEM;
-
-	for (i = 0; i < cp->hash; i++) {
-		err = tcf_exts_init(&cp->perfect[i].exts, net,
-				    TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
-		if (err < 0)
-			goto errout;
-		cp->perfect[i].p = cp;
-	}
-
-	return 0;
-
-errout:
-	tcindex_free_perfect_hash(cp);
-	return err;
-}
-
-static int
-tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
-		  u32 handle, struct tcindex_data *p,
-		  struct tcindex_filter_result *r, struct nlattr **tb,
-		  struct nlattr *est, u32 flags, struct netlink_ext_ack *extack)
-{
-	struct tcindex_filter_result new_filter_result;
-	struct tcindex_data *cp = NULL, *oldp;
-	struct tcindex_filter *f = NULL; /* make gcc behave */
-	struct tcf_result cr = {};
-	int err, balloc = 0;
-	struct tcf_exts e;
-	bool update_h = false;
-
-	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
-	if (err < 0)
-		return err;
-	err = tcf_exts_validate(net, tp, tb, est, &e, flags, extack);
-	if (err < 0)
-		goto errout;
-
-	err = -ENOMEM;
-	/* tcindex_data attributes must look atomic to classifier/lookup so
-	 * allocate new tcindex data and RCU assign it onto root. Keeping
-	 * perfect hash and hash pointers from old data.
-	 */
-	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
-	if (!cp)
-		goto errout;
-
-	cp->mask = p->mask;
-	cp->shift = p->shift;
-	cp->hash = p->hash;
-	cp->alloc_hash = p->alloc_hash;
-	cp->fall_through = p->fall_through;
-	cp->tp = tp;
-	refcount_set(&cp->refcnt, 1); /* Paired with tcindex_destroy_work() */
-
-	if (tb[TCA_TCINDEX_HASH])
-		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
-
-	if (tb[TCA_TCINDEX_MASK])
-		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
-
-	if (tb[TCA_TCINDEX_SHIFT]) {
-		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
-		if (cp->shift > 16) {
-			err = -EINVAL;
-			goto errout;
-		}
-	}
-	if (!cp->hash) {
-		/* Hash not specified, use perfect hash if the upper limit
-		 * of the hashing index is below the threshold.
-		 */
-		if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
-			cp->hash = (cp->mask >> cp->shift) + 1;
-		else
-			cp->hash = DEFAULT_HASH_SIZE;
-	}
-
-	if (p->perfect) {
-		int i;
-
-		if (tcindex_alloc_perfect_hash(net, cp) < 0)
-			goto errout;
-		cp->alloc_hash = cp->hash;
-		for (i = 0; i < min(cp->hash, p->hash); i++)
-			cp->perfect[i].res = p->perfect[i].res;
-		balloc = 1;
-	}
-	cp->h = p->h;
-
-	err = tcindex_filter_result_init(&new_filter_result, cp, net);
-	if (err < 0)
-		goto errout_alloc;
-	if (r)
-		cr = r->res;
-
-	err = -EBUSY;
-
-	/* Hash already allocated, make sure that we still meet the
-	 * requirements for the allocated hash.
-	 */
-	if (cp->perfect) {
-		if (!valid_perfect_hash(cp) ||
-		    cp->hash > cp->alloc_hash)
-			goto errout_alloc;
-	} else if (cp->h && cp->hash != cp->alloc_hash) {
-		goto errout_alloc;
-	}
-
-	err = -EINVAL;
-	if (tb[TCA_TCINDEX_FALL_THROUGH])
-		cp->fall_through = nla_get_u32(tb[TCA_TCINDEX_FALL_THROUGH]);
-
-	if (!cp->perfect && !cp->h)
-		cp->alloc_hash = cp->hash;
-
-	/* Note: this could be as restrictive as if (handle & ~(mask >> shift))
-	 * but then, we'd fail handles that may become valid after some future
-	 * mask change. While this is extremely unlikely to ever matter,
-	 * the check below is safer (and also more backwards-compatible).
-	 */
-	if (cp->perfect || valid_perfect_hash(cp))
-		if (handle >= cp->alloc_hash)
-			goto errout_alloc;
-
-
-	err = -ENOMEM;
-	if (!cp->perfect && !cp->h) {
-		if (valid_perfect_hash(cp)) {
-			if (tcindex_alloc_perfect_hash(net, cp) < 0)
-				goto errout_alloc;
-			balloc = 1;
-		} else {
-			struct tcindex_filter __rcu **hash;
-
-			hash = kcalloc(cp->hash,
-				       sizeof(struct tcindex_filter *),
-				       GFP_KERNEL);
-
-			if (!hash)
-				goto errout_alloc;
-
-			cp->h = hash;
-			balloc = 2;
-		}
-	}
-
-	if (cp->perfect) {
-		r = cp->perfect + handle;
-	} else {
-		/* imperfect area is updated in-place using rcu */
-		update_h = !!tcindex_lookup(cp, handle);
-		r = &new_filter_result;
-	}
-
-	if (r == &new_filter_result) {
-		f = kzalloc(sizeof(*f), GFP_KERNEL);
-		if (!f)
-			goto errout_alloc;
-		f->key = handle;
-		f->next = NULL;
-		err = tcindex_filter_result_init(&f->result, cp, net);
-		if (err < 0) {
-			kfree(f);
-			goto errout_alloc;
-		}
-	}
-
-	if (tb[TCA_TCINDEX_CLASSID]) {
-		cr.classid = nla_get_u32(tb[TCA_TCINDEX_CLASSID]);
-		tcf_bind_filter(tp, &cr, base);
-	}
-
-	oldp = p;
-	r->res = cr;
-	tcf_exts_change(&r->exts, &e);
-
-	rcu_assign_pointer(tp->root, cp);
-
-	if (update_h) {
-		struct tcindex_filter __rcu **fp;
-		struct tcindex_filter *cf;
-
-		f->result.res = r->res;
-		tcf_exts_change(&f->result.exts, &r->exts);
-
-		/* imperfect area bucket */
-		fp = cp->h + (handle % cp->hash);
-
-		/* lookup the filter, guaranteed to exist */
-		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
-		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
-			if (cf->key == (u16)handle)
-				break;
-
-		f->next = cf->next;
-
-		cf = rcu_replace_pointer(*fp, f, 1);
-		tcf_exts_get_net(&cf->result.exts);
-		tcf_queue_work(&cf->rwork, tcindex_destroy_fexts_work);
-	} else if (r == &new_filter_result) {
-		struct tcindex_filter *nfp;
-		struct tcindex_filter __rcu **fp;
-
-		f->result.res = r->res;
-		tcf_exts_change(&f->result.exts, &r->exts);
-
-		fp = cp->h + (handle % cp->hash);
-		for (nfp = rtnl_dereference(*fp);
-		     nfp;
-		     fp = &nfp->next, nfp = rtnl_dereference(*fp))
-				; /* nothing */
-
-		rcu_assign_pointer(*fp, f);
-	} else {
-		tcf_exts_destroy(&new_filter_result.exts);
-	}
-
-	if (oldp)
-		tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
-	return 0;
-
-errout_alloc:
-	if (balloc == 1)
-		tcindex_free_perfect_hash(cp);
-	else if (balloc == 2)
-		kfree(cp->h);
-	tcf_exts_destroy(&new_filter_result.exts);
-errout:
-	kfree(cp);
-	tcf_exts_destroy(&e);
-	return err;
-}
-
-static int
-tcindex_change(struct net *net, struct sk_buff *in_skb,
-	       struct tcf_proto *tp, unsigned long base, u32 handle,
-	       struct nlattr **tca, void **arg, u32 flags,
-	       struct netlink_ext_ack *extack)
-{
-	struct nlattr *opt = tca[TCA_OPTIONS];
-	struct nlattr *tb[TCA_TCINDEX_MAX + 1];
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r = *arg;
-	int err;
-
-	pr_debug("tcindex_change(tp %p,handle 0x%08x,tca %p,arg %p),opt %p,"
-	    "p %p,r %p,*arg %p\n",
-	    tp, handle, tca, arg, opt, p, r, *arg);
-
-	if (!opt)
-		return 0;
-
-	err = nla_parse_nested_deprecated(tb, TCA_TCINDEX_MAX, opt,
-					  tcindex_policy, NULL);
-	if (err < 0)
-		return err;
-
-	return tcindex_set_parms(net, tp, base, handle, p, r, tb,
-				 tca[TCA_RATE], flags, extack);
-}
-
-static void tcindex_walk(struct tcf_proto *tp, struct tcf_walker *walker,
-			 bool rtnl_held)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter *f, *next;
-	int i;
-
-	pr_debug("tcindex_walk(tp %p,walker %p),p %p\n", tp, walker, p);
-	if (p->perfect) {
-		for (i = 0; i < p->hash; i++) {
-			if (!p->perfect[i].res.class)
-				continue;
-			if (!tc_cls_stats_dump(tp, walker, p->perfect + i))
-				return;
-		}
-	}
-	if (!p->h)
-		return;
-	for (i = 0; i < p->hash; i++) {
-		for (f = rtnl_dereference(p->h[i]); f; f = next) {
-			next = rtnl_dereference(f->next);
-			if (!tc_cls_stats_dump(tp, walker, &f->result))
-				return;
-		}
-	}
-}
-
-static void tcindex_destroy(struct tcf_proto *tp, bool rtnl_held,
-			    struct netlink_ext_ack *extack)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	int i;
-
-	pr_debug("tcindex_destroy(tp %p),p %p\n", tp, p);
-
-	if (p->perfect) {
-		for (i = 0; i < p->hash; i++) {
-			struct tcindex_filter_result *r = p->perfect + i;
-
-			/* tcf_queue_work() does not guarantee the ordering we
-			 * want, so we have to take this refcnt temporarily to
-			 * ensure 'p' is freed after all tcindex_filter_result
-			 * here. Imperfect hash does not need this, because it
-			 * uses linked lists rather than an array.
-			 */
-			tcindex_data_get(p);
-
-			tcf_unbind_filter(tp, &r->res);
-			if (tcf_exts_get_net(&r->exts))
-				tcf_queue_work(&r->rwork,
-					       tcindex_destroy_rexts_work);
-			else
-				__tcindex_destroy_rexts(r);
-		}
-	}
-
-	for (i = 0; p->h && i < p->hash; i++) {
-		struct tcindex_filter *f, *next;
-		bool last;
-
-		for (f = rtnl_dereference(p->h[i]); f; f = next) {
-			next = rtnl_dereference(f->next);
-			tcindex_delete(tp, &f->result, &last, rtnl_held, NULL);
-		}
-	}
-
-	tcf_queue_work(&p->rwork, tcindex_destroy_work);
-}
-
-
-static int tcindex_dump(struct net *net, struct tcf_proto *tp, void *fh,
-			struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r = fh;
-	struct nlattr *nest;
-
-	pr_debug("tcindex_dump(tp %p,fh %p,skb %p,t %p),p %p,r %p\n",
-		 tp, fh, skb, t, p, r);
-	pr_debug("p->perfect %p p->h %p\n", p->perfect, p->h);
-
-	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
-	if (nest == NULL)
-		goto nla_put_failure;
-
-	if (!fh) {
-		t->tcm_handle = ~0; /* whatever ... */
-		if (nla_put_u32(skb, TCA_TCINDEX_HASH, p->hash) ||
-		    nla_put_u16(skb, TCA_TCINDEX_MASK, p->mask) ||
-		    nla_put_u32(skb, TCA_TCINDEX_SHIFT, p->shift) ||
-		    nla_put_u32(skb, TCA_TCINDEX_FALL_THROUGH, p->fall_through))
-			goto nla_put_failure;
-		nla_nest_end(skb, nest);
-	} else {
-		if (p->perfect) {
-			t->tcm_handle = r - p->perfect;
-		} else {
-			struct tcindex_filter *f;
-			struct tcindex_filter __rcu **fp;
-			int i;
-
-			t->tcm_handle = 0;
-			for (i = 0; !t->tcm_handle && i < p->hash; i++) {
-				fp = &p->h[i];
-				for (f = rtnl_dereference(*fp);
-				     !t->tcm_handle && f;
-				     fp = &f->next, f = rtnl_dereference(*fp)) {
-					if (&f->result == r)
-						t->tcm_handle = f->key;
-				}
-			}
-		}
-		pr_debug("handle = %d\n", t->tcm_handle);
-		if (r->res.class &&
-		    nla_put_u32(skb, TCA_TCINDEX_CLASSID, r->res.classid))
-			goto nla_put_failure;
-
-		if (tcf_exts_dump(skb, &r->exts) < 0)
-			goto nla_put_failure;
-		nla_nest_end(skb, nest);
-
-		if (tcf_exts_dump_stats(skb, &r->exts) < 0)
-			goto nla_put_failure;
-	}
-
-	return skb->len;
-
-nla_put_failure:
-	nla_nest_cancel(skb, nest);
-	return -1;
-}
-
-static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl,
-			       void *q, unsigned long base)
-{
-	struct tcindex_filter_result *r = fh;
-
-	tc_cls_bind_class(classid, cl, q, &r->res, base);
-}
-
-static struct tcf_proto_ops cls_tcindex_ops __read_mostly = {
-	.kind		=	"tcindex",
-	.classify	=	tcindex_classify,
-	.init		=	tcindex_init,
-	.destroy	=	tcindex_destroy,
-	.get		=	tcindex_get,
-	.change		=	tcindex_change,
-	.delete		=	tcindex_delete,
-	.walk		=	tcindex_walk,
-	.dump		=	tcindex_dump,
-	.bind_class	=	tcindex_bind_class,
-	.owner		=	THIS_MODULE,
-};
-
-static int __init init_tcindex(void)
-{
-	return register_tcf_proto_ops(&cls_tcindex_ops);
-}
-
-static void __exit exit_tcindex(void)
-{
-	unregister_tcf_proto_ops(&cls_tcindex_ops);
-}
-
-module_init(init_tcindex)
-module_exit(exit_tcindex)
-MODULE_LICENSE("GPL");
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 4fc9f2923ed1..7dd9f8b387cc 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -25,6 +25,18 @@
 
 static void sctp_sched_prio_unsched_all(struct sctp_stream *stream);
 
+static struct sctp_stream_priorities *sctp_sched_prio_head_get(struct sctp_stream_priorities *p)
+{
+	p->users++;
+	return p;
+}
+
+static void sctp_sched_prio_head_put(struct sctp_stream_priorities *p)
+{
+	if (p && --p->users == 0)
+		kfree(p);
+}
+
 static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 			struct sctp_stream *stream, int prio, gfp_t gfp)
 {
@@ -38,6 +50,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 	INIT_LIST_HEAD(&p->active);
 	p->next = NULL;
 	p->prio = prio;
+	p->users = 1;
 
 	return p;
 }
@@ -53,7 +66,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 	 */
 	list_for_each_entry(p, &stream->prio_list, prio_sched) {
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 		if (p->prio > prio)
 			break;
 	}
@@ -70,7 +83,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 			 */
 			break;
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 	}
 
 	/* If not even there, allocate a new one. */
@@ -154,32 +167,21 @@ static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 	struct sctp_stream_out_ext *soute = sout->ext;
 	struct sctp_stream_priorities *prio_head, *old;
 	bool reschedule = false;
-	int i;
+
+	old = soute->prio_head;
+	if (old && old->prio == prio)
+		return 0;
 
 	prio_head = sctp_sched_prio_get_head(stream, prio, gfp);
 	if (!prio_head)
 		return -ENOMEM;
 
 	reschedule = sctp_sched_prio_unsched(soute);
-	old = soute->prio_head;
 	soute->prio_head = prio_head;
 	if (reschedule)
 		sctp_sched_prio_sched(stream, soute);
 
-	if (!old)
-		/* Happens when we set the priority for the first time */
-		return 0;
-
-	for (i = 0; i < stream->outcnt; i++) {
-		soute = SCTP_SO(stream, i)->ext;
-		if (soute && soute->prio_head == old)
-			/* It's still in use, nothing else to do here. */
-			return 0;
-	}
-
-	/* No hits, we are good to free it. */
-	kfree(old);
-
+	sctp_sched_prio_head_put(old);
 	return 0;
 }
 
@@ -206,20 +208,8 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 
 static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
 {
-	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
-	int i;
-
-	if (!prio)
-		return;
-
+	sctp_sched_prio_head_put(SCTP_SO(stream, sid)->ext->prio_head);
 	SCTP_SO(stream, sid)->ext->prio_head = NULL;
-	for (i = 0; i < stream->outcnt; i++) {
-		if (SCTP_SO(stream, i)->ext &&
-		    SCTP_SO(stream, i)->ext->prio_head == prio)
-			return;
-	}
-
-	kfree(prio);
 }
 
 static void sctp_sched_prio_free(struct sctp_stream *stream)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index a83d2b4275fa..38dcd9b40102 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -941,7 +941,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			       MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1275,7 +1277,9 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2416,11 +2420,19 @@ static void tx_work_handler(struct work_struct *work)
 
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
-	mutex_lock(&tls_ctx->tx_lock);
-	lock_sock(sk);
-	tls_tx_records(sk, -1);
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
+
+	if (mutex_trylock(&tls_ctx->tx_lock)) {
+		lock_sock(sk);
+		tls_tx_records(sk, -1);
+		release_sock(sk);
+		mutex_unlock(&tls_ctx->tx_lock);
+	} else if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		/* Someone is holding the tx_lock, they will likely run Tx
+		 * and cancel the work on their way out of the lock section.
+		 * Schedule a long delay just in case.
+		 */
+		schedule_delayed_work(&ctx->tx_work.work, msecs_to_jiffies(10));
+	}
 }
 
 static bool tls_is_tx_ready(struct tls_sw_context_tx *ctx)
diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index 24381c42eb54..64750db9b963 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -101,7 +101,6 @@
 #define SERDES_CONF_UNK3	BIT(14)
 #define SERDES_CONF_NO_DATA_FEEDBACK	BIT(15)
 #define SERDES_CONF_SYNC_SEL	GENMASK(18, 16)
-#define SERDES_CONF_SOME_RST	BIT(19)
 #define REG_TX_SERDES_BITSTART	0x08
 #define REG_RX_SERDES_BITSTART	0x0c
 #define REG_TX_SERDES_SLOTMASK	0x0c
@@ -203,15 +202,24 @@ static void mca_fe_early_trigger(struct snd_pcm_substream *substream, int cmd,
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, 0));
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, 7));
 		mca_modify(cl, serdes_unit + REG_SERDES_STATUS,
 			   SERDES_STATUS_EN | SERDES_STATUS_RST,
 			   SERDES_STATUS_RST);
-		mca_modify(cl, serdes_conf, SERDES_CONF_SOME_RST,
-			   SERDES_CONF_SOME_RST);
-		readl_relaxed(cl->base + serdes_conf);
-		mca_modify(cl, serdes_conf, SERDES_STATUS_RST, 0);
-		WARN_ON(readl_relaxed(cl->base + REG_SERDES_STATUS) &
+		/*
+		 * Experiments suggest that it takes at most ~1 us
+		 * for the bit to clear, so wait 2 us for good measure.
+		 */
+		udelay(2);
+		WARN_ON(readl_relaxed(cl->base + serdes_unit + REG_SERDES_STATUS) &
 			SERDES_STATUS_RST);
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, 0));
+		mca_modify(cl, serdes_conf, SERDES_CONF_SYNC_SEL,
+			   FIELD_PREP(SERDES_CONF_SYNC_SEL, cl->no + 1));
 		break;
 	default:
 		break;
@@ -942,10 +950,17 @@ static int mca_pcm_new(struct snd_soc_component *component,
 		chan = mca_request_dma_channel(cl, i);
 
 		if (IS_ERR_OR_NULL(chan)) {
+			mca_pcm_free(component, rtd->pcm);
+
+			if (chan && PTR_ERR(chan) == -EPROBE_DEFER)
+				return PTR_ERR(chan);
+
 			dev_err(component->dev, "unable to obtain DMA channel (stream %d cluster %d): %pe\n",
 				i, cl->no, chan);
-			mca_pcm_free(component, rtd->pcm);
-			return -EINVAL;
+
+			if (!chan)
+				return -EINVAL;
+			return PTR_ERR(chan);
 		}
 
 		cl->dma_chans[i] = chan;
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 7022e6286e6c..3f16ad1c3758 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -2039,6 +2039,7 @@ config SND_SOC_WSA883X
 config SND_SOC_ZL38060
 	tristate "Microsemi ZL38060 Connected Home Audio Processor"
 	depends on SPI_MASTER
+	depends on GPIOLIB
 	select REGMAP
 	help
 	  Support for ZL38060 Connected Home Audio Processor from Microsemi,
diff --git a/sound/soc/codecs/adau7118.c b/sound/soc/codecs/adau7118.c
index bbb097249887..a663d37e5776 100644
--- a/sound/soc/codecs/adau7118.c
+++ b/sound/soc/codecs/adau7118.c
@@ -444,22 +444,6 @@ static const struct snd_soc_component_driver adau7118_component_driver = {
 	.endianness		= 1,
 };
 
-static void adau7118_regulator_disable(void *data)
-{
-	struct adau7118_data *st = data;
-	int ret;
-	/*
-	 * If we fail to disable DVDD, don't bother in trying IOVDD. We
-	 * actually don't want to be left in the situation where DVDD
-	 * is enabled and IOVDD is disabled.
-	 */
-	ret = regulator_disable(st->dvdd);
-	if (ret)
-		return;
-
-	regulator_disable(st->iovdd);
-}
-
 static int adau7118_regulator_setup(struct adau7118_data *st)
 {
 	st->iovdd = devm_regulator_get(st->dev, "iovdd");
@@ -481,8 +465,7 @@ static int adau7118_regulator_setup(struct adau7118_data *st)
 		regcache_cache_only(st->map, true);
 	}
 
-	return devm_add_action_or_reset(st->dev, adau7118_regulator_disable,
-					st);
+	return 0;
 }
 
 static int adau7118_parset_dt(const struct adau7118_data *st)
diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index c2e268054773..f2c9a1fdbe0d 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2567,6 +2567,9 @@ static void mt8195_dai_etdm_parse_of(struct mtk_base_afe *afe)
 
 	/* etdm in only */
 	for (i = 0; i < 2; i++) {
+		dai_id = ETDM_TO_DAI_ID(i);
+		etdm_data = afe_priv->dai_priv[dai_id];
+
 		ret = snprintf(prop, sizeof(prop),
 			       "mediatek,%s-chn-disabled",
 			       of_afe_etdms[i].name);
diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index 8d35893b2fa8..6a00a6eecaef 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -264,6 +264,7 @@ int iioutils_get_param_float(float *output, const char *param_name,
 			if (fscanf(sysfsfp, "%f", output) != 1)
 				ret = errno ? -errno : -ENODATA;
 
+			fclose(sysfsfp);
 			break;
 		}
 error_free_filename:
@@ -345,9 +346,9 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
@@ -357,7 +358,6 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_close_dir;
 			}
 			if (ret == 1)
@@ -365,11 +365,9 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
-			free(filename);
 		}
 
 	*ci_array = malloc(sizeof(**ci_array) * (*counter));
@@ -395,9 +393,9 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
@@ -405,20 +403,17 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 			errno = 0;
 			if (fscanf(sysfsfp, "%i", &current_enabled) != 1) {
 				ret = errno ? -errno : -ENODATA;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
 
 			if (!current_enabled) {
-				free(filename);
 				count--;
 				continue;
 			}
@@ -429,7 +424,6 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 						strlen(ent->d_name) -
 						strlen("_en"));
 			if (!current->name) {
-				free(filename);
 				ret = -ENOMEM;
 				count--;
 				goto error_cleanup_array;
@@ -439,7 +433,6 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 			ret = iioutils_break_up_name(current->name,
 						     &current->generic_name);
 			if (ret) {
-				free(filename);
 				free(current->name);
 				count--;
 				goto error_cleanup_array;
@@ -450,17 +443,16 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 				       scan_el_dir,
 				       current->name);
 			if (ret < 0) {
-				free(filename);
 				ret = -ENOMEM;
 				goto error_cleanup_array;
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				fprintf(stderr, "failed to open %s\n",
-					filename);
-				free(filename);
+				fprintf(stderr, "failed to open %s/%s_index\n",
+					scan_el_dir, current->name);
 				goto error_cleanup_array;
 			}
 
@@ -470,17 +462,14 @@ int build_channel_array(const char *device_dir, int buffer_idx,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_cleanup_array;
 			}
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_cleanup_array;
 			}
 
-			free(filename);
 			/* Find the scale */
 			ret = iioutils_get_param_float(&current->scale,
 						       "scale",
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0c1b6acad141..730b49e255e4 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -668,6 +668,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (strncmp(key_name, STATIC_CALL_TRAMP_PREFIX_STR,
 			    STATIC_CALL_TRAMP_PREFIX_LEN)) {
 			WARN("static_call: trampoline name malformed: %s", key_name);
+			free(key_name);
 			return -1;
 		}
 		tmp = key_name + STATIC_CALL_TRAMP_PREFIX_LEN - STATIC_CALL_KEY_PREFIX_LEN;
@@ -677,6 +678,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (!key_sym) {
 			if (!opts.module) {
 				WARN("static_call: can't find static_call_key symbol: %s", tmp);
+				free(key_name);
 				return -1;
 			}
 
diff --git a/tools/testing/selftests/netfilter/rpath.sh b/tools/testing/selftests/netfilter/rpath.sh
index f7311e66d219..5289c8447a41 100755
--- a/tools/testing/selftests/netfilter/rpath.sh
+++ b/tools/testing/selftests/netfilter/rpath.sh
@@ -62,10 +62,16 @@ ip -net "$ns1" a a fec0:42::2/64 dev v0 nodad
 ip -net "$ns2" a a fec0:42::1/64 dev d0 nodad
 
 # firewall matches to test
-[ -n "$iptables" ] && ip netns exec "$ns2" \
-	"$iptables" -t raw -A PREROUTING -s 192.168.0.0/16 -m rpfilter
-[ -n "$ip6tables" ] && ip netns exec "$ns2" \
-	"$ip6tables" -t raw -A PREROUTING -s fec0::/16 -m rpfilter
+[ -n "$iptables" ] && {
+	common='-t raw -A PREROUTING -s 192.168.0.0/16'
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter
+	ip netns exec "$ns2" "$iptables" $common -m rpfilter --invert
+}
+[ -n "$ip6tables" ] && {
+	common='-t raw -A PREROUTING -s fec0::/16'
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter
+	ip netns exec "$ns2" "$ip6tables" $common -m rpfilter --invert
+}
 [ -n "$nft" ] && ip netns exec "$ns2" $nft -f - <<EOF
 table inet t {
 	chain c {
@@ -89,6 +95,11 @@ ipt_zero_rule() { # (command)
 	[ -n "$1" ] || return 0
 	ip netns exec "$ns2" "$1" -t raw -vS | grep -q -- "-m rpfilter -c 0 0"
 }
+ipt_zero_reverse_rule() { # (command)
+	[ -n "$1" ] || return 0
+	ip netns exec "$ns2" "$1" -t raw -vS | \
+		grep -q -- "-m rpfilter --invert -c 0 0"
+}
 nft_zero_rule() { # (family)
 	[ -n "$nft" ] || return 0
 	ip netns exec "$ns2" "$nft" list chain inet t c | \
@@ -101,8 +112,7 @@ netns_ping() { # (netns, args...)
 	ip netns exec "$netns" ping -q -c 1 -W 1 "$@" >/dev/null
 }
 
-testrun() {
-	# clear counters first
+clear_counters() {
 	[ -n "$iptables" ] && ip netns exec "$ns2" "$iptables" -t raw -Z
 	[ -n "$ip6tables" ] && ip netns exec "$ns2" "$ip6tables" -t raw -Z
 	if [ -n "$nft" ]; then
@@ -111,6 +121,10 @@ testrun() {
 			ip netns exec "$ns2" $nft -s list table inet t;
 		) | ip netns exec "$ns2" $nft -f -
 	fi
+}
+
+testrun() {
+	clear_counters
 
 	# test 1: martian traffic should fail rpfilter matches
 	netns_ping "$ns1" -I v0 192.168.42.1 && \
@@ -120,9 +134,13 @@ testrun() {
 
 	ipt_zero_rule "$iptables" || die "iptables matched martian"
 	ipt_zero_rule "$ip6tables" || die "ip6tables matched martian"
+	ipt_zero_reverse_rule "$iptables" && die "iptables not matched martian"
+	ipt_zero_reverse_rule "$ip6tables" && die "ip6tables not matched martian"
 	nft_zero_rule ip || die "nft IPv4 matched martian"
 	nft_zero_rule ip6 || die "nft IPv6 matched martian"
 
+	clear_counters
+
 	# test 2: rpfilter match should pass for regular traffic
 	netns_ping "$ns1" 192.168.23.1 || \
 		die "regular ping 192.168.23.1 failed"
@@ -131,6 +149,8 @@ testrun() {
 
 	ipt_zero_rule "$iptables" && die "iptables match not effective"
 	ipt_zero_rule "$ip6tables" && die "ip6tables match not effective"
+	ipt_zero_reverse_rule "$iptables" || die "iptables match over-effective"
+	ipt_zero_reverse_rule "$ip6tables" || die "ip6tables match over-effective"
 	nft_zero_rule ip && die "nft IPv4 match not effective"
 	nft_zero_rule ip6 && die "nft IPv6 match not effective"
 
diff --git a/tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json b/tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json
deleted file mode 100644
index 44901db70376..000000000000
--- a/tools/testing/selftests/tc-testing/tc-tests/filters/tcindex.json
+++ /dev/null
@@ -1,227 +0,0 @@
-[
-    {
-        "id": "8293",
-        "name": "Add tcindex filter with default action",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress"
-        ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "^filter parent ffff: protocol ip pref 1 tcindex chain 0 handle 0x0001 classid 1:1",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "7281",
-        "name": "Add tcindex filter with hash size and pass action",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress"
-        ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex hash 32 fall_through classid 1:1 action pass",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "^filter parent ffff: protocol ip pref.*tcindex chain [0-9]+ handle 0x0001 classid 1:1.*action order [0-9]+: gact action pass",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "b294",
-        "name": "Add tcindex filter with mask shift and reclassify action",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress"
-        ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex hash 32 mask 1 shift 2 fall_through classid 1:1 action reclassify",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "^filter parent ffff: protocol ip pref.*tcindex chain [0-9]+ handle 0x0001 classid 1:1.*action order [0-9]+: gact action reclassify",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "0532",
-        "name": "Add tcindex filter with pass_on and continue actions",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress"
-        ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex hash 32 mask 1 shift 2 pass_on classid 1:1 action continue",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "^filter parent ffff: protocol ip pref.*tcindex chain [0-9]+ handle 0x0001 classid 1:1.*action order [0-9]+: gact action continue",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "d473",
-        "name": "Add tcindex filter with pipe action",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress"
-        ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex hash 32 mask 1 shift 2 fall_through classid 1:1 action pipe",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "^filter parent ffff: protocol ip pref.*tcindex chain [0-9]+ handle 0x0001 classid 1:1.*action order [0-9]+: gact action pipe",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "2940",
-        "name": "Add tcindex filter with miltiple actions",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress"
-        ],
-        "cmdUnderTest": "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 7 tcindex hash 32 mask 1 shift 2 fall_through classid 1:1 action skbedit mark 7 pipe action gact drop",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 7 protocol ip tcindex",
-        "matchPattern": "^filter parent ffff: protocol ip pref 7 tcindex.*handle 0x0001.*action.*skbedit.*mark 7 pipe.*action.*gact action drop",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "1893",
-        "name": "List tcindex filters",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1",
-            "$TC filter add dev $DEV1 parent ffff: handle 2 protocol ip prio 1 tcindex classid 1:1"
-        ],
-        "cmdUnderTest": "$TC filter show dev $DEV1 parent ffff:",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter show dev $DEV1 parent ffff:",
-        "matchPattern": "handle 0x000[0-9]+ classid 1:1",
-        "matchCount": "2",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "2041",
-        "name": "Change tcindex filter with pass action",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1 action drop"
-        ],
-        "cmdUnderTest": "$TC filter change dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1 action pass",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "handle 0x0001 classid 1:1.*action order [0-9]+: gact action pass",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "9203",
-        "name": "Replace tcindex filter with pass action",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1 action drop"
-        ],
-        "cmdUnderTest": "$TC filter replace dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1 action pass",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "handle 0x0001 classid 1:1.*action order [0-9]+: gact action pass",
-        "matchCount": "1",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    },
-    {
-        "id": "7957",
-        "name": "Delete tcindex filter with drop action",
-        "category": [
-            "filter",
-            "tcindex"
-        ],
-        "plugins": {
-            "requires": "nsPlugin"
-        },
-        "setup": [
-            "$TC qdisc add dev $DEV1 ingress",
-            "$TC filter add dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1 action drop"
-        ],
-        "cmdUnderTest": "$TC filter del dev $DEV1 parent ffff: handle 1 protocol ip prio 1 tcindex classid 1:1 action drop",
-        "expExitCode": "0",
-        "verifyCmd": "$TC filter get dev $DEV1 parent ffff: handle 1 prio 1 protocol ip tcindex",
-        "matchPattern": "handle 0x0001 classid 1:1.*action order [0-9]+: gact action drop",
-        "matchCount": "0",
-        "teardown": [
-            "$TC qdisc del dev $DEV1 ingress"
-        ]
-    }
-]
