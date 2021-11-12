Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0892D44E7FE
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 14:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235035AbhKLN5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 08:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235070AbhKLN5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Nov 2021 08:57:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8612E60F55;
        Fri, 12 Nov 2021 13:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636725264;
        bh=Ikq73mD+YB7TH95kcZt5U/uExS1pdalXxSC62Rhl00Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiXHqK/HmETbKxMRbDM0AkudhYXVeXI51d5yLPdOI6x+vYBx5LpmJEoxog3ud0thR
         kIeasn0U5BORUVJAWTBKML5WyLK25+n10XghiW6trITEyEOijmZvDOY70lnXeXV8vs
         09EablqNQ5KeJl4YCuannG7dBl8PORKEbKaewrEY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.255
Date:   Fri, 12 Nov 2021 14:54:13 +0100
Message-Id: <16367252522079@kroah.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <16367252528812@kroah.com>
References: <16367252528812@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index b684983722af..552f17dd25b4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 254
+SUBLEVEL = 255
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/arc/include/asm/pgtable.h b/arch/arc/include/asm/pgtable.h
index 77676e18da69..a31ae69da639 100644
--- a/arch/arc/include/asm/pgtable.h
+++ b/arch/arc/include/asm/pgtable.h
@@ -138,8 +138,10 @@
 
 #ifdef CONFIG_ARC_HAS_PAE40
 #define PTE_BITS_NON_RWX_IN_PD1	(0xff00000000 | PAGE_MASK | _PAGE_CACHEABLE)
+#define MAX_POSSIBLE_PHYSMEM_BITS 40
 #else
 #define PTE_BITS_NON_RWX_IN_PD1	(PAGE_MASK | _PAGE_CACHEABLE)
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
 #endif
 
 /**************************************************************************
diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index 92fd2c8a9af0..6154902bed83 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -78,6 +78,8 @@
 #define PTE_HWTABLE_OFF		(PTE_HWTABLE_PTRS * sizeof(pte_t))
 #define PTE_HWTABLE_SIZE	(PTRS_PER_PTE * sizeof(u32))
 
+#define MAX_POSSIBLE_PHYSMEM_BITS	32
+
 /*
  * PMD_SHIFT determines the size of the area a second-level page table can map
  * PGDIR_SHIFT determines what a third-level page table entry can map
diff --git a/arch/arm/include/asm/pgtable-3level.h b/arch/arm/include/asm/pgtable-3level.h
index 2a029bceaf2f..35807e611b6e 100644
--- a/arch/arm/include/asm/pgtable-3level.h
+++ b/arch/arm/include/asm/pgtable-3level.h
@@ -37,6 +37,8 @@
 #define PTE_HWTABLE_OFF		(0)
 #define PTE_HWTABLE_SIZE	(PTRS_PER_PTE * sizeof(u64))
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 40
+
 /*
  * PGDIR_SHIFT determines the size a top-level page table entry can map.
  */
diff --git a/arch/mips/include/asm/pgtable-32.h b/arch/mips/include/asm/pgtable-32.h
index 74afe8c76bdd..215fb48f644b 100644
--- a/arch/mips/include/asm/pgtable-32.h
+++ b/arch/mips/include/asm/pgtable-32.h
@@ -111,6 +111,7 @@ static inline void pmd_clear(pmd_t *pmdp)
 
 #if defined(CONFIG_XPA)
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 40
 #define pte_pfn(x)		(((unsigned long)((x).pte_high >> _PFN_SHIFT)) | (unsigned long)((x).pte_low << _PAGE_PRESENT_SHIFT))
 static inline pte_t
 pfn_pte(unsigned long pfn, pgprot_t prot)
@@ -126,6 +127,7 @@ pfn_pte(unsigned long pfn, pgprot_t prot)
 
 #elif defined(CONFIG_PHYS_ADDR_T_64BIT) && defined(CONFIG_CPU_MIPS32)
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 36
 #define pte_pfn(x)		((unsigned long)((x).pte_high >> 6))
 
 static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
@@ -140,6 +142,7 @@ static inline pte_t pfn_pte(unsigned long pfn, pgprot_t prot)
 
 #else
 
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
 #ifdef CONFIG_CPU_VR41XX
 #define pte_pfn(x)		((unsigned long)((x).pte >> (PAGE_SHIFT + 2)))
 #define pfn_pte(pfn, prot)	__pte(((pfn) << (PAGE_SHIFT + 2)) | pgprot_val(prot))
diff --git a/arch/powerpc/include/asm/pte-common.h b/arch/powerpc/include/asm/pte-common.h
index ce142ef99ba7..18ebe9a4728e 100644
--- a/arch/powerpc/include/asm/pte-common.h
+++ b/arch/powerpc/include/asm/pte-common.h
@@ -102,8 +102,10 @@ static inline bool pte_user(pte_t pte)
  */
 #if defined(CONFIG_PPC32) && defined(CONFIG_PTE_64BIT)
 #define PTE_RPN_MASK	(~((1ULL<<PTE_RPN_SHIFT)-1))
+#define MAX_POSSIBLE_PHYSMEM_BITS 36
 #else
 #define PTE_RPN_MASK	(~((1UL<<PTE_RPN_SHIFT)-1))
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
 #endif
 
 /* _PAGE_CHG_MASK masks of bits that are to be preserved across
diff --git a/arch/x86/include/asm/pgtable-3level_types.h b/arch/x86/include/asm/pgtable-3level_types.h
index 876b4c77d983..6a59a6d0cc50 100644
--- a/arch/x86/include/asm/pgtable-3level_types.h
+++ b/arch/x86/include/asm/pgtable-3level_types.h
@@ -44,5 +44,6 @@ typedef union {
  */
 #define PTRS_PER_PTE	512
 
+#define MAX_POSSIBLE_PHYSMEM_BITS	36
 
 #endif /* _ASM_X86_PGTABLE_3LEVEL_DEFS_H */
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index bf6d2692fc60..2bd79b7ae9d6 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -40,6 +40,8 @@ typedef struct { pteval_t pte; } pte_t;
 #define P4D_SIZE	(_AC(1, UL) << P4D_SHIFT)
 #define P4D_MASK	(~(P4D_SIZE - 1))
 
+#define MAX_POSSIBLE_PHYSMEM_BITS	52
+
 #else /* CONFIG_X86_5LEVEL */
 
 /*
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index b928e61fe375..dab6940ea99c 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -96,7 +96,7 @@ static unsigned long ioapic_read_indirect(struct kvm_ioapic *ioapic,
 static void rtc_irq_eoi_tracking_reset(struct kvm_ioapic *ioapic)
 {
 	ioapic->rtc_status.pending_eoi = 0;
-	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID + 1);
+	bitmap_zero(ioapic->rtc_status.dest_map.map, KVM_MAX_VCPU_ID);
 }
 
 static void kvm_rtc_eoi_tracking_restore_all(struct kvm_ioapic *ioapic);
diff --git a/arch/x86/kvm/ioapic.h b/arch/x86/kvm/ioapic.h
index 283f1f489bca..ea1a4e0297da 100644
--- a/arch/x86/kvm/ioapic.h
+++ b/arch/x86/kvm/ioapic.h
@@ -43,13 +43,13 @@ struct kvm_vcpu;
 
 struct dest_map {
 	/* vcpu bitmap where IRQ has been sent */
-	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID + 1);
+	DECLARE_BITMAP(map, KVM_MAX_VCPU_ID);
 
 	/*
 	 * Vector sent to a given vcpu, only valid when
 	 * the vcpu's bit in map is set
 	 */
-	u8 vectors[KVM_MAX_VCPU_ID + 1];
+	u8 vectors[KVM_MAX_VCPU_ID];
 };
 
 
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index a82d068a84b4..8ea401fc8996 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -355,9 +355,6 @@ static int amba_device_try_add(struct amba_device *dev, struct resource *parent)
 	void __iomem *tmp;
 	int i, ret;
 
-	WARN_ON(dev->irq[0] == (unsigned int)-1);
-	WARN_ON(dev->irq[1] == (unsigned int)-1);
-
 	ret = request_resource(parent, &dev->res);
 	if (ret)
 		goto err_out;
diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
index 926f3c8eba69..42329bbe4055 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -41,6 +41,7 @@
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
+#include <linux/overflow.h>
 
 #include "qib.h"
 #include "qib_user_sdma.h"
@@ -606,7 +607,7 @@ static int qib_user_sdma_coalesce(const struct qib_devdata *dd,
 /*
  * How many pages in this iovec element?
  */
-static int qib_user_sdma_num_pages(const struct iovec *iov)
+static size_t qib_user_sdma_num_pages(const struct iovec *iov)
 {
 	const unsigned long addr  = (unsigned long) iov->iov_base;
 	const unsigned long  len  = iov->iov_len;
@@ -662,7 +663,7 @@ static void qib_user_sdma_free_pkt_frag(struct device *dev,
 static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
 				   struct qib_user_sdma_queue *pq,
 				   struct qib_user_sdma_pkt *pkt,
-				   unsigned long addr, int tlen, int npages)
+				   unsigned long addr, int tlen, size_t npages)
 {
 	struct page *pages[8];
 	int i, j;
@@ -726,7 +727,7 @@ static int qib_user_sdma_pin_pkt(const struct qib_devdata *dd,
 	unsigned long idx;
 
 	for (idx = 0; idx < niov; idx++) {
-		const int npages = qib_user_sdma_num_pages(iov + idx);
+		const size_t npages = qib_user_sdma_num_pages(iov + idx);
 		const unsigned long addr = (unsigned long) iov[idx].iov_base;
 
 		ret = qib_user_sdma_pin_pages(dd, pq, pkt, addr,
@@ -828,8 +829,8 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		unsigned pktnw;
 		unsigned pktnwc;
 		int nfrags = 0;
-		int npages = 0;
-		int bytes_togo = 0;
+		size_t npages = 0;
+		size_t bytes_togo = 0;
 		int tiddma = 0;
 		int cfur;
 
@@ -889,7 +890,11 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 
 			npages += qib_user_sdma_num_pages(&iov[idx]);
 
-			bytes_togo += slen;
+			if (check_add_overflow(bytes_togo, slen, &bytes_togo) ||
+			    bytes_togo > type_max(typeof(pkt->bytes_togo))) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
 			pktnwc += slen >> 2;
 			idx++;
 			nfrags++;
@@ -908,10 +913,10 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 		}
 
 		if (frag_size) {
-			int pktsize, tidsmsize, n;
+			size_t tidsmsize, n, pktsize, sz, addrlimit;
 
 			n = npages*((2*PAGE_SIZE/frag_size)+1);
-			pktsize = sizeof(*pkt) + sizeof(pkt->addr[0])*n;
+			pktsize = struct_size(pkt, addr, n);
 
 			/*
 			 * Determine if this is tid-sdma or just sdma.
@@ -926,14 +931,24 @@ static int qib_user_sdma_queue_pkts(const struct qib_devdata *dd,
 			else
 				tidsmsize = 0;
 
-			pkt = kmalloc(pktsize+tidsmsize, GFP_KERNEL);
+			if (check_add_overflow(pktsize, tidsmsize, &sz)) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
+			pkt = kmalloc(sz, GFP_KERNEL);
 			if (!pkt) {
 				ret = -ENOMEM;
 				goto free_pbc;
 			}
 			pkt->largepkt = 1;
 			pkt->frag_size = frag_size;
-			pkt->addrlimit = n + ARRAY_SIZE(pkt->addr);
+			if (check_add_overflow(n, ARRAY_SIZE(pkt->addr),
+					       &addrlimit) ||
+			    addrlimit > type_max(typeof(pkt->addrlimit))) {
+				ret = -EINVAL;
+				goto free_pbc;
+			}
+			pkt->addrlimit = addrlimit;
 
 			if (tiddma) {
 				char *tidsm = (char *)pkt + pktsize;
diff --git a/drivers/media/firewire/firedtv-avc.c b/drivers/media/firewire/firedtv-avc.c
index b243e4a52f10..9e6a48233c06 100644
--- a/drivers/media/firewire/firedtv-avc.c
+++ b/drivers/media/firewire/firedtv-avc.c
@@ -1169,7 +1169,11 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
 		read_pos += program_info_length;
 		write_pos += program_info_length;
 	}
-	while (read_pos < length) {
+	while (read_pos + 4 < length) {
+		if (write_pos + 4 >= sizeof(c->operand) - 4) {
+			ret = -EINVAL;
+			goto out;
+		}
 		c->operand[write_pos++] = msg[read_pos++];
 		c->operand[write_pos++] = msg[read_pos++];
 		c->operand[write_pos++] = msg[read_pos++];
@@ -1181,13 +1185,17 @@ int avc_ca_pmt(struct firedtv *fdtv, char *msg, int length)
 		c->operand[write_pos++] = es_info_length >> 8;
 		c->operand[write_pos++] = es_info_length & 0xff;
 		if (es_info_length > 0) {
+			if (read_pos >= length) {
+				ret = -EINVAL;
+				goto out;
+			}
 			pmt_cmd_id = msg[read_pos++];
 			if (pmt_cmd_id != 1 && pmt_cmd_id != 4)
 				dev_err(fdtv->device, "invalid pmt_cmd_id %d at stream level\n",
 					pmt_cmd_id);
 
-			if (es_info_length > sizeof(c->operand) - 4 -
-					     write_pos) {
+			if (es_info_length > sizeof(c->operand) - 4 - write_pos ||
+			    es_info_length > length - read_pos) {
 				ret = -EINVAL;
 				goto out;
 			}
diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
index edbb30fdd9d9..93fb4b7312af 100644
--- a/drivers/media/firewire/firedtv-ci.c
+++ b/drivers/media/firewire/firedtv-ci.c
@@ -138,6 +138,8 @@ static int fdtv_ca_pmt(struct firedtv *fdtv, void *arg)
 	} else {
 		data_length = msg->msg[3];
 	}
+	if (data_length > sizeof(msg->msg) - data_pos)
+		return -EINVAL;
 
 	return avc_ca_pmt(fdtv, &msg->msg[data_pos], data_length);
 }
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 786a330bc470..e31739242ccb 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -48,7 +48,7 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
 			      (void *)seg,
 			      (int)len,
 			      &transfer,
-			      HZ * 5);
+			      USB_CTRL_SET_TIMEOUT);
 
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a7e4fba724b7..80ab7ef02724 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -575,8 +575,10 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-	module_put(sdev->host->hostt->module);
+	struct module *mod = sdev->host->hostt->module;
+
 	put_device(&sdev->sdev_gendev);
+	module_put(mod);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ffb44d77a01b..7fe2a0371b48 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -430,9 +430,12 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	struct list_head *this, *tmp;
 	struct scsi_vpd *vpd_pg80 = NULL, *vpd_pg83 = NULL;
 	unsigned long flags;
+	struct module *mod;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
+	mod = sdev->host->hostt->module;
+
 	scsi_dh_release_device(sdev);
 
 	parent = sdev->sdev_gendev.parent;
@@ -473,11 +476,17 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 
 	if (parent)
 		put_device(parent);
+	module_put(mod);
 }
 
 static void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
+
+	/* Set module pointer as NULL in case of module unloading */
+	if (!try_module_get(sdp->host->hostt->module))
+		sdp->host->hostt->module = NULL;
+
 	execute_in_process_context(scsi_device_dev_release_usercontext,
 				   &sdp->ew);
 }
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 7ebca862ecaa..e758eb3d2d19 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -41,6 +41,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
 
 #include "../comedi_usb.h"
@@ -246,22 +247,42 @@ static int dt9812_read_info(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
+	size_t tbuf_size;
 	int count, ret;
+	void *tbuf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
-	cmd.u.flash_data_info.address =
+	tbuf_size = max(sizeof(*cmd), buf_size);
+
+	tbuf = kzalloc(tbuf_size, GFP_KERNEL);
+	if (!tbuf)
+		return -ENOMEM;
+
+	cmd = tbuf;
+
+	cmd->cmd = cpu_to_le32(DT9812_R_FLASH_DATA);
+	cmd->u.flash_data_info.address =
 	    cpu_to_le16(DT9812_DIAGS_BOARD_INFO_ADDR + offset);
-	cmd.u.flash_data_info.numbytes = cpu_to_le16(buf_size);
+	cmd->u.flash_data_info.numbytes = cpu_to_le16(buf_size);
 
 	/* DT9812 only responds to 32 byte writes!! */
 	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
 	if (ret)
-		return ret;
+		goto out;
+
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   tbuf, buf_size, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == buf_size)
+			memcpy(buf, tbuf, buf_size);
+		else
+			ret = -EREMOTEIO;
+	}
+out:
+	kfree(tbuf);
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    buf, buf_size, &count, DT9812_USB_TIMEOUT);
+	return ret;
 }
 
 static int dt9812_read_multiple_registers(struct comedi_device *dev,
@@ -270,22 +291,42 @@ static int dt9812_read_multiple_registers(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count, ret;
+	size_t buf_size;
+	void *buf;
 
-	cmd.cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
+	buf_size = max_t(size_t, sizeof(*cmd), reg_count);
+
+	buf = kzalloc(buf_size, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	cmd = buf;
+
+	cmd->cmd = cpu_to_le32(DT9812_R_MULTI_BYTE_REG);
+	cmd->u.read_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++)
-		cmd.u.read_multi_info.address[i] = address[i];
+		cmd->u.read_multi_info.address[i] = address[i];
 
 	/* DT9812 only responds to 32 byte writes!! */
 	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			   &cmd, 32, &count, DT9812_USB_TIMEOUT);
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
 	if (ret)
-		return ret;
+		goto out;
+
+	ret = usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
+			   buf, reg_count, &count, DT9812_USB_TIMEOUT);
+	if (!ret) {
+		if (count == reg_count)
+			memcpy(value, buf, reg_count);
+		else
+			ret = -EREMOTEIO;
+	}
+out:
+	kfree(buf);
 
-	return usb_bulk_msg(usb, usb_rcvbulkpipe(usb, devpriv->cmd_rd.addr),
-			    value, reg_count, &count, DT9812_USB_TIMEOUT);
+	return ret;
 }
 
 static int dt9812_write_multiple_registers(struct comedi_device *dev,
@@ -294,19 +335,27 @@ static int dt9812_write_multiple_registers(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
 
-	cmd.cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
-	cmd.u.read_multi_info.count = reg_count;
+	cmd->cmd = cpu_to_le32(DT9812_W_MULTI_BYTE_REG);
+	cmd->u.read_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++) {
-		cmd.u.write_multi_info.write[i].address = address[i];
-		cmd.u.write_multi_info.write[i].value = value[i];
+		cmd->u.write_multi_info.write[i].address = address[i];
+		cmd->u.write_multi_info.write[i].value = value[i];
 	}
 
 	/* DT9812 only responds to 32 byte writes!! */
-	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
+	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
+	kfree(cmd);
+
+	return ret;
 }
 
 static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
@@ -315,17 +364,25 @@ static int dt9812_rmw_multiple_registers(struct comedi_device *dev,
 {
 	struct usb_device *usb = comedi_to_usb_dev(dev);
 	struct dt9812_private *devpriv = dev->private;
-	struct dt9812_usb_cmd cmd;
+	struct dt9812_usb_cmd *cmd;
 	int i, count;
+	int ret;
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
 
-	cmd.cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
-	cmd.u.rmw_multi_info.count = reg_count;
+	cmd->cmd = cpu_to_le32(DT9812_RMW_MULTI_BYTE_REG);
+	cmd->u.rmw_multi_info.count = reg_count;
 	for (i = 0; i < reg_count; i++)
-		cmd.u.rmw_multi_info.rmw[i] = rmw[i];
+		cmd->u.rmw_multi_info.rmw[i] = rmw[i];
 
 	/* DT9812 only responds to 32 byte writes!! */
-	return usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
-			    &cmd, 32, &count, DT9812_USB_TIMEOUT);
+	ret = usb_bulk_msg(usb, usb_sndbulkpipe(usb, devpriv->cmd_wr.addr),
+			   cmd, sizeof(*cmd), &count, DT9812_USB_TIMEOUT);
+	kfree(cmd);
+
+	return ret;
 }
 
 static int dt9812_digital_in(struct comedi_device *dev, u8 *bits)
diff --git a/drivers/staging/comedi/drivers/ni_usb6501.c b/drivers/staging/comedi/drivers/ni_usb6501.c
index 009c5277387b..56b45b21eac3 100644
--- a/drivers/staging/comedi/drivers/ni_usb6501.c
+++ b/drivers/staging/comedi/drivers/ni_usb6501.c
@@ -153,6 +153,10 @@ static const u8 READ_COUNTER_RESPONSE[]	= {0x00, 0x01, 0x00, 0x10,
 					   0x00, 0x00, 0x00, 0x02,
 					   0x00, 0x00, 0x00, 0x00};
 
+/* Largest supported packets */
+static const size_t TX_MAX_SIZE	= sizeof(SET_PORT_DIR_REQUEST);
+static const size_t RX_MAX_SIZE	= sizeof(READ_PORT_RESPONSE);
+
 enum commands {
 	READ_PORT,
 	WRITE_PORT,
@@ -510,6 +514,12 @@ static int ni6501_find_endpoints(struct comedi_device *dev)
 	if (!devpriv->ep_rx || !devpriv->ep_tx)
 		return -ENODEV;
 
+	if (usb_endpoint_maxp(devpriv->ep_rx) < RX_MAX_SIZE)
+		return -ENODEV;
+
+	if (usb_endpoint_maxp(devpriv->ep_tx) < TX_MAX_SIZE)
+		return -ENODEV;
+
 	return 0;
 }
 
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index cdf86284dd04..36470ee06596 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -99,6 +99,9 @@ enum {
 #define IC3_VERSION		BIT(0)
 #define IC6_VERSION		BIT(1)
 
+#define MIN_BUF_SIZE		64
+#define PACKET_TIMEOUT		10000	/* ms */
+
 enum vmk80xx_model {
 	VMK8055_MODEL,
 	VMK8061_MODEL
@@ -166,22 +169,21 @@ static void vmk80xx_do_bulk_msg(struct comedi_device *dev)
 	__u8 rx_addr;
 	unsigned int tx_pipe;
 	unsigned int rx_pipe;
-	size_t size;
+	size_t tx_size;
+	size_t rx_size;
 
 	tx_addr = devpriv->ep_tx->bEndpointAddress;
 	rx_addr = devpriv->ep_rx->bEndpointAddress;
 	tx_pipe = usb_sndbulkpipe(usb, tx_addr);
 	rx_pipe = usb_rcvbulkpipe(usb, rx_addr);
+	tx_size = usb_endpoint_maxp(devpriv->ep_tx);
+	rx_size = usb_endpoint_maxp(devpriv->ep_rx);
 
-	/*
-	 * The max packet size attributes of the K8061
-	 * input/output endpoints are identical
-	 */
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf, tx_size, NULL,
+		     PACKET_TIMEOUT);
 
-	usb_bulk_msg(usb, tx_pipe, devpriv->usb_tx_buf,
-		     size, NULL, devpriv->ep_tx->bInterval);
-	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, size, NULL, HZ * 10);
+	usb_bulk_msg(usb, rx_pipe, devpriv->usb_rx_buf, rx_size, NULL,
+		     PACKET_TIMEOUT);
 }
 
 static int vmk80xx_read_packet(struct comedi_device *dev)
@@ -200,7 +202,7 @@ static int vmk80xx_read_packet(struct comedi_device *dev)
 	pipe = usb_rcvintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_rx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
@@ -221,7 +223,7 @@ static int vmk80xx_write_packet(struct comedi_device *dev, int cmd)
 	pipe = usb_sndintpipe(usb, ep->bEndpointAddress);
 	return usb_interrupt_msg(usb, pipe, devpriv->usb_tx_buf,
 				 usb_endpoint_maxp(ep), NULL,
-				 HZ * 10);
+				 PACKET_TIMEOUT);
 }
 
 static int vmk80xx_reset_device(struct comedi_device *dev)
@@ -687,12 +689,12 @@ static int vmk80xx_alloc_usb_buffers(struct comedi_device *dev)
 	struct vmk80xx_private *devpriv = dev->private;
 	size_t size;
 
-	size = usb_endpoint_maxp(devpriv->ep_rx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_rx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_rx_buf)
 		return -ENOMEM;
 
-	size = usb_endpoint_maxp(devpriv->ep_tx);
+	size = max(usb_endpoint_maxp(devpriv->ep_rx), MIN_BUF_SIZE);
 	devpriv->usb_tx_buf = kzalloc(size, GFP_KERNEL);
 	if (!devpriv->usb_tx_buf)
 		return -ENOMEM;
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 89ec4bb19e48..ac7872ea0cb1 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -266,7 +266,7 @@ int write_nic_byte_E(struct net_device *dev, int indx, u8 data)
 
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -288,7 +288,7 @@ int read_nic_byte_E(struct net_device *dev, int indx, u8 *data)
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 1, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -316,7 +316,7 @@ int write_nic_byte(struct net_device *dev, int indx, u8 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -343,7 +343,7 @@ int write_nic_word(struct net_device *dev, int indx, u16 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	kfree(usbdata);
 
 	if (status < 0) {
@@ -370,7 +370,7 @@ int write_nic_dword(struct net_device *dev, int indx, u32 data)
 	status = usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
 				 RTL8187_REQ_SET_REGS, RTL8187_REQT_WRITE,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	kfree(usbdata);
 
 
@@ -397,7 +397,7 @@ int read_nic_byte(struct net_device *dev, int indx, u8 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 1, HZ / 2);
+				 usbdata, 1, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -424,7 +424,7 @@ int read_nic_word(struct net_device *dev, int indx, u16 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 2, HZ / 2);
+				 usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -448,7 +448,7 @@ static int read_nic_word_E(struct net_device *dev, int indx, u16 *data)
 
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
-				 indx | 0xfe00, 0, usbdata, 2, HZ / 2);
+				 indx | 0xfe00, 0, usbdata, 2, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
@@ -474,7 +474,7 @@ int read_nic_dword(struct net_device *dev, int indx, u32 *data)
 	status = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 				 RTL8187_REQ_GET_REGS, RTL8187_REQT_READ,
 				 (indx & 0xff) | 0xff00, (indx >> 8) & 0x0f,
-				 usbdata, 4, HZ / 2);
+				 usbdata, 4, 500);
 	*data = *usbdata;
 	kfree(usbdata);
 
diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 441e76b8959d..0c1576f73e4a 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -505,7 +505,7 @@ int r8712_usbctrl_vendorreq(struct intf_priv *pintfpriv, u8 request, u16 value,
 		memcpy(pIo_buf, pdata, len);
 	}
 	status = usb_control_msg(udev, pipe, request, reqtype, value, index,
-				 pIo_buf, len, HZ / 2);
+				 pIo_buf, len, 500);
 	if (status > 0) {  /* Success this control transfer. */
 		if (requesttype == 0x01) {
 			/* For Control read transfer, we have to copy the read
diff --git a/drivers/usb/gadget/udc/Kconfig b/drivers/usb/gadget/udc/Kconfig
index 1e9567091d86..3291ea22853c 100644
--- a/drivers/usb/gadget/udc/Kconfig
+++ b/drivers/usb/gadget/udc/Kconfig
@@ -328,6 +328,7 @@ config USB_AMD5536UDC
 config USB_FSL_QE
 	tristate "Freescale QE/CPM USB Device Controller"
 	depends on FSL_SOC && (QUICC_ENGINE || CPM)
+	depends on !64BIT || BROKEN
 	help
 	   Some of Freescale PowerPC processors have a Full Speed
 	   QE/CPM2 USB controller, which support device mode with 4
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 1e431634589d..319c5a1b4a6a 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1280,9 +1280,11 @@ static int musb_gadget_queue(struct usb_ep *ep, struct usb_request *req,
 		status = musb_queue_resume_work(musb,
 						musb_ep_restart_resume_work,
 						request);
-		if (status < 0)
+		if (status < 0) {
 			dev_err(musb->controller, "%s resume work: %i\n",
 				__func__, status);
+			list_del(&request->list);
+		}
 	}
 
 unlock:
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index 683830dd383f..15915784071e 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -425,6 +425,16 @@ UNUSUAL_DEV(  0x04b8, 0x0602, 0x0110, 0x0110,
 		"785EPX Storage",
 		USB_SC_SCSI, USB_PR_BULK, NULL, US_FL_SINGLE_LUN),
 
+/*
+ * Reported by James Buren <braewoods+lkml@braewoods.net>
+ * Virtual ISOs cannot be remounted if ejected while the device is locked
+ * Disable locking to mimic Windows behavior that bypasses the issue
+ */
+UNUSUAL_DEV(  0x04c5, 0x2028, 0x0001, 0x0001,
+		"iODD",
+		"2531/2541",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL, US_FL_NOT_LOCKABLE),
+
 /*
  * Not sure who reported this originally but
  * Pavel Machek <pavel@ucw.cz> reported that the extra US_FL_SINGLE_LUN
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index f1134752cea3..ee3c92390413 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1326,6 +1326,8 @@ static int isofs_read_inode(struct inode *inode, int relocated)
 
 	de = (struct iso_directory_record *) (bh->b_data + offset);
 	de_len = *(unsigned char *) de;
+	if (de_len < sizeof(struct iso_directory_record))
+		goto fail;
 
 	if (offset + de_len > bufsize) {
 		int frag1 = bufsize - offset;
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index cdee19314061..dd65e925f7cf 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1069,6 +1069,19 @@ static inline bool arch_has_pfn_modify_check(void)
 
 #endif /* !__ASSEMBLY__ */
 
+#if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
+#ifdef CONFIG_PHYS_ADDR_T_64BIT
+/*
+ * ZSMALLOC needs to know the highest PFN on 32-bit architectures
+ * with physical address space extension, but falls back to
+ * BITS_PER_LONG otherwise.
+ */
+#error Missing MAX_POSSIBLE_PHYSMEM_BITS definition
+#else
+#define MAX_POSSIBLE_PHYSMEM_BITS 32
+#endif
+#endif
+
 #ifndef has_transparent_hugepage
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define has_transparent_hugepage() 1
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index f7dc68cd0a39..b8a2734394f7 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/bug.h>
 #include <linux/errno.h>
+#include <linux/mm.h>
 
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
@@ -52,16 +53,39 @@ struct bvec_iter {
  */
 #define __bvec_iter_bvec(bvec, iter)	(&(bvec)[(iter).bi_idx])
 
-#define bvec_iter_page(bvec, iter)				\
+/* multi-page (mp_bvec) helpers */
+#define mp_bvec_iter_page(bvec, iter)				\
 	(__bvec_iter_bvec((bvec), (iter))->bv_page)
 
-#define bvec_iter_len(bvec, iter)				\
+#define mp_bvec_iter_len(bvec, iter)				\
 	min((iter).bi_size,					\
 	    __bvec_iter_bvec((bvec), (iter))->bv_len - (iter).bi_bvec_done)
 
-#define bvec_iter_offset(bvec, iter)				\
+#define mp_bvec_iter_offset(bvec, iter)				\
 	(__bvec_iter_bvec((bvec), (iter))->bv_offset + (iter).bi_bvec_done)
 
+#define mp_bvec_iter_page_idx(bvec, iter)			\
+	(mp_bvec_iter_offset((bvec), (iter)) / PAGE_SIZE)
+
+#define mp_bvec_iter_bvec(bvec, iter)				\
+((struct bio_vec) {						\
+	.bv_page	= mp_bvec_iter_page((bvec), (iter)),	\
+	.bv_len		= mp_bvec_iter_len((bvec), (iter)),	\
+	.bv_offset	= mp_bvec_iter_offset((bvec), (iter)),	\
+})
+
+/* For building single-page bvec in flight */
+ #define bvec_iter_offset(bvec, iter)				\
+	(mp_bvec_iter_offset((bvec), (iter)) % PAGE_SIZE)
+
+#define bvec_iter_len(bvec, iter)				\
+	min_t(unsigned, mp_bvec_iter_len((bvec), (iter)),		\
+	      PAGE_SIZE - bvec_iter_offset((bvec), (iter)))
+
+#define bvec_iter_page(bvec, iter)				\
+	nth_page(mp_bvec_iter_page((bvec), (iter)),		\
+		 mp_bvec_iter_page_idx((bvec), (iter)))
+
 #define bvec_iter_bvec(bvec, iter)				\
 ((struct bio_vec) {						\
 	.bv_page	= bvec_iter_page((bvec), (iter)),	\
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index f96b22db5fe7..31b5e7919d62 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2092,8 +2092,15 @@ static int __init console_setup(char *str)
 	char *s, *options, *brl_options = NULL;
 	int idx;
 
-	if (str[0] == 0)
+	/*
+	 * console="" or console=null have been suggested as a way to
+	 * disable console output. Use ttynull that has been created
+	 * for exacly this purpose.
+	 */
+	if (str[0] == 0 || strcmp(str, "null") == 0) {
+		__add_preferred_console("ttynull", 0, NULL, NULL);
 		return 1;
+	}
 
 	if (_braille_console_setup(&str, &brl_options))
 		return 1;
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 6ed736ea9b59..633ebcac82f8 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -83,18 +83,19 @@
  * This is made more complicated by various memory models and PAE.
  */
 
-#ifndef MAX_PHYSMEM_BITS
-#ifdef CONFIG_HIGHMEM64G
-#define MAX_PHYSMEM_BITS 36
-#else /* !CONFIG_HIGHMEM64G */
+#ifndef MAX_POSSIBLE_PHYSMEM_BITS
+#ifdef MAX_PHYSMEM_BITS
+#define MAX_POSSIBLE_PHYSMEM_BITS MAX_PHYSMEM_BITS
+#else
 /*
  * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
  * be PAGE_SHIFT
  */
-#define MAX_PHYSMEM_BITS BITS_PER_LONG
+#define MAX_POSSIBLE_PHYSMEM_BITS BITS_PER_LONG
 #endif
 #endif
-#define _PFN_BITS		(MAX_PHYSMEM_BITS - PAGE_SHIFT)
+
+#define _PFN_BITS		(MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
 
 /*
  * Memory for allocating for handle keeps object position by
