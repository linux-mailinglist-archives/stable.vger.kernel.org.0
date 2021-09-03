Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE2E3FFC8E
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348592AbhICJC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:02:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348600AbhICJC1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:02:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E651260E9B;
        Fri,  3 Sep 2021 09:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659687;
        bh=V0m90Qow2nlnJ63ThBRO6Y8WyRJXvd6N70QVZYLDaN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKY8tEGK0690ar8S0r5Puo1OKfUXPCOPxZPtOaj6byQRWvKL5DBt8NopIlFW9M2Ja
         Na2okiERq4FvFRVFOqD0iNSwtwsRIPs3Oqk7+hlNeSUzr1z/hhS04MujqU4tOAAg1w
         vE03+gcPHHgEOn7KwZv0YccbmgPRu31OjQV5y814=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.246
Date:   Fri,  3 Sep 2021 11:01:19 +0200
Message-Id: <163065967844140@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <1630659678123129@kroah.com>
References: <1630659678123129@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index f50d45b1e967..6f0796843c09 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -152,8 +152,8 @@ Shadow pages contain the following information:
     shadow pages) so role.quadrant takes values in the range 0..3.  Each
     quadrant maps 1GB virtual address space.
   role.access:
-    Inherited guest access permissions in the form uwx.  Note execute
-    permission is positive, not negative.
+    Inherited guest access permissions from the parent ptes in the form uwx.
+    Note execute permission is positive, not negative.
   role.invalid:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it is
diff --git a/Makefile b/Makefile
index 0c87def162ac..11f0d1f637c4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 245
+SUBLEVEL = 246
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
index f35ed578e007..4d823d3f65bb 100644
--- a/arch/arc/kernel/vmlinux.lds.S
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -92,6 +92,8 @@ SECTIONS
 		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
 	}
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index e4b48ca24ff7..68ed9c01ca3c 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -4326,7 +4326,16 @@ static void reset_rsvds_bits_mask_ept(struct kvm_vcpu *vcpu,
 void
 reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu, struct kvm_mmu *context)
 {
-	bool uses_nx = context->nx || context->base_role.smep_andnot_wp;
+	/*
+	 * KVM uses NX when TDP is disabled to handle a variety of scenarios,
+	 * notably for huge SPTEs if iTLB multi-hit mitigation is enabled and
+	 * to generate correct permissions for CR0.WP=0/CR4.SMEP=1/EFER.NX=0.
+	 * The iTLB multi-hit workaround can be toggled at any time, so assume
+	 * NX can be used by any non-nested shadow MMU to avoid having to reset
+	 * MMU contexts.  Note, KVM forces EFER.NX=1 when TDP is disabled.
+	 */
+	bool uses_nx = context->nx || !tdp_enabled ||
+		context->base_role.smep_andnot_wp;
 	struct rsvd_bits_validate *shadow_zero_check;
 	int i;
 
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7260a165488d..4b921f1a165d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -93,8 +93,8 @@ struct guest_walker {
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
 	bool pte_writable[PT_MAX_FULL_LEVELS];
-	unsigned pt_access;
-	unsigned pte_access;
+	unsigned int pt_access[PT_MAX_FULL_LEVELS];
+	unsigned int pte_access;
 	gfn_t gfn;
 	struct x86_exception fault;
 };
@@ -388,13 +388,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		}
 
 		walker->ptes[walker->level - 1] = pte;
+
+		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
 	} while (!is_last_gpte(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
 
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access = FNAME(gpte_access)(vcpu, pt_access ^ walk_nx_mask);
 	walker->pte_access = FNAME(gpte_access)(vcpu, pte_access ^ walk_nx_mask);
 	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
@@ -433,7 +435,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -602,7 +605,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, ret;
 	gfn_t gfn, base_gfn;
 
@@ -634,6 +637,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}
diff --git a/drivers/base/power/opp/of.c b/drivers/base/power/opp/of.c
index 87509cb69f79..68ae8e9c1edc 100644
--- a/drivers/base/power/opp/of.c
+++ b/drivers/base/power/opp/of.c
@@ -402,8 +402,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct device_node *opp_np)
 		}
 	}
 
-	/* There should be one of more OPP defined */
-	if (WARN_ON(!count)) {
+	/* There should be one or more OPPs defined */
+	if (!count) {
+		dev_err(dev, "%s: no supported OPPs", __func__);
 		ret = -ENOENT;
 		goto put_opp_table;
 	}
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e7c82bde47d4..cbf74731cfce 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4069,22 +4069,21 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	if (UFDCS->rawcmd == 1)
 		UFDCS->rawcmd = 2;
 
-	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		UDRS->last_checked = 0;
-		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
-		check_disk_change(bdev);
-		if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
-			goto out;
-		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags))
+	if (!(mode & FMODE_NDELAY)) {
+		if (mode & (FMODE_READ|FMODE_WRITE)) {
+			UDRS->last_checked = 0;
+			clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
+			check_disk_change(bdev);
+			if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags))
+				goto out;
+			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags))
+				goto out;
+		}
+		res = -EROFS;
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
 			goto out;
 	}
-
-	res = -EROFS;
-
-	if ((mode & FMODE_WRITE) &&
-			!test_bit(FD_DISK_WRITABLE_BIT, &UDRS->flags))
-		goto out;
-
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;
diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 86105e7f07fc..6773e8f09fc3 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -855,8 +855,6 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	req.request.sequence = req32.request.sequence;
 	req.request.signal = req32.request.signal;
 	err = drm_ioctl_kernel(file, drm_wait_vblank_ioctl, &req, DRM_UNLOCKED);
-	if (err)
-		return err;
 
 	req32.reply.type = req.reply.type;
 	req32.reply.sequence = req.reply.sequence;
@@ -865,7 +863,7 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	if (copy_to_user(argp, &req32, sizeof(req32)))
 		return -EFAULT;
 
-	return 0;
+	return err;
 }
 
 #if defined(CONFIG_X86)
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
index 5e51a5c1eb01..d11cb1f887f7 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
@@ -418,7 +418,7 @@ nvkm_dp_train(struct nvkm_dp *dp, u32 dataKBps)
 	return ret;
 }
 
-static void
+void
 nvkm_dp_disable(struct nvkm_outp *outp, struct nvkm_ior *ior)
 {
 	struct nvkm_dp *dp = nvkm_dp(outp);
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
index 495f665a0ee6..12d6ff4cfa95 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
@@ -32,6 +32,7 @@ struct nvkm_dp {
 
 int nvkm_dp_new(struct nvkm_disp *, int index, struct dcb_output *,
 		struct nvkm_outp **);
+void nvkm_dp_disable(struct nvkm_outp *, struct nvkm_ior *);
 
 /* DPCD Receiver Capabilities */
 #define DPCD_RC00_DPCD_REV                                              0x00000
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
index bbba77ff9385..81c0f0513c74 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
@@ -22,6 +22,7 @@
  * Authors: Ben Skeggs
  */
 #include "outp.h"
+#include "dp.h"
 #include "ior.h"
 
 #include <subdev/bios.h>
@@ -207,6 +208,14 @@ nvkm_outp_init_route(struct nvkm_outp *outp)
 	if (!ior->arm.head || ior->arm.proto != proto) {
 		OUTP_DBG(outp, "no heads (%x %d %d)", ior->arm.head,
 			 ior->arm.proto, proto);
+
+		/* The EFI GOP driver on Ampere can leave unused DP links routed,
+		 * which we don't expect.  The DisableLT IED script *should* get
+		 * us back to where we need to be.
+		 */
+		if (ior->func->route.get && !ior->arm.head && outp->info.type == DCB_OUTPUT_DP)
+			nvkm_dp_disable(outp, ior);
+
 		return;
 	}
 
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 741938409f8e..c1c6d2c570aa 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3067,6 +3067,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int i;
+	struct sdma_desc *descp;
 
 	/* Handle last descriptor */
 	if (unlikely((tx->num_desc == (MAX_DESC - 1)))) {
@@ -3087,12 +3088,10 @@ static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 	if (unlikely(tx->num_desc == MAX_DESC))
 		goto enomem;
 
-	tx->descp = kmalloc_array(
-			MAX_DESC,
-			sizeof(struct sdma_desc),
-			GFP_ATOMIC);
-	if (!tx->descp)
+	descp = kmalloc_array(MAX_DESC, sizeof(struct sdma_desc), GFP_ATOMIC);
+	if (!descp)
 		goto enomem;
+	tx->descp = descp;
 
 	/* reserve last descriptor for coalescing */
 	tx->desc_limit = MAX_DESC - 1;
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 592c6e7f3dca..fbe1173b2651 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -236,8 +236,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
 		u8 ecc = msg->msg.rx.data[1];
-		u8 txerr = msg->msg.rx.data[2];
-		u8 rxerr = msg->msg.rx.data[3];
+		u8 rxerr = msg->msg.rx.data[2];
+		u8 txerr = msg->msg.rx.data[3];
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 0f2ad50f3bd7..7f37e7cb687e 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -691,11 +691,13 @@ static int xge_probe(struct platform_device *pdev)
 	ret = register_netdev(ndev);
 	if (ret) {
 		netdev_err(ndev, "Failed to register netdev\n");
-		goto err;
+		goto err_mdio_remove;
 	}
 
 	return 0;
 
+err_mdio_remove:
+	xge_mdio_remove(ndev);
 err:
 	free_netdev(ndev);
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 1e990f9dd379..9d5fe4ea9cee 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1013,6 +1013,8 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
+	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u16 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {
@@ -1066,7 +1068,17 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 				     E1000_PCI_LTR_CAP_LPT + 2, &max_nosnoop);
 		max_ltr_enc = max_t(u16, max_snoop, max_nosnoop);
 
-		if (lat_enc > max_ltr_enc)
+		lat_enc_d = (lat_enc & E1000_LTRV_VALUE_MASK) *
+			     (1U << (E1000_LTRV_SCALE_FACTOR *
+			     ((lat_enc & E1000_LTRV_SCALE_MASK)
+			     >> E1000_LTRV_SCALE_SHIFT)));
+
+		max_ltr_enc_d = (max_ltr_enc & E1000_LTRV_VALUE_MASK) *
+				 (1U << (E1000_LTRV_SCALE_FACTOR *
+				 ((max_ltr_enc & E1000_LTRV_SCALE_MASK)
+				 >> E1000_LTRV_SCALE_SHIFT)));
+
+		if (lat_enc_d > max_ltr_enc_d)
 			lat_enc = max_ltr_enc;
 	}
 
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 88df80c0894b..e32012d39827 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -292,8 +292,11 @@
 
 /* Latency Tolerance Reporting */
 #define E1000_LTRV			0x000F8
+#define E1000_LTRV_VALUE_MASK		0x000003FF
 #define E1000_LTRV_SCALE_MAX		5
 #define E1000_LTRV_SCALE_FACTOR		5
+#define E1000_LTRV_SCALE_SHIFT		10
+#define E1000_LTRV_SCALE_MASK		0x00001C00
 #define E1000_LTRV_REQ_SHIFT		15
 #define E1000_LTRV_NOSNOOP_SHIFT	16
 #define E1000_LTRV_SEND			(1 << 30)
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index cc0414fd1355..8fde1515aec7 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -100,7 +100,7 @@
 #define      MVNETA_DESC_SWAP                    BIT(6)
 #define      MVNETA_TX_BRST_SZ_MASK(burst)       ((burst) << 22)
 #define MVNETA_PORT_STATUS                       0x2444
-#define      MVNETA_TX_IN_PRGRS                  BIT(1)
+#define      MVNETA_TX_IN_PRGRS                  BIT(0)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
 #define MVNETA_SERDES_CFG			 0x24A0
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 1820be79df37..cca8c84edfbc 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -484,16 +484,19 @@ int vt_ioctl(struct tty_struct *tty,
 			ret = -EINVAL;
 			goto out;
 		}
-		/* FIXME: this needs the console lock extending */
-		if (vc->vc_mode == (unsigned char) arg)
+		console_lock();
+		if (vc->vc_mode == (unsigned char) arg) {
+			console_unlock();
 			break;
+		}
 		vc->vc_mode = (unsigned char) arg;
-		if (console != fg_console)
+		if (console != fg_console) {
+			console_unlock();
 			break;
+		}
 		/*
 		 * explicitly blank/unblank the screen if switching modes
 		 */
-		console_lock();
 		if (arg == KD_TEXT)
 			do_unblank_screen(1);
 		else
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 616f7c3a30e5..d0cfd3a0819d 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1062,19 +1062,19 @@ static struct dwc3_trb *dwc3_ep_prev_trb(struct dwc3_ep *dep, u8 index)
 
 static u32 dwc3_calc_trbs_left(struct dwc3_ep *dep)
 {
-	struct dwc3_trb		*tmp;
 	u8			trbs_left;
 
 	/*
-	 * If enqueue & dequeue are equal than it is either full or empty.
-	 *
-	 * One way to know for sure is if the TRB right before us has HWO bit
-	 * set or not. If it has, then we're definitely full and can't fit any
-	 * more transfers in our ring.
+	 * If the enqueue & dequeue are equal then the TRB ring is either full
+	 * or empty. It's considered full when there are DWC3_TRB_NUM-1 of TRBs
+	 * pending to be processed by the driver.
 	 */
 	if (dep->trb_enqueue == dep->trb_dequeue) {
-		tmp = dwc3_ep_prev_trb(dep, dep->trb_enqueue);
-		if (tmp->ctrl & DWC3_TRB_CTRL_HWO)
+		/*
+		 * If there is any request remained in the started_list at
+		 * this point, that means there is no TRB available.
+		 */
+		if (!list_empty(&dep->started_list))
 			return 0;
 
 		return DWC3_TRB_NUM - 1;
@@ -1799,10 +1799,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
 		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
 				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
-		if (ret == 0) {
-			dev_err(dwc->dev, "timed out waiting for SETUP phase\n");
-			return -ETIMEDOUT;
-		}
+		if (ret == 0)
+			dev_warn(dwc->dev, "timed out waiting for SETUP phase\n");
 	}
 
 	spin_lock_irqsave(&dwc->lock, flags);
@@ -1936,6 +1934,7 @@ static int __dwc3_gadget_start(struct dwc3 *dwc)
 	/* begin to receive SETUP packets */
 	dwc->ep0state = EP0_SETUP_PHASE;
 	dwc->link_state = DWC3_LINK_STATE_SS_DIS;
+	dwc->delayed_status = false;
 	dwc3_ep0_out_start(dwc);
 
 	dwc3_gadget_enable_irq(dwc);
diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 0370a1314b88..af6339ff6d2f 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -358,8 +358,6 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 	if (!prm->ep_enabled)
 		return;
 
-	prm->ep_enabled = false;
-
 	audio_dev = uac->audio_dev;
 	params = &audio_dev->params;
 
@@ -377,11 +375,12 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 		}
 	}
 
+	prm->ep_enabled = false;
+
 	if (usb_ep_disable(ep))
 		dev_err(uac->card->dev, "%s:%d Error!\n", __func__, __LINE__);
 }
 
-
 int u_audio_start_capture(struct g_audio *audio_dev)
 {
 	struct snd_uac_chip *uac = audio_dev->uac;
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 86ca2405942b..4ae7afc68bde 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -628,7 +628,6 @@ static struct usb_serial_driver ch341_device = {
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
-	.bulk_in_size      = 512,
 	.id_table          = id_table,
 	.num_ports         = 1,
 	.open              = ch341_open,
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5482e7a973d1..655221780951 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2076,6 +2076,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(4) | RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
 	  .driver_info = RSVD(6) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2df3, 0x9d03, 0xff) },			/* LongSung M5710 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 1e2e01270be9..c23045aa9873 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -330,7 +330,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			iov = wiov;
 		else {
 			iov = riov;
-			if (unlikely(wiov && wiov->i)) {
+			if (unlikely(wiov && wiov->used)) {
 				vringh_bad("Readable desc %p after writable",
 					   &descs[i]);
 				err = -EINVAL;
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 07dcf687a52b..4938ca1f4b63 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1003,6 +1003,10 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 			goto done;
 		}
 
+		/* bitfill_aligned() assumes that it's at least 8x8 */
+		if (var->xres < 8 || var->yres < 8)
+			return -EINVAL;
+
 		ret = info->fbops->fb_check_var(var, info);
 
 		if (ret)
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 51278f8bd3ab..22a4329ed200 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1198,7 +1198,7 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->broken;
+	return READ_ONCE(vq->broken);
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
@@ -1212,7 +1212,9 @@ void virtio_break_device(struct virtio_device *dev)
 
 	list_for_each_entry(_vq, &dev->vqs, list) {
 		struct vring_virtqueue *vq = to_vvq(_vq);
-		vq->broken = true;
+
+		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
+		WRITE_ONCE(vq->broken, true);
 	}
 }
 EXPORT_SYMBOL_GPL(virtio_break_device);
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 9940a59306b5..1a4d89f8361c 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -443,6 +443,8 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index d290416e79e9..9fd550d4116c 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -112,9 +112,9 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		cpu_relax();
 	}
 
-	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len,
+	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
 				&off, PAGE_SIZE);
-	if (unlikely(ret != ibmr->sg_len))
+	if (unlikely(ret != ibmr->sg_dma_len))
 		return ret < 0 ? ret : -EINVAL;
 
 	/* Perform a WR for the fast_reg_mr. Each individual page
