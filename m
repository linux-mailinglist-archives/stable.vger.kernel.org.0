Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2846C6B5CBB
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 15:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjCKOTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 09:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCKORw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 09:17:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FA8131300;
        Sat, 11 Mar 2023 06:17:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACB19B8254F;
        Sat, 11 Mar 2023 14:17:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92327C433EF;
        Sat, 11 Mar 2023 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678544244;
        bh=MBFPHvAhZdMSp8Y36MdZ2r8tfh2Uwin2OE5pHhp1Vmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MnXMwnanS83xHZ6ICVs2hnSdiF8bLUOrzYkCENmg/dFjhcVES84k1YL+gwNYgAICZ
         dp3p8vIJ2g+B9hBofL7+EeDmVh36tzNvLiymb86EMOH6qqoQTRZwij/gv/b0egO8lX
         7k4Y16hp/ldBF+zkGVDYyvA2lC+EgA14/eiuXekI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.100
Date:   Sat, 11 Mar 2023 15:17:10 +0100
Message-Id: <1678544230157192@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167854423054246@kroah.com>
References: <167854423054246@kroah.com>
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
index 889ed45be4ca..2d5a5913b5f2 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -51,7 +51,7 @@ Date:		Dec 2014
 KernelVersion:	4.0
 Description:	Default output terminal descriptors
 
-		All attributes read only:
+		All attributes read only except bSourceID:
 
 		==============	=============================================
 		iTerminal	index of string descriptor
diff --git a/Makefile b/Makefile
index 08e73aba22ea..ef2defa6bce2 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 99
+SUBLEVEL = 100
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index f6d2946edbd2..15f2effd6baf 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -60,7 +60,7 @@ int irq_select_affinity(unsigned int irq)
 		cpu = (cpu < (NR_CPUS-1) ? cpu + 1 : 0);
 	last_cpu = cpu;
 
-	cpumask_copy(irq_data_get_affinity_mask(data), cpumask_of(cpu));
+	irq_data_update_affinity(data, cpumask_of(cpu));
 	chip->irq_set_affinity(data, cpumask_of(cpu), false);
 	return 0;
 }
diff --git a/arch/arm/boot/dts/spear320-hmi.dts b/arch/arm/boot/dts/spear320-hmi.dts
index 367ba48aac3e..5c562fb4886f 100644
--- a/arch/arm/boot/dts/spear320-hmi.dts
+++ b/arch/arm/boot/dts/spear320-hmi.dts
@@ -242,7 +242,7 @@ stmpe811@41 {
 					irq-trigger = <0x1>;
 
 					stmpegpio: stmpe-gpio {
-						compatible = "stmpe,gpio";
+						compatible = "st,stmpe-gpio";
 						reg = <0>;
 						gpio-controller;
 						#gpio-cells = <2>;
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 35adcf89035a..99300850abc1 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -834,7 +834,7 @@ iosapic_unregister_intr (unsigned int gsi)
 	if (iosapic_intr_info[irq].count == 0) {
 #ifdef CONFIG_SMP
 		/* Clear affinity */
-		cpumask_setall(irq_get_affinity_mask(irq));
+		irq_data_update_affinity(irq_get_irq_data(irq), cpu_all_mask);
 #endif
 		/* Clear the interrupt information */
 		iosapic_intr_info[irq].dest = 0;
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index ecef17c7c35b..275b9ea58c64 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -57,8 +57,8 @@ static char irq_redir [NR_IRQS]; // = { [0 ... NR_IRQS-1] = 1 };
 void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 {
 	if (irq < NR_IRQS) {
-		cpumask_copy(irq_get_affinity_mask(irq),
-			     cpumask_of(cpu_logical_id(hwid)));
+		irq_data_update_affinity(irq_get_irq_data(irq),
+					 cpumask_of(cpu_logical_id(hwid)));
 		irq_redir[irq] = (char) (redir & 0xff);
 	}
 }
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index df5c28f252e3..025e5133c860 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -37,7 +37,7 @@ static int ia64_set_msi_irq_affinity(struct irq_data *idata,
 	msg.data = data;
 
 	pci_write_msi_msg(irq, &msg);
-	cpumask_copy(irq_data_get_affinity_mask(idata), cpumask_of(cpu));
+	irq_data_update_affinity(idata, cpumask_of(cpu));
 
 	return 0;
 }
@@ -132,7 +132,7 @@ static int dmar_msi_set_affinity(struct irq_data *data,
 	msg.address_lo |= MSI_ADDR_DEST_ID_CPU(cpu_physical_id(cpu));
 
 	dmar_msi_write(irq, &msg);
-	cpumask_copy(irq_data_get_affinity_mask(data), mask);
+	irq_data_update_affinity(data, mask);
 
 	return 0;
 }
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 0d46b19dc4d3..e6cc38ef6945 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -333,7 +333,7 @@ unsigned long txn_affinity_addr(unsigned int irq, int cpu)
 {
 #ifdef CONFIG_SMP
 	struct irq_data *d = irq_get_irq_data(irq);
-	cpumask_copy(irq_data_get_affinity_mask(d), cpumask_of(cpu));
+	irq_data_update_affinity(d, cpumask_of(cpu));
 #endif
 
 	return per_cpu(cpu_data, cpu).txn_addr;
diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index cde6db184c26..45a4bcd27a39 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -770,6 +770,7 @@ static int vector_config(char *str, char **error_out)
 
 	if (parsed == NULL) {
 		*error_out = "vector_config failed to parse parameters";
+		kfree(params);
 		return -EINVAL;
 	}
 
diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index 0ab58016db22..d762d726b66c 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -131,8 +131,11 @@ static int um_pci_send_cmd(struct um_pci_device *dev,
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
@@ -615,22 +618,33 @@ static void um_pci_virtio_remove(struct virtio_device *vdev)
 	struct um_pci_device *dev = vdev->priv;
 	int i;
 
-        /* Stop all virtqueues */
-        vdev->config->reset(vdev);
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
index 82ff3785bf69..204e9dfbff1a 100644
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
 
@@ -1132,6 +1133,15 @@ void virtio_uml_set_no_vq_suspend(struct virtio_device *vdev,
 
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
@@ -1262,8 +1272,14 @@ static int vu_unregister_cmdline_device(struct device *dev, void *data)
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
index d60ed0668a59..b9ccdf5ea98b 100644
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
@@ -81,17 +81,17 @@ static void __resctrl_sched_in(void)
 	}
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
index 4f5d79e658cd..88545a1f5207 100644
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
index 4f2f54e1281c..d4a130337e93 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -216,7 +216,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	switch_fpu_finish(next_fpu);
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ec0d836a13b1..b8fe38cd121d 100644
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
diff --git a/drivers/base/component.c b/drivers/base/component.c
index 870485cbbb87..058f1a2cb2a9 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -130,7 +130,7 @@ static void component_master_debugfs_add(struct master *m)
 
 static void component_master_debugfs_del(struct master *m)
 {
-	debugfs_remove(debugfs_lookup(dev_name(m->parent), component_debugfs_dir));
+	debugfs_lookup_and_remove(dev_name(m->parent), component_debugfs_dir);
 }
 
 #else
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 060348125635..9cbf086fe552 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -352,7 +352,7 @@ late_initcall(deferred_probe_initcall);
 
 static void __exit deferred_probe_exit(void)
 {
-	debugfs_remove_recursive(debugfs_lookup("devices_deferred", NULL));
+	debugfs_lookup_and_remove("devices_deferred", NULL);
 }
 __exitcall(deferred_probe_exit);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 68a0c0fe64dd..58a38e61de53 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1152,13 +1152,13 @@ loop_set_status_from_info(struct loop_device *lo,
 	if (err)
 		return err;
 
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
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
diff --git a/drivers/firmware/efi/sysfb_efi.c b/drivers/firmware/efi/sysfb_efi.c
index 4c7c9dd7733f..6aa2bb5bbd5e 100644
--- a/drivers/firmware/efi/sysfb_efi.c
+++ b/drivers/firmware/efi/sysfb_efi.c
@@ -266,6 +266,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
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
 
diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index 8c2ab3d653b7..f67c816050f2 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -348,7 +348,7 @@ static bool malidp_check_pages_threshold(struct malidp_plane_state *ms,
 		else
 			sgt = obj->funcs->get_sg_table(obj);
 
-		if (!sgt)
+		if (IS_ERR(sgt))
 			return false;
 
 		sgl = sgt->sgl;
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 0d915fe8b6e4..d02e323a4ecd 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3781,6 +3781,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		set_bit(0, &mgr->payload_mask);
 		mgr->vcpi_mask = 0;
 		mgr->payload_id_table_cleared = false;
+
+		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
+		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
 	}
 
 out_unlock:
@@ -3994,7 +3997,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_sideband_msg_rx *msg = &mgr->down_rep_recv;
 
 	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb))
-		goto out;
+		goto out_clear_reply;
 
 	/* Multi-packet message transmission, don't clear the reply */
 	if (!msg->have_eomt)
diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 7e75fb0fc7bd..25d399b00404 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -169,8 +169,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base);
+		ret = PTR_ERR(shmem->pages);
 		shmem->pages = NULL;
-		return PTR_ERR(shmem->pages);
+		return ret;
 	}
 
 	if (use_dma_api) {
diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index fbf2e2c45678..9023c07bb57b 100644
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
 EXPORT_SYMBOL(mma9551_read_config_word);
 
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
 EXPORT_SYMBOL(mma9551_read_status_word);
 
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index b0d587254fe6..689921dc3d4a 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1055,7 +1055,7 @@ static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
 static void handle_temp_err(struct hfi1_devdata *dd);
 static void dc_shutdown(struct hfi1_devdata *dd);
 static void dc_start(struct hfi1_devdata *dd);
-static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+static int qos_rmt_entries(unsigned int n_krcv_queues, unsigned int *mp,
 			   unsigned int *np);
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd);
 static int wait_link_transfer_active(struct hfi1_devdata *dd, int wait_ms);
@@ -13361,7 +13361,6 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	int ret;
 	unsigned ngroups;
 	int rmt_count;
-	int user_rmt_reduced;
 	u32 n_usr_ctxts;
 	u32 send_contexts = chip_send_contexts(dd);
 	u32 rcv_contexts = chip_rcv_contexts(dd);
@@ -13420,28 +13419,34 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
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
@@ -14298,15 +14303,15 @@ static void clear_rsm_rule(struct hfi1_devdata *dd, u8 rule_index)
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
@@ -14364,7 +14369,7 @@ static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 
 	if (!rmt)
 		goto bail;
-	rmt_entries = qos_rmt_entries(dd, &m, &n);
+	rmt_entries = qos_rmt_entries(dd->n_krcv_queues - 1, &m, &n);
 	if (rmt_entries == 0)
 		goto bail;
 	qpns_per_vl = 1 << m;
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 7154fb551ddc..5ceaaabb4f9d 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1586,27 +1586,29 @@ static int pdev_iommuv2_enable(struct pci_dev *pdev)
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
diff --git a/drivers/irqchip/irq-bcm6345-l1.c b/drivers/irqchip/irq-bcm6345-l1.c
index 1bd0621c4ce2..ebc3a253f735 100644
--- a/drivers/irqchip/irq-bcm6345-l1.c
+++ b/drivers/irqchip/irq-bcm6345-l1.c
@@ -220,11 +220,11 @@ static int bcm6345_l1_set_affinity(struct irq_data *d,
 		enabled = intc->cpus[old_cpu]->enable_cache[word] & mask;
 		if (enabled)
 			__bcm6345_l1_mask(d);
-		cpumask_copy(irq_data_get_affinity_mask(d), dest);
+		irq_data_update_affinity(d, dest);
 		if (enabled)
 			__bcm6345_l1_unmask(d);
 	} else {
-		cpumask_copy(irq_data_get_affinity_mask(d), dest);
+		irq_data_update_affinity(d, dest);
 	}
 	raw_spin_unlock_irqrestore(&intc->lock, flags);
 
diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 4b3a44264b2c..05335866e6d6 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -1459,6 +1460,10 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 
 	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
 
+	/* The barrier is needed to synchronize with uvc_status_stop(). */
+	if (smp_load_acquire(&dev->flush_status))
+		return;
+
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
 	ret = usb_submit_urb(w->urb, GFP_KERNEL);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index ceae2eabc0a1..2e7df1de0af9 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -531,14 +531,10 @@ static int uvc_parse_format(struct uvc_device *dev,
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
 
@@ -549,8 +545,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 		 */
 		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
 			if (format->fcc == V4L2_PIX_FMT_YUYV) {
-				strscpy(format->name, "Greyscale 8-bit (Y8  )",
-					sizeof(format->name));
 				format->fcc = V4L2_PIX_FMT_GREY;
 				format->bpp = 8;
 				width_multiplier = 2;
@@ -591,7 +585,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strscpy(format->name, "MJPEG", sizeof(format->name));
 		format->fcc = V4L2_PIX_FMT_MJPEG;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		format->bpp = 0;
@@ -607,17 +600,7 @@ static int uvc_parse_format(struct uvc_device *dev,
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
@@ -625,9 +608,6 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcat(format->name, buffer[8] & (1 << 7) ? " 60Hz" : " 50Hz",
-			sizeof(format->name));
-
 		format->fcc = V4L2_PIX_FMT_DV;
 		format->flags = UVC_FMT_FLAG_COMPRESSED | UVC_FMT_FLAG_STREAM;
 		format->bpp = 0;
@@ -654,7 +634,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		return -EINVAL;
 	}
 
-	uvc_dbg(dev, DESCR, "Found format %s\n", format->name);
+	uvc_dbg(dev, DESCR, "Found format %p4cc", &format->fcc);
 
 	buflen -= buffer[0];
 	buffer += buffer[0];
@@ -1151,10 +1131,8 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
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
@@ -1278,15 +1256,15 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
@@ -1318,10 +1296,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(term->baSourceID, &buffer[7], 1);
 
-		if (buffer[8] != 0)
-			usb_string(udev, buffer[8], term->name,
-				   sizeof(term->name));
-		else
+		if (buffer[8] == 0 ||
+		    usb_string(udev, buffer[8], term->name, sizeof(term->name)) < 0)
 			sprintf(term->name, "Output %u", buffer[3]);
 
 		list_add_tail(&term->list, &dev->entities);
@@ -1343,10 +1319,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
-		if (buffer[5+p] != 0)
-			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[5+p] == 0 ||
+		    usb_string(udev, buffer[5+p], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1376,10 +1350,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
@@ -1407,10 +1379,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
@@ -2714,6 +2684,24 @@ static const struct usb_device_id uvc_ids[] = {
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
index 753c8226db70..3fa658b86c82 100644
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
index 023412b2a9b9..ab535e550158 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -657,8 +657,6 @@ static int uvc_ioctl_enum_fmt(struct uvc_streaming *stream,
 	fmt->flags = 0;
 	if (format->flags & UVC_FMT_FLAG_COMPRESSED)
 		fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-	strscpy(fmt->description, format->name, sizeof(fmt->description));
-	fmt->description[sizeof(fmt->description) - 1] = 0;
 	fmt->pixelformat = format->fcc;
 	return 0;
 }
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 1b4cc934109e..f477cfbbb905 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1334,7 +1334,9 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
 	if (has_scr)
 		memcpy(stream->clock.last_scr, scr, 6);
 
-	memcpy(&meta->length, mem, length);
+	meta->length = mem[0];
+	meta->flags  = mem[1];
+	memcpy(meta->buf, &mem[2], length - 2);
 	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
 
 	uvc_dbg(stream->dev, FRAME,
@@ -1951,6 +1953,17 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
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
index d7c4f6f5fca9..1aa2cc98502d 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -209,6 +209,7 @@
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
 #define UVC_QUIRK_FORCE_BPP		0x00001000
+#define UVC_QUIRK_WAKE_AUTOSUSPEND	0x00002000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -405,8 +406,6 @@ struct uvc_format {
 	u32 fcc;
 	u32 flags;
 
-	char name[32];
-
 	unsigned int nframes;
 	struct uvc_frame *frame;
 };
@@ -698,6 +697,7 @@ struct uvc_device {
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
+	bool flush_status;
 	u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 9323b1e3a69e..5c8317bd4d98 100644
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
index 67844089db21..9d082287dbe0 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -175,7 +175,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 	ret = __mei_cl_send(cldev->cl, (u8 *)&req, sizeof(req), 0,
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd\n");
+		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -187,7 +187,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 		 * Should be at least one version block,
 		 * error out if nothing found
 		 */
-		dev_err(&cldev->dev, "Could not read FW version\n");
+		dev_err(&cldev->dev, "Could not read FW version ret = %d\n", bytes_recv);
 		return -EIO;
 	}
 
@@ -337,7 +337,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	ret = __mei_cl_send(cl, (u8 *)&cmd, sizeof(cmd), 0,
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(bus->dev, "Could not send IF version cmd\n");
+		dev_err(bus->dev, "Could not send IF version cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -352,7 +352,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length, &vtag,
 				   0, 0);
 	if (bytes_recv < 0 || (size_t)bytes_recv < if_version_length) {
-		dev_err(bus->dev, "Could not read IF version\n");
+		dev_err(bus->dev, "Could not read IF version ret = %d\n", bytes_recv);
 		ret = -EIO;
 		goto err;
 	}
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index f1d8ba6d4857..dab8ad9fed6b 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1711,7 +1711,7 @@ static void __init vmballoon_debugfs_init(struct vmballoon *b)
 static void __exit vmballoon_debugfs_exit(struct vmballoon *b)
 {
 	static_key_disable(&balloon_stat_enabled.key);
-	debugfs_remove(debugfs_lookup("vmmemctl", NULL));
+	debugfs_lookup_and_remove("vmmemctl", NULL);
 	kfree(b->stats);
 	b->stats = NULL;
 }
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index a32050fecabf..3499ff2649d5 100644
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
index 053ab52668e8..69592be33adf 100644
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
index 6ea95ade4ca6..d79323e8ea29 100644
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
index afcdacb9d0e9..2ee0e60c43c2 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -886,8 +886,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
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
 
@@ -969,11 +972,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
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
@@ -1120,14 +1123,18 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
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
@@ -1243,6 +1250,18 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
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
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 77a13fb555fb..63889449b8f6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -748,7 +748,7 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 
 		/* NPC profile doesn't extract AH/ESP header fields */
 		if ((ah_esp_mask->spi & ah_esp_hdr->spi) ||
-		    (ah_esp_mask->tclass & ah_esp_mask->tclass))
+		    (ah_esp_mask->tclass & ah_esp_hdr->tclass))
 			return -EOPNOTSUPP;
 
 		if (flow_type == AH_V6_FLOW)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3194cdcd2f63..002567792e91 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -962,7 +962,8 @@ mlx5_eswitch_add_send_to_vport_rule(struct mlx5_eswitch *on_esw,
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
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 04a2cea6d6b6..57d09dbf627b 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -674,6 +674,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
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
index d41636504246..6a1d3b2752fb 100644
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
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index fd99735dca3e..93ea922618c3 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -677,7 +677,7 @@ static int iosapic_set_affinity_irq(struct irq_data *d,
 	if (dest_cpu < 0)
 		return -1;
 
-	cpumask_copy(irq_data_get_affinity_mask(d), cpumask_of(dest_cpu));
+	irq_data_update_affinity(d, cpumask_of(dest_cpu));
 	vi->txn_addr = txn_affinity_addr(d->irq, dest_cpu);
 
 	spin_lock_irqsave(&iosapic_lock, flags);
diff --git a/drivers/pci/controller/pci-loongson.c b/drivers/pci/controller/pci-loongson.c
index 48169b1e3817..e73e18a73833 100644
--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -13,9 +13,14 @@
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
 #define DEV_LS7A_CONF	0x7a10
@@ -38,11 +43,11 @@ static void bridge_class_quirk(struct pci_dev *dev)
 	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
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
@@ -60,37 +65,33 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
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
 
 static void __iomem *cfg1_map(struct loongson_pci *priv, int bus,
 				unsigned int devfn, int where)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 778ae3c861f4..ce0988513fda 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5970,6 +5970,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 {
 	u16 v;
 	int ret;
+	struct pci_host_bridge *bridge = pci_find_host_bridge(dev->bus);
 
 	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
 		return -EINVAL;
@@ -5988,6 +5989,15 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 
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
index 305ff5bd1a20..643a3b292f0b 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4823,6 +4823,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
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
@@ -4968,6 +4988,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
+	/* Wangxun nics */
+	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
 	{ 0 }
 };
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 2ce636937c6e..16d291e10627 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1878,12 +1878,67 @@ static void adjust_bridge_window(struct pci_dev *bridge, struct resource *res,
 		add_size = size - new_size;
 		pci_dbg(bridge, "bridge window %pR shrunken by %pa\n", res,
 			&add_size);
+	} else {
+		return;
 	}
 
 	res->end = res->start + new_size - 1;
 	remove_from_list(add_list, res);
 }
 
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
+}
+
+/*
+ * io, mmio and mmio_pref contain the total amount of bridge window space
+ * available. This includes the minimal space needed to cover all the
+ * existing devices on the bus and the possible extra space that can be
+ * shared with the bridges.
+ */
 static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 					    struct list_head *add_list,
 					    struct resource io,
@@ -1893,7 +1948,7 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 	unsigned int normal_bridges = 0, hotplug_bridges = 0;
 	struct resource *io_res, *mmio_res, *mmio_pref_res;
 	struct pci_dev *dev, *bridge = bus->self;
-	resource_size_t io_per_hp, mmio_per_hp, mmio_pref_per_hp, align;
+	resource_size_t io_per_b, mmio_per_b, mmio_pref_per_b, align;
 
 	io_res = &bridge->resource[PCI_BRIDGE_IO_WINDOW];
 	mmio_res = &bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -1937,94 +1992,88 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
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
 
diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index 5b9a254c4552..062821410ee4 100644
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
diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 07e9fc58354f..41a6fc47cc16 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -41,7 +41,7 @@
 
 struct pwm_sifive_ddata {
 	struct pwm_chip	chip;
-	struct mutex lock; /* lock to protect user_count */
+	struct mutex lock; /* lock to protect user_count and approx_period */
 	struct notifier_block notifier;
 	struct clk *clk;
 	void __iomem *regs;
@@ -76,6 +76,7 @@ static void pwm_sifive_free(struct pwm_chip *chip, struct pwm_device *pwm)
 	mutex_unlock(&ddata->lock);
 }
 
+/* Called holding ddata->lock */
 static void pwm_sifive_update_clock(struct pwm_sifive_ddata *ddata,
 				    unsigned long rate)
 {
@@ -163,7 +164,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		return ret;
 	}
 
-	mutex_lock(&ddata->lock);
 	cur_state = pwm->state;
 	enabled = cur_state.enabled;
 
@@ -182,14 +182,23 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* The hardware cannot generate a 100% duty cycle */
 	frac = min(frac, (1U << PWM_SIFIVE_CMPWIDTH) - 1);
 
+	mutex_lock(&ddata->lock);
 	if (state->period != ddata->approx_period) {
-		if (ddata->user_count != 1) {
+		/*
+		 * Don't let a 2nd user change the period underneath the 1st user.
+		 * However if ddate->approx_period == 0 this is the first time we set
+		 * any period, so let whoever gets here first set the period so other
+		 * users who agree on the period won't fail.
+		 */
+		if (ddata->user_count != 1 && ddata->approx_period) {
+			mutex_unlock(&ddata->lock);
 			ret = -EBUSY;
 			goto exit;
 		}
 		ddata->approx_period = state->period;
 		pwm_sifive_update_clock(ddata, clk_get_rate(ddata->clk));
 	}
+	mutex_unlock(&ddata->lock);
 
 	writel(frac, ddata->regs + PWM_SIFIVE_PWMCMP(pwm->hwpwm));
 
@@ -198,7 +207,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 exit:
 	clk_disable(ddata->clk);
-	mutex_unlock(&ddata->lock);
 	return ret;
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
index 3ee17c4d7298..f49ab45455d7 100644
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
index c551ebf0ac00..536bd023c480 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -128,7 +128,6 @@ struct sun6i_rtc_clk_data {
 	unsigned int fixed_prescaler : 16;
 	unsigned int has_prescaler : 1;
 	unsigned int has_out_clk : 1;
-	unsigned int export_iosc : 1;
 	unsigned int has_losc_en : 1;
 	unsigned int has_auto_swt : 1;
 };
@@ -260,10 +259,8 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
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
@@ -304,13 +301,10 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
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
 
@@ -350,7 +344,6 @@ static const struct sun6i_rtc_clk_data sun8i_h3_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 };
 
 static void __init sun8i_h3_rtc_clk_init(struct device_node *node)
@@ -368,7 +361,6 @@ static const struct sun6i_rtc_clk_data sun50i_h6_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 	.has_losc_en = 1,
 	.has_auto_swt = 1,
 };
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 04fb7fc01226..e5e38431c5c7 100644
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
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 9e674b748e78..90118204e21a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2990,19 +2990,25 @@ static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	struct sysinfo s;
+	u64 coherent_dma_mask, dma_mask;
 
-	if (ioc->is_mcpu_endpoint ||
-	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4) {
 		ioc->dma_mask = 32;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
+	} else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
 		ioc->dma_mask = 63;
-	else
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(63);
+	} else {
 		ioc->dma_mask = 64;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(64);
+	}
+
+	if (ioc->use_32bit_dma)
+		coherent_dma_mask = DMA_BIT_MASK(32);
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)))
+	if (dma_set_mask(&pdev->dev, dma_mask) ||
+	    dma_set_coherent_mask(&pdev->dev, coherent_dma_mask))
 		return -ENODEV;
 
 	if (ioc->dma_mask > 32) {
diff --git a/drivers/sh/intc/chip.c b/drivers/sh/intc/chip.c
index 358df7510186..828d81e02b37 100644
--- a/drivers/sh/intc/chip.c
+++ b/drivers/sh/intc/chip.c
@@ -72,7 +72,7 @@ static int intc_set_affinity(struct irq_data *data,
 	if (!cpumask_intersects(cpumask, cpu_online_mask))
 		return -1;
 
-	cpumask_copy(irq_data_get_affinity_mask(data), cpumask);
+	irq_data_update_affinity(data, cpumask);
 
 	return IRQ_SET_MASK_OK_NOCOPY;
 }
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
index 0339e6df6eb7..7b340f383213 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -556,6 +556,29 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
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
@@ -597,6 +620,10 @@ _cdns_xfer_msg(struct sdw_cdns *cdns, struct sdw_msg *msg, int cmd,
 		dev_err(cdns->dev, "IO transfer timed out, cmd %d device %d addr %x len %d\n",
 			cmd, msg->dev_num, msg->addr, msg->len);
 		msg->len = 0;
+
+		/* Drain anything in the RX_FIFO */
+		cdns_read_response(cdns);
+
 		return SDW_CMD_TIMEOUT;
 	}
 
@@ -765,22 +792,6 @@ EXPORT_SYMBOL(cdns_reset_page_addr);
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
index e587aede63bf..e437a604429f 100644
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
@@ -119,7 +125,12 @@ struct sdw_cdns {
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
diff --git a/drivers/thermal/intel/Kconfig b/drivers/thermal/intel/Kconfig
index c83ea5d04a1d..e0d65e450c89 100644
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
index f4d9dc4648da..8a1d5c5d4c09 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1484,12 +1484,32 @@ static void lpuart_break_ctl(struct uart_port *port, int break_state)
 
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
index 49bc5a4b2832..e783a4225bf0 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1821,7 +1821,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	char name[32];
 
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
-	debugfs_remove(debugfs_lookup(name, NULL));
+	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
 	free_page((unsigned long)priv->rxbuf.buf);
 }
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 0ab788058fa2..b57cf8ddbf63 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1245,25 +1245,6 @@ static int sc16is7xx_probe(struct device *dev,
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
@@ -1329,6 +1310,25 @@ static int sc16is7xx_probe(struct device *dev,
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
@@ -1348,18 +1348,19 @@ static int sc16is7xx_probe(struct device *dev,
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
index 6616d4a0d41d..64dd6439d179 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1244,14 +1244,16 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
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
diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
index 62368c4ed37a..cc36f9f22814 100644
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -1036,7 +1036,7 @@ static void usb_debugfs_init(void)
 
 static void usb_debugfs_cleanup(void)
 {
-	debugfs_remove(debugfs_lookup("devices", usb_debug_root));
+	debugfs_lookup_and_remove("devices", usb_debug_root);
 }
 
 /*
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index e82e4cbe4ec7..725653711411 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -1092,6 +1092,7 @@ struct dwc3_scratchpad_array {
  *		     address.
  * @num_ep_resized: carries the current number endpoints which have had its tx
  *		    fifo resized.
+ * @debug_root: root debugfs directory for this device to put its files in.
  */
 struct dwc3 {
 	struct work_struct	drd_work;
@@ -1303,6 +1304,7 @@ struct dwc3 {
 	int			max_cfg_eps;
 	int			last_fifo_depth;
 	int			num_ep_resized;
+	struct dentry		*debug_root;
 };
 
 #define INCRX_BURST_MODE 0
diff --git a/drivers/usb/dwc3/debug.h b/drivers/usb/dwc3/debug.h
index d223c54115f4..01d0366bf93a 100644
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
index 4812ba4bbedd..a0100d26de8e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3081,9 +3081,7 @@ static void dwc3_gadget_free_endpoints(struct dwc3 *dwc)
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
index 77d64031aa9c..b553dca9246e 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -505,11 +505,68 @@ UVC_ATTR_RO(uvcg_default_output_, cname, aname)
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
index a9f07c59fc37..5c7dff6bc638 100644
--- a/drivers/usb/gadget/udc/bcm63xx_udc.c
+++ b/drivers/usb/gadget/udc/bcm63xx_udc.c
@@ -2259,7 +2259,7 @@ static void bcm63xx_udc_init_debugfs(struct bcm63xx_udc *udc)
  */
 static void bcm63xx_udc_cleanup_debugfs(struct bcm63xx_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(udc->gadget.name, usb_debug_root));
+	debugfs_lookup_and_remove(udc->gadget.name, usb_debug_root);
 }
 
 /***********************************************************************
diff --git a/drivers/usb/gadget/udc/gr_udc.c b/drivers/usb/gadget/udc/gr_udc.c
index 4b35739d3695..d1febde6f2c4 100644
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
index 865de8db998a..ec0d3d74d66e 100644
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
index a09ec1d826b2..e4d2ab5768ba 100644
--- a/drivers/usb/gadget/udc/pxa25x_udc.c
+++ b/drivers/usb/gadget/udc/pxa25x_udc.c
@@ -1341,7 +1341,7 @@ DEFINE_SHOW_ATTRIBUTE(udc_debug);
 		debugfs_create_file(dev->gadget.name, \
 			S_IRUGO, NULL, dev, &udc_debug_fops); \
 	} while (0)
-#define remove_debug_files(dev) debugfs_remove(debugfs_lookup(dev->gadget.name, NULL))
+#define remove_debug_files(dev) debugfs_lookup_and_remove(dev->gadget.name, NULL)
 
 #else	/* !CONFIG_USB_GADGET_DEBUG_FILES */
 
diff --git a/drivers/usb/gadget/udc/pxa27x_udc.c b/drivers/usb/gadget/udc/pxa27x_udc.c
index f4b7a2a3e711..282b114f382f 100644
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
index 4b02ace09f3d..d9a3fd8af7a0 100644
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
index 8c7f0991c21b..9c3e12f2f25d 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1206,7 +1206,7 @@ static void create_debug_file(struct isp116x *isp116x)
 
 static void remove_debug_file(struct isp116x *isp116x)
 {
-	debugfs_remove(debugfs_lookup(hcd_name, usb_debug_root));
+	debugfs_lookup_and_remove(hcd_name, usb_debug_root);
 }
 
 #else
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index d8610ce8f2ec..bc68669dfc50 100644
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
index 85623731a516..825ff6727310 100644
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
index d90b869f5f40..d138f62ce84d 100644
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
index 8ca1a235d164..eabccf25796b 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -33,7 +33,7 @@ static void xhci_mvebu_mbus_config(void __iomem *base,
 
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
index 3a3d8b5c7ad5..5eec84fa6517 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1044,8 +1044,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			put_device(&wd_data->dev);
 		}
+		put_device(&wd_data->dev);
 		return err;
 	}
 
diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
index 46d9295d9a6e..5e8321f43cbd 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -528,9 +528,10 @@ static void bind_evtchn_to_cpu(evtchn_port_t evtchn, unsigned int cpu,
 	BUG_ON(irq == -1);
 
 	if (IS_ENABLED(CONFIG_SMP) && force_affinity) {
-		cpumask_copy(irq_get_affinity_mask(irq), cpumask_of(cpu));
-		cpumask_copy(irq_get_effective_affinity_mask(irq),
-			     cpumask_of(cpu));
+		struct irq_data *data = irq_get_irq_data(irq);
+
+		irq_data_update_affinity(data, cpumask_of(cpu));
+		irq_data_update_effective_affinity(data, cpumask_of(cpu));
 	}
 
 	xen_evtchn_port_bind_to_cpu(evtchn, cpu, info->cpu);
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index a8d0a8081a1d..2660c34c770e 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1282,8 +1282,14 @@ struct dentry_info_args {
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
 
@@ -1295,16 +1301,18 @@ static inline void tl_to_darg(struct dentry_info_args *darg,
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
@@ -1401,8 +1409,8 @@ static int ext4_fc_replay_link_internal(struct super_block *sb,
 }
 
 /* Link replay function */
-static int ext4_fc_replay_link(struct super_block *sb, struct ext4_fc_tl *tl,
-			       u8 *val)
+static int ext4_fc_replay_link(struct super_block *sb,
+			       struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct dentry_info_args darg;
@@ -1456,8 +1464,8 @@ static int ext4_fc_record_modified_inode(struct super_block *sb, int ino)
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
@@ -1557,8 +1565,8 @@ static int ext4_fc_replay_inode(struct super_block *sb, struct ext4_fc_tl *tl,
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
@@ -1657,7 +1665,7 @@ int ext4_fc_record_regions(struct super_block *sb, int ino,
 
 /* Replay add range tag */
 static int ext4_fc_replay_add_range(struct super_block *sb,
-				    struct ext4_fc_tl *tl, u8 *val)
+				    struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct ext4_fc_add_range fc_add_ex;
 	struct ext4_extent newex, *ex;
@@ -1778,8 +1786,8 @@ static int ext4_fc_replay_add_range(struct super_block *sb,
 
 /* Replay DEL_RANGE tag */
 static int
-ext4_fc_replay_del_range(struct super_block *sb, struct ext4_fc_tl *tl,
-			 u8 *val)
+ext4_fc_replay_del_range(struct super_block *sb,
+			 struct ext4_fc_tl_mem *tl, u8 *val)
 {
 	struct inode *inode;
 	struct ext4_fc_del_range lrange;
@@ -1972,7 +1980,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	struct ext4_fc_replay_state *state;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_add_range ext;
-	struct ext4_fc_tl tl;
+	struct ext4_fc_tl_mem tl;
 	struct ext4_fc_tail tail;
 	__u8 *start, *end, *cur, *val;
 	struct ext4_fc_head head;
@@ -2091,7 +2099,7 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 {
 	struct super_block *sb = journal->j_private;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct ext4_fc_tl tl;
+	struct ext4_fc_tl_mem tl;
 	__u8 *start, *end, *cur, *val;
 	int ret = JBD2_FC_REPLAY_CONTINUE;
 	struct ext4_fc_replay_state *state = &sbi->s_fc_replay_state;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 758048a885d2..326c1a4c2a6a 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3928,7 +3928,7 @@ static int f2fs_ioc_set_compress_option(struct file *filp, unsigned long arg)
 		goto out;
 	}
 
-	if (inode->i_size != 0) {
+	if (F2FS_HAS_BLOCKS(inode)) {
 		ret = -EFBIG;
 		goto out;
 	}
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 480d5f76491d..bce1c2ae6d15 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -64,7 +64,6 @@ bool f2fs_may_inline_dentry(struct inode *inode)
 void f2fs_do_read_inline_data(struct page *page, struct page *ipage)
 {
 	struct inode *inode = page->mapping->host;
-	void *src_addr, *dst_addr;
 
 	if (PageUptodate(page))
 		return;
@@ -74,11 +73,8 @@ void f2fs_do_read_inline_data(struct page *page, struct page *ipage)
 	zero_user_segment(page, MAX_INLINE_DATA(inode), PAGE_SIZE);
 
 	/* Copy the whole inline data block */
-	src_addr = inline_data_addr(inode, ipage);
-	dst_addr = kmap_atomic(page);
-	memcpy(dst_addr, src_addr, MAX_INLINE_DATA(inode));
-	flush_dcache_page(page);
-	kunmap_atomic(dst_addr);
+	memcpy_to_page(page, 0, inline_data_addr(inode, ipage),
+		       MAX_INLINE_DATA(inode));
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
 }
@@ -246,7 +242,6 @@ int f2fs_convert_inline_inode(struct inode *inode)
 
 int f2fs_write_inline_data(struct inode *inode, struct page *page)
 {
-	void *src_addr, *dst_addr;
 	struct dnode_of_data dn;
 	int err;
 
@@ -263,10 +258,8 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	f2fs_bug_on(F2FS_I_SB(inode), page->index);
 
 	f2fs_wait_on_page_writeback(dn.inode_page, NODE, true, true);
-	src_addr = kmap_atomic(page);
-	dst_addr = inline_data_addr(inode, dn.inode_page);
-	memcpy(dst_addr, src_addr, MAX_INLINE_DATA(inode));
-	kunmap_atomic(src_addr);
+	memcpy_from_page(inline_data_addr(inode, dn.inode_page),
+			 page, 0, MAX_INLINE_DATA(inode));
 	set_page_dirty(dn.inode_page);
 
 	f2fs_clear_page_cache_dirty_tag(page);
diff --git a/fs/f2fs/iostat.c b/fs/f2fs/iostat.c
index cdcf54ae0db8..9e0160a02bf4 100644
--- a/fs/f2fs/iostat.c
+++ b/fs/f2fs/iostat.c
@@ -194,8 +194,12 @@ static inline void __update_iostat_latency(struct bio_iostat_ctx *iostat_ctx,
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
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f4e8de1f4789..ae72211e422e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2442,7 +2442,6 @@ static ssize_t f2fs_quota_read(struct super_block *sb, int type, char *data,
 	size_t toread;
 	loff_t i_size = i_size_read(inode);
 	struct page *page;
-	char *kaddr;
 
 	if (off > i_size)
 		return 0;
@@ -2476,9 +2475,7 @@ static ssize_t f2fs_quota_read(struct super_block *sb, int type, char *data,
 			return -EIO;
 		}
 
-		kaddr = kmap_atomic(page);
-		memcpy(data, kaddr + offset, tocopy);
-		kunmap_atomic(kaddr);
+		memcpy_from_page(data, page, offset, tocopy);
 		f2fs_put_page(page, 1);
 
 		offset = 0;
@@ -2500,7 +2497,6 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 	size_t towrite = len;
 	struct page *page;
 	void *fsdata = NULL;
-	char *kaddr;
 	int err = 0;
 	int tocopy;
 
@@ -2520,10 +2516,7 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 			break;
 		}
 
-		kaddr = kmap_atomic(page);
-		memcpy(kaddr + offset, data, tocopy);
-		kunmap_atomic(kaddr);
-		flush_dcache_page(page);
+		memcpy_to_page(page, offset, data, tocopy);
 
 		a_ops->write_end(NULL, mapping, off, tocopy, tocopy,
 						page, fsdata);
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index a28968bb56e6..d5a50e73ec32 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -47,16 +47,13 @@ static int pagecache_read(struct inode *inode, void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *addr;
 
 		page = read_mapping_page(inode->i_mapping, pos >> PAGE_SHIFT,
 					 NULL);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
-		addr = kmap_atomic(page);
-		memcpy(buf, addr + offset_in_page(pos), n);
-		kunmap_atomic(addr);
+		memcpy_from_page(buf, page, offset_in_page(pos), n);
 
 		put_page(page);
 
@@ -81,8 +78,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
-		void *addr;
+		void *fsdata = NULL;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
@@ -90,9 +86,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		if (res)
 			return res;
 
-		addr = kmap_atomic(page);
-		memcpy(addr + offset_in_page(pos), buf, n);
-		kunmap_atomic(addr);
+		memcpy_to_page(page, offset_in_page(pos), buf, n);
 
 		res = pagecache_write_end(NULL, inode->i_mapping, pos, n, n,
 					  page, fsdata);
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index f401bc05d5ff..0034b0f39715 100644
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
index c0b84e960b20..9cb05ef9b9dd 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -212,11 +212,10 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
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
@@ -403,7 +402,7 @@ static int calc_dd_growth(const struct ubifs_info *c,
 	dd_growth = req->dirtied_page ? c->bi.page_budget : 0;
 
 	if (req->dirtied_ino)
-		dd_growth += c->bi.inode_budget << (req->dirtied_ino - 1);
+		dd_growth += c->bi.inode_budget * req->dirtied_ino;
 	if (req->mod_dent)
 		dd_growth += c->bi.dent_budget;
 	dd_growth += req->dirtied_ino_d;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 79e371bc15e1..e7c36e3a9b9e 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1147,7 +1147,6 @@ static int ubifs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	int err, sz_change, len = strlen(symname);
 	struct fscrypt_str disk_link;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = ALIGN(len, 8),
 					.dirtied_ino = 1 };
 	struct fscrypt_name nm;
 
@@ -1163,6 +1162,7 @@ static int ubifs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
 	 * Budget request settings: new inode, new direntry and changing parent
 	 * directory inode.
 	 */
+	req.new_ino_d = ALIGN(disk_link.len - 1, 8);
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
@@ -1320,6 +1320,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlink) {
 		ubifs_assert(c, inode_is_locked(new_inode));
 
+		/* Budget for old inode's data when its nlink > 1. */
+		req.dirtied_ino_d = ALIGN(ubifs_inode(new_inode)->data_len, 8);
 		err = ubifs_purge_xattrs(new_inode);
 		if (err)
 			return err;
@@ -1572,6 +1574,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1597,6 +1603,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 6b45a037a047..7cc2abcb70ae 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1031,7 +1031,7 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
 		if (page->index >= synced_i_size >> PAGE_SHIFT) {
 			err = inode->i_sb->s_op->write_inode(inode, NULL);
 			if (err)
-				goto out_unlock;
+				goto out_redirty;
 			/*
 			 * The inode has been written, but the write-buffer has
 			 * not been synchronized, so in case of an unclean
@@ -1059,11 +1059,17 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
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
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index eb05038b7191..32c1f428054b 100644
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
index c38066ce9ab0..efbb4554a4a6 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1594,8 +1594,13 @@ static inline int ubifs_check_hmac(const struct ubifs_info *c,
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
diff --git a/include/linux/bootconfig.h b/include/linux/bootconfig.h
index 537e1b991f11..5296fbb8408c 100644
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -49,7 +49,7 @@ struct xbc_node {
 /* Maximum size of boot config is 32KB - 1 */
 #define XBC_DATA_MAX	(XBC_VALUE - 1)
 
-#define XBC_NODE_MAX	1024
+#define XBC_NODE_MAX	8192
 #define XBC_KEYLEN_MAX	256
 #define XBC_DEPTH_MAX	16
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index c8293c817646..f9e6449fbbba 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -875,16 +875,22 @@ static inline int irq_data_get_node(struct irq_data *d)
 	return irq_common_data_get_node(d->common);
 }
 
-static inline struct cpumask *irq_get_affinity_mask(int irq)
+static inline struct cpumask *irq_data_get_affinity_mask(struct irq_data *d)
 {
-	struct irq_data *d = irq_get_irq_data(irq);
+	return d->common->affinity;
+}
 
-	return d ? d->common->affinity : NULL;
+static inline void irq_data_update_affinity(struct irq_data *d,
+					    const struct cpumask *m)
+{
+	cpumask_copy(d->common->affinity, m);
 }
 
-static inline struct cpumask *irq_data_get_affinity_mask(struct irq_data *d)
+static inline struct cpumask *irq_get_affinity_mask(int irq)
 {
-	return d->common->affinity;
+	struct irq_data *d = irq_get_irq_data(irq);
+
+	return d ? irq_data_get_affinity_mask(d) : NULL;
 }
 
 #ifdef CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK
@@ -906,7 +912,7 @@ static inline void irq_data_update_effective_affinity(struct irq_data *d,
 static inline
 struct cpumask *irq_data_get_effective_affinity_mask(struct irq_data *d)
 {
-	return d->common->affinity;
+	return irq_data_get_affinity_mask(d);
 }
 #endif
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 9d6e75222868..34dd24c99180 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -557,6 +557,7 @@ struct pci_host_bridge {
 	void		*release_data;
 	unsigned int	ignore_reset_delay:1;	/* For entire hierarchy */
 	unsigned int	no_ext_tags:1;		/* No Extended Tags */
+	unsigned int	no_inc_mrrs:1;		/* No Increase MRRS */
 	unsigned int	native_aer:1;		/* OS may use PCIe AER */
 	unsigned int	native_pcie_hotplug:1;	/* OS may use PCIe hotplug */
 	unsigned int	native_shpc_hotplug:1;	/* OS may use SHPC hotplug */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 04f44a4694a2..4853538bf156 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3012,6 +3012,8 @@
 #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
+#define PCI_VENDOR_ID_WANGXUN		0x8088
+
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
 
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 8d2c3dd9f595..790252c1478b 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1420,6 +1420,7 @@ struct sctp_stream_priorities {
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
diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index 60dc825ecc2b..d81ec8476581 100644
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
diff --git a/kernel/printk/index.c b/kernel/printk/index.c
index d3709408debe..d23b8f8a51db 100644
--- a/kernel/printk/index.c
+++ b/kernel/printk/index.c
@@ -146,7 +146,7 @@ static void pi_create_file(struct module *mod)
 #ifdef CONFIG_MODULES
 static void pi_remove_file(struct module *mod)
 {
-	debugfs_remove(debugfs_lookup(pi_get_module_name(mod), dfs_index));
+	debugfs_lookup_and_remove(pi_get_module_name(mod), dfs_index);
 }
 
 static int pi_module_notify(struct notifier_block *nb, unsigned long op,
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 459055696355..58b8e8b1fea2 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -5546,11 +5546,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
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
index f6d145873b49..e5bfe8d7ef44 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -388,6 +388,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int ret;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -405,7 +406,12 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
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
@@ -502,7 +508,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto dma_unmap;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -512,11 +518,14 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	req->status = REQ_STATUS_SENT;
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
 	req->status = REQ_STATUS_ERROR;
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index 4255f2a3bea4..9e4da8c1b907 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -393,19 +393,24 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
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
@@ -420,11 +425,6 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
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
@@ -483,23 +483,35 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
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
@@ -518,6 +530,8 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
+		if (!xen_9pfs_front_init(dev))
+			xenbus_switch_state(dev, XenbusStateInitialised);
 		break;
 
 	case XenbusStateConnected:
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index f1128c2134f0..3f92a21cabe8 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -888,10 +888,6 @@ static int hci_sock_release(struct socket *sock)
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -2012,6 +2008,12 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
 	return err;
 }
 
+static void hci_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_write_queue);
+}
+
 static const struct proto_ops hci_sock_ops = {
 	.family		= PF_BLUETOOTH,
 	.owner		= THIS_MODULE,
@@ -2065,6 +2067,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 16774559c52c..a09b2fc11c80 100644
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
index 24a80e960d2d..7fc8ae7f3cd5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3113,8 +3113,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
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
index c53f14b94356..71bf3aeed73c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1524,6 +1524,10 @@ int arpt_register_table(struct net *net,
 
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
index 13acb687c19a..a748a1e75460 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1044,7 +1044,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_counters *counters;
 	struct ipt_entry *iter;
 
-	ret = 0;
 	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
@@ -1090,7 +1089,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	return ret;
+	return 0;
 
  put_module:
 	module_put(t->me);
@@ -1741,6 +1740,10 @@ int ipt_register_table(struct net *net, const struct xt_table *table,
 
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
index 41368e77fbb8..aa67d5adcbca 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -565,6 +565,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process context.
+ *       Otherwise, this is from BH context.
  */
 
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -717,7 +720,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 					  &tcp_rsk(req)->last_oow_ack_time))
 			req->rsk_ops->send_ack(sk, skb, req);
 		if (paws_reject)
-			__NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
 	}
 
@@ -736,7 +739,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 *	   "fourth, check the SYN bit"
 	 */
 	if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 		goto embryonic_reset;
 	}
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index a579ea14a69b..277a5ee887eb 100644
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
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 0655fd8c67e9..7b26882b9e70 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5555,16 +5555,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
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
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2cc6092b4f86..18a508783c28 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2396,12 +2396,15 @@ ctnetlink_create_conntrack(struct net *net,
 
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
index a02a25b7eae6..dc276b6802ca 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5342,7 +5342,7 @@ static int nf_tables_getsetelem(struct sk_buff *skb,
 	int rem, err = 0;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_ELEM_LIST_TABLE], family,
-				 genmask, NETLINK_CB(skb).portid);
+				 genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_TABLE]);
 		return PTR_ERR(table);
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index d928d5a24bbc..9ba3676ab37f 100644
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
index 980ad795727e..d010c5b8e83b 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -189,40 +189,67 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
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
@@ -237,33 +264,14 @@ static int tcf_mpls_init(struct net *net, struct nlattr *nla,
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
index 4f72e6e7dbda..051cd2092859 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -134,6 +134,17 @@ static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
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
@@ -141,10 +152,9 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 {
 	struct tc_action_net *tn = net_generic(net, pedit_net_id);
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
@@ -171,109 +181,125 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
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
@@ -324,28 +350,30 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
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
@@ -421,11 +449,10 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
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
 
@@ -444,30 +471,33 @@ static int tcf_pedit_dump(struct sk_buff *skb, struct tc_action *a,
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
index ab4ae24ab886..ca67d9644917 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -55,8 +55,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
-	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
-	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
+
+	if (!tb[TCA_SAMPLE_PARMS])
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
@@ -80,6 +80,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
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
index 54c5ff207fb1..000000000000
--- a/net/sched/cls_tcindex.c
+++ /dev/null
@@ -1,756 +0,0 @@
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
-			if (walker->count >= walker->skip) {
-				if (walker->fn(tp, p->perfect + i, walker) < 0) {
-					walker->stop = 1;
-					return;
-				}
-			}
-			walker->count++;
-		}
-	}
-	if (!p->h)
-		return;
-	for (i = 0; i < p->hash; i++) {
-		for (f = rtnl_dereference(p->h[i]); f; f = next) {
-			next = rtnl_dereference(f->next);
-			if (walker->count >= walker->skip) {
-				if (walker->fn(tp, &f->result, walker) < 0) {
-					walker->stop = 1;
-					return;
-				}
-			}
-			walker->count++;
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
-	if (r && r->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &r->res, base);
-		else
-			__tcf_unbind_filter(q, &r->res);
-	}
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
index c0fea678abb1..bc897ff56e78 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -950,7 +950,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			       MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1284,7 +1286,9 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2284,11 +2288,19 @@ static void tx_work_handler(struct work_struct *work)
 
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
 
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index d59a7e99ce42..c3deb82c5da3 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1830,7 +1830,7 @@ config SND_SOC_WSA881X
 config SND_SOC_ZL38060
 	tristate "Microsemi ZL38060 Connected Home Audio Processor"
 	depends on SPI_MASTER
-	select GPIOLIB
+	depends on GPIOLIB
 	select REGMAP
 	help
 	  Support for ZL38060 Connected Home Audio Processor from Microsemi,
diff --git a/sound/soc/codecs/adau7118.c b/sound/soc/codecs/adau7118.c
index 841229dcbca1..305f294b7710 100644
--- a/sound/soc/codecs/adau7118.c
+++ b/sound/soc/codecs/adau7118.c
@@ -445,22 +445,6 @@ static const struct snd_soc_component_driver adau7118_component_driver = {
 	.non_legacy_dai_naming	= 1,
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
@@ -482,8 +466,7 @@ static int adau7118_regulator_setup(struct adau7118_data *st)
 		regcache_cache_only(st->map, true);
 	}
 
-	return devm_add_action_or_reset(st->dev, adau7118_regulator_disable,
-					st);
+	return 0;
 }
 
 static int adau7118_parset_dt(const struct adau7118_data *st)
diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index 7378e42f2766..9031d410bbd0 100644
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
index 2fc0270e3c1f..32f119e8c3b2 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -573,6 +573,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (strncmp(key_name, STATIC_CALL_TRAMP_PREFIX_STR,
 			    STATIC_CALL_TRAMP_PREFIX_LEN)) {
 			WARN("static_call: trampoline name malformed: %s", key_name);
+			free(key_name);
 			return -1;
 		}
 		tmp = key_name + STATIC_CALL_TRAMP_PREFIX_LEN - STATIC_CALL_KEY_PREFIX_LEN;
@@ -582,6 +583,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (!key_sym) {
 			if (!module) {
 				WARN("static_call: can't find static_call_key symbol: %s", tmp);
+				free(key_name);
 				return -1;
 			}
 
