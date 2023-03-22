Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B85C6C5445
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 19:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjCVSzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 14:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjCVSy2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 14:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28C365C63;
        Wed, 22 Mar 2023 11:53:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E59A62214;
        Wed, 22 Mar 2023 18:53:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737B2C433EF;
        Wed, 22 Mar 2023 18:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679511218;
        bh=wKqPdrjfoS/UnwG14iUNlqKS61Wyr/h6C74nnsHBU8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jclRIS++fb1qOWvBLKZZmCzqET3MppzqUEr7LpKOf5u+ndVwJ8NBvgEAZaCIDKnne
         uHf/3MwlFVm/1viIALU+GqWDAc8/b2njI/iwW/AtPT0TAcfadKgzLYlfI0PHX7oOpb
         S9XcJNxW3iroUIHZHTwY/KoTj4j09r7WCnx2/8so=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.176
Date:   Wed, 22 Mar 2023 19:53:18 +0100
Message-Id: <1679511198957@kroah.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <1679511198146230@kroah.com>
References: <1679511198146230@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
index ca52c82e5bb5..f7b69a0e71e1 100644
--- a/Documentation/filesystems/vfs.rst
+++ b/Documentation/filesystems/vfs.rst
@@ -1188,7 +1188,7 @@ defined:
 	return
 	-ECHILD and it will be called again in ref-walk mode.
 
-``_weak_revalidate``
+``d_weak_revalidate``
 	called when the VFS needs to revalidate a "jumped" dentry.  This
 	is called when a path-walk ends at dentry that was not acquired
 	by doing a lookup in the parent directory.  This includes "/",
diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
index 87cf5c010d5d..ed2e45f9b762 100644
--- a/Documentation/trace/ftrace.rst
+++ b/Documentation/trace/ftrace.rst
@@ -2923,7 +2923,7 @@ Produces::
               bash-1994  [000] ....  4342.324898: ima_get_action <-process_measurement
               bash-1994  [000] ....  4342.324898: ima_match_policy <-ima_get_action
               bash-1994  [000] ....  4342.324899: do_truncate <-do_last
-              bash-1994  [000] ....  4342.324899: should_remove_suid <-do_truncate
+              bash-1994  [000] ....  4342.324899: setattr_should_drop_suidgid <-do_truncate
               bash-1994  [000] ....  4342.324899: notify_change <-do_truncate
               bash-1994  [000] ....  4342.324900: current_fs_time <-notify_change
               bash-1994  [000] ....  4342.324900: current_kernel_time <-current_fs_time
diff --git a/Makefile b/Makefile
index e6b09052f222..71caf5938361 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 175
+SUBLEVEL = 176
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/s390/boot/ipl_report.c b/arch/s390/boot/ipl_report.c
index 0b4965573656..88bacf4999c4 100644
--- a/arch/s390/boot/ipl_report.c
+++ b/arch/s390/boot/ipl_report.c
@@ -57,11 +57,19 @@ static unsigned long find_bootdata_space(struct ipl_rb_components *comps,
 	if (IS_ENABLED(CONFIG_BLK_DEV_INITRD) && INITRD_START && INITRD_SIZE &&
 	    intersects(INITRD_START, INITRD_SIZE, safe_addr, size))
 		safe_addr = INITRD_START + INITRD_SIZE;
+	if (intersects(safe_addr, size, (unsigned long)comps, comps->len)) {
+		safe_addr = (unsigned long)comps + comps->len;
+		goto repeat;
+	}
 	for_each_rb_entry(comp, comps)
 		if (intersects(safe_addr, size, comp->addr, comp->len)) {
 			safe_addr = comp->addr + comp->len;
 			goto repeat;
 		}
+	if (intersects(safe_addr, size, (unsigned long)certs, certs->len)) {
+		safe_addr = (unsigned long)certs + certs->len;
+		goto repeat;
+	}
 	for_each_rb_entry(cert, certs)
 		if (intersects(safe_addr, size, cert->addr, cert->len)) {
 			safe_addr = cert->addr + cert->len;
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 1906387a0faf..0b7c81389c50 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2309,6 +2309,7 @@ static void mce_restart(void)
 {
 	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
+	mce_schedule_work();
 }
 
 /* Toggle features for corrected errors */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 91371b01eae0..c165ddbb672f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2998,7 +2998,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					struct vmcs12 *vmcs12,
 					enum vm_entry_failure_code *entry_failure_code)
 {
-	bool ia32e;
+	bool ia32e = !!(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE);
 
 	*entry_failure_code = ENTRY_FAIL_DEFAULT;
 
@@ -3024,6 +3024,13 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					   vmcs12->guest_ia32_perf_global_ctrl)))
 		return -EINVAL;
 
+	if (CC((vmcs12->guest_cr0 & (X86_CR0_PG | X86_CR0_PE)) == X86_CR0_PG))
+		return -EINVAL;
+
+	if (CC(ia32e && !(vmcs12->guest_cr4 & X86_CR4_PAE)) ||
+	    CC(ia32e && !(vmcs12->guest_cr0 & X86_CR0_PG)))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
@@ -3035,7 +3042,6 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	 */
 	if (to_vmx(vcpu)->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
-		ia32e = (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) != 0;
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
 		    CC(((vmcs12->guest_cr0 & X86_CR0_PG) &&
diff --git a/arch/x86/mm/mem_encrypt_identity.c b/arch/x86/mm/mem_encrypt_identity.c
index 011e042b47ba..5ec47af786dd 100644
--- a/arch/x86/mm/mem_encrypt_identity.c
+++ b/arch/x86/mm/mem_encrypt_identity.c
@@ -586,7 +586,8 @@ void __init sme_enable(struct boot_params *bp)
 	cmdline_ptr = (const char *)((u64)bp->hdr.cmd_line_ptr |
 				     ((u64)bp->ext_cmd_line_ptr << 32));
 
-	cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer));
+	if (cmdline_find_option(cmdline_ptr, cmdline_arg, buffer, sizeof(buffer)) < 0)
+		return;
 
 	if (!strncmp(buffer, cmdline_on, sizeof(buffer)))
 		sme_me_mask = me_mask;
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 40c53632512b..9617688b58b3 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -16,13 +16,7 @@ menuconfig BLK_DEV
 
 if BLK_DEV
 
-config BLK_DEV_NULL_BLK
-	tristate "Null test block driver"
-	select CONFIGFS_FS
-
-config BLK_DEV_NULL_BLK_FAULT_INJECTION
-	bool "Support fault injection for Null test block driver"
-	depends on BLK_DEV_NULL_BLK && FAULT_INJECTION
+source "drivers/block/null_blk/Kconfig"
 
 config BLK_DEV_FD
 	tristate "Normal floppy disk support"
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index e1f63117ee94..a3170859e01d 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -41,12 +41,7 @@ obj-$(CONFIG_BLK_DEV_RSXX) += rsxx/
 obj-$(CONFIG_ZRAM) += zram/
 obj-$(CONFIG_BLK_DEV_RNBD)	+= rnbd/
 
-obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk.o
-null_blk-objs	:= null_blk_main.o
-ifeq ($(CONFIG_BLK_DEV_ZONED), y)
-null_blk-$(CONFIG_TRACING) += null_blk_trace.o
-endif
-null_blk-$(CONFIG_BLK_DEV_ZONED) += null_blk_zoned.o
+obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk/
 
 skd-y		:= skd_main.o
 swim_mod-y	:= swim.o swim_asm.o
diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
deleted file mode 100644
index 7de703f28617..000000000000
--- a/drivers/block/null_blk.h
+++ /dev/null
@@ -1,137 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __BLK_NULL_BLK_H
-#define __BLK_NULL_BLK_H
-
-#undef pr_fmt
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
-#include <linux/blkdev.h>
-#include <linux/slab.h>
-#include <linux/blk-mq.h>
-#include <linux/hrtimer.h>
-#include <linux/configfs.h>
-#include <linux/badblocks.h>
-#include <linux/fault-inject.h>
-
-struct nullb_cmd {
-	struct request *rq;
-	struct bio *bio;
-	unsigned int tag;
-	blk_status_t error;
-	struct nullb_queue *nq;
-	struct hrtimer timer;
-	bool fake_timeout;
-};
-
-struct nullb_queue {
-	unsigned long *tag_map;
-	wait_queue_head_t wait;
-	unsigned int queue_depth;
-	struct nullb_device *dev;
-	unsigned int requeue_selection;
-
-	struct nullb_cmd *cmds;
-};
-
-struct nullb_device {
-	struct nullb *nullb;
-	struct config_item item;
-	struct radix_tree_root data; /* data stored in the disk */
-	struct radix_tree_root cache; /* disk cache data */
-	unsigned long flags; /* device flags */
-	unsigned int curr_cache;
-	struct badblocks badblocks;
-
-	unsigned int nr_zones;
-	unsigned int nr_zones_imp_open;
-	unsigned int nr_zones_exp_open;
-	unsigned int nr_zones_closed;
-	struct blk_zone *zones;
-	sector_t zone_size_sects;
-	spinlock_t zone_lock;
-	unsigned long *zone_locks;
-
-	unsigned long size; /* device size in MB */
-	unsigned long completion_nsec; /* time in ns to complete a request */
-	unsigned long cache_size; /* disk cache size in MB */
-	unsigned long zone_size; /* zone size in MB if device is zoned */
-	unsigned long zone_capacity; /* zone capacity in MB if device is zoned */
-	unsigned int zone_nr_conv; /* number of conventional zones */
-	unsigned int zone_max_open; /* max number of open zones */
-	unsigned int zone_max_active; /* max number of active zones */
-	unsigned int submit_queues; /* number of submission queues */
-	unsigned int home_node; /* home node for the device */
-	unsigned int queue_mode; /* block interface */
-	unsigned int blocksize; /* block size */
-	unsigned int irqmode; /* IRQ completion handler */
-	unsigned int hw_queue_depth; /* queue depth */
-	unsigned int index; /* index of the disk, only valid with a disk */
-	unsigned int mbps; /* Bandwidth throttle cap (in MB/s) */
-	bool blocking; /* blocking blk-mq device */
-	bool use_per_node_hctx; /* use per-node allocation for hardware context */
-	bool power; /* power on/off the device */
-	bool memory_backed; /* if data is stored in memory */
-	bool discard; /* if support discard */
-	bool zoned; /* if device is zoned */
-};
-
-struct nullb {
-	struct nullb_device *dev;
-	struct list_head list;
-	unsigned int index;
-	struct request_queue *q;
-	struct gendisk *disk;
-	struct blk_mq_tag_set *tag_set;
-	struct blk_mq_tag_set __tag_set;
-	unsigned int queue_depth;
-	atomic_long_t cur_bytes;
-	struct hrtimer bw_timer;
-	unsigned long cache_flush_pos;
-	spinlock_t lock;
-
-	struct nullb_queue *queues;
-	unsigned int nr_queues;
-	char disk_name[DISK_NAME_LEN];
-};
-
-blk_status_t null_process_cmd(struct nullb_cmd *cmd,
-			      enum req_opf op, sector_t sector,
-			      unsigned int nr_sectors);
-
-#ifdef CONFIG_BLK_DEV_ZONED
-int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q);
-int null_register_zoned_dev(struct nullb *nullb);
-void null_free_zoned_dev(struct nullb_device *dev);
-int null_report_zones(struct gendisk *disk, sector_t sector,
-		      unsigned int nr_zones, report_zones_cb cb, void *data);
-blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd,
-				    enum req_opf op, sector_t sector,
-				    sector_t nr_sectors);
-size_t null_zone_valid_read_len(struct nullb *nullb,
-				sector_t sector, unsigned int len);
-#else
-static inline int null_init_zoned_dev(struct nullb_device *dev,
-				      struct request_queue *q)
-{
-	pr_err("CONFIG_BLK_DEV_ZONED not enabled\n");
-	return -EINVAL;
-}
-static inline int null_register_zoned_dev(struct nullb *nullb)
-{
-	return -ENODEV;
-}
-static inline void null_free_zoned_dev(struct nullb_device *dev) {}
-static inline blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd,
-			enum req_opf op, sector_t sector, sector_t nr_sectors)
-{
-	return BLK_STS_NOTSUPP;
-}
-static inline size_t null_zone_valid_read_len(struct nullb *nullb,
-					      sector_t sector,
-					      unsigned int len)
-{
-	return len;
-}
-#define null_report_zones	NULL
-#endif /* CONFIG_BLK_DEV_ZONED */
-#endif /* __NULL_BLK_H */
diff --git a/drivers/block/null_blk/Kconfig b/drivers/block/null_blk/Kconfig
new file mode 100644
index 000000000000..6bf1f8ca20a2
--- /dev/null
+++ b/drivers/block/null_blk/Kconfig
@@ -0,0 +1,12 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Null block device driver configuration
+#
+
+config BLK_DEV_NULL_BLK
+	tristate "Null test block driver"
+	select CONFIGFS_FS
+
+config BLK_DEV_NULL_BLK_FAULT_INJECTION
+	bool "Support fault injection for Null test block driver"
+	depends on BLK_DEV_NULL_BLK && FAULT_INJECTION
diff --git a/drivers/block/null_blk/Makefile b/drivers/block/null_blk/Makefile
new file mode 100644
index 000000000000..84c36e512ab8
--- /dev/null
+++ b/drivers/block/null_blk/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+
+# needed for trace events
+ccflags-y			+= -I$(src)
+
+obj-$(CONFIG_BLK_DEV_NULL_BLK)	+= null_blk.o
+null_blk-objs			:= main.o
+ifeq ($(CONFIG_BLK_DEV_ZONED), y)
+null_blk-$(CONFIG_TRACING) 	+= trace.o
+endif
+null_blk-$(CONFIG_BLK_DEV_ZONED) += zoned.o
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
new file mode 100644
index 000000000000..25db095e943b
--- /dev/null
+++ b/drivers/block/null_blk/main.c
@@ -0,0 +1,2036 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Add configfs and memory store: Kyungchan Koh <kkc6196@fb.com> and
+ * Shaohua Li <shli@fb.com>
+ */
+#include <linux/module.h>
+
+#include <linux/moduleparam.h>
+#include <linux/sched.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include "null_blk.h"
+
+#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
+#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
+#define SECTOR_MASK		(PAGE_SECTORS - 1)
+
+#define FREE_BATCH		16
+
+#define TICKS_PER_SEC		50ULL
+#define TIMER_INTERVAL		(NSEC_PER_SEC / TICKS_PER_SEC)
+
+#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
+static DECLARE_FAULT_ATTR(null_timeout_attr);
+static DECLARE_FAULT_ATTR(null_requeue_attr);
+static DECLARE_FAULT_ATTR(null_init_hctx_attr);
+#endif
+
+static inline u64 mb_per_tick(int mbps)
+{
+	return (1 << 20) / TICKS_PER_SEC * ((u64) mbps);
+}
+
+/*
+ * Status flags for nullb_device.
+ *
+ * CONFIGURED:	Device has been configured and turned on. Cannot reconfigure.
+ * UP:		Device is currently on and visible in userspace.
+ * THROTTLED:	Device is being throttled.
+ * CACHE:	Device is using a write-back cache.
+ */
+enum nullb_device_flags {
+	NULLB_DEV_FL_CONFIGURED	= 0,
+	NULLB_DEV_FL_UP		= 1,
+	NULLB_DEV_FL_THROTTLED	= 2,
+	NULLB_DEV_FL_CACHE	= 3,
+};
+
+#define MAP_SZ		((PAGE_SIZE >> SECTOR_SHIFT) + 2)
+/*
+ * nullb_page is a page in memory for nullb devices.
+ *
+ * @page:	The page holding the data.
+ * @bitmap:	The bitmap represents which sector in the page has data.
+ *		Each bit represents one block size. For example, sector 8
+ *		will use the 7th bit
+ * The highest 2 bits of bitmap are for special purpose. LOCK means the cache
+ * page is being flushing to storage. FREE means the cache page is freed and
+ * should be skipped from flushing to storage. Please see
+ * null_make_cache_space
+ */
+struct nullb_page {
+	struct page *page;
+	DECLARE_BITMAP(bitmap, MAP_SZ);
+};
+#define NULLB_PAGE_LOCK (MAP_SZ - 1)
+#define NULLB_PAGE_FREE (MAP_SZ - 2)
+
+static LIST_HEAD(nullb_list);
+static struct mutex lock;
+static int null_major;
+static DEFINE_IDA(nullb_indexes);
+static struct blk_mq_tag_set tag_set;
+
+enum {
+	NULL_IRQ_NONE		= 0,
+	NULL_IRQ_SOFTIRQ	= 1,
+	NULL_IRQ_TIMER		= 2,
+};
+
+enum {
+	NULL_Q_BIO		= 0,
+	NULL_Q_RQ		= 1,
+	NULL_Q_MQ		= 2,
+};
+
+static int g_no_sched;
+module_param_named(no_sched, g_no_sched, int, 0444);
+MODULE_PARM_DESC(no_sched, "No io scheduler");
+
+static int g_submit_queues = 1;
+module_param_named(submit_queues, g_submit_queues, int, 0444);
+MODULE_PARM_DESC(submit_queues, "Number of submission queues");
+
+static int g_home_node = NUMA_NO_NODE;
+module_param_named(home_node, g_home_node, int, 0444);
+MODULE_PARM_DESC(home_node, "Home node for the device");
+
+#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
+/*
+ * For more details about fault injection, please refer to
+ * Documentation/fault-injection/fault-injection.rst.
+ */
+static char g_timeout_str[80];
+module_param_string(timeout, g_timeout_str, sizeof(g_timeout_str), 0444);
+MODULE_PARM_DESC(timeout, "Fault injection. timeout=<interval>,<probability>,<space>,<times>");
+
+static char g_requeue_str[80];
+module_param_string(requeue, g_requeue_str, sizeof(g_requeue_str), 0444);
+MODULE_PARM_DESC(requeue, "Fault injection. requeue=<interval>,<probability>,<space>,<times>");
+
+static char g_init_hctx_str[80];
+module_param_string(init_hctx, g_init_hctx_str, sizeof(g_init_hctx_str), 0444);
+MODULE_PARM_DESC(init_hctx, "Fault injection to fail hctx init. init_hctx=<interval>,<probability>,<space>,<times>");
+#endif
+
+static int g_queue_mode = NULL_Q_MQ;
+
+static int null_param_store_val(const char *str, int *val, int min, int max)
+{
+	int ret, new_val;
+
+	ret = kstrtoint(str, 10, &new_val);
+	if (ret)
+		return -EINVAL;
+
+	if (new_val < min || new_val > max)
+		return -EINVAL;
+
+	*val = new_val;
+	return 0;
+}
+
+static int null_set_queue_mode(const char *str, const struct kernel_param *kp)
+{
+	return null_param_store_val(str, &g_queue_mode, NULL_Q_BIO, NULL_Q_MQ);
+}
+
+static const struct kernel_param_ops null_queue_mode_param_ops = {
+	.set	= null_set_queue_mode,
+	.get	= param_get_int,
+};
+
+device_param_cb(queue_mode, &null_queue_mode_param_ops, &g_queue_mode, 0444);
+MODULE_PARM_DESC(queue_mode, "Block interface to use (0=bio,1=rq,2=multiqueue)");
+
+static int g_gb = 250;
+module_param_named(gb, g_gb, int, 0444);
+MODULE_PARM_DESC(gb, "Size in GB");
+
+static int g_bs = 512;
+module_param_named(bs, g_bs, int, 0444);
+MODULE_PARM_DESC(bs, "Block size (in bytes)");
+
+static unsigned int nr_devices = 1;
+module_param(nr_devices, uint, 0444);
+MODULE_PARM_DESC(nr_devices, "Number of devices to register");
+
+static bool g_blocking;
+module_param_named(blocking, g_blocking, bool, 0444);
+MODULE_PARM_DESC(blocking, "Register as a blocking blk-mq driver device");
+
+static bool shared_tags;
+module_param(shared_tags, bool, 0444);
+MODULE_PARM_DESC(shared_tags, "Share tag set between devices for blk-mq");
+
+static bool g_shared_tag_bitmap;
+module_param_named(shared_tag_bitmap, g_shared_tag_bitmap, bool, 0444);
+MODULE_PARM_DESC(shared_tag_bitmap, "Use shared tag bitmap for all submission queues for blk-mq");
+
+static int g_irqmode = NULL_IRQ_SOFTIRQ;
+
+static int null_set_irqmode(const char *str, const struct kernel_param *kp)
+{
+	return null_param_store_val(str, &g_irqmode, NULL_IRQ_NONE,
+					NULL_IRQ_TIMER);
+}
+
+static const struct kernel_param_ops null_irqmode_param_ops = {
+	.set	= null_set_irqmode,
+	.get	= param_get_int,
+};
+
+device_param_cb(irqmode, &null_irqmode_param_ops, &g_irqmode, 0444);
+MODULE_PARM_DESC(irqmode, "IRQ completion handler. 0-none, 1-softirq, 2-timer");
+
+static unsigned long g_completion_nsec = 10000;
+module_param_named(completion_nsec, g_completion_nsec, ulong, 0444);
+MODULE_PARM_DESC(completion_nsec, "Time in ns to complete a request in hardware. Default: 10,000ns");
+
+static int g_hw_queue_depth = 64;
+module_param_named(hw_queue_depth, g_hw_queue_depth, int, 0444);
+MODULE_PARM_DESC(hw_queue_depth, "Queue depth for each hardware queue. Default: 64");
+
+static bool g_use_per_node_hctx;
+module_param_named(use_per_node_hctx, g_use_per_node_hctx, bool, 0444);
+MODULE_PARM_DESC(use_per_node_hctx, "Use per-node allocation for hardware context queues. Default: false");
+
+static bool g_zoned;
+module_param_named(zoned, g_zoned, bool, S_IRUGO);
+MODULE_PARM_DESC(zoned, "Make device as a host-managed zoned block device. Default: false");
+
+static unsigned long g_zone_size = 256;
+module_param_named(zone_size, g_zone_size, ulong, S_IRUGO);
+MODULE_PARM_DESC(zone_size, "Zone size in MB when block device is zoned. Must be power-of-two: Default: 256");
+
+static unsigned long g_zone_capacity;
+module_param_named(zone_capacity, g_zone_capacity, ulong, 0444);
+MODULE_PARM_DESC(zone_capacity, "Zone capacity in MB when block device is zoned. Can be less than or equal to zone size. Default: Zone size");
+
+static unsigned int g_zone_nr_conv;
+module_param_named(zone_nr_conv, g_zone_nr_conv, uint, 0444);
+MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones when block device is zoned. Default: 0");
+
+static unsigned int g_zone_max_open;
+module_param_named(zone_max_open, g_zone_max_open, uint, 0444);
+MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones when block device is zoned. Default: 0 (no limit)");
+
+static unsigned int g_zone_max_active;
+module_param_named(zone_max_active, g_zone_max_active, uint, 0444);
+MODULE_PARM_DESC(zone_max_active, "Maximum number of active zones when block device is zoned. Default: 0 (no limit)");
+
+static struct nullb_device *null_alloc_dev(void);
+static void null_free_dev(struct nullb_device *dev);
+static void null_del_dev(struct nullb *nullb);
+static int null_add_dev(struct nullb_device *dev);
+static void null_free_device_storage(struct nullb_device *dev, bool is_cache);
+
+static inline struct nullb_device *to_nullb_device(struct config_item *item)
+{
+	return item ? container_of(item, struct nullb_device, item) : NULL;
+}
+
+static inline ssize_t nullb_device_uint_attr_show(unsigned int val, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%u\n", val);
+}
+
+static inline ssize_t nullb_device_ulong_attr_show(unsigned long val,
+	char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%lu\n", val);
+}
+
+static inline ssize_t nullb_device_bool_attr_show(bool val, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%u\n", val);
+}
+
+static ssize_t nullb_device_uint_attr_store(unsigned int *val,
+	const char *page, size_t count)
+{
+	unsigned int tmp;
+	int result;
+
+	result = kstrtouint(page, 0, &tmp);
+	if (result < 0)
+		return result;
+
+	*val = tmp;
+	return count;
+}
+
+static ssize_t nullb_device_ulong_attr_store(unsigned long *val,
+	const char *page, size_t count)
+{
+	int result;
+	unsigned long tmp;
+
+	result = kstrtoul(page, 0, &tmp);
+	if (result < 0)
+		return result;
+
+	*val = tmp;
+	return count;
+}
+
+static ssize_t nullb_device_bool_attr_store(bool *val, const char *page,
+	size_t count)
+{
+	bool tmp;
+	int result;
+
+	result = kstrtobool(page,  &tmp);
+	if (result < 0)
+		return result;
+
+	*val = tmp;
+	return count;
+}
+
+/* The following macro should only be used with TYPE = {uint, ulong, bool}. */
+#define NULLB_DEVICE_ATTR(NAME, TYPE, APPLY)				\
+static ssize_t								\
+nullb_device_##NAME##_show(struct config_item *item, char *page)	\
+{									\
+	return nullb_device_##TYPE##_attr_show(				\
+				to_nullb_device(item)->NAME, page);	\
+}									\
+static ssize_t								\
+nullb_device_##NAME##_store(struct config_item *item, const char *page,	\
+			    size_t count)				\
+{									\
+	int (*apply_fn)(struct nullb_device *dev, TYPE new_value) = APPLY;\
+	struct nullb_device *dev = to_nullb_device(item);		\
+	TYPE new_value = 0;						\
+	int ret;							\
+									\
+	ret = nullb_device_##TYPE##_attr_store(&new_value, page, count);\
+	if (ret < 0)							\
+		return ret;						\
+	if (apply_fn)							\
+		ret = apply_fn(dev, new_value);				\
+	else if (test_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags)) 	\
+		ret = -EBUSY;						\
+	if (ret < 0)							\
+		return ret;						\
+	dev->NAME = new_value;						\
+	return count;							\
+}									\
+CONFIGFS_ATTR(nullb_device_, NAME);
+
+static int nullb_apply_submit_queues(struct nullb_device *dev,
+				     unsigned int submit_queues)
+{
+	struct nullb *nullb = dev->nullb;
+	struct blk_mq_tag_set *set;
+
+	if (!nullb)
+		return 0;
+
+	/*
+	 * Make sure that null_init_hctx() does not access nullb->queues[] past
+	 * the end of that array.
+	 */
+	if (submit_queues > nr_cpu_ids)
+		return -EINVAL;
+	set = nullb->tag_set;
+	blk_mq_update_nr_hw_queues(set, submit_queues);
+	return set->nr_hw_queues == submit_queues ? 0 : -ENOMEM;
+}
+
+NULLB_DEVICE_ATTR(size, ulong, NULL);
+NULLB_DEVICE_ATTR(completion_nsec, ulong, NULL);
+NULLB_DEVICE_ATTR(submit_queues, uint, nullb_apply_submit_queues);
+NULLB_DEVICE_ATTR(home_node, uint, NULL);
+NULLB_DEVICE_ATTR(queue_mode, uint, NULL);
+NULLB_DEVICE_ATTR(blocksize, uint, NULL);
+NULLB_DEVICE_ATTR(irqmode, uint, NULL);
+NULLB_DEVICE_ATTR(hw_queue_depth, uint, NULL);
+NULLB_DEVICE_ATTR(index, uint, NULL);
+NULLB_DEVICE_ATTR(blocking, bool, NULL);
+NULLB_DEVICE_ATTR(use_per_node_hctx, bool, NULL);
+NULLB_DEVICE_ATTR(memory_backed, bool, NULL);
+NULLB_DEVICE_ATTR(discard, bool, NULL);
+NULLB_DEVICE_ATTR(mbps, uint, NULL);
+NULLB_DEVICE_ATTR(cache_size, ulong, NULL);
+NULLB_DEVICE_ATTR(zoned, bool, NULL);
+NULLB_DEVICE_ATTR(zone_size, ulong, NULL);
+NULLB_DEVICE_ATTR(zone_capacity, ulong, NULL);
+NULLB_DEVICE_ATTR(zone_nr_conv, uint, NULL);
+NULLB_DEVICE_ATTR(zone_max_open, uint, NULL);
+NULLB_DEVICE_ATTR(zone_max_active, uint, NULL);
+
+static ssize_t nullb_device_power_show(struct config_item *item, char *page)
+{
+	return nullb_device_bool_attr_show(to_nullb_device(item)->power, page);
+}
+
+static ssize_t nullb_device_power_store(struct config_item *item,
+				     const char *page, size_t count)
+{
+	struct nullb_device *dev = to_nullb_device(item);
+	bool newp = false;
+	ssize_t ret;
+
+	ret = nullb_device_bool_attr_store(&newp, page, count);
+	if (ret < 0)
+		return ret;
+
+	if (!dev->power && newp) {
+		if (test_and_set_bit(NULLB_DEV_FL_UP, &dev->flags))
+			return count;
+		if (null_add_dev(dev)) {
+			clear_bit(NULLB_DEV_FL_UP, &dev->flags);
+			return -ENOMEM;
+		}
+
+		set_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
+		dev->power = newp;
+	} else if (dev->power && !newp) {
+		if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
+			mutex_lock(&lock);
+			dev->power = newp;
+			null_del_dev(dev->nullb);
+			mutex_unlock(&lock);
+		}
+		clear_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
+	}
+
+	return count;
+}
+
+CONFIGFS_ATTR(nullb_device_, power);
+
+static ssize_t nullb_device_badblocks_show(struct config_item *item, char *page)
+{
+	struct nullb_device *t_dev = to_nullb_device(item);
+
+	return badblocks_show(&t_dev->badblocks, page, 0);
+}
+
+static ssize_t nullb_device_badblocks_store(struct config_item *item,
+				     const char *page, size_t count)
+{
+	struct nullb_device *t_dev = to_nullb_device(item);
+	char *orig, *buf, *tmp;
+	u64 start, end;
+	int ret;
+
+	orig = kstrndup(page, count, GFP_KERNEL);
+	if (!orig)
+		return -ENOMEM;
+
+	buf = strstrip(orig);
+
+	ret = -EINVAL;
+	if (buf[0] != '+' && buf[0] != '-')
+		goto out;
+	tmp = strchr(&buf[1], '-');
+	if (!tmp)
+		goto out;
+	*tmp = '\0';
+	ret = kstrtoull(buf + 1, 0, &start);
+	if (ret)
+		goto out;
+	ret = kstrtoull(tmp + 1, 0, &end);
+	if (ret)
+		goto out;
+	ret = -EINVAL;
+	if (start > end)
+		goto out;
+	/* enable badblocks */
+	cmpxchg(&t_dev->badblocks.shift, -1, 0);
+	if (buf[0] == '+')
+		ret = badblocks_set(&t_dev->badblocks, start,
+			end - start + 1, 1);
+	else
+		ret = badblocks_clear(&t_dev->badblocks, start,
+			end - start + 1);
+	if (ret == 0)
+		ret = count;
+out:
+	kfree(orig);
+	return ret;
+}
+CONFIGFS_ATTR(nullb_device_, badblocks);
+
+static struct configfs_attribute *nullb_device_attrs[] = {
+	&nullb_device_attr_size,
+	&nullb_device_attr_completion_nsec,
+	&nullb_device_attr_submit_queues,
+	&nullb_device_attr_home_node,
+	&nullb_device_attr_queue_mode,
+	&nullb_device_attr_blocksize,
+	&nullb_device_attr_irqmode,
+	&nullb_device_attr_hw_queue_depth,
+	&nullb_device_attr_index,
+	&nullb_device_attr_blocking,
+	&nullb_device_attr_use_per_node_hctx,
+	&nullb_device_attr_power,
+	&nullb_device_attr_memory_backed,
+	&nullb_device_attr_discard,
+	&nullb_device_attr_mbps,
+	&nullb_device_attr_cache_size,
+	&nullb_device_attr_badblocks,
+	&nullb_device_attr_zoned,
+	&nullb_device_attr_zone_size,
+	&nullb_device_attr_zone_capacity,
+	&nullb_device_attr_zone_nr_conv,
+	&nullb_device_attr_zone_max_open,
+	&nullb_device_attr_zone_max_active,
+	NULL,
+};
+
+static void nullb_device_release(struct config_item *item)
+{
+	struct nullb_device *dev = to_nullb_device(item);
+
+	null_free_device_storage(dev, false);
+	null_free_dev(dev);
+}
+
+static struct configfs_item_operations nullb_device_ops = {
+	.release	= nullb_device_release,
+};
+
+static const struct config_item_type nullb_device_type = {
+	.ct_item_ops	= &nullb_device_ops,
+	.ct_attrs	= nullb_device_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct
+config_item *nullb_group_make_item(struct config_group *group, const char *name)
+{
+	struct nullb_device *dev;
+
+	dev = null_alloc_dev();
+	if (!dev)
+		return ERR_PTR(-ENOMEM);
+
+	config_item_init_type_name(&dev->item, name, &nullb_device_type);
+
+	return &dev->item;
+}
+
+static void
+nullb_group_drop_item(struct config_group *group, struct config_item *item)
+{
+	struct nullb_device *dev = to_nullb_device(item);
+
+	if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
+		mutex_lock(&lock);
+		dev->power = false;
+		null_del_dev(dev->nullb);
+		mutex_unlock(&lock);
+	}
+
+	config_item_put(item);
+}
+
+static ssize_t memb_group_features_show(struct config_item *item, char *page)
+{
+	return snprintf(page, PAGE_SIZE,
+			"memory_backed,discard,bandwidth,cache,badblocks,zoned,zone_size,zone_capacity,zone_nr_conv,zone_max_open,zone_max_active\n");
+}
+
+CONFIGFS_ATTR_RO(memb_group_, features);
+
+static struct configfs_attribute *nullb_group_attrs[] = {
+	&memb_group_attr_features,
+	NULL,
+};
+
+static struct configfs_group_operations nullb_group_ops = {
+	.make_item	= nullb_group_make_item,
+	.drop_item	= nullb_group_drop_item,
+};
+
+static const struct config_item_type nullb_group_type = {
+	.ct_group_ops	= &nullb_group_ops,
+	.ct_attrs	= nullb_group_attrs,
+	.ct_owner	= THIS_MODULE,
+};
+
+static struct configfs_subsystem nullb_subsys = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "nullb",
+			.ci_type = &nullb_group_type,
+		},
+	},
+};
+
+static inline int null_cache_active(struct nullb *nullb)
+{
+	return test_bit(NULLB_DEV_FL_CACHE, &nullb->dev->flags);
+}
+
+static struct nullb_device *null_alloc_dev(void)
+{
+	struct nullb_device *dev;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+	INIT_RADIX_TREE(&dev->data, GFP_ATOMIC);
+	INIT_RADIX_TREE(&dev->cache, GFP_ATOMIC);
+	if (badblocks_init(&dev->badblocks, 0)) {
+		kfree(dev);
+		return NULL;
+	}
+
+	dev->size = g_gb * 1024;
+	dev->completion_nsec = g_completion_nsec;
+	dev->submit_queues = g_submit_queues;
+	dev->home_node = g_home_node;
+	dev->queue_mode = g_queue_mode;
+	dev->blocksize = g_bs;
+	dev->irqmode = g_irqmode;
+	dev->hw_queue_depth = g_hw_queue_depth;
+	dev->blocking = g_blocking;
+	dev->use_per_node_hctx = g_use_per_node_hctx;
+	dev->zoned = g_zoned;
+	dev->zone_size = g_zone_size;
+	dev->zone_capacity = g_zone_capacity;
+	dev->zone_nr_conv = g_zone_nr_conv;
+	dev->zone_max_open = g_zone_max_open;
+	dev->zone_max_active = g_zone_max_active;
+	return dev;
+}
+
+static void null_free_dev(struct nullb_device *dev)
+{
+	if (!dev)
+		return;
+
+	null_free_zoned_dev(dev);
+	badblocks_exit(&dev->badblocks);
+	kfree(dev);
+}
+
+static void put_tag(struct nullb_queue *nq, unsigned int tag)
+{
+	clear_bit_unlock(tag, nq->tag_map);
+
+	if (waitqueue_active(&nq->wait))
+		wake_up(&nq->wait);
+}
+
+static unsigned int get_tag(struct nullb_queue *nq)
+{
+	unsigned int tag;
+
+	do {
+		tag = find_first_zero_bit(nq->tag_map, nq->queue_depth);
+		if (tag >= nq->queue_depth)
+			return -1U;
+	} while (test_and_set_bit_lock(tag, nq->tag_map));
+
+	return tag;
+}
+
+static void free_cmd(struct nullb_cmd *cmd)
+{
+	put_tag(cmd->nq, cmd->tag);
+}
+
+static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer);
+
+static struct nullb_cmd *__alloc_cmd(struct nullb_queue *nq)
+{
+	struct nullb_cmd *cmd;
+	unsigned int tag;
+
+	tag = get_tag(nq);
+	if (tag != -1U) {
+		cmd = &nq->cmds[tag];
+		cmd->tag = tag;
+		cmd->error = BLK_STS_OK;
+		cmd->nq = nq;
+		if (nq->dev->irqmode == NULL_IRQ_TIMER) {
+			hrtimer_init(&cmd->timer, CLOCK_MONOTONIC,
+				     HRTIMER_MODE_REL);
+			cmd->timer.function = null_cmd_timer_expired;
+		}
+		return cmd;
+	}
+
+	return NULL;
+}
+
+static struct nullb_cmd *alloc_cmd(struct nullb_queue *nq, int can_wait)
+{
+	struct nullb_cmd *cmd;
+	DEFINE_WAIT(wait);
+
+	cmd = __alloc_cmd(nq);
+	if (cmd || !can_wait)
+		return cmd;
+
+	do {
+		prepare_to_wait(&nq->wait, &wait, TASK_UNINTERRUPTIBLE);
+		cmd = __alloc_cmd(nq);
+		if (cmd)
+			break;
+
+		io_schedule();
+	} while (1);
+
+	finish_wait(&nq->wait, &wait);
+	return cmd;
+}
+
+static void end_cmd(struct nullb_cmd *cmd)
+{
+	int queue_mode = cmd->nq->dev->queue_mode;
+
+	switch (queue_mode)  {
+	case NULL_Q_MQ:
+		blk_mq_end_request(cmd->rq, cmd->error);
+		return;
+	case NULL_Q_BIO:
+		cmd->bio->bi_status = cmd->error;
+		bio_endio(cmd->bio);
+		break;
+	}
+
+	free_cmd(cmd);
+}
+
+static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer)
+{
+	end_cmd(container_of(timer, struct nullb_cmd, timer));
+
+	return HRTIMER_NORESTART;
+}
+
+static void null_cmd_end_timer(struct nullb_cmd *cmd)
+{
+	ktime_t kt = cmd->nq->dev->completion_nsec;
+
+	hrtimer_start(&cmd->timer, kt, HRTIMER_MODE_REL);
+}
+
+static void null_complete_rq(struct request *rq)
+{
+	end_cmd(blk_mq_rq_to_pdu(rq));
+}
+
+static struct nullb_page *null_alloc_page(gfp_t gfp_flags)
+{
+	struct nullb_page *t_page;
+
+	t_page = kmalloc(sizeof(struct nullb_page), gfp_flags);
+	if (!t_page)
+		goto out;
+
+	t_page->page = alloc_pages(gfp_flags, 0);
+	if (!t_page->page)
+		goto out_freepage;
+
+	memset(t_page->bitmap, 0, sizeof(t_page->bitmap));
+	return t_page;
+out_freepage:
+	kfree(t_page);
+out:
+	return NULL;
+}
+
+static void null_free_page(struct nullb_page *t_page)
+{
+	__set_bit(NULLB_PAGE_FREE, t_page->bitmap);
+	if (test_bit(NULLB_PAGE_LOCK, t_page->bitmap))
+		return;
+	__free_page(t_page->page);
+	kfree(t_page);
+}
+
+static bool null_page_empty(struct nullb_page *page)
+{
+	int size = MAP_SZ - 2;
+
+	return find_first_bit(page->bitmap, size) == size;
+}
+
+static void null_free_sector(struct nullb *nullb, sector_t sector,
+	bool is_cache)
+{
+	unsigned int sector_bit;
+	u64 idx;
+	struct nullb_page *t_page, *ret;
+	struct radix_tree_root *root;
+
+	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
+	idx = sector >> PAGE_SECTORS_SHIFT;
+	sector_bit = (sector & SECTOR_MASK);
+
+	t_page = radix_tree_lookup(root, idx);
+	if (t_page) {
+		__clear_bit(sector_bit, t_page->bitmap);
+
+		if (null_page_empty(t_page)) {
+			ret = radix_tree_delete_item(root, idx, t_page);
+			WARN_ON(ret != t_page);
+			null_free_page(ret);
+			if (is_cache)
+				nullb->dev->curr_cache -= PAGE_SIZE;
+		}
+	}
+}
+
+static struct nullb_page *null_radix_tree_insert(struct nullb *nullb, u64 idx,
+	struct nullb_page *t_page, bool is_cache)
+{
+	struct radix_tree_root *root;
+
+	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
+
+	if (radix_tree_insert(root, idx, t_page)) {
+		null_free_page(t_page);
+		t_page = radix_tree_lookup(root, idx);
+		WARN_ON(!t_page || t_page->page->index != idx);
+	} else if (is_cache)
+		nullb->dev->curr_cache += PAGE_SIZE;
+
+	return t_page;
+}
+
+static void null_free_device_storage(struct nullb_device *dev, bool is_cache)
+{
+	unsigned long pos = 0;
+	int nr_pages;
+	struct nullb_page *ret, *t_pages[FREE_BATCH];
+	struct radix_tree_root *root;
+
+	root = is_cache ? &dev->cache : &dev->data;
+
+	do {
+		int i;
+
+		nr_pages = radix_tree_gang_lookup(root,
+				(void **)t_pages, pos, FREE_BATCH);
+
+		for (i = 0; i < nr_pages; i++) {
+			pos = t_pages[i]->page->index;
+			ret = radix_tree_delete_item(root, pos, t_pages[i]);
+			WARN_ON(ret != t_pages[i]);
+			null_free_page(ret);
+		}
+
+		pos++;
+	} while (nr_pages == FREE_BATCH);
+
+	if (is_cache)
+		dev->curr_cache = 0;
+}
+
+static struct nullb_page *__null_lookup_page(struct nullb *nullb,
+	sector_t sector, bool for_write, bool is_cache)
+{
+	unsigned int sector_bit;
+	u64 idx;
+	struct nullb_page *t_page;
+	struct radix_tree_root *root;
+
+	idx = sector >> PAGE_SECTORS_SHIFT;
+	sector_bit = (sector & SECTOR_MASK);
+
+	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
+	t_page = radix_tree_lookup(root, idx);
+	WARN_ON(t_page && t_page->page->index != idx);
+
+	if (t_page && (for_write || test_bit(sector_bit, t_page->bitmap)))
+		return t_page;
+
+	return NULL;
+}
+
+static struct nullb_page *null_lookup_page(struct nullb *nullb,
+	sector_t sector, bool for_write, bool ignore_cache)
+{
+	struct nullb_page *page = NULL;
+
+	if (!ignore_cache)
+		page = __null_lookup_page(nullb, sector, for_write, true);
+	if (page)
+		return page;
+	return __null_lookup_page(nullb, sector, for_write, false);
+}
+
+static struct nullb_page *null_insert_page(struct nullb *nullb,
+					   sector_t sector, bool ignore_cache)
+	__releases(&nullb->lock)
+	__acquires(&nullb->lock)
+{
+	u64 idx;
+	struct nullb_page *t_page;
+
+	t_page = null_lookup_page(nullb, sector, true, ignore_cache);
+	if (t_page)
+		return t_page;
+
+	spin_unlock_irq(&nullb->lock);
+
+	t_page = null_alloc_page(GFP_NOIO);
+	if (!t_page)
+		goto out_lock;
+
+	if (radix_tree_preload(GFP_NOIO))
+		goto out_freepage;
+
+	spin_lock_irq(&nullb->lock);
+	idx = sector >> PAGE_SECTORS_SHIFT;
+	t_page->page->index = idx;
+	t_page = null_radix_tree_insert(nullb, idx, t_page, !ignore_cache);
+	radix_tree_preload_end();
+
+	return t_page;
+out_freepage:
+	null_free_page(t_page);
+out_lock:
+	spin_lock_irq(&nullb->lock);
+	return null_lookup_page(nullb, sector, true, ignore_cache);
+}
+
+static int null_flush_cache_page(struct nullb *nullb, struct nullb_page *c_page)
+{
+	int i;
+	unsigned int offset;
+	u64 idx;
+	struct nullb_page *t_page, *ret;
+	void *dst, *src;
+
+	idx = c_page->page->index;
+
+	t_page = null_insert_page(nullb, idx << PAGE_SECTORS_SHIFT, true);
+
+	__clear_bit(NULLB_PAGE_LOCK, c_page->bitmap);
+	if (test_bit(NULLB_PAGE_FREE, c_page->bitmap)) {
+		null_free_page(c_page);
+		if (t_page && null_page_empty(t_page)) {
+			ret = radix_tree_delete_item(&nullb->dev->data,
+				idx, t_page);
+			null_free_page(t_page);
+		}
+		return 0;
+	}
+
+	if (!t_page)
+		return -ENOMEM;
+
+	src = kmap_atomic(c_page->page);
+	dst = kmap_atomic(t_page->page);
+
+	for (i = 0; i < PAGE_SECTORS;
+			i += (nullb->dev->blocksize >> SECTOR_SHIFT)) {
+		if (test_bit(i, c_page->bitmap)) {
+			offset = (i << SECTOR_SHIFT);
+			memcpy(dst + offset, src + offset,
+				nullb->dev->blocksize);
+			__set_bit(i, t_page->bitmap);
+		}
+	}
+
+	kunmap_atomic(dst);
+	kunmap_atomic(src);
+
+	ret = radix_tree_delete_item(&nullb->dev->cache, idx, c_page);
+	null_free_page(ret);
+	nullb->dev->curr_cache -= PAGE_SIZE;
+
+	return 0;
+}
+
+static int null_make_cache_space(struct nullb *nullb, unsigned long n)
+{
+	int i, err, nr_pages;
+	struct nullb_page *c_pages[FREE_BATCH];
+	unsigned long flushed = 0, one_round;
+
+again:
+	if ((nullb->dev->cache_size * 1024 * 1024) >
+	     nullb->dev->curr_cache + n || nullb->dev->curr_cache == 0)
+		return 0;
+
+	nr_pages = radix_tree_gang_lookup(&nullb->dev->cache,
+			(void **)c_pages, nullb->cache_flush_pos, FREE_BATCH);
+	/*
+	 * nullb_flush_cache_page could unlock before using the c_pages. To
+	 * avoid race, we don't allow page free
+	 */
+	for (i = 0; i < nr_pages; i++) {
+		nullb->cache_flush_pos = c_pages[i]->page->index;
+		/*
+		 * We found the page which is being flushed to disk by other
+		 * threads
+		 */
+		if (test_bit(NULLB_PAGE_LOCK, c_pages[i]->bitmap))
+			c_pages[i] = NULL;
+		else
+			__set_bit(NULLB_PAGE_LOCK, c_pages[i]->bitmap);
+	}
+
+	one_round = 0;
+	for (i = 0; i < nr_pages; i++) {
+		if (c_pages[i] == NULL)
+			continue;
+		err = null_flush_cache_page(nullb, c_pages[i]);
+		if (err)
+			return err;
+		one_round++;
+	}
+	flushed += one_round << PAGE_SHIFT;
+
+	if (n > flushed) {
+		if (nr_pages == 0)
+			nullb->cache_flush_pos = 0;
+		if (one_round == 0) {
+			/* give other threads a chance */
+			spin_unlock_irq(&nullb->lock);
+			spin_lock_irq(&nullb->lock);
+		}
+		goto again;
+	}
+	return 0;
+}
+
+static int copy_to_nullb(struct nullb *nullb, struct page *source,
+	unsigned int off, sector_t sector, size_t n, bool is_fua)
+{
+	size_t temp, count = 0;
+	unsigned int offset;
+	struct nullb_page *t_page;
+	void *dst, *src;
+
+	while (count < n) {
+		temp = min_t(size_t, nullb->dev->blocksize, n - count);
+
+		if (null_cache_active(nullb) && !is_fua)
+			null_make_cache_space(nullb, PAGE_SIZE);
+
+		offset = (sector & SECTOR_MASK) << SECTOR_SHIFT;
+		t_page = null_insert_page(nullb, sector,
+			!null_cache_active(nullb) || is_fua);
+		if (!t_page)
+			return -ENOSPC;
+
+		src = kmap_atomic(source);
+		dst = kmap_atomic(t_page->page);
+		memcpy(dst + offset, src + off + count, temp);
+		kunmap_atomic(dst);
+		kunmap_atomic(src);
+
+		__set_bit(sector & SECTOR_MASK, t_page->bitmap);
+
+		if (is_fua)
+			null_free_sector(nullb, sector, true);
+
+		count += temp;
+		sector += temp >> SECTOR_SHIFT;
+	}
+	return 0;
+}
+
+static int copy_from_nullb(struct nullb *nullb, struct page *dest,
+	unsigned int off, sector_t sector, size_t n)
+{
+	size_t temp, count = 0;
+	unsigned int offset;
+	struct nullb_page *t_page;
+	void *dst, *src;
+
+	while (count < n) {
+		temp = min_t(size_t, nullb->dev->blocksize, n - count);
+
+		offset = (sector & SECTOR_MASK) << SECTOR_SHIFT;
+		t_page = null_lookup_page(nullb, sector, false,
+			!null_cache_active(nullb));
+
+		dst = kmap_atomic(dest);
+		if (!t_page) {
+			memset(dst + off + count, 0, temp);
+			goto next;
+		}
+		src = kmap_atomic(t_page->page);
+		memcpy(dst + off + count, src + offset, temp);
+		kunmap_atomic(src);
+next:
+		kunmap_atomic(dst);
+
+		count += temp;
+		sector += temp >> SECTOR_SHIFT;
+	}
+	return 0;
+}
+
+static void nullb_fill_pattern(struct nullb *nullb, struct page *page,
+			       unsigned int len, unsigned int off)
+{
+	void *dst;
+
+	dst = kmap_atomic(page);
+	memset(dst + off, 0xFF, len);
+	kunmap_atomic(dst);
+}
+
+static void null_handle_discard(struct nullb *nullb, sector_t sector, size_t n)
+{
+	size_t temp;
+
+	spin_lock_irq(&nullb->lock);
+	while (n > 0) {
+		temp = min_t(size_t, n, nullb->dev->blocksize);
+		null_free_sector(nullb, sector, false);
+		if (null_cache_active(nullb))
+			null_free_sector(nullb, sector, true);
+		sector += temp >> SECTOR_SHIFT;
+		n -= temp;
+	}
+	spin_unlock_irq(&nullb->lock);
+}
+
+static int null_handle_flush(struct nullb *nullb)
+{
+	int err;
+
+	if (!null_cache_active(nullb))
+		return 0;
+
+	spin_lock_irq(&nullb->lock);
+	while (true) {
+		err = null_make_cache_space(nullb,
+			nullb->dev->cache_size * 1024 * 1024);
+		if (err || nullb->dev->curr_cache == 0)
+			break;
+	}
+
+	WARN_ON(!radix_tree_empty(&nullb->dev->cache));
+	spin_unlock_irq(&nullb->lock);
+	return err;
+}
+
+static int null_transfer(struct nullb *nullb, struct page *page,
+	unsigned int len, unsigned int off, bool is_write, sector_t sector,
+	bool is_fua)
+{
+	struct nullb_device *dev = nullb->dev;
+	unsigned int valid_len = len;
+	int err = 0;
+
+	if (!is_write) {
+		if (dev->zoned)
+			valid_len = null_zone_valid_read_len(nullb,
+				sector, len);
+
+		if (valid_len) {
+			err = copy_from_nullb(nullb, page, off,
+				sector, valid_len);
+			off += valid_len;
+			len -= valid_len;
+		}
+
+		if (len)
+			nullb_fill_pattern(nullb, page, len, off);
+		flush_dcache_page(page);
+	} else {
+		flush_dcache_page(page);
+		err = copy_to_nullb(nullb, page, off, sector, len, is_fua);
+	}
+
+	return err;
+}
+
+static int null_handle_rq(struct nullb_cmd *cmd)
+{
+	struct request *rq = cmd->rq;
+	struct nullb *nullb = cmd->nq->dev->nullb;
+	int err;
+	unsigned int len;
+	sector_t sector;
+	struct req_iterator iter;
+	struct bio_vec bvec;
+
+	sector = blk_rq_pos(rq);
+
+	if (req_op(rq) == REQ_OP_DISCARD) {
+		null_handle_discard(nullb, sector, blk_rq_bytes(rq));
+		return 0;
+	}
+
+	spin_lock_irq(&nullb->lock);
+	rq_for_each_segment(bvec, rq, iter) {
+		len = bvec.bv_len;
+		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
+				     op_is_write(req_op(rq)), sector,
+				     rq->cmd_flags & REQ_FUA);
+		if (err) {
+			spin_unlock_irq(&nullb->lock);
+			return err;
+		}
+		sector += len >> SECTOR_SHIFT;
+	}
+	spin_unlock_irq(&nullb->lock);
+
+	return 0;
+}
+
+static int null_handle_bio(struct nullb_cmd *cmd)
+{
+	struct bio *bio = cmd->bio;
+	struct nullb *nullb = cmd->nq->dev->nullb;
+	int err;
+	unsigned int len;
+	sector_t sector;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
+
+	sector = bio->bi_iter.bi_sector;
+
+	if (bio_op(bio) == REQ_OP_DISCARD) {
+		null_handle_discard(nullb, sector,
+			bio_sectors(bio) << SECTOR_SHIFT);
+		return 0;
+	}
+
+	spin_lock_irq(&nullb->lock);
+	bio_for_each_segment(bvec, bio, iter) {
+		len = bvec.bv_len;
+		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
+				     op_is_write(bio_op(bio)), sector,
+				     bio->bi_opf & REQ_FUA);
+		if (err) {
+			spin_unlock_irq(&nullb->lock);
+			return err;
+		}
+		sector += len >> SECTOR_SHIFT;
+	}
+	spin_unlock_irq(&nullb->lock);
+	return 0;
+}
+
+static void null_stop_queue(struct nullb *nullb)
+{
+	struct request_queue *q = nullb->q;
+
+	if (nullb->dev->queue_mode == NULL_Q_MQ)
+		blk_mq_stop_hw_queues(q);
+}
+
+static void null_restart_queue_async(struct nullb *nullb)
+{
+	struct request_queue *q = nullb->q;
+
+	if (nullb->dev->queue_mode == NULL_Q_MQ)
+		blk_mq_start_stopped_hw_queues(q, true);
+}
+
+static inline blk_status_t null_handle_throttled(struct nullb_cmd *cmd)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	struct nullb *nullb = dev->nullb;
+	blk_status_t sts = BLK_STS_OK;
+	struct request *rq = cmd->rq;
+
+	if (!hrtimer_active(&nullb->bw_timer))
+		hrtimer_restart(&nullb->bw_timer);
+
+	if (atomic_long_sub_return(blk_rq_bytes(rq), &nullb->cur_bytes) < 0) {
+		null_stop_queue(nullb);
+		/* race with timer */
+		if (atomic_long_read(&nullb->cur_bytes) > 0)
+			null_restart_queue_async(nullb);
+		/* requeue request */
+		sts = BLK_STS_DEV_RESOURCE;
+	}
+	return sts;
+}
+
+static inline blk_status_t null_handle_badblocks(struct nullb_cmd *cmd,
+						 sector_t sector,
+						 sector_t nr_sectors)
+{
+	struct badblocks *bb = &cmd->nq->dev->badblocks;
+	sector_t first_bad;
+	int bad_sectors;
+
+	if (badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
+		return BLK_STS_IOERR;
+
+	return BLK_STS_OK;
+}
+
+static inline blk_status_t null_handle_memory_backed(struct nullb_cmd *cmd,
+						     enum req_opf op)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	int err;
+
+	if (dev->queue_mode == NULL_Q_BIO)
+		err = null_handle_bio(cmd);
+	else
+		err = null_handle_rq(cmd);
+
+	return errno_to_blk_status(err);
+}
+
+static void nullb_zero_read_cmd_buffer(struct nullb_cmd *cmd)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	struct bio *bio;
+
+	if (dev->memory_backed)
+		return;
+
+	if (dev->queue_mode == NULL_Q_BIO && bio_op(cmd->bio) == REQ_OP_READ) {
+		zero_fill_bio(cmd->bio);
+	} else if (req_op(cmd->rq) == REQ_OP_READ) {
+		__rq_for_each_bio(bio, cmd->rq)
+			zero_fill_bio(bio);
+	}
+}
+
+static inline void nullb_complete_cmd(struct nullb_cmd *cmd)
+{
+	/*
+	 * Since root privileges are required to configure the null_blk
+	 * driver, it is fine that this driver does not initialize the
+	 * data buffers of read commands. Zero-initialize these buffers
+	 * anyway if KMSAN is enabled to prevent that KMSAN complains
+	 * about null_blk not initializing read data buffers.
+	 */
+	if (IS_ENABLED(CONFIG_KMSAN))
+		nullb_zero_read_cmd_buffer(cmd);
+
+	/* Complete IO by inline, softirq or timer */
+	switch (cmd->nq->dev->irqmode) {
+	case NULL_IRQ_SOFTIRQ:
+		switch (cmd->nq->dev->queue_mode) {
+		case NULL_Q_MQ:
+			blk_mq_complete_request(cmd->rq);
+			break;
+		case NULL_Q_BIO:
+			/*
+			 * XXX: no proper submitting cpu information available.
+			 */
+			end_cmd(cmd);
+			break;
+		}
+		break;
+	case NULL_IRQ_NONE:
+		end_cmd(cmd);
+		break;
+	case NULL_IRQ_TIMER:
+		null_cmd_end_timer(cmd);
+		break;
+	}
+}
+
+blk_status_t null_process_cmd(struct nullb_cmd *cmd,
+			      enum req_opf op, sector_t sector,
+			      unsigned int nr_sectors)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	blk_status_t ret;
+
+	if (dev->badblocks.shift != -1) {
+		ret = null_handle_badblocks(cmd, sector, nr_sectors);
+		if (ret != BLK_STS_OK)
+			return ret;
+	}
+
+	if (dev->memory_backed)
+		return null_handle_memory_backed(cmd, op);
+
+	return BLK_STS_OK;
+}
+
+static blk_status_t null_handle_cmd(struct nullb_cmd *cmd, sector_t sector,
+				    sector_t nr_sectors, enum req_opf op)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	struct nullb *nullb = dev->nullb;
+	blk_status_t sts;
+
+	if (test_bit(NULLB_DEV_FL_THROTTLED, &dev->flags)) {
+		sts = null_handle_throttled(cmd);
+		if (sts != BLK_STS_OK)
+			return sts;
+	}
+
+	if (op == REQ_OP_FLUSH) {
+		cmd->error = errno_to_blk_status(null_handle_flush(nullb));
+		goto out;
+	}
+
+	if (dev->zoned)
+		sts = null_process_zoned_cmd(cmd, op, sector, nr_sectors);
+	else
+		sts = null_process_cmd(cmd, op, sector, nr_sectors);
+
+	/* Do not overwrite errors (e.g. timeout errors) */
+	if (cmd->error == BLK_STS_OK)
+		cmd->error = sts;
+
+out:
+	nullb_complete_cmd(cmd);
+	return BLK_STS_OK;
+}
+
+static enum hrtimer_restart nullb_bwtimer_fn(struct hrtimer *timer)
+{
+	struct nullb *nullb = container_of(timer, struct nullb, bw_timer);
+	ktime_t timer_interval = ktime_set(0, TIMER_INTERVAL);
+	unsigned int mbps = nullb->dev->mbps;
+
+	if (atomic_long_read(&nullb->cur_bytes) == mb_per_tick(mbps))
+		return HRTIMER_NORESTART;
+
+	atomic_long_set(&nullb->cur_bytes, mb_per_tick(mbps));
+	null_restart_queue_async(nullb);
+
+	hrtimer_forward_now(&nullb->bw_timer, timer_interval);
+
+	return HRTIMER_RESTART;
+}
+
+static void nullb_setup_bwtimer(struct nullb *nullb)
+{
+	ktime_t timer_interval = ktime_set(0, TIMER_INTERVAL);
+
+	hrtimer_init(&nullb->bw_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	nullb->bw_timer.function = nullb_bwtimer_fn;
+	atomic_long_set(&nullb->cur_bytes, mb_per_tick(nullb->dev->mbps));
+	hrtimer_start(&nullb->bw_timer, timer_interval, HRTIMER_MODE_REL);
+}
+
+static struct nullb_queue *nullb_to_queue(struct nullb *nullb)
+{
+	int index = 0;
+
+	if (nullb->nr_queues != 1)
+		index = raw_smp_processor_id() / ((nr_cpu_ids + nullb->nr_queues - 1) / nullb->nr_queues);
+
+	return &nullb->queues[index];
+}
+
+static blk_qc_t null_submit_bio(struct bio *bio)
+{
+	sector_t sector = bio->bi_iter.bi_sector;
+	sector_t nr_sectors = bio_sectors(bio);
+	struct nullb *nullb = bio->bi_disk->private_data;
+	struct nullb_queue *nq = nullb_to_queue(nullb);
+	struct nullb_cmd *cmd;
+
+	cmd = alloc_cmd(nq, 1);
+	cmd->bio = bio;
+
+	null_handle_cmd(cmd, sector, nr_sectors, bio_op(bio));
+	return BLK_QC_T_NONE;
+}
+
+static bool should_timeout_request(struct request *rq)
+{
+#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
+	if (g_timeout_str[0])
+		return should_fail(&null_timeout_attr, 1);
+#endif
+	return false;
+}
+
+static bool should_requeue_request(struct request *rq)
+{
+#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
+	if (g_requeue_str[0])
+		return should_fail(&null_requeue_attr, 1);
+#endif
+	return false;
+}
+
+static enum blk_eh_timer_return null_timeout_rq(struct request *rq, bool res)
+{
+	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
+
+	pr_info("rq %p timed out\n", rq);
+
+	/*
+	 * If the device is marked as blocking (i.e. memory backed or zoned
+	 * device), the submission path may be blocked waiting for resources
+	 * and cause real timeouts. For these real timeouts, the submission
+	 * path will complete the request using blk_mq_complete_request().
+	 * Only fake timeouts need to execute blk_mq_complete_request() here.
+	 */
+	cmd->error = BLK_STS_TIMEOUT;
+	if (cmd->fake_timeout)
+		blk_mq_complete_request(rq);
+	return BLK_EH_DONE;
+}
+
+static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
+			 const struct blk_mq_queue_data *bd)
+{
+	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
+	struct nullb_queue *nq = hctx->driver_data;
+	sector_t nr_sectors = blk_rq_sectors(bd->rq);
+	sector_t sector = blk_rq_pos(bd->rq);
+
+	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
+
+	if (nq->dev->irqmode == NULL_IRQ_TIMER) {
+		hrtimer_init(&cmd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+		cmd->timer.function = null_cmd_timer_expired;
+	}
+	cmd->rq = bd->rq;
+	cmd->error = BLK_STS_OK;
+	cmd->nq = nq;
+	cmd->fake_timeout = should_timeout_request(bd->rq) ||
+		blk_should_fake_timeout(bd->rq->q);
+
+	blk_mq_start_request(bd->rq);
+
+	if (should_requeue_request(bd->rq)) {
+		/*
+		 * Alternate between hitting the core BUSY path, and the
+		 * driver driven requeue path
+		 */
+		nq->requeue_selection++;
+		if (nq->requeue_selection & 1)
+			return BLK_STS_RESOURCE;
+		else {
+			blk_mq_requeue_request(bd->rq, true);
+			return BLK_STS_OK;
+		}
+	}
+	if (cmd->fake_timeout)
+		return BLK_STS_OK;
+
+	return null_handle_cmd(cmd, sector, nr_sectors, req_op(bd->rq));
+}
+
+static void cleanup_queue(struct nullb_queue *nq)
+{
+	kfree(nq->tag_map);
+	kfree(nq->cmds);
+}
+
+static void cleanup_queues(struct nullb *nullb)
+{
+	int i;
+
+	for (i = 0; i < nullb->nr_queues; i++)
+		cleanup_queue(&nullb->queues[i]);
+
+	kfree(nullb->queues);
+}
+
+static void null_exit_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
+{
+	struct nullb_queue *nq = hctx->driver_data;
+	struct nullb *nullb = nq->dev->nullb;
+
+	nullb->nr_queues--;
+}
+
+static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
+{
+	init_waitqueue_head(&nq->wait);
+	nq->queue_depth = nullb->queue_depth;
+	nq->dev = nullb->dev;
+}
+
+static int null_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
+			  unsigned int hctx_idx)
+{
+	struct nullb *nullb = hctx->queue->queuedata;
+	struct nullb_queue *nq;
+
+#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
+	if (g_init_hctx_str[0] && should_fail(&null_init_hctx_attr, 1))
+		return -EFAULT;
+#endif
+
+	nq = &nullb->queues[hctx_idx];
+	hctx->driver_data = nq;
+	null_init_queue(nullb, nq);
+	nullb->nr_queues++;
+
+	return 0;
+}
+
+static const struct blk_mq_ops null_mq_ops = {
+	.queue_rq       = null_queue_rq,
+	.complete	= null_complete_rq,
+	.timeout	= null_timeout_rq,
+	.init_hctx	= null_init_hctx,
+	.exit_hctx	= null_exit_hctx,
+};
+
+static void null_del_dev(struct nullb *nullb)
+{
+	struct nullb_device *dev;
+
+	if (!nullb)
+		return;
+
+	dev = nullb->dev;
+
+	ida_simple_remove(&nullb_indexes, nullb->index);
+
+	list_del_init(&nullb->list);
+
+	del_gendisk(nullb->disk);
+
+	if (test_bit(NULLB_DEV_FL_THROTTLED, &nullb->dev->flags)) {
+		hrtimer_cancel(&nullb->bw_timer);
+		atomic_long_set(&nullb->cur_bytes, LONG_MAX);
+		null_restart_queue_async(nullb);
+	}
+
+	blk_cleanup_queue(nullb->q);
+	if (dev->queue_mode == NULL_Q_MQ &&
+	    nullb->tag_set == &nullb->__tag_set)
+		blk_mq_free_tag_set(nullb->tag_set);
+	put_disk(nullb->disk);
+	cleanup_queues(nullb);
+	if (null_cache_active(nullb))
+		null_free_device_storage(nullb->dev, true);
+	kfree(nullb);
+	dev->nullb = NULL;
+}
+
+static void null_config_discard(struct nullb *nullb)
+{
+	if (nullb->dev->discard == false)
+		return;
+
+	if (nullb->dev->zoned) {
+		nullb->dev->discard = false;
+		pr_info("discard option is ignored in zoned mode\n");
+		return;
+	}
+
+	nullb->q->limits.discard_granularity = nullb->dev->blocksize;
+	nullb->q->limits.discard_alignment = nullb->dev->blocksize;
+	blk_queue_max_discard_sectors(nullb->q, UINT_MAX >> 9);
+	blk_queue_flag_set(QUEUE_FLAG_DISCARD, nullb->q);
+}
+
+static const struct block_device_operations null_bio_ops = {
+	.owner		= THIS_MODULE,
+	.submit_bio	= null_submit_bio,
+	.report_zones	= null_report_zones,
+};
+
+static const struct block_device_operations null_rq_ops = {
+	.owner		= THIS_MODULE,
+	.report_zones	= null_report_zones,
+};
+
+static int setup_commands(struct nullb_queue *nq)
+{
+	struct nullb_cmd *cmd;
+	int i, tag_size;
+
+	nq->cmds = kcalloc(nq->queue_depth, sizeof(*cmd), GFP_KERNEL);
+	if (!nq->cmds)
+		return -ENOMEM;
+
+	tag_size = ALIGN(nq->queue_depth, BITS_PER_LONG) / BITS_PER_LONG;
+	nq->tag_map = kcalloc(tag_size, sizeof(unsigned long), GFP_KERNEL);
+	if (!nq->tag_map) {
+		kfree(nq->cmds);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nq->queue_depth; i++) {
+		cmd = &nq->cmds[i];
+		cmd->tag = -1U;
+	}
+
+	return 0;
+}
+
+static int setup_queues(struct nullb *nullb)
+{
+	nullb->queues = kcalloc(nr_cpu_ids, sizeof(struct nullb_queue),
+				GFP_KERNEL);
+	if (!nullb->queues)
+		return -ENOMEM;
+
+	nullb->queue_depth = nullb->dev->hw_queue_depth;
+
+	return 0;
+}
+
+static int init_driver_queues(struct nullb *nullb)
+{
+	struct nullb_queue *nq;
+	int i, ret = 0;
+
+	for (i = 0; i < nullb->dev->submit_queues; i++) {
+		nq = &nullb->queues[i];
+
+		null_init_queue(nullb, nq);
+
+		ret = setup_commands(nq);
+		if (ret)
+			return ret;
+		nullb->nr_queues++;
+	}
+	return 0;
+}
+
+static int null_gendisk_register(struct nullb *nullb)
+{
+	sector_t size = ((sector_t)nullb->dev->size * SZ_1M) >> SECTOR_SHIFT;
+	struct gendisk *disk;
+
+	disk = nullb->disk = alloc_disk_node(1, nullb->dev->home_node);
+	if (!disk)
+		return -ENOMEM;
+	set_capacity(disk, size);
+
+	disk->flags |= GENHD_FL_EXT_DEVT | GENHD_FL_SUPPRESS_PARTITION_INFO;
+	disk->major		= null_major;
+	disk->first_minor	= nullb->index;
+	if (queue_is_mq(nullb->q))
+		disk->fops		= &null_rq_ops;
+	else
+		disk->fops		= &null_bio_ops;
+	disk->private_data	= nullb;
+	disk->queue		= nullb->q;
+	strncpy(disk->disk_name, nullb->disk_name, DISK_NAME_LEN);
+
+	if (nullb->dev->zoned) {
+		int ret = null_register_zoned_dev(nullb);
+
+		if (ret)
+			return ret;
+	}
+
+	add_disk(disk);
+	return 0;
+}
+
+static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
+{
+	set->ops = &null_mq_ops;
+	set->nr_hw_queues = nullb ? nullb->dev->submit_queues :
+						g_submit_queues;
+	set->queue_depth = nullb ? nullb->dev->hw_queue_depth :
+						g_hw_queue_depth;
+	set->numa_node = nullb ? nullb->dev->home_node : g_home_node;
+	set->cmd_size	= sizeof(struct nullb_cmd);
+	set->flags = BLK_MQ_F_SHOULD_MERGE;
+	if (g_no_sched)
+		set->flags |= BLK_MQ_F_NO_SCHED;
+	if (g_shared_tag_bitmap)
+		set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
+	set->driver_data = NULL;
+
+	if ((nullb && nullb->dev->blocking) || g_blocking)
+		set->flags |= BLK_MQ_F_BLOCKING;
+
+	return blk_mq_alloc_tag_set(set);
+}
+
+static int null_validate_conf(struct nullb_device *dev)
+{
+	dev->blocksize = round_down(dev->blocksize, 512);
+	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
+
+	if (dev->queue_mode == NULL_Q_MQ && dev->use_per_node_hctx) {
+		if (dev->submit_queues != nr_online_nodes)
+			dev->submit_queues = nr_online_nodes;
+	} else if (dev->submit_queues > nr_cpu_ids)
+		dev->submit_queues = nr_cpu_ids;
+	else if (dev->submit_queues == 0)
+		dev->submit_queues = 1;
+
+	dev->queue_mode = min_t(unsigned int, dev->queue_mode, NULL_Q_MQ);
+	dev->irqmode = min_t(unsigned int, dev->irqmode, NULL_IRQ_TIMER);
+
+	/* Do memory allocation, so set blocking */
+	if (dev->memory_backed)
+		dev->blocking = true;
+	else /* cache is meaningless */
+		dev->cache_size = 0;
+	dev->cache_size = min_t(unsigned long, ULONG_MAX / 1024 / 1024,
+						dev->cache_size);
+	dev->mbps = min_t(unsigned int, 1024 * 40, dev->mbps);
+	/* can not stop a queue */
+	if (dev->queue_mode == NULL_Q_BIO)
+		dev->mbps = 0;
+
+	if (dev->zoned &&
+	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
+		pr_err("zone_size must be power-of-two\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
+static bool __null_setup_fault(struct fault_attr *attr, char *str)
+{
+	if (!str[0])
+		return true;
+
+	if (!setup_fault_attr(attr, str))
+		return false;
+
+	attr->verbose = 0;
+	return true;
+}
+#endif
+
+static bool null_setup_fault(void)
+{
+#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
+	if (!__null_setup_fault(&null_timeout_attr, g_timeout_str))
+		return false;
+	if (!__null_setup_fault(&null_requeue_attr, g_requeue_str))
+		return false;
+	if (!__null_setup_fault(&null_init_hctx_attr, g_init_hctx_str))
+		return false;
+#endif
+	return true;
+}
+
+static int null_add_dev(struct nullb_device *dev)
+{
+	struct nullb *nullb;
+	int rv;
+
+	rv = null_validate_conf(dev);
+	if (rv)
+		return rv;
+
+	nullb = kzalloc_node(sizeof(*nullb), GFP_KERNEL, dev->home_node);
+	if (!nullb) {
+		rv = -ENOMEM;
+		goto out;
+	}
+	nullb->dev = dev;
+	dev->nullb = nullb;
+
+	spin_lock_init(&nullb->lock);
+
+	rv = setup_queues(nullb);
+	if (rv)
+		goto out_free_nullb;
+
+	if (dev->queue_mode == NULL_Q_MQ) {
+		if (shared_tags) {
+			nullb->tag_set = &tag_set;
+			rv = 0;
+		} else {
+			nullb->tag_set = &nullb->__tag_set;
+			rv = null_init_tag_set(nullb, nullb->tag_set);
+		}
+
+		if (rv)
+			goto out_cleanup_queues;
+
+		if (!null_setup_fault())
+			goto out_cleanup_queues;
+
+		nullb->tag_set->timeout = 5 * HZ;
+		nullb->q = blk_mq_init_queue_data(nullb->tag_set, nullb);
+		if (IS_ERR(nullb->q)) {
+			rv = -ENOMEM;
+			goto out_cleanup_tags;
+		}
+	} else if (dev->queue_mode == NULL_Q_BIO) {
+		nullb->q = blk_alloc_queue(dev->home_node);
+		if (!nullb->q) {
+			rv = -ENOMEM;
+			goto out_cleanup_queues;
+		}
+		rv = init_driver_queues(nullb);
+		if (rv)
+			goto out_cleanup_blk_queue;
+	}
+
+	if (dev->mbps) {
+		set_bit(NULLB_DEV_FL_THROTTLED, &dev->flags);
+		nullb_setup_bwtimer(nullb);
+	}
+
+	if (dev->cache_size > 0) {
+		set_bit(NULLB_DEV_FL_CACHE, &nullb->dev->flags);
+		blk_queue_write_cache(nullb->q, true, true);
+	}
+
+	if (dev->zoned) {
+		rv = null_init_zoned_dev(dev, nullb->q);
+		if (rv)
+			goto out_cleanup_blk_queue;
+	}
+
+	nullb->q->queuedata = nullb;
+	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
+	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
+
+	mutex_lock(&lock);
+	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
+	if (rv < 0) {
+		mutex_unlock(&lock);
+		goto out_cleanup_zone;
+	}
+	nullb->index = rv;
+	dev->index = rv;
+	mutex_unlock(&lock);
+
+	blk_queue_logical_block_size(nullb->q, dev->blocksize);
+	blk_queue_physical_block_size(nullb->q, dev->blocksize);
+
+	null_config_discard(nullb);
+
+	sprintf(nullb->disk_name, "nullb%d", nullb->index);
+
+	rv = null_gendisk_register(nullb);
+	if (rv)
+		goto out_ida_free;
+
+	mutex_lock(&lock);
+	list_add_tail(&nullb->list, &nullb_list);
+	mutex_unlock(&lock);
+
+	return 0;
+
+out_ida_free:
+	ida_free(&nullb_indexes, nullb->index);
+out_cleanup_zone:
+	null_free_zoned_dev(dev);
+out_cleanup_blk_queue:
+	blk_cleanup_queue(nullb->q);
+out_cleanup_tags:
+	if (dev->queue_mode == NULL_Q_MQ && nullb->tag_set == &nullb->__tag_set)
+		blk_mq_free_tag_set(nullb->tag_set);
+out_cleanup_queues:
+	cleanup_queues(nullb);
+out_free_nullb:
+	kfree(nullb);
+	dev->nullb = NULL;
+out:
+	return rv;
+}
+
+static int __init null_init(void)
+{
+	int ret = 0;
+	unsigned int i;
+	struct nullb *nullb;
+	struct nullb_device *dev;
+
+	if (g_bs > PAGE_SIZE) {
+		pr_warn("invalid block size\n");
+		pr_warn("defaults block size to %lu\n", PAGE_SIZE);
+		g_bs = PAGE_SIZE;
+	}
+
+	if (g_home_node != NUMA_NO_NODE && g_home_node >= nr_online_nodes) {
+		pr_err("invalid home_node value\n");
+		g_home_node = NUMA_NO_NODE;
+	}
+
+	if (g_queue_mode == NULL_Q_RQ) {
+		pr_err("legacy IO path no longer available\n");
+		return -EINVAL;
+	}
+	if (g_queue_mode == NULL_Q_MQ && g_use_per_node_hctx) {
+		if (g_submit_queues != nr_online_nodes) {
+			pr_warn("submit_queues param is set to %u.\n",
+							nr_online_nodes);
+			g_submit_queues = nr_online_nodes;
+		}
+	} else if (g_submit_queues > nr_cpu_ids)
+		g_submit_queues = nr_cpu_ids;
+	else if (g_submit_queues <= 0)
+		g_submit_queues = 1;
+
+	if (g_queue_mode == NULL_Q_MQ && shared_tags) {
+		ret = null_init_tag_set(NULL, &tag_set);
+		if (ret)
+			return ret;
+	}
+
+	config_group_init(&nullb_subsys.su_group);
+	mutex_init(&nullb_subsys.su_mutex);
+
+	ret = configfs_register_subsystem(&nullb_subsys);
+	if (ret)
+		goto err_tagset;
+
+	mutex_init(&lock);
+
+	null_major = register_blkdev(0, "nullb");
+	if (null_major < 0) {
+		ret = null_major;
+		goto err_conf;
+	}
+
+	for (i = 0; i < nr_devices; i++) {
+		dev = null_alloc_dev();
+		if (!dev) {
+			ret = -ENOMEM;
+			goto err_dev;
+		}
+		ret = null_add_dev(dev);
+		if (ret) {
+			null_free_dev(dev);
+			goto err_dev;
+		}
+	}
+
+	pr_info("module loaded\n");
+	return 0;
+
+err_dev:
+	while (!list_empty(&nullb_list)) {
+		nullb = list_entry(nullb_list.next, struct nullb, list);
+		dev = nullb->dev;
+		null_del_dev(nullb);
+		null_free_dev(dev);
+	}
+	unregister_blkdev(null_major, "nullb");
+err_conf:
+	configfs_unregister_subsystem(&nullb_subsys);
+err_tagset:
+	if (g_queue_mode == NULL_Q_MQ && shared_tags)
+		blk_mq_free_tag_set(&tag_set);
+	return ret;
+}
+
+static void __exit null_exit(void)
+{
+	struct nullb *nullb;
+
+	configfs_unregister_subsystem(&nullb_subsys);
+
+	unregister_blkdev(null_major, "nullb");
+
+	mutex_lock(&lock);
+	while (!list_empty(&nullb_list)) {
+		struct nullb_device *dev;
+
+		nullb = list_entry(nullb_list.next, struct nullb, list);
+		dev = nullb->dev;
+		null_del_dev(nullb);
+		null_free_dev(dev);
+	}
+	mutex_unlock(&lock);
+
+	if (g_queue_mode == NULL_Q_MQ && shared_tags)
+		blk_mq_free_tag_set(&tag_set);
+}
+
+module_init(null_init);
+module_exit(null_exit);
+
+MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
new file mode 100644
index 000000000000..7de703f28617
--- /dev/null
+++ b/drivers/block/null_blk/null_blk.h
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __BLK_NULL_BLK_H
+#define __BLK_NULL_BLK_H
+
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/blkdev.h>
+#include <linux/slab.h>
+#include <linux/blk-mq.h>
+#include <linux/hrtimer.h>
+#include <linux/configfs.h>
+#include <linux/badblocks.h>
+#include <linux/fault-inject.h>
+
+struct nullb_cmd {
+	struct request *rq;
+	struct bio *bio;
+	unsigned int tag;
+	blk_status_t error;
+	struct nullb_queue *nq;
+	struct hrtimer timer;
+	bool fake_timeout;
+};
+
+struct nullb_queue {
+	unsigned long *tag_map;
+	wait_queue_head_t wait;
+	unsigned int queue_depth;
+	struct nullb_device *dev;
+	unsigned int requeue_selection;
+
+	struct nullb_cmd *cmds;
+};
+
+struct nullb_device {
+	struct nullb *nullb;
+	struct config_item item;
+	struct radix_tree_root data; /* data stored in the disk */
+	struct radix_tree_root cache; /* disk cache data */
+	unsigned long flags; /* device flags */
+	unsigned int curr_cache;
+	struct badblocks badblocks;
+
+	unsigned int nr_zones;
+	unsigned int nr_zones_imp_open;
+	unsigned int nr_zones_exp_open;
+	unsigned int nr_zones_closed;
+	struct blk_zone *zones;
+	sector_t zone_size_sects;
+	spinlock_t zone_lock;
+	unsigned long *zone_locks;
+
+	unsigned long size; /* device size in MB */
+	unsigned long completion_nsec; /* time in ns to complete a request */
+	unsigned long cache_size; /* disk cache size in MB */
+	unsigned long zone_size; /* zone size in MB if device is zoned */
+	unsigned long zone_capacity; /* zone capacity in MB if device is zoned */
+	unsigned int zone_nr_conv; /* number of conventional zones */
+	unsigned int zone_max_open; /* max number of open zones */
+	unsigned int zone_max_active; /* max number of active zones */
+	unsigned int submit_queues; /* number of submission queues */
+	unsigned int home_node; /* home node for the device */
+	unsigned int queue_mode; /* block interface */
+	unsigned int blocksize; /* block size */
+	unsigned int irqmode; /* IRQ completion handler */
+	unsigned int hw_queue_depth; /* queue depth */
+	unsigned int index; /* index of the disk, only valid with a disk */
+	unsigned int mbps; /* Bandwidth throttle cap (in MB/s) */
+	bool blocking; /* blocking blk-mq device */
+	bool use_per_node_hctx; /* use per-node allocation for hardware context */
+	bool power; /* power on/off the device */
+	bool memory_backed; /* if data is stored in memory */
+	bool discard; /* if support discard */
+	bool zoned; /* if device is zoned */
+};
+
+struct nullb {
+	struct nullb_device *dev;
+	struct list_head list;
+	unsigned int index;
+	struct request_queue *q;
+	struct gendisk *disk;
+	struct blk_mq_tag_set *tag_set;
+	struct blk_mq_tag_set __tag_set;
+	unsigned int queue_depth;
+	atomic_long_t cur_bytes;
+	struct hrtimer bw_timer;
+	unsigned long cache_flush_pos;
+	spinlock_t lock;
+
+	struct nullb_queue *queues;
+	unsigned int nr_queues;
+	char disk_name[DISK_NAME_LEN];
+};
+
+blk_status_t null_process_cmd(struct nullb_cmd *cmd,
+			      enum req_opf op, sector_t sector,
+			      unsigned int nr_sectors);
+
+#ifdef CONFIG_BLK_DEV_ZONED
+int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q);
+int null_register_zoned_dev(struct nullb *nullb);
+void null_free_zoned_dev(struct nullb_device *dev);
+int null_report_zones(struct gendisk *disk, sector_t sector,
+		      unsigned int nr_zones, report_zones_cb cb, void *data);
+blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd,
+				    enum req_opf op, sector_t sector,
+				    sector_t nr_sectors);
+size_t null_zone_valid_read_len(struct nullb *nullb,
+				sector_t sector, unsigned int len);
+#else
+static inline int null_init_zoned_dev(struct nullb_device *dev,
+				      struct request_queue *q)
+{
+	pr_err("CONFIG_BLK_DEV_ZONED not enabled\n");
+	return -EINVAL;
+}
+static inline int null_register_zoned_dev(struct nullb *nullb)
+{
+	return -ENODEV;
+}
+static inline void null_free_zoned_dev(struct nullb_device *dev) {}
+static inline blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd,
+			enum req_opf op, sector_t sector, sector_t nr_sectors)
+{
+	return BLK_STS_NOTSUPP;
+}
+static inline size_t null_zone_valid_read_len(struct nullb *nullb,
+					      sector_t sector,
+					      unsigned int len)
+{
+	return len;
+}
+#define null_report_zones	NULL
+#endif /* CONFIG_BLK_DEV_ZONED */
+#endif /* __NULL_BLK_H */
diff --git a/drivers/block/null_blk/trace.c b/drivers/block/null_blk/trace.c
new file mode 100644
index 000000000000..3711cba16071
--- /dev/null
+++ b/drivers/block/null_blk/trace.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * null_blk trace related helpers.
+ *
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ */
+#include "trace.h"
+
+/*
+ * Helper to use for all null_blk traces to extract disk name.
+ */
+const char *nullb_trace_disk_name(struct trace_seq *p, char *name)
+{
+	const char *ret = trace_seq_buffer_ptr(p);
+
+	if (name && *name)
+		trace_seq_printf(p, "disk=%s, ", name);
+	trace_seq_putc(p, 0);
+
+	return ret;
+}
diff --git a/drivers/block/null_blk/trace.h b/drivers/block/null_blk/trace.h
new file mode 100644
index 000000000000..ce3b430e88c5
--- /dev/null
+++ b/drivers/block/null_blk/trace.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * null_blk device driver tracepoints.
+ *
+ * Copyright (C) 2020 Western Digital Corporation or its affiliates.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM nullb
+
+#if !defined(_TRACE_NULLB_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_NULLB_H
+
+#include <linux/tracepoint.h>
+#include <linux/trace_seq.h>
+
+#include "null_blk.h"
+
+const char *nullb_trace_disk_name(struct trace_seq *p, char *name);
+
+#define __print_disk_name(name) nullb_trace_disk_name(p, name)
+
+#ifndef TRACE_HEADER_MULTI_READ
+static inline void __assign_disk_name(char *name, struct gendisk *disk)
+{
+	if (disk)
+		memcpy(name, disk->disk_name, DISK_NAME_LEN);
+	else
+		memset(name, 0, DISK_NAME_LEN);
+}
+#endif
+
+TRACE_EVENT(nullb_zone_op,
+	    TP_PROTO(struct nullb_cmd *cmd, unsigned int zone_no,
+		     unsigned int zone_cond),
+	    TP_ARGS(cmd, zone_no, zone_cond),
+	    TP_STRUCT__entry(
+		__array(char, disk, DISK_NAME_LEN)
+		__field(enum req_opf, op)
+		__field(unsigned int, zone_no)
+		__field(unsigned int, zone_cond)
+	    ),
+	    TP_fast_assign(
+		__entry->op = req_op(cmd->rq);
+		__entry->zone_no = zone_no;
+		__entry->zone_cond = zone_cond;
+		__assign_disk_name(__entry->disk, cmd->rq->rq_disk);
+	    ),
+	    TP_printk("%s req=%-15s zone_no=%u zone_cond=%-10s",
+		      __print_disk_name(__entry->disk),
+		      blk_op_str(__entry->op),
+		      __entry->zone_no,
+		      blk_zone_cond_str(__entry->zone_cond))
+);
+
+TRACE_EVENT(nullb_report_zones,
+	    TP_PROTO(struct nullb *nullb, unsigned int nr_zones),
+	    TP_ARGS(nullb, nr_zones),
+	    TP_STRUCT__entry(
+		__array(char, disk, DISK_NAME_LEN)
+		__field(unsigned int, nr_zones)
+	    ),
+	    TP_fast_assign(
+		__entry->nr_zones = nr_zones;
+		__assign_disk_name(__entry->disk, nullb->disk);
+	    ),
+	    TP_printk("%s nr_zones=%u",
+		      __print_disk_name(__entry->disk), __entry->nr_zones)
+);
+
+#endif /* _TRACE_NULLB_H */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
new file mode 100644
index 000000000000..41220ce59659
--- /dev/null
+++ b/drivers/block/null_blk/zoned.c
@@ -0,0 +1,617 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/vmalloc.h>
+#include <linux/bitmap.h>
+#include "null_blk.h"
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
+
+static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
+{
+	return sect >> ilog2(dev->zone_size_sects);
+}
+
+int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
+{
+	sector_t dev_capacity_sects, zone_capacity_sects;
+	sector_t sector = 0;
+	unsigned int i;
+
+	if (!is_power_of_2(dev->zone_size)) {
+		pr_err("zone_size must be power-of-two\n");
+		return -EINVAL;
+	}
+	if (dev->zone_size > dev->size) {
+		pr_err("Zone size larger than device capacity\n");
+		return -EINVAL;
+	}
+
+	if (!dev->zone_capacity)
+		dev->zone_capacity = dev->zone_size;
+
+	if (dev->zone_capacity > dev->zone_size) {
+		pr_err("null_blk: zone capacity (%lu MB) larger than zone size (%lu MB)\n",
+					dev->zone_capacity, dev->zone_size);
+		return -EINVAL;
+	}
+
+	zone_capacity_sects = MB_TO_SECTS(dev->zone_capacity);
+	dev_capacity_sects = MB_TO_SECTS(dev->size);
+	dev->zone_size_sects = MB_TO_SECTS(dev->zone_size);
+	dev->nr_zones = dev_capacity_sects >> ilog2(dev->zone_size_sects);
+	if (dev_capacity_sects & (dev->zone_size_sects - 1))
+		dev->nr_zones++;
+
+	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct blk_zone),
+			GFP_KERNEL | __GFP_ZERO);
+	if (!dev->zones)
+		return -ENOMEM;
+
+	/*
+	 * With memory backing, the zone_lock spinlock needs to be temporarily
+	 * released to avoid scheduling in atomic context. To guarantee zone
+	 * information protection, use a bitmap to lock zones with
+	 * wait_on_bit_lock_io(). Sleeping on the lock is OK as memory backing
+	 * implies that the queue is marked with BLK_MQ_F_BLOCKING.
+	 */
+	spin_lock_init(&dev->zone_lock);
+	if (dev->memory_backed) {
+		dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
+		if (!dev->zone_locks) {
+			kvfree(dev->zones);
+			return -ENOMEM;
+		}
+	}
+
+	if (dev->zone_nr_conv >= dev->nr_zones) {
+		dev->zone_nr_conv = dev->nr_zones - 1;
+		pr_info("changed the number of conventional zones to %u",
+			dev->zone_nr_conv);
+	}
+
+	/* Max active zones has to be < nbr of seq zones in order to be enforceable */
+	if (dev->zone_max_active >= dev->nr_zones - dev->zone_nr_conv) {
+		dev->zone_max_active = 0;
+		pr_info("zone_max_active limit disabled, limit >= zone count\n");
+	}
+
+	/* Max open zones has to be <= max active zones */
+	if (dev->zone_max_active && dev->zone_max_open > dev->zone_max_active) {
+		dev->zone_max_open = dev->zone_max_active;
+		pr_info("changed the maximum number of open zones to %u\n",
+			dev->nr_zones);
+	} else if (dev->zone_max_open >= dev->nr_zones - dev->zone_nr_conv) {
+		dev->zone_max_open = 0;
+		pr_info("zone_max_open limit disabled, limit >= zone count\n");
+	}
+
+	for (i = 0; i <  dev->zone_nr_conv; i++) {
+		struct blk_zone *zone = &dev->zones[i];
+
+		zone->start = sector;
+		zone->len = dev->zone_size_sects;
+		zone->capacity = zone->len;
+		zone->wp = zone->start + zone->len;
+		zone->type = BLK_ZONE_TYPE_CONVENTIONAL;
+		zone->cond = BLK_ZONE_COND_NOT_WP;
+
+		sector += dev->zone_size_sects;
+	}
+
+	for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+		struct blk_zone *zone = &dev->zones[i];
+
+		zone->start = zone->wp = sector;
+		if (zone->start + dev->zone_size_sects > dev_capacity_sects)
+			zone->len = dev_capacity_sects - zone->start;
+		else
+			zone->len = dev->zone_size_sects;
+		zone->capacity =
+			min_t(sector_t, zone->len, zone_capacity_sects);
+		zone->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
+		zone->cond = BLK_ZONE_COND_EMPTY;
+
+		sector += dev->zone_size_sects;
+	}
+
+	q->limits.zoned = BLK_ZONED_HM;
+	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
+	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
+
+	return 0;
+}
+
+int null_register_zoned_dev(struct nullb *nullb)
+{
+	struct nullb_device *dev = nullb->dev;
+	struct request_queue *q = nullb->q;
+
+	if (queue_is_mq(q)) {
+		int ret = blk_revalidate_disk_zones(nullb->disk, NULL);
+
+		if (ret)
+			return ret;
+	} else {
+		blk_queue_chunk_sectors(q, dev->zone_size_sects);
+		q->nr_zones = blkdev_nr_zones(nullb->disk);
+	}
+
+	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
+	blk_queue_max_open_zones(q, dev->zone_max_open);
+	blk_queue_max_active_zones(q, dev->zone_max_active);
+
+	return 0;
+}
+
+void null_free_zoned_dev(struct nullb_device *dev)
+{
+	bitmap_free(dev->zone_locks);
+	kvfree(dev->zones);
+	dev->zones = NULL;
+}
+
+static inline void null_lock_zone(struct nullb_device *dev, unsigned int zno)
+{
+	if (dev->memory_backed)
+		wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
+	spin_lock_irq(&dev->zone_lock);
+}
+
+static inline void null_unlock_zone(struct nullb_device *dev, unsigned int zno)
+{
+	spin_unlock_irq(&dev->zone_lock);
+
+	if (dev->memory_backed)
+		clear_and_wake_up_bit(zno, dev->zone_locks);
+}
+
+int null_report_zones(struct gendisk *disk, sector_t sector,
+		unsigned int nr_zones, report_zones_cb cb, void *data)
+{
+	struct nullb *nullb = disk->private_data;
+	struct nullb_device *dev = nullb->dev;
+	unsigned int first_zone, i, zno;
+	struct blk_zone zone;
+	int error;
+
+	first_zone = null_zone_no(dev, sector);
+	if (first_zone >= dev->nr_zones)
+		return 0;
+
+	nr_zones = min(nr_zones, dev->nr_zones - first_zone);
+	trace_nullb_report_zones(nullb, nr_zones);
+
+	zno = first_zone;
+	for (i = 0; i < nr_zones; i++, zno++) {
+		/*
+		 * Stacked DM target drivers will remap the zone information by
+		 * modifying the zone information passed to the report callback.
+		 * So use a local copy to avoid corruption of the device zone
+		 * array.
+		 */
+		null_lock_zone(dev, zno);
+		memcpy(&zone, &dev->zones[zno], sizeof(struct blk_zone));
+		null_unlock_zone(dev, zno);
+
+		error = cb(&zone, i, data);
+		if (error)
+			return error;
+	}
+
+	return nr_zones;
+}
+
+/*
+ * This is called in the case of memory backing from null_process_cmd()
+ * with the target zone already locked.
+ */
+size_t null_zone_valid_read_len(struct nullb *nullb,
+				sector_t sector, unsigned int len)
+{
+	struct nullb_device *dev = nullb->dev;
+	struct blk_zone *zone = &dev->zones[null_zone_no(dev, sector)];
+	unsigned int nr_sectors = len >> SECTOR_SHIFT;
+
+	/* Read must be below the write pointer position */
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL ||
+	    sector + nr_sectors <= zone->wp)
+		return len;
+
+	if (sector > zone->wp)
+		return 0;
+
+	return (zone->wp - sector) << SECTOR_SHIFT;
+}
+
+static blk_status_t null_close_zone(struct nullb_device *dev, struct blk_zone *zone)
+{
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return BLK_STS_IOERR;
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_CLOSED:
+		/* close operation on closed is not an error */
+		return BLK_STS_OK;
+	case BLK_ZONE_COND_IMP_OPEN:
+		dev->nr_zones_imp_open--;
+		break;
+	case BLK_ZONE_COND_EXP_OPEN:
+		dev->nr_zones_exp_open--;
+		break;
+	case BLK_ZONE_COND_EMPTY:
+	case BLK_ZONE_COND_FULL:
+	default:
+		return BLK_STS_IOERR;
+	}
+
+	if (zone->wp == zone->start) {
+		zone->cond = BLK_ZONE_COND_EMPTY;
+	} else {
+		zone->cond = BLK_ZONE_COND_CLOSED;
+		dev->nr_zones_closed++;
+	}
+
+	return BLK_STS_OK;
+}
+
+static void null_close_first_imp_zone(struct nullb_device *dev)
+{
+	unsigned int i;
+
+	for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+		if (dev->zones[i].cond == BLK_ZONE_COND_IMP_OPEN) {
+			null_close_zone(dev, &dev->zones[i]);
+			return;
+		}
+	}
+}
+
+static blk_status_t null_check_active(struct nullb_device *dev)
+{
+	if (!dev->zone_max_active)
+		return BLK_STS_OK;
+
+	if (dev->nr_zones_exp_open + dev->nr_zones_imp_open +
+			dev->nr_zones_closed < dev->zone_max_active)
+		return BLK_STS_OK;
+
+	return BLK_STS_ZONE_ACTIVE_RESOURCE;
+}
+
+static blk_status_t null_check_open(struct nullb_device *dev)
+{
+	if (!dev->zone_max_open)
+		return BLK_STS_OK;
+
+	if (dev->nr_zones_exp_open + dev->nr_zones_imp_open < dev->zone_max_open)
+		return BLK_STS_OK;
+
+	if (dev->nr_zones_imp_open) {
+		if (null_check_active(dev) == BLK_STS_OK) {
+			null_close_first_imp_zone(dev);
+			return BLK_STS_OK;
+		}
+	}
+
+	return BLK_STS_ZONE_OPEN_RESOURCE;
+}
+
+/*
+ * This function matches the manage open zone resources function in the ZBC standard,
+ * with the addition of max active zones support (added in the ZNS standard).
+ *
+ * The function determines if a zone can transition to implicit open or explicit open,
+ * while maintaining the max open zone (and max active zone) limit(s). It may close an
+ * implicit open zone in order to make additional zone resources available.
+ *
+ * ZBC states that an implicit open zone shall be closed only if there is not
+ * room within the open limit. However, with the addition of an active limit,
+ * it is not certain that closing an implicit open zone will allow a new zone
+ * to be opened, since we might already be at the active limit capacity.
+ */
+static blk_status_t null_check_zone_resources(struct nullb_device *dev, struct blk_zone *zone)
+{
+	blk_status_t ret;
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_EMPTY:
+		ret = null_check_active(dev);
+		if (ret != BLK_STS_OK)
+			return ret;
+		fallthrough;
+	case BLK_ZONE_COND_CLOSED:
+		return null_check_open(dev);
+	default:
+		/* Should never be called for other states */
+		WARN_ON(1);
+		return BLK_STS_IOERR;
+	}
+}
+
+static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
+				    unsigned int nr_sectors, bool append)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	unsigned int zno = null_zone_no(dev, sector);
+	struct blk_zone *zone = &dev->zones[zno];
+	blk_status_t ret;
+
+	trace_nullb_zone_op(cmd, zno, zone->cond);
+
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
+		if (append)
+			return BLK_STS_IOERR;
+		return null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
+	}
+
+	null_lock_zone(dev, zno);
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_FULL:
+		/* Cannot write to a full zone */
+		ret = BLK_STS_IOERR;
+		goto unlock;
+	case BLK_ZONE_COND_EMPTY:
+	case BLK_ZONE_COND_CLOSED:
+		ret = null_check_zone_resources(dev, zone);
+		if (ret != BLK_STS_OK)
+			goto unlock;
+		break;
+	case BLK_ZONE_COND_IMP_OPEN:
+	case BLK_ZONE_COND_EXP_OPEN:
+		break;
+	default:
+		/* Invalid zone condition */
+		ret = BLK_STS_IOERR;
+		goto unlock;
+	}
+
+	/*
+	 * Regular writes must be at the write pointer position.
+	 * Zone append writes are automatically issued at the write
+	 * pointer and the position returned using the request or BIO
+	 * sector.
+	 */
+	if (append) {
+		sector = zone->wp;
+		if (cmd->bio)
+			cmd->bio->bi_iter.bi_sector = sector;
+		else
+			cmd->rq->__sector = sector;
+	} else if (sector != zone->wp) {
+		ret = BLK_STS_IOERR;
+		goto unlock;
+	}
+
+	if (zone->wp + nr_sectors > zone->start + zone->capacity) {
+		ret = BLK_STS_IOERR;
+		goto unlock;
+	}
+
+	if (zone->cond == BLK_ZONE_COND_CLOSED) {
+		dev->nr_zones_closed--;
+		dev->nr_zones_imp_open++;
+	} else if (zone->cond == BLK_ZONE_COND_EMPTY) {
+		dev->nr_zones_imp_open++;
+	}
+	if (zone->cond != BLK_ZONE_COND_EXP_OPEN)
+		zone->cond = BLK_ZONE_COND_IMP_OPEN;
+
+	/*
+	 * Memory backing allocation may sleep: release the zone_lock spinlock
+	 * to avoid scheduling in atomic context. Zone operation atomicity is
+	 * still guaranteed through the zone_locks bitmap.
+	 */
+	if (dev->memory_backed)
+		spin_unlock_irq(&dev->zone_lock);
+	ret = null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
+	if (dev->memory_backed)
+		spin_lock_irq(&dev->zone_lock);
+
+	if (ret != BLK_STS_OK)
+		goto unlock;
+
+	zone->wp += nr_sectors;
+	if (zone->wp == zone->start + zone->capacity) {
+		if (zone->cond == BLK_ZONE_COND_EXP_OPEN)
+			dev->nr_zones_exp_open--;
+		else if (zone->cond == BLK_ZONE_COND_IMP_OPEN)
+			dev->nr_zones_imp_open--;
+		zone->cond = BLK_ZONE_COND_FULL;
+	}
+	ret = BLK_STS_OK;
+
+unlock:
+	null_unlock_zone(dev, zno);
+
+	return ret;
+}
+
+static blk_status_t null_open_zone(struct nullb_device *dev, struct blk_zone *zone)
+{
+	blk_status_t ret;
+
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return BLK_STS_IOERR;
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_EXP_OPEN:
+		/* open operation on exp open is not an error */
+		return BLK_STS_OK;
+	case BLK_ZONE_COND_EMPTY:
+		ret = null_check_zone_resources(dev, zone);
+		if (ret != BLK_STS_OK)
+			return ret;
+		break;
+	case BLK_ZONE_COND_IMP_OPEN:
+		dev->nr_zones_imp_open--;
+		break;
+	case BLK_ZONE_COND_CLOSED:
+		ret = null_check_zone_resources(dev, zone);
+		if (ret != BLK_STS_OK)
+			return ret;
+		dev->nr_zones_closed--;
+		break;
+	case BLK_ZONE_COND_FULL:
+	default:
+		return BLK_STS_IOERR;
+	}
+
+	zone->cond = BLK_ZONE_COND_EXP_OPEN;
+	dev->nr_zones_exp_open++;
+
+	return BLK_STS_OK;
+}
+
+static blk_status_t null_finish_zone(struct nullb_device *dev, struct blk_zone *zone)
+{
+	blk_status_t ret;
+
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return BLK_STS_IOERR;
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_FULL:
+		/* finish operation on full is not an error */
+		return BLK_STS_OK;
+	case BLK_ZONE_COND_EMPTY:
+		ret = null_check_zone_resources(dev, zone);
+		if (ret != BLK_STS_OK)
+			return ret;
+		break;
+	case BLK_ZONE_COND_IMP_OPEN:
+		dev->nr_zones_imp_open--;
+		break;
+	case BLK_ZONE_COND_EXP_OPEN:
+		dev->nr_zones_exp_open--;
+		break;
+	case BLK_ZONE_COND_CLOSED:
+		ret = null_check_zone_resources(dev, zone);
+		if (ret != BLK_STS_OK)
+			return ret;
+		dev->nr_zones_closed--;
+		break;
+	default:
+		return BLK_STS_IOERR;
+	}
+
+	zone->cond = BLK_ZONE_COND_FULL;
+	zone->wp = zone->start + zone->len;
+
+	return BLK_STS_OK;
+}
+
+static blk_status_t null_reset_zone(struct nullb_device *dev, struct blk_zone *zone)
+{
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return BLK_STS_IOERR;
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_EMPTY:
+		/* reset operation on empty is not an error */
+		return BLK_STS_OK;
+	case BLK_ZONE_COND_IMP_OPEN:
+		dev->nr_zones_imp_open--;
+		break;
+	case BLK_ZONE_COND_EXP_OPEN:
+		dev->nr_zones_exp_open--;
+		break;
+	case BLK_ZONE_COND_CLOSED:
+		dev->nr_zones_closed--;
+		break;
+	case BLK_ZONE_COND_FULL:
+		break;
+	default:
+		return BLK_STS_IOERR;
+	}
+
+	zone->cond = BLK_ZONE_COND_EMPTY;
+	zone->wp = zone->start;
+
+	return BLK_STS_OK;
+}
+
+static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
+				   sector_t sector)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	unsigned int zone_no;
+	struct blk_zone *zone;
+	blk_status_t ret;
+	size_t i;
+
+	if (op == REQ_OP_ZONE_RESET_ALL) {
+		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
+			null_lock_zone(dev, i);
+			zone = &dev->zones[i];
+			if (zone->cond != BLK_ZONE_COND_EMPTY) {
+				null_reset_zone(dev, zone);
+				trace_nullb_zone_op(cmd, i, zone->cond);
+			}
+			null_unlock_zone(dev, i);
+		}
+		return BLK_STS_OK;
+	}
+
+	zone_no = null_zone_no(dev, sector);
+	zone = &dev->zones[zone_no];
+
+	null_lock_zone(dev, zone_no);
+
+	switch (op) {
+	case REQ_OP_ZONE_RESET:
+		ret = null_reset_zone(dev, zone);
+		break;
+	case REQ_OP_ZONE_OPEN:
+		ret = null_open_zone(dev, zone);
+		break;
+	case REQ_OP_ZONE_CLOSE:
+		ret = null_close_zone(dev, zone);
+		break;
+	case REQ_OP_ZONE_FINISH:
+		ret = null_finish_zone(dev, zone);
+		break;
+	default:
+		ret = BLK_STS_NOTSUPP;
+		break;
+	}
+
+	if (ret == BLK_STS_OK)
+		trace_nullb_zone_op(cmd, zone_no, zone->cond);
+
+	null_unlock_zone(dev, zone_no);
+
+	return ret;
+}
+
+blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf op,
+				    sector_t sector, sector_t nr_sectors)
+{
+	struct nullb_device *dev = cmd->nq->dev;
+	unsigned int zno = null_zone_no(dev, sector);
+	blk_status_t sts;
+
+	switch (op) {
+	case REQ_OP_WRITE:
+		sts = null_zone_write(cmd, sector, nr_sectors, false);
+		break;
+	case REQ_OP_ZONE_APPEND:
+		sts = null_zone_write(cmd, sector, nr_sectors, true);
+		break;
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		sts = null_zone_mgmt(cmd, op, sector);
+		break;
+	default:
+		null_lock_zone(dev, zno);
+		sts = null_process_cmd(cmd, op, sector, nr_sectors);
+		null_unlock_zone(dev, zno);
+	}
+
+	return sts;
+}
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
deleted file mode 100644
index c6ba8f9f3f31..000000000000
--- a/drivers/block/null_blk_main.c
+++ /dev/null
@@ -1,2036 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * Add configfs and memory store: Kyungchan Koh <kkc6196@fb.com> and
- * Shaohua Li <shli@fb.com>
- */
-#include <linux/module.h>
-
-#include <linux/moduleparam.h>
-#include <linux/sched.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include "null_blk.h"
-
-#define PAGE_SECTORS_SHIFT	(PAGE_SHIFT - SECTOR_SHIFT)
-#define PAGE_SECTORS		(1 << PAGE_SECTORS_SHIFT)
-#define SECTOR_MASK		(PAGE_SECTORS - 1)
-
-#define FREE_BATCH		16
-
-#define TICKS_PER_SEC		50ULL
-#define TIMER_INTERVAL		(NSEC_PER_SEC / TICKS_PER_SEC)
-
-#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
-static DECLARE_FAULT_ATTR(null_timeout_attr);
-static DECLARE_FAULT_ATTR(null_requeue_attr);
-static DECLARE_FAULT_ATTR(null_init_hctx_attr);
-#endif
-
-static inline u64 mb_per_tick(int mbps)
-{
-	return (1 << 20) / TICKS_PER_SEC * ((u64) mbps);
-}
-
-/*
- * Status flags for nullb_device.
- *
- * CONFIGURED:	Device has been configured and turned on. Cannot reconfigure.
- * UP:		Device is currently on and visible in userspace.
- * THROTTLED:	Device is being throttled.
- * CACHE:	Device is using a write-back cache.
- */
-enum nullb_device_flags {
-	NULLB_DEV_FL_CONFIGURED	= 0,
-	NULLB_DEV_FL_UP		= 1,
-	NULLB_DEV_FL_THROTTLED	= 2,
-	NULLB_DEV_FL_CACHE	= 3,
-};
-
-#define MAP_SZ		((PAGE_SIZE >> SECTOR_SHIFT) + 2)
-/*
- * nullb_page is a page in memory for nullb devices.
- *
- * @page:	The page holding the data.
- * @bitmap:	The bitmap represents which sector in the page has data.
- *		Each bit represents one block size. For example, sector 8
- *		will use the 7th bit
- * The highest 2 bits of bitmap are for special purpose. LOCK means the cache
- * page is being flushing to storage. FREE means the cache page is freed and
- * should be skipped from flushing to storage. Please see
- * null_make_cache_space
- */
-struct nullb_page {
-	struct page *page;
-	DECLARE_BITMAP(bitmap, MAP_SZ);
-};
-#define NULLB_PAGE_LOCK (MAP_SZ - 1)
-#define NULLB_PAGE_FREE (MAP_SZ - 2)
-
-static LIST_HEAD(nullb_list);
-static struct mutex lock;
-static int null_major;
-static DEFINE_IDA(nullb_indexes);
-static struct blk_mq_tag_set tag_set;
-
-enum {
-	NULL_IRQ_NONE		= 0,
-	NULL_IRQ_SOFTIRQ	= 1,
-	NULL_IRQ_TIMER		= 2,
-};
-
-enum {
-	NULL_Q_BIO		= 0,
-	NULL_Q_RQ		= 1,
-	NULL_Q_MQ		= 2,
-};
-
-static int g_no_sched;
-module_param_named(no_sched, g_no_sched, int, 0444);
-MODULE_PARM_DESC(no_sched, "No io scheduler");
-
-static int g_submit_queues = 1;
-module_param_named(submit_queues, g_submit_queues, int, 0444);
-MODULE_PARM_DESC(submit_queues, "Number of submission queues");
-
-static int g_home_node = NUMA_NO_NODE;
-module_param_named(home_node, g_home_node, int, 0444);
-MODULE_PARM_DESC(home_node, "Home node for the device");
-
-#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
-/*
- * For more details about fault injection, please refer to
- * Documentation/fault-injection/fault-injection.rst.
- */
-static char g_timeout_str[80];
-module_param_string(timeout, g_timeout_str, sizeof(g_timeout_str), 0444);
-MODULE_PARM_DESC(timeout, "Fault injection. timeout=<interval>,<probability>,<space>,<times>");
-
-static char g_requeue_str[80];
-module_param_string(requeue, g_requeue_str, sizeof(g_requeue_str), 0444);
-MODULE_PARM_DESC(requeue, "Fault injection. requeue=<interval>,<probability>,<space>,<times>");
-
-static char g_init_hctx_str[80];
-module_param_string(init_hctx, g_init_hctx_str, sizeof(g_init_hctx_str), 0444);
-MODULE_PARM_DESC(init_hctx, "Fault injection to fail hctx init. init_hctx=<interval>,<probability>,<space>,<times>");
-#endif
-
-static int g_queue_mode = NULL_Q_MQ;
-
-static int null_param_store_val(const char *str, int *val, int min, int max)
-{
-	int ret, new_val;
-
-	ret = kstrtoint(str, 10, &new_val);
-	if (ret)
-		return -EINVAL;
-
-	if (new_val < min || new_val > max)
-		return -EINVAL;
-
-	*val = new_val;
-	return 0;
-}
-
-static int null_set_queue_mode(const char *str, const struct kernel_param *kp)
-{
-	return null_param_store_val(str, &g_queue_mode, NULL_Q_BIO, NULL_Q_MQ);
-}
-
-static const struct kernel_param_ops null_queue_mode_param_ops = {
-	.set	= null_set_queue_mode,
-	.get	= param_get_int,
-};
-
-device_param_cb(queue_mode, &null_queue_mode_param_ops, &g_queue_mode, 0444);
-MODULE_PARM_DESC(queue_mode, "Block interface to use (0=bio,1=rq,2=multiqueue)");
-
-static int g_gb = 250;
-module_param_named(gb, g_gb, int, 0444);
-MODULE_PARM_DESC(gb, "Size in GB");
-
-static int g_bs = 512;
-module_param_named(bs, g_bs, int, 0444);
-MODULE_PARM_DESC(bs, "Block size (in bytes)");
-
-static unsigned int nr_devices = 1;
-module_param(nr_devices, uint, 0444);
-MODULE_PARM_DESC(nr_devices, "Number of devices to register");
-
-static bool g_blocking;
-module_param_named(blocking, g_blocking, bool, 0444);
-MODULE_PARM_DESC(blocking, "Register as a blocking blk-mq driver device");
-
-static bool shared_tags;
-module_param(shared_tags, bool, 0444);
-MODULE_PARM_DESC(shared_tags, "Share tag set between devices for blk-mq");
-
-static bool g_shared_tag_bitmap;
-module_param_named(shared_tag_bitmap, g_shared_tag_bitmap, bool, 0444);
-MODULE_PARM_DESC(shared_tag_bitmap, "Use shared tag bitmap for all submission queues for blk-mq");
-
-static int g_irqmode = NULL_IRQ_SOFTIRQ;
-
-static int null_set_irqmode(const char *str, const struct kernel_param *kp)
-{
-	return null_param_store_val(str, &g_irqmode, NULL_IRQ_NONE,
-					NULL_IRQ_TIMER);
-}
-
-static const struct kernel_param_ops null_irqmode_param_ops = {
-	.set	= null_set_irqmode,
-	.get	= param_get_int,
-};
-
-device_param_cb(irqmode, &null_irqmode_param_ops, &g_irqmode, 0444);
-MODULE_PARM_DESC(irqmode, "IRQ completion handler. 0-none, 1-softirq, 2-timer");
-
-static unsigned long g_completion_nsec = 10000;
-module_param_named(completion_nsec, g_completion_nsec, ulong, 0444);
-MODULE_PARM_DESC(completion_nsec, "Time in ns to complete a request in hardware. Default: 10,000ns");
-
-static int g_hw_queue_depth = 64;
-module_param_named(hw_queue_depth, g_hw_queue_depth, int, 0444);
-MODULE_PARM_DESC(hw_queue_depth, "Queue depth for each hardware queue. Default: 64");
-
-static bool g_use_per_node_hctx;
-module_param_named(use_per_node_hctx, g_use_per_node_hctx, bool, 0444);
-MODULE_PARM_DESC(use_per_node_hctx, "Use per-node allocation for hardware context queues. Default: false");
-
-static bool g_zoned;
-module_param_named(zoned, g_zoned, bool, S_IRUGO);
-MODULE_PARM_DESC(zoned, "Make device as a host-managed zoned block device. Default: false");
-
-static unsigned long g_zone_size = 256;
-module_param_named(zone_size, g_zone_size, ulong, S_IRUGO);
-MODULE_PARM_DESC(zone_size, "Zone size in MB when block device is zoned. Must be power-of-two: Default: 256");
-
-static unsigned long g_zone_capacity;
-module_param_named(zone_capacity, g_zone_capacity, ulong, 0444);
-MODULE_PARM_DESC(zone_capacity, "Zone capacity in MB when block device is zoned. Can be less than or equal to zone size. Default: Zone size");
-
-static unsigned int g_zone_nr_conv;
-module_param_named(zone_nr_conv, g_zone_nr_conv, uint, 0444);
-MODULE_PARM_DESC(zone_nr_conv, "Number of conventional zones when block device is zoned. Default: 0");
-
-static unsigned int g_zone_max_open;
-module_param_named(zone_max_open, g_zone_max_open, uint, 0444);
-MODULE_PARM_DESC(zone_max_open, "Maximum number of open zones when block device is zoned. Default: 0 (no limit)");
-
-static unsigned int g_zone_max_active;
-module_param_named(zone_max_active, g_zone_max_active, uint, 0444);
-MODULE_PARM_DESC(zone_max_active, "Maximum number of active zones when block device is zoned. Default: 0 (no limit)");
-
-static struct nullb_device *null_alloc_dev(void);
-static void null_free_dev(struct nullb_device *dev);
-static void null_del_dev(struct nullb *nullb);
-static int null_add_dev(struct nullb_device *dev);
-static void null_free_device_storage(struct nullb_device *dev, bool is_cache);
-
-static inline struct nullb_device *to_nullb_device(struct config_item *item)
-{
-	return item ? container_of(item, struct nullb_device, item) : NULL;
-}
-
-static inline ssize_t nullb_device_uint_attr_show(unsigned int val, char *page)
-{
-	return snprintf(page, PAGE_SIZE, "%u\n", val);
-}
-
-static inline ssize_t nullb_device_ulong_attr_show(unsigned long val,
-	char *page)
-{
-	return snprintf(page, PAGE_SIZE, "%lu\n", val);
-}
-
-static inline ssize_t nullb_device_bool_attr_show(bool val, char *page)
-{
-	return snprintf(page, PAGE_SIZE, "%u\n", val);
-}
-
-static ssize_t nullb_device_uint_attr_store(unsigned int *val,
-	const char *page, size_t count)
-{
-	unsigned int tmp;
-	int result;
-
-	result = kstrtouint(page, 0, &tmp);
-	if (result < 0)
-		return result;
-
-	*val = tmp;
-	return count;
-}
-
-static ssize_t nullb_device_ulong_attr_store(unsigned long *val,
-	const char *page, size_t count)
-{
-	int result;
-	unsigned long tmp;
-
-	result = kstrtoul(page, 0, &tmp);
-	if (result < 0)
-		return result;
-
-	*val = tmp;
-	return count;
-}
-
-static ssize_t nullb_device_bool_attr_store(bool *val, const char *page,
-	size_t count)
-{
-	bool tmp;
-	int result;
-
-	result = kstrtobool(page,  &tmp);
-	if (result < 0)
-		return result;
-
-	*val = tmp;
-	return count;
-}
-
-/* The following macro should only be used with TYPE = {uint, ulong, bool}. */
-#define NULLB_DEVICE_ATTR(NAME, TYPE, APPLY)				\
-static ssize_t								\
-nullb_device_##NAME##_show(struct config_item *item, char *page)	\
-{									\
-	return nullb_device_##TYPE##_attr_show(				\
-				to_nullb_device(item)->NAME, page);	\
-}									\
-static ssize_t								\
-nullb_device_##NAME##_store(struct config_item *item, const char *page,	\
-			    size_t count)				\
-{									\
-	int (*apply_fn)(struct nullb_device *dev, TYPE new_value) = APPLY;\
-	struct nullb_device *dev = to_nullb_device(item);		\
-	TYPE new_value = 0;						\
-	int ret;							\
-									\
-	ret = nullb_device_##TYPE##_attr_store(&new_value, page, count);\
-	if (ret < 0)							\
-		return ret;						\
-	if (apply_fn)							\
-		ret = apply_fn(dev, new_value);				\
-	else if (test_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags)) 	\
-		ret = -EBUSY;						\
-	if (ret < 0)							\
-		return ret;						\
-	dev->NAME = new_value;						\
-	return count;							\
-}									\
-CONFIGFS_ATTR(nullb_device_, NAME);
-
-static int nullb_apply_submit_queues(struct nullb_device *dev,
-				     unsigned int submit_queues)
-{
-	struct nullb *nullb = dev->nullb;
-	struct blk_mq_tag_set *set;
-
-	if (!nullb)
-		return 0;
-
-	/*
-	 * Make sure that null_init_hctx() does not access nullb->queues[] past
-	 * the end of that array.
-	 */
-	if (submit_queues > nr_cpu_ids)
-		return -EINVAL;
-	set = nullb->tag_set;
-	blk_mq_update_nr_hw_queues(set, submit_queues);
-	return set->nr_hw_queues == submit_queues ? 0 : -ENOMEM;
-}
-
-NULLB_DEVICE_ATTR(size, ulong, NULL);
-NULLB_DEVICE_ATTR(completion_nsec, ulong, NULL);
-NULLB_DEVICE_ATTR(submit_queues, uint, nullb_apply_submit_queues);
-NULLB_DEVICE_ATTR(home_node, uint, NULL);
-NULLB_DEVICE_ATTR(queue_mode, uint, NULL);
-NULLB_DEVICE_ATTR(blocksize, uint, NULL);
-NULLB_DEVICE_ATTR(irqmode, uint, NULL);
-NULLB_DEVICE_ATTR(hw_queue_depth, uint, NULL);
-NULLB_DEVICE_ATTR(index, uint, NULL);
-NULLB_DEVICE_ATTR(blocking, bool, NULL);
-NULLB_DEVICE_ATTR(use_per_node_hctx, bool, NULL);
-NULLB_DEVICE_ATTR(memory_backed, bool, NULL);
-NULLB_DEVICE_ATTR(discard, bool, NULL);
-NULLB_DEVICE_ATTR(mbps, uint, NULL);
-NULLB_DEVICE_ATTR(cache_size, ulong, NULL);
-NULLB_DEVICE_ATTR(zoned, bool, NULL);
-NULLB_DEVICE_ATTR(zone_size, ulong, NULL);
-NULLB_DEVICE_ATTR(zone_capacity, ulong, NULL);
-NULLB_DEVICE_ATTR(zone_nr_conv, uint, NULL);
-NULLB_DEVICE_ATTR(zone_max_open, uint, NULL);
-NULLB_DEVICE_ATTR(zone_max_active, uint, NULL);
-
-static ssize_t nullb_device_power_show(struct config_item *item, char *page)
-{
-	return nullb_device_bool_attr_show(to_nullb_device(item)->power, page);
-}
-
-static ssize_t nullb_device_power_store(struct config_item *item,
-				     const char *page, size_t count)
-{
-	struct nullb_device *dev = to_nullb_device(item);
-	bool newp = false;
-	ssize_t ret;
-
-	ret = nullb_device_bool_attr_store(&newp, page, count);
-	if (ret < 0)
-		return ret;
-
-	if (!dev->power && newp) {
-		if (test_and_set_bit(NULLB_DEV_FL_UP, &dev->flags))
-			return count;
-		if (null_add_dev(dev)) {
-			clear_bit(NULLB_DEV_FL_UP, &dev->flags);
-			return -ENOMEM;
-		}
-
-		set_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
-		dev->power = newp;
-	} else if (dev->power && !newp) {
-		if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
-			mutex_lock(&lock);
-			dev->power = newp;
-			null_del_dev(dev->nullb);
-			mutex_unlock(&lock);
-		}
-		clear_bit(NULLB_DEV_FL_CONFIGURED, &dev->flags);
-	}
-
-	return count;
-}
-
-CONFIGFS_ATTR(nullb_device_, power);
-
-static ssize_t nullb_device_badblocks_show(struct config_item *item, char *page)
-{
-	struct nullb_device *t_dev = to_nullb_device(item);
-
-	return badblocks_show(&t_dev->badblocks, page, 0);
-}
-
-static ssize_t nullb_device_badblocks_store(struct config_item *item,
-				     const char *page, size_t count)
-{
-	struct nullb_device *t_dev = to_nullb_device(item);
-	char *orig, *buf, *tmp;
-	u64 start, end;
-	int ret;
-
-	orig = kstrndup(page, count, GFP_KERNEL);
-	if (!orig)
-		return -ENOMEM;
-
-	buf = strstrip(orig);
-
-	ret = -EINVAL;
-	if (buf[0] != '+' && buf[0] != '-')
-		goto out;
-	tmp = strchr(&buf[1], '-');
-	if (!tmp)
-		goto out;
-	*tmp = '\0';
-	ret = kstrtoull(buf + 1, 0, &start);
-	if (ret)
-		goto out;
-	ret = kstrtoull(tmp + 1, 0, &end);
-	if (ret)
-		goto out;
-	ret = -EINVAL;
-	if (start > end)
-		goto out;
-	/* enable badblocks */
-	cmpxchg(&t_dev->badblocks.shift, -1, 0);
-	if (buf[0] == '+')
-		ret = badblocks_set(&t_dev->badblocks, start,
-			end - start + 1, 1);
-	else
-		ret = badblocks_clear(&t_dev->badblocks, start,
-			end - start + 1);
-	if (ret == 0)
-		ret = count;
-out:
-	kfree(orig);
-	return ret;
-}
-CONFIGFS_ATTR(nullb_device_, badblocks);
-
-static struct configfs_attribute *nullb_device_attrs[] = {
-	&nullb_device_attr_size,
-	&nullb_device_attr_completion_nsec,
-	&nullb_device_attr_submit_queues,
-	&nullb_device_attr_home_node,
-	&nullb_device_attr_queue_mode,
-	&nullb_device_attr_blocksize,
-	&nullb_device_attr_irqmode,
-	&nullb_device_attr_hw_queue_depth,
-	&nullb_device_attr_index,
-	&nullb_device_attr_blocking,
-	&nullb_device_attr_use_per_node_hctx,
-	&nullb_device_attr_power,
-	&nullb_device_attr_memory_backed,
-	&nullb_device_attr_discard,
-	&nullb_device_attr_mbps,
-	&nullb_device_attr_cache_size,
-	&nullb_device_attr_badblocks,
-	&nullb_device_attr_zoned,
-	&nullb_device_attr_zone_size,
-	&nullb_device_attr_zone_capacity,
-	&nullb_device_attr_zone_nr_conv,
-	&nullb_device_attr_zone_max_open,
-	&nullb_device_attr_zone_max_active,
-	NULL,
-};
-
-static void nullb_device_release(struct config_item *item)
-{
-	struct nullb_device *dev = to_nullb_device(item);
-
-	null_free_device_storage(dev, false);
-	null_free_dev(dev);
-}
-
-static struct configfs_item_operations nullb_device_ops = {
-	.release	= nullb_device_release,
-};
-
-static const struct config_item_type nullb_device_type = {
-	.ct_item_ops	= &nullb_device_ops,
-	.ct_attrs	= nullb_device_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
-static struct
-config_item *nullb_group_make_item(struct config_group *group, const char *name)
-{
-	struct nullb_device *dev;
-
-	dev = null_alloc_dev();
-	if (!dev)
-		return ERR_PTR(-ENOMEM);
-
-	config_item_init_type_name(&dev->item, name, &nullb_device_type);
-
-	return &dev->item;
-}
-
-static void
-nullb_group_drop_item(struct config_group *group, struct config_item *item)
-{
-	struct nullb_device *dev = to_nullb_device(item);
-
-	if (test_and_clear_bit(NULLB_DEV_FL_UP, &dev->flags)) {
-		mutex_lock(&lock);
-		dev->power = false;
-		null_del_dev(dev->nullb);
-		mutex_unlock(&lock);
-	}
-
-	config_item_put(item);
-}
-
-static ssize_t memb_group_features_show(struct config_item *item, char *page)
-{
-	return snprintf(page, PAGE_SIZE,
-			"memory_backed,discard,bandwidth,cache,badblocks,zoned,zone_size,zone_capacity,zone_nr_conv,zone_max_open,zone_max_active\n");
-}
-
-CONFIGFS_ATTR_RO(memb_group_, features);
-
-static struct configfs_attribute *nullb_group_attrs[] = {
-	&memb_group_attr_features,
-	NULL,
-};
-
-static struct configfs_group_operations nullb_group_ops = {
-	.make_item	= nullb_group_make_item,
-	.drop_item	= nullb_group_drop_item,
-};
-
-static const struct config_item_type nullb_group_type = {
-	.ct_group_ops	= &nullb_group_ops,
-	.ct_attrs	= nullb_group_attrs,
-	.ct_owner	= THIS_MODULE,
-};
-
-static struct configfs_subsystem nullb_subsys = {
-	.su_group = {
-		.cg_item = {
-			.ci_namebuf = "nullb",
-			.ci_type = &nullb_group_type,
-		},
-	},
-};
-
-static inline int null_cache_active(struct nullb *nullb)
-{
-	return test_bit(NULLB_DEV_FL_CACHE, &nullb->dev->flags);
-}
-
-static struct nullb_device *null_alloc_dev(void)
-{
-	struct nullb_device *dev;
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev)
-		return NULL;
-	INIT_RADIX_TREE(&dev->data, GFP_ATOMIC);
-	INIT_RADIX_TREE(&dev->cache, GFP_ATOMIC);
-	if (badblocks_init(&dev->badblocks, 0)) {
-		kfree(dev);
-		return NULL;
-	}
-
-	dev->size = g_gb * 1024;
-	dev->completion_nsec = g_completion_nsec;
-	dev->submit_queues = g_submit_queues;
-	dev->home_node = g_home_node;
-	dev->queue_mode = g_queue_mode;
-	dev->blocksize = g_bs;
-	dev->irqmode = g_irqmode;
-	dev->hw_queue_depth = g_hw_queue_depth;
-	dev->blocking = g_blocking;
-	dev->use_per_node_hctx = g_use_per_node_hctx;
-	dev->zoned = g_zoned;
-	dev->zone_size = g_zone_size;
-	dev->zone_capacity = g_zone_capacity;
-	dev->zone_nr_conv = g_zone_nr_conv;
-	dev->zone_max_open = g_zone_max_open;
-	dev->zone_max_active = g_zone_max_active;
-	return dev;
-}
-
-static void null_free_dev(struct nullb_device *dev)
-{
-	if (!dev)
-		return;
-
-	null_free_zoned_dev(dev);
-	badblocks_exit(&dev->badblocks);
-	kfree(dev);
-}
-
-static void put_tag(struct nullb_queue *nq, unsigned int tag)
-{
-	clear_bit_unlock(tag, nq->tag_map);
-
-	if (waitqueue_active(&nq->wait))
-		wake_up(&nq->wait);
-}
-
-static unsigned int get_tag(struct nullb_queue *nq)
-{
-	unsigned int tag;
-
-	do {
-		tag = find_first_zero_bit(nq->tag_map, nq->queue_depth);
-		if (tag >= nq->queue_depth)
-			return -1U;
-	} while (test_and_set_bit_lock(tag, nq->tag_map));
-
-	return tag;
-}
-
-static void free_cmd(struct nullb_cmd *cmd)
-{
-	put_tag(cmd->nq, cmd->tag);
-}
-
-static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer);
-
-static struct nullb_cmd *__alloc_cmd(struct nullb_queue *nq)
-{
-	struct nullb_cmd *cmd;
-	unsigned int tag;
-
-	tag = get_tag(nq);
-	if (tag != -1U) {
-		cmd = &nq->cmds[tag];
-		cmd->tag = tag;
-		cmd->error = BLK_STS_OK;
-		cmd->nq = nq;
-		if (nq->dev->irqmode == NULL_IRQ_TIMER) {
-			hrtimer_init(&cmd->timer, CLOCK_MONOTONIC,
-				     HRTIMER_MODE_REL);
-			cmd->timer.function = null_cmd_timer_expired;
-		}
-		return cmd;
-	}
-
-	return NULL;
-}
-
-static struct nullb_cmd *alloc_cmd(struct nullb_queue *nq, int can_wait)
-{
-	struct nullb_cmd *cmd;
-	DEFINE_WAIT(wait);
-
-	cmd = __alloc_cmd(nq);
-	if (cmd || !can_wait)
-		return cmd;
-
-	do {
-		prepare_to_wait(&nq->wait, &wait, TASK_UNINTERRUPTIBLE);
-		cmd = __alloc_cmd(nq);
-		if (cmd)
-			break;
-
-		io_schedule();
-	} while (1);
-
-	finish_wait(&nq->wait, &wait);
-	return cmd;
-}
-
-static void end_cmd(struct nullb_cmd *cmd)
-{
-	int queue_mode = cmd->nq->dev->queue_mode;
-
-	switch (queue_mode)  {
-	case NULL_Q_MQ:
-		blk_mq_end_request(cmd->rq, cmd->error);
-		return;
-	case NULL_Q_BIO:
-		cmd->bio->bi_status = cmd->error;
-		bio_endio(cmd->bio);
-		break;
-	}
-
-	free_cmd(cmd);
-}
-
-static enum hrtimer_restart null_cmd_timer_expired(struct hrtimer *timer)
-{
-	end_cmd(container_of(timer, struct nullb_cmd, timer));
-
-	return HRTIMER_NORESTART;
-}
-
-static void null_cmd_end_timer(struct nullb_cmd *cmd)
-{
-	ktime_t kt = cmd->nq->dev->completion_nsec;
-
-	hrtimer_start(&cmd->timer, kt, HRTIMER_MODE_REL);
-}
-
-static void null_complete_rq(struct request *rq)
-{
-	end_cmd(blk_mq_rq_to_pdu(rq));
-}
-
-static struct nullb_page *null_alloc_page(gfp_t gfp_flags)
-{
-	struct nullb_page *t_page;
-
-	t_page = kmalloc(sizeof(struct nullb_page), gfp_flags);
-	if (!t_page)
-		goto out;
-
-	t_page->page = alloc_pages(gfp_flags, 0);
-	if (!t_page->page)
-		goto out_freepage;
-
-	memset(t_page->bitmap, 0, sizeof(t_page->bitmap));
-	return t_page;
-out_freepage:
-	kfree(t_page);
-out:
-	return NULL;
-}
-
-static void null_free_page(struct nullb_page *t_page)
-{
-	__set_bit(NULLB_PAGE_FREE, t_page->bitmap);
-	if (test_bit(NULLB_PAGE_LOCK, t_page->bitmap))
-		return;
-	__free_page(t_page->page);
-	kfree(t_page);
-}
-
-static bool null_page_empty(struct nullb_page *page)
-{
-	int size = MAP_SZ - 2;
-
-	return find_first_bit(page->bitmap, size) == size;
-}
-
-static void null_free_sector(struct nullb *nullb, sector_t sector,
-	bool is_cache)
-{
-	unsigned int sector_bit;
-	u64 idx;
-	struct nullb_page *t_page, *ret;
-	struct radix_tree_root *root;
-
-	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
-	idx = sector >> PAGE_SECTORS_SHIFT;
-	sector_bit = (sector & SECTOR_MASK);
-
-	t_page = radix_tree_lookup(root, idx);
-	if (t_page) {
-		__clear_bit(sector_bit, t_page->bitmap);
-
-		if (null_page_empty(t_page)) {
-			ret = radix_tree_delete_item(root, idx, t_page);
-			WARN_ON(ret != t_page);
-			null_free_page(ret);
-			if (is_cache)
-				nullb->dev->curr_cache -= PAGE_SIZE;
-		}
-	}
-}
-
-static struct nullb_page *null_radix_tree_insert(struct nullb *nullb, u64 idx,
-	struct nullb_page *t_page, bool is_cache)
-{
-	struct radix_tree_root *root;
-
-	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
-
-	if (radix_tree_insert(root, idx, t_page)) {
-		null_free_page(t_page);
-		t_page = radix_tree_lookup(root, idx);
-		WARN_ON(!t_page || t_page->page->index != idx);
-	} else if (is_cache)
-		nullb->dev->curr_cache += PAGE_SIZE;
-
-	return t_page;
-}
-
-static void null_free_device_storage(struct nullb_device *dev, bool is_cache)
-{
-	unsigned long pos = 0;
-	int nr_pages;
-	struct nullb_page *ret, *t_pages[FREE_BATCH];
-	struct radix_tree_root *root;
-
-	root = is_cache ? &dev->cache : &dev->data;
-
-	do {
-		int i;
-
-		nr_pages = radix_tree_gang_lookup(root,
-				(void **)t_pages, pos, FREE_BATCH);
-
-		for (i = 0; i < nr_pages; i++) {
-			pos = t_pages[i]->page->index;
-			ret = radix_tree_delete_item(root, pos, t_pages[i]);
-			WARN_ON(ret != t_pages[i]);
-			null_free_page(ret);
-		}
-
-		pos++;
-	} while (nr_pages == FREE_BATCH);
-
-	if (is_cache)
-		dev->curr_cache = 0;
-}
-
-static struct nullb_page *__null_lookup_page(struct nullb *nullb,
-	sector_t sector, bool for_write, bool is_cache)
-{
-	unsigned int sector_bit;
-	u64 idx;
-	struct nullb_page *t_page;
-	struct radix_tree_root *root;
-
-	idx = sector >> PAGE_SECTORS_SHIFT;
-	sector_bit = (sector & SECTOR_MASK);
-
-	root = is_cache ? &nullb->dev->cache : &nullb->dev->data;
-	t_page = radix_tree_lookup(root, idx);
-	WARN_ON(t_page && t_page->page->index != idx);
-
-	if (t_page && (for_write || test_bit(sector_bit, t_page->bitmap)))
-		return t_page;
-
-	return NULL;
-}
-
-static struct nullb_page *null_lookup_page(struct nullb *nullb,
-	sector_t sector, bool for_write, bool ignore_cache)
-{
-	struct nullb_page *page = NULL;
-
-	if (!ignore_cache)
-		page = __null_lookup_page(nullb, sector, for_write, true);
-	if (page)
-		return page;
-	return __null_lookup_page(nullb, sector, for_write, false);
-}
-
-static struct nullb_page *null_insert_page(struct nullb *nullb,
-					   sector_t sector, bool ignore_cache)
-	__releases(&nullb->lock)
-	__acquires(&nullb->lock)
-{
-	u64 idx;
-	struct nullb_page *t_page;
-
-	t_page = null_lookup_page(nullb, sector, true, ignore_cache);
-	if (t_page)
-		return t_page;
-
-	spin_unlock_irq(&nullb->lock);
-
-	t_page = null_alloc_page(GFP_NOIO);
-	if (!t_page)
-		goto out_lock;
-
-	if (radix_tree_preload(GFP_NOIO))
-		goto out_freepage;
-
-	spin_lock_irq(&nullb->lock);
-	idx = sector >> PAGE_SECTORS_SHIFT;
-	t_page->page->index = idx;
-	t_page = null_radix_tree_insert(nullb, idx, t_page, !ignore_cache);
-	radix_tree_preload_end();
-
-	return t_page;
-out_freepage:
-	null_free_page(t_page);
-out_lock:
-	spin_lock_irq(&nullb->lock);
-	return null_lookup_page(nullb, sector, true, ignore_cache);
-}
-
-static int null_flush_cache_page(struct nullb *nullb, struct nullb_page *c_page)
-{
-	int i;
-	unsigned int offset;
-	u64 idx;
-	struct nullb_page *t_page, *ret;
-	void *dst, *src;
-
-	idx = c_page->page->index;
-
-	t_page = null_insert_page(nullb, idx << PAGE_SECTORS_SHIFT, true);
-
-	__clear_bit(NULLB_PAGE_LOCK, c_page->bitmap);
-	if (test_bit(NULLB_PAGE_FREE, c_page->bitmap)) {
-		null_free_page(c_page);
-		if (t_page && null_page_empty(t_page)) {
-			ret = radix_tree_delete_item(&nullb->dev->data,
-				idx, t_page);
-			null_free_page(t_page);
-		}
-		return 0;
-	}
-
-	if (!t_page)
-		return -ENOMEM;
-
-	src = kmap_atomic(c_page->page);
-	dst = kmap_atomic(t_page->page);
-
-	for (i = 0; i < PAGE_SECTORS;
-			i += (nullb->dev->blocksize >> SECTOR_SHIFT)) {
-		if (test_bit(i, c_page->bitmap)) {
-			offset = (i << SECTOR_SHIFT);
-			memcpy(dst + offset, src + offset,
-				nullb->dev->blocksize);
-			__set_bit(i, t_page->bitmap);
-		}
-	}
-
-	kunmap_atomic(dst);
-	kunmap_atomic(src);
-
-	ret = radix_tree_delete_item(&nullb->dev->cache, idx, c_page);
-	null_free_page(ret);
-	nullb->dev->curr_cache -= PAGE_SIZE;
-
-	return 0;
-}
-
-static int null_make_cache_space(struct nullb *nullb, unsigned long n)
-{
-	int i, err, nr_pages;
-	struct nullb_page *c_pages[FREE_BATCH];
-	unsigned long flushed = 0, one_round;
-
-again:
-	if ((nullb->dev->cache_size * 1024 * 1024) >
-	     nullb->dev->curr_cache + n || nullb->dev->curr_cache == 0)
-		return 0;
-
-	nr_pages = radix_tree_gang_lookup(&nullb->dev->cache,
-			(void **)c_pages, nullb->cache_flush_pos, FREE_BATCH);
-	/*
-	 * nullb_flush_cache_page could unlock before using the c_pages. To
-	 * avoid race, we don't allow page free
-	 */
-	for (i = 0; i < nr_pages; i++) {
-		nullb->cache_flush_pos = c_pages[i]->page->index;
-		/*
-		 * We found the page which is being flushed to disk by other
-		 * threads
-		 */
-		if (test_bit(NULLB_PAGE_LOCK, c_pages[i]->bitmap))
-			c_pages[i] = NULL;
-		else
-			__set_bit(NULLB_PAGE_LOCK, c_pages[i]->bitmap);
-	}
-
-	one_round = 0;
-	for (i = 0; i < nr_pages; i++) {
-		if (c_pages[i] == NULL)
-			continue;
-		err = null_flush_cache_page(nullb, c_pages[i]);
-		if (err)
-			return err;
-		one_round++;
-	}
-	flushed += one_round << PAGE_SHIFT;
-
-	if (n > flushed) {
-		if (nr_pages == 0)
-			nullb->cache_flush_pos = 0;
-		if (one_round == 0) {
-			/* give other threads a chance */
-			spin_unlock_irq(&nullb->lock);
-			spin_lock_irq(&nullb->lock);
-		}
-		goto again;
-	}
-	return 0;
-}
-
-static int copy_to_nullb(struct nullb *nullb, struct page *source,
-	unsigned int off, sector_t sector, size_t n, bool is_fua)
-{
-	size_t temp, count = 0;
-	unsigned int offset;
-	struct nullb_page *t_page;
-	void *dst, *src;
-
-	while (count < n) {
-		temp = min_t(size_t, nullb->dev->blocksize, n - count);
-
-		if (null_cache_active(nullb) && !is_fua)
-			null_make_cache_space(nullb, PAGE_SIZE);
-
-		offset = (sector & SECTOR_MASK) << SECTOR_SHIFT;
-		t_page = null_insert_page(nullb, sector,
-			!null_cache_active(nullb) || is_fua);
-		if (!t_page)
-			return -ENOSPC;
-
-		src = kmap_atomic(source);
-		dst = kmap_atomic(t_page->page);
-		memcpy(dst + offset, src + off + count, temp);
-		kunmap_atomic(dst);
-		kunmap_atomic(src);
-
-		__set_bit(sector & SECTOR_MASK, t_page->bitmap);
-
-		if (is_fua)
-			null_free_sector(nullb, sector, true);
-
-		count += temp;
-		sector += temp >> SECTOR_SHIFT;
-	}
-	return 0;
-}
-
-static int copy_from_nullb(struct nullb *nullb, struct page *dest,
-	unsigned int off, sector_t sector, size_t n)
-{
-	size_t temp, count = 0;
-	unsigned int offset;
-	struct nullb_page *t_page;
-	void *dst, *src;
-
-	while (count < n) {
-		temp = min_t(size_t, nullb->dev->blocksize, n - count);
-
-		offset = (sector & SECTOR_MASK) << SECTOR_SHIFT;
-		t_page = null_lookup_page(nullb, sector, false,
-			!null_cache_active(nullb));
-
-		dst = kmap_atomic(dest);
-		if (!t_page) {
-			memset(dst + off + count, 0, temp);
-			goto next;
-		}
-		src = kmap_atomic(t_page->page);
-		memcpy(dst + off + count, src + offset, temp);
-		kunmap_atomic(src);
-next:
-		kunmap_atomic(dst);
-
-		count += temp;
-		sector += temp >> SECTOR_SHIFT;
-	}
-	return 0;
-}
-
-static void nullb_fill_pattern(struct nullb *nullb, struct page *page,
-			       unsigned int len, unsigned int off)
-{
-	void *dst;
-
-	dst = kmap_atomic(page);
-	memset(dst + off, 0xFF, len);
-	kunmap_atomic(dst);
-}
-
-static void null_handle_discard(struct nullb *nullb, sector_t sector, size_t n)
-{
-	size_t temp;
-
-	spin_lock_irq(&nullb->lock);
-	while (n > 0) {
-		temp = min_t(size_t, n, nullb->dev->blocksize);
-		null_free_sector(nullb, sector, false);
-		if (null_cache_active(nullb))
-			null_free_sector(nullb, sector, true);
-		sector += temp >> SECTOR_SHIFT;
-		n -= temp;
-	}
-	spin_unlock_irq(&nullb->lock);
-}
-
-static int null_handle_flush(struct nullb *nullb)
-{
-	int err;
-
-	if (!null_cache_active(nullb))
-		return 0;
-
-	spin_lock_irq(&nullb->lock);
-	while (true) {
-		err = null_make_cache_space(nullb,
-			nullb->dev->cache_size * 1024 * 1024);
-		if (err || nullb->dev->curr_cache == 0)
-			break;
-	}
-
-	WARN_ON(!radix_tree_empty(&nullb->dev->cache));
-	spin_unlock_irq(&nullb->lock);
-	return err;
-}
-
-static int null_transfer(struct nullb *nullb, struct page *page,
-	unsigned int len, unsigned int off, bool is_write, sector_t sector,
-	bool is_fua)
-{
-	struct nullb_device *dev = nullb->dev;
-	unsigned int valid_len = len;
-	int err = 0;
-
-	if (!is_write) {
-		if (dev->zoned)
-			valid_len = null_zone_valid_read_len(nullb,
-				sector, len);
-
-		if (valid_len) {
-			err = copy_from_nullb(nullb, page, off,
-				sector, valid_len);
-			off += valid_len;
-			len -= valid_len;
-		}
-
-		if (len)
-			nullb_fill_pattern(nullb, page, len, off);
-		flush_dcache_page(page);
-	} else {
-		flush_dcache_page(page);
-		err = copy_to_nullb(nullb, page, off, sector, len, is_fua);
-	}
-
-	return err;
-}
-
-static int null_handle_rq(struct nullb_cmd *cmd)
-{
-	struct request *rq = cmd->rq;
-	struct nullb *nullb = cmd->nq->dev->nullb;
-	int err;
-	unsigned int len;
-	sector_t sector;
-	struct req_iterator iter;
-	struct bio_vec bvec;
-
-	sector = blk_rq_pos(rq);
-
-	if (req_op(rq) == REQ_OP_DISCARD) {
-		null_handle_discard(nullb, sector, blk_rq_bytes(rq));
-		return 0;
-	}
-
-	spin_lock_irq(&nullb->lock);
-	rq_for_each_segment(bvec, rq, iter) {
-		len = bvec.bv_len;
-		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
-				     op_is_write(req_op(rq)), sector,
-				     rq->cmd_flags & REQ_FUA);
-		if (err) {
-			spin_unlock_irq(&nullb->lock);
-			return err;
-		}
-		sector += len >> SECTOR_SHIFT;
-	}
-	spin_unlock_irq(&nullb->lock);
-
-	return 0;
-}
-
-static int null_handle_bio(struct nullb_cmd *cmd)
-{
-	struct bio *bio = cmd->bio;
-	struct nullb *nullb = cmd->nq->dev->nullb;
-	int err;
-	unsigned int len;
-	sector_t sector;
-	struct bio_vec bvec;
-	struct bvec_iter iter;
-
-	sector = bio->bi_iter.bi_sector;
-
-	if (bio_op(bio) == REQ_OP_DISCARD) {
-		null_handle_discard(nullb, sector,
-			bio_sectors(bio) << SECTOR_SHIFT);
-		return 0;
-	}
-
-	spin_lock_irq(&nullb->lock);
-	bio_for_each_segment(bvec, bio, iter) {
-		len = bvec.bv_len;
-		err = null_transfer(nullb, bvec.bv_page, len, bvec.bv_offset,
-				     op_is_write(bio_op(bio)), sector,
-				     bio->bi_opf & REQ_FUA);
-		if (err) {
-			spin_unlock_irq(&nullb->lock);
-			return err;
-		}
-		sector += len >> SECTOR_SHIFT;
-	}
-	spin_unlock_irq(&nullb->lock);
-	return 0;
-}
-
-static void null_stop_queue(struct nullb *nullb)
-{
-	struct request_queue *q = nullb->q;
-
-	if (nullb->dev->queue_mode == NULL_Q_MQ)
-		blk_mq_stop_hw_queues(q);
-}
-
-static void null_restart_queue_async(struct nullb *nullb)
-{
-	struct request_queue *q = nullb->q;
-
-	if (nullb->dev->queue_mode == NULL_Q_MQ)
-		blk_mq_start_stopped_hw_queues(q, true);
-}
-
-static inline blk_status_t null_handle_throttled(struct nullb_cmd *cmd)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	struct nullb *nullb = dev->nullb;
-	blk_status_t sts = BLK_STS_OK;
-	struct request *rq = cmd->rq;
-
-	if (!hrtimer_active(&nullb->bw_timer))
-		hrtimer_restart(&nullb->bw_timer);
-
-	if (atomic_long_sub_return(blk_rq_bytes(rq), &nullb->cur_bytes) < 0) {
-		null_stop_queue(nullb);
-		/* race with timer */
-		if (atomic_long_read(&nullb->cur_bytes) > 0)
-			null_restart_queue_async(nullb);
-		/* requeue request */
-		sts = BLK_STS_DEV_RESOURCE;
-	}
-	return sts;
-}
-
-static inline blk_status_t null_handle_badblocks(struct nullb_cmd *cmd,
-						 sector_t sector,
-						 sector_t nr_sectors)
-{
-	struct badblocks *bb = &cmd->nq->dev->badblocks;
-	sector_t first_bad;
-	int bad_sectors;
-
-	if (badblocks_check(bb, sector, nr_sectors, &first_bad, &bad_sectors))
-		return BLK_STS_IOERR;
-
-	return BLK_STS_OK;
-}
-
-static inline blk_status_t null_handle_memory_backed(struct nullb_cmd *cmd,
-						     enum req_opf op)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	int err;
-
-	if (dev->queue_mode == NULL_Q_BIO)
-		err = null_handle_bio(cmd);
-	else
-		err = null_handle_rq(cmd);
-
-	return errno_to_blk_status(err);
-}
-
-static void nullb_zero_read_cmd_buffer(struct nullb_cmd *cmd)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	struct bio *bio;
-
-	if (dev->memory_backed)
-		return;
-
-	if (dev->queue_mode == NULL_Q_BIO && bio_op(cmd->bio) == REQ_OP_READ) {
-		zero_fill_bio(cmd->bio);
-	} else if (req_op(cmd->rq) == REQ_OP_READ) {
-		__rq_for_each_bio(bio, cmd->rq)
-			zero_fill_bio(bio);
-	}
-}
-
-static inline void nullb_complete_cmd(struct nullb_cmd *cmd)
-{
-	/*
-	 * Since root privileges are required to configure the null_blk
-	 * driver, it is fine that this driver does not initialize the
-	 * data buffers of read commands. Zero-initialize these buffers
-	 * anyway if KMSAN is enabled to prevent that KMSAN complains
-	 * about null_blk not initializing read data buffers.
-	 */
-	if (IS_ENABLED(CONFIG_KMSAN))
-		nullb_zero_read_cmd_buffer(cmd);
-
-	/* Complete IO by inline, softirq or timer */
-	switch (cmd->nq->dev->irqmode) {
-	case NULL_IRQ_SOFTIRQ:
-		switch (cmd->nq->dev->queue_mode) {
-		case NULL_Q_MQ:
-			if (likely(!blk_should_fake_timeout(cmd->rq->q)))
-				blk_mq_complete_request(cmd->rq);
-			break;
-		case NULL_Q_BIO:
-			/*
-			 * XXX: no proper submitting cpu information available.
-			 */
-			end_cmd(cmd);
-			break;
-		}
-		break;
-	case NULL_IRQ_NONE:
-		end_cmd(cmd);
-		break;
-	case NULL_IRQ_TIMER:
-		null_cmd_end_timer(cmd);
-		break;
-	}
-}
-
-blk_status_t null_process_cmd(struct nullb_cmd *cmd,
-			      enum req_opf op, sector_t sector,
-			      unsigned int nr_sectors)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	blk_status_t ret;
-
-	if (dev->badblocks.shift != -1) {
-		ret = null_handle_badblocks(cmd, sector, nr_sectors);
-		if (ret != BLK_STS_OK)
-			return ret;
-	}
-
-	if (dev->memory_backed)
-		return null_handle_memory_backed(cmd, op);
-
-	return BLK_STS_OK;
-}
-
-static blk_status_t null_handle_cmd(struct nullb_cmd *cmd, sector_t sector,
-				    sector_t nr_sectors, enum req_opf op)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	struct nullb *nullb = dev->nullb;
-	blk_status_t sts;
-
-	if (test_bit(NULLB_DEV_FL_THROTTLED, &dev->flags)) {
-		sts = null_handle_throttled(cmd);
-		if (sts != BLK_STS_OK)
-			return sts;
-	}
-
-	if (op == REQ_OP_FLUSH) {
-		cmd->error = errno_to_blk_status(null_handle_flush(nullb));
-		goto out;
-	}
-
-	if (dev->zoned)
-		sts = null_process_zoned_cmd(cmd, op, sector, nr_sectors);
-	else
-		sts = null_process_cmd(cmd, op, sector, nr_sectors);
-
-	/* Do not overwrite errors (e.g. timeout errors) */
-	if (cmd->error == BLK_STS_OK)
-		cmd->error = sts;
-
-out:
-	nullb_complete_cmd(cmd);
-	return BLK_STS_OK;
-}
-
-static enum hrtimer_restart nullb_bwtimer_fn(struct hrtimer *timer)
-{
-	struct nullb *nullb = container_of(timer, struct nullb, bw_timer);
-	ktime_t timer_interval = ktime_set(0, TIMER_INTERVAL);
-	unsigned int mbps = nullb->dev->mbps;
-
-	if (atomic_long_read(&nullb->cur_bytes) == mb_per_tick(mbps))
-		return HRTIMER_NORESTART;
-
-	atomic_long_set(&nullb->cur_bytes, mb_per_tick(mbps));
-	null_restart_queue_async(nullb);
-
-	hrtimer_forward_now(&nullb->bw_timer, timer_interval);
-
-	return HRTIMER_RESTART;
-}
-
-static void nullb_setup_bwtimer(struct nullb *nullb)
-{
-	ktime_t timer_interval = ktime_set(0, TIMER_INTERVAL);
-
-	hrtimer_init(&nullb->bw_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	nullb->bw_timer.function = nullb_bwtimer_fn;
-	atomic_long_set(&nullb->cur_bytes, mb_per_tick(nullb->dev->mbps));
-	hrtimer_start(&nullb->bw_timer, timer_interval, HRTIMER_MODE_REL);
-}
-
-static struct nullb_queue *nullb_to_queue(struct nullb *nullb)
-{
-	int index = 0;
-
-	if (nullb->nr_queues != 1)
-		index = raw_smp_processor_id() / ((nr_cpu_ids + nullb->nr_queues - 1) / nullb->nr_queues);
-
-	return &nullb->queues[index];
-}
-
-static blk_qc_t null_submit_bio(struct bio *bio)
-{
-	sector_t sector = bio->bi_iter.bi_sector;
-	sector_t nr_sectors = bio_sectors(bio);
-	struct nullb *nullb = bio->bi_disk->private_data;
-	struct nullb_queue *nq = nullb_to_queue(nullb);
-	struct nullb_cmd *cmd;
-
-	cmd = alloc_cmd(nq, 1);
-	cmd->bio = bio;
-
-	null_handle_cmd(cmd, sector, nr_sectors, bio_op(bio));
-	return BLK_QC_T_NONE;
-}
-
-static bool should_timeout_request(struct request *rq)
-{
-#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
-	if (g_timeout_str[0])
-		return should_fail(&null_timeout_attr, 1);
-#endif
-	return false;
-}
-
-static bool should_requeue_request(struct request *rq)
-{
-#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
-	if (g_requeue_str[0])
-		return should_fail(&null_requeue_attr, 1);
-#endif
-	return false;
-}
-
-static enum blk_eh_timer_return null_timeout_rq(struct request *rq, bool res)
-{
-	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(rq);
-
-	pr_info("rq %p timed out\n", rq);
-
-	/*
-	 * If the device is marked as blocking (i.e. memory backed or zoned
-	 * device), the submission path may be blocked waiting for resources
-	 * and cause real timeouts. For these real timeouts, the submission
-	 * path will complete the request using blk_mq_complete_request().
-	 * Only fake timeouts need to execute blk_mq_complete_request() here.
-	 */
-	cmd->error = BLK_STS_TIMEOUT;
-	if (cmd->fake_timeout)
-		blk_mq_complete_request(rq);
-	return BLK_EH_DONE;
-}
-
-static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
-			 const struct blk_mq_queue_data *bd)
-{
-	struct nullb_cmd *cmd = blk_mq_rq_to_pdu(bd->rq);
-	struct nullb_queue *nq = hctx->driver_data;
-	sector_t nr_sectors = blk_rq_sectors(bd->rq);
-	sector_t sector = blk_rq_pos(bd->rq);
-
-	might_sleep_if(hctx->flags & BLK_MQ_F_BLOCKING);
-
-	if (nq->dev->irqmode == NULL_IRQ_TIMER) {
-		hrtimer_init(&cmd->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-		cmd->timer.function = null_cmd_timer_expired;
-	}
-	cmd->rq = bd->rq;
-	cmd->error = BLK_STS_OK;
-	cmd->nq = nq;
-	cmd->fake_timeout = should_timeout_request(bd->rq);
-
-	blk_mq_start_request(bd->rq);
-
-	if (should_requeue_request(bd->rq)) {
-		/*
-		 * Alternate between hitting the core BUSY path, and the
-		 * driver driven requeue path
-		 */
-		nq->requeue_selection++;
-		if (nq->requeue_selection & 1)
-			return BLK_STS_RESOURCE;
-		else {
-			blk_mq_requeue_request(bd->rq, true);
-			return BLK_STS_OK;
-		}
-	}
-	if (cmd->fake_timeout)
-		return BLK_STS_OK;
-
-	return null_handle_cmd(cmd, sector, nr_sectors, req_op(bd->rq));
-}
-
-static void cleanup_queue(struct nullb_queue *nq)
-{
-	kfree(nq->tag_map);
-	kfree(nq->cmds);
-}
-
-static void cleanup_queues(struct nullb *nullb)
-{
-	int i;
-
-	for (i = 0; i < nullb->nr_queues; i++)
-		cleanup_queue(&nullb->queues[i]);
-
-	kfree(nullb->queues);
-}
-
-static void null_exit_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
-{
-	struct nullb_queue *nq = hctx->driver_data;
-	struct nullb *nullb = nq->dev->nullb;
-
-	nullb->nr_queues--;
-}
-
-static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
-{
-	init_waitqueue_head(&nq->wait);
-	nq->queue_depth = nullb->queue_depth;
-	nq->dev = nullb->dev;
-}
-
-static int null_init_hctx(struct blk_mq_hw_ctx *hctx, void *driver_data,
-			  unsigned int hctx_idx)
-{
-	struct nullb *nullb = hctx->queue->queuedata;
-	struct nullb_queue *nq;
-
-#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
-	if (g_init_hctx_str[0] && should_fail(&null_init_hctx_attr, 1))
-		return -EFAULT;
-#endif
-
-	nq = &nullb->queues[hctx_idx];
-	hctx->driver_data = nq;
-	null_init_queue(nullb, nq);
-	nullb->nr_queues++;
-
-	return 0;
-}
-
-static const struct blk_mq_ops null_mq_ops = {
-	.queue_rq       = null_queue_rq,
-	.complete	= null_complete_rq,
-	.timeout	= null_timeout_rq,
-	.init_hctx	= null_init_hctx,
-	.exit_hctx	= null_exit_hctx,
-};
-
-static void null_del_dev(struct nullb *nullb)
-{
-	struct nullb_device *dev;
-
-	if (!nullb)
-		return;
-
-	dev = nullb->dev;
-
-	ida_simple_remove(&nullb_indexes, nullb->index);
-
-	list_del_init(&nullb->list);
-
-	del_gendisk(nullb->disk);
-
-	if (test_bit(NULLB_DEV_FL_THROTTLED, &nullb->dev->flags)) {
-		hrtimer_cancel(&nullb->bw_timer);
-		atomic_long_set(&nullb->cur_bytes, LONG_MAX);
-		null_restart_queue_async(nullb);
-	}
-
-	blk_cleanup_queue(nullb->q);
-	if (dev->queue_mode == NULL_Q_MQ &&
-	    nullb->tag_set == &nullb->__tag_set)
-		blk_mq_free_tag_set(nullb->tag_set);
-	put_disk(nullb->disk);
-	cleanup_queues(nullb);
-	if (null_cache_active(nullb))
-		null_free_device_storage(nullb->dev, true);
-	kfree(nullb);
-	dev->nullb = NULL;
-}
-
-static void null_config_discard(struct nullb *nullb)
-{
-	if (nullb->dev->discard == false)
-		return;
-
-	if (nullb->dev->zoned) {
-		nullb->dev->discard = false;
-		pr_info("discard option is ignored in zoned mode\n");
-		return;
-	}
-
-	nullb->q->limits.discard_granularity = nullb->dev->blocksize;
-	nullb->q->limits.discard_alignment = nullb->dev->blocksize;
-	blk_queue_max_discard_sectors(nullb->q, UINT_MAX >> 9);
-	blk_queue_flag_set(QUEUE_FLAG_DISCARD, nullb->q);
-}
-
-static const struct block_device_operations null_bio_ops = {
-	.owner		= THIS_MODULE,
-	.submit_bio	= null_submit_bio,
-	.report_zones	= null_report_zones,
-};
-
-static const struct block_device_operations null_rq_ops = {
-	.owner		= THIS_MODULE,
-	.report_zones	= null_report_zones,
-};
-
-static int setup_commands(struct nullb_queue *nq)
-{
-	struct nullb_cmd *cmd;
-	int i, tag_size;
-
-	nq->cmds = kcalloc(nq->queue_depth, sizeof(*cmd), GFP_KERNEL);
-	if (!nq->cmds)
-		return -ENOMEM;
-
-	tag_size = ALIGN(nq->queue_depth, BITS_PER_LONG) / BITS_PER_LONG;
-	nq->tag_map = kcalloc(tag_size, sizeof(unsigned long), GFP_KERNEL);
-	if (!nq->tag_map) {
-		kfree(nq->cmds);
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < nq->queue_depth; i++) {
-		cmd = &nq->cmds[i];
-		cmd->tag = -1U;
-	}
-
-	return 0;
-}
-
-static int setup_queues(struct nullb *nullb)
-{
-	nullb->queues = kcalloc(nr_cpu_ids, sizeof(struct nullb_queue),
-				GFP_KERNEL);
-	if (!nullb->queues)
-		return -ENOMEM;
-
-	nullb->queue_depth = nullb->dev->hw_queue_depth;
-
-	return 0;
-}
-
-static int init_driver_queues(struct nullb *nullb)
-{
-	struct nullb_queue *nq;
-	int i, ret = 0;
-
-	for (i = 0; i < nullb->dev->submit_queues; i++) {
-		nq = &nullb->queues[i];
-
-		null_init_queue(nullb, nq);
-
-		ret = setup_commands(nq);
-		if (ret)
-			return ret;
-		nullb->nr_queues++;
-	}
-	return 0;
-}
-
-static int null_gendisk_register(struct nullb *nullb)
-{
-	sector_t size = ((sector_t)nullb->dev->size * SZ_1M) >> SECTOR_SHIFT;
-	struct gendisk *disk;
-
-	disk = nullb->disk = alloc_disk_node(1, nullb->dev->home_node);
-	if (!disk)
-		return -ENOMEM;
-	set_capacity(disk, size);
-
-	disk->flags |= GENHD_FL_EXT_DEVT | GENHD_FL_SUPPRESS_PARTITION_INFO;
-	disk->major		= null_major;
-	disk->first_minor	= nullb->index;
-	if (queue_is_mq(nullb->q))
-		disk->fops		= &null_rq_ops;
-	else
-		disk->fops		= &null_bio_ops;
-	disk->private_data	= nullb;
-	disk->queue		= nullb->q;
-	strncpy(disk->disk_name, nullb->disk_name, DISK_NAME_LEN);
-
-	if (nullb->dev->zoned) {
-		int ret = null_register_zoned_dev(nullb);
-
-		if (ret)
-			return ret;
-	}
-
-	add_disk(disk);
-	return 0;
-}
-
-static int null_init_tag_set(struct nullb *nullb, struct blk_mq_tag_set *set)
-{
-	set->ops = &null_mq_ops;
-	set->nr_hw_queues = nullb ? nullb->dev->submit_queues :
-						g_submit_queues;
-	set->queue_depth = nullb ? nullb->dev->hw_queue_depth :
-						g_hw_queue_depth;
-	set->numa_node = nullb ? nullb->dev->home_node : g_home_node;
-	set->cmd_size	= sizeof(struct nullb_cmd);
-	set->flags = BLK_MQ_F_SHOULD_MERGE;
-	if (g_no_sched)
-		set->flags |= BLK_MQ_F_NO_SCHED;
-	if (g_shared_tag_bitmap)
-		set->flags |= BLK_MQ_F_TAG_HCTX_SHARED;
-	set->driver_data = NULL;
-
-	if ((nullb && nullb->dev->blocking) || g_blocking)
-		set->flags |= BLK_MQ_F_BLOCKING;
-
-	return blk_mq_alloc_tag_set(set);
-}
-
-static int null_validate_conf(struct nullb_device *dev)
-{
-	dev->blocksize = round_down(dev->blocksize, 512);
-	dev->blocksize = clamp_t(unsigned int, dev->blocksize, 512, 4096);
-
-	if (dev->queue_mode == NULL_Q_MQ && dev->use_per_node_hctx) {
-		if (dev->submit_queues != nr_online_nodes)
-			dev->submit_queues = nr_online_nodes;
-	} else if (dev->submit_queues > nr_cpu_ids)
-		dev->submit_queues = nr_cpu_ids;
-	else if (dev->submit_queues == 0)
-		dev->submit_queues = 1;
-
-	dev->queue_mode = min_t(unsigned int, dev->queue_mode, NULL_Q_MQ);
-	dev->irqmode = min_t(unsigned int, dev->irqmode, NULL_IRQ_TIMER);
-
-	/* Do memory allocation, so set blocking */
-	if (dev->memory_backed)
-		dev->blocking = true;
-	else /* cache is meaningless */
-		dev->cache_size = 0;
-	dev->cache_size = min_t(unsigned long, ULONG_MAX / 1024 / 1024,
-						dev->cache_size);
-	dev->mbps = min_t(unsigned int, 1024 * 40, dev->mbps);
-	/* can not stop a queue */
-	if (dev->queue_mode == NULL_Q_BIO)
-		dev->mbps = 0;
-
-	if (dev->zoned &&
-	    (!dev->zone_size || !is_power_of_2(dev->zone_size))) {
-		pr_err("zone_size must be power-of-two\n");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
-static bool __null_setup_fault(struct fault_attr *attr, char *str)
-{
-	if (!str[0])
-		return true;
-
-	if (!setup_fault_attr(attr, str))
-		return false;
-
-	attr->verbose = 0;
-	return true;
-}
-#endif
-
-static bool null_setup_fault(void)
-{
-#ifdef CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION
-	if (!__null_setup_fault(&null_timeout_attr, g_timeout_str))
-		return false;
-	if (!__null_setup_fault(&null_requeue_attr, g_requeue_str))
-		return false;
-	if (!__null_setup_fault(&null_init_hctx_attr, g_init_hctx_str))
-		return false;
-#endif
-	return true;
-}
-
-static int null_add_dev(struct nullb_device *dev)
-{
-	struct nullb *nullb;
-	int rv;
-
-	rv = null_validate_conf(dev);
-	if (rv)
-		return rv;
-
-	nullb = kzalloc_node(sizeof(*nullb), GFP_KERNEL, dev->home_node);
-	if (!nullb) {
-		rv = -ENOMEM;
-		goto out;
-	}
-	nullb->dev = dev;
-	dev->nullb = nullb;
-
-	spin_lock_init(&nullb->lock);
-
-	rv = setup_queues(nullb);
-	if (rv)
-		goto out_free_nullb;
-
-	if (dev->queue_mode == NULL_Q_MQ) {
-		if (shared_tags) {
-			nullb->tag_set = &tag_set;
-			rv = 0;
-		} else {
-			nullb->tag_set = &nullb->__tag_set;
-			rv = null_init_tag_set(nullb, nullb->tag_set);
-		}
-
-		if (rv)
-			goto out_cleanup_queues;
-
-		if (!null_setup_fault())
-			goto out_cleanup_queues;
-
-		nullb->tag_set->timeout = 5 * HZ;
-		nullb->q = blk_mq_init_queue_data(nullb->tag_set, nullb);
-		if (IS_ERR(nullb->q)) {
-			rv = -ENOMEM;
-			goto out_cleanup_tags;
-		}
-	} else if (dev->queue_mode == NULL_Q_BIO) {
-		nullb->q = blk_alloc_queue(dev->home_node);
-		if (!nullb->q) {
-			rv = -ENOMEM;
-			goto out_cleanup_queues;
-		}
-		rv = init_driver_queues(nullb);
-		if (rv)
-			goto out_cleanup_blk_queue;
-	}
-
-	if (dev->mbps) {
-		set_bit(NULLB_DEV_FL_THROTTLED, &dev->flags);
-		nullb_setup_bwtimer(nullb);
-	}
-
-	if (dev->cache_size > 0) {
-		set_bit(NULLB_DEV_FL_CACHE, &nullb->dev->flags);
-		blk_queue_write_cache(nullb->q, true, true);
-	}
-
-	if (dev->zoned) {
-		rv = null_init_zoned_dev(dev, nullb->q);
-		if (rv)
-			goto out_cleanup_blk_queue;
-	}
-
-	nullb->q->queuedata = nullb;
-	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
-	blk_queue_flag_clear(QUEUE_FLAG_ADD_RANDOM, nullb->q);
-
-	mutex_lock(&lock);
-	rv = ida_simple_get(&nullb_indexes, 0, 0, GFP_KERNEL);
-	if (rv < 0) {
-		mutex_unlock(&lock);
-		goto out_cleanup_zone;
-	}
-	nullb->index = rv;
-	dev->index = rv;
-	mutex_unlock(&lock);
-
-	blk_queue_logical_block_size(nullb->q, dev->blocksize);
-	blk_queue_physical_block_size(nullb->q, dev->blocksize);
-
-	null_config_discard(nullb);
-
-	sprintf(nullb->disk_name, "nullb%d", nullb->index);
-
-	rv = null_gendisk_register(nullb);
-	if (rv)
-		goto out_ida_free;
-
-	mutex_lock(&lock);
-	list_add_tail(&nullb->list, &nullb_list);
-	mutex_unlock(&lock);
-
-	return 0;
-
-out_ida_free:
-	ida_free(&nullb_indexes, nullb->index);
-out_cleanup_zone:
-	null_free_zoned_dev(dev);
-out_cleanup_blk_queue:
-	blk_cleanup_queue(nullb->q);
-out_cleanup_tags:
-	if (dev->queue_mode == NULL_Q_MQ && nullb->tag_set == &nullb->__tag_set)
-		blk_mq_free_tag_set(nullb->tag_set);
-out_cleanup_queues:
-	cleanup_queues(nullb);
-out_free_nullb:
-	kfree(nullb);
-	dev->nullb = NULL;
-out:
-	return rv;
-}
-
-static int __init null_init(void)
-{
-	int ret = 0;
-	unsigned int i;
-	struct nullb *nullb;
-	struct nullb_device *dev;
-
-	if (g_bs > PAGE_SIZE) {
-		pr_warn("invalid block size\n");
-		pr_warn("defaults block size to %lu\n", PAGE_SIZE);
-		g_bs = PAGE_SIZE;
-	}
-
-	if (g_home_node != NUMA_NO_NODE && g_home_node >= nr_online_nodes) {
-		pr_err("invalid home_node value\n");
-		g_home_node = NUMA_NO_NODE;
-	}
-
-	if (g_queue_mode == NULL_Q_RQ) {
-		pr_err("legacy IO path no longer available\n");
-		return -EINVAL;
-	}
-	if (g_queue_mode == NULL_Q_MQ && g_use_per_node_hctx) {
-		if (g_submit_queues != nr_online_nodes) {
-			pr_warn("submit_queues param is set to %u.\n",
-							nr_online_nodes);
-			g_submit_queues = nr_online_nodes;
-		}
-	} else if (g_submit_queues > nr_cpu_ids)
-		g_submit_queues = nr_cpu_ids;
-	else if (g_submit_queues <= 0)
-		g_submit_queues = 1;
-
-	if (g_queue_mode == NULL_Q_MQ && shared_tags) {
-		ret = null_init_tag_set(NULL, &tag_set);
-		if (ret)
-			return ret;
-	}
-
-	config_group_init(&nullb_subsys.su_group);
-	mutex_init(&nullb_subsys.su_mutex);
-
-	ret = configfs_register_subsystem(&nullb_subsys);
-	if (ret)
-		goto err_tagset;
-
-	mutex_init(&lock);
-
-	null_major = register_blkdev(0, "nullb");
-	if (null_major < 0) {
-		ret = null_major;
-		goto err_conf;
-	}
-
-	for (i = 0; i < nr_devices; i++) {
-		dev = null_alloc_dev();
-		if (!dev) {
-			ret = -ENOMEM;
-			goto err_dev;
-		}
-		ret = null_add_dev(dev);
-		if (ret) {
-			null_free_dev(dev);
-			goto err_dev;
-		}
-	}
-
-	pr_info("module loaded\n");
-	return 0;
-
-err_dev:
-	while (!list_empty(&nullb_list)) {
-		nullb = list_entry(nullb_list.next, struct nullb, list);
-		dev = nullb->dev;
-		null_del_dev(nullb);
-		null_free_dev(dev);
-	}
-	unregister_blkdev(null_major, "nullb");
-err_conf:
-	configfs_unregister_subsystem(&nullb_subsys);
-err_tagset:
-	if (g_queue_mode == NULL_Q_MQ && shared_tags)
-		blk_mq_free_tag_set(&tag_set);
-	return ret;
-}
-
-static void __exit null_exit(void)
-{
-	struct nullb *nullb;
-
-	configfs_unregister_subsystem(&nullb_subsys);
-
-	unregister_blkdev(null_major, "nullb");
-
-	mutex_lock(&lock);
-	while (!list_empty(&nullb_list)) {
-		struct nullb_device *dev;
-
-		nullb = list_entry(nullb_list.next, struct nullb, list);
-		dev = nullb->dev;
-		null_del_dev(nullb);
-		null_free_dev(dev);
-	}
-	mutex_unlock(&lock);
-
-	if (g_queue_mode == NULL_Q_MQ && shared_tags)
-		blk_mq_free_tag_set(&tag_set);
-}
-
-module_init(null_init);
-module_exit(null_exit);
-
-MODULE_AUTHOR("Jens Axboe <axboe@kernel.dk>");
-MODULE_LICENSE("GPL");
diff --git a/drivers/block/null_blk_trace.c b/drivers/block/null_blk_trace.c
deleted file mode 100644
index f246e7bff698..000000000000
--- a/drivers/block/null_blk_trace.c
+++ /dev/null
@@ -1,21 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * null_blk trace related helpers.
- *
- * Copyright (C) 2020 Western Digital Corporation or its affiliates.
- */
-#include "null_blk_trace.h"
-
-/*
- * Helper to use for all null_blk traces to extract disk name.
- */
-const char *nullb_trace_disk_name(struct trace_seq *p, char *name)
-{
-	const char *ret = trace_seq_buffer_ptr(p);
-
-	if (name && *name)
-		trace_seq_printf(p, "disk=%s, ", name);
-	trace_seq_putc(p, 0);
-
-	return ret;
-}
diff --git a/drivers/block/null_blk_trace.h b/drivers/block/null_blk_trace.h
deleted file mode 100644
index 4f83032eb544..000000000000
--- a/drivers/block/null_blk_trace.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * null_blk device driver tracepoints.
- *
- * Copyright (C) 2020 Western Digital Corporation or its affiliates.
- */
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM nullb
-
-#if !defined(_TRACE_NULLB_H) || defined(TRACE_HEADER_MULTI_READ)
-#define _TRACE_NULLB_H
-
-#include <linux/tracepoint.h>
-#include <linux/trace_seq.h>
-
-#include "null_blk.h"
-
-const char *nullb_trace_disk_name(struct trace_seq *p, char *name);
-
-#define __print_disk_name(name) nullb_trace_disk_name(p, name)
-
-#ifndef TRACE_HEADER_MULTI_READ
-static inline void __assign_disk_name(char *name, struct gendisk *disk)
-{
-	if (disk)
-		memcpy(name, disk->disk_name, DISK_NAME_LEN);
-	else
-		memset(name, 0, DISK_NAME_LEN);
-}
-#endif
-
-TRACE_EVENT(nullb_zone_op,
-	    TP_PROTO(struct nullb_cmd *cmd, unsigned int zone_no,
-		     unsigned int zone_cond),
-	    TP_ARGS(cmd, zone_no, zone_cond),
-	    TP_STRUCT__entry(
-		__array(char, disk, DISK_NAME_LEN)
-		__field(enum req_opf, op)
-		__field(unsigned int, zone_no)
-		__field(unsigned int, zone_cond)
-	    ),
-	    TP_fast_assign(
-		__entry->op = req_op(cmd->rq);
-		__entry->zone_no = zone_no;
-		__entry->zone_cond = zone_cond;
-		__assign_disk_name(__entry->disk, cmd->rq->rq_disk);
-	    ),
-	    TP_printk("%s req=%-15s zone_no=%u zone_cond=%-10s",
-		      __print_disk_name(__entry->disk),
-		      blk_op_str(__entry->op),
-		      __entry->zone_no,
-		      blk_zone_cond_str(__entry->zone_cond))
-);
-
-TRACE_EVENT(nullb_report_zones,
-	    TP_PROTO(struct nullb *nullb, unsigned int nr_zones),
-	    TP_ARGS(nullb, nr_zones),
-	    TP_STRUCT__entry(
-		__array(char, disk, DISK_NAME_LEN)
-		__field(unsigned int, nr_zones)
-	    ),
-	    TP_fast_assign(
-		__entry->nr_zones = nr_zones;
-		__assign_disk_name(__entry->disk, nullb->disk);
-	    ),
-	    TP_printk("%s nr_zones=%u",
-		      __print_disk_name(__entry->disk), __entry->nr_zones)
-);
-
-#endif /* _TRACE_NULLB_H */
-
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH .
-#undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE null_blk_trace
-
-/* This part must be outside protection */
-#include <trace/define_trace.h>
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
deleted file mode 100644
index f5df82c26c16..000000000000
--- a/drivers/block/null_blk_zoned.c
+++ /dev/null
@@ -1,617 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-#include <linux/vmalloc.h>
-#include <linux/bitmap.h>
-#include "null_blk.h"
-
-#define CREATE_TRACE_POINTS
-#include "null_blk_trace.h"
-
-#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)
-
-static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
-{
-	return sect >> ilog2(dev->zone_size_sects);
-}
-
-int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
-{
-	sector_t dev_capacity_sects, zone_capacity_sects;
-	sector_t sector = 0;
-	unsigned int i;
-
-	if (!is_power_of_2(dev->zone_size)) {
-		pr_err("zone_size must be power-of-two\n");
-		return -EINVAL;
-	}
-	if (dev->zone_size > dev->size) {
-		pr_err("Zone size larger than device capacity\n");
-		return -EINVAL;
-	}
-
-	if (!dev->zone_capacity)
-		dev->zone_capacity = dev->zone_size;
-
-	if (dev->zone_capacity > dev->zone_size) {
-		pr_err("null_blk: zone capacity (%lu MB) larger than zone size (%lu MB)\n",
-					dev->zone_capacity, dev->zone_size);
-		return -EINVAL;
-	}
-
-	zone_capacity_sects = MB_TO_SECTS(dev->zone_capacity);
-	dev_capacity_sects = MB_TO_SECTS(dev->size);
-	dev->zone_size_sects = MB_TO_SECTS(dev->zone_size);
-	dev->nr_zones = dev_capacity_sects >> ilog2(dev->zone_size_sects);
-	if (dev_capacity_sects & (dev->zone_size_sects - 1))
-		dev->nr_zones++;
-
-	dev->zones = kvmalloc_array(dev->nr_zones, sizeof(struct blk_zone),
-			GFP_KERNEL | __GFP_ZERO);
-	if (!dev->zones)
-		return -ENOMEM;
-
-	/*
-	 * With memory backing, the zone_lock spinlock needs to be temporarily
-	 * released to avoid scheduling in atomic context. To guarantee zone
-	 * information protection, use a bitmap to lock zones with
-	 * wait_on_bit_lock_io(). Sleeping on the lock is OK as memory backing
-	 * implies that the queue is marked with BLK_MQ_F_BLOCKING.
-	 */
-	spin_lock_init(&dev->zone_lock);
-	if (dev->memory_backed) {
-		dev->zone_locks = bitmap_zalloc(dev->nr_zones, GFP_KERNEL);
-		if (!dev->zone_locks) {
-			kvfree(dev->zones);
-			return -ENOMEM;
-		}
-	}
-
-	if (dev->zone_nr_conv >= dev->nr_zones) {
-		dev->zone_nr_conv = dev->nr_zones - 1;
-		pr_info("changed the number of conventional zones to %u",
-			dev->zone_nr_conv);
-	}
-
-	/* Max active zones has to be < nbr of seq zones in order to be enforceable */
-	if (dev->zone_max_active >= dev->nr_zones - dev->zone_nr_conv) {
-		dev->zone_max_active = 0;
-		pr_info("zone_max_active limit disabled, limit >= zone count\n");
-	}
-
-	/* Max open zones has to be <= max active zones */
-	if (dev->zone_max_active && dev->zone_max_open > dev->zone_max_active) {
-		dev->zone_max_open = dev->zone_max_active;
-		pr_info("changed the maximum number of open zones to %u\n",
-			dev->nr_zones);
-	} else if (dev->zone_max_open >= dev->nr_zones - dev->zone_nr_conv) {
-		dev->zone_max_open = 0;
-		pr_info("zone_max_open limit disabled, limit >= zone count\n");
-	}
-
-	for (i = 0; i <  dev->zone_nr_conv; i++) {
-		struct blk_zone *zone = &dev->zones[i];
-
-		zone->start = sector;
-		zone->len = dev->zone_size_sects;
-		zone->capacity = zone->len;
-		zone->wp = zone->start + zone->len;
-		zone->type = BLK_ZONE_TYPE_CONVENTIONAL;
-		zone->cond = BLK_ZONE_COND_NOT_WP;
-
-		sector += dev->zone_size_sects;
-	}
-
-	for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
-		struct blk_zone *zone = &dev->zones[i];
-
-		zone->start = zone->wp = sector;
-		if (zone->start + dev->zone_size_sects > dev_capacity_sects)
-			zone->len = dev_capacity_sects - zone->start;
-		else
-			zone->len = dev->zone_size_sects;
-		zone->capacity =
-			min_t(sector_t, zone->len, zone_capacity_sects);
-		zone->type = BLK_ZONE_TYPE_SEQWRITE_REQ;
-		zone->cond = BLK_ZONE_COND_EMPTY;
-
-		sector += dev->zone_size_sects;
-	}
-
-	q->limits.zoned = BLK_ZONED_HM;
-	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
-
-	return 0;
-}
-
-int null_register_zoned_dev(struct nullb *nullb)
-{
-	struct nullb_device *dev = nullb->dev;
-	struct request_queue *q = nullb->q;
-
-	if (queue_is_mq(q)) {
-		int ret = blk_revalidate_disk_zones(nullb->disk, NULL);
-
-		if (ret)
-			return ret;
-	} else {
-		blk_queue_chunk_sectors(q, dev->zone_size_sects);
-		q->nr_zones = blkdev_nr_zones(nullb->disk);
-	}
-
-	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
-	blk_queue_max_open_zones(q, dev->zone_max_open);
-	blk_queue_max_active_zones(q, dev->zone_max_active);
-
-	return 0;
-}
-
-void null_free_zoned_dev(struct nullb_device *dev)
-{
-	bitmap_free(dev->zone_locks);
-	kvfree(dev->zones);
-	dev->zones = NULL;
-}
-
-static inline void null_lock_zone(struct nullb_device *dev, unsigned int zno)
-{
-	if (dev->memory_backed)
-		wait_on_bit_lock_io(dev->zone_locks, zno, TASK_UNINTERRUPTIBLE);
-	spin_lock_irq(&dev->zone_lock);
-}
-
-static inline void null_unlock_zone(struct nullb_device *dev, unsigned int zno)
-{
-	spin_unlock_irq(&dev->zone_lock);
-
-	if (dev->memory_backed)
-		clear_and_wake_up_bit(zno, dev->zone_locks);
-}
-
-int null_report_zones(struct gendisk *disk, sector_t sector,
-		unsigned int nr_zones, report_zones_cb cb, void *data)
-{
-	struct nullb *nullb = disk->private_data;
-	struct nullb_device *dev = nullb->dev;
-	unsigned int first_zone, i, zno;
-	struct blk_zone zone;
-	int error;
-
-	first_zone = null_zone_no(dev, sector);
-	if (first_zone >= dev->nr_zones)
-		return 0;
-
-	nr_zones = min(nr_zones, dev->nr_zones - first_zone);
-	trace_nullb_report_zones(nullb, nr_zones);
-
-	zno = first_zone;
-	for (i = 0; i < nr_zones; i++, zno++) {
-		/*
-		 * Stacked DM target drivers will remap the zone information by
-		 * modifying the zone information passed to the report callback.
-		 * So use a local copy to avoid corruption of the device zone
-		 * array.
-		 */
-		null_lock_zone(dev, zno);
-		memcpy(&zone, &dev->zones[zno], sizeof(struct blk_zone));
-		null_unlock_zone(dev, zno);
-
-		error = cb(&zone, i, data);
-		if (error)
-			return error;
-	}
-
-	return nr_zones;
-}
-
-/*
- * This is called in the case of memory backing from null_process_cmd()
- * with the target zone already locked.
- */
-size_t null_zone_valid_read_len(struct nullb *nullb,
-				sector_t sector, unsigned int len)
-{
-	struct nullb_device *dev = nullb->dev;
-	struct blk_zone *zone = &dev->zones[null_zone_no(dev, sector)];
-	unsigned int nr_sectors = len >> SECTOR_SHIFT;
-
-	/* Read must be below the write pointer position */
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL ||
-	    sector + nr_sectors <= zone->wp)
-		return len;
-
-	if (sector > zone->wp)
-		return 0;
-
-	return (zone->wp - sector) << SECTOR_SHIFT;
-}
-
-static blk_status_t null_close_zone(struct nullb_device *dev, struct blk_zone *zone)
-{
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-		return BLK_STS_IOERR;
-
-	switch (zone->cond) {
-	case BLK_ZONE_COND_CLOSED:
-		/* close operation on closed is not an error */
-		return BLK_STS_OK;
-	case BLK_ZONE_COND_IMP_OPEN:
-		dev->nr_zones_imp_open--;
-		break;
-	case BLK_ZONE_COND_EXP_OPEN:
-		dev->nr_zones_exp_open--;
-		break;
-	case BLK_ZONE_COND_EMPTY:
-	case BLK_ZONE_COND_FULL:
-	default:
-		return BLK_STS_IOERR;
-	}
-
-	if (zone->wp == zone->start) {
-		zone->cond = BLK_ZONE_COND_EMPTY;
-	} else {
-		zone->cond = BLK_ZONE_COND_CLOSED;
-		dev->nr_zones_closed++;
-	}
-
-	return BLK_STS_OK;
-}
-
-static void null_close_first_imp_zone(struct nullb_device *dev)
-{
-	unsigned int i;
-
-	for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
-		if (dev->zones[i].cond == BLK_ZONE_COND_IMP_OPEN) {
-			null_close_zone(dev, &dev->zones[i]);
-			return;
-		}
-	}
-}
-
-static blk_status_t null_check_active(struct nullb_device *dev)
-{
-	if (!dev->zone_max_active)
-		return BLK_STS_OK;
-
-	if (dev->nr_zones_exp_open + dev->nr_zones_imp_open +
-			dev->nr_zones_closed < dev->zone_max_active)
-		return BLK_STS_OK;
-
-	return BLK_STS_ZONE_ACTIVE_RESOURCE;
-}
-
-static blk_status_t null_check_open(struct nullb_device *dev)
-{
-	if (!dev->zone_max_open)
-		return BLK_STS_OK;
-
-	if (dev->nr_zones_exp_open + dev->nr_zones_imp_open < dev->zone_max_open)
-		return BLK_STS_OK;
-
-	if (dev->nr_zones_imp_open) {
-		if (null_check_active(dev) == BLK_STS_OK) {
-			null_close_first_imp_zone(dev);
-			return BLK_STS_OK;
-		}
-	}
-
-	return BLK_STS_ZONE_OPEN_RESOURCE;
-}
-
-/*
- * This function matches the manage open zone resources function in the ZBC standard,
- * with the addition of max active zones support (added in the ZNS standard).
- *
- * The function determines if a zone can transition to implicit open or explicit open,
- * while maintaining the max open zone (and max active zone) limit(s). It may close an
- * implicit open zone in order to make additional zone resources available.
- *
- * ZBC states that an implicit open zone shall be closed only if there is not
- * room within the open limit. However, with the addition of an active limit,
- * it is not certain that closing an implicit open zone will allow a new zone
- * to be opened, since we might already be at the active limit capacity.
- */
-static blk_status_t null_check_zone_resources(struct nullb_device *dev, struct blk_zone *zone)
-{
-	blk_status_t ret;
-
-	switch (zone->cond) {
-	case BLK_ZONE_COND_EMPTY:
-		ret = null_check_active(dev);
-		if (ret != BLK_STS_OK)
-			return ret;
-		fallthrough;
-	case BLK_ZONE_COND_CLOSED:
-		return null_check_open(dev);
-	default:
-		/* Should never be called for other states */
-		WARN_ON(1);
-		return BLK_STS_IOERR;
-	}
-}
-
-static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
-				    unsigned int nr_sectors, bool append)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	unsigned int zno = null_zone_no(dev, sector);
-	struct blk_zone *zone = &dev->zones[zno];
-	blk_status_t ret;
-
-	trace_nullb_zone_op(cmd, zno, zone->cond);
-
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
-		if (append)
-			return BLK_STS_IOERR;
-		return null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
-	}
-
-	null_lock_zone(dev, zno);
-
-	switch (zone->cond) {
-	case BLK_ZONE_COND_FULL:
-		/* Cannot write to a full zone */
-		ret = BLK_STS_IOERR;
-		goto unlock;
-	case BLK_ZONE_COND_EMPTY:
-	case BLK_ZONE_COND_CLOSED:
-		ret = null_check_zone_resources(dev, zone);
-		if (ret != BLK_STS_OK)
-			goto unlock;
-		break;
-	case BLK_ZONE_COND_IMP_OPEN:
-	case BLK_ZONE_COND_EXP_OPEN:
-		break;
-	default:
-		/* Invalid zone condition */
-		ret = BLK_STS_IOERR;
-		goto unlock;
-	}
-
-	/*
-	 * Regular writes must be at the write pointer position.
-	 * Zone append writes are automatically issued at the write
-	 * pointer and the position returned using the request or BIO
-	 * sector.
-	 */
-	if (append) {
-		sector = zone->wp;
-		if (cmd->bio)
-			cmd->bio->bi_iter.bi_sector = sector;
-		else
-			cmd->rq->__sector = sector;
-	} else if (sector != zone->wp) {
-		ret = BLK_STS_IOERR;
-		goto unlock;
-	}
-
-	if (zone->wp + nr_sectors > zone->start + zone->capacity) {
-		ret = BLK_STS_IOERR;
-		goto unlock;
-	}
-
-	if (zone->cond == BLK_ZONE_COND_CLOSED) {
-		dev->nr_zones_closed--;
-		dev->nr_zones_imp_open++;
-	} else if (zone->cond == BLK_ZONE_COND_EMPTY) {
-		dev->nr_zones_imp_open++;
-	}
-	if (zone->cond != BLK_ZONE_COND_EXP_OPEN)
-		zone->cond = BLK_ZONE_COND_IMP_OPEN;
-
-	/*
-	 * Memory backing allocation may sleep: release the zone_lock spinlock
-	 * to avoid scheduling in atomic context. Zone operation atomicity is
-	 * still guaranteed through the zone_locks bitmap.
-	 */
-	if (dev->memory_backed)
-		spin_unlock_irq(&dev->zone_lock);
-	ret = null_process_cmd(cmd, REQ_OP_WRITE, sector, nr_sectors);
-	if (dev->memory_backed)
-		spin_lock_irq(&dev->zone_lock);
-
-	if (ret != BLK_STS_OK)
-		goto unlock;
-
-	zone->wp += nr_sectors;
-	if (zone->wp == zone->start + zone->capacity) {
-		if (zone->cond == BLK_ZONE_COND_EXP_OPEN)
-			dev->nr_zones_exp_open--;
-		else if (zone->cond == BLK_ZONE_COND_IMP_OPEN)
-			dev->nr_zones_imp_open--;
-		zone->cond = BLK_ZONE_COND_FULL;
-	}
-	ret = BLK_STS_OK;
-
-unlock:
-	null_unlock_zone(dev, zno);
-
-	return ret;
-}
-
-static blk_status_t null_open_zone(struct nullb_device *dev, struct blk_zone *zone)
-{
-	blk_status_t ret;
-
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-		return BLK_STS_IOERR;
-
-	switch (zone->cond) {
-	case BLK_ZONE_COND_EXP_OPEN:
-		/* open operation on exp open is not an error */
-		return BLK_STS_OK;
-	case BLK_ZONE_COND_EMPTY:
-		ret = null_check_zone_resources(dev, zone);
-		if (ret != BLK_STS_OK)
-			return ret;
-		break;
-	case BLK_ZONE_COND_IMP_OPEN:
-		dev->nr_zones_imp_open--;
-		break;
-	case BLK_ZONE_COND_CLOSED:
-		ret = null_check_zone_resources(dev, zone);
-		if (ret != BLK_STS_OK)
-			return ret;
-		dev->nr_zones_closed--;
-		break;
-	case BLK_ZONE_COND_FULL:
-	default:
-		return BLK_STS_IOERR;
-	}
-
-	zone->cond = BLK_ZONE_COND_EXP_OPEN;
-	dev->nr_zones_exp_open++;
-
-	return BLK_STS_OK;
-}
-
-static blk_status_t null_finish_zone(struct nullb_device *dev, struct blk_zone *zone)
-{
-	blk_status_t ret;
-
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-		return BLK_STS_IOERR;
-
-	switch (zone->cond) {
-	case BLK_ZONE_COND_FULL:
-		/* finish operation on full is not an error */
-		return BLK_STS_OK;
-	case BLK_ZONE_COND_EMPTY:
-		ret = null_check_zone_resources(dev, zone);
-		if (ret != BLK_STS_OK)
-			return ret;
-		break;
-	case BLK_ZONE_COND_IMP_OPEN:
-		dev->nr_zones_imp_open--;
-		break;
-	case BLK_ZONE_COND_EXP_OPEN:
-		dev->nr_zones_exp_open--;
-		break;
-	case BLK_ZONE_COND_CLOSED:
-		ret = null_check_zone_resources(dev, zone);
-		if (ret != BLK_STS_OK)
-			return ret;
-		dev->nr_zones_closed--;
-		break;
-	default:
-		return BLK_STS_IOERR;
-	}
-
-	zone->cond = BLK_ZONE_COND_FULL;
-	zone->wp = zone->start + zone->len;
-
-	return BLK_STS_OK;
-}
-
-static blk_status_t null_reset_zone(struct nullb_device *dev, struct blk_zone *zone)
-{
-	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
-		return BLK_STS_IOERR;
-
-	switch (zone->cond) {
-	case BLK_ZONE_COND_EMPTY:
-		/* reset operation on empty is not an error */
-		return BLK_STS_OK;
-	case BLK_ZONE_COND_IMP_OPEN:
-		dev->nr_zones_imp_open--;
-		break;
-	case BLK_ZONE_COND_EXP_OPEN:
-		dev->nr_zones_exp_open--;
-		break;
-	case BLK_ZONE_COND_CLOSED:
-		dev->nr_zones_closed--;
-		break;
-	case BLK_ZONE_COND_FULL:
-		break;
-	default:
-		return BLK_STS_IOERR;
-	}
-
-	zone->cond = BLK_ZONE_COND_EMPTY;
-	zone->wp = zone->start;
-
-	return BLK_STS_OK;
-}
-
-static blk_status_t null_zone_mgmt(struct nullb_cmd *cmd, enum req_opf op,
-				   sector_t sector)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	unsigned int zone_no;
-	struct blk_zone *zone;
-	blk_status_t ret;
-	size_t i;
-
-	if (op == REQ_OP_ZONE_RESET_ALL) {
-		for (i = dev->zone_nr_conv; i < dev->nr_zones; i++) {
-			null_lock_zone(dev, i);
-			zone = &dev->zones[i];
-			if (zone->cond != BLK_ZONE_COND_EMPTY) {
-				null_reset_zone(dev, zone);
-				trace_nullb_zone_op(cmd, i, zone->cond);
-			}
-			null_unlock_zone(dev, i);
-		}
-		return BLK_STS_OK;
-	}
-
-	zone_no = null_zone_no(dev, sector);
-	zone = &dev->zones[zone_no];
-
-	null_lock_zone(dev, zone_no);
-
-	switch (op) {
-	case REQ_OP_ZONE_RESET:
-		ret = null_reset_zone(dev, zone);
-		break;
-	case REQ_OP_ZONE_OPEN:
-		ret = null_open_zone(dev, zone);
-		break;
-	case REQ_OP_ZONE_CLOSE:
-		ret = null_close_zone(dev, zone);
-		break;
-	case REQ_OP_ZONE_FINISH:
-		ret = null_finish_zone(dev, zone);
-		break;
-	default:
-		ret = BLK_STS_NOTSUPP;
-		break;
-	}
-
-	if (ret == BLK_STS_OK)
-		trace_nullb_zone_op(cmd, zone_no, zone->cond);
-
-	null_unlock_zone(dev, zone_no);
-
-	return ret;
-}
-
-blk_status_t null_process_zoned_cmd(struct nullb_cmd *cmd, enum req_opf op,
-				    sector_t sector, sector_t nr_sectors)
-{
-	struct nullb_device *dev = cmd->nq->dev;
-	unsigned int zno = null_zone_no(dev, sector);
-	blk_status_t sts;
-
-	switch (op) {
-	case REQ_OP_WRITE:
-		sts = null_zone_write(cmd, sector, nr_sectors, false);
-		break;
-	case REQ_OP_ZONE_APPEND:
-		sts = null_zone_write(cmd, sector, nr_sectors, true);
-		break;
-	case REQ_OP_ZONE_RESET:
-	case REQ_OP_ZONE_RESET_ALL:
-	case REQ_OP_ZONE_OPEN:
-	case REQ_OP_ZONE_CLOSE:
-	case REQ_OP_ZONE_FINISH:
-		sts = null_zone_mgmt(cmd, op, sector);
-		break;
-	default:
-		null_lock_zone(dev, zno);
-		sts = null_process_cmd(cmd, op, sector, nr_sectors);
-		null_unlock_zone(dev, zno);
-	}
-
-	return sts;
-}
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 39aeebc6837d..d9e41d3bbe71 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -984,6 +984,8 @@ static int vdc_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	print_version();
 
 	hp = mdesc_grab();
+	if (!hp)
+		return -ENODEV;
 
 	err = -ENODEV;
 	if ((vdev->dev_no << PARTITION_SHIFT) & ~(u64)MINORMASK) {
diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index c715d4681a0b..4ae49eae4586 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -79,7 +79,7 @@ config COMMON_CLK_RK808
 config COMMON_CLK_HI655X
 	tristate "Clock driver for Hi655x" if EXPERT
 	depends on (MFD_HI655X_PMIC || COMPILE_TEST)
-	depends on REGMAP
+	select REGMAP
 	default MFD_HI655X_PMIC
 	help
 	  This driver supports the hi655x PMIC clock. This
diff --git a/drivers/cpuidle/cpuidle-psci-domain.c b/drivers/cpuidle/cpuidle-psci-domain.c
index 4a031c62f92a..5098639d41f1 100644
--- a/drivers/cpuidle/cpuidle-psci-domain.c
+++ b/drivers/cpuidle/cpuidle-psci-domain.c
@@ -182,7 +182,8 @@ static void psci_pd_remove(void)
 	struct psci_pd_provider *pd_provider, *it;
 	struct generic_pm_domain *genpd;
 
-	list_for_each_entry_safe(pd_provider, it, &psci_pd_providers, link) {
+	list_for_each_entry_safe_reverse(pd_provider, it,
+					 &psci_pd_providers, link) {
 		of_genpd_del_provider(pd_provider->node);
 
 		genpd = of_genpd_remove_last(pd_provider->node);
diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index 9e6504592646..300ba2991936 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -171,7 +171,7 @@ static int zynqmp_pm_feature(u32 api_id)
 	}
 
 	/* Add new entry if not present */
-	feature_data = kmalloc(sizeof(*feature_data), GFP_KERNEL);
+	feature_data = kmalloc(sizeof(*feature_data), GFP_ATOMIC);
 	if (!feature_data)
 		return -ENOMEM;
 
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
index 159be13ef20b..2c19b3775179 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_events.c
@@ -528,16 +528,13 @@ static struct kfd_event_waiter *alloc_event_waiters(uint32_t num_events)
 	struct kfd_event_waiter *event_waiters;
 	uint32_t i;
 
-	event_waiters = kmalloc_array(num_events,
-					sizeof(struct kfd_event_waiter),
-					GFP_KERNEL);
+	event_waiters = kcalloc(num_events, sizeof(struct kfd_event_waiter),
+				GFP_KERNEL);
 	if (!event_waiters)
 		return NULL;
 
-	for (i = 0; (event_waiters) && (i < num_events) ; i++) {
+	for (i = 0; i < num_events; i++)
 		init_wait(&event_waiters[i].wait);
-		event_waiters[i].activated = false;
-	}
 
 	return event_waiters;
 }
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index e427f4ffa080..e5b1002d7f3f 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -1868,7 +1868,10 @@ static unsigned int CalculateVMAndRowBytes(
 	}
 
 	if (SurfaceTiling == dm_sw_linear) {
-		*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
+		if (PTEBufferSizeInRequests == 0)
+			*dpte_row_height = 1;
+		else
+			*dpte_row_height = dml_min(128, 1 << (unsigned int) dml_floor(dml_log2(PTEBufferSizeInRequests * *PixelPTEReqWidth / Pitch), 1));
 		*dpte_row_width_ub = (dml_ceil(((double) SwathWidth - 1) / *PixelPTEReqWidth, 1) + 1) * *PixelPTEReqWidth;
 		*PixelPTEBytesPerRow = *dpte_row_width_ub / *PixelPTEReqWidth * *PTERequestSize;
 	} else if (ScanDirection != dm_vert) {
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index c56656a95cf9..b7bb5610dfe2 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -614,11 +614,14 @@ int drm_gem_shmem_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
 	int ret;
 
 	if (obj->import_attach) {
-		/* Drop the reference drm_gem_mmap_obj() acquired.*/
-		drm_gem_object_put(obj);
 		vma->vm_private_data = NULL;
+		ret = dma_buf_mmap(obj->dma_buf, vma, 0);
+
+		/* Drop the reference drm_gem_mmap_obj() acquired.*/
+		if (!ret)
+			drm_gem_object_put(obj);
 
-		return dma_buf_mmap(obj->dma_buf, vma, 0);
+		return ret;
 	}
 
 	shmem = to_drm_gem_shmem_obj(obj);
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 69b2e5509d67..de67b2745258 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -108,7 +108,7 @@ static struct i915_vma *create_ring_vma(struct i915_ggtt *ggtt, int size)
 	struct i915_vma *vma;
 
 	obj = ERR_PTR(-ENODEV);
-	if (i915_ggtt_has_aperture(ggtt))
+	if (i915_ggtt_has_aperture(ggtt) && !HAS_LLC(i915))
 		obj = i915_gem_object_create_stolen(i915, size);
 	if (IS_ERR(obj))
 		obj = i915_gem_object_create_internal(i915, size);
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index c4c2d24dc509..0532a5069c04 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -432,8 +432,7 @@ replace_barrier(struct i915_active *ref, struct i915_active_fence *active)
 	 * we can use it to substitute for the pending idle-barrer
 	 * request that we want to emit on the kernel_context.
 	 */
-	__active_del_barrier(ref, node_from_active(active));
-	return true;
+	return __active_del_barrier(ref, node_from_active(active));
 }
 
 int i915_active_ref(struct i915_active *ref, u64 idx, struct dma_fence *fence)
@@ -446,16 +445,19 @@ int i915_active_ref(struct i915_active *ref, u64 idx, struct dma_fence *fence)
 	if (err)
 		return err;
 
-	active = active_instance(ref, idx);
-	if (!active) {
-		err = -ENOMEM;
-		goto out;
-	}
+	do {
+		active = active_instance(ref, idx);
+		if (!active) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		if (replace_barrier(ref, active)) {
+			RCU_INIT_POINTER(active->fence, NULL);
+			atomic_dec(&ref->count);
+		}
+	} while (unlikely(is_barrier(active)));
 
-	if (replace_barrier(ref, active)) {
-		RCU_INIT_POINTER(active->fence, NULL);
-		atomic_dec(&ref->count);
-	}
 	if (!__i915_active_fence_set(active, fence))
 		__i915_active_acquire(ref);
 
diff --git a/drivers/gpu/drm/meson/meson_vpp.c b/drivers/gpu/drm/meson/meson_vpp.c
index 154837688ab0..5df1957c8e41 100644
--- a/drivers/gpu/drm/meson/meson_vpp.c
+++ b/drivers/gpu/drm/meson/meson_vpp.c
@@ -100,6 +100,8 @@ void meson_vpp_init(struct meson_drm *priv)
 			       priv->io_base + _REG(VPP_DOLBY_CTRL));
 		writel_relaxed(0x1020080,
 				priv->io_base + _REG(VPP_DUMMY_DATA1));
+		writel_relaxed(0x42020,
+				priv->io_base + _REG(VPP_DUMMY_DATA));
 	} else if (meson_vpu_is_compatible(priv, VPU_COMPATIBLE_G12A))
 		writel_relaxed(0xf, priv->io_base + _REG(DOLBY_PATH_CTRL));
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_mmu.c b/drivers/gpu/drm/panfrost/panfrost_mmu.c
index 13596961ae17..5ff856ef7d88 100644
--- a/drivers/gpu/drm/panfrost/panfrost_mmu.c
+++ b/drivers/gpu/drm/panfrost/panfrost_mmu.c
@@ -236,7 +236,7 @@ static void panfrost_mmu_flush_range(struct panfrost_device *pfdev,
 	if (pm_runtime_active(pfdev->dev))
 		mmu_hw_do_operation(pfdev, mmu, iova, size, AS_COMMAND_FLUSH_PT);
 
-	pm_runtime_put_sync_autosuspend(pfdev->dev);
+	pm_runtime_put_autosuspend(pfdev->dev);
 }
 
 static int mmu_map_sg(struct panfrost_device *pfdev, struct panfrost_mmu *mmu,
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 5f9ec1d1464a..524d6d712e72 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -258,6 +258,7 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 {
 	struct hid_report *report;
 	struct hid_field *field;
+	unsigned int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int usages;
 	unsigned int offset;
 	unsigned int i;
@@ -288,8 +289,11 @@ static int hid_add_field(struct hid_parser *parser, unsigned report_type, unsign
 	offset = report->size;
 	report->size += parser->global.report_size * parser->global.report_count;
 
+	if (parser->device->ll_driver->max_buffer_size)
+		max_buffer_size = parser->device->ll_driver->max_buffer_size;
+
 	/* Total size check: Allow for possible report index byte */
-	if (report->size > (HID_MAX_BUFFER_SIZE - 1) << 3) {
+	if (report->size > (max_buffer_size - 1) << 3) {
 		hid_err(parser->device, "report is too long\n");
 		return -1;
 	}
@@ -1752,6 +1756,7 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 	struct hid_report_enum *report_enum = hid->report_enum + type;
 	struct hid_report *report;
 	struct hid_driver *hdrv;
+	int max_buffer_size = HID_MAX_BUFFER_SIZE;
 	unsigned int a;
 	u32 rsize, csize = size;
 	u8 *cdata = data;
@@ -1768,10 +1773,13 @@ int hid_report_raw_event(struct hid_device *hid, int type, u8 *data, u32 size,
 
 	rsize = hid_compute_report_size(report);
 
-	if (report_enum->numbered && rsize >= HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE - 1;
-	else if (rsize > HID_MAX_BUFFER_SIZE)
-		rsize = HID_MAX_BUFFER_SIZE;
+	if (hid->ll_driver->max_buffer_size)
+		max_buffer_size = hid->ll_driver->max_buffer_size;
+
+	if (report_enum->numbered && rsize >= max_buffer_size)
+		rsize = max_buffer_size - 1;
+	else if (rsize > max_buffer_size)
+		rsize = max_buffer_size;
 
 	if (csize < rsize) {
 		dbg_hid("report %d is too short, (%d < %d)\n", report->id,
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index fc06d8bb42e0..ba0ca652b9da 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -395,6 +395,7 @@ struct hid_ll_driver uhid_hid_driver = {
 	.parse = uhid_hid_parse,
 	.raw_request = uhid_hid_raw_request,
 	.output_report = uhid_hid_output_report,
+	.max_buffer_size = UHID_DATA_MAX,
 };
 EXPORT_SYMBOL_GPL(uhid_hid_driver);
 
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 9d5b019651f2..6b84822e7d93 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -486,10 +486,10 @@ static ssize_t temp_store(struct device *dev, struct device_attribute *attr,
 		val = (temp - val) / 1000;
 
 		if (sattr->index != 1) {
-			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
+			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF) << 4;
 		} else {
-			data->temp[HYSTERSIS][sattr->index] &= 0x0F;
+			data->temp[HYSTERSIS][sattr->index] &= 0xF0;
 			data->temp[HYSTERSIS][sattr->index] |= (val & 0xF);
 		}
 
@@ -554,11 +554,11 @@ static ssize_t temp_st_show(struct device *dev, struct device_attribute *attr,
 		val = data->enh_acoustics[0] & 0xf;
 		break;
 	case 1:
-		val = (data->enh_acoustics[1] >> 4) & 0xf;
+		val = data->enh_acoustics[1] & 0xf;
 		break;
 	case 2:
 	default:
-		val = data->enh_acoustics[1] & 0xf;
+		val = (data->enh_acoustics[1] >> 4) & 0xf;
 		break;
 	}
 
diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index d3c98115042b..836e7579e166 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -772,7 +772,7 @@ static int ina3221_probe_child_from_dt(struct device *dev,
 		return ret;
 	} else if (val > INA3221_CHANNEL3) {
 		dev_err(dev, "invalid reg %d of %pOFn\n", val, child);
-		return ret;
+		return -EINVAL;
 	}
 
 	input = &ina->inputs[val];
diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index c7b373ba92f2..d1b2e936546f 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -301,6 +301,7 @@ static int adm1266_config_gpio(struct adm1266_data *data)
 	data->gc.label = name;
 	data->gc.parent = &data->client->dev;
 	data->gc.owner = THIS_MODULE;
+	data->gc.can_sleep = true;
 	data->gc.base = -1;
 	data->gc.names = data->gpio_names;
 	data->gc.ngpio = ARRAY_SIZE(data->gpio_names);
diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index f8017993e2b4..9e26cc084a17 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
@@ -16,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/pmbus.h>
 #include <linux/gpio/driver.h>
+#include <linux/timekeeping.h>
 #include "pmbus.h"
 
 enum chips { ucd9000, ucd90120, ucd90124, ucd90160, ucd90320, ucd9090,
@@ -65,6 +67,7 @@ struct ucd9000_data {
 	struct gpio_chip gpio;
 #endif
 	struct dentry *debugfs;
+	ktime_t write_time;
 };
 #define to_ucd9000_data(_info) container_of(_info, struct ucd9000_data, info)
 
@@ -73,6 +76,73 @@ struct ucd9000_debugfs_entry {
 	u8 index;
 };
 
+/*
+ * It has been observed that the UCD90320 randomly fails register access when
+ * doing another access right on the back of a register write. To mitigate this
+ * make sure that there is a minimum delay between a write access and the
+ * following access. The 250us is based on experimental data. At a delay of
+ * 200us the issue seems to go away. Add a bit of extra margin to allow for
+ * system to system differences.
+ */
+#define UCD90320_WAIT_DELAY_US 250
+
+static inline void ucd90320_wait(const struct ucd9000_data *data)
+{
+	s64 delta = ktime_us_delta(ktime_get(), data->write_time);
+
+	if (delta < UCD90320_WAIT_DELAY_US)
+		udelay(UCD90320_WAIT_DELAY_US - delta);
+}
+
+static int ucd90320_read_word_data(struct i2c_client *client, int page,
+				   int phase, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	if (reg >= PMBUS_VIRT_BASE)
+		return -ENXIO;
+
+	ucd90320_wait(data);
+	return pmbus_read_word_data(client, page, phase, reg);
+}
+
+static int ucd90320_read_byte_data(struct i2c_client *client, int page, int reg)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+
+	ucd90320_wait(data);
+	return pmbus_read_byte_data(client, page, reg);
+}
+
+static int ucd90320_write_word_data(struct i2c_client *client, int page,
+				    int reg, u16 word)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_word_data(client, page, reg, word);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
+static int ucd90320_write_byte(struct i2c_client *client, int page, u8 value)
+{
+	const struct pmbus_driver_info *info = pmbus_get_driver_info(client);
+	struct ucd9000_data *data = to_ucd9000_data(info);
+	int ret;
+
+	ucd90320_wait(data);
+	ret = pmbus_write_byte(client, page, value);
+	data->write_time = ktime_get();
+
+	return ret;
+}
+
 static int ucd9000_get_fan_config(struct i2c_client *client, int fan)
 {
 	int fan_config = 0;
@@ -598,6 +668,11 @@ static int ucd9000_probe(struct i2c_client *client)
 		info->read_byte_data = ucd9000_read_byte_data;
 		info->func[0] |= PMBUS_HAVE_FAN12 | PMBUS_HAVE_STATUS_FAN12
 		  | PMBUS_HAVE_FAN34 | PMBUS_HAVE_STATUS_FAN34;
+	} else if (mid->driver_data == ucd90320) {
+		info->read_byte_data = ucd90320_read_byte_data;
+		info->read_word_data = ucd90320_read_word_data;
+		info->write_byte = ucd90320_write_byte;
+		info->write_word_data = ucd90320_write_word_data;
 	}
 
 	ucd9000_probe_gpio(client, mid, data);
diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 47bbe47e062f..7d5f7441aceb 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -758,7 +758,7 @@ static int tmp51x_probe(struct i2c_client *client)
 static struct i2c_driver tmp51x_driver = {
 	.driver = {
 		.name	= "tmp51x",
-		.of_match_table = of_match_ptr(tmp51x_of_match),
+		.of_match_table = tmp51x_of_match,
 	},
 	.probe_new	= tmp51x_probe,
 	.id_table	= tmp51x_id,
diff --git a/drivers/hwmon/xgene-hwmon.c b/drivers/hwmon/xgene-hwmon.c
index f2a5af239c95..f5d3cf86753f 100644
--- a/drivers/hwmon/xgene-hwmon.c
+++ b/drivers/hwmon/xgene-hwmon.c
@@ -768,6 +768,7 @@ static int xgene_hwmon_remove(struct platform_device *pdev)
 {
 	struct xgene_hwmon_dev *ctx = platform_get_drvdata(pdev);
 
+	cancel_work_sync(&ctx->workq);
 	hwmon_device_unregister(ctx->hwmon_dev);
 	kfifo_free(&ctx->async_msg_fifo);
 	if (acpi_disabled)
diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
index ceb6cdc20484..7db6d0fc6ec2 100644
--- a/drivers/interconnect/core.c
+++ b/drivers/interconnect/core.c
@@ -850,6 +850,10 @@ void icc_node_destroy(int id)
 
 	mutex_unlock(&icc_lock);
 
+	if (!node)
+		return;
+
+	kfree(node->links);
 	kfree(node);
 }
 EXPORT_SYMBOL_GPL(icc_node_destroy);
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 21666d705e37..dcf9e4d4ee6b 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -488,7 +488,7 @@ static enum m5mols_restype __find_restype(u32 code)
 	do {
 		if (code == m5mols_default_ffmt[type].code)
 			return type;
-	} while (type++ != SIZE_DEFAULT_FFMT);
+	} while (++type != SIZE_DEFAULT_FFMT);
 
 	return 0;
 }
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index af85b32c6c1c..c468f9a02ef6 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1818,7 +1818,6 @@ static void atmci_tasklet_func(unsigned long priv)
 				atmci_writel(host, ATMCI_IER, ATMCI_NOTBUSY);
 				state = STATE_WAITING_NOTBUSY;
 			} else if (host->mrq->stop) {
-				atmci_writel(host, ATMCI_IER, ATMCI_CMDRDY);
 				atmci_send_stop_cmd(host, data);
 				state = STATE_SENDING_STOP;
 			} else {
@@ -1851,8 +1850,6 @@ static void atmci_tasklet_func(unsigned long priv)
 				 * command to send.
 				 */
 				if (host->mrq->stop) {
-					atmci_writel(host, ATMCI_IER,
-					             ATMCI_CMDRDY);
 					atmci_send_stop_cmd(host, data);
 					state = STATE_SENDING_STOP;
 				} else {
diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index 24cd6d3dc647..bf2592774165 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -369,7 +369,7 @@ static void sdhci_am654_write_b(struct sdhci_host *host, u8 val, int reg)
 					MAX_POWER_ON_TIMEOUT, false, host, val,
 					reg);
 		if (ret)
-			dev_warn(mmc_dev(host->mmc), "Power on failed\n");
+			dev_info(mmc_dev(host->mmc), "Power on failed\n");
 	}
 }
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 371b345635e6..a253476a52b0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2734,7 +2734,7 @@ static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
 		return 10240 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
 	else if (chip->info->ops->set_max_frame_size)
 		return 1632 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
-	return 1522 - VLAN_ETH_HLEN - EDSA_HLEN - ETH_FCS_LEN;
+	return ETH_DATA_LEN;
 }
 
 static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
@@ -2742,6 +2742,17 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int ret = 0;
 
+	/* For families where we don't know how to alter the MTU,
+	 * just accept any value up to ETH_DATA_LEN
+	 */
+	if (!chip->info->ops->port_set_jumbo_size &&
+	    !chip->info->ops->set_max_frame_size) {
+		if (new_mtu > ETH_DATA_LEN)
+			return -EINVAL;
+
+		return 0;
+	}
+
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
 		new_mtu += EDSA_HLEN;
 
@@ -2750,9 +2761,6 @@ static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
 		ret = chip->info->ops->port_set_jumbo_size(chip, port, new_mtu);
 	else if (chip->info->ops->set_max_frame_size)
 		ret = chip->info->ops->set_max_frame_size(chip, new_mtu);
-	else
-		if (new_mtu > 1522)
-			ret = -EINVAL;
 	mv88e6xxx_reg_unlock(chip);
 
 	return ret;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 9e8a20a94862..76481ff7074b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -14851,6 +14851,7 @@ static int i40e_init_recovery_mode(struct i40e_pf *pf, struct i40e_hw *hw)
 	int err;
 	int v_idx;
 
+	pci_set_drvdata(pf->pdev, pf);
 	pci_save_state(pf->pdev);
 
 	/* set up periodic task facility */
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 59963b901be0..e0790df700e2 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -169,8 +169,6 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 	}
 	netif_tx_stop_queue(netdev_get_tx_queue(vsi->netdev, q_idx));
 
-	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
-
 	ice_fill_txq_meta(vsi, tx_ring, &txq_meta);
 	err = ice_vsi_stop_tx_ring(vsi, ICE_NO_RESET, 0, tx_ring, &txq_meta);
 	if (err)
@@ -185,6 +183,8 @@ static int ice_qp_dis(struct ice_vsi *vsi, u16 q_idx)
 		if (err)
 			return err;
 	}
+	ice_qvec_dis_irq(vsi, rx_ring, q_vector);
+
 	err = ice_vsi_ctrl_one_rx_ring(vsi, false, q_idx, true);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d2f5855b2ea7..895b6f0a3984 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4986,6 +4986,11 @@ static int qed_init_wfq_param(struct qed_hwfn *p_hwfn,
 
 	num_vports = p_hwfn->qm_info.num_vports;
 
+	if (num_vports < 2) {
+		DP_NOTICE(p_hwfn, "Unexpected num_vports: %d\n", num_vports);
+		return -EINVAL;
+	}
+
 	/* Accounting for the vports which are configured for WFQ explicitly */
 	for (i = 0; i < num_vports; i++) {
 		u32 tmp_speed;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
index 3e3192a3ad9b..fdbd5f07a185 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mng_tlv.c
@@ -422,7 +422,7 @@ qed_mfw_get_tlv_time_value(struct qed_mfw_tlv_time *p_time,
 	if (p_time->hour > 23)
 		p_time->hour = 0;
 	if (p_time->min > 59)
-		p_time->hour = 0;
+		p_time->min = 0;
 	if (p_time->msec > 999)
 		p_time->msec = 0;
 	if (p_time->usec > 999)
diff --git a/drivers/net/ethernet/sun/ldmvsw.c b/drivers/net/ethernet/sun/ldmvsw.c
index 01ea0d6f8819..934a4b54784b 100644
--- a/drivers/net/ethernet/sun/ldmvsw.c
+++ b/drivers/net/ethernet/sun/ldmvsw.c
@@ -290,6 +290,9 @@ static int vsw_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	rmac = mdesc_get_property(hp, vdev->mp, remote_macaddr_prop, &len);
 	err = -ENODEV;
 	if (!rmac) {
diff --git a/drivers/net/ethernet/sun/sunvnet.c b/drivers/net/ethernet/sun/sunvnet.c
index 96b883f965f6..b6c03adf1e76 100644
--- a/drivers/net/ethernet/sun/sunvnet.c
+++ b/drivers/net/ethernet/sun/sunvnet.c
@@ -431,6 +431,9 @@ static int vnet_port_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 
 	hp = mdesc_grab();
 
+	if (!hp)
+		return -ENODEV;
+
 	vp = vnet_find_parent(hp, vdev->mp, vdev);
 	if (IS_ERR(vp)) {
 		pr_err("Cannot find port parent vnet\n");
diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
index 943d26cbf39f..71712ea25403 100644
--- a/drivers/net/ipvlan/ipvlan_l3s.c
+++ b/drivers/net/ipvlan/ipvlan_l3s.c
@@ -101,6 +101,7 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
 		goto out;
 
 	skb->dev = addr->master->dev;
+	skb->skb_iif = skb->dev->ifindex;
 	len = skb->len + ETH_HLEN;
 	ipvlan_count_rx(addr->master, len, true, false);
 out:
diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index caf7291ffaf8..b67de3f9ef18 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -181,8 +181,11 @@ static int lan95xx_config_aneg_ext(struct phy_device *phydev)
 static int lan87xx_read_status(struct phy_device *phydev)
 {
 	struct smsc_phy_priv *priv = phydev->priv;
+	int err;
 
-	int err = genphy_read_status(phydev);
+	err = genphy_read_status(phydev);
+	if (err)
+		return err;
 
 	if (!phydev->link && priv->energy_enable) {
 		/* Disable EDPD to wake up PHY */
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 378a12ae2d95..fb1389bd0939 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -2199,6 +2199,13 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (rx_cmd_a & RX_CMD_A_LEN) - RXW_PADDING;
 		align_count = (4 - ((size + RXW_PADDING) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err rx_cmd_a=0x%08x\n",
+				  rx_cmd_a);
+			return 0;
+		}
+
 		if (unlikely(rx_cmd_a & RX_CMD_A_RED)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error rx_cmd_a=0x%08x\n", rx_cmd_a);
diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 57b07446bb76..68eb1253f888 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -175,6 +175,7 @@ static int pn533_usb_send_frame(struct pn533 *dev,
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
 
+	arg.phy = phy;
 	init_completion(&arg.done);
 	cntx = phy->out_urb->context;
 	phy->out_urb->context = &arg;
diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index 5d74c674368a..8ccf5a86ad1b 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -286,13 +286,15 @@ EXPORT_SYMBOL(ndlc_probe);
 
 void ndlc_remove(struct llt_ndlc *ndlc)
 {
-	st_nci_remove(ndlc->ndev);
-
 	/* cancel timers */
 	del_timer_sync(&ndlc->t1_timer);
 	del_timer_sync(&ndlc->t2_timer);
 	ndlc->t2_active = false;
 	ndlc->t1_active = false;
+	/* cancel work */
+	cancel_work_sync(&ndlc->sm_work);
+
+	st_nci_remove(ndlc->ndev);
 
 	skb_queue_purge(&ndlc->rcv_q);
 	skb_queue_purge(&ndlc->send_q);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e162f1dfbafe..a4b6aa932a8f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -723,16 +723,26 @@ static blk_status_t nvme_setup_discard(struct nvme_ns *ns, struct request *req,
 		range = page_address(ns->ctrl->discard_page);
 	}
 
-	__rq_for_each_bio(bio, req) {
-		u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
-		u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
-
-		if (n < segments) {
-			range[n].cattr = cpu_to_le32(0);
-			range[n].nlb = cpu_to_le32(nlb);
-			range[n].slba = cpu_to_le64(slba);
+	if (queue_max_discard_segments(req->q) == 1) {
+		u64 slba = nvme_sect_to_lba(ns, blk_rq_pos(req));
+		u32 nlb = blk_rq_sectors(req) >> (ns->lba_shift - 9);
+
+		range[0].cattr = cpu_to_le32(0);
+		range[0].nlb = cpu_to_le32(nlb);
+		range[0].slba = cpu_to_le64(slba);
+		n = 1;
+	} else {
+		__rq_for_each_bio(bio, req) {
+			u64 slba = nvme_sect_to_lba(ns, bio->bi_iter.bi_sector);
+			u32 nlb = bio->bi_iter.bi_size >> ns->lba_shift;
+
+			if (n < segments) {
+				range[n].cattr = cpu_to_le32(0);
+				range[n].nlb = cpu_to_le32(nlb);
+				range[n].slba = cpu_to_le64(slba);
+			}
+			n++;
 		}
-		n++;
 	}
 
 	if (WARN_ON_ONCE(n != segments)) {
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index bc88ff2912f5..a82a0796a614 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -749,8 +749,10 @@ static void __nvmet_req_complete(struct nvmet_req *req, u16 status)
 
 void nvmet_req_complete(struct nvmet_req *req, u16 status)
 {
+	struct nvmet_sq *sq = req->sq;
+
 	__nvmet_req_complete(req, status);
-	percpu_ref_put(&req->sq->ref);
+	percpu_ref_put(&sq->ref);
 }
 EXPORT_SYMBOL_GPL(nvmet_req_complete);
 
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 8b587fc97f7b..c22cc20db1a7 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -911,7 +911,7 @@ static int pci_pm_resume_noirq(struct device *dev)
 	pcie_pme_root_status_cleanup(pci_dev);
 
 	if (!skip_bus_pm && prev_state == PCI_D3cold)
-		pci_bridge_wait_for_secondary_bus(pci_dev);
+		pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
 
 	if (pci_has_legacy_pm_support(pci_dev))
 		return 0;
@@ -1298,7 +1298,7 @@ static int pci_pm_runtime_resume(struct device *dev)
 	pci_pm_default_resume(pci_dev);
 
 	if (prev_state == PCI_D3cold)
-		pci_bridge_wait_for_secondary_bus(pci_dev);
+		pci_bridge_wait_for_secondary_bus(pci_dev, "resume", PCI_RESET_WAIT);
 
 	if (pm && pm->runtime_resume)
 		error = pm->runtime_resume(dev);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 744a2e05635b..d37013d007b6 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -157,9 +157,6 @@ static int __init pcie_port_pm_setup(char *str)
 }
 __setup("pcie_port_pm=", pcie_port_pm_setup);
 
-/* Time to wait after a reset for device to become responsive */
-#define PCIE_RESET_READY_POLL_MS 60000
-
 /**
  * pci_bus_max_busnr - returns maximum PCI bus number of given bus' children
  * @bus: pointer to PCI bus structure to search
@@ -1221,7 +1218,7 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 			return -ENOTTY;
 		}
 
-		if (delay > 1000)
+		if (delay > PCI_RESET_WAIT)
 			pci_info(dev, "not ready %dms after %s; waiting\n",
 				 delay - 1, reset_type);
 
@@ -1230,7 +1227,7 @@ static int pci_dev_wait(struct pci_dev *dev, char *reset_type, int timeout)
 		pci_read_config_dword(dev, PCI_COMMAND, &id);
 	}
 
-	if (delay > 1000)
+	if (delay > PCI_RESET_WAIT)
 		pci_info(dev, "ready %dms after %s\n", delay - 1,
 			 reset_type);
 
@@ -4792,24 +4789,31 @@ static int pci_bus_max_d3cold_delay(const struct pci_bus *bus)
 /**
  * pci_bridge_wait_for_secondary_bus - Wait for secondary bus to be accessible
  * @dev: PCI bridge
+ * @reset_type: reset type in human-readable form
+ * @timeout: maximum time to wait for devices on secondary bus (milliseconds)
  *
  * Handle necessary delays before access to the devices on the secondary
- * side of the bridge are permitted after D3cold to D0 transition.
+ * side of the bridge are permitted after D3cold to D0 transition
+ * or Conventional Reset.
  *
  * For PCIe this means the delays in PCIe 5.0 section 6.6.1. For
  * conventional PCI it means Tpvrh + Trhfa specified in PCI 3.0 section
  * 4.3.2.
+ *
+ * Return 0 on success or -ENOTTY if the first device on the secondary bus
+ * failed to become accessible.
  */
-void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
+				      int timeout)
 {
 	struct pci_dev *child;
 	int delay;
 
 	if (pci_dev_is_disconnected(dev))
-		return;
+		return 0;
 
 	if (!pci_is_bridge(dev))
-		return;
+		return 0;
 
 	down_read(&pci_bus_sem);
 
@@ -4821,14 +4825,14 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	 */
 	if (!dev->subordinate || list_empty(&dev->subordinate->devices)) {
 		up_read(&pci_bus_sem);
-		return;
+		return 0;
 	}
 
 	/* Take d3cold_delay requirements into account */
 	delay = pci_bus_max_d3cold_delay(dev->subordinate);
 	if (!delay) {
 		up_read(&pci_bus_sem);
-		return;
+		return 0;
 	}
 
 	child = list_first_entry(&dev->subordinate->devices, struct pci_dev,
@@ -4837,14 +4841,12 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 
 	/*
 	 * Conventional PCI and PCI-X we need to wait Tpvrh + Trhfa before
-	 * accessing the device after reset (that is 1000 ms + 100 ms). In
-	 * practice this should not be needed because we don't do power
-	 * management for them (see pci_bridge_d3_possible()).
+	 * accessing the device after reset (that is 1000 ms + 100 ms).
 	 */
 	if (!pci_is_pcie(dev)) {
 		pci_dbg(dev, "waiting %d ms for secondary bus\n", 1000 + delay);
 		msleep(1000 + delay);
-		return;
+		return 0;
 	}
 
 	/*
@@ -4861,11 +4863,11 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	 * configuration requests if we only wait for 100 ms (see
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=203885).
 	 *
-	 * Therefore we wait for 100 ms and check for the device presence.
-	 * If it is still not present give it an additional 100 ms.
+	 * Therefore we wait for 100 ms and check for the device presence
+	 * until the timeout expires.
 	 */
 	if (!pcie_downstream_port(dev))
-		return;
+		return 0;
 
 	if (pcie_get_speed_cap(dev) <= PCIE_SPEED_5_0GT) {
 		pci_dbg(dev, "waiting %d ms for downstream link\n", delay);
@@ -4876,14 +4878,11 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 		if (!pcie_wait_for_link_delay(dev, true, delay)) {
 			/* Did not train, no need to wait any further */
 			pci_info(dev, "Data Link Layer Link Active not set in 1000 msec\n");
-			return;
+			return -ENOTTY;
 		}
 	}
 
-	if (!pci_device_is_present(child)) {
-		pci_dbg(child, "waiting additional %d ms to become accessible\n", delay);
-		msleep(delay);
-	}
+	return pci_dev_wait(child, reset_type, timeout - delay);
 }
 
 void pci_reset_secondary_bus(struct pci_dev *dev)
@@ -4902,15 +4901,6 @@ void pci_reset_secondary_bus(struct pci_dev *dev)
 
 	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
-
-	/*
-	 * Trhfa for conventional PCI is 2^25 clock cycles.
-	 * Assuming a minimum 33MHz clock this results in a 1s
-	 * delay before we can consider subordinate devices to
-	 * be re-initialized.  PCIe has some ways to shorten this,
-	 * but we don't make use of them yet.
-	 */
-	ssleep(1);
 }
 
 void __weak pcibios_reset_secondary_bus(struct pci_dev *dev)
@@ -4929,7 +4919,8 @@ int pci_bridge_secondary_bus_reset(struct pci_dev *dev)
 {
 	pcibios_reset_secondary_bus(dev);
 
-	return pci_dev_wait(dev, "bus reset", PCIE_RESET_READY_POLL_MS);
+	return pci_bridge_wait_for_secondary_bus(dev, "bus reset",
+						 PCIE_RESET_READY_POLL_MS);
 }
 EXPORT_SYMBOL_GPL(pci_bridge_secondary_bus_reset);
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 9197d7362731..72436000ff25 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -47,6 +47,19 @@ int pci_bus_error_reset(struct pci_dev *dev);
 #define PCI_PM_D3HOT_WAIT       10	/* msec */
 #define PCI_PM_D3COLD_WAIT      100	/* msec */
 
+/*
+ * Following exit from Conventional Reset, devices must be ready within 1 sec
+ * (PCIe r6.0 sec 6.6.1).  A D3cold to D0 transition implies a Conventional
+ * Reset (PCIe r6.0 sec 5.8).
+ */
+#define PCI_RESET_WAIT		1000	/* msec */
+/*
+ * Devices may extend the 1 sec period through Request Retry Status completions
+ * (PCIe r6.0 sec 2.3.1).  The spec does not provide an upper limit, but 60 sec
+ * ought to be enough for any device to become responsive.
+ */
+#define PCIE_RESET_READY_POLL_MS 60000	/* msec */
+
 /**
  * struct pci_platform_pm_ops - Firmware PM callbacks
  *
@@ -108,7 +121,8 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev);
 void pci_free_cap_save_buffers(struct pci_dev *dev);
 bool pci_bridge_d3_possible(struct pci_dev *dev);
 void pci_bridge_d3_update(struct pci_dev *dev);
-void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev);
+int pci_bridge_wait_for_secondary_bus(struct pci_dev *dev, char *reset_type,
+				      int timeout);
 
 static inline void pci_wakeup_event(struct pci_dev *dev)
 {
diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index c556e7beafe3..f21d64ae4ffc 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -170,8 +170,8 @@ pci_ers_result_t dpc_reset_link(struct pci_dev *pdev)
 	pci_write_config_word(pdev, cap + PCI_EXP_DPC_STATUS,
 			      PCI_EXP_DPC_STATUS_TRIGGER);
 
-	if (!pcie_wait_for_link(pdev, true)) {
-		pci_info(pdev, "Data Link Layer Link Active not set in 1000 msec\n");
+	if (pci_bridge_wait_for_secondary_bus(pdev, "DPC",
+					      PCIE_RESET_READY_POLL_MS)) {
 		clear_bit(PCI_DPC_RECOVERED, &pdev->priv_flags);
 		ret = PCI_ERS_RESULT_DISCONNECT;
 	} else {
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index fae032324210..18321cf9db5d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -322,10 +322,7 @@ static void scsi_host_dev_release(struct device *dev)
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
 
-	/* In case scsi_remove_host() has not been called. */
-	scsi_proc_hostdir_rm(shost->hostt);
-
-	/* Wait for functions invoked through call_rcu(&shost->rcu, ...) */
+	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
 	if (shost->tmf_work_q)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index b58f4d9c296a..326265fd7f91 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -670,7 +670,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		goto out_fail;
 	}
 	port = sas_port_alloc_num(sas_node->parent_dev);
-	if ((sas_port_add(port))) {
+	if (!port || (sas_port_add(port))) {
 		ioc_err(ioc, "failure at %s:%d/%s()!\n",
 			__FILE__, __LINE__, __func__);
 		goto out_fail;
@@ -695,6 +695,12 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		rphy = sas_expander_alloc(port,
 		    mpt3sas_port->remote_identify.device_type);
 
+	if (!rphy) {
+		ioc_err(ioc, "failure at %s:%d/%s()!\n",
+			__FILE__, __LINE__, __func__);
+		goto out_delete_port;
+	}
+
 	rphy->identify = mpt3sas_port->remote_identify;
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -714,6 +720,7 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 			__FILE__, __LINE__, __func__);
 		sas_rphy_free(rphy);
 		rphy = NULL;
+		goto out_delete_port;
 	}
 
 	if (mpt3sas_port->remote_identify.device_type == SAS_END_DEVICE) {
@@ -740,7 +747,10 @@ mpt3sas_transport_port_add(struct MPT3SAS_ADAPTER *ioc, u16 handle,
 		    rphy_to_expander_device(rphy));
 	return mpt3sas_port;
 
- out_fail:
+out_delete_port:
+	sas_port_delete(port);
+
+out_fail:
 	list_for_each_entry_safe(mpt3sas_phy, next, &mpt3sas_port->phy_list,
 	    port_siblings)
 		list_del(&mpt3sas_phy->port_siblings);
diff --git a/drivers/tty/serial/8250/8250_em.c b/drivers/tty/serial/8250/8250_em.c
index f8e99995eee9..d94c3811a8f7 100644
--- a/drivers/tty/serial/8250/8250_em.c
+++ b/drivers/tty/serial/8250/8250_em.c
@@ -106,8 +106,8 @@ static int serial8250_em_probe(struct platform_device *pdev)
 	memset(&up, 0, sizeof(up));
 	up.port.mapbase = regs->start;
 	up.port.irq = irq;
-	up.port.type = PORT_UNKNOWN;
-	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_IOREMAP;
+	up.port.type = PORT_16750;
+	up.port.flags = UPF_FIXED_PORT | UPF_IOREMAP | UPF_FIXED_TYPE;
 	up.port.dev = &pdev->dev;
 	up.port.private_data = priv;
 
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 9cb0e8673f82..32cce52800a7 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -2159,9 +2159,15 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* update the per-port timeout */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
-	/* wait transmit engin complete */
-	lpuart32_write(&sport->port, 0, UARTMODIR);
-	lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	/*
+	 * LPUART Transmission Complete Flag may never be set while queuing a break
+	 * character, so skip waiting for transmission complete when UARTCTRL_SBK is
+	 * asserted.
+	 */
+	if (!(old_ctrl & UARTCTRL_SBK)) {
+		lpuart32_write(&sport->port, 0, UARTMODIR);
+		lpuart32_wait_bit_set(&sport->port, UARTSTAT, UARTSTAT_TC);
+	}
 
 	/* disable transmit and receive */
 	lpuart32_write(&sport->port, old_ctrl & ~(UARTCTRL_TE | UARTCTRL_RE),
diff --git a/drivers/video/fbdev/stifb.c b/drivers/video/fbdev/stifb.c
index 3feb6e40d56d..ef8a4c5fc687 100644
--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -921,6 +921,28 @@ SETUP_HCRX(struct stifb_info *fb)
 
 /* ------------------- driver specific functions --------------------------- */
 
+static int
+stifb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
+{
+	struct stifb_info *fb = container_of(info, struct stifb_info, info);
+
+	if (var->xres != fb->info.var.xres ||
+	    var->yres != fb->info.var.yres ||
+	    var->bits_per_pixel != fb->info.var.bits_per_pixel)
+		return -EINVAL;
+
+	var->xres_virtual = var->xres;
+	var->yres_virtual = var->yres;
+	var->xoffset = 0;
+	var->yoffset = 0;
+	var->grayscale = fb->info.var.grayscale;
+	var->red.length = fb->info.var.red.length;
+	var->green.length = fb->info.var.green.length;
+	var->blue.length = fb->info.var.blue.length;
+
+	return 0;
+}
+
 static int
 stifb_setcolreg(u_int regno, u_int red, u_int green,
 	      u_int blue, u_int transp, struct fb_info *info)
@@ -1145,6 +1167,7 @@ stifb_init_display(struct stifb_info *fb)
 
 static const struct fb_ops stifb_ops = {
 	.owner		= THIS_MODULE,
+	.fb_check_var	= stifb_check_var,
 	.fb_setcolreg	= stifb_setcolreg,
 	.fb_blank	= stifb_blank,
 	.fb_fillrect	= stifb_fillrect,
@@ -1164,6 +1187,7 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	struct stifb_info *fb;
 	struct fb_info *info;
 	unsigned long sti_rom_address;
+	char modestr[32];
 	char *dev_name;
 	int bpp, xres, yres;
 
@@ -1342,6 +1366,9 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 	info->flags = FBINFO_HWACCEL_COPYAREA | FBINFO_HWACCEL_FILLRECT;
 	info->pseudo_palette = &fb->pseudo_palette;
 
+	scnprintf(modestr, sizeof(modestr), "%dx%d-%d", xres, yres, bpp);
+	fb_find_mode(&info->var, info, modestr, NULL, 0, NULL, bpp);
+
 	/* This has to be done !!! */
 	if (fb_alloc_cmap(&info->cmap, NR_PALETTE, 0))
 		goto out_err1;
diff --git a/fs/attr.c b/fs/attr.c
index 848ffe6e3c24..326a0db3296d 100644
--- a/fs/attr.c
+++ b/fs/attr.c
@@ -18,6 +18,65 @@
 #include <linux/evm.h>
 #include <linux/ima.h>
 
+#include "internal.h"
+
+/**
+ * setattr_should_drop_sgid - determine whether the setgid bit needs to be
+ *                            removed
+ * @inode:	inode to check
+ *
+ * This function determines whether the setgid bit needs to be removed.
+ * We retain backwards compatibility and require setgid bit to be removed
+ * unconditionally if S_IXGRP is set. Otherwise we have the exact same
+ * requirements as setattr_prepare() and setattr_copy().
+ *
+ * Return: ATTR_KILL_SGID if setgid bit needs to be removed, 0 otherwise.
+ */
+int setattr_should_drop_sgid(const struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+
+	if (!(mode & S_ISGID))
+		return 0;
+	if (mode & S_IXGRP)
+		return ATTR_KILL_SGID;
+	if (!in_group_or_capable(inode, inode->i_gid))
+		return ATTR_KILL_SGID;
+	return 0;
+}
+
+/**
+ * setattr_should_drop_suidgid - determine whether the set{g,u}id bit needs to
+ *                               be dropped
+ * @inode:	inode to check
+ *
+ * This function determines whether the set{g,u}id bits need to be removed.
+ * If the setuid bit needs to be removed ATTR_KILL_SUID is returned. If the
+ * setgid bit needs to be removed ATTR_KILL_SGID is returned. If both
+ * set{g,u}id bits need to be removed the corresponding mask of both flags is
+ * returned.
+ *
+ * Return: A mask of ATTR_KILL_S{G,U}ID indicating which - if any - setid bits
+ * to remove, 0 otherwise.
+ */
+int setattr_should_drop_suidgid(struct inode *inode)
+{
+	umode_t mode = inode->i_mode;
+	int kill = 0;
+
+	/* suid always must be killed */
+	if (unlikely(mode & S_ISUID))
+		kill = ATTR_KILL_SUID;
+
+	kill |= setattr_should_drop_sgid(inode);
+
+	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+		return kill;
+
+	return 0;
+}
+EXPORT_SYMBOL(setattr_should_drop_suidgid);
+
 static bool chown_ok(const struct inode *inode, kuid_t uid)
 {
 	if (uid_eq(current_fsuid(), inode->i_uid) &&
@@ -90,9 +149,8 @@ int setattr_prepare(struct dentry *dentry, struct iattr *attr)
 		if (!inode_owner_or_capable(inode))
 			return -EPERM;
 		/* Also check the setgid bit! */
-		if (!in_group_p((ia_valid & ATTR_GID) ? attr->ia_gid :
-				inode->i_gid) &&
-		    !capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		if (!in_group_or_capable(inode, (ia_valid & ATTR_GID) ?
+						attr->ia_gid : inode->i_gid))
 			attr->ia_mode &= ~S_ISGID;
 	}
 
@@ -193,9 +251,7 @@ void setattr_copy(struct inode *inode, const struct iattr *attr)
 		inode->i_ctime = attr->ia_ctime;
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) &&
-		    !capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		if (!in_group_or_capable(inode, inode->i_gid))
 			mode &= ~S_ISGID;
 		inode->i_mode = mode;
 	}
@@ -297,7 +353,7 @@ int notify_change(struct dentry * dentry, struct iattr * attr, struct inode **de
 		}
 	}
 	if (ia_valid & ATTR_KILL_SGID) {
-		if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP)) {
+		if (mode & S_ISGID) {
 			if (!(ia_valid & ATTR_MODE)) {
 				ia_valid = attr->ia_valid |= ATTR_MODE;
 				attr->ia_mode = inode->i_mode;
diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
index 97cd4df04060..e11818801148 100644
--- a/fs/cifs/smb2inode.c
+++ b/fs/cifs/smb2inode.c
@@ -236,15 +236,32 @@ smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		size[0] = 8; /* sizeof __le64 */
 		data[0] = ptr;
 
-		rc = SMB2_set_info_init(tcon, server,
-					&rqst[num_rqst], COMPOUND_FID,
-					COMPOUND_FID, current->tgid,
-					FILE_END_OF_FILE_INFORMATION,
-					SMB2_O_INFO_FILE, 0, data, size);
+		if (cfile) {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						cfile->fid.persistent_fid,
+						cfile->fid.volatile_fid,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+		} else {
+			rc = SMB2_set_info_init(tcon, server,
+						&rqst[num_rqst],
+						COMPOUND_FID,
+						COMPOUND_FID,
+						current->tgid,
+						FILE_END_OF_FILE_INFORMATION,
+						SMB2_O_INFO_FILE, 0,
+						data, size);
+			if (!rc) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			}
+		}
 		if (rc)
 			goto finished;
-		smb2_set_next_command(tcon, &rqst[num_rqst]);
-		smb2_set_related(&rqst[num_rqst++]);
+		num_rqst++;
 		trace_smb3_set_eof_enter(xid, ses->Suid, tcon->tid, full_path);
 		break;
 	case SMB2_OP_SET_INFO:
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b137006f0fd2..4409f56fc37e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -312,7 +312,7 @@ static int
 __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		struct smb_rqst *rqst)
 {
-	int rc = 0;
+	int rc;
 	struct kvec *iov;
 	int n_vec;
 	unsigned int send_length = 0;
@@ -323,6 +323,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
+	cifs_in_send_inc(server);
 	if (cifs_rdma_enabled(server)) {
 		/* return -EAGAIN when connecting or reconnecting */
 		rc = -EAGAIN;
@@ -331,14 +332,17 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		goto smbd_done;
 	}
 
+	rc = -EAGAIN;
 	if (ssocket == NULL)
-		return -EAGAIN;
+		goto out;
 
+	rc = -ERESTARTSYS;
 	if (fatal_signal_pending(current)) {
 		cifs_dbg(FYI, "signal pending before send request\n");
-		return -ERESTARTSYS;
+		goto out;
 	}
 
+	rc = 0;
 	/* cork the socket */
 	tcp_sock_set_cork(ssocket->sk, true);
 
@@ -449,7 +453,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 			 rc);
 	else if (rc > 0)
 		rc = 0;
-
+out:
+	cifs_in_send_dec(server);
 	return rc;
 }
 
@@ -826,9 +831,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
 	cifs_save_when_sent(mid);
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, 1, rqst, flags);
-	cifs_in_send_dec(server);
 
 	if (rc < 0) {
 		revert_current_mid(server, mid->credits);
@@ -1117,9 +1120,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		else
 			midQ[i]->callback = cifs_compound_last_callback;
 	}
-	cifs_in_send_inc(server);
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
-	cifs_in_send_dec(server);
 
 	for (i = 0; i < num_rqst; i++)
 		cifs_save_when_sent(midQ[i]);
@@ -1356,9 +1357,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
@@ -1495,9 +1494,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
-	cifs_in_send_inc(server);
 	rc = smb_send(server, in_buf, len);
-	cifs_in_send_dec(server);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1a654a1f3f46..6ba185b46ba3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4721,13 +4721,6 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 		goto bad_inode;
 	raw_inode = ext4_raw_inode(&iloc);
 
-	if ((ino == EXT4_ROOT_INO) && (raw_inode->i_links_count == 0)) {
-		ext4_error_inode(inode, function, line, 0,
-				 "iget: root inode unallocated");
-		ret = -EFSCORRUPTED;
-		goto bad_inode;
-	}
-
 	if ((flags & EXT4_IGET_HANDLE) &&
 	    (raw_inode->i_links_count == 0) && (raw_inode->i_mode == 0)) {
 		ret = -ESTALE;
@@ -4800,11 +4793,16 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	 * NeilBrown 1999oct15
 	 */
 	if (inode->i_nlink == 0) {
-		if ((inode->i_mode == 0 ||
+		if ((inode->i_mode == 0 || flags & EXT4_IGET_SPECIAL ||
 		     !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS)) &&
 		    ino != EXT4_BOOT_LOADER_INO) {
-			/* this inode is deleted */
-			ret = -ESTALE;
+			/* this inode is deleted or unallocated */
+			if (flags & EXT4_IGET_SPECIAL) {
+				ext4_error_inode(inode, function, line, 0,
+						 "iget: special inode unallocated");
+				ret = -EFSCORRUPTED;
+			} else
+				ret = -ESTALE;
 			goto bad_inode;
 		}
 		/* The only unlinked inodes we let through here have
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 1f47aeca7142..45f719c1e002 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3934,10 +3934,8 @@ static int ext4_rename(struct inode *old_dir, struct dentry *old_dentry,
 				goto end_rename;
 		}
 		retval = ext4_rename_dir_prepare(handle, &old);
-		if (retval) {
-			inode_unlock(old.inode);
+		if (retval)
 			goto end_rename;
-		}
 	}
 	/*
 	 * If we're renaming a file within an inline_data dir and adding or
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 60e122761352..f3da1f2d4cb9 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -386,6 +386,17 @@ static int ext4_xattr_inode_iget(struct inode *parent, unsigned long ea_ino,
 	struct inode *inode;
 	int err;
 
+	/*
+	 * We have to check for this corruption early as otherwise
+	 * iget_locked() could wait indefinitely for the state of our
+	 * parent inode.
+	 */
+	if (parent->i_ino == ea_ino) {
+		ext4_error(parent->i_sb,
+			   "Parent and EA inode have the same ino %lu", ea_ino);
+		return -EFSCORRUPTED;
+	}
+
 	inode = ext4_iget(parent->i_sb, ea_ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
diff --git a/fs/inode.c b/fs/inode.c
index 9f49e0bdc2f7..7ec90788d8be 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1854,35 +1854,6 @@ void touch_atime(const struct path *path)
 }
 EXPORT_SYMBOL(touch_atime);
 
-/*
- * The logic we want is
- *
- *	if suid or (sgid and xgrp)
- *		remove privs
- */
-int should_remove_suid(struct dentry *dentry)
-{
-	umode_t mode = d_inode(dentry)->i_mode;
-	int kill = 0;
-
-	/* suid always must be killed */
-	if (unlikely(mode & S_ISUID))
-		kill = ATTR_KILL_SUID;
-
-	/*
-	 * sgid without any exec bits is just a mandatory locking mark; leave
-	 * it alone.  If some exec bits are set, it's a real sgid; kill it.
-	 */
-	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
-		kill |= ATTR_KILL_SGID;
-
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
-		return kill;
-
-	return 0;
-}
-EXPORT_SYMBOL(should_remove_suid);
-
 /*
  * Return mask of changes for notify_change() that need to be done as a
  * response to write or truncate. Return 0 if nothing has to be changed.
@@ -1897,7 +1868,7 @@ int dentry_needs_remove_privs(struct dentry *dentry)
 	if (IS_NOSEC(inode))
 		return 0;
 
-	mask = should_remove_suid(dentry);
+	mask = setattr_should_drop_suidgid(inode);
 	ret = security_inode_need_killpriv(dentry);
 	if (ret < 0)
 		return ret;
@@ -2147,10 +2118,6 @@ void inode_init_owner(struct inode *inode, const struct inode *dir,
 		/* Directories are special, and always inherit S_ISGID */
 		if (S_ISDIR(mode))
 			mode |= S_ISGID;
-		else if ((mode & (S_ISGID | S_IXGRP)) == (S_ISGID | S_IXGRP) &&
-			 !in_group_p(inode->i_gid) &&
-			 !capable_wrt_inode_uidgid(dir, CAP_FSETID))
-			mode &= ~S_ISGID;
 	} else
 		inode->i_gid = current_fsgid();
 	inode->i_mode = mode;
@@ -2382,3 +2349,48 @@ int vfs_ioc_fssetxattr_check(struct inode *inode, const struct fsxattr *old_fa,
 	return 0;
 }
 EXPORT_SYMBOL(vfs_ioc_fssetxattr_check);
+
+/**
+ * in_group_or_capable - check whether caller is CAP_FSETID privileged
+ * @inode:	inode to check
+ * @gid:	the new/current gid of @inode
+ *
+ * Check wether @gid is in the caller's group list or if the caller is
+ * privileged with CAP_FSETID over @inode. This can be used to determine
+ * whether the setgid bit can be kept or must be dropped.
+ *
+ * Return: true if the caller is sufficiently privileged, false if not.
+ */
+bool in_group_or_capable(const struct inode *inode, kgid_t gid)
+{
+	if (in_group_p(gid))
+		return true;
+	if (capable_wrt_inode_uidgid(inode, CAP_FSETID))
+		return true;
+	return false;
+}
+
+/**
+ * mode_strip_sgid - handle the sgid bit for non-directories
+ * @dir: parent directory inode
+ * @mode: mode of the file to be created in @dir
+ *
+ * If the @mode of the new file has both the S_ISGID and S_IXGRP bit
+ * raised and @dir has the S_ISGID bit raised ensure that the caller is
+ * either in the group of the parent directory or they have CAP_FSETID
+ * in their user namespace and are privileged over the parent directory.
+ * In all other cases, strip the S_ISGID bit from @mode.
+ *
+ * Return: the new mode to use for the file
+ */
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode)
+{
+	if ((mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return mode;
+	if (S_ISDIR(mode) || !dir || !(dir->i_mode & S_ISGID))
+		return mode;
+	if (in_group_or_capable(dir, dir->i_gid))
+		return mode;
+	return mode & ~S_ISGID;
+}
+EXPORT_SYMBOL(mode_strip_sgid);
diff --git a/fs/internal.h b/fs/internal.h
index 06d313b9beec..d5d9fcdae10c 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -149,6 +149,7 @@ extern int vfs_open(const struct path *, struct file *);
 extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
+bool in_group_or_capable(const struct inode *inode, kgid_t gid);
 
 /*
  * fs-writeback.c
@@ -196,3 +197,8 @@ int sb_init_dio_done_wq(struct super_block *sb);
  */
 int do_statx(int dfd, const char __user *filename, unsigned flags,
 	     unsigned int mask, struct statx __user *buffer);
+
+/*
+ * fs/attr.c
+ */
+int setattr_should_drop_sgid(const struct inode *inode);
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index bd7d58d27bfc..97a3c09fd96b 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -138,19 +138,18 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
 	struct jffs2_sb_info *c = JFFS2_SB_INFO(inode->i_sb);
 	pgoff_t index = pos >> PAGE_SHIFT;
-	uint32_t pageofs = index << PAGE_SHIFT;
 	int ret = 0;
 
 	jffs2_dbg(1, "%s()\n", __func__);
 
-	if (pageofs > inode->i_size) {
-		/* Make new hole frag from old EOF to new page */
+	if (pos > inode->i_size) {
+		/* Make new hole frag from old EOF to new position */
 		struct jffs2_raw_inode ri;
 		struct jffs2_full_dnode *fn;
 		uint32_t alloc_len;
 
-		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new page\n",
-			  (unsigned int)inode->i_size, pageofs);
+		jffs2_dbg(1, "Writing new hole frag 0x%x-0x%x between current EOF and new position\n",
+			  (unsigned int)inode->i_size, (uint32_t)pos);
 
 		ret = jffs2_reserve_space(c, sizeof(ri), &alloc_len,
 					  ALLOC_NORMAL, JFFS2_SUMMARY_INODE_SIZE);
@@ -170,10 +169,10 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 		ri.mode = cpu_to_jemode(inode->i_mode);
 		ri.uid = cpu_to_je16(i_uid_read(inode));
 		ri.gid = cpu_to_je16(i_gid_read(inode));
-		ri.isize = cpu_to_je32(max((uint32_t)inode->i_size, pageofs));
+		ri.isize = cpu_to_je32((uint32_t)pos);
 		ri.atime = ri.ctime = ri.mtime = cpu_to_je32(JFFS2_NOW());
 		ri.offset = cpu_to_je32(inode->i_size);
-		ri.dsize = cpu_to_je32(pageofs - inode->i_size);
+		ri.dsize = cpu_to_je32((uint32_t)pos - inode->i_size);
 		ri.csize = cpu_to_je32(0);
 		ri.compr = JFFS2_COMPR_ZERO;
 		ri.node_crc = cpu_to_je32(crc32(0, &ri, sizeof(ri)-8));
@@ -203,7 +202,7 @@ static int jffs2_write_begin(struct file *filp, struct address_space *mapping,
 			goto out_err;
 		}
 		jffs2_complete_reservation(c);
-		inode->i_size = pageofs;
+		inode->i_size = pos;
 		mutex_unlock(&f->sem);
 	}
 
diff --git a/fs/namei.c b/fs/namei.c
index 4159c140fa47..3d98db9802a7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2798,6 +2798,63 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 }
 EXPORT_SYMBOL(unlock_rename);
 
+/**
+ * mode_strip_umask - handle vfs umask stripping
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode to be created in @dir
+ *
+ * Umask stripping depends on whether or not the filesystem supports POSIX
+ * ACLs. If the filesystem doesn't support it umask stripping is done directly
+ * in here. If the filesystem does support POSIX ACLs umask stripping is
+ * deferred until the filesystem calls posix_acl_create().
+ *
+ * Returns: mode
+ */
+static inline umode_t mode_strip_umask(const struct inode *dir, umode_t mode)
+{
+	if (!IS_POSIXACL(dir))
+		mode &= ~current_umask();
+	return mode;
+}
+
+/**
+ * vfs_prepare_mode - prepare the mode to be used for a new inode
+ * @dir:	parent directory of the new inode
+ * @mode:	mode of the new inode
+ * @mask_perms:	allowed permission by the vfs
+ * @type:	type of file to be created
+ *
+ * This helper consolidates and enforces vfs restrictions on the @mode of a new
+ * object to be created.
+ *
+ * Umask stripping depends on whether the filesystem supports POSIX ACLs (see
+ * the kernel documentation for mode_strip_umask()). Moving umask stripping
+ * after setgid stripping allows the same ordering for both non-POSIX ACL and
+ * POSIX ACL supporting filesystems.
+ *
+ * Note that it's currently valid for @type to be 0 if a directory is created.
+ * Filesystems raise that flag individually and we need to check whether each
+ * filesystem can deal with receiving S_IFDIR from the vfs before we enforce a
+ * non-zero type.
+ *
+ * Returns: mode to be passed to the filesystem
+ */
+static inline umode_t vfs_prepare_mode(const struct inode *dir, umode_t mode,
+				       umode_t mask_perms, umode_t type)
+{
+	mode = mode_strip_sgid(dir, mode);
+	mode = mode_strip_umask(dir, mode);
+
+	/*
+	 * Apply the vfs mandated allowed permission mask and set the type of
+	 * file to be created before we call into the filesystem.
+	 */
+	mode &= (mask_perms & ~S_IFMT);
+	mode |= (type & S_IFMT);
+
+	return mode;
+}
+
 int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		bool want_excl)
 {
@@ -2807,8 +2864,8 @@ int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 
 	if (!dir->i_op->create)
 		return -EACCES;	/* shouldn't it be ENOSYS? */
-	mode &= S_IALLUGO;
-	mode |= S_IFREG;
+
+	mode = vfs_prepare_mode(dir, mode, S_IALLUGO, S_IFREG);
 	error = security_inode_create(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3072,8 +3129,7 @@ static struct dentry *lookup_open(struct nameidata *nd, struct file *file,
 	if (open_flag & O_CREAT) {
 		if (open_flag & O_EXCL)
 			open_flag &= ~O_TRUNC;
-		if (!IS_POSIXACL(dir->d_inode))
-			mode &= ~current_umask();
+		mode = vfs_prepare_mode(dir->d_inode, mode, mode, mode);
 		if (likely(got_write))
 			create_error = may_o_create(&nd->path, dentry, mode);
 		else
@@ -3286,8 +3342,7 @@ struct dentry *vfs_tmpfile(struct dentry *dentry, umode_t mode, int open_flag)
 	child = d_alloc(dentry, &slash_name);
 	if (unlikely(!child))
 		goto out_err;
-	if (!IS_POSIXACL(dir))
-		mode &= ~current_umask();
+	mode = vfs_prepare_mode(dir, mode, mode, mode);
 	error = dir->i_op->tmpfile(dir, child, mode);
 	if (error)
 		goto out_err;
@@ -3548,6 +3603,7 @@ int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
 	if (!dir->i_op->mknod)
 		return -EPERM;
 
+	mode = vfs_prepare_mode(dir, mode, mode, mode);
 	error = devcgroup_inode_mknod(mode, dev);
 	if (error)
 		return error;
@@ -3596,9 +3652,8 @@ static long do_mknodat(int dfd, const char __user *filename, umode_t mode,
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mknod(&path, dentry, mode, dev);
+	error = security_path_mknod(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode), dev);
 	if (error)
 		goto out;
 	switch (mode & S_IFMT) {
@@ -3646,7 +3701,7 @@ int vfs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
 	if (!dir->i_op->mkdir)
 		return -EPERM;
 
-	mode &= (S_IRWXUGO|S_ISVTX);
+	mode = vfs_prepare_mode(dir, mode, S_IRWXUGO | S_ISVTX, 0);
 	error = security_inode_mkdir(dir, dentry, mode);
 	if (error)
 		return error;
@@ -3673,9 +3728,8 @@ static long do_mkdirat(int dfd, const char __user *pathname, umode_t mode)
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
-	if (!IS_POSIXACL(path.dentry->d_inode))
-		mode &= ~current_umask();
-	error = security_path_mkdir(&path, dentry, mode);
+	error = security_path_mkdir(&path, dentry,
+			mode_strip_umask(path.dentry->d_inode, mode));
 	if (!error)
 		error = vfs_mkdir(path.dentry->d_inode, dentry, mode);
 	done_path_create(&path, dentry);
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1470b49adb2d..ca00cac5a12f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1994,7 +1994,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 		}
 	}
 
-	if (file && should_remove_suid(file->f_path.dentry)) {
+	if (file && setattr_should_drop_suidgid(file_inode(file))) {
 		ret = __ocfs2_write_remove_suid(inode, di_bh);
 		if (ret) {
 			mlog_errno(ret);
@@ -2282,7 +2282,7 @@ static int ocfs2_prepare_inode_for_write(struct file *file,
 		 * inode. There's also the dinode i_size state which
 		 * can be lost via setattr during extending writes (we
 		 * set inode->i_size at the end of a write. */
-		if (should_remove_suid(dentry)) {
+		if (setattr_should_drop_suidgid(inode)) {
 			if (meta_level == 0) {
 				ocfs2_inode_unlock_for_extent_tree(inode,
 								   &di_bh,
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 856474b0a1ae..df1f6b7aa797 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -198,6 +198,7 @@ static struct inode *ocfs2_get_init_inode(struct inode *dir, umode_t mode)
 	 * callers. */
 	if (S_ISDIR(mode))
 		set_nlink(inode, 2);
+	mode = mode_strip_sgid(dir, mode);
 	inode_init_owner(inode, dir, mode);
 	status = dquot_initialize(inode);
 	if (status)
diff --git a/fs/open.c b/fs/open.c
index b3fbb4300fc9..1ca4b236fdbe 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -665,10 +665,10 @@ int chown_common(const struct path *path, uid_t user, gid_t group)
 		newattrs.ia_valid |= ATTR_GID;
 		newattrs.ia_gid = gid;
 	}
-	if (!S_ISDIR(inode->i_mode))
-		newattrs.ia_valid |=
-			ATTR_KILL_SUID | ATTR_KILL_SGID | ATTR_KILL_PRIV;
 	inode_lock(inode);
+	if (!S_ISDIR(inode->i_mode))
+		newattrs.ia_valid |= ATTR_KILL_SUID | ATTR_KILL_PRIV |
+				     setattr_should_drop_sgid(inode);
 	error = security_path_chown(path, uid, gid);
 	if (!error)
 		error = notify_change(path->dentry, &newattrs, &delegated_inode);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 24c7d30e41df..0926363179a7 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3190,7 +3190,7 @@ xfs_btree_insrec(
 	struct xfs_btree_block	*block;	/* btree block */
 	struct xfs_buf		*bp;	/* buffer for block */
 	union xfs_btree_ptr	nptr;	/* new block ptr */
-	struct xfs_btree_cur	*ncur;	/* new btree cursor */
+	struct xfs_btree_cur	*ncur = NULL;	/* new btree cursor */
 	union xfs_btree_key	nkey;	/* new block key */
 	union xfs_btree_key	*lkey;
 	int			optr;	/* old key/record index */
@@ -3270,7 +3270,7 @@ xfs_btree_insrec(
 #ifdef DEBUG
 	error = xfs_btree_check_block(cur, block, level, bp);
 	if (error)
-		return error;
+		goto error0;
 #endif
 
 	/*
@@ -3290,7 +3290,7 @@ xfs_btree_insrec(
 		for (i = numrecs - ptr; i >= 0; i--) {
 			error = xfs_btree_debug_check_ptr(cur, pp, i, level);
 			if (error)
-				return error;
+				goto error0;
 		}
 
 		xfs_btree_shift_keys(cur, kp, 1, numrecs - ptr + 1);
@@ -3375,6 +3375,8 @@ xfs_btree_insrec(
 	return 0;
 
 error0:
+	if (ncur)
+		xfs_btree_del_cursor(ncur, error);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 7371a7f7c652..fbab1042bc90 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -800,9 +800,6 @@ xfs_alloc_file_space(
 			quota_flag = XFS_QMOPT_RES_REGBLKS;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
 				resrtextents, 0, &tp);
 
@@ -830,9 +827,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error0;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 4d6bf8d4974f..9b6c5ba5fdfb 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -94,8 +94,6 @@ xfs_update_prealloc_flags(
 		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	if (flags & XFS_PREALLOC_SYNC)
-		xfs_trans_set_sync(tp);
 	return xfs_trans_commit(tp);
 }
 
@@ -852,7 +850,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -897,6 +894,10 @@ xfs_file_fallocate(
 			goto out_unlock;
 	}
 
+	error = file_modified(file);
+	if (error)
+		goto out_unlock;
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		error = xfs_free_file_space(ip, offset, len);
 		if (error)
@@ -946,8 +947,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1000,13 +999,6 @@ xfs_file_fallocate(
 		}
 	}
 
-	if (file->f_flags & O_DSYNC)
-		flags |= XFS_PREALLOC_SYNC;
-
-	error = xfs_update_prealloc_flags(ip, flags);
-	if (error)
-		goto out_unlock;
-
 	/* Change file size if needed */
 	if (new_size) {
 		struct iattr iattr;
@@ -1024,8 +1016,14 @@ xfs_file_fallocate(
 	 * leave shifted extents past EOF and hence losing access to
 	 * the data that is contained within them.
 	 */
-	if (do_file_insert)
+	if (do_file_insert) {
 		error = xfs_insert_file_space(ip, offset, len);
+		if (error)
+			goto out_unlock;
+	}
+
+	if (file->f_flags & O_DSYNC)
+		error = xfs_log_force_inode(ip);
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6a3026e78a9b..69fef29df428 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -595,37 +595,6 @@ xfs_vn_getattr(
 	return 0;
 }
 
-static void
-xfs_setattr_mode(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-	umode_t			mode = iattr->ia_mode;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	inode->i_mode &= S_IFMT;
-	inode->i_mode |= mode & ~S_IFMT;
-}
-
-void
-xfs_setattr_time(
-	struct xfs_inode	*ip,
-	struct iattr		*iattr)
-{
-	struct inode		*inode = VFS_I(ip);
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	if (iattr->ia_valid & ATTR_ATIME)
-		inode->i_atime = iattr->ia_atime;
-	if (iattr->ia_valid & ATTR_CTIME)
-		inode->i_ctime = iattr->ia_ctime;
-	if (iattr->ia_valid & ATTR_MTIME)
-		inode->i_mtime = iattr->ia_mtime;
-}
-
 static int
 xfs_vn_change_ok(
 	struct dentry	*dentry,
@@ -740,16 +709,6 @@ xfs_setattr_nonsize(
 				goto out_cancel;
 		}
 
-		/*
-		 * CAP_FSETID overrides the following restrictions:
-		 *
-		 * The set-user-ID and set-group-ID bits of a file will be
-		 * cleared upon successful return from chown()
-		 */
-		if ((inode->i_mode & (S_ISUID|S_ISGID)) &&
-		    !capable(CAP_FSETID))
-			inode->i_mode &= ~(S_ISUID|S_ISGID);
-
 		/*
 		 * Change the ownerships and register quota modifications
 		 * in the transaction.
@@ -761,7 +720,6 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
 			if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_GQUOTA_ON(mp)) {
@@ -772,15 +730,10 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			inode->i_gid = gid;
 		}
 	}
 
-	if (mask & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (mask & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	setattr_copy(inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
@@ -1025,11 +978,8 @@ xfs_setattr_size(
 		xfs_inode_clear_eofblocks_tag(ip);
 	}
 
-	if (iattr->ia_valid & ATTR_MODE)
-		xfs_setattr_mode(ip, iattr);
-	if (iattr->ia_valid & (ATTR_ATIME|ATTR_CTIME|ATTR_MTIME))
-		xfs_setattr_time(ip, iattr);
-
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(inode, iattr);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_iops.h b/fs/xfs/xfs_iops.h
index 4d24ff309f59..dd1bd0332f8e 100644
--- a/fs/xfs/xfs_iops.h
+++ b/fs/xfs/xfs_iops.h
@@ -18,7 +18,6 @@ extern ssize_t xfs_vn_listxattr(struct dentry *, char *data, size_t size);
  */
 #define XFS_ATTR_NOACL		0x01	/* Don't call posix_acl_chmod */
 
-extern void xfs_setattr_time(struct xfs_inode *ip, struct iattr *iattr);
 extern int xfs_setattr_nonsize(struct xfs_inode *ip, struct iattr *vap,
 			       int flags);
 extern int xfs_vn_setattr_nonsize(struct dentry *dentry, struct iattr *vap);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a2a5a0fd9233..402cf828cc91 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -126,7 +126,6 @@ __xfs_free_perag(
 {
 	struct xfs_perag *pag = container_of(head, struct xfs_perag, rcu_head);
 
-	ASSERT(atomic_read(&pag->pag_ref) == 0);
 	kmem_free(pag);
 }
 
@@ -145,7 +144,7 @@ xfs_free_perag(
 		pag = radix_tree_delete(&mp->m_perag_tree, agno);
 		spin_unlock(&mp->m_perag_lock);
 		ASSERT(pag);
-		ASSERT(atomic_read(&pag->pag_ref) == 0);
+		XFS_IS_CORRUPT(pag->pag_mount, atomic_read(&pag->pag_ref) != 0);
 		xfs_iunlink_destroy(pag);
 		xfs_buf_hash_destroy(pag);
 		call_rcu(&pag->rcu_head, __xfs_free_perag);
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index f3082a957d5e..053b99929f83 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -164,10 +164,12 @@ xfs_fs_map_blocks(
 		 * that the blocks allocated and handed out to the client are
 		 * guaranteed to be present even after a server crash.
 		 */
-		error = xfs_update_prealloc_flags(ip,
-				XFS_PREALLOC_SET | XFS_PREALLOC_SYNC);
+		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
+		if (!error)
+			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
+
 	} else {
 		xfs_iunlock(ip, lock_flags);
 	}
@@ -283,7 +285,8 @@ xfs_fs_commit_blocks(
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	xfs_setattr_time(ip, iattr);
+	ASSERT(!(iattr->ia_valid & (ATTR_UID | ATTR_GID)));
+	setattr_copy(inode, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
 		ip->i_d.di_size = iattr->ia_size;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 64e5da33733b..3c17e0c0f816 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1318,8 +1318,15 @@ xfs_qm_quotacheck(
 
 	error = xfs_iwalk_threaded(mp, 0, 0, xfs_qm_dqusage_adjust, 0, true,
 			NULL);
-	if (error)
+	if (error) {
+		/*
+		 * The inode walk may have partially populated the dquot
+		 * caches.  We must purge them before disabling quota and
+		 * tearing down the quotainfo, or else the dquots will leak.
+		 */
+		xfs_qm_dqpurge_all(mp, XFS_QMOPT_QUOTALL);
 		goto error_return;
+	}
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 2195daa289d2..055486e35e68 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -427,11 +427,11 @@ struct drm_bridge_funcs {
 	 *
 	 * The returned array must be allocated with kmalloc() and will be
 	 * freed by the caller. If the allocation fails, NULL should be
-	 * returned. num_output_fmts must be set to the returned array size.
+	 * returned. num_input_fmts must be set to the returned array size.
 	 * Formats listed in the returned array should be listed in decreasing
 	 * preference order (the core will try all formats until it finds one
 	 * that works). When the format is not supported NULL should be
-	 * returned and num_output_fmts should be set to 0.
+	 * returned and num_input_fmts should be set to 0.
 	 *
 	 * This method is called on all elements of the bridge chain as part of
 	 * the bus format negotiation process that happens in
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 74e19bccbf73..8ce9e5c61ede 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1768,6 +1768,7 @@ extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
 extern void inode_init_owner(struct inode *inode, const struct inode *dir,
 			umode_t mode);
 extern bool may_open_dev(const struct path *path);
+umode_t mode_strip_sgid(const struct inode *dir, umode_t mode);
 
 /*
  * This is the "filldir" function type, used by readdir() to let
@@ -2959,7 +2960,7 @@ extern void __destroy_inode(struct inode *);
 extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
-extern int should_remove_suid(struct dentry *);
+extern int setattr_should_drop_suidgid(struct inode *);
 extern int file_remove_privs(struct file *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
@@ -3407,7 +3408,7 @@ int __init get_filesystem_list(char *buf);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct inode *dir, struct inode *inode)
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 2ba33d708942..256f34f49167 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -798,6 +798,7 @@ struct hid_driver {
  * @raw_request: send raw report request to device (e.g. feature report)
  * @output_report: send output report to device
  * @idle: send idle request to device
+ * @max_buffer_size: over-ride maximum data buffer size (default: HID_MAX_BUFFER_SIZE)
  */
 struct hid_ll_driver {
 	int (*start)(struct hid_device *hdev);
@@ -822,6 +823,8 @@ struct hid_ll_driver {
 	int (*output_report) (struct hid_device *hdev, __u8 *buf, size_t len);
 
 	int (*idle)(struct hid_device *hdev, int report, int idle, int reqtype);
+
+	unsigned int max_buffer_size;
 };
 
 extern struct hid_ll_driver i2c_hid_ll_driver;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b478a16ef284..9ef63bc14b00 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -270,9 +270,11 @@ struct hh_cache {
  * relationship HH alignment <= LL alignment.
  */
 #define LL_RESERVED_SPACE(dev) \
-	((((dev)->hard_header_len+(dev)->needed_headroom)&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 #define LL_RESERVED_SPACE_EXTRA(dev,extra) \
-	((((dev)->hard_header_len+(dev)->needed_headroom+(extra))&~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
+	((((dev)->hard_header_len + READ_ONCE((dev)->needed_headroom) + (extra)) \
+	  & ~(HH_DATA_MOD - 1)) + HH_DATA_MOD)
 
 struct header_ops {
 	int	(*create) (struct sk_buff *skb, struct net_device *dev,
diff --git a/include/linux/sh_intc.h b/include/linux/sh_intc.h
index c255273b0281..37ad81058d6a 100644
--- a/include/linux/sh_intc.h
+++ b/include/linux/sh_intc.h
@@ -97,7 +97,10 @@ struct intc_hw_desc {
 	unsigned int nr_subgroups;
 };
 
-#define _INTC_ARRAY(a) a, __same_type(a, NULL) ? 0 : sizeof(a)/sizeof(*a)
+#define _INTC_SIZEOF_OR_ZERO(a) (_Generic(a,                 \
+                                 typeof(NULL):  0,           \
+                                 default:       sizeof(a)))
+#define _INTC_ARRAY(a) a, _INTC_SIZEOF_OR_ZERO(a)/sizeof(*a)
 
 #define INTC_HW_DESC(vectors, groups, mask_regs,	\
 		     prio_regs,	sense_regs, ack_regs)	\
diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index e4c5df71f0e7..4e1356c35fe6 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -234,12 +234,11 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
  * not add unwanted padding between the beginning of the section and the
  * structure. Force alignment to the same alignment as the section start.
  *
- * When lockdep is enabled, we make sure to always do the RCU portions of
- * the tracepoint code, regardless of whether tracing is on. However,
- * don't check if the condition is false, due to interaction with idle
- * instrumentation. This lets us find RCU issues triggered with tracepoints
- * even when this tracepoint is off. This code has no purpose other than
- * poking RCU a bit.
+ * When lockdep is enabled, we make sure to always test if RCU is
+ * "watching" regardless if the tracepoint is enabled or not. Tracepoints
+ * require RCU to be active, and it should always warn at the tracepoint
+ * site if it is not watching, as it will need to be active when the
+ * tracepoint is enabled.
  */
 #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
 	extern int __traceiter_##name(data_proto);			\
@@ -253,9 +252,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 				TP_ARGS(data_args),			\
 				TP_CONDITION(cond), 0);			\
 		if (IS_ENABLED(CONFIG_LOCKDEP) && (cond)) {		\
-			rcu_read_lock_sched_notrace();			\
-			rcu_dereference_sched(__tracepoint_##name.funcs);\
-			rcu_read_unlock_sched_notrace();		\
+			WARN_ON_ONCE(!rcu_is_watching());		\
 		}							\
 	}								\
 	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 445afda927f4..fd799567fc23 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -5792,10 +5792,10 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		if (unlikely(!apoll))
+			return IO_APOLL_ABORTED;
 		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
-	if (unlikely(!apoll))
-		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d97c189695cb..67829b6e07bd 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1538,7 +1538,8 @@ static struct dyn_ftrace *lookup_rec(unsigned long start, unsigned long end)
 	key.flags = end;	/* overload flags, as it is unsigned long */
 
 	for (pg = ftrace_pages_start; pg; pg = pg->next) {
-		if (end < pg->records[0].ip ||
+		if (pg->index == 0 ||
+		    end < pg->records[0].ip ||
 		    start >= (pg->records[pg->index - 1].ip + MCOUNT_INSN_SIZE))
 			continue;
 		rec = bsearch(&key, pg->records, pg->index,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8637eab2986e..ce45bdd9077d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4705,6 +4705,8 @@ loff_t tracing_lseek(struct file *file, loff_t offset, int whence)
 static const struct file_operations tracing_fops = {
 	.open		= tracing_open,
 	.read		= seq_read,
+	.read_iter	= seq_read_iter,
+	.splice_read	= generic_file_splice_read,
 	.write		= tracing_write_stub,
 	.llseek		= tracing_lseek,
 	.release	= tracing_release,
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index ccc99cd23f3c..9ed65191888e 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1087,6 +1087,9 @@ static const char *hist_field_name(struct hist_field *field,
 {
 	const char *field_name = "";
 
+	if (WARN_ON_ONCE(!field))
+		return field_name;
+
 	if (level > 1)
 		return field_name;
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9b15760e0541..e4c690c21fc9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1994,7 +1994,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 {
 	struct mm_struct *mm = vma->vm_mm;
 	pgtable_t pgtable;
-	pmd_t _pmd;
+	pmd_t _pmd, old_pmd;
 	int i;
 
 	/*
@@ -2005,7 +2005,7 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 	 *
 	 * See Documentation/vm/mmu_notifier.rst
 	 */
-	pmdp_huge_clear_flush(vma, haddr, pmd);
+	old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
 	pmd_populate(mm, &_pmd, pgtable);
@@ -2014,6 +2014,8 @@ static void __split_huge_zero_page_pmd(struct vm_area_struct *vma,
 		pte_t *pte, entry;
 		entry = pfn_pte(my_zero_pfn(haddr), vma->vm_page_prot);
 		entry = pte_mkspecial(entry);
+		if (pmd_uffd_wp(old_pmd))
+			entry = pte_mkuffd_wp(entry);
 		pte = pte_offset_map(&_pmd, haddr);
 		VM_BUG_ON(!pte_none(*pte));
 		set_pte_at(mm, haddr, pte, entry);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 5f786ef662ea..41f890bf9d4c 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -573,6 +573,9 @@ static int rtentry_to_fib_config(struct net *net, int cmd, struct rtentry *rt,
 			cfg->fc_scope = RT_SCOPE_UNIVERSE;
 	}
 
+	if (!cfg->fc_table)
+		cfg->fc_table = RT_TABLE_MAIN;
+
 	if (cmd == SIOCDELRT)
 		return 0;
 
diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index be75b409445c..99f70b990eb1 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -613,10 +613,10 @@ void ip_md_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 	}
 
 	headroom += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
-	if (headroom > dev->needed_headroom)
-		dev->needed_headroom = headroom;
+	if (headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		goto tx_dropped;
 	}
@@ -797,10 +797,10 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 
 	max_headroom = LL_RESERVED_SPACE(rt->dst.dev) + sizeof(struct iphdr)
 			+ rt->dst.header_len + ip_encap_hlen(&tunnel->encap);
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
-	if (skb_cow_head(skb, dev->needed_headroom)) {
+	if (skb_cow_head(skb, READ_ONCE(dev->needed_headroom))) {
 		ip_rt_put(rt);
 		dev->stats.tx_dropped++;
 		kfree_skb(skb);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index eefd032bc6db..e4ad274ec7a3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -3609,7 +3609,7 @@ struct sk_buff *tcp_make_synack(const struct sock *sk, struct dst_entry *dst,
 	th->window = htons(min(req->rsk_rcv_wnd, 65535U));
 	tcp_options_write((__be32 *)(th + 1), NULL, &opts);
 	th->doff = (tcp_header_size >> 2);
-	__TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
+	TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
 
 #ifdef CONFIG_TCP_MD5SIG
 	/* Okay, we have all we need - do the md5 hash if needed */
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 0d4cab94c5dd..a03a322e0cc1 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -1267,8 +1267,8 @@ int ip6_tnl_xmit(struct sk_buff *skb, struct net_device *dev, __u8 dsfield,
 	 */
 	max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
 			+ dst->header_len + t->hlen;
-	if (max_headroom > dev->needed_headroom)
-		dev->needed_headroom = max_headroom;
+	if (max_headroom > READ_ONCE(dev->needed_headroom))
+		WRITE_ONCE(dev->needed_headroom, max_headroom);
 
 	err = ip6_tnl_encap(skb, t, &proto, fl6);
 	if (err)
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 349c6ac3313f..6f84978a7726 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -83,7 +83,7 @@ struct iucv_irq_data {
 	u16 ippathid;
 	u8  ipflags1;
 	u8  iptype;
-	u32 res2[8];
+	u32 res2[9];
 };
 
 struct iucv_irq_list {
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3b154ad4945c..607519246bf2 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -275,7 +275,6 @@ void mptcp_subflow_reset(struct sock *ssk)
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = subflow->conn;
 
-	tcp_set_state(ssk, TCP_CLOSE);
 	tcp_send_active_reset(ssk, GFP_ATOMIC);
 	tcp_done(ssk);
 	if (!test_and_set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &mptcp_sk(sk)->flags) &&
diff --git a/net/netfilter/nft_masq.c b/net/netfilter/nft_masq.c
index 9953e8053753..1818dbf089ca 100644
--- a/net/netfilter/nft_masq.c
+++ b/net/netfilter/nft_masq.c
@@ -43,7 +43,7 @@ static int nft_masq_init(const struct nft_ctx *ctx,
 			 const struct nft_expr *expr,
 			 const struct nlattr * const tb[])
 {
-	u32 plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	u32 plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	struct nft_masq *priv = nft_expr_priv(expr);
 	int err;
 
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index db8f9116eeb4..cd4eb4996aff 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -226,7 +226,7 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
diff --git a/net/netfilter/nft_redir.c b/net/netfilter/nft_redir.c
index ba09890dddb5..e64f531d66cf 100644
--- a/net/netfilter/nft_redir.c
+++ b/net/netfilter/nft_redir.c
@@ -48,7 +48,7 @@ static int nft_redir_init(const struct nft_ctx *ctx,
 	unsigned int plen;
 	int err;
 
-	plen = sizeof_field(struct nf_nat_range, min_addr.all);
+	plen = sizeof_field(struct nf_nat_range, min_proto.all);
 	if (tb[NFTA_REDIR_REG_PROTO_MIN]) {
 		err = nft_parse_register_load(tb[NFTA_REDIR_REG_PROTO_MIN],
 					      &priv->sreg_proto_min, plen);
@@ -232,7 +232,7 @@ static struct nft_expr_type nft_redir_inet_type __read_mostly = {
 	.name		= "redir",
 	.ops		= &nft_redir_inet_ops,
 	.policy		= nft_redir_policy,
-	.maxattr	= NFTA_MASQ_MAX,
+	.maxattr	= NFTA_REDIR_MAX,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 94503f36b9a6..9125d28d9ff5 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -104,6 +104,9 @@ int smc_cdc_msg_send(struct smc_connection *conn,
 	union smc_host_cursor cfed;
 	int rc;
 
+	if (unlikely(!READ_ONCE(conn->sndbuf_desc)))
+		return -ENOBUFS;
+
 	smc_cdc_add_pending_send(conn, pend);
 
 	conn->tx_cdc_seq++;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index bf485a2017a4..e84241ff4ac4 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -912,7 +912,7 @@ static void __smc_lgr_terminate(struct smc_link_group *lgr, bool soft)
 	if (lgr->terminating)
 		return;	/* lgr already terminating */
 	/* cancel free_work sync, will terminate when lgr->freeing is set */
-	cancel_delayed_work_sync(&lgr->free_work);
+	cancel_delayed_work(&lgr->free_work);
 	lgr->terminating = 1;
 
 	/* kill remaining link group connections */
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index fdbd56ed4bd5..ba73014805a4 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2611,9 +2611,6 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 		if (inner_mode == NULL)
 			goto error;
 
-		if (!(inner_mode->flags & XFRM_MODE_FLAG_TUNNEL))
-			goto error;
-
 		x->inner_mode = *inner_mode;
 
 		if (x->props.family == AF_INET)
diff --git a/sound/hda/intel-dsp-config.c b/sound/hda/intel-dsp-config.c
index 2a5ba9dca6b0..f96e70c85f84 100644
--- a/sound/hda/intel-dsp-config.c
+++ b/sound/hda/intel-dsp-config.c
@@ -359,6 +359,15 @@ static const struct config_entry config_table[] = {
 	},
 #endif
 
+/* Meteor Lake */
+#if IS_ENABLED(CONFIG_SND_SOC_SOF_METEORLAKE)
+	/* Meteorlake-P */
+	{
+		.flags = FLAG_SOF | FLAG_SOF_ONLY_IF_DMIC_OR_SOUNDWIRE,
+		.device = 0x7e28,
+	},
+#endif
+
 };
 
 static const struct config_entry *snd_intel_dsp_find_config
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 494bfd2135a9..de1fe604905f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -365,14 +365,15 @@ enum {
 #define needs_eld_notify_link(chip)	false
 #endif
 
-#define CONTROLLER_IN_GPU(pci) (((pci)->device == 0x0a0c) || \
+#define CONTROLLER_IN_GPU(pci) (((pci)->vendor == 0x8086) &&         \
+				       (((pci)->device == 0x0a0c) || \
 					((pci)->device == 0x0c0c) || \
 					((pci)->device == 0x0d0c) || \
 					((pci)->device == 0x160c) || \
 					((pci)->device == 0x490d) || \
 					((pci)->device == 0x4f90) || \
 					((pci)->device == 0x4f91) || \
-					((pci)->device == 0x4f92))
+					((pci)->device == 0x4f92)))
 
 #define IS_BXT(pci) ((pci)->vendor == 0x8086 && (pci)->device == 0x5a98)
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f2ef75c8de42..2cf6600c9ca8 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9091,6 +9091,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),
diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
index 834066d465fc..f0fbd7367f4f 100755
--- a/tools/testing/selftests/net/devlink_port_split.py
+++ b/tools/testing/selftests/net/devlink_port_split.py
@@ -57,6 +57,8 @@ class devlink_ports(object):
         assert stderr == ""
         ports = json.loads(stdout)['port']
 
+        validate_devlink_output(ports, 'flavour')
+
         for port in ports:
             if dev in port:
                 if ports[port]['flavour'] == 'physical':
@@ -218,6 +220,27 @@ def split_splittable_port(port, k, lanes, dev):
     unsplit(port.bus_info)
 
 
+def validate_devlink_output(devlink_data, target_property=None):
+    """
+    Determine if test should be skipped by checking:
+      1. devlink_data contains values
+      2. The target_property exist in devlink_data
+    """
+    skip_reason = None
+    if any(devlink_data.values()):
+        if target_property:
+            skip_reason = "{} not found in devlink output, test skipped".format(target_property)
+            for key in devlink_data:
+                if target_property in devlink_data[key]:
+                    skip_reason = None
+    else:
+        skip_reason = 'devlink output is empty, test skipped'
+
+    if skip_reason:
+        print(skip_reason)
+        sys.exit(KSFT_SKIP)
+
+
 def make_parser():
     parser = argparse.ArgumentParser(description='A test for port splitting.')
     parser.add_argument('--dev',
@@ -238,6 +261,7 @@ def main(cmdline=None):
         stdout, stderr = run_command(cmd)
         assert stderr == ""
 
+        validate_devlink_output(json.loads(stdout))
         devs = json.loads(stdout)['dev']
         dev = list(devs.keys())[0]
 
@@ -249,6 +273,7 @@ def main(cmdline=None):
 
     ports = devlink_ports(dev)
 
+    found_max_lanes = False
     for port in ports.if_names:
         max_lanes = get_max_lanes(port.name)
 
@@ -271,6 +296,11 @@ def main(cmdline=None):
                 split_splittable_port(port, lane, max_lanes, dev)
 
                 lane //= 2
+        found_max_lanes = True
+
+    if not found_max_lanes:
+        print(f"Test not started, no port of device {dev} reports max_lanes")
+        sys.exit(KSFT_SKIP)
 
 
 if __name__ == "__main__":
