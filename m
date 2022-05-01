Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C845164F3
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 17:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbiEAP1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 11:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241060AbiEAP1x (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 11:27:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D733054E;
        Sun,  1 May 2022 08:24:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D27BB80E03;
        Sun,  1 May 2022 15:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49169C385A9;
        Sun,  1 May 2022 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651418663;
        bh=MOiur1yPHg8sxhNkt9jdoqIqaNMXwVKO4UJqXsk5YnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSUcIY6XtHOC+NmERywdwFvdeqXqHvJtfgx37y/KQsphcbGsc5xXzQRsx0jUBCVqU
         9R8oAE3eDMfnE3iJT7GijNYCnGbHoWslqQk912afool2RFwIfH6skWsy4wlT9B3UTD
         opCWzQHAugULu+xWa1oWFepLkp9I3zgQYyqNXERo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.19.241
Date:   Sun,  1 May 2022 17:24:00 +0200
Message-Id: <165141863925398@kroah.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <165141863986144@kroah.com>
References: <165141863986144@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 546e52f8a05f..58fb76d1d7d3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 19
-SUBLEVEL = 240
+SUBLEVEL = 241
 EXTRAVERSION =
 NAME = "People's Front"
 
diff --git a/arch/ia64/kernel/kprobes.c b/arch/ia64/kernel/kprobes.c
index 9cfd3ac027b7..7fc0806bbdc9 100644
--- a/arch/ia64/kernel/kprobes.c
+++ b/arch/ia64/kernel/kprobes.c
@@ -409,10 +409,83 @@ static void kretprobe_trampoline(void)
 {
 }
 
+/*
+ * At this point the target function has been tricked into
+ * returning into our trampoline.  Lookup the associated instance
+ * and then:
+ *    - call the handler function
+ *    - cleanup by marking the instance as unused
+ *    - long jump back to the original return address
+ */
 int __kprobes trampoline_probe_handler(struct kprobe *p, struct pt_regs *regs)
 {
-	regs->cr_iip = __kretprobe_trampoline_handler(regs,
-		dereference_function_descriptor(kretprobe_trampoline), NULL);
+	struct kretprobe_instance *ri = NULL;
+	struct hlist_head *head, empty_rp;
+	struct hlist_node *tmp;
+	unsigned long flags, orig_ret_address = 0;
+	unsigned long trampoline_address =
+		(unsigned long)dereference_function_descriptor(kretprobe_trampoline);
+
+	INIT_HLIST_HEAD(&empty_rp);
+	kretprobe_hash_lock(current, &head, &flags);
+
+	/*
+	 * It is possible to have multiple instances associated with a given
+	 * task either because an multiple functions in the call path
+	 * have a return probe installed on them, and/or more than one return
+	 * return probe was registered for a target function.
+	 *
+	 * We can handle this because:
+	 *     - instances are always inserted at the head of the list
+	 *     - when multiple return probes are registered for the same
+	 *       function, the first instance's ret_addr will point to the
+	 *       real return address, and all the rest will point to
+	 *       kretprobe_trampoline
+	 */
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+
+	regs->cr_iip = orig_ret_address;
+
+	hlist_for_each_entry_safe(ri, tmp, head, hlist) {
+		if (ri->task != current)
+			/* another task is sharing our hash bucket */
+			continue;
+
+		if (ri->rp && ri->rp->handler)
+			ri->rp->handler(ri, regs);
+
+		orig_ret_address = (unsigned long)ri->ret_addr;
+		recycle_rp_inst(ri, &empty_rp);
+
+		if (orig_ret_address != trampoline_address)
+			/*
+			 * This is the real return address. Any other
+			 * instances associated with this task are for
+			 * other calls deeper on the call stack
+			 */
+			break;
+	}
+	kretprobe_assert(ri, orig_ret_address, trampoline_address);
+
+	kretprobe_hash_unlock(current, &flags);
+
+	hlist_for_each_entry_safe(ri, tmp, &empty_rp, hlist) {
+		hlist_del(&ri->hlist);
+		kfree(ri);
+	}
 	/*
 	 * By returning a non-zero value, we are telling
 	 * kprobe_handler() that we don't want the post_handler
@@ -425,7 +498,6 @@ void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
 	ri->ret_addr = (kprobe_opcode_t *)regs->b0;
-	ri->fp = NULL;
 
 	/* Replace the return addr with trampoline addr */
 	regs->b0 = (unsigned long)dereference_function_descriptor(kretprobe_trampoline);
diff --git a/arch/powerpc/include/asm/exception-64s.h b/arch/powerpc/include/asm/exception-64s.h
index 35fb5b11955a..4fdae1c182df 100644
--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -48,11 +48,12 @@
 #define EX_CCR		52
 #define EX_CFAR		56
 #define EX_PPR		64
+#define EX_LR		72
 #if defined(CONFIG_RELOCATABLE)
-#define EX_CTR		72
-#define EX_SIZE		10	/* size in u64 units */
+#define EX_CTR		80
+#define EX_SIZE		11	/* size in u64 units */
 #else
-#define EX_SIZE		9	/* size in u64 units */
+#define EX_SIZE		10	/* size in u64 units */
 #endif
 
 /*
@@ -60,14 +61,6 @@
  */
 #define MAX_MCE_DEPTH	4
 
-/*
- * EX_LR is only used in EXSLB and where it does not overlap with EX_DAR
- * EX_CCR similarly with DSISR, but being 4 byte registers there is a hole
- * in the save area so it's not necessary to overlap them. Could be used
- * for future savings though if another 4 byte register was to be saved.
- */
-#define EX_LR		EX_DAR
-
 /*
  * EX_R3 is only used by the bad_stack handler. bad_stack reloads and
  * saves DAR from SPRN_DAR, and EX_DAR is not used. So EX_R3 can overlap
@@ -243,10 +236,22 @@
  * PPR save/restore macros used in exceptions_64s.S  
  * Used for P7 or later processors
  */
-#define SAVE_PPR(area, ra, rb)						\
+#define SAVE_PPR(area, ra)						\
+BEGIN_FTR_SECTION_NESTED(940)						\
+	ld	ra,area+EX_PPR(r13);	/* Read PPR from paca */	\
+	std	ra,RESULT(r1);		/* Store PPR in RESULT for now */ \
+END_FTR_SECTION_NESTED(CPU_FTR_HAS_PPR,CPU_FTR_HAS_PPR,940)
+
+/*
+ * This is called after we are finished accessing 'area', so we can now take
+ * SLB faults accessing the thread struct, which will use PACA_EXSLB area.
+ * This is required because the large_addr_slb handler uses EXSLB and it also
+ * uses the common exception macros including this PPR saving.
+ */
+#define MOVE_PPR_TO_THREAD(ra, rb)					\
 BEGIN_FTR_SECTION_NESTED(940)						\
 	ld	ra,PACACURRENT(r13);					\
-	ld	rb,area+EX_PPR(r13);	/* Read PPR from paca */	\
+	ld	rb,RESULT(r1);		/* Read PPR from stack */	\
 	std	rb,TASKTHREADPPR(ra);					\
 END_FTR_SECTION_NESTED(CPU_FTR_HAS_PPR,CPU_FTR_HAS_PPR,940)
 
@@ -515,9 +520,11 @@ END_FTR_SECTION_NESTED(ftr,ftr,943)
 3:	EXCEPTION_PROLOG_COMMON_1();					   \
 	beq	4f;			/* if from kernel mode		*/ \
 	ACCOUNT_CPU_USER_ENTRY(r13, r9, r10);				   \
-	SAVE_PPR(area, r9, r10);					   \
+	SAVE_PPR(area, r9);						   \
 4:	EXCEPTION_PROLOG_COMMON_2(area)					   \
-	EXCEPTION_PROLOG_COMMON_3(n)					   \
+	beq	5f;			/* if from kernel mode		*/ \
+	MOVE_PPR_TO_THREAD(r9, r10);					   \
+5:	EXCEPTION_PROLOG_COMMON_3(n)					   \
 	ACCOUNT_STOLEN_TIME
 
 /* Save original regs values from save area to stack frame. */
diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 60662771bd46..940132e705c1 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -39,6 +39,22 @@ config BLK_DEV_FD
 	  To compile this driver as a module, choose M here: the
 	  module will be called floppy.
 
+config BLK_DEV_FD_RAWCMD
+	bool "Support for raw floppy disk commands (DEPRECATED)"
+	depends on BLK_DEV_FD
+	help
+	  If you want to use actual physical floppies and expect to do
+	  special low-level hardware accesses to them (access and use
+	  non-standard formats, for example), then enable this.
+
+	  Note that the code enabled by this option is rarely used and
+	  might be unstable or insecure, and distros should not enable it.
+
+	  Note: FDRAWCMD is deprecated and will be removed from the kernel
+	  in the near future.
+
+	  If unsure, say N.
+
 config AMIGA_FLOPPY
 	tristate "Amiga floppy support"
 	depends on AMIGA
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e6e95e67c40e..97c8fc4d6e7b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3023,6 +3023,8 @@ static const char *drive_name(int type, int drive)
 		return "(null)";
 }
 
+#ifdef CONFIG_BLK_DEV_FD_RAWCMD
+
 /* raw commands */
 static void raw_cmd_done(int flag)
 {
@@ -3234,6 +3236,35 @@ static int raw_cmd_ioctl(int cmd, void __user *param)
 	return ret;
 }
 
+static int floppy_raw_cmd_ioctl(int type, int drive, int cmd,
+				void __user *param)
+{
+	int ret;
+
+	pr_warn_once("Note: FDRAWCMD is deprecated and will be removed from the kernel in the near future.\n");
+
+	if (type)
+		return -EINVAL;
+	if (lock_fdc(drive))
+		return -EINTR;
+	set_floppy(drive);
+	ret = raw_cmd_ioctl(cmd, param);
+	if (ret == -EINTR)
+		return -EINTR;
+	process_fd_request();
+	return ret;
+}
+
+#else /* CONFIG_BLK_DEV_FD_RAWCMD */
+
+static int floppy_raw_cmd_ioctl(int type, int drive, int cmd,
+				void __user *param)
+{
+	return -EOPNOTSUPP;
+}
+
+#endif
+
 static int invalidate_drive(struct block_device *bdev)
 {
 	/* invalidate the buffer track to force a reread */
@@ -3421,7 +3452,6 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int
 {
 	int drive = (long)bdev->bd_disk->private_data;
 	int type = ITYPE(UDRS->fd_device);
-	int i;
 	int ret;
 	int size;
 	union inparam {
@@ -3572,16 +3602,7 @@ static int fd_locked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int
 		outparam = UDRWE;
 		break;
 	case FDRAWCMD:
-		if (type)
-			return -EINVAL;
-		if (lock_fdc(drive))
-			return -EINTR;
-		set_floppy(drive);
-		i = raw_cmd_ioctl(cmd, (void __user *)param);
-		if (i == -EINTR)
-			return -EINTR;
-		process_fd_request();
-		return i;
+		return floppy_raw_cmd_ioctl(type, drive, cmd, (void __user *)param);
 	case FDTWADDLE:
 		if (lock_fdc(drive))
 			return -EINTR;
diff --git a/drivers/lightnvm/Kconfig b/drivers/lightnvm/Kconfig
index 20706da7aa1c..38cd49a3aeed 100644
--- a/drivers/lightnvm/Kconfig
+++ b/drivers/lightnvm/Kconfig
@@ -4,7 +4,7 @@
 
 menuconfig NVM
 	bool "Open-Channel SSD target support"
-	depends on BLOCK && PCI
+	depends on BLOCK && PCI && BROKEN
 	select BLK_DEV_NVME
 	help
 	  Say Y here to get to enable Open-channel SSDs.
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 7a33a52eacca..9d2e1ce536ec 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1297,12 +1297,12 @@ static int vicodec_release(struct file *file)
 	struct video_device *vfd = video_devdata(file);
 	struct vicodec_ctx *ctx = file2ctx(file);
 
-	v4l2_fh_del(&ctx->fh);
-	v4l2_fh_exit(&ctx->fh);
-	v4l2_ctrl_handler_free(&ctx->hdl);
 	mutex_lock(vfd->lock);
 	v4l2_m2m_ctx_release(ctx->fh.m2m_ctx);
 	mutex_unlock(vfd->lock);
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	v4l2_ctrl_handler_free(&ctx->hdl);
 	kfree(ctx);
 
 	return 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
index 729df169faa2..8b50afcdb52d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c
@@ -68,6 +68,10 @@
 #define TSE_PCS_USE_SGMII_ENA				BIT(0)
 #define TSE_PCS_IF_USE_SGMII				0x03
 
+#define SGMII_ADAPTER_CTRL_REG				0x00
+#define SGMII_ADAPTER_DISABLE				0x0001
+#define SGMII_ADAPTER_ENABLE				0x0000
+
 #define AUTONEGO_LINK_TIMER				20
 
 static int tse_pcs_reset(void __iomem *base, struct tse_pcs *pcs)
@@ -209,8 +213,12 @@ void tse_pcs_fix_mac_speed(struct tse_pcs *pcs, struct phy_device *phy_dev,
 			   unsigned int speed)
 {
 	void __iomem *tse_pcs_base = pcs->tse_pcs_base;
+	void __iomem *sgmii_adapter_base = pcs->sgmii_adapter_base;
 	u32 val;
 
+	writew(SGMII_ADAPTER_ENABLE,
+	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+
 	pcs->autoneg = phy_dev->autoneg;
 
 	if (phy_dev->autoneg == AUTONEG_ENABLE) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
index 254199f2efdb..2f5882450b06 100644
--- a/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
+++ b/drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h
@@ -21,10 +21,6 @@
 #include <linux/phy.h>
 #include <linux/timer.h>
 
-#define SGMII_ADAPTER_CTRL_REG		0x00
-#define SGMII_ADAPTER_ENABLE		0x0000
-#define SGMII_ADAPTER_DISABLE		0x0001
-
 struct tse_pcs {
 	struct device *dev;
 	void __iomem *tse_pcs_base;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 32ead4a4b460..33407df6bea6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -29,6 +29,9 @@
 
 #include "altr_tse_pcs.h"
 
+#define SGMII_ADAPTER_CTRL_REG                          0x00
+#define SGMII_ADAPTER_DISABLE                           0x0001
+
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII 0x0
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RGMII 0x1
 #define SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII 0x2
@@ -62,14 +65,16 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 {
 	struct socfpga_dwmac *dwmac = (struct socfpga_dwmac *)priv;
 	void __iomem *splitter_base = dwmac->splitter_base;
+	void __iomem *tse_pcs_base = dwmac->pcs.tse_pcs_base;
 	void __iomem *sgmii_adapter_base = dwmac->pcs.sgmii_adapter_base;
 	struct device *dev = dwmac->dev;
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct phy_device *phy_dev = ndev->phydev;
 	u32 val;
 
-	writew(SGMII_ADAPTER_DISABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
+	if ((tse_pcs_base) && (sgmii_adapter_base))
+		writew(SGMII_ADAPTER_DISABLE,
+		       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
 
 	if (splitter_base) {
 		val = readl(splitter_base + EMAC_SPLITTER_CTRL_REG);
@@ -91,9 +96,7 @@ static void socfpga_dwmac_fix_mac_speed(void *priv, unsigned int speed)
 		writel(val, splitter_base + EMAC_SPLITTER_CTRL_REG);
 	}
 
-	writew(SGMII_ADAPTER_ENABLE,
-	       sgmii_adapter_base + SGMII_ADAPTER_CTRL_REG);
-	if (phy_dev)
+	if (tse_pcs_base && sgmii_adapter_base)
 		tse_pcs_fix_mac_speed(&dwmac->pcs, phy_dev, speed);
 }
 
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 29431e3eebee..87094189af74 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -311,7 +311,6 @@ static void sp_setup(struct net_device *dev)
 {
 	/* Finish setting up the DEVICE info. */
 	dev->netdev_ops		= &sp_netdev_ops;
-	dev->needs_free_netdev	= true;
 	dev->mtu		= SIXP_MTU;
 	dev->hard_header_len	= AX25_MAX_HEADER_LEN;
 	dev->header_ops 	= &ax25_header_ops;
@@ -679,9 +678,11 @@ static void sixpack_close(struct tty_struct *tty)
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	/* Free all 6pack frame buffers. */
+	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
+
+	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 5eee26cf9011..d30256ac3537 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -404,15 +404,20 @@ static int u32_init(struct tcf_proto *tp)
 	return 0;
 }
 
-static int u32_destroy_key(struct tcf_proto *tp, struct tc_u_knode *n,
-			   bool free_pf)
+static void __u32_destroy_key(struct tc_u_knode *n)
 {
 	struct tc_u_hnode *ht = rtnl_dereference(n->ht_down);
 
 	tcf_exts_destroy(&n->exts);
-	tcf_exts_put_net(&n->exts);
 	if (ht && --ht->refcnt == 0)
 		kfree(ht);
+	kfree(n);
+}
+
+static void u32_destroy_key(struct tcf_proto *tp, struct tc_u_knode *n,
+			    bool free_pf)
+{
+	tcf_exts_put_net(&n->exts);
 #ifdef CONFIG_CLS_U32_PERF
 	if (free_pf)
 		free_percpu(n->pf);
@@ -421,8 +426,7 @@ static int u32_destroy_key(struct tcf_proto *tp, struct tc_u_knode *n,
 	if (free_pf)
 		free_percpu(n->pcpu_success);
 #endif
-	kfree(n);
-	return 0;
+	__u32_destroy_key(n);
 }
 
 /* u32_delete_key_rcu should be called when free'ing a copied
@@ -965,13 +969,13 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 				    tca[TCA_RATE], ovr, extack);
 
 		if (err) {
-			u32_destroy_key(tp, new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 
 		err = u32_replace_hw_knode(tp, new, flags, extack);
 		if (err) {
-			u32_destroy_key(tp, new, false);
+			__u32_destroy_key(new);
 			return err;
 		}
 
