Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 527B320A9E
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 17:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfEPPGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726687AbfEPPGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 11:06:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FCB2082E;
        Thu, 16 May 2019 15:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558019158;
        bh=FD9TNu/M5Lp5onH0/nLiSckZDXLGTOgsk0aXtPPsTGQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LO0sOqduc/txIxZMrslqNE2ORsZ8JugJGp3g4zvrEu0jwL4mb/ldGz8AJDjel4mnI
         ykkA3cIkYeWmVFbktH4gVLlPks34viDSKOsp6subGBnmEo5fHlc6cEPQrWJ1tsWqNS
         nRK8X4VVRQtHsT1HinQ0Jk56Ph7iCwkiLpFG4mtU=
Date:   Thu, 16 May 2019 17:05:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.18.140
Message-ID: <20190516150555.GB30718@kroah.com>
References: <20190516150548.GA30718@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516150548.GA30718@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/usb/power-management.txt b/Documentation/usb/power-management.txt
index 7b90fe034c4b..d3e38fe2091d 100644
--- a/Documentation/usb/power-management.txt
+++ b/Documentation/usb/power-management.txt
@@ -364,11 +364,15 @@ autosuspend the interface's device.  When the usage counter is = 0
 then the interface is considered to be idle, and the kernel may
 autosuspend the device.
 
-Drivers need not be concerned about balancing changes to the usage
-counter; the USB core will undo any remaining "get"s when a driver
-is unbound from its interface.  As a corollary, drivers must not call
-any of the usb_autopm_* functions after their disconnect() routine has
-returned.
+Drivers must be careful to balance their overall changes to the usage
+counter.  Unbalanced "get"s will remain in effect when a driver is
+unbound from its interface, preventing the device from going into
+runtime suspend should the interface be bound to a driver again.  On
+the other hand, drivers are allowed to achieve this balance by calling
+the ``usb_autopm_*`` functions even after their ``disconnect`` routine
+has returned -- say from within a work-queue routine -- provided they
+retain an active reference to the interface (via ``usb_get_intf`` and
+``usb_put_intf``).
 
 Drivers using the async routines are responsible for their own
 synchronization and mutual exclusion.
diff --git a/Makefile b/Makefile
index c2e8362de950..bf1cf82b40c5 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 18
-SUBLEVEL = 139
+SUBLEVEL = 140
 EXTRAVERSION =
 NAME = Diseased Newt
 
diff --git a/arch/arm/mach-iop13xx/setup.c b/arch/arm/mach-iop13xx/setup.c
index 53c316f7301e..fe4932fda01d 100644
--- a/arch/arm/mach-iop13xx/setup.c
+++ b/arch/arm/mach-iop13xx/setup.c
@@ -300,7 +300,7 @@ static struct resource iop13xx_adma_2_resources[] = {
 	}
 };
 
-static u64 iop13xx_adma_dmamask = DMA_BIT_MASK(64);
+static u64 iop13xx_adma_dmamask = DMA_BIT_MASK(32);
 static struct iop_adma_platform_data iop13xx_adma_0_data = {
 	.hw_id = 0,
 	.pool_size = PAGE_SIZE,
@@ -324,7 +324,7 @@ static struct platform_device iop13xx_adma_0_channel = {
 	.resource = iop13xx_adma_0_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop13xx_adma_0_data,
 	},
 };
@@ -336,7 +336,7 @@ static struct platform_device iop13xx_adma_1_channel = {
 	.resource = iop13xx_adma_1_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop13xx_adma_1_data,
 	},
 };
@@ -348,7 +348,7 @@ static struct platform_device iop13xx_adma_2_channel = {
 	.resource = iop13xx_adma_2_resources,
 	.dev = {
 		.dma_mask = &iop13xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop13xx_adma_2_data,
 	},
 };
diff --git a/arch/arm/mach-iop13xx/tpmi.c b/arch/arm/mach-iop13xx/tpmi.c
index db511ec2b1df..116feb6b261e 100644
--- a/arch/arm/mach-iop13xx/tpmi.c
+++ b/arch/arm/mach-iop13xx/tpmi.c
@@ -152,7 +152,7 @@ static struct resource iop13xx_tpmi_3_resources[] = {
 	}
 };
 
-u64 iop13xx_tpmi_mask = DMA_BIT_MASK(64);
+u64 iop13xx_tpmi_mask = DMA_BIT_MASK(32);
 static struct platform_device iop13xx_tpmi_0_device = {
 	.name = "iop-tpmi",
 	.id = 0,
@@ -160,7 +160,7 @@ static struct platform_device iop13xx_tpmi_0_device = {
 	.resource = iop13xx_tpmi_0_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -171,7 +171,7 @@ static struct platform_device iop13xx_tpmi_1_device = {
 	.resource = iop13xx_tpmi_1_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -182,7 +182,7 @@ static struct platform_device iop13xx_tpmi_2_device = {
 	.resource = iop13xx_tpmi_2_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
@@ -193,7 +193,7 @@ static struct platform_device iop13xx_tpmi_3_device = {
 	.resource = iop13xx_tpmi_3_resources,
 	.dev = {
 		.dma_mask          = &iop13xx_tpmi_mask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 	},
 };
 
diff --git a/arch/arm/plat-iop/adma.c b/arch/arm/plat-iop/adma.c
index a4d1f8de3b5b..d9612221e484 100644
--- a/arch/arm/plat-iop/adma.c
+++ b/arch/arm/plat-iop/adma.c
@@ -143,7 +143,7 @@ struct platform_device iop3xx_dma_0_channel = {
 	.resource = iop3xx_dma_0_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop3xx_dma_0_data,
 	},
 };
@@ -155,7 +155,7 @@ struct platform_device iop3xx_dma_1_channel = {
 	.resource = iop3xx_dma_1_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop3xx_dma_1_data,
 	},
 };
@@ -167,7 +167,7 @@ struct platform_device iop3xx_aau_channel = {
 	.resource = iop3xx_aau_resources,
 	.dev = {
 		.dma_mask = &iop3xx_adma_dmamask,
-		.coherent_dma_mask = DMA_BIT_MASK(64),
+		.coherent_dma_mask = DMA_BIT_MASK(32),
 		.platform_data = (void *) &iop3xx_aau_data,
 	},
 };
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index b8b6e22f9987..c774011131e2 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -649,7 +649,7 @@ static struct platform_device orion_xor0_shared = {
 	.resource	= orion_xor0_shared_resources,
 	.dev            = {
 		.dma_mask               = &orion_xor_dmamask,
-		.coherent_dma_mask      = DMA_BIT_MASK(64),
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 		.platform_data          = &orion_xor0_pdata,
 	},
 };
@@ -710,7 +710,7 @@ static struct platform_device orion_xor1_shared = {
 	.resource	= orion_xor1_shared_resources,
 	.dev            = {
 		.dma_mask               = &orion_xor_dmamask,
-		.coherent_dma_mask      = DMA_BIT_MASK(64),
+		.coherent_dma_mask      = DMA_BIT_MASK(32),
 		.platform_data          = &orion_xor1_pdata,
 	},
 };
diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
index 680f2cc13a6d..435d6f86079a 100644
--- a/arch/mips/kernel/scall64-o32.S
+++ b/arch/mips/kernel/scall64-o32.S
@@ -124,7 +124,7 @@ trace_a_syscall:
 	subu	t1, v0,  __NR_O32_Linux
 	move	a1, v0
 	bnez	t1, 1f /* __NR_syscall at offset 0 */
-	lw	a1, PT_R4(sp) /* Arg1 for __NR_syscall case */
+	ld	a1, PT_R4(sp) /* Arg1 for __NR_syscall case */
 	.set	pop
 
 1:	jal	syscall_trace_enter
diff --git a/arch/powerpc/include/asm/reg_booke.h b/arch/powerpc/include/asm/reg_booke.h
index 16547efa2d5a..438f509a4436 100644
--- a/arch/powerpc/include/asm/reg_booke.h
+++ b/arch/powerpc/include/asm/reg_booke.h
@@ -41,7 +41,7 @@
 #if defined(CONFIG_PPC_BOOK3E_64)
 #define MSR_64BIT	MSR_CM
 
-#define MSR_		(MSR_ME | MSR_CE)
+#define MSR_		(MSR_ME | MSR_RI | MSR_CE)
 #define MSR_KERNEL	(MSR_ | MSR_64BIT)
 #define MSR_USER32	(MSR_ | MSR_PR | MSR_EE)
 #define MSR_USER64	(MSR_USER32 | MSR_64BIT)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6b06ab8748dd..005a5b8d5628 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -415,13 +415,13 @@ TRACE_EVENT(kvm_apic_ipi,
 );
 
 TRACE_EVENT(kvm_apic_accept_irq,
-	    TP_PROTO(__u32 apicid, __u16 dm, __u8 tm, __u8 vec),
+	    TP_PROTO(__u32 apicid, __u16 dm, __u16 tm, __u8 vec),
 	    TP_ARGS(apicid, dm, tm, vec),
 
 	TP_STRUCT__entry(
 		__field(	__u32,		apicid		)
 		__field(	__u16,		dm		)
-		__field(	__u8,		tm		)
+		__field(	__u16,		tm		)
 		__field(	__u8,		vec		)
 	),
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index 0ad96c647541..7017a81d53cf 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -51,38 +51,52 @@ static int eject_tray(struct ata_device *dev)
 /* Per the spec, only slot type and drawer type ODD can be supported */
 static enum odd_mech_type zpodd_get_mech_type(struct ata_device *dev)
 {
-	char buf[16];
+	char *buf;
 	unsigned int ret;
-	struct rm_feature_desc *desc = (void *)(buf + 8);
+	struct rm_feature_desc *desc;
 	struct ata_taskfile tf;
 	static const char cdb[] = {  GPCMD_GET_CONFIGURATION,
 			2,      /* only 1 feature descriptor requested */
 			0, 3,   /* 3, removable medium feature */
 			0, 0, 0,/* reserved */
-			0, sizeof(buf),
+			0, 16,
 			0, 0, 0,
 	};
 
+	buf = kzalloc(16, GFP_KERNEL);
+	if (!buf)
+		return ODD_MECH_TYPE_UNSUPPORTED;
+	desc = (void *)(buf + 8);
+
 	ata_tf_init(dev, &tf);
 	tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
 	tf.command = ATA_CMD_PACKET;
 	tf.protocol = ATAPI_PROT_PIO;
-	tf.lbam = sizeof(buf);
+	tf.lbam = 16;
 
 	ret = ata_exec_internal(dev, &tf, cdb, DMA_FROM_DEVICE,
-				buf, sizeof(buf), 0);
-	if (ret)
+				buf, 16, 0);
+	if (ret) {
+		kfree(buf);
 		return ODD_MECH_TYPE_UNSUPPORTED;
+	}
 
-	if (be16_to_cpu(desc->feature_code) != 3)
+	if (be16_to_cpu(desc->feature_code) != 3) {
+		kfree(buf);
 		return ODD_MECH_TYPE_UNSUPPORTED;
+	}
 
-	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1)
+	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1) {
+		kfree(buf);
 		return ODD_MECH_TYPE_SLOT;
-	else if (desc->mech_type == 1 && desc->load == 0 && desc->eject == 1)
+	} else if (desc->mech_type == 1 && desc->load == 0 &&
+		   desc->eject == 1) {
+		kfree(buf);
 		return ODD_MECH_TYPE_DRAWER;
-	else
+	} else {
+		kfree(buf);
 		return ODD_MECH_TYPE_UNSUPPORTED;
+	}
 }
 
 /* Test if ODD is zero power ready by sense code */
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index a467dc43c389..15157a3eabb4 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -81,7 +81,6 @@
 
 static DEFINE_IDR(loop_index_idr);
 static DEFINE_MUTEX(loop_index_mutex);
-static DEFINE_MUTEX(loop_ctl_mutex);
 
 static int max_part;
 static int part_shift;
@@ -1013,7 +1012,7 @@ static int loop_clr_fd(struct loop_device *lo)
 	 */
 	if (lo->lo_refcnt > 1) {
 		lo->lo_flags |= LO_FLAGS_AUTOCLEAR;
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		return 0;
 	}
 
@@ -1062,12 +1061,12 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 	/*
-	 * Need not hold loop_ctl_mutex to fput backing file.
-	 * Calling fput holding loop_ctl_mutex triggers a circular
+	 * Need not hold lo_ctl_mutex to fput backing file.
+	 * Calling fput holding lo_ctl_mutex triggers a circular
 	 * lock dependency possibility warning as fput can take
-	 * bd_mutex which is usually taken before loop_ctl_mutex.
+	 * bd_mutex which is usually taken before lo_ctl_mutex.
 	 */
 	fput(filp);
 	return 0;
@@ -1301,7 +1300,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	struct loop_device *lo = bdev->bd_disk->private_data;
 	int err;
 
-	mutex_lock_nested(&loop_ctl_mutex, 1);
+	mutex_lock_nested(&lo->lo_ctl_mutex, 1);
 	switch (cmd) {
 	case LOOP_SET_FD:
 		err = loop_set_fd(lo, mode, bdev, arg);
@@ -1310,7 +1309,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		err = loop_change_fd(lo, bdev, arg);
 		break;
 	case LOOP_CLR_FD:
-		/* loop_clr_fd would have unlocked loop_ctl_mutex on success */
+		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
 		err = loop_clr_fd(lo);
 		if (!err)
 			goto out_unlocked;
@@ -1341,7 +1340,7 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	default:
 		err = lo->ioctl ? lo->ioctl(lo, cmd, arg) : -EINVAL;
 	}
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 
 out_unlocked:
 	return err;
@@ -1474,16 +1473,16 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch(cmd) {
 	case LOOP_SET_STATUS:
-		mutex_lock(&loop_ctl_mutex);
+		mutex_lock(&lo->lo_ctl_mutex);
 		err = loop_set_status_compat(
 			lo, (const struct compat_loop_info __user *) arg);
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		break;
 	case LOOP_GET_STATUS:
-		mutex_lock(&loop_ctl_mutex);
+		mutex_lock(&lo->lo_ctl_mutex);
 		err = loop_get_status_compat(
 			lo, (struct compat_loop_info __user *) arg);
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		break;
 	case LOOP_SET_CAPACITY:
 	case LOOP_CLR_FD:
@@ -1514,9 +1513,9 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 	}
 
-	mutex_lock(&loop_ctl_mutex);
+	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 out:
 	mutex_unlock(&loop_index_mutex);
 	return err;
@@ -1526,7 +1525,7 @@ static void __lo_release(struct loop_device *lo)
 {
 	int err;
 
-	mutex_lock(&loop_ctl_mutex);
+	mutex_lock(&lo->lo_ctl_mutex);
 
 	if (--lo->lo_refcnt)
 		goto out;
@@ -1548,7 +1547,7 @@ static void __lo_release(struct loop_device *lo)
 	}
 
 out:
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 }
 
 static void lo_release(struct gendisk *disk, fmode_t mode)
@@ -1594,10 +1593,10 @@ static int unregister_transfer_cb(int id, void *ptr, void *data)
 	struct loop_device *lo = ptr;
 	struct loop_func_table *xfer = data;
 
-	mutex_lock(&loop_ctl_mutex);
+	mutex_lock(&lo->lo_ctl_mutex);
 	if (lo->lo_encryption == xfer)
 		loop_release_xfer(lo);
-	mutex_unlock(&loop_ctl_mutex);
+	mutex_unlock(&lo->lo_ctl_mutex);
 	return 0;
 }
 
@@ -1678,7 +1677,7 @@ static int loop_add(struct loop_device **l, int i)
 	if (!part_shift)
 		disk->flags |= GENHD_FL_NO_PART_SCAN;
 	disk->flags |= GENHD_FL_EXT_DEVT;
-	mutex_init(&loop_ctl_mutex);
+	mutex_init(&lo->lo_ctl_mutex);
 	lo->lo_number		= i;
 	lo->lo_thread		= NULL;
 	init_waitqueue_head(&lo->lo_event);
@@ -1790,19 +1789,19 @@ static long loop_control_ioctl(struct file *file, unsigned int cmd,
 		ret = loop_lookup(&lo, parm);
 		if (ret < 0)
 			break;
-		mutex_lock(&loop_ctl_mutex);
+		mutex_lock(&lo->lo_ctl_mutex);
 		if (lo->lo_state != Lo_unbound) {
 			ret = -EBUSY;
-			mutex_unlock(&loop_ctl_mutex);
+			mutex_unlock(&lo->lo_ctl_mutex);
 			break;
 		}
 		if (lo->lo_refcnt > 0) {
 			ret = -EBUSY;
-			mutex_unlock(&loop_ctl_mutex);
+			mutex_unlock(&lo->lo_ctl_mutex);
 			break;
 		}
 		lo->lo_disk->private_data = NULL;
-		mutex_unlock(&loop_ctl_mutex);
+		mutex_unlock(&lo->lo_ctl_mutex);
 		idr_remove(&loop_index_idr, lo->lo_number);
 		loop_remove(lo);
 		break;
diff --git a/drivers/block/loop.h b/drivers/block/loop.h
index 205dfb4767a0..fb113dd45e97 100644
--- a/drivers/block/loop.h
+++ b/drivers/block/loop.h
@@ -55,6 +55,7 @@ struct loop_device {
 	struct bio_list		lo_bio_list;
 	unsigned int		lo_bio_count;
 	int			lo_state;
+	struct mutex		lo_ctl_mutex;
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
 	/* wait queue for incoming requests */
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index c4328d9d9981..f838119d12b2 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1062,6 +1062,8 @@ static int ace_setup(struct ace_device *ace)
 	return 0;
 
 err_read:
+	/* prevent double queue cleanup */
+	ace->gd->queue = NULL;
 	put_disk(ace->gd);
 err_alloc_disk:
 	blk_cleanup_queue(ace->queue);
diff --git a/drivers/gpu/ipu-v3/ipu-dp.c b/drivers/gpu/ipu-v3/ipu-dp.c
index 98686edbcdbb..33de3a1bac49 100644
--- a/drivers/gpu/ipu-v3/ipu-dp.c
+++ b/drivers/gpu/ipu-v3/ipu-dp.c
@@ -195,7 +195,8 @@ int ipu_dp_setup_channel(struct ipu_dp *dp,
 		ipu_dp_csc_init(flow, flow->foreground.in_cs, flow->out_cs,
 				DP_COM_CONF_CSC_DEF_BOTH);
 	} else {
-		if (flow->foreground.in_cs == flow->out_cs)
+		if (flow->foreground.in_cs == IPUV3_COLORSPACE_UNKNOWN ||
+		    flow->foreground.in_cs == flow->out_cs)
 			/*
 			 * foreground identical to output, apply color
 			 * conversion on background
@@ -261,6 +262,8 @@ void ipu_dp_disable_channel(struct ipu_dp *dp)
 	struct ipu_dp_priv *priv = flow->priv;
 	u32 reg, csc;
 
+	dp->in_cs = IPUV3_COLORSPACE_UNKNOWN;
+
 	if (!dp->foreground)
 		return;
 
@@ -268,8 +271,9 @@ void ipu_dp_disable_channel(struct ipu_dp *dp)
 
 	reg = readl(flow->base + DP_COM_CONF);
 	csc = reg & DP_COM_CONF_CSC_DEF_MASK;
-	if (csc == DP_COM_CONF_CSC_DEF_FG)
-		reg &= ~DP_COM_CONF_CSC_DEF_MASK;
+	reg &= ~DP_COM_CONF_CSC_DEF_MASK;
+	if (csc == DP_COM_CONF_CSC_DEF_BOTH || csc == DP_COM_CONF_CSC_DEF_BG)
+		reg |= DP_COM_CONF_CSC_DEF_BG;
 
 	reg &= ~DP_COM_CONF_FG_EN;
 	writel(reg, flow->base + DP_COM_CONF);
@@ -350,6 +354,8 @@ int ipu_dp_init(struct ipu_soc *ipu, struct device *dev, unsigned long base)
 	mutex_init(&priv->mutex);
 
 	for (i = 0; i < IPUV3_NUM_FLOWS; i++) {
+		priv->flow[i].background.in_cs = IPUV3_COLORSPACE_UNKNOWN;
+		priv->flow[i].foreground.in_cs = IPUV3_COLORSPACE_UNKNOWN;
 		priv->flow[i].foreground.foreground = true;
 		priv->flow[i].base = priv->base + ipu_dp_flow_base[i];
 		priv->flow[i].priv = priv;
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index e930627d0c76..71b069bd2a24 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -1057,10 +1057,15 @@ static int hid_debug_rdesc_show(struct seq_file *f, void *p)
 	seq_printf(f, "\n\n");
 
 	/* dump parsed data and input mappings */
+	if (down_interruptible(&hdev->driver_input_lock))
+		return 0;
+
 	hid_dump_device(hdev, f);
 	seq_printf(f, "\n");
 	hid_dump_input_mapping(hdev, f);
 
+	up(&hdev->driver_input_lock);
+
 	return 0;
 }
 
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index bb870ee75a90..b7d5a8835424 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -745,6 +745,10 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 		case 0x074: map_key_clear(KEY_BRIGHTNESS_MAX);		break;
 		case 0x075: map_key_clear(KEY_BRIGHTNESS_AUTO);		break;
 
+		case 0x079: map_key_clear(KEY_KBDILLUMUP);	break;
+		case 0x07a: map_key_clear(KEY_KBDILLUMDOWN);	break;
+		case 0x07c: map_key_clear(KEY_KBDILLUMTOGGLE);	break;
+
 		case 0x082: map_key_clear(KEY_VIDEO_NEXT);	break;
 		case 0x083: map_key_clear(KEY_LAST);		break;
 		case 0x084: map_key_clear(KEY_ENTER);		break;
diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
index a483747cdc9b..b520de11fc17 100644
--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1315,7 +1315,7 @@ static int xadc_remove(struct platform_device *pdev)
 	}
 	free_irq(irq, indio_dev);
 	clk_disable_unprepare(xadc->clk);
-	cancel_delayed_work(&xadc->zynq_unmask_work);
+	cancel_delayed_work_sync(&xadc->zynq_unmask_work);
 	kfree(xadc->data);
 	kfree(indio_dev->channels);
 
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 2f3475247f0f..127f9cc563e9 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -294,7 +294,7 @@ static void iommu_write_l2(struct amd_iommu *iommu, u8 address, u32 val)
 static void iommu_set_exclusion_range(struct amd_iommu *iommu)
 {
 	u64 start = iommu->exclusion_start & PAGE_MASK;
-	u64 limit = (start + iommu->exclusion_length) & PAGE_MASK;
+	u64 limit = (start + iommu->exclusion_length - 1) & PAGE_MASK;
 	u64 entry;
 
 	if (!iommu->exclusion_start)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0ba8dd970e91..031b66a15f8d 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3414,26 +3414,15 @@ static void handle_parity_checks6(struct r5conf *conf, struct stripe_head *sh,
 	case check_state_check_result:
 		sh->check_state = check_state_idle;
 
+		if (s->failed > 1)
+			break;
 		/* handle a successful check operation, if parity is correct
 		 * we are done.  Otherwise update the mismatch count and repair
 		 * parity if !MD_RECOVERY_CHECK
 		 */
 		if (sh->ops.zero_sum_result == 0) {
-			/* both parities are correct */
-			if (!s->failed)
-				set_bit(STRIPE_INSYNC, &sh->state);
-			else {
-				/* in contrast to the raid5 case we can validate
-				 * parity, but still have a failure to write
-				 * back
-				 */
-				sh->check_state = check_state_compute_result;
-				/* Returning at this point means that we may go
-				 * off and bring p and/or q uptodate again so
-				 * we make sure to check zero_sum_result again
-				 * to verify if p or q need writeback
-				 */
-			}
+			/* Any parity checked was correct */
+			set_bit(STRIPE_INSYNC, &sh->state);
 		} else {
 			atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index dd3db2458a4f..8577a0269e5b 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -155,10 +155,10 @@ MODULE_PARM_DESC(debug, "Debug level (0-1)");
 #define REG_GFIX	0x69	/* Fix gain control */
 
 #define REG_DBLV	0x6b	/* PLL control an debugging */
-#define   DBLV_BYPASS	  0x00	  /* Bypass PLL */
-#define   DBLV_X4	  0x01	  /* clock x4 */
-#define   DBLV_X6	  0x10	  /* clock x6 */
-#define   DBLV_X8	  0x11	  /* clock x8 */
+#define   DBLV_BYPASS	  0x0a	  /* Bypass PLL */
+#define   DBLV_X4	  0x4a	  /* clock x4 */
+#define   DBLV_X6	  0x8a	  /* clock x6 */
+#define   DBLV_X8	  0xca	  /* clock x8 */
 
 #define REG_REG76	0x76	/* OV's name */
 #define   R76_BLKPCOR	  0x80	  /* Black pixel correction enable */
@@ -833,7 +833,7 @@ static int ov7675_set_framerate(struct v4l2_subdev *sd,
 	if (ret < 0)
 		return ret;
 
-	return ov7670_write(sd, REG_DBLV, DBLV_X4);
+	return 0;
 }
 
 static void ov7670_get_framerate_legacy(struct v4l2_subdev *sd,
@@ -1540,11 +1540,7 @@ static int ov7670_probe(struct i2c_client *client,
 		if (config->clock_speed)
 			info->clock_speed = config->clock_speed;
 
-		/*
-		 * It should be allowed for ov7670 too when it is migrated to
-		 * the new frame rate formula.
-		 */
-		if (config->pll_bypass && id->driver_data != MODEL_OV7670)
+		if (config->pll_bypass)
 			info->pll_bypass = true;
 
 		if (config->pclk_hb_disable)
diff --git a/drivers/media/usb/tlg2300/Kconfig b/drivers/media/usb/tlg2300/Kconfig
index 645d915267e6..358fff581520 100644
--- a/drivers/media/usb/tlg2300/Kconfig
+++ b/drivers/media/usb/tlg2300/Kconfig
@@ -1,6 +1,7 @@
 config VIDEO_TLG2300
 	tristate "Telegent TLG2300 USB video capture support"
 	depends on VIDEO_DEV && I2C && SND && DVB_CORE
+	depends on BROKEN
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	depends on RC_CORE
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index f1c53944a2c3..f20e205d9318 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -1032,13 +1032,6 @@ static int bond_option_arp_validate_set(struct bonding *bond,
 {
 	netdev_info(bond->dev, "Setting arp_validate to %s (%llu)\n",
 		    newval->string, newval->value);
-
-	if (bond->dev->flags & IFF_UP) {
-		if (!newval->value)
-			bond->recv_probe = NULL;
-		else if (bond->params.arp_interval)
-			bond->recv_probe = bond_arp_rcv;
-	}
 	bond->params.arp_validate = newval->value;
 
 	return 0;
diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
index b01b0ce4d1be..cf9e9a3d4a48 100644
--- a/drivers/net/bonding/bond_sysfs_slave.c
+++ b/drivers/net/bonding/bond_sysfs_slave.c
@@ -55,7 +55,9 @@ static SLAVE_ATTR_RO(link_failure_count);
 
 static ssize_t perm_hwaddr_show(struct slave *slave, char *buf)
 {
-	return sprintf(buf, "%pM\n", slave->perm_hwaddr);
+	return sprintf(buf, "%*phC\n",
+		       slave->dev->addr_len,
+		       slave->perm_hwaddr);
 }
 static SLAVE_ATTR_RO(perm_hwaddr);
 
diff --git a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
index cc83350d56ba..11693f93a17d 100644
--- a/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
+++ b/drivers/net/ethernet/freescale/ucc_geth_ethtool.c
@@ -253,14 +253,12 @@ uec_set_ringparam(struct net_device *netdev,
 		return -EINVAL;
 	}
 
+	if (netif_running(netdev))
+		return -EBUSY;
+
 	ug_info->bdRingLenRx[queue] = ring->rx_pending;
 	ug_info->bdRingLenTx[queue] = ring->tx_pending;
 
-	if (netif_running(netdev)) {
-		/* FIXME: restart automatically */
-		netdev_info(netdev, "Please re-open the interface\n");
-	}
-
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 566b17db135a..a718066bb99f 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -3183,6 +3183,7 @@ static ssize_t ehea_probe_port(struct device *dev,
 
 	if (ehea_add_adapter_mr(adapter)) {
 		pr_err("creating MR failed\n");
+		of_node_put(eth_dn);
 		return -EIO;
 	}
 
diff --git a/drivers/net/ethernet/intel/igb/e1000_defines.h b/drivers/net/ethernet/intel/igb/e1000_defines.h
index 217f8138851b..bd92291e531d 100644
--- a/drivers/net/ethernet/intel/igb/e1000_defines.h
+++ b/drivers/net/ethernet/intel/igb/e1000_defines.h
@@ -193,6 +193,8 @@
 /* enable link status from external LINK_0 and LINK_1 pins */
 #define E1000_CTRL_SWDPIN0  0x00040000  /* SWDPIN 0 value */
 #define E1000_CTRL_SWDPIN1  0x00080000  /* SWDPIN 1 value */
+#define E1000_CTRL_ADVD3WUC 0x00100000  /* D3 WUC */
+#define E1000_CTRL_EN_PHY_PWR_MGMT 0x00200000 /* PHY PM enable */
 #define E1000_CTRL_SDP0_DIR 0x00400000  /* SDP0 Data direction */
 #define E1000_CTRL_SDP1_DIR 0x00800000  /* SDP1 Data direction */
 #define E1000_CTRL_RST      0x04000000  /* Global reset */
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 390d96ae4147..9bd84498cbe7 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -7337,9 +7337,7 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, rctl, status;
 	u32 wufc = runtime ? E1000_WUFC_LNKC : adapter->wol;
-#ifdef CONFIG_PM
-	int retval = 0;
-#endif
+	bool wake;
 
 	rtnl_lock();
 	netif_device_detach(netdev);
@@ -7350,14 +7348,6 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 	igb_clear_interrupt_scheme(adapter);
 	rtnl_unlock();
 
-#ifdef CONFIG_PM
-	if (!runtime) {
-		retval = pci_save_state(pdev);
-		if (retval)
-			return retval;
-	}
-#endif
-
 	status = rd32(E1000_STATUS);
 	if (status & E1000_STATUS_LU)
 		wufc &= ~E1000_WUFC_LNKC;
@@ -7374,10 +7364,6 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 		}
 
 		ctrl = rd32(E1000_CTRL);
-		/* advertise wake from D3Cold */
-		#define E1000_CTRL_ADVD3WUC 0x00100000
-		/* phy power management enable */
-		#define E1000_CTRL_EN_PHY_PWR_MGMT 0x00200000
 		ctrl |= E1000_CTRL_ADVD3WUC;
 		wr32(E1000_CTRL, ctrl);
 
@@ -7391,12 +7377,15 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 		wr32(E1000_WUFC, 0);
 	}
 
-	*enable_wake = wufc || adapter->en_mng_pt;
-	if (!*enable_wake)
+	wake = wufc || adapter->en_mng_pt;
+	if (!wake)
 		igb_power_down_link(adapter);
 	else
 		igb_power_up_link(adapter);
 
+	if (enable_wake)
+		*enable_wake = wake;
+
 	/* Release control of h/w to f/w.  If f/w is AMT enabled, this
 	 * would have already happened in close and is redundant.
 	 */
@@ -7411,22 +7400,7 @@ static int __igb_shutdown(struct pci_dev *pdev, bool *enable_wake,
 #ifdef CONFIG_PM_SLEEP
 static int igb_suspend(struct device *dev)
 {
-	int retval;
-	bool wake;
-	struct pci_dev *pdev = to_pci_dev(dev);
-
-	retval = __igb_shutdown(pdev, &wake, 0);
-	if (retval)
-		return retval;
-
-	if (wake) {
-		pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		pci_set_power_state(pdev, PCI_D3hot);
-	}
-
-	return 0;
+	return __igb_shutdown(to_pci_dev(dev), NULL, 0);
 }
 #endif /* CONFIG_PM_SLEEP */
 
@@ -7495,22 +7469,7 @@ static int igb_runtime_idle(struct device *dev)
 
 static int igb_runtime_suspend(struct device *dev)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	int retval;
-	bool wake;
-
-	retval = __igb_shutdown(pdev, &wake, 1);
-	if (retval)
-		return retval;
-
-	if (wake) {
-		pci_prepare_to_sleep(pdev);
-	} else {
-		pci_wake_from_d3(pdev, false);
-		pci_set_power_state(pdev, PCI_D3hot);
-	}
-
-	return 0;
+	return __igb_shutdown(to_pci_dev(dev), NULL, 1);
 }
 
 static int igb_runtime_resume(struct device *dev)
diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
index 66d4ab703f45..8a94add287de 100644
--- a/drivers/net/ethernet/micrel/ks8851.c
+++ b/drivers/net/ethernet/micrel/ks8851.c
@@ -547,9 +547,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 		/* set dma read address */
 		ks8851_wrreg16(ks, KS_RXFDPR, RXFDPR_RXFPAI | 0x00);
 
-		/* start the packet dma process, and set auto-dequeue rx */
-		ks8851_wrreg16(ks, KS_RXQCR,
-			       ks->rc_rxqcr | RXQCR_SDA | RXQCR_ADRFE);
+		/* start DMA access */
+		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
 
 		if (rxlen > 4) {
 			unsigned int rxalign;
@@ -580,7 +579,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
 			}
 		}
 
-		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr);
+		/* end DMA access and dequeue packet */
+		ks8851_wrreg16(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_RRXEF);
 	}
 }
 
@@ -797,6 +797,15 @@ static void ks8851_tx_work(struct work_struct *work)
 static int ks8851_net_open(struct net_device *dev)
 {
 	struct ks8851_net *ks = netdev_priv(dev);
+	int ret;
+
+	ret = request_threaded_irq(dev->irq, NULL, ks8851_irq,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   dev->name, ks);
+	if (ret < 0) {
+		netdev_err(dev, "failed to get irq\n");
+		return ret;
+	}
 
 	/* lock the card, even if we may not actually be doing anything
 	 * else at the moment */
@@ -861,6 +870,7 @@ static int ks8851_net_open(struct net_device *dev)
 	netif_dbg(ks, ifup, ks->netdev, "network device up\n");
 
 	mutex_unlock(&ks->lock);
+	mii_check_link(&ks->mii);
 	return 0;
 }
 
@@ -911,6 +921,8 @@ static int ks8851_net_stop(struct net_device *dev)
 		dev_kfree_skb(txb);
 	}
 
+	free_irq(dev->irq, ks);
+
 	return 0;
 }
 
@@ -1516,6 +1528,7 @@ static int ks8851_probe(struct spi_device *spi)
 
 	spi_set_drvdata(spi, ks);
 
+	netif_carrier_off(ks->netdev);
 	ndev->if_port = IF_PORT_100BASET;
 	ndev->netdev_ops = &ks8851_netdev_ops;
 	ndev->irq = spi->irq;
@@ -1542,14 +1555,6 @@ static int ks8851_probe(struct spi_device *spi)
 	ks8851_read_selftest(ks);
 	ks8851_init_mac(ks);
 
-	ret = request_threaded_irq(spi->irq, NULL, ks8851_irq,
-				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-				   ndev->name, ks);
-	if (ret < 0) {
-		dev_err(&spi->dev, "failed to get irq\n");
-		goto err_irq;
-	}
-
 	ret = register_netdev(ndev);
 	if (ret) {
 		dev_err(&spi->dev, "failed to register network device\n");
@@ -1562,14 +1567,10 @@ static int ks8851_probe(struct spi_device *spi)
 
 	return 0;
 
-
 err_netdev:
-	free_irq(ndev->irq, ks);
-
-err_irq:
+err_id:
 	if (gpio_is_valid(gpio))
 		gpio_set_value(gpio, 0);
-err_id:
 	regulator_disable(ks->vdd_reg);
 err_reg:
 	regulator_disable(ks->vdd_io);
@@ -1587,7 +1588,6 @@ static int ks8851_remove(struct spi_device *spi)
 		dev_info(&spi->dev, "remove\n");
 
 	unregister_netdev(priv->netdev);
-	free_irq(spi->irq, priv);
 	if (gpio_is_valid(priv->gpio))
 		gpio_set_value(priv->gpio, 0);
 	regulator_disable(priv->vdd_reg);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index 0a2318cad34d..63ebc491057b 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -1038,6 +1038,8 @@ int qlcnic_do_lb_test(struct qlcnic_adapter *adapter, u8 mode)
 
 	for (i = 0; i < QLCNIC_NUM_ILB_PKT; i++) {
 		skb = netdev_alloc_skb(adapter->netdev, QLCNIC_ILB_PKT_SIZE);
+		if (!skb)
+			break;
 		qlcnic_create_loopback_buff(skb->data, adapter->mac_addr);
 		skb_put(skb, QLCNIC_ILB_PKT_SIZE);
 		adapter->ahw->diag_cnt = 0;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fc7b5ac6d6fe..5d27a216f7af 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1736,8 +1736,6 @@ static int stmmac_open(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int ret;
 
-	stmmac_check_ether_addr(priv);
-
 	if (priv->pcs != STMMAC_PCS_RGMII && priv->pcs != STMMAC_PCS_TBI &&
 	    priv->pcs != STMMAC_PCS_RTBI) {
 		ret = stmmac_init_phy(dev);
@@ -2824,6 +2822,8 @@ struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 	if (ret)
 		goto error_hw_init;
 
+	stmmac_check_ether_addr(priv);
+
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index cfd81eb1b532..ddceed3c5a4a 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -153,7 +153,7 @@ out_fail:
 void
 slhc_free(struct slcompress *comp)
 {
-	if ( comp == NULLSLCOMPR )
+	if ( IS_ERR_OR_NULL(comp) )
 		return;
 
 	if ( comp->tstate != NULLSLSTATE )
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index eb04b348edf3..1565bb4da4b3 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1137,6 +1137,12 @@ static int team_port_add(struct team *team, struct net_device *port_dev)
 		return -EINVAL;
 	}
 
+	if (netdev_has_upper_dev(dev, port_dev)) {
+		netdev_err(dev, "Device %s is already an upper device of the team interface\n",
+			   portname);
+		return -EBUSY;
+	}
+
 	if (port_dev->features & NETIF_F_VLAN_CHALLENGED &&
 	    vlan_uses_dev(dev)) {
 		netdev_err(dev, "Device %s is VLAN challenged and team device has VLAN set up\n",
diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index 26ad9ff12ac5..8bf34b97003f 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -4399,14 +4399,16 @@ sony_pic_read_possible_resource(struct acpi_resource *resource, void *context)
 			}
 			return AE_OK;
 		}
+
+	case ACPI_RESOURCE_TYPE_END_TAG:
+		return AE_OK;
+
 	default:
 		dprintk("Resource %d isn't an IRQ nor an IO port\n",
 			resource->type);
+		return AE_CTRL_TERMINATE;
 
-	case ACPI_RESOURCE_TYPE_END_TAG:
-		return AE_OK;
 	}
-	return AE_CTRL_TERMINATE;
 }
 
 static int sony_pic_possible_resources(struct acpi_device *device)
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index d0d2b047658b..dcd5dcae7b3c 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -455,7 +455,7 @@ static int sh_rtc_set_time(struct device *dev, struct rtc_time *tm)
 static inline int sh_rtc_read_alarm_value(struct sh_rtc *rtc, int reg_off)
 {
 	unsigned int byte;
-	int value = 0xff;	/* return 0xff for ignored values */
+	int value = -1;			/* return -1 for ignored values */
 
 	byte = readb(rtc->regbase + reg_off);
 	if (byte & AR_ENB) {
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 4bbcdf991c26..4856e5bbb42f 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -2031,14 +2031,14 @@ static int dasd_eckd_end_analysis(struct dasd_block *block)
 	blk_per_trk = recs_per_track(&private->rdc_data, 0, block->bp_block);
 
 raw:
-	block->blocks = (private->real_cyl *
+	block->blocks = ((unsigned long) private->real_cyl *
 			  private->rdc_data.trk_per_cyl *
 			  blk_per_trk);
 
 	dev_info(&device->cdev->dev,
-		 "DASD with %d KB/block, %d KB total size, %d KB/track, "
+		 "DASD with %u KB/block, %lu KB total size, %u KB/track, "
 		 "%s\n", (block->bp_block >> 10),
-		 ((private->real_cyl *
+		 (((unsigned long) private->real_cyl *
 		   private->rdc_data.trk_per_cyl *
 		   blk_per_trk * (block->bp_block >> 9)) >> 1),
 		 ((blk_per_trk * block->bp_block) >> 10),
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index 7c511add5aa7..84b6c5080a79 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -622,7 +622,7 @@ con3270_init(void)
 		     (void (*)(unsigned long)) con3270_read_tasklet,
 		     (unsigned long) condev->read);
 
-	raw3270_add_view(&condev->view, &con3270_fn, 1);
+	raw3270_add_view(&condev->view, &con3270_fn, 1, RAW3270_VIEW_LOCK_IRQ);
 
 	INIT_LIST_HEAD(&condev->freemem);
 	for (i = 0; i < CON3270_STRING_PAGES; i++) {
diff --git a/drivers/s390/char/fs3270.c b/drivers/s390/char/fs3270.c
index 71e974738014..f0c86bcbe316 100644
--- a/drivers/s390/char/fs3270.c
+++ b/drivers/s390/char/fs3270.c
@@ -463,7 +463,8 @@ fs3270_open(struct inode *inode, struct file *filp)
 
 	init_waitqueue_head(&fp->wait);
 	fp->fs_pid = get_pid(task_pid(current));
-	rc = raw3270_add_view(&fp->view, &fs3270_fn, minor);
+	rc = raw3270_add_view(&fp->view, &fs3270_fn, minor,
+			      RAW3270_VIEW_LOCK_BH);
 	if (rc) {
 		fs3270_free_view(&fp->view);
 		goto out;
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index 220acb4cbee5..9c350e6d75bf 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -956,7 +956,7 @@ raw3270_deactivate_view(struct raw3270_view *view)
  * Add view to device with minor "minor".
  */
 int
-raw3270_add_view(struct raw3270_view *view, struct raw3270_fn *fn, int minor)
+raw3270_add_view(struct raw3270_view *view, struct raw3270_fn *fn, int minor, int subclass)
 {
 	unsigned long flags;
 	struct raw3270 *rp;
@@ -978,6 +978,7 @@ raw3270_add_view(struct raw3270_view *view, struct raw3270_fn *fn, int minor)
 		view->cols = rp->cols;
 		view->ascebc = rp->ascebc;
 		spin_lock_init(&view->lock);
+		lockdep_set_subclass(&view->lock, subclass);
 		list_add(&view->list, &rp->view_list);
 		rc = 0;
 		spin_unlock_irqrestore(get_ccwdev_lock(rp->cdev), flags);
diff --git a/drivers/s390/char/raw3270.h b/drivers/s390/char/raw3270.h
index e1e41c2861fb..5ae54317857a 100644
--- a/drivers/s390/char/raw3270.h
+++ b/drivers/s390/char/raw3270.h
@@ -155,6 +155,8 @@ struct raw3270_fn {
 struct raw3270_view {
 	struct list_head list;
 	spinlock_t lock;
+#define RAW3270_VIEW_LOCK_IRQ	0
+#define RAW3270_VIEW_LOCK_BH	1
 	atomic_t ref_count;
 	struct raw3270 *dev;
 	struct raw3270_fn *fn;
@@ -163,7 +165,7 @@ struct raw3270_view {
 	unsigned char *ascebc;		/* ascii -> ebcdic table */
 };
 
-int raw3270_add_view(struct raw3270_view *, struct raw3270_fn *, int);
+int raw3270_add_view(struct raw3270_view *, struct raw3270_fn *, int, int);
 int raw3270_activate_view(struct raw3270_view *);
 void raw3270_del_view(struct raw3270_view *);
 void raw3270_deactivate_view(struct raw3270_view *);
diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
index e96fc7fd9498..ab95d24b991b 100644
--- a/drivers/s390/char/tty3270.c
+++ b/drivers/s390/char/tty3270.c
@@ -937,7 +937,8 @@ static int tty3270_install(struct tty_driver *driver, struct tty_struct *tty)
 		return PTR_ERR(tp);
 
 	rc = raw3270_add_view(&tp->view, &tty3270_fn,
-			      tty->index + RAW3270_FIRSTMINOR);
+			      tty->index + RAW3270_FIRSTMINOR,
+			      RAW3270_VIEW_LOCK_BH);
 	if (rc) {
 		tty3270_free_view(tp);
 		return rc;
diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index e056dd4fe44d..5526388f905e 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1595,6 +1595,7 @@ static int ctcm_new_device(struct ccwgroup_device *cgdev)
 		if (priv->channel[direction] == NULL) {
 			if (direction == CTCM_WRITE)
 				channel_free(priv->channel[CTCM_READ]);
+			result = -ENODEV;
 			goto out_dev;
 		}
 		priv->channel[direction]->netdev = dev;
diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
index ca28e1c66115..f9d59262da88 100644
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -195,10 +195,6 @@ static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 	list_for_each_entry(port, &adapter->port_list, list) {
 		if ((port->d_id & range) == (ntoh24(page->rscn_fid) & range))
 			zfcp_fc_test_link(port);
-		if (!port->d_id)
-			zfcp_erp_port_reopen(port,
-					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "fcrscn1");
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
@@ -206,6 +202,7 @@ static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 {
 	struct fsf_status_read_buffer *status_buffer = (void *)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fc_els_rscn *head;
 	struct fc_els_rscn_page *page;
 	u16 i;
@@ -218,6 +215,22 @@ static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
 	/* see FC-FS */
 	no_entries = head->rscn_plen / sizeof(struct fc_els_rscn_page);
 
+	if (no_entries > 1) {
+		/* handle failed ports */
+		unsigned long flags;
+		struct zfcp_port *port;
+
+		read_lock_irqsave(&adapter->port_list_lock, flags);
+		list_for_each_entry(port, &adapter->port_list, list) {
+			if (port->d_id)
+				continue;
+			zfcp_erp_port_reopen(port,
+					     ZFCP_STATUS_COMMON_ERP_FAILED,
+					     "fcrscn1");
+		}
+		read_unlock_irqrestore(&adapter->port_list_lock, flags);
+	}
+
 	for (i = 1; i < no_entries; i++) {
 		/* skip head and start with 1st element */
 		page++;
diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 86103c8475d8..fbb2052bc412 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1737,8 +1737,11 @@ csio_scsi_err_handler(struct csio_hw *hw, struct csio_ioreq *req)
 	}
 
 out:
-	if (req->nsge > 0)
+	if (req->nsge > 0) {
 		scsi_dma_unmap(cmnd);
+		if (req->dcopy && (host_status == DID_OK))
+			host_status = csio_scsi_copy_to_sgl(hw, req);
+	}
 
 	cmnd->result = (((host_status) << 16) | scsi_status);
 	cmnd->scsi_done(cmnd);
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 22450abf0a03..773f86729304 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -47,17 +47,16 @@ static void smp_task_timedout(unsigned long _task)
 	unsigned long flags;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
+	if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
 		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+		complete(&task->slow_task->completion);
+	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-
-	complete(&task->slow_task->completion);
 }
 
 static void smp_task_done(struct sas_task *task)
 {
-	if (!del_timer(&task->slow_task->timer))
-		return;
+	del_timer(&task->slow_task->timer);
 	complete(&task->slow_task->completion);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e9cd3013dcd0..71b15541505a 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -431,7 +431,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		}
 
 		ha->optrom_region_start = start;
-		ha->optrom_region_size = start + size;
+		ha->optrom_region_size = size;
 
 		ha->optrom_state = QLA_SREADING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
@@ -504,7 +504,7 @@ qla2x00_sysfs_write_optrom_ctl(struct file *filp, struct kobject *kobj,
 		}
 
 		ha->optrom_region_start = start;
-		ha->optrom_region_size = start + size;
+		ha->optrom_region_size = size;
 
 		ha->optrom_state = QLA_SWRITING;
 		ha->optrom_buffer = vmalloc(ha->optrom_region_size);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a9fac1eb8306..28f6d5ef04e0 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3213,6 +3213,8 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
 		return -EINVAL;
 	ep = iscsi_lookup_endpoint(transport_fd);
+	if (!ep)
+		return -EINVAL;
 	conn = cls_conn->dd_data;
 	qla_conn = conn->dd_data;
 	qla_conn->qla_ep = ep->dd_data;
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 96c6e75bbfe6..bc29b571e3fb 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -788,13 +788,22 @@ static void handle_sc_creation(struct vmbus_channel *new_sc)
 static void  handle_multichannel_storage(struct hv_device *device, int max_chns)
 {
 	struct storvsc_device *stor_device;
-	int num_cpus = num_online_cpus();
 	int num_sc;
 	struct storvsc_cmd_request *request;
 	struct vstor_packet *vstor_packet;
 	int ret, t;
 
-	num_sc = ((max_chns > num_cpus) ? num_cpus : max_chns);
+	/*
+	 * If the number of CPUs is artificially restricted, such as
+	 * with maxcpus=1 on the kernel boot line, Hyper-V could offer
+	 * sub-channels >= the number of CPUs. These sub-channels
+	 * should not be created. The primary channel is already created
+	 * and assigned to one CPU, so check against # CPUs - 1.
+	 */
+	num_sc = min((int)(num_online_cpus() - 1), max_chns);
+	if (!num_sc)
+		return;
+
 	stor_device = get_out_stor_device(device);
 	if (!stor_device)
 		return;
diff --git a/drivers/staging/iio/addac/adt7316.c b/drivers/staging/iio/addac/adt7316.c
index 5b11b42c0254..b654d26ce046 100644
--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -47,6 +47,8 @@
 #define ADT7516_MSB_AIN3		0xA
 #define ADT7516_MSB_AIN4		0xB
 #define ADT7316_DA_DATA_BASE		0x10
+#define ADT7316_DA_10_BIT_LSB_SHIFT	6
+#define ADT7316_DA_12_BIT_LSB_SHIFT	4
 #define ADT7316_DA_MSB_DATA_REGS	4
 #define ADT7316_LSB_DAC_A		0x10
 #define ADT7316_MSB_DAC_A		0x11
@@ -1092,7 +1094,7 @@ static ssize_t adt7316_store_DAC_internal_Vref(struct device *dev,
 		ldac_config = chip->ldac_config & (~ADT7516_DAC_IN_VREF_MASK);
 		if (data & 0x1)
 			ldac_config |= ADT7516_DAC_AB_IN_VREF;
-		else if (data & 0x2)
+		if (data & 0x2)
 			ldac_config |= ADT7516_DAC_CD_IN_VREF;
 	} else {
 		ret = kstrtou8(buf, 16, &data);
@@ -1414,7 +1416,7 @@ static IIO_DEVICE_ATTR(ex_analog_temp_offset, S_IRUGO | S_IWUSR,
 static ssize_t adt7316_show_DAC(struct adt7316_chip_info *chip,
 		int channel, char *buf)
 {
-	u16 data;
+	u16 data = 0;
 	u8 msb, lsb, offset;
 	int ret;
 
@@ -1439,7 +1441,11 @@ static ssize_t adt7316_show_DAC(struct adt7316_chip_info *chip,
 	if (ret)
 		return -EIO;
 
-	data = (msb << offset) + (lsb & ((1 << offset) - 1));
+	if (chip->dac_bits == 12)
+		data = lsb >> ADT7316_DA_12_BIT_LSB_SHIFT;
+	else if (chip->dac_bits == 10)
+		data = lsb >> ADT7316_DA_10_BIT_LSB_SHIFT;
+	data |= msb << offset;
 
 	return sprintf(buf, "%d\n", data);
 }
@@ -1447,7 +1453,7 @@ static ssize_t adt7316_show_DAC(struct adt7316_chip_info *chip,
 static ssize_t adt7316_store_DAC(struct adt7316_chip_info *chip,
 		int channel, const char *buf, size_t len)
 {
-	u8 msb, lsb, offset;
+	u8 msb, lsb, lsb_reg, offset;
 	u16 data;
 	int ret;
 
@@ -1465,9 +1471,13 @@ static ssize_t adt7316_store_DAC(struct adt7316_chip_info *chip,
 		return -EINVAL;
 
 	if (chip->dac_bits > 8) {
-		lsb = data & (1 << offset);
+		lsb = data & ((1 << offset) - 1);
+		if (chip->dac_bits == 12)
+			lsb_reg = lsb << ADT7316_DA_12_BIT_LSB_SHIFT;
+		else
+			lsb_reg = lsb << ADT7316_DA_10_BIT_LSB_SHIFT;
 		ret = chip->bus.write(chip->bus.client,
-			ADT7316_DA_DATA_BASE + channel * 2, lsb);
+			ADT7316_DA_DATA_BASE + channel * 2, lsb_reg);
 		if (ret)
 			return -EIO;
 	}
diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 73f392586786..4061323be79f 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -467,11 +467,6 @@ static int usb_unbind_interface(struct device *dev)
 		pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
 
-	/* Undo any residual pm_autopm_get_interface_* calls */
-	for (r = atomic_read(&intf->pm_usage_cnt); r > 0; --r)
-		usb_autopm_put_interface_no_suspend(intf);
-	atomic_set(&intf->pm_usage_cnt, 0);
-
 	if (!error)
 		usb_autosuspend_device(udev);
 
@@ -1604,7 +1599,6 @@ void usb_autopm_put_interface(struct usb_interface *intf)
 	int			status;
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	status = pm_runtime_put_sync(&intf->dev);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
@@ -1633,7 +1627,6 @@ void usb_autopm_put_interface_async(struct usb_interface *intf)
 	int			status;
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	status = pm_runtime_put(&intf->dev);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
@@ -1655,7 +1648,6 @@ void usb_autopm_put_interface_no_suspend(struct usb_interface *intf)
 	struct usb_device	*udev = interface_to_usbdev(intf);
 
 	usb_mark_last_busy(udev);
-	atomic_dec(&intf->pm_usage_cnt);
 	pm_runtime_put_noidle(&intf->dev);
 }
 EXPORT_SYMBOL_GPL(usb_autopm_put_interface_no_suspend);
@@ -1686,8 +1678,6 @@ int usb_autopm_get_interface(struct usb_interface *intf)
 	status = pm_runtime_get_sync(&intf->dev);
 	if (status < 0)
 		pm_runtime_put_sync(&intf->dev);
-	else
-		atomic_inc(&intf->pm_usage_cnt);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
 			status);
@@ -1721,8 +1711,6 @@ int usb_autopm_get_interface_async(struct usb_interface *intf)
 	status = pm_runtime_get(&intf->dev);
 	if (status < 0 && status != -EINPROGRESS)
 		pm_runtime_put_noidle(&intf->dev);
-	else
-		atomic_inc(&intf->pm_usage_cnt);
 	dev_vdbg(&intf->dev, "%s: cnt %d -> %d\n",
 			__func__, atomic_read(&intf->dev.power.usage_count),
 			status);
@@ -1746,7 +1734,6 @@ void usb_autopm_get_interface_no_resume(struct usb_interface *intf)
 	struct usb_device	*udev = interface_to_usbdev(intf);
 
 	usb_mark_last_busy(udev);
-	atomic_inc(&intf->pm_usage_cnt);
 	pm_runtime_get_noresume(&intf->dev);
 }
 EXPORT_SYMBOL_GPL(usb_autopm_get_interface_no_resume);
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index f8eb72d350ac..c245f93bb2cb 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -820,9 +820,11 @@ int usb_string(struct usb_device *dev, int index, char *buf, size_t size)
 
 	if (dev->state == USB_STATE_SUSPENDED)
 		return -EHOSTUNREACH;
-	if (size <= 0 || !buf || !index)
+	if (size <= 0 || !buf)
 		return -EINVAL;
 	buf[0] = 0;
+	if (index <= 0 || index >= 256)
+		return -EINVAL;
 	tbuf = kmalloc(256, GFP_NOIO);
 	if (!tbuf)
 		return -ENOMEM;
diff --git a/drivers/usb/gadget/udc/net2272.c b/drivers/usb/gadget/udc/net2272.c
index 4b2444e75840..83d0544338ca 100644
--- a/drivers/usb/gadget/udc/net2272.c
+++ b/drivers/usb/gadget/udc/net2272.c
@@ -962,6 +962,7 @@ net2272_dequeue(struct usb_ep *_ep, struct usb_request *_req)
 			break;
 	}
 	if (&req->req != _req) {
+		ep->stopped = stopped;
 		spin_unlock_irqrestore(&ep->dev->lock, flags);
 		return -EINVAL;
 	}
diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 8d13337e2dde..931765208286 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -800,9 +800,6 @@ static void start_queue(struct net2280_ep *ep, u32 dmactl, u32 td_dma)
 	(void) readl(&ep->dev->pci->pcimstctl);
 
 	writel(BIT(DMA_START), &dma->dmastat);
-
-	if (!ep->is_in)
-		stop_out_naking(ep);
 }
 
 static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
@@ -841,6 +838,7 @@ static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
 			writel(BIT(DMA_START), &dma->dmastat);
 			return;
 		}
+		stop_out_naking(ep);
 	}
 
 	tmp = dmactl_default;
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index ab5128755672..3d9ce725d1df 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -3234,6 +3234,9 @@ static int __init u132_hcd_init(void)
 	printk(KERN_INFO "driver %s\n", hcd_name);
 	workqueue = create_singlethread_workqueue("u132");
 	retval = platform_driver_register(&u132_platform_driver);
+	if (retval)
+		destroy_workqueue(workqueue);
+
 	return retval;
 }
 
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index fbcb1cd4c118..b92046a38644 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -332,6 +332,7 @@ static void yurex_disconnect(struct usb_interface *interface)
 	usb_deregister_dev(interface, &yurex_class);
 
 	/* prevent more I/O from starting */
+	usb_poison_urb(dev->urb);
 	mutex_lock(&dev->io_mutex);
 	dev->interface = NULL;
 	mutex_unlock(&dev->io_mutex);
diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index c44b911937e8..0036d9627787 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -350,39 +350,59 @@ void usb_serial_generic_read_bulk_callback(struct urb *urb)
 	struct usb_serial_port *port = urb->context;
 	unsigned char *data = urb->transfer_buffer;
 	unsigned long flags;
+	bool stopped = false;
+	int status = urb->status;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(port->read_urbs); ++i) {
 		if (urb == port->read_urbs[i])
 			break;
 	}
-	set_bit(i, &port->read_urbs_free);
 
 	dev_dbg(&port->dev, "%s - urb %d, len %d\n", __func__, i,
 							urb->actual_length);
-	switch (urb->status) {
+	switch (status) {
 	case 0:
+		usb_serial_debug_data(&port->dev, __func__, urb->actual_length,
+							data);
+		port->serial->type->process_read_urb(urb);
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
-		return;
+							__func__, status);
+		stopped = true;
+		break;
 	case -EPIPE:
 		dev_err(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
-		return;
+							__func__, status);
+		stopped = true;
+		break;
 	default:
 		dev_dbg(&port->dev, "%s - nonzero urb status: %d\n",
-							__func__, urb->status);
-		goto resubmit;
+							__func__, status);
+		break;
 	}
 
-	usb_serial_debug_data(&port->dev, __func__, urb->actual_length, data);
-	port->serial->type->process_read_urb(urb);
+	/*
+	 * Make sure URB processing is done before marking as free to avoid
+	 * racing with unthrottle() on another CPU. Matches the barriers
+	 * implied by the test_and_clear_bit() in
+	 * usb_serial_generic_submit_read_urb().
+	 */
+	smp_mb__before_atomic();
+	set_bit(i, &port->read_urbs_free);
+	/*
+	 * Make sure URB is marked as free before checking the throttled flag
+	 * to avoid racing with unthrottle() on another CPU. Matches the
+	 * smp_mb() in unthrottle().
+	 */
+	smp_mb__after_atomic();
+
+	if (stopped)
+		return;
 
-resubmit:
 	/* Throttle the device if requested by tty */
 	spin_lock_irqsave(&port->lock, flags);
 	port->throttled = port->throttle_req;
@@ -399,6 +419,7 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 {
 	unsigned long flags;
 	struct usb_serial_port *port = urb->context;
+	int status = urb->status;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(port->write_urbs); ++i) {
@@ -410,22 +431,22 @@ void usb_serial_generic_write_bulk_callback(struct urb *urb)
 	set_bit(i, &port->write_urbs_free);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	switch (urb->status) {
+	switch (status) {
 	case 0:
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
 	case -ESHUTDOWN:
 		dev_dbg(&port->dev, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	case -EPIPE:
 		dev_err_console(port, "%s - urb stopped: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		return;
 	default:
 		dev_err_console(port, "%s - nonzero urb status: %d\n",
-							__func__, urb->status);
+							__func__, status);
 		goto resubmit;
 	}
 
@@ -456,6 +477,12 @@ void usb_serial_generic_unthrottle(struct tty_struct *tty)
 	port->throttled = port->throttle_req = 0;
 	spin_unlock_irq(&port->lock);
 
+	/*
+	 * Matches the smp_mb__after_atomic() in
+	 * usb_serial_generic_read_bulk_callback().
+	 */
+	smp_mb();
+
 	if (was_throttled)
 		usb_serial_generic_submit_read_urbs(port, GFP_KERNEL);
 }
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index 27e4a580d2ed..ba41b5ac83f3 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -769,18 +769,16 @@ static void rts51x_suspend_timer_fn(unsigned long data)
 		break;
 	case RTS51X_STAT_IDLE:
 	case RTS51X_STAT_SS:
-		usb_stor_dbg(us, "RTS51X_STAT_SS, intf->pm_usage_cnt:%d, power.usage:%d\n",
-			     atomic_read(&us->pusb_intf->pm_usage_cnt),
+		usb_stor_dbg(us, "RTS51X_STAT_SS, power.usage:%d\n",
 			     atomic_read(&us->pusb_intf->dev.power.usage_count));
 
-		if (atomic_read(&us->pusb_intf->pm_usage_cnt) > 0) {
+		if (atomic_read(&us->pusb_intf->dev.power.usage_count) > 0) {
 			usb_stor_dbg(us, "Ready to enter SS state\n");
 			rts51x_set_stat(chip, RTS51X_STAT_SS);
 			/* ignore mass storage interface's children */
 			pm_suspend_ignore_children(&us->pusb_intf->dev, true);
 			usb_autopm_put_interface_async(us->pusb_intf);
-			usb_stor_dbg(us, "RTS51X_STAT_SS 01, intf->pm_usage_cnt:%d, power.usage:%d\n",
-				     atomic_read(&us->pusb_intf->pm_usage_cnt),
+			usb_stor_dbg(us, "RTS51X_STAT_SS 01, power.usage:%d\n",
 				     atomic_read(&us->pusb_intf->dev.power.usage_count));
 		}
 		break;
@@ -813,11 +811,10 @@ static void rts51x_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 	int ret;
 
 	if (working_scsi(srb)) {
-		usb_stor_dbg(us, "working scsi, intf->pm_usage_cnt:%d, power.usage:%d\n",
-			     atomic_read(&us->pusb_intf->pm_usage_cnt),
+		usb_stor_dbg(us, "working scsi, power.usage:%d\n",
 			     atomic_read(&us->pusb_intf->dev.power.usage_count));
 
-		if (atomic_read(&us->pusb_intf->pm_usage_cnt) <= 0) {
+		if (atomic_read(&us->pusb_intf->dev.power.usage_count) <= 0) {
 			ret = usb_autopm_get_interface(us->pusb_intf);
 			usb_stor_dbg(us, "working scsi, ret=%d\n", ret);
 		}
diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 56cacb68040c..808e3a317954 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -380,22 +380,10 @@ static int get_pipe(struct stub_device *sdev, struct usbip_header *pdu)
 	}
 
 	if (usb_endpoint_xfer_isoc(epd)) {
-		/* validate packet size and number of packets */
-		unsigned int maxp, packets, bytes;
-
-#define USB_EP_MAXP_MULT_SHIFT  11
-#define USB_EP_MAXP_MULT_MASK   (3 << USB_EP_MAXP_MULT_SHIFT)
-#define USB_EP_MAXP_MULT(m) \
-	(((m) & USB_EP_MAXP_MULT_MASK) >> USB_EP_MAXP_MULT_SHIFT)
-
-		maxp = usb_endpoint_maxp(epd);
-		maxp *= (USB_EP_MAXP_MULT(
-				__le16_to_cpu(epd->wMaxPacketSize)) + 1);
-		bytes = pdu->u.cmd_submit.transfer_buffer_length;
-		packets = DIV_ROUND_UP(bytes, maxp);
-
+		/* validate number of packets */
 		if (pdu->u.cmd_submit.number_of_packets < 0 ||
-		    pdu->u.cmd_submit.number_of_packets > packets) {
+		    pdu->u.cmd_submit.number_of_packets >
+		    USBIP_MAX_ISO_PACKETS) {
 			dev_err(&sdev->udev->dev,
 				"CMD_SUBMIT: isoc invalid num packets %d\n",
 				pdu->u.cmd_submit.number_of_packets);
diff --git a/drivers/usb/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
index 0fc5ace57c0e..af903aa4ad90 100644
--- a/drivers/usb/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -134,6 +134,13 @@ extern struct device_attribute dev_attr_usbip_debug;
 #define USBIP_DIR_OUT	0x00
 #define USBIP_DIR_IN	0x01
 
+/*
+ * Arbitrary limit for the maximum number of isochronous packets in an URB,
+ * compare for example the uhci_submit_isochronous function in
+ * drivers/usb/host/uhci-q.c
+ */
+#define USBIP_MAX_ISO_PACKETS 1024
+
 /**
  * struct usbip_header_basic - data pertinent to every request
  * @command: the usbip request type
diff --git a/drivers/virt/fsl_hypervisor.c b/drivers/virt/fsl_hypervisor.c
index 32c8fc5f7a5c..3df3946d6e82 100644
--- a/drivers/virt/fsl_hypervisor.c
+++ b/drivers/virt/fsl_hypervisor.c
@@ -215,6 +215,9 @@ static long ioctl_memcpy(struct fsl_hv_ioctl_memcpy __user *p)
 	 * hypervisor.
 	 */
 	lb_offset = param.local_vaddr & (PAGE_SIZE - 1);
+	if (param.count == 0 ||
+	    param.count > U64_MAX - lb_offset - PAGE_SIZE + 1)
+		return -EINVAL;
 	num_pages = (param.count + lb_offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Allocate the buffers we need */
@@ -335,8 +338,8 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __user *p, int set)
 	struct fsl_hv_ioctl_prop param;
 	char __user *upath, *upropname;
 	void __user *upropval;
-	char *path = NULL, *propname = NULL;
-	void *propval = NULL;
+	char *path, *propname;
+	void *propval;
 	int ret = 0;
 
 	/* Get the parameters from the user. */
@@ -348,32 +351,30 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __user *p, int set)
 	upropval = (void __user *)(uintptr_t)param.propval;
 
 	path = strndup_user(upath, FH_DTPROP_MAX_PATHLEN);
-	if (IS_ERR(path)) {
-		ret = PTR_ERR(path);
-		goto out;
-	}
+	if (IS_ERR(path))
+		return PTR_ERR(path);
 
 	propname = strndup_user(upropname, FH_DTPROP_MAX_PATHLEN);
 	if (IS_ERR(propname)) {
 		ret = PTR_ERR(propname);
-		goto out;
+		goto err_free_path;
 	}
 
 	if (param.proplen > FH_DTPROP_MAX_PROPLEN) {
 		ret = -EINVAL;
-		goto out;
+		goto err_free_propname;
 	}
 
 	propval = kmalloc(param.proplen, GFP_KERNEL);
 	if (!propval) {
 		ret = -ENOMEM;
-		goto out;
+		goto err_free_propname;
 	}
 
 	if (set) {
 		if (copy_from_user(propval, upropval, param.proplen)) {
 			ret = -EFAULT;
-			goto out;
+			goto err_free_propval;
 		}
 
 		param.ret = fh_partition_set_dtprop(param.handle,
@@ -392,7 +393,7 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __user *p, int set)
 			if (copy_to_user(upropval, propval, param.proplen) ||
 			    put_user(param.proplen, &p->proplen)) {
 				ret = -EFAULT;
-				goto out;
+				goto err_free_propval;
 			}
 		}
 	}
@@ -400,10 +401,12 @@ static long ioctl_dtprop(struct fsl_hv_ioctl_prop __user *p, int set)
 	if (put_user(param.ret, &p->ret))
 		ret = -EFAULT;
 
-out:
-	kfree(path);
+err_free_propval:
 	kfree(propval);
+err_free_propname:
 	kfree(propname);
+err_free_path:
+	kfree(path);
 
 	return ret;
 }
diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 1de6df87bfa3..919ad5f1f6c1 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -1013,15 +1013,15 @@ static int ds_probe(struct usb_interface *intf,
 	/* alternative 3, 1ms interrupt (greatly speeds search), 64 byte bulk */
 	alt = 3;
 	err = usb_set_interface(dev->udev,
-		intf->altsetting[alt].desc.bInterfaceNumber, alt);
+		intf->cur_altsetting->desc.bInterfaceNumber, alt);
 	if (err) {
 		dev_err(&dev->udev->dev, "Failed to set alternative setting %d "
 			"for %d interface: err=%d.\n", alt,
-			intf->altsetting[alt].desc.bInterfaceNumber, err);
+			intf->cur_altsetting->desc.bInterfaceNumber, err);
 		goto err_out_clear;
 	}
 
-	iface_desc = &intf->altsetting[alt];
+	iface_desc = intf->cur_altsetting;
 	if (iface_desc->desc.bNumEndpoints != NUM_EP-1) {
 		pr_info("Num endpoints=%d. It is not DS9490R.\n",
 			iface_desc->desc.bNumEndpoints);
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 695e7888fef8..e641fc3e9131 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1308,6 +1308,7 @@ void ceph_dentry_lru_del(struct dentry *dn)
 unsigned ceph_dentry_hash(struct inode *dir, struct dentry *dn)
 {
 	struct ceph_inode_info *dci = ceph_inode(dir);
+	unsigned hash;
 
 	switch (dci->i_dir_layout.dl_dir_hash) {
 	case 0:	/* for backward compat */
@@ -1315,8 +1316,11 @@ unsigned ceph_dentry_hash(struct inode *dir, struct dentry *dn)
 		return dn->d_name.hash;
 
 	default:
-		return ceph_str_hash(dci->i_dir_layout.dl_dir_hash,
+		spin_lock(&dn->d_lock);
+		hash = ceph_str_hash(dci->i_dir_layout.dl_dir_hash,
 				     dn->d_name.name, dn->d_name.len);
+		spin_unlock(&dn->d_lock);
+		return hash;
 	}
 }
 
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 7a1df90c7771..7641fcf83ac8 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -472,6 +472,7 @@ static void ceph_i_callback(struct rcu_head *head)
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	struct ceph_inode_info *ci = ceph_inode(inode);
 
+	kfree(ci->i_symlink);
 	kmem_cache_free(ceph_inode_cachep, ci);
 }
 
@@ -503,7 +504,6 @@ void ceph_destroy_inode(struct inode *inode)
 		ceph_put_snap_realm(mdsc, realm);
 	}
 
-	kfree(ci->i_symlink);
 	while ((n = rb_first(&ci->i_fragtree)) != NULL) {
 		frag = rb_entry(n, struct ceph_inode_frag, node);
 		rb_erase(n, &ci->i_fragtree);
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index ec1ed7e4b8f3..c3a03f5a1b49 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -484,11 +484,17 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 					umode_t mode, dev_t dev)
 {
 	struct inode *inode;
-	struct resv_map *resv_map;
+	struct resv_map *resv_map = NULL;
 
-	resv_map = resv_map_alloc();
-	if (!resv_map)
-		return NULL;
+	/*
+	 * Reserve maps are only needed for inodes that can have associated
+	 * page allocations.
+	 */
+	if (S_ISREG(mode) || S_ISLNK(mode)) {
+		resv_map = resv_map_alloc();
+		if (!resv_map)
+			return NULL;
+	}
 
 	inode = new_inode(sb);
 	if (inode) {
@@ -530,8 +536,10 @@ static struct inode *hugetlbfs_get_inode(struct super_block *sb,
 			break;
 		}
 		lockdep_annotate_inode_mutex_key(inode);
-	} else
-		kref_put(&resv_map->refs, resv_map_release);
+	} else {
+		if (resv_map)
+			kref_put(&resv_map->refs, resv_map_release);
+	}
 
 	return inode;
 }
diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index 386303dca382..4f390be71723 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -1429,11 +1429,6 @@ void jffs2_do_clear_inode(struct jffs2_sb_info *c, struct jffs2_inode_info *f)
 
 	jffs2_kill_fragtree(&f->fragtree, deleted?c:NULL);
 
-	if (f->target) {
-		kfree(f->target);
-		f->target = NULL;
-	}
-
 	fds = f->dents;
 	while(fds) {
 		fd = fds;
diff --git a/fs/jffs2/super.c b/fs/jffs2/super.c
index 0bbc31d10857..d1be5991bb66 100644
--- a/fs/jffs2/super.c
+++ b/fs/jffs2/super.c
@@ -47,7 +47,10 @@ static struct inode *jffs2_alloc_inode(struct super_block *sb)
 static void jffs2_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
-	kmem_cache_free(jffs2_inode_cachep, JFFS2_INODE_INFO(inode));
+	struct jffs2_inode_info *f = JFFS2_INODE_INFO(inode);
+
+	kfree(f->target);
+	kmem_cache_free(jffs2_inode_cachep, f);
 }
 
 static void jffs2_destroy_inode(struct inode *inode)
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index d2fcd6e9d675..d70b4ed1b936 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -2019,7 +2019,8 @@ static int nfs23_validate_mount_data(void *options,
 		memcpy(sap, &data->addr, sizeof(data->addr));
 		args->nfs_server.addrlen = sizeof(data->addr);
 		args->nfs_server.port = ntohs(data->addr.sin_port);
-		if (!nfs_verify_server_address(sap))
+		if (sap->sa_family != AF_INET ||
+		    !nfs_verify_server_address(sap))
 			goto out_no_address;
 
 		if (!(data->flags & NFS_MOUNT_TCP))
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 2a7e8c85b6e3..96b780a01016 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1512,9 +1512,11 @@ static void drop_sysctl_table(struct ctl_table_header *header)
 	if (--header->nreg)
 		return;
 
-	if (parent)
+	if (parent) {
 		put_links(header);
-	start_unregistering(header);
+		start_unregistering(header);
+	}
+
 	if (!--header->count)
 		kfree_rcu(header, rcu);
 
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 2ddc93aea4a1..5ed9e6306fd4 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -125,7 +125,6 @@ enum usb_interface_condition {
  * @dev: driver model's view of this device
  * @usb_dev: if an interface is bound to the USB major, this will point
  *	to the sysfs representation for that device.
- * @pm_usage_cnt: PM usage counter for this interface
  * @reset_ws: Used for scheduling resets from atomic context.
  * @resetting_device: USB core reset the device, so use alt setting 0 as
  *	current; needs bandwidth alloc after reset.
@@ -181,7 +180,6 @@ struct usb_interface {
 
 	struct device dev;		/* interface specific device info */
 	struct device *usb_dev;
-	atomic_t pm_usage_cnt;		/* usage counter for autosuspend */
 	struct work_struct reset_ws;	/* for resets in atomic context */
 };
 #define	to_usb_interface(d) container_of(d, struct usb_interface, dev)
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 37ff1aef0845..604d35957030 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -145,6 +145,9 @@ struct oob_data {
 
 #define HCI_MAX_SHORT_NAME_LENGTH	10
 
+/* Min encryption key size to match with SMP */
+#define HCI_MIN_ENC_KEY_SIZE		7
+
 /* Default LE RPA expiry time, 15 minutes */
 #define HCI_DEFAULT_RPA_TIMEOUT		(15 * 60)
 
diff --git a/init/main.c b/init/main.c
index 32940a68ea48..6235c0bed3da 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,6 +539,8 @@ asmlinkage __visible void __init start_kernel(void)
 	page_alloc_init();
 
 	pr_notice("Kernel command line: %s\n", boot_command_line);
+	/* parameters may set static keys */
+	jump_label_init();
 	parse_early_param();
 	after_dashes = parse_args("Booting kernel",
 				  static_command_line, __start___param,
@@ -548,8 +550,6 @@ asmlinkage __visible void __init start_kernel(void)
 		parse_args("Setting init args", after_dashes, NULL, 0, -1, -1,
 			   set_init_arg);
 
-	jump_label_init();
-
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index e7ef539c56d9..749280b58080 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -307,8 +307,10 @@ irq_set_affinity_notifier(unsigned int irq, struct irq_affinity_notify *notify)
 	desc->affinity_notify = notify;
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
-	if (old_notify)
+	if (old_notify) {
+		cancel_work_sync(&old_notify->work);
 		kref_put(&old_notify->kref, old_notify->release);
+	}
 
 	return 0;
 }
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9020fbe8d785..a116db60e3b0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1569,6 +1569,10 @@ static u64 numa_get_avg_runtime(struct task_struct *p, u64 *period)
 	if (p->last_task_numa_placement) {
 		delta = runtime - p->last_sum_exec_runtime;
 		*period = now - p->last_task_numa_placement;
+
+		/* Avoid time going backwards, prevent potential divide error: */
+		if (unlikely((s64)*period < 0))
+			*period = 0;
 	} else {
 		delta = p->se.avg.runnable_avg_sum;
 		*period = p->se.avg.runnable_avg_period;
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 1fb08f21302e..0334899f1d3e 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -417,7 +417,7 @@ static int __init init_tstats_procfs(void)
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_stats", 0644, NULL, &tstats_fops);
+	pe = proc_create("timer_stats", 0600, NULL, &tstats_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 173ff025ea75..48d4291c34cd 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -730,7 +730,7 @@ u64 ring_buffer_time_stamp(struct ring_buffer *buffer, int cpu)
 
 	preempt_disable_notrace();
 	time = rb_time_stamp(buffer);
-	preempt_enable_no_resched_notrace();
+	preempt_enable_notrace();
 
 	return time;
 }
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 1ab6797be8a3..d53bb8b78131 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -394,10 +394,12 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	ifrr.ifr_ifru = ifr->ifr_ifru;
 
 	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		if (!net_eq(dev_net(dev), &init_net))
+			break;
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-	case SIOCSHWTSTAMP:
 	case SIOCGHWTSTAMP:
 		if (netif_device_present(real_dev) && ops->ndo_do_ioctl)
 			err = ops->ndo_do_ioctl(real_dev, &ifrr, cmd);
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index b45eb243a5ee..489fb5abb8f0 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -932,6 +932,14 @@ int hci_conn_check_link_mode(struct hci_conn *conn)
 	    !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
 		return 0;
 
+	/* The minimum encryption key size needs to be enforced by the
+	 * host stack before establishing any L2CAP connections. The
+	 * specification in theory allows a minimum of 1, but to align
+	 * BR/EDR and LE transports, a minimum of 7 is chosen.
+	 */
+	if (conn->enc_key_size < HCI_MIN_ENC_KEY_SIZE)
+		return 0;
+
 	return 1;
 }
 
diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
index cb3fdde1968a..322047f9d038 100644
--- a/net/bluetooth/hidp/sock.c
+++ b/net/bluetooth/hidp/sock.c
@@ -76,6 +76,7 @@ static int hidp_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long
 			sockfd_put(csock);
 			return err;
 		}
+		ca.name[sizeof(ca.name)-1] = 0;
 
 		err = hidp_connection_add(&ca, csock, isock);
 		if (!err && copy_to_user(argp, &ca, sizeof(ca)))
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index ef88729ad3d7..42e4d2b32c60 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -460,13 +460,15 @@ int br_add_if(struct net_bridge *br, struct net_device *dev)
 	call_netdevice_notifiers(NETDEV_JOIN, dev);
 
 	err = dev_set_allmulti(dev, 1);
-	if (err)
-		goto put_back;
+	if (err) {
+		kfree(p);	/* kobject not yet init'd, manually free */
+		goto err1;
+	}
 
 	err = kobject_init_and_add(&p->kobj, &brport_ktype, &(dev->dev.kobj),
 				   SYSFS_BRIDGE_PORT_ATTR);
 	if (err)
-		goto err1;
+		goto err2;
 
 	err = br_sysfs_addif(p);
 	if (err)
@@ -531,12 +533,9 @@ err3:
 	sysfs_remove_link(br->ifobj, p->dev->name);
 err2:
 	kobject_put(&p->kobj);
-	p = NULL; /* kobject_put frees */
-err1:
 	dev_set_allmulti(dev, -1);
-put_back:
+err1:
 	dev_put(dev);
-	kfree(p);
 	return err;
 }
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 5e3df32902b1..f8dfa7af4af5 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2042,7 +2042,8 @@ static int ebt_size_mwt(struct compat_ebt_entry_mwt *match32,
 		if (match_kern)
 			match_kern->match_size = ret;
 
-		if (WARN_ON(type == EBT_COMPAT_TARGET && size_left))
+		/* rule should have no remaining data after target */
+		if (type == EBT_COMPAT_TARGET && size_left)
 			return -EINVAL;
 
 		match32 = (struct compat_ebt_entry_mwt *) buf;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index f6c8f825ae6b..3fdc44b3a562 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -454,6 +454,7 @@ static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 	to->pkt_type = from->pkt_type;
 	to->priority = from->priority;
 	to->protocol = from->protocol;
+	to->skb_iif = from->skb_iif;
 	skb_dst_drop(to);
 	skb_dst_copy(to, from);
 	to->dev = from->dev;
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index b127807c0bbf..8326cff3e3e0 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -158,6 +158,7 @@ static int icmp_filter(const struct sock *sk, const struct sk_buff *skb)
  */
 static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 {
+	int dif = inet_iif(skb);
 	struct sock *sk;
 	struct hlist_head *head;
 	int delivered = 0;
@@ -170,8 +171,7 @@ static int raw_v4_input(struct sk_buff *skb, const struct iphdr *iph, int hash)
 
 	net = dev_net(skb->dev);
 	sk = __raw_v4_lookup(net, __sk_head(head), iph->protocol,
-			     iph->saddr, iph->daddr,
-			     skb->dev->ifindex);
+			     iph->saddr, iph->daddr, dif);
 
 	while (sk) {
 		delivered = 1;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index b53385c18dce..8f770627b3c8 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1148,25 +1148,39 @@ static struct dst_entry *ipv4_dst_check(struct dst_entry *dst, u32 cookie)
 	return dst;
 }
 
-static void ipv4_link_failure(struct sk_buff *skb)
+static void ipv4_send_dest_unreach(struct sk_buff *skb)
 {
 	struct ip_options opt;
-	struct rtable *rt;
 	int res;
 
 	/* Recompile ip options since IPCB may not be valid anymore.
+	 * Also check we have a reasonable ipv4 header.
 	 */
-	memset(&opt, 0, sizeof(opt));
-	opt.optlen = ip_hdr(skb)->ihl*4 - sizeof(struct iphdr);
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)) ||
+	    ip_hdr(skb)->version != 4 || ip_hdr(skb)->ihl < 5)
+		return;
 
-	rcu_read_lock();
-	res = __ip_options_compile(dev_net(skb->dev), &opt, skb, NULL);
-	rcu_read_unlock();
+	memset(&opt, 0, sizeof(opt));
+	if (ip_hdr(skb)->ihl > 5) {
+		if (!pskb_network_may_pull(skb, ip_hdr(skb)->ihl * 4))
+			return;
+		opt.optlen = ip_hdr(skb)->ihl * 4 - sizeof(struct iphdr);
 
-	if (res)
-		return;
+		rcu_read_lock();
+		res = __ip_options_compile(dev_net(skb->dev), &opt, skb, NULL);
+		rcu_read_unlock();
 
+		if (res)
+			return;
+	}
 	__icmp_send(skb, ICMP_DEST_UNREACH, ICMP_HOST_UNREACH, 0, &opt);
+}
+
+static void ipv4_link_failure(struct sk_buff *skb)
+{
+	struct rtable *rt;
+
+	ipv4_send_dest_unreach(skb);
 
 	rt = skb_rtable(skb);
 	if (rt)
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 1a83031bcddd..d4584d512b0b 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -94,16 +94,21 @@ static struct ip6_flowlabel *fl_lookup(struct net *net, __be32 label)
 	return fl;
 }
 
+static void fl_free_rcu(struct rcu_head *head)
+{
+	struct ip6_flowlabel *fl = container_of(head, struct ip6_flowlabel, rcu);
+
+	if (fl->share == IPV6_FL_S_PROCESS)
+		put_pid(fl->owner.pid);
+	release_net(fl->fl_net);
+	kfree(fl->opt);
+	kfree(fl);
+}
 
 static void fl_free(struct ip6_flowlabel *fl)
 {
-	if (fl) {
-		if (fl->share == IPV6_FL_S_PROCESS)
-			put_pid(fl->owner.pid);
-		release_net(fl->fl_net);
-		kfree(fl->opt);
-		kfree_rcu(fl, rcu);
-	}
+	if (fl)
+		call_rcu(&fl->rcu, fl_free_rcu);
 }
 
 static void fl_release(struct ip6_flowlabel *fl)
@@ -629,9 +634,9 @@ recheck:
 				if (fl1->share == IPV6_FL_S_EXCL ||
 				    fl1->share != fl->share ||
 				    ((fl1->share == IPV6_FL_S_PROCESS) &&
-				     (fl1->owner.pid == fl->owner.pid)) ||
+				     (fl1->owner.pid != fl->owner.pid)) ||
 				    ((fl1->share == IPV6_FL_S_USER) &&
-				     uid_eq(fl1->owner.uid, fl->owner.uid)))
+				     !uid_eq(fl1->owner.uid, fl->owner.uid)))
 					goto release;
 
 				err = -ENOMEM;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 97c37cf56019..8669e190ce35 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1648,7 +1648,7 @@ static int __init xt_init(void)
 		seqcount_init(&per_cpu(xt_recseq, i));
 	}
 
-	xt = kmalloc(sizeof(struct xt_af) * NFPROTO_NUMPROTO, GFP_KERNEL);
+	xt = kcalloc(NFPROTO_NUMPROTO, sizeof(struct xt_af), GFP_KERNEL);
 	if (!xt)
 		return -ENOMEM;
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 158f7b5ff637..ae913d7f3604 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2252,8 +2252,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	void *ph;
 	DECLARE_SOCKADDR(struct sockaddr_ll *, saddr, msg->msg_name);
 	bool need_wait = !(msg->msg_flags & MSG_DONTWAIT);
+	unsigned char *addr = NULL;
 	int tp_len, size_max;
-	unsigned char *addr;
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen;
@@ -2273,10 +2273,13 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 						sll_addr)))
 			goto out;
 		proto	= saddr->sll_protocol;
-		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev = dev_get_by_index(sock_net(&po->sk), saddr->sll_ifindex);
-		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out_put;
+		if (po->sk.sk_socket->type == SOCK_DGRAM) {
+			if (dev && msg->msg_namelen < dev->addr_len +
+				   offsetof(struct sockaddr_ll, sll_addr))
+				goto out_put;
+			addr = saddr->sll_addr;
+		}
 	}
 
 	err = -ENXIO;
@@ -2411,7 +2414,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
-	unsigned char *addr;
+	unsigned char *addr = NULL;
 	int err, reserve = 0;
 	struct virtio_net_hdr vnet_hdr = { 0 };
 	int offset = 0;
@@ -2428,7 +2431,6 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 	if (likely(saddr == NULL)) {
 		dev	= packet_cached_dev_get(po);
 		proto	= po->num;
-		addr	= NULL;
 	} else {
 		err = -EINVAL;
 		if (msg->msg_namelen < sizeof(struct sockaddr_ll))
@@ -2436,10 +2438,13 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
 		if (msg->msg_namelen < (saddr->sll_halen + offsetof(struct sockaddr_ll, sll_addr)))
 			goto out;
 		proto	= saddr->sll_protocol;
-		addr	= saddr->sll_halen ? saddr->sll_addr : NULL;
 		dev = dev_get_by_index(sock_net(sk), saddr->sll_ifindex);
-		if (addr && dev && saddr->sll_halen < dev->addr_len)
-			goto out_unlock;
+		if (sock->type == SOCK_DGRAM) {
+			if (dev && msg->msg_namelen < dev->addr_len +
+				   offsetof(struct sockaddr_ll, sll_addr))
+				goto out_unlock;
+			addr = saddr->sll_addr;
+		}
 	}
 
 	err = -ENXIO;
@@ -4195,14 +4200,29 @@ static void __exit packet_exit(void)
 
 static int __init packet_init(void)
 {
-	int rc = proto_register(&packet_proto, 0);
+	int rc;
 
-	if (rc != 0)
+	rc = proto_register(&packet_proto, 0);
+	if (rc)
 		goto out;
+	rc = sock_register(&packet_family_ops);
+	if (rc)
+		goto out_proto;
+	rc = register_pernet_subsys(&packet_net_ops);
+	if (rc)
+		goto out_sock;
+	rc = register_netdevice_notifier(&packet_netdev_notifier);
+	if (rc)
+		goto out_pernet;
 
-	sock_register(&packet_family_ops);
-	register_pernet_subsys(&packet_net_ops);
-	register_netdevice_notifier(&packet_netdev_notifier);
+	return 0;
+
+out_pernet:
+	unregister_pernet_subsys(&packet_net_ops);
+out_sock:
+	sock_unregister(PF_PACKET);
+out_proto:
+	proto_unregister(&packet_proto);
 out:
 	return rc;
 }
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index cdfa7f4c0a59..4a5598a42cd6 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -50,6 +50,7 @@ static void cache_init(struct cache_head *h)
 	h->last_refresh = now;
 }
 
+static inline int cache_is_valid(struct cache_head *h);
 static void cache_fresh_locked(struct cache_head *head, time_t expiry);
 static void cache_fresh_unlocked(struct cache_head *head,
 				struct cache_detail *detail);
@@ -98,6 +99,8 @@ struct cache_head *sunrpc_cache_lookup(struct cache_detail *detail,
 				*hp = tmp->next;
 				tmp->next = NULL;
 				detail->entries --;
+				if (cache_is_valid(tmp) == -EAGAIN)
+					set_bit(CACHE_NEGATIVE, &tmp->flags);
 				cache_fresh_locked(tmp, 0);
 				freeme = tmp;
 				break;
diff --git a/scripts/kconfig/lxdialog/inputbox.c b/scripts/kconfig/lxdialog/inputbox.c
index d58de1dc5360..510049a7bd1d 100644
--- a/scripts/kconfig/lxdialog/inputbox.c
+++ b/scripts/kconfig/lxdialog/inputbox.c
@@ -126,7 +126,8 @@ do_resize:
 			case KEY_DOWN:
 				break;
 			case KEY_BACKSPACE:
-			case 127:
+			case 8:   /* ^H */
+			case 127: /* ^? */
 				if (pos) {
 					wattrset(dialog, dlg.inputbox.atr);
 					if (input_x == 0) {
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 984489ef2b46..e570f6c9b3ad 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1046,7 +1046,7 @@ static int do_match(int key, struct match_state *state, int *ans)
 		state->match_direction = FIND_NEXT_MATCH_UP;
 		*ans = get_mext_match(state->pattern,
 				state->match_direction);
-	} else if (key == KEY_BACKSPACE || key == 127) {
+	} else if (key == KEY_BACKSPACE || key == 8 || key == 127) {
 		state->pattern[strlen(state->pattern)-1] = '\0';
 		adj_match_dir(&state->match_direction);
 	} else
diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index 4b2f44c20caf..9a65035cf787 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -439,7 +439,8 @@ int dialog_inputbox(WINDOW *main_window,
 		case KEY_F(F_EXIT):
 		case KEY_F(F_BACK):
 			break;
-		case 127:
+		case 8:   /* ^H */
+		case 127: /* ^? */
 		case KEY_BACKSPACE:
 			if (cursor_position > 0) {
 				memmove(&result[cursor_position-1],
diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 736c1ea8e31e..756796c06413 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -641,6 +641,7 @@ static const struct regmap_config cs4270_regmap = {
 	.reg_defaults =		cs4270_reg_defaults,
 	.num_reg_defaults =	ARRAY_SIZE(cs4270_reg_defaults),
 	.cache_type =		REGCACHE_RBTREE,
+	.write_flag_mask =	CS4270_I2C_INCR,
 
 	.readable_reg =		cs4270_reg_is_readable,
 	.volatile_reg =		cs4270_reg_is_volatile,
diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 6ea662db2410..fdce75d5c675 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -234,6 +234,8 @@ static const struct snd_soc_dapm_widget aic32x4_dapm_widgets[] = {
 	SND_SOC_DAPM_INPUT("IN2_R"),
 	SND_SOC_DAPM_INPUT("IN3_L"),
 	SND_SOC_DAPM_INPUT("IN3_R"),
+	SND_SOC_DAPM_INPUT("CM_L"),
+	SND_SOC_DAPM_INPUT("CM_R"),
 };
 
 static const struct snd_soc_dapm_route aic32x4_dapm_routes[] = {
diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
index e2fb859fbbaa..4323002c67db 100644
--- a/sound/soc/soc-pcm.c
+++ b/sound/soc/soc-pcm.c
@@ -847,10 +847,13 @@ static int soc_pcm_hw_params(struct snd_pcm_substream *substream,
 		codec_params = *params;
 
 		/* fixup params based on TDM slot masks */
-		if (codec_dai->tx_mask)
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK &&
+		    codec_dai->tx_mask)
 			soc_pcm_codec_params_fixup(&codec_params,
 						   codec_dai->tx_mask);
-		if (codec_dai->rx_mask)
+
+		if (substream->stream == SNDRV_PCM_STREAM_CAPTURE &&
+		    codec_dai->rx_mask)
 			soc_pcm_codec_params_fixup(&codec_params,
 						   codec_dai->rx_mask);
 
diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 84374e313e3f..d404c3ded0e3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2065,7 +2065,7 @@ eval_type_str(unsigned long long val, const char *type, int pointer)
 		return val & 0xffffffff;
 
 	if (strcmp(type, "u64") == 0 ||
-	    strcmp(type, "s64"))
+	    strcmp(type, "s64") == 0)
 		return val;
 
 	if (strcmp(type, "s8") == 0)
diff --git a/tools/testing/selftests/net/run_netsocktests b/tools/testing/selftests/net/run_netsocktests
index c09a682df56a..19486dab2379 100644
--- a/tools/testing/selftests/net/run_netsocktests
+++ b/tools/testing/selftests/net/run_netsocktests
@@ -6,7 +6,7 @@ echo "--------------------"
 ./socket
 if [ $? -ne 0 ]; then
 	echo "[FAIL]"
+	exit 1
 else
 	echo "[PASS]"
 fi
-
