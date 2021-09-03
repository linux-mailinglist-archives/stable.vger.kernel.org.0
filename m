Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9FA3FFC9F
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 11:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348659AbhICJDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 05:03:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348666AbhICJCz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 05:02:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97D0F610A2;
        Fri,  3 Sep 2021 09:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630659715;
        bh=5yO7qXQ8twd1FaHEUS8Xl5YmPKZVKNNkryhnU/VDT4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxVPOz7/Zo5JVw+Qz9sS0Qc18B9ddzdZIlBVlZTSvIDqvef75yswDOnY+gKPIrkCc
         pj5VWgqYgD/3Q+7t8S/6sFnN3KXtszEblssAdvrrskVshmEiXD9f7hwLFHd5DUepT1
         E4tj9ONgnOuZHyCUKxX1cIhqRHBhQkOVVPeNkqHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.13.14
Date:   Fri,  3 Sep 2021 11:01:47 +0200
Message-Id: <1630659707178205@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163065970717133@kroah.com>
References: <163065970717133@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
index 23b227614366..c92f951b8538 100644
--- a/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
+++ b/Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml
@@ -24,10 +24,10 @@ allOf:
 select:
   properties:
     compatible:
-      items:
-        - enum:
-            - sifive,fu540-c000-ccache
-            - sifive,fu740-c000-ccache
+      contains:
+        enum:
+          - sifive,fu540-c000-ccache
+          - sifive,fu740-c000-ccache
 
   required:
     - compatible
diff --git a/Makefile b/Makefile
index ed4031db3894..de1f9c79e27a 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 13
-SUBLEVEL = 13
+SUBLEVEL = 14
 EXTRAVERSION =
 NAME = Opossums on Parade
 
diff --git a/arch/arc/kernel/vmlinux.lds.S b/arch/arc/kernel/vmlinux.lds.S
index e2146a8da195..529ae50f9fe2 100644
--- a/arch/arc/kernel/vmlinux.lds.S
+++ b/arch/arc/kernel/vmlinux.lds.S
@@ -88,6 +88,8 @@ SECTIONS
 		CPUIDLE_TEXT
 		LOCK_TEXT
 		KPROBES_TEXT
+		IRQENTRY_TEXT
+		SOFTIRQENTRY_TEXT
 		*(.fixup)
 		*(.gnu.warning)
 	}
diff --git a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
index 801995af3dfc..c096b7758aa0 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8994-angler-rev-101.dts
@@ -36,3 +36,7 @@ serial@f991e000 {
 		};
 	};
 };
+
+&tlmm {
+	gpio-reserved-ranges = <85 4>;
+};
diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/asm/el2_setup.h
index 21fa330f498d..b83fb24954b7 100644
--- a/arch/arm64/include/asm/el2_setup.h
+++ b/arch/arm64/include/asm/el2_setup.h
@@ -33,8 +33,7 @@
  * EL2.
  */
 .macro __init_el2_timers
-	mrs	x0, cnthctl_el2
-	orr	x0, x0, #3			// Enable EL1 physical timers
+	mov	x0, #3				// Enable EL1 physical timers
 	msr	cnthctl_el2, x0
 	msr	cntvoff_el2, xzr		// Clear virtual offset
 .endm
diff --git a/arch/parisc/include/asm/string.h b/arch/parisc/include/asm/string.h
index 4a0c9dbd62fd..f6e1132f4e35 100644
--- a/arch/parisc/include/asm/string.h
+++ b/arch/parisc/include/asm/string.h
@@ -8,19 +8,4 @@ extern void * memset(void *, int, size_t);
 #define __HAVE_ARCH_MEMCPY
 void * memcpy(void * dest,const void *src,size_t count);
 
-#define __HAVE_ARCH_STRLEN
-extern size_t strlen(const char *s);
-
-#define __HAVE_ARCH_STRCPY
-extern char *strcpy(char *dest, const char *src);
-
-#define __HAVE_ARCH_STRNCPY
-extern char *strncpy(char *dest, const char *src, size_t count);
-
-#define __HAVE_ARCH_STRCAT
-extern char *strcat(char *dest, const char *src);
-
-#define __HAVE_ARCH_MEMSET
-extern void *memset(void *, int, size_t);
-
 #endif
diff --git a/arch/parisc/kernel/parisc_ksyms.c b/arch/parisc/kernel/parisc_ksyms.c
index 8ed409ecec93..e8a6a751dfd8 100644
--- a/arch/parisc/kernel/parisc_ksyms.c
+++ b/arch/parisc/kernel/parisc_ksyms.c
@@ -17,10 +17,6 @@
 
 #include <linux/string.h>
 EXPORT_SYMBOL(memset);
-EXPORT_SYMBOL(strlen);
-EXPORT_SYMBOL(strcpy);
-EXPORT_SYMBOL(strncpy);
-EXPORT_SYMBOL(strcat);
 
 #include <linux/atomic.h>
 EXPORT_SYMBOL(__xchg8);
diff --git a/arch/parisc/lib/Makefile b/arch/parisc/lib/Makefile
index 2d7a9974dbae..7b197667faf6 100644
--- a/arch/parisc/lib/Makefile
+++ b/arch/parisc/lib/Makefile
@@ -3,7 +3,7 @@
 # Makefile for parisc-specific library files
 #
 
-lib-y	:= lusercopy.o bitops.o checksum.o io.o memcpy.o \
-	   ucmpdi2.o delay.o string.o
+lib-y	:= lusercopy.o bitops.o checksum.o io.o memset.o memcpy.o \
+	   ucmpdi2.o delay.o
 
 obj-y	:= iomap.o
diff --git a/arch/parisc/lib/memset.c b/arch/parisc/lib/memset.c
new file mode 100644
index 000000000000..133e4809859a
--- /dev/null
+++ b/arch/parisc/lib/memset.c
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#include <linux/types.h>
+#include <asm/string.h>
+
+#define OPSIZ (BITS_PER_LONG/8)
+typedef unsigned long op_t;
+
+void *
+memset (void *dstpp, int sc, size_t len)
+{
+  unsigned int c = sc;
+  long int dstp = (long int) dstpp;
+
+  if (len >= 8)
+    {
+      size_t xlen;
+      op_t cccc;
+
+      cccc = (unsigned char) c;
+      cccc |= cccc << 8;
+      cccc |= cccc << 16;
+      if (OPSIZ > 4)
+	/* Do the shift in two steps to avoid warning if long has 32 bits.  */
+	cccc |= (cccc << 16) << 16;
+
+      /* There are at least some bytes to set.
+	 No need to test for LEN == 0 in this alignment loop.  */
+      while (dstp % OPSIZ != 0)
+	{
+	  ((unsigned char *) dstp)[0] = c;
+	  dstp += 1;
+	  len -= 1;
+	}
+
+      /* Write 8 `op_t' per iteration until less than 8 `op_t' remain.  */
+      xlen = len / (OPSIZ * 8);
+      while (xlen > 0)
+	{
+	  ((op_t *) dstp)[0] = cccc;
+	  ((op_t *) dstp)[1] = cccc;
+	  ((op_t *) dstp)[2] = cccc;
+	  ((op_t *) dstp)[3] = cccc;
+	  ((op_t *) dstp)[4] = cccc;
+	  ((op_t *) dstp)[5] = cccc;
+	  ((op_t *) dstp)[6] = cccc;
+	  ((op_t *) dstp)[7] = cccc;
+	  dstp += 8 * OPSIZ;
+	  xlen -= 1;
+	}
+      len %= OPSIZ * 8;
+
+      /* Write 1 `op_t' per iteration until less than OPSIZ bytes remain.  */
+      xlen = len / OPSIZ;
+      while (xlen > 0)
+	{
+	  ((op_t *) dstp)[0] = cccc;
+	  dstp += OPSIZ;
+	  xlen -= 1;
+	}
+      len %= OPSIZ;
+    }
+
+  /* Write the last few bytes.  */
+  while (len > 0)
+    {
+      ((unsigned char *) dstp)[0] = c;
+      dstp += 1;
+      len -= 1;
+    }
+
+  return dstpp;
+}
diff --git a/arch/parisc/lib/string.S b/arch/parisc/lib/string.S
deleted file mode 100644
index 4a64264427a6..000000000000
--- a/arch/parisc/lib/string.S
+++ /dev/null
@@ -1,136 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *    PA-RISC assembly string functions
- *
- *    Copyright (C) 2019 Helge Deller <deller@gmx.de>
- */
-
-#include <asm/assembly.h>
-#include <linux/linkage.h>
-
-	.section .text.hot
-	.level PA_ASM_LEVEL
-
-	t0 = r20
-	t1 = r21
-	t2 = r22
-
-ENTRY_CFI(strlen, frame=0,no_calls)
-	or,COND(<>) arg0,r0,ret0
-	b,l,n	.Lstrlen_null_ptr,r0
-	depwi	0,31,2,ret0
-	cmpb,COND(<>) arg0,ret0,.Lstrlen_not_aligned
-	ldw,ma	4(ret0),t0
-	cmpib,tr 0,r0,.Lstrlen_loop
-	uxor,nbz r0,t0,r0
-.Lstrlen_not_aligned:
-	uaddcm	arg0,ret0,t1
-	shladd	t1,3,r0,t1
-	mtsar	t1
-	depwi	-1,%sar,32,t0
-	uxor,nbz r0,t0,r0
-.Lstrlen_loop:
-	b,l,n	.Lstrlen_end_loop,r0
-	ldw,ma	4(ret0),t0
-	cmpib,tr 0,r0,.Lstrlen_loop
-	uxor,nbz r0,t0,r0
-.Lstrlen_end_loop:
-	extrw,u,<> t0,7,8,r0
-	addib,tr,n -3,ret0,.Lstrlen_out
-	extrw,u,<> t0,15,8,r0
-	addib,tr,n -2,ret0,.Lstrlen_out
-	extrw,u,<> t0,23,8,r0
-	addi	-1,ret0,ret0
-.Lstrlen_out:
-	bv r0(rp)
-	uaddcm ret0,arg0,ret0
-.Lstrlen_null_ptr:
-	bv,n r0(rp)
-ENDPROC_CFI(strlen)
-
-
-ENTRY_CFI(strcpy, frame=0,no_calls)
-	ldb	0(arg1),t0
-	stb	t0,0(arg0)
-	ldo	0(arg0),ret0
-	ldo	1(arg1),t1
-	cmpb,=	r0,t0,2f
-	ldo	1(arg0),t2
-1:	ldb	0(t1),arg1
-	stb	arg1,0(t2)
-	ldo	1(t1),t1
-	cmpb,<> r0,arg1,1b
-	ldo	1(t2),t2
-2:	bv,n	r0(rp)
-ENDPROC_CFI(strcpy)
-
-
-ENTRY_CFI(strncpy, frame=0,no_calls)
-	ldb	0(arg1),t0
-	stb	t0,0(arg0)
-	ldo	1(arg1),t1
-	ldo	0(arg0),ret0
-	cmpb,=	r0,t0,2f
-	ldo	1(arg0),arg1
-1:	ldo	-1(arg2),arg2
-	cmpb,COND(=),n r0,arg2,2f
-	ldb	0(t1),arg0
-	stb	arg0,0(arg1)
-	ldo	1(t1),t1
-	cmpb,<> r0,arg0,1b
-	ldo	1(arg1),arg1
-2:	bv,n	r0(rp)
-ENDPROC_CFI(strncpy)
-
-
-ENTRY_CFI(strcat, frame=0,no_calls)
-	ldb	0(arg0),t0
-	cmpb,=	t0,r0,2f
-	ldo	0(arg0),ret0
-	ldo	1(arg0),arg0
-1:	ldb	0(arg0),t1
-	cmpb,<>,n r0,t1,1b
-	ldo	1(arg0),arg0
-2:	ldb	0(arg1),t2
-	stb	t2,0(arg0)
-	ldo	1(arg0),arg0
-	ldb	0(arg1),t0
-	cmpb,<>	r0,t0,2b
-	ldo	1(arg1),arg1
-	bv,n	r0(rp)
-ENDPROC_CFI(strcat)
-
-
-ENTRY_CFI(memset, frame=0,no_calls)
-	copy	arg0,ret0
-	cmpb,COND(=) r0,arg0,4f
-	copy	arg0,t2
-	cmpb,COND(=) r0,arg2,4f
-	ldo	-1(arg2),arg3
-	subi	-1,arg3,t0
-	subi	0,t0,t1
-	cmpiclr,COND(>=) 0,t1,arg2
-	ldo	-1(t1),arg2
-	extru arg2,31,2,arg0
-2:	stb	arg1,0(t2)
-	ldo	1(t2),t2
-	addib,>= -1,arg0,2b
-	ldo	-1(arg3),arg3
-	cmpiclr,COND(<=) 4,arg2,r0
-	b,l,n	4f,r0
-#ifdef CONFIG_64BIT
-	depd,*	r0,63,2,arg2
-#else
-	depw	r0,31,2,arg2
-#endif
-	ldo	1(t2),t2
-3:	stb	arg1,-1(t2)
-	stb	arg1,0(t2)
-	stb	arg1,1(t2)
-	stb	arg1,2(t2)
-	addib,COND(>) -4,arg2,3b
-	ldo	4(t2),t2
-4:	bv,n	r0(rp)
-ENDPROC_CFI(memset)
-
-	.end
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index f998e655b570..7450651a7536 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -97,7 +97,7 @@ config PPC_BOOK3S_64
 	select PPC_HAVE_PMU_SUPPORT
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select ARCH_ENABLE_HUGEPAGE_MIGRATION if HUGETLB_PAGE && MIGRATION
-	select ARCH_ENABLE_PMD_SPLIT_PTLOCK
+	select ARCH_ENABLE_SPLIT_PMD_PTLOCK
 	select ARCH_ENABLE_THP_MIGRATION if TRANSPARENT_HUGEPAGE
 	select ARCH_SUPPORTS_HUGETLBFS
 	select ARCH_SUPPORTS_NUMA_BALANCING
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index 1a85305720e8..9c0511119bad 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -10,6 +10,7 @@
 #include <asm/ptrace.h>
 #include <asm/syscall.h>
 #include <asm/thread_info.h>
+#include <asm/switch_to.h>
 #include <linux/audit.h>
 #include <linux/ptrace.h>
 #include <linux/elf.h>
@@ -56,6 +57,9 @@ static int riscv_fpr_get(struct task_struct *target,
 {
 	struct __riscv_d_ext_state *fstate = &target->thread.fstate;
 
+	if (target == current)
+		fstate_save(current, task_pt_regs(current));
+
 	membuf_write(&to, fstate, offsetof(struct __riscv_d_ext_state, fcsr));
 	membuf_store(&to, fstate->fcsr);
 	return membuf_zero(&to, 4);	// explicitly pad
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 1f7bb4898a9d..a8f02c889ae8 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4701,7 +4701,7 @@ static void __snr_uncore_mmio_init_box(struct intel_uncore_box *box,
 		return;
 
 	pci_read_config_dword(pdev, SNR_IMC_MMIO_BASE_OFFSET, &pci_dword);
-	addr = (pci_dword & SNR_IMC_MMIO_BASE_MASK) << 23;
+	addr = ((resource_size_t)pci_dword & SNR_IMC_MMIO_BASE_MASK) << 23;
 
 	pci_read_config_dword(pdev, mem_offset, &pci_dword);
 	addr |= (pci_dword & SNR_IMC_MMIO_MEM0_MASK) << 12;
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 5fac3757e6e0..0e56557cacf2 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3061,19 +3061,19 @@ static ssize_t ioc_weight_write(struct kernfs_open_file *of, char *buf,
 		if (v < CGROUP_WEIGHT_MIN || v > CGROUP_WEIGHT_MAX)
 			return -EINVAL;
 
-		spin_lock(&blkcg->lock);
+		spin_lock_irq(&blkcg->lock);
 		iocc->dfl_weight = v * WEIGHT_ONE;
 		hlist_for_each_entry(blkg, &blkcg->blkg_list, blkcg_node) {
 			struct ioc_gq *iocg = blkg_to_iocg(blkg);
 
 			if (iocg) {
-				spin_lock_irq(&iocg->ioc->lock);
+				spin_lock(&iocg->ioc->lock);
 				ioc_now(iocg->ioc, &now);
 				weight_updated(iocg, &now);
-				spin_unlock_irq(&iocg->ioc->lock);
+				spin_unlock(&iocg->ioc->lock);
 			}
 		}
-		spin_unlock(&blkcg->lock);
+		spin_unlock_irq(&blkcg->lock);
 
 		return nbytes;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c732aa581124..6dfa572ac1fc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -923,34 +923,14 @@ static bool blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 	unsigned long *next = priv;
 
 	/*
-	 * Just do a quick check if it is expired before locking the request in
-	 * so we're not unnecessarilly synchronizing across CPUs.
-	 */
-	if (!blk_mq_req_expired(rq, next))
-		return true;
-
-	/*
-	 * We have reason to believe the request may be expired. Take a
-	 * reference on the request to lock this request lifetime into its
-	 * currently allocated context to prevent it from being reallocated in
-	 * the event the completion by-passes this timeout handler.
-	 *
-	 * If the reference was already released, then the driver beat the
-	 * timeout handler to posting a natural completion.
-	 */
-	if (!refcount_inc_not_zero(&rq->ref))
-		return true;
-
-	/*
-	 * The request is now locked and cannot be reallocated underneath the
-	 * timeout handler's processing. Re-verify this exact request is truly
-	 * expired; if it is not expired, then the request was completed and
-	 * reallocated as a new request.
+	 * blk_mq_queue_tag_busy_iter() has locked the request, so it cannot
+	 * be reallocated underneath the timeout handler's processing, then
+	 * the expire check is reliable. If the request is not expired, then
+	 * it was completed and reallocated as a new request after returning
+	 * from blk_mq_check_expired().
 	 */
 	if (blk_mq_req_expired(rq, next))
 		blk_mq_rq_timed_out(rq, reserved);
-
-	blk_mq_put_rq_ref(rq);
 	return true;
 }
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 8a9d22207c59..86f264fd58a5 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4029,23 +4029,23 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	if (fdc_state[FDC(drive)].rawcmd == 1)
 		fdc_state[FDC(drive)].rawcmd = 2;
 
-	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		drive_state[drive].last_checked = 0;
-		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags);
-		if (bdev_check_media_change(bdev))
-			floppy_revalidate(bdev->bd_disk);
-		if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
-			goto out;
-		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+	if (!(mode & FMODE_NDELAY)) {
+		if (mode & (FMODE_READ|FMODE_WRITE)) {
+			drive_state[drive].last_checked = 0;
+			clear_bit(FD_OPEN_SHOULD_FAIL_BIT,
+				  &drive_state[drive].flags);
+			if (bdev_check_media_change(bdev))
+				floppy_revalidate(bdev->bd_disk);
+			if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
+				goto out;
+			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+				goto out;
+		}
+		res = -EROFS;
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
 			goto out;
 	}
-
-	res = -EROFS;
-
-	if ((mode & FMODE_WRITE) &&
-			!test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
-		goto out;
-
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 6d23308119d1..c6b48160343a 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -516,6 +516,7 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
 #define BTUSB_HW_RESET_ACTIVE	12
 #define BTUSB_TX_WAIT_VND_EVT	13
 #define BTUSB_WAKEUP_DISABLE	14
+#define BTUSB_USE_ALT3_FOR_WBS	15
 
 struct btusb_data {
 	struct hci_dev       *hdev;
@@ -1748,16 +1749,20 @@ static void btusb_work(struct work_struct *work)
 			/* Bluetooth USB spec recommends alt 6 (63 bytes), but
 			 * many adapters do not support it.  Alt 1 appears to
 			 * work for all adapters that do not have alt 6, and
-			 * which work with WBS at all.
+			 * which work with WBS at all.  Some devices prefer
+			 * alt 3 (HCI payload >= 60 Bytes let air packet
+			 * data satisfy 60 bytes), requiring
+			 * MTU >= 3 (packets) * 25 (size) - 3 (headers) = 72
+			 * see also Core spec 5, vol 4, B 2.1.1 & Table 2.1.
 			 */
-			new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
-			/* Because mSBC frames do not need to be aligned to the
-			 * SCO packet boundary. If support the Alt 3, use the
-			 * Alt 3 for HCI payload >= 60 Bytes let air packet
-			 * data satisfy 60 bytes.
-			 */
-			if (new_alts == 1 && btusb_find_altsetting(data, 3))
+			if (btusb_find_altsetting(data, 6))
+				new_alts = 6;
+			else if (btusb_find_altsetting(data, 3) &&
+				 hdev->sco_mtu >= 72 &&
+				 test_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags))
 				new_alts = 3;
+			else
+				new_alts = 1;
 		}
 
 		if (btusb_switch_alt_setting(hdev, new_alts) < 0)
@@ -4733,6 +4738,7 @@ static int btusb_probe(struct usb_interface *intf,
 		 * (DEVICE_REMOTE_WAKEUP)
 		 */
 		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
+		set_bit(BTUSB_USE_ALT3_FOR_WBS, &data->flags);
 	}
 
 	if (!reset)
diff --git a/drivers/clk/renesas/rcar-usb2-clock-sel.c b/drivers/clk/renesas/rcar-usb2-clock-sel.c
index 9fb79bd79435..684d8937965e 100644
--- a/drivers/clk/renesas/rcar-usb2-clock-sel.c
+++ b/drivers/clk/renesas/rcar-usb2-clock-sel.c
@@ -187,7 +187,7 @@ static int rcar_usb2_clock_sel_probe(struct platform_device *pdev)
 	init.ops = &usb2_clock_sel_clock_ops;
 	priv->hw.init = &init;
 
-	ret = devm_clk_hw_register(NULL, &priv->hw);
+	ret = devm_clk_hw_register(dev, &priv->hw);
 	if (ret)
 		goto pm_put;
 
diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index 5e07065ec22f..1f8dc1164ba2 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -138,6 +138,7 @@ static const struct of_device_id blacklist[] __initconst = {
 	{ .compatible = "qcom,qcs404", },
 	{ .compatible = "qcom,sc7180", },
 	{ .compatible = "qcom,sdm845", },
+	{ .compatible = "qcom,sm8150", },
 
 	{ .compatible = "st,stih407", },
 	{ .compatible = "st,stih410", },
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
index b53eab384adb..38d0811e3c75 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acpi.c
@@ -904,7 +904,7 @@ void amdgpu_acpi_fini(struct amdgpu_device *adev)
  */
 bool amdgpu_acpi_is_s0ix_supported(struct amdgpu_device *adev)
 {
-#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_PM_SLEEP)
+#if IS_ENABLED(CONFIG_AMD_PMC) && IS_ENABLED(CONFIG_SUSPEND)
 	if (acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0) {
 		if (adev->flags & AMD_IS_APU)
 			return pm_suspend_target_state == PM_SUSPEND_TO_IDLE;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index cb3ad1395e13..8939e98bf003 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2690,12 +2690,11 @@ static void amdgpu_device_delay_enable_gfx_off(struct work_struct *work)
 	struct amdgpu_device *adev =
 		container_of(work, struct amdgpu_device, gfx.gfx_off_delay_work.work);
 
-	mutex_lock(&adev->gfx.gfx_off_mutex);
-	if (!adev->gfx.gfx_off_state && !adev->gfx.gfx_off_req_count) {
-		if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, true))
-			adev->gfx.gfx_off_state = true;
-	}
-	mutex_unlock(&adev->gfx.gfx_off_mutex);
+	WARN_ON_ONCE(adev->gfx.gfx_off_state);
+	WARN_ON_ONCE(adev->gfx.gfx_off_req_count);
+
+	if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, true))
+		adev->gfx.gfx_off_state = true;
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 95d4f43a03df..571d77ccc9dd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -563,24 +563,38 @@ void amdgpu_gfx_off_ctrl(struct amdgpu_device *adev, bool enable)
 
 	mutex_lock(&adev->gfx.gfx_off_mutex);
 
-	if (!enable)
-		adev->gfx.gfx_off_req_count++;
-	else if (adev->gfx.gfx_off_req_count > 0)
+	if (enable) {
+		/* If the count is already 0, it means there's an imbalance bug somewhere.
+		 * Note that the bug may be in a different caller than the one which triggers the
+		 * WARN_ON_ONCE.
+		 */
+		if (WARN_ON_ONCE(adev->gfx.gfx_off_req_count == 0))
+			goto unlock;
+
 		adev->gfx.gfx_off_req_count--;
 
-	if (enable && !adev->gfx.gfx_off_state && !adev->gfx.gfx_off_req_count) {
-		schedule_delayed_work(&adev->gfx.gfx_off_delay_work, GFX_OFF_DELAY_ENABLE);
-	} else if (!enable && adev->gfx.gfx_off_state) {
-		if (!amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, false)) {
-			adev->gfx.gfx_off_state = false;
+		if (adev->gfx.gfx_off_req_count == 0 && !adev->gfx.gfx_off_state)
+			schedule_delayed_work(&adev->gfx.gfx_off_delay_work, GFX_OFF_DELAY_ENABLE);
+	} else {
+		if (adev->gfx.gfx_off_req_count == 0) {
+			cancel_delayed_work_sync(&adev->gfx.gfx_off_delay_work);
+
+			if (adev->gfx.gfx_off_state &&
+			    !amdgpu_dpm_set_powergating_by_smu(adev, AMD_IP_BLOCK_TYPE_GFX, false)) {
+				adev->gfx.gfx_off_state = false;
 
-			if (adev->gfx.funcs->init_spm_golden) {
-				dev_dbg(adev->dev, "GFXOFF is disabled, re-init SPM golden settings\n");
-				amdgpu_gfx_init_spm_golden(adev);
+				if (adev->gfx.funcs->init_spm_golden) {
+					dev_dbg(adev->dev,
+						"GFXOFF is disabled, re-init SPM golden settings\n");
+					amdgpu_gfx_init_spm_golden(adev);
+				}
 			}
 		}
+
+		adev->gfx.gfx_off_req_count++;
 	}
 
+unlock:
 	mutex_unlock(&adev->gfx.gfx_off_mutex);
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index db00de33caa3..3933a42f8d81 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -937,11 +937,6 @@ int amdgpu_bo_pin_restricted(struct amdgpu_bo *bo, u32 domain,
 			return -EINVAL;
 	}
 
-	/* This assumes only APU display buffers are pinned with (VRAM|GTT).
-	 * See function amdgpu_display_supported_domains()
-	 */
-	domain = amdgpu_bo_get_preferred_pin_domain(adev, domain);
-
 	if (bo->tbo.pin_count) {
 		uint32_t mem_type = bo->tbo.mem.mem_type;
 		uint32_t mem_flags = bo->tbo.mem.placement;
@@ -966,6 +961,11 @@ int amdgpu_bo_pin_restricted(struct amdgpu_bo *bo, u32 domain,
 		return 0;
 	}
 
+	/* This assumes only APU display buffers are pinned with (VRAM|GTT).
+	 * See function amdgpu_display_supported_domains()
+	 */
+	domain = amdgpu_bo_get_preferred_pin_domain(adev, domain);
+
 	if (bo->tbo.base.import_attach)
 		dma_buf_pin(bo->tbo.base.import_attach);
 
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
index 31c61ac3bd5e..cc6f19a48dea 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_hwmgr.c
@@ -5123,6 +5123,13 @@ static int vega10_get_power_profile_mode(struct pp_hwmgr *hwmgr, char *buf)
 	return size;
 }
 
+static bool vega10_get_power_profile_mode_quirks(struct pp_hwmgr *hwmgr)
+{
+	struct amdgpu_device *adev = hwmgr->adev;
+
+	return (adev->pdev->device == 0x6860);
+}
+
 static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, uint32_t size)
 {
 	struct vega10_hwmgr *data = hwmgr->backend;
@@ -5159,9 +5166,15 @@ static int vega10_set_power_profile_mode(struct pp_hwmgr *hwmgr, long *input, ui
 	}
 
 out:
-	smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
+	if (vega10_get_power_profile_mode_quirks(hwmgr))
+		smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
+						1 << power_profile_mode,
+						NULL);
+	else
+		smum_send_msg_to_smc_with_parameter(hwmgr, PPSMC_MSG_SetWorkloadMask,
 						(!power_profile_mode) ? 0 : 1 << (power_profile_mode - 1),
 						NULL);
+
 	hwmgr->power_profile_mode = power_profile_mode;
 
 	return 0;
diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index 33390f02f5eb..e41d3a69a02a 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -856,8 +856,6 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	req.request.sequence = req32.request.sequence;
 	req.request.signal = req32.request.signal;
 	err = drm_ioctl_kernel(file, drm_wait_vblank_ioctl, &req, DRM_UNLOCKED);
-	if (err)
-		return err;
 
 	req32.reply.type = req.reply.type;
 	req32.reply.sequence = req.reply.sequence;
@@ -866,7 +864,7 @@ static int compat_drm_wait_vblank(struct file *file, unsigned int cmd,
 	if (copy_to_user(argp, &req32, sizeof(req32)))
 		return -EFAULT;
 
-	return 0;
+	return err;
 }
 
 #if defined(CONFIG_X86)
diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 005510f309cf..ddee6d4f07cf 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -3833,23 +3833,18 @@ static void intel_dp_check_device_service_irq(struct intel_dp *intel_dp)
 
 static void intel_dp_check_link_service_irq(struct intel_dp *intel_dp)
 {
-	struct drm_i915_private *i915 = dp_to_i915(intel_dp);
 	u8 val;
 
 	if (intel_dp->dpcd[DP_DPCD_REV] < 0x11)
 		return;
 
 	if (drm_dp_dpcd_readb(&intel_dp->aux,
-			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val) {
-		drm_dbg_kms(&i915->drm, "Error in reading link service irq vector\n");
+			      DP_LINK_SERVICE_IRQ_VECTOR_ESI0, &val) != 1 || !val)
 		return;
-	}
 
 	if (drm_dp_dpcd_writeb(&intel_dp->aux,
-			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1) {
-		drm_dbg_kms(&i915->drm, "Error in writing link service irq vector\n");
+			       DP_LINK_SERVICE_IRQ_VECTOR_ESI0, val) != 1)
 		return;
-	}
 
 	if (val & HDMI_LINK_STATUS_CHANGED)
 		intel_dp_handle_hdmi_link_status_change(intel_dp);
diff --git a/drivers/gpu/drm/i915/gt/intel_timeline.c b/drivers/gpu/drm/i915/gt/intel_timeline.c
index f19cf6d2fa85..feb1a76c639f 100644
--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -127,6 +127,15 @@ static void intel_timeline_fini(struct rcu_head *rcu)
 
 	i915_vma_put(timeline->hwsp_ggtt);
 	i915_active_fini(&timeline->active);
+
+	/*
+	 * A small race exists between intel_gt_retire_requests_timeout and
+	 * intel_timeline_exit which could result in the syncmap not getting
+	 * free'd. Rather than work to hard to seal this race, simply cleanup
+	 * the syncmap on fini.
+	 */
+	i915_syncmap_free(&timeline->sync);
+
 	kfree(timeline);
 }
 
diff --git a/drivers/gpu/drm/nouveau/dispnv50/disp.c b/drivers/gpu/drm/nouveau/dispnv50/disp.c
index 1c9c0cdf85db..578aaac2e277 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/disp.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/disp.c
@@ -2235,6 +2235,33 @@ nv50_disp_atomic_commit_tail(struct drm_atomic_state *state)
 		interlock[NV50_DISP_INTERLOCK_CORE] = 0;
 	}
 
+	/* Finish updating head(s)...
+	 *
+	 * NVD is rather picky about both where window assignments can change,
+	 * *and* about certain core and window channel states matching.
+	 *
+	 * The EFI GOP driver on newer GPUs configures window channels with a
+	 * different output format to what we do, and the core channel update
+	 * in the assign_windows case above would result in a state mismatch.
+	 *
+	 * Delay some of the head update until after that point to workaround
+	 * the issue.  This only affects the initial modeset.
+	 *
+	 * TODO: handle this better when adding flexible window mapping
+	 */
+	for_each_oldnew_crtc_in_state(state, crtc, old_crtc_state, new_crtc_state, i) {
+		struct nv50_head_atom *asyh = nv50_head_atom(new_crtc_state);
+		struct nv50_head *head = nv50_head(crtc);
+
+		NV_ATOMIC(drm, "%s: set %04x (clr %04x)\n", crtc->name,
+			  asyh->set.mask, asyh->clr.mask);
+
+		if (asyh->set.mask) {
+			nv50_head_flush_set_wndw(head, asyh);
+			interlock[NV50_DISP_INTERLOCK_CORE] = 1;
+		}
+	}
+
 	/* Update plane(s). */
 	for_each_new_plane_in_state(state, plane, new_plane_state, i) {
 		struct nv50_wndw_atom *asyw = nv50_wndw_atom(new_plane_state);
diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.c b/drivers/gpu/drm/nouveau/dispnv50/head.c
index ec361d17e900..d66f97280282 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.c
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.c
@@ -50,11 +50,8 @@ nv50_head_flush_clr(struct nv50_head *head,
 }
 
 void
-nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
+nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom *asyh)
 {
-	if (asyh->set.view   ) head->func->view    (head, asyh);
-	if (asyh->set.mode   ) head->func->mode    (head, asyh);
-	if (asyh->set.core   ) head->func->core_set(head, asyh);
 	if (asyh->set.olut   ) {
 		asyh->olut.offset = nv50_lut_load(&head->olut,
 						  asyh->olut.buffer,
@@ -62,6 +59,14 @@ nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
 						  asyh->olut.load);
 		head->func->olut_set(head, asyh);
 	}
+}
+
+void
+nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh)
+{
+	if (asyh->set.view   ) head->func->view    (head, asyh);
+	if (asyh->set.mode   ) head->func->mode    (head, asyh);
+	if (asyh->set.core   ) head->func->core_set(head, asyh);
 	if (asyh->set.curs   ) head->func->curs_set(head, asyh);
 	if (asyh->set.base   ) head->func->base    (head, asyh);
 	if (asyh->set.ovly   ) head->func->ovly    (head, asyh);
diff --git a/drivers/gpu/drm/nouveau/dispnv50/head.h b/drivers/gpu/drm/nouveau/dispnv50/head.h
index dae841dc05fd..0bac6be9ba34 100644
--- a/drivers/gpu/drm/nouveau/dispnv50/head.h
+++ b/drivers/gpu/drm/nouveau/dispnv50/head.h
@@ -21,6 +21,7 @@ struct nv50_head {
 
 struct nv50_head *nv50_head_create(struct drm_device *, int index);
 void nv50_head_flush_set(struct nv50_head *head, struct nv50_head_atom *asyh);
+void nv50_head_flush_set_wndw(struct nv50_head *head, struct nv50_head_atom *asyh);
 void nv50_head_flush_clr(struct nv50_head *head,
 			 struct nv50_head_atom *asyh, bool flush);
 
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
index b930f539feec..93ddf63d1114 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/device/base.c
@@ -2624,6 +2624,26 @@ nv174_chipset = {
 	.dma      = { 0x00000001, gv100_dma_new },
 };
 
+static const struct nvkm_device_chip
+nv177_chipset = {
+	.name = "GA107",
+	.bar      = { 0x00000001, tu102_bar_new },
+	.bios     = { 0x00000001, nvkm_bios_new },
+	.devinit  = { 0x00000001, ga100_devinit_new },
+	.fb       = { 0x00000001, ga102_fb_new },
+	.gpio     = { 0x00000001, ga102_gpio_new },
+	.i2c      = { 0x00000001, gm200_i2c_new },
+	.imem     = { 0x00000001, nv50_instmem_new },
+	.mc       = { 0x00000001, ga100_mc_new },
+	.mmu      = { 0x00000001, tu102_mmu_new },
+	.pci      = { 0x00000001, gp100_pci_new },
+	.privring = { 0x00000001, gm200_privring_new },
+	.timer    = { 0x00000001, gk20a_timer_new },
+	.top      = { 0x00000001, ga100_top_new },
+	.disp     = { 0x00000001, ga102_disp_new },
+	.dma      = { 0x00000001, gv100_dma_new },
+};
+
 static int
 nvkm_device_event_ctor(struct nvkm_object *object, void *data, u32 size,
 		       struct nvkm_notify *notify)
@@ -3049,6 +3069,7 @@ nvkm_device_ctor(const struct nvkm_device_func *func,
 		case 0x168: device->chip = &nv168_chipset; break;
 		case 0x172: device->chip = &nv172_chipset; break;
 		case 0x174: device->chip = &nv174_chipset; break;
+		case 0x177: device->chip = &nv177_chipset; break;
 		default:
 			if (nvkm_boolopt(device->cfgopt, "NvEnableUnsupportedChipsets", false)) {
 				switch (device->chipset) {
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
index 55fbfe28c6dc..9669472a2749 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.c
@@ -440,7 +440,7 @@ nvkm_dp_train(struct nvkm_dp *dp, u32 dataKBps)
 	return ret;
 }
 
-static void
+void
 nvkm_dp_disable(struct nvkm_outp *outp, struct nvkm_ior *ior)
 {
 	struct nvkm_dp *dp = nvkm_dp(outp);
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
index 428b3f488f03..e484d0c3b0d4 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/dp.h
@@ -32,6 +32,7 @@ struct nvkm_dp {
 
 int nvkm_dp_new(struct nvkm_disp *, int index, struct dcb_output *,
 		struct nvkm_outp **);
+void nvkm_dp_disable(struct nvkm_outp *, struct nvkm_ior *);
 
 /* DPCD Receiver Capabilities */
 #define DPCD_RC00_DPCD_REV                                              0x00000
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c b/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
index dffcac249211..129982fef7ef 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/outp.c
@@ -22,6 +22,7 @@
  * Authors: Ben Skeggs
  */
 #include "outp.h"
+#include "dp.h"
 #include "ior.h"
 
 #include <subdev/bios.h>
@@ -257,6 +258,14 @@ nvkm_outp_init_route(struct nvkm_outp *outp)
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
 
diff --git a/drivers/infiniband/core/uverbs_std_types_mr.c b/drivers/infiniband/core/uverbs_std_types_mr.c
index f782d5e1aa25..03e1db5d1e8c 100644
--- a/drivers/infiniband/core/uverbs_std_types_mr.c
+++ b/drivers/infiniband/core/uverbs_std_types_mr.c
@@ -249,6 +249,9 @@ static int UVERBS_HANDLER(UVERBS_METHOD_REG_DMABUF_MR)(
 	mr->uobject = uobj;
 	atomic_inc(&pd->usecnt);
 
+	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
+	rdma_restrack_set_name(&mr->res, NULL);
+	rdma_restrack_add(&mr->res);
 	uobj->object = mr;
 
 	uverbs_finalize_uobj_create(attrs, UVERBS_ATTR_REG_DMABUF_MR_HANDLE);
diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 2efaa80bfbd2..9d79005befd6 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1691,6 +1691,7 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	if (nq)
 		nq->budget++;
 	atomic_inc(&rdev->srq_count);
+	spin_lock_init(&srq->lock);
 
 	return 0;
 
diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 25550d982238..8097a8d8a49f 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1406,7 +1406,6 @@ static int bnxt_re_dev_init(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	memset(&rattr, 0, sizeof(rattr));
 	rc = bnxt_re_register_netdev(rdev);
 	if (rc) {
-		rtnl_unlock();
 		ibdev_err(&rdev->ibdev,
 			  "Failed to register with netedev: %#x\n", rc);
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/efa/efa_main.c b/drivers/infiniband/hw/efa/efa_main.c
index 816cfd65b7ac..0b61ef0d5983 100644
--- a/drivers/infiniband/hw/efa/efa_main.c
+++ b/drivers/infiniband/hw/efa/efa_main.c
@@ -356,6 +356,7 @@ static int efa_enable_msix(struct efa_dev *dev)
 	}
 
 	if (irq_num != msix_vecs) {
+		efa_disable_msix(dev);
 		dev_err(&dev->pdev->dev,
 			"Allocated %d MSI-X (out of %d requested)\n",
 			irq_num, msix_vecs);
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index 1fcc6e9666e0..8e902b83ce26 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3055,6 +3055,7 @@ static void __sdma_process_event(struct sdma_engine *sde,
 static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int i;
+	struct sdma_desc *descp;
 
 	/* Handle last descriptor */
 	if (unlikely((tx->num_desc == (MAX_DESC - 1)))) {
@@ -3075,12 +3076,10 @@ static int _extend_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
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
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index cca7296b12d0..9bb562c7cd24 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4444,7 +4444,8 @@ static void mlx5r_mp_remove(struct auxiliary_device *adev)
 	mutex_lock(&mlx5_ib_multiport_mutex);
 	if (mpi->ibdev)
 		mlx5_ib_unbind_slave_port(mpi->ibdev, mpi);
-	list_del(&mpi->list);
+	else
+		list_del(&mpi->list);
 	mutex_unlock(&mlx5_ib_multiport_mutex);
 	kfree(mpi);
 }
diff --git a/drivers/infiniband/sw/rxe/rxe_mcast.c b/drivers/infiniband/sw/rxe/rxe_mcast.c
index 0ea9a5aa4ec0..1c1d1b53312d 100644
--- a/drivers/infiniband/sw/rxe/rxe_mcast.c
+++ b/drivers/infiniband/sw/rxe/rxe_mcast.c
@@ -85,7 +85,7 @@ int rxe_mcast_add_grp_elem(struct rxe_dev *rxe, struct rxe_qp *qp,
 		goto out;
 	}
 
-	elem = rxe_alloc(&rxe->mc_elem_pool);
+	elem = rxe_alloc_locked(&rxe->mc_elem_pool);
 	if (!elem) {
 		err = -ENOMEM;
 		goto out;
diff --git a/drivers/media/pci/intel/ipu3/cio2-bridge.c b/drivers/media/pci/intel/ipu3/cio2-bridge.c
index 59a36f922675..30d29b96a339 100644
--- a/drivers/media/pci/intel/ipu3/cio2-bridge.c
+++ b/drivers/media/pci/intel/ipu3/cio2-bridge.c
@@ -226,7 +226,7 @@ static int cio2_bridge_connect_sensor(const struct cio2_sensor_config *cfg,
 err_free_swnodes:
 	software_node_unregister_nodes(sensor->swnodes);
 err_put_adev:
-	acpi_dev_put(sensor->adev);
+	acpi_dev_put(adev);
 	return ret;
 }
 
diff --git a/drivers/mmc/host/sdhci-iproc.c b/drivers/mmc/host/sdhci-iproc.c
index 9f0eef97ebdd..b9eb2ec61a83 100644
--- a/drivers/mmc/host/sdhci-iproc.c
+++ b/drivers/mmc/host/sdhci-iproc.c
@@ -295,8 +295,7 @@ static const struct sdhci_ops sdhci_iproc_bcm2711_ops = {
 };
 
 static const struct sdhci_pltfm_data sdhci_bcm2711_pltfm_data = {
-	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12 |
-		  SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
+	.quirks = SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12,
 	.ops = &sdhci_iproc_bcm2711_ops,
 };
 
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 66fa8b07c2e6..95ae740fc311 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -224,8 +224,8 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 	if (id == ESD_EV_CAN_ERROR_EXT) {
 		u8 state = msg->msg.rx.data[0];
 		u8 ecc = msg->msg.rx.data[1];
-		u8 txerr = msg->msg.rx.data[2];
-		u8 rxerr = msg->msg.rx.data[3];
+		u8 rxerr = msg->msg.rx.data[2];
+		u8 txerr = msg->msg.rx.data[3];
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
 		if (skb == NULL) {
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 50109218baad..512b1810a8bd 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1473,9 +1473,6 @@ static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 		u16 data;
 		u8 gates;
 
-		cur++;
-		next++;
-
 		if (i == schedule->num_entries)
 			gates = initial->gate_mask ^
 				cur->gate_mask;
@@ -1504,6 +1501,9 @@ static void hellcreek_setup_gcl(struct hellcreek *hellcreek, int port,
 			(initial->gate_mask <<
 			 TR_GCLCMD_INIT_GATE_STATES_SHIFT);
 		hellcreek_write(hellcreek, data, TR_GCLCMD);
+
+		cur++;
+		next++;
 	}
 }
 
@@ -1551,7 +1551,7 @@ static bool hellcreek_schedule_startable(struct hellcreek *hellcreek, int port)
 	/* Calculate difference to admin base time */
 	base_time_ns = ktime_to_ns(hellcreek_port->current_schedule->base_time);
 
-	return base_time_ns - current_ns < (s64)8 * NSEC_PER_SEC;
+	return base_time_ns - current_ns < (s64)4 * NSEC_PER_SEC;
 }
 
 static void hellcreek_start_schedule(struct hellcreek *hellcreek, int port)
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 167c599a81a5..2b01efad1a51 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1295,11 +1295,8 @@ mt7530_port_bridge_leave(struct dsa_switch *ds, int port,
 		/* Remove this port from the port matrix of the other ports
 		 * in the same bridge. If the port is disabled, port matrix
 		 * is kept and not being setup until the port becomes enabled.
-		 * And the other port's port matrix cannot be broken when the
-		 * other port is still a VLAN-aware port.
 		 */
-		if (dsa_is_user_port(ds, i) && i != port &&
-		   !dsa_port_is_vlan_filtering(dsa_to_port(ds, i))) {
+		if (dsa_is_user_port(ds, i) && i != port) {
 			if (dsa_to_port(ds, i)->bridge_dev != bridge)
 				continue;
 			if (priv->ports[i].enable)
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 860c18fb7aae..80399c8980bd 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -677,11 +677,13 @@ static int xge_probe(struct platform_device *pdev)
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
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9f62ffe64781..920046717638 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5068,6 +5068,7 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 		ret = -ENOMEM;
 		goto bye;
 	}
+	bitmap_zero(adap->sge.blocked_fl, adap->sge.egr_sz);
 #endif
 
 	params[0] = FW_PARAM_PFVF(CLIP_START);
@@ -6788,13 +6789,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	setup_memwin(adapter);
 	err = adap_init0(adapter, 0);
-#ifdef CONFIG_DEBUG_FS
-	bitmap_zero(adapter->sge.blocked_fl, adapter->sge.egr_sz);
-#endif
-	setup_memwin_rdma(adapter);
 	if (err)
 		goto out_unmap_bar;
 
+	setup_memwin_rdma(adapter);
+
 	/* configure SGE_STAT_CFG_A to read WC stats */
 	if (!is_t4(adapter->params.chip))
 		t4_write_reg(adapter, SGE_STAT_CFG_A, STATSOURCE_T5_V(7) |
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 76a482456f1f..91445521dde1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -564,9 +564,13 @@ static void hclge_cmd_uninit_regs(struct hclge_hw *hw)
 
 void hclge_cmd_uninit(struct hclge_dev *hdev)
 {
+	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
+	/* wait to ensure that the firmware completes the possible left
+	 * over commands.
+	 */
+	msleep(HCLGE_CMDQ_CLEAR_WAIT_TIME);
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
 	spin_lock(&hdev->hw.cmq.crq.lock);
-	set_bit(HCLGE_STATE_CMD_DISABLE, &hdev->state);
 	hclge_cmd_uninit_regs(&hdev->hw);
 	spin_unlock(&hdev->hw.cmq.crq.lock);
 	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index c6fc22e29581..a836bdba5a4d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -9,6 +9,7 @@
 #include "hnae3.h"
 
 #define HCLGE_CMDQ_TX_TIMEOUT		30000
+#define HCLGE_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGE_DESC_DATA_LEN		6
 
 struct hclge_dev;
@@ -264,6 +265,9 @@ enum hclge_opcode_type {
 	/* Led command */
 	HCLGE_OPC_LED_STATUS_CFG	= 0xB000,
 
+	/* clear hardware resource command */
+	HCLGE_OPC_CLEAR_HW_RESOURCE	= 0x700B,
+
 	/* NCL config command */
 	HCLGE_OPC_QUERY_NCL_CONFIG	= 0x7011,
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 5bf5db91d16c..39f56f245d84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -255,21 +255,12 @@ static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	u64 requests[HNAE3_MAX_TC], indications[HNAE3_MAX_TC];
 	struct hclge_vport *vport = hclge_get_vport(h);
 	struct hclge_dev *hdev = vport->back;
-	u8 i, j, pfc_map, *prio_tc;
 	int ret;
+	u8 i;
 
 	memset(pfc, 0, sizeof(*pfc));
 	pfc->pfc_cap = hdev->pfc_max;
-	prio_tc = hdev->tm_info.prio_tc;
-	pfc_map = hdev->tm_info.hw_pfc_map;
-
-	/* Pfc setting is based on TC */
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
-		for (j = 0; j < HNAE3_MAX_USER_PRIO; j++) {
-			if ((prio_tc[j] == i) && (pfc_map & BIT(i)))
-				pfc->pfc_en |= BIT(j);
-		}
-	}
+	pfc->pfc_en = hdev->tm_info.pfc_en;
 
 	ret = hclge_pfc_tx_stats_get(hdev, requests);
 	if (ret)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 6304aed49f22..f105ff9e3f4c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2924,12 +2924,12 @@ static void hclge_update_link_status(struct hclge_dev *hdev)
 	}
 
 	if (state != hdev->hw.mac.link) {
+		hdev->hw.mac.link = state;
 		client->ops->link_status_change(handle, state);
 		hclge_config_mac_tnl_int(hdev, state);
 		if (rclient && rclient->ops->link_status_change)
 			rclient->ops->link_status_change(rhandle, state);
 
-		hdev->hw.mac.link = state;
 		hclge_push_link_status(hdev);
 	}
 
@@ -9869,7 +9869,11 @@ static int hclge_init_vlan_config(struct hclge_dev *hdev)
 static void hclge_add_vport_vlan_table(struct hclge_vport *vport, u16 vlan_id,
 				       bool writen_to_tbl)
 {
-	struct hclge_vport_vlan_cfg *vlan;
+	struct hclge_vport_vlan_cfg *vlan, *tmp;
+
+	list_for_each_entry_safe(vlan, tmp, &vport->vlan_list, node)
+		if (vlan->vlan_id == vlan_id)
+			return;
 
 	vlan = kzalloc(sizeof(*vlan), GFP_KERNEL);
 	if (!vlan)
@@ -11167,6 +11171,28 @@ static void hclge_clear_resetting_state(struct hclge_dev *hdev)
 	}
 }
 
+static int hclge_clear_hw_resource(struct hclge_dev *hdev)
+{
+	struct hclge_desc desc;
+	int ret;
+
+	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_CLEAR_HW_RESOURCE, false);
+
+	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
+	/* This new command is only supported by new firmware, it will
+	 * fail with older firmware. Error value -EOPNOSUPP can only be
+	 * returned by older firmware running this command, to keep code
+	 * backward compatible we will override this value and return
+	 * success.
+	 */
+	if (ret && ret != -EOPNOTSUPP) {
+		dev_err(&hdev->pdev->dev,
+			"failed to clear hw resource, ret = %d\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
 static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 {
 	struct pci_dev *pdev = ae_dev->pdev;
@@ -11204,6 +11230,10 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_cmd_uninit;
 
+	ret  = hclge_clear_hw_resource(hdev);
+	if (ret)
+		goto err_cmd_uninit;
+
 	ret = hclge_get_cap(hdev);
 	if (ret)
 		goto err_cmd_uninit;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
index d8c5c5810b99..2267832037d8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.c
@@ -505,12 +505,17 @@ static void hclgevf_cmd_uninit_regs(struct hclgevf_hw *hw)
 
 void hclgevf_cmd_uninit(struct hclgevf_dev *hdev)
 {
+	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
+	/* wait to ensure that the firmware completes the possible left
+	 * over commands.
+	 */
+	msleep(HCLGEVF_CMDQ_CLEAR_WAIT_TIME);
 	spin_lock_bh(&hdev->hw.cmq.csq.lock);
 	spin_lock(&hdev->hw.cmq.crq.lock);
-	set_bit(HCLGEVF_STATE_CMD_DISABLE, &hdev->state);
 	hclgevf_cmd_uninit_regs(&hdev->hw);
 	spin_unlock(&hdev->hw.cmq.crq.lock);
 	spin_unlock_bh(&hdev->hw.cmq.csq.lock);
+
 	hclgevf_free_cmd_desc(&hdev->hw.cmq.csq);
 	hclgevf_free_cmd_desc(&hdev->hw.cmq.crq);
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
index c6dc11b32aa7..59f4c19bd846 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_cmd.h
@@ -8,6 +8,7 @@
 #include "hnae3.h"
 
 #define HCLGEVF_CMDQ_TX_TIMEOUT		30000
+#define HCLGEVF_CMDQ_CLEAR_WAIT_TIME	200
 #define HCLGEVF_CMDQ_RX_INVLD_B		0
 #define HCLGEVF_CMDQ_RX_OUTVLD_B	1
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index fe03c8419890..d3f36e2b2b90 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -498,10 +498,10 @@ void hclgevf_update_link_status(struct hclgevf_dev *hdev, int link_state)
 	link_state =
 		test_bit(HCLGEVF_STATE_DOWN, &hdev->state) ? 0 : link_state;
 	if (link_state != hdev->hw.mac.link) {
+		hdev->hw.mac.link = link_state;
 		client->ops->link_status_change(handle, !!link_state);
 		if (rclient && rclient->ops->link_status_change)
 			rclient->ops->link_status_change(rhandle, !!link_state);
-		hdev->hw.mac.link = link_state;
 	}
 
 	clear_bit(HCLGEVF_STATE_LINK_UPDATING, &hdev->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
index 9b17735b9f4c..987b88d7e0c7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_mbx.c
@@ -304,8 +304,8 @@ void hclgevf_mbx_async_handler(struct hclgevf_dev *hdev)
 			flag = (u8)msg_q[5];
 
 			/* update upper layer with new link link status */
-			hclgevf_update_link_status(hdev, link_status);
 			hclgevf_update_speed_duplex(hdev, speed, duplex);
+			hclgevf_update_link_status(hdev, link_status);
 
 			if (flag & HCLGE_MBX_PUSH_LINK_STATUS_EN)
 				set_bit(HCLGEVF_STATE_PF_PUSH_LINK_STATUS,
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 590ad110d383..c6ec669aa7bd 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -1006,6 +1006,8 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
 {
 	u32 reg = link << (E1000_LTRV_REQ_SHIFT + E1000_LTRV_NOSNOOP_SHIFT) |
 	    link << E1000_LTRV_REQ_SHIFT | E1000_LTRV_SEND;
+	u16 max_ltr_enc_d = 0;	/* maximum LTR decoded by platform */
+	u16 lat_enc_d = 0;	/* latency decoded */
 	u16 lat_enc = 0;	/* latency encoded */
 
 	if (link) {
@@ -1059,7 +1061,17 @@ static s32 e1000_platform_pm_pch_lpt(struct e1000_hw *hw, bool link)
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
 
@@ -4115,13 +4127,17 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 		return ret_val;
 
 	if (!(data & valid_csum_mask)) {
-		data |= valid_csum_mask;
-		ret_val = e1000_write_nvm(hw, word, 1, &data);
-		if (ret_val)
-			return ret_val;
-		ret_val = e1000e_update_nvm_checksum(hw);
-		if (ret_val)
-			return ret_val;
+		e_dbg("NVM Checksum Invalid\n");
+
+		if (hw->mac.type < e1000_pch_cnp) {
+			data |= valid_csum_mask;
+			ret_val = e1000_write_nvm(hw, word, 1, &data);
+			if (ret_val)
+				return ret_val;
+			ret_val = e1000e_update_nvm_checksum(hw);
+			if (ret_val)
+				return ret_val;
+		}
 	}
 
 	return e1000e_validate_nvm_checksum_generic(hw);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 1502895eb45d..e757896287eb 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -274,8 +274,11 @@
 
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
diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
index cf685eeea198..e256f70cf59d 100644
--- a/drivers/net/ethernet/intel/ice/ice_devlink.c
+++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
@@ -42,7 +42,9 @@ static int ice_info_pba(struct ice_pf *pf, struct ice_info_ctx *ctx)
 
 	status = ice_read_pba_string(hw, (u8 *)ctx->buf, sizeof(ctx->buf));
 	if (status)
-		return -EIO;
+		/* We failed to locate the PBA, so just skip this entry */
+		dev_dbg(ice_pf_to_dev(pf), "Failed to read Product Board Assembly string, status %s\n",
+			ice_stat_str(status));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a8d5f196fdbd..9b85fdf01297 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -146,6 +146,9 @@ static void igc_release_hw_control(struct igc_adapter *adapter)
 	struct igc_hw *hw = &adapter->hw;
 	u32 ctrl_ext;
 
+	if (!pci_device_is_present(adapter->pdev))
+		return;
+
 	/* Let firmware take over control of h/w */
 	ctrl_ext = rd32(IGC_CTRL_EXT);
 	wr32(IGC_CTRL_EXT,
@@ -4037,26 +4040,29 @@ void igc_down(struct igc_adapter *adapter)
 
 	igc_ptp_suspend(adapter);
 
-	/* disable receives in the hardware */
-	rctl = rd32(IGC_RCTL);
-	wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
-	/* flush and sleep below */
-
+	if (pci_device_is_present(adapter->pdev)) {
+		/* disable receives in the hardware */
+		rctl = rd32(IGC_RCTL);
+		wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
+		/* flush and sleep below */
+	}
 	/* set trans_start so we don't get spurious watchdogs during reset */
 	netif_trans_update(netdev);
 
 	netif_carrier_off(netdev);
 	netif_tx_stop_all_queues(netdev);
 
-	/* disable transmits in the hardware */
-	tctl = rd32(IGC_TCTL);
-	tctl &= ~IGC_TCTL_EN;
-	wr32(IGC_TCTL, tctl);
-	/* flush both disables and wait for them to finish */
-	wrfl();
-	usleep_range(10000, 20000);
+	if (pci_device_is_present(adapter->pdev)) {
+		/* disable transmits in the hardware */
+		tctl = rd32(IGC_TCTL);
+		tctl &= ~IGC_TCTL_EN;
+		wr32(IGC_TCTL, tctl);
+		/* flush both disables and wait for them to finish */
+		wrfl();
+		usleep_range(10000, 20000);
 
-	igc_irq_disable(adapter);
+		igc_irq_disable(adapter);
+	}
 
 	adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 
@@ -5074,7 +5080,7 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < IGC_MAX_TX_QUEUES; i++) {
+		for (i = 0; i < adapter->num_tx_queues; i++) {
 			if (e->gate_mask & BIT(i))
 				queue_uses[i]++;
 
@@ -5131,7 +5137,7 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 
 		end_time += e->interval;
 
-		for (i = 0; i < IGC_MAX_TX_QUEUES; i++) {
+		for (i = 0; i < adapter->num_tx_queues; i++) {
 			struct igc_ring *ring = adapter->tx_ring[i];
 
 			if (!(e->gate_mask & BIT(i)))
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 69617d2c1be2..4ae19c6a3247 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -849,7 +849,8 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	adapter->ptp_tx_skb = NULL;
 	clear_bit_unlock(__IGC_PTP_TX_IN_PROGRESS, &adapter->state);
 
-	igc_ptp_time_save(adapter);
+	if (pci_device_is_present(adapter->pdev))
+		igc_ptp_time_save(adapter);
 }
 
 /**
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 618623014180..76c680515764 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -105,7 +105,7 @@
 #define	MVNETA_VLAN_PRIO_TO_RXQ			 0x2440
 #define      MVNETA_VLAN_PRIO_RXQ_MAP(prio, rxq) ((rxq) << ((prio) * 3))
 #define MVNETA_PORT_STATUS                       0x2444
-#define      MVNETA_TX_IN_PRGRS                  BIT(1)
+#define      MVNETA_TX_IN_PRGRS                  BIT(0)
 #define      MVNETA_TX_FIFO_EMPTY                BIT(8)
 #define MVNETA_RX_MIN_FRAME_SIZE                 0x247c
 /* Only exists on Armada XP and Armada 370 */
diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index ea4e83410fe4..7390fa3980ec 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -21,7 +21,7 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
 		    ocelot->map[target][reg & REG_MASK] + offset, &val);
 	return val;
 }
-EXPORT_SYMBOL(__ocelot_read_ix);
+EXPORT_SYMBOL_GPL(__ocelot_read_ix);
 
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
 {
@@ -32,7 +32,7 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
 	regmap_write(ocelot->targets[target],
 		     ocelot->map[target][reg & REG_MASK] + offset, val);
 }
-EXPORT_SYMBOL(__ocelot_write_ix);
+EXPORT_SYMBOL_GPL(__ocelot_write_ix);
 
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 		     u32 offset)
@@ -45,7 +45,7 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 			   ocelot->map[target][reg & REG_MASK] + offset,
 			   mask, val);
 }
-EXPORT_SYMBOL(__ocelot_rmw_ix);
+EXPORT_SYMBOL_GPL(__ocelot_rmw_ix);
 
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
 {
@@ -58,7 +58,7 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
 	regmap_read(port->target, ocelot->map[target][reg & REG_MASK], &val);
 	return val;
 }
-EXPORT_SYMBOL(ocelot_port_readl);
+EXPORT_SYMBOL_GPL(ocelot_port_readl);
 
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 {
@@ -69,7 +69,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 
 	regmap_write(port->target, ocelot->map[target][reg & REG_MASK], val);
 }
-EXPORT_SYMBOL(ocelot_port_writel);
+EXPORT_SYMBOL_GPL(ocelot_port_writel);
 
 void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
 {
@@ -77,7 +77,7 @@ void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
 
 	ocelot_port_writel(port, (cur & (~mask)) | val, reg);
 }
-EXPORT_SYMBOL(ocelot_port_rmwl);
+EXPORT_SYMBOL_GPL(ocelot_port_rmwl);
 
 u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 			    u32 reg, u32 offset)
@@ -128,7 +128,7 @@ int ocelot_regfields_init(struct ocelot *ocelot,
 
 	return 0;
 }
-EXPORT_SYMBOL(ocelot_regfields_init);
+EXPORT_SYMBOL_GPL(ocelot_regfields_init);
 
 static struct regmap_config ocelot_regmap_config = {
 	.reg_bits	= 32,
@@ -148,4 +148,4 @@ struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res)
 
 	return devm_regmap_init_mmio(ocelot->dev, regs, &ocelot_regmap_config);
 }
-EXPORT_SYMBOL(ocelot_regmap_init);
+EXPORT_SYMBOL_GPL(ocelot_regmap_init);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_ll2.c b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
index 49783f365079..f2c8273dce67 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_ll2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_ll2.c
@@ -327,6 +327,9 @@ static int qed_ll2_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	unsigned long flags;
 	int rc = -EINVAL;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_tx->lock, flags);
 	if (p_tx->b_completing_packet) {
 		rc = -EBUSY;
@@ -500,7 +503,16 @@ static int qed_ll2_rxq_completion(struct qed_hwfn *p_hwfn, void *cookie)
 	unsigned long flags = 0;
 	int rc = 0;
 
+	if (!p_ll2_conn)
+		return rc;
+
 	spin_lock_irqsave(&p_rx->lock, flags);
+
+	if (!QED_LL2_RX_REGISTERED(p_ll2_conn)) {
+		spin_unlock_irqrestore(&p_rx->lock, flags);
+		return 0;
+	}
+
 	cq_new_idx = le16_to_cpu(*p_rx->p_fw_cons);
 	cq_old_idx = qed_chain_get_cons_idx(&p_rx->rcq_chain);
 
@@ -821,6 +833,9 @@ static int qed_ll2_lb_rxq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	struct qed_ll2_info *p_ll2_conn = (struct qed_ll2_info *)p_cookie;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_RX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -844,6 +859,9 @@ static int qed_ll2_lb_txq_completion(struct qed_hwfn *p_hwfn, void *p_cookie)
 	u16 new_idx = 0, num_bds = 0;
 	int rc;
 
+	if (!p_ll2_conn)
+		return 0;
+
 	if (!QED_LL2_TX_REGISTERED(p_ll2_conn))
 		return 0;
 
@@ -1725,6 +1743,8 @@ int qed_ll2_post_rx_buffer(void *cxt,
 	if (!p_ll2_conn)
 		return -EINVAL;
 	p_rx = &p_ll2_conn->rx_queue;
+	if (!p_rx->set_prod_addr)
+		return -EIO;
 
 	spin_lock_irqsave(&p_rx->lock, flags);
 	if (!list_empty(&p_rx->free_descq))
diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
index da864d12916b..4f4b79250a2b 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
@@ -1285,8 +1285,7 @@ qed_rdma_create_qp(void *rdma_cxt,
 
 	if (!rdma_cxt || !in_params || !out_params ||
 	    !p_hwfn->p_rdma_info->active) {
-		DP_ERR(p_hwfn->cdev,
-		       "qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
+		pr_err("qed roce create qp failed due to NULL entry (rdma_cxt=%p, in=%p, out=%p, roce_info=?\n",
 		       rdma_cxt, in_params, out_params);
 		return NULL;
 	}
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 980a60477b02..a5285a8a9eae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4925,6 +4925,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 		prefetch(np);
 
+		/* Ensure a valid XSK buffer before proceed */
+		if (!buf->xdp)
+			break;
+
 		if (priv->extend_desc)
 			stmmac_rx_extended_status(priv, &priv->dev->stats,
 						  &priv->xstats,
@@ -4945,10 +4949,6 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			continue;
 		}
 
-		/* Ensure a valid XSK buffer before proceed */
-		if (!buf->xdp)
-			break;
-
 		/* XSK pool expects RX frame 1:1 mapped to XSK buffer */
 		if (likely(status & rx_not_ls)) {
 			xsk_buff_free(buf->xdp);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 4e70efc45458..c7554db2962f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -775,14 +775,18 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 					 GFP_KERNEL);
 		if (!plat->est)
 			return -ENOMEM;
+
+		mutex_init(&priv->plat->est->lock);
 	} else {
 		memset(plat->est, 0, sizeof(*plat->est));
 	}
 
 	size = qopt->num_entries;
 
+	mutex_lock(&priv->plat->est->lock);
 	priv->plat->est->gcl_size = size;
 	priv->plat->est->enable = qopt->enable;
+	mutex_unlock(&priv->plat->est->lock);
 
 	for (i = 0; i < size; i++) {
 		s64 delta_ns = qopt->entries[i].interval;
@@ -813,6 +817,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 		priv->plat->est->gcl[i] = delta_ns | (gates << wid);
 	}
 
+	mutex_lock(&priv->plat->est->lock);
 	/* Adjust for real system time */
 	priv->ptp_clock_ops.gettime64(&priv->ptp_clock_ops, &current_time);
 	current_time_ns = timespec64_to_ktime(current_time);
@@ -837,8 +842,10 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	priv->plat->est->ctr[0] = do_div(ctr, NSEC_PER_SEC);
 	priv->plat->est->ctr[1] = (u32)ctr;
 
-	if (fpe && !priv->dma_cap.fpesel)
+	if (fpe && !priv->dma_cap.fpesel) {
+		mutex_unlock(&priv->plat->est->lock);
 		return -EOPNOTSUPP;
+	}
 
 	/* Actual FPE register configuration will be done after FPE handshake
 	 * is success.
@@ -847,6 +854,7 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 
 	ret = stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
 				   priv->plat->clk_ptp_rate);
+	mutex_unlock(&priv->plat->est->lock);
 	if (ret) {
 		netdev_err(priv->dev, "failed to configure EST\n");
 		goto disable;
@@ -862,9 +870,13 @@ static int tc_setup_taprio(struct stmmac_priv *priv,
 	return 0;
 
 disable:
-	priv->plat->est->enable = false;
-	stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
-			     priv->plat->clk_ptp_rate);
+	if (priv->plat->est) {
+		mutex_lock(&priv->plat->est->lock);
+		priv->plat->est->enable = false;
+		stmmac_est_configure(priv, priv->ioaddr, priv->plat->est,
+				     priv->plat->clk_ptp_rate);
+		mutex_unlock(&priv->plat->est->lock);
+	}
 
 	priv->plat->fpe_cfg->enable = false;
 	stmmac_fpe_configure(priv, priv->ioaddr,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
index 105821b53020..2a616c6f7cd0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_xdp.c
@@ -34,18 +34,18 @@ static int stmmac_xdp_enable_pool(struct stmmac_priv *priv,
 	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
 
 	if (need_update) {
-		stmmac_disable_rx_queue(priv, queue);
-		stmmac_disable_tx_queue(priv, queue);
 		napi_disable(&ch->rx_napi);
 		napi_disable(&ch->tx_napi);
+		stmmac_disable_rx_queue(priv, queue);
+		stmmac_disable_tx_queue(priv, queue);
 	}
 
 	set_bit(queue, priv->af_xdp_zc_qps);
 
 	if (need_update) {
-		napi_enable(&ch->rxtx_napi);
 		stmmac_enable_rx_queue(priv, queue);
 		stmmac_enable_tx_queue(priv, queue);
+		napi_enable(&ch->rxtx_napi);
 
 		err = stmmac_xsk_wakeup(priv->dev, queue, XDP_WAKEUP_RX);
 		if (err)
@@ -72,10 +72,10 @@ static int stmmac_xdp_disable_pool(struct stmmac_priv *priv, u16 queue)
 	need_update = netif_running(priv->dev) && stmmac_xdp_is_enabled(priv);
 
 	if (need_update) {
+		napi_disable(&ch->rxtx_napi);
 		stmmac_disable_rx_queue(priv, queue);
 		stmmac_disable_tx_queue(priv, queue);
 		synchronize_rcu();
-		napi_disable(&ch->rxtx_napi);
 	}
 
 	xsk_pool_dma_unmap(pool, STMMAC_RX_DMA_ATTR);
@@ -83,10 +83,10 @@ static int stmmac_xdp_disable_pool(struct stmmac_priv *priv, u16 queue)
 	clear_bit(queue, priv->af_xdp_zc_qps);
 
 	if (need_update) {
-		napi_enable(&ch->rx_napi);
-		napi_enable(&ch->tx_napi);
 		stmmac_enable_rx_queue(priv, queue);
 		stmmac_enable_tx_queue(priv, queue);
+		napi_enable(&ch->rx_napi);
+		napi_enable(&ch->tx_napi);
 	}
 
 	return 0;
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index a08a46fef0d2..847372c6d9e8 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -471,7 +471,7 @@ static int enable_net_traffic(struct net_device *dev, struct usb_device *usb)
 		write_mii_word(pegasus, 0, 0x1b, &auxmode);
 	}
 
-	return 0;
+	return ret;
 fail:
 	netif_dbg(pegasus, drv, pegasus->net, "%s failed\n", __func__);
 	return ret;
@@ -860,7 +860,7 @@ static int pegasus_open(struct net_device *net)
 	if (!pegasus->rx_skb)
 		goto exit;
 
-	res = set_registers(pegasus, EthID, 6, net->dev_addr);
+	set_registers(pegasus, EthID, 6, net->dev_addr);
 
 	usb_fill_bulk_urb(pegasus->rx_urb, pegasus->usb,
 			  usb_rcvbulkpipe(pegasus->usb, 1),
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 40f2109a097f..1a63cae6567e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -37,6 +37,7 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 	u32 sha1 = 0;
 	u16 mac_type = 0, rf_id = 0;
 	u8 *pnvm_data = NULL, *tmp;
+	bool hw_match = false;
 	u32 size = 0;
 	int ret;
 
@@ -83,6 +84,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 				break;
 			}
 
+			if (hw_match)
+				break;
+
 			mac_type = le16_to_cpup((__le16 *)data);
 			rf_id = le16_to_cpup((__le16 *)(data + sizeof(__le16)));
 
@@ -90,15 +94,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 				     "Got IWL_UCODE_TLV_HW_TYPE mac_type 0x%0x rf_id 0x%0x\n",
 				     mac_type, rf_id);
 
-			if (mac_type != CSR_HW_REV_TYPE(trans->hw_rev) ||
-			    rf_id != CSR_HW_RFID_TYPE(trans->hw_rf_id)) {
-				IWL_DEBUG_FW(trans,
-					     "HW mismatch, skipping PNVM section, mac_type 0x%0x, rf_id 0x%0x.\n",
-					     CSR_HW_REV_TYPE(trans->hw_rev), trans->hw_rf_id);
-				ret = -ENOENT;
-				goto out;
-			}
-
+			if (mac_type == CSR_HW_REV_TYPE(trans->hw_rev) &&
+			    rf_id == CSR_HW_RFID_TYPE(trans->hw_rf_id))
+				hw_match = true;
 			break;
 		case IWL_UCODE_TLV_SEC_RT: {
 			struct iwl_pnvm_section *section = (void *)data;
@@ -149,6 +147,15 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 	}
 
 done:
+	if (!hw_match) {
+		IWL_DEBUG_FW(trans,
+			     "HW mismatch, skipping PNVM section (need mac_type 0x%x rf_id 0x%x)\n",
+			     CSR_HW_REV_TYPE(trans->hw_rev),
+			     CSR_HW_RFID_TYPE(trans->hw_rf_id));
+		ret = -ENOENT;
+		goto out;
+	}
+
 	if (!size) {
 		IWL_DEBUG_FW(trans, "Empty PNVM, skipping.\n");
 		ret = -ENOENT;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index d94bd8d732e9..9f11a1d5d034 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1103,12 +1103,80 @@ static const struct iwl_dev_info iwl_dev_info_table[] = {
 		      IWL_CFG_ANY, IWL_CFG_ANY, IWL_CFG_NO_CDB,
 		      iwl_cfg_bz_a0_mr_a0, iwl_ax211_name),
 
+/* SoF with JF2 */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_name),
+
+/* SoF with JF */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SOF, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_name),
+
 /* So with GF */
 	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
 		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
 		      IWL_CFG_RF_TYPE_GF, IWL_CFG_ANY,
 		      IWL_CFG_160, IWL_CFG_ANY, IWL_CFG_NO_CDB,
-		      iwlax211_2ax_cfg_so_gf_a0, iwl_ax211_name)
+		      iwlax211_2ax_cfg_so_gf_a0, iwl_ax211_name),
+
+/* So with JF2 */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF2, IWL_CFG_RF_ID_JF,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9560_name),
+
+/* So with JF */
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_160_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9461_name),
+	_IWL_DEV_INFO(IWL_CFG_ANY, IWL_CFG_ANY,
+		      IWL_CFG_MAC_TYPE_SO, IWL_CFG_ANY,
+		      IWL_CFG_RF_TYPE_JF1, IWL_CFG_RF_ID_JF1_DIV,
+		      IWL_CFG_NO_160, IWL_CFG_CORES_BT, IWL_CFG_NO_CDB,
+		      iwlax210_2ax_cfg_so_jf_b0, iwl9462_name)
 
 #endif /* CONFIG_IWLMVM */
 };
diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index c582a9ca397b..01feeba78426 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -985,8 +985,9 @@ static int _of_add_opp_table_v2(struct device *dev, struct opp_table *opp_table)
 		}
 	}
 
-	/* There should be one of more OPP defined */
-	if (WARN_ON(!count)) {
+	/* There should be one or more OPPs defined */
+	if (!count) {
+		dev_err(dev, "%s: no supported OPPs", __func__);
 		ret = -ENOENT;
 		goto remove_static_opp;
 	}
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 60592fb88e7a..e878ac192758 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -507,6 +507,7 @@ config THINKPAD_ACPI
 	depends on RFKILL || RFKILL = n
 	depends on ACPI_VIDEO || ACPI_VIDEO = n
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on I2C
 	select ACPI_PLATFORM_PROFILE
 	select HWMON
 	select NVRAM
@@ -701,6 +702,7 @@ config INTEL_HID_EVENT
 	tristate "INTEL HID Event"
 	depends on ACPI
 	depends on INPUT
+	depends on I2C
 	select INPUT_SPARSEKMAP
 	help
 	  This driver provides support for the Intel HID Event hotkey interface.
@@ -752,6 +754,7 @@ config INTEL_VBTN
 	tristate "INTEL VIRTUAL BUTTON"
 	depends on ACPI
 	depends on INPUT
+	depends on I2C
 	select INPUT_SPARSEKMAP
 	help
 	  This driver provides support for the Intel Virtual Button interface.
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 0cb927f0f301..a81dc4b191b7 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -41,6 +41,10 @@ static int wapf = -1;
 module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
+static int tablet_mode_sw = -1;
+module_param(tablet_mode_sw, uint, 0444);
+MODULE_PARM_DESC(tablet_mode_sw, "Tablet mode detect: -1:auto 0:disable 1:kbd-dock 2:lid-flip");
+
 static struct quirk_entry *quirks;
 
 static bool asus_q500a_i8042_filter(unsigned char data, unsigned char str,
@@ -458,6 +462,15 @@ static const struct dmi_system_id asus_quirks[] = {
 		},
 		.driver_data = &quirk_asus_use_lid_flip_devid,
 	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUS TP200s / E205SA",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E205SA"),
+		},
+		.driver_data = &quirk_asus_use_lid_flip_devid,
+	},
 	{},
 };
 
@@ -477,6 +490,21 @@ static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 	else
 		wapf = quirks->wapf;
 
+	switch (tablet_mode_sw) {
+	case 0:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 1:
+		quirks->use_kbd_dock_devid = true;
+		quirks->use_lid_flip_devid = false;
+		break;
+	case 2:
+		quirks->use_kbd_dock_devid = false;
+		quirks->use_lid_flip_devid = true;
+		break;
+	}
+
 	if (quirks->i8042_filter) {
 		ret = i8042_install_filter(quirks->i8042_filter);
 		if (ret) {
diff --git a/drivers/platform/x86/dual_accel_detect.h b/drivers/platform/x86/dual_accel_detect.h
new file mode 100644
index 000000000000..a9eae17cc43d
--- /dev/null
+++ b/drivers/platform/x86/dual_accel_detect.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Helper code to detect 360 degree hinges (yoga) style 2-in-1 devices using 2 accelerometers
+ * to allow the OS to determine the angle between the display and the base of the device.
+ *
+ * On Windows these are read by a special HingeAngleService process which calls undocumented
+ * ACPI methods, to let the firmware know if the 2-in-1 is in tablet- or laptop-mode.
+ * The firmware may use this to disable the kbd and touchpad to avoid spurious input in
+ * tablet-mode as well as to report SW_TABLET_MODE info to the OS.
+ *
+ * Since Linux does not call these undocumented methods, the SW_TABLET_MODE info reported
+ * by various drivers/platform/x86 drivers is incorrect. These drivers use the detection
+ * code in this file to disable SW_TABLET_MODE reporting to avoid reporting broken info
+ * (instead userspace can derive the status itself by directly reading the 2 accels).
+ */
+
+#include <linux/acpi.h>
+#include <linux/i2c.h>
+
+static int dual_accel_i2c_resource_count(struct acpi_resource *ares, void *data)
+{
+	struct acpi_resource_i2c_serialbus *sb;
+	int *count = data;
+
+	if (i2c_acpi_get_i2c_resource(ares, &sb))
+		*count = *count + 1;
+
+	return 1;
+}
+
+static int dual_accel_i2c_client_count(struct acpi_device *adev)
+{
+	int ret, count = 0;
+	LIST_HEAD(r);
+
+	ret = acpi_dev_get_resources(adev, &r, dual_accel_i2c_resource_count, &count);
+	if (ret < 0)
+		return ret;
+
+	acpi_dev_free_resource_list(&r);
+	return count;
+}
+
+static bool dual_accel_detect_bosc0200(void)
+{
+	struct acpi_device *adev;
+	int count;
+
+	adev = acpi_dev_get_first_match_dev("BOSC0200", NULL, -1);
+	if (!adev)
+		return false;
+
+	count = dual_accel_i2c_client_count(adev);
+
+	acpi_dev_put(adev);
+
+	return count == 2;
+}
+
+static bool dual_accel_detect(void)
+{
+	/* Systems which use a pair of accels with KIOX010A / KIOX020A ACPI ids */
+	if (acpi_dev_present("KIOX010A", NULL, -1) &&
+	    acpi_dev_present("KIOX020A", NULL, -1))
+		return true;
+
+	/* Systems which use a single DUAL250E ACPI device to model 2 accels */
+	if (acpi_dev_present("DUAL250E", NULL, -1))
+		return true;
+
+	/* Systems which use a single BOSC0200 ACPI device to model 2 accels */
+	if (dual_accel_detect_bosc0200())
+		return true;
+
+	return false;
+}
diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index fbb224a82e34..7f3a03f937f6 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 GAMING X V2"),
@@ -147,6 +148,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 AORUS ELITE"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 GAMING X"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 I AORUS PRO WIFI"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("X570 UD"),
 	{ }
diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index 078648a9201b..7135d720af60 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/suspend.h>
+#include "dual_accel_detect.h"
 
 /* When NOT in tablet mode, VGBS returns with the flag 0x40 */
 #define TABLET_MODE_FLAG BIT(6)
@@ -121,6 +122,7 @@ struct intel_hid_priv {
 	struct input_dev *array;
 	struct input_dev *switches;
 	bool wakeup_mode;
+	bool dual_accel;
 };
 
 #define HID_EVENT_FILTER_UUID	"eeec56b3-4442-408f-a792-4edd4d758054"
@@ -450,22 +452,9 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 	 * SW_TABLET_MODE report, in these cases we enable support when receiving
 	 * the first event instead of during driver setup.
 	 *
-	 * Some 360 degree hinges (yoga) style 2-in-1 devices use 2 accelerometers
-	 * to allow the OS to determine the angle between the display and the base
-	 * of the device. On Windows these are read by a special HingeAngleService
-	 * process which calls an ACPI DSM (Device Specific Method) on the
-	 * ACPI KIOX010A device node for the sensor in the display, to let the
-	 * firmware know if the 2-in-1 is in tablet- or laptop-mode so that it can
-	 * disable the kbd and touchpad to avoid spurious input in tablet-mode.
-	 *
-	 * The linux kxcjk1013 driver calls the DSM for this once at probe time
-	 * to ensure that the builtin kbd and touchpad work. On some devices this
-	 * causes a "spurious" 0xcd event on the intel-hid ACPI dev. In this case
-	 * there is not a functional tablet-mode switch, so we should not register
-	 * the tablet-mode switch device.
+	 * See dual_accel_detect.h for more info on the dual_accel check.
 	 */
-	if (!priv->switches && (event == 0xcc || event == 0xcd) &&
-	    !acpi_dev_present("KIOX010A", NULL, -1)) {
+	if (!priv->switches && !priv->dual_accel && (event == 0xcc || event == 0xcd)) {
 		dev_info(&device->dev, "switch event received, enable switches supports\n");
 		err = intel_hid_switches_setup(device);
 		if (err)
@@ -606,6 +595,8 @@ static int intel_hid_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
+	priv->dual_accel = dual_accel_detect();
+
 	err = intel_hid_input_setup(device);
 	if (err) {
 		pr_err("Failed to setup Intel HID hotkeys\n");
diff --git a/drivers/platform/x86/intel-vbtn.c b/drivers/platform/x86/intel-vbtn.c
index 888a764efad1..309166431063 100644
--- a/drivers/platform/x86/intel-vbtn.c
+++ b/drivers/platform/x86/intel-vbtn.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/suspend.h>
+#include "dual_accel_detect.h"
 
 /* Returned when NOT in tablet mode on some HP Stream x360 11 models */
 #define VGBS_TABLET_MODE_FLAG_ALT	0x10
@@ -66,6 +67,7 @@ static const struct key_entry intel_vbtn_switchmap[] = {
 struct intel_vbtn_priv {
 	struct input_dev *buttons_dev;
 	struct input_dev *switches_dev;
+	bool dual_accel;
 	bool has_buttons;
 	bool has_switches;
 	bool wakeup_mode;
@@ -160,6 +162,10 @@ static void notify_handler(acpi_handle handle, u32 event, void *context)
 		input_dev = priv->buttons_dev;
 	} else if ((ke = sparse_keymap_entry_from_scancode(priv->switches_dev, event))) {
 		if (!priv->has_switches) {
+			/* See dual_accel_detect.h for more info */
+			if (priv->dual_accel)
+				return;
+
 			dev_info(&device->dev, "Registering Intel Virtual Switches input-dev after receiving a switch event\n");
 			ret = input_register_device(priv->switches_dev);
 			if (ret)
@@ -248,11 +254,15 @@ static const struct dmi_system_id dmi_switches_allow_list[] = {
 	{} /* Array terminator */
 };
 
-static bool intel_vbtn_has_switches(acpi_handle handle)
+static bool intel_vbtn_has_switches(acpi_handle handle, bool dual_accel)
 {
 	unsigned long long vgbs;
 	acpi_status status;
 
+	/* See dual_accel_detect.h for more info */
+	if (dual_accel)
+		return false;
+
 	if (!dmi_check_system(dmi_switches_allow_list))
 		return false;
 
@@ -263,13 +273,14 @@ static bool intel_vbtn_has_switches(acpi_handle handle)
 static int intel_vbtn_probe(struct platform_device *device)
 {
 	acpi_handle handle = ACPI_HANDLE(&device->dev);
-	bool has_buttons, has_switches;
+	bool dual_accel, has_buttons, has_switches;
 	struct intel_vbtn_priv *priv;
 	acpi_status status;
 	int err;
 
+	dual_accel = dual_accel_detect();
 	has_buttons = acpi_has_method(handle, "VBDL");
-	has_switches = intel_vbtn_has_switches(handle);
+	has_switches = intel_vbtn_has_switches(handle, dual_accel);
 
 	if (!has_buttons && !has_switches) {
 		dev_warn(&device->dev, "failed to read Intel Virtual Button driver\n");
@@ -281,6 +292,7 @@ static int intel_vbtn_probe(struct platform_device *device)
 		return -ENOMEM;
 	dev_set_drvdata(&device->dev, priv);
 
+	priv->dual_accel = dual_accel;
 	priv->has_buttons = has_buttons;
 	priv->has_switches = has_switches;
 
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index edd71e744d27..f8cfb529d1a2 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -73,6 +73,7 @@
 #include <linux/uaccess.h>
 #include <acpi/battery.h>
 #include <acpi/video.h>
+#include "dual_accel_detect.h"
 
 /* ThinkPad CMOS commands */
 #define TP_CMOS_VOLUME_DOWN	0
@@ -3232,7 +3233,7 @@ static int hotkey_init_tablet_mode(void)
 		 * the laptop/tent/tablet mode to the EC. The bmc150 iio driver
 		 * does not support this, so skip the hotkey on these models.
 		 */
-		if (has_tablet_mode && !acpi_dev_present("BOSC0200", "1", -1))
+		if (has_tablet_mode && !dual_accel_detect())
 			tp_features.hotkey_tablet = TP_HOTKEY_TABLET_USES_GMMS;
 		type = "GMMS";
 	} else if (acpi_evalf(hkey_handle, &res, "MHKG", "qd")) {
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ae9bfc658203..c0d31119d6d7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -808,12 +808,15 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	ret = scsi_device_set_state(sdev, state);
 	/*
 	 * If the device state changes to SDEV_RUNNING, we need to
-	 * rescan the device to revalidate it, and run the queue to
-	 * avoid I/O hang.
+	 * run the queue to avoid I/O hang, and rescan the device
+	 * to revalidate it. Running the queue first is necessary
+	 * because another thread may be waiting inside
+	 * blk_mq_freeze_queue_wait() and because that call may be
+	 * waiting for pending I/O to finish.
 	 */
 	if (ret == 0 && state == SDEV_RUNNING) {
-		scsi_rescan_device(dev);
 		blk_mq_run_hw_queues(sdev->request_queue, true);
+		scsi_rescan_device(dev);
 	}
 	mutex_unlock(&sdev->state_mutex);
 
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 0e0cd9e9e589..3639bb6dc372 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -246,6 +246,8 @@ int vt_waitactive(int n)
  *
  * XXX It should at least call into the driver, fbdev's definitely need to
  * restore their engine state. --BenH
+ *
+ * Called with the console lock held.
  */
 static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 {
@@ -262,7 +264,6 @@ static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 		return -EINVAL;
 	}
 
-	/* FIXME: this needs the console lock extending */
 	if (vc->vc_mode == mode)
 		return 0;
 
@@ -271,12 +272,10 @@ static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 		return 0;
 
 	/* explicitly blank/unblank the screen if switching modes */
-	console_lock();
 	if (mode == KD_TEXT)
 		do_unblank_screen(1);
 	else
 		do_blank_screen(1);
-	console_unlock();
 
 	return 0;
 }
@@ -378,7 +377,10 @@ static int vt_k_ioctl(struct tty_struct *tty, unsigned int cmd,
 		if (!perm)
 			return -EPERM;
 
-		return vt_kdsetmode(vc, arg);
+		console_lock();
+		ret = vt_kdsetmode(vc, arg);
+		console_unlock();
+		return ret;
 
 	case KDGETMODE:
 		return put_user(vc->vc_mode, (int __user *)arg);
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 8e3e0c30f420..3c4d5d29149c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -940,19 +940,19 @@ static struct dwc3_trb *dwc3_ep_prev_trb(struct dwc3_ep *dep, u8 index)
 
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
@@ -2243,10 +2243,8 @@ static int dwc3_gadget_pullup(struct usb_gadget *g, int is_on)
 
 		ret = wait_for_completion_timeout(&dwc->ep0_in_setup,
 				msecs_to_jiffies(DWC3_PULL_UP_TIMEOUT));
-		if (ret == 0) {
-			dev_err(dwc->dev, "timed out waiting for SETUP phase\n");
-			return -ETIMEDOUT;
-		}
+		if (ret == 0)
+			dev_warn(dwc->dev, "timed out waiting for SETUP phase\n");
 	}
 
 	/*
@@ -2458,6 +2456,7 @@ static int __dwc3_gadget_start(struct dwc3 *dwc)
 	/* begin to receive SETUP packets */
 	dwc->ep0state = EP0_SETUP_PHASE;
 	dwc->link_state = DWC3_LINK_STATE_SS_DIS;
+	dwc->delayed_status = false;
 	dwc3_ep0_out_start(dwc);
 
 	dwc3_gadget_enable_irq(dwc);
diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 5fbceee897a3..3b613ca06ae5 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -312,8 +312,6 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
 	if (!prm->ep_enabled)
 		return;
 
-	prm->ep_enabled = false;
-
 	audio_dev = uac->audio_dev;
 	params = &audio_dev->params;
 
@@ -331,11 +329,12 @@ static inline void free_ep(struct uac_rtd_params *prm, struct usb_ep *ep)
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
diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
index f97ac9f52bf4..96692dbbd4da 100644
--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -207,7 +207,8 @@ static int renesas_check_rom_state(struct pci_dev *pdev)
 			return 0;
 
 		case RENESAS_ROM_STATUS_NO_RESULT: /* No result yet */
-			return 0;
+			dev_dbg(&pdev->dev, "Unknown ROM status ...\n");
+			return -ENOENT;
 
 		case RENESAS_ROM_STATUS_ERROR: /* Error State */
 		default: /* All other states are marked as "Reserved states" */
@@ -224,14 +225,6 @@ static int renesas_fw_check_running(struct pci_dev *pdev)
 	u8 fw_state;
 	int err;
 
-	/* Check if device has ROM and loaded, if so skip everything */
-	err = renesas_check_rom(pdev);
-	if (err) { /* we have rom */
-		err = renesas_check_rom_state(pdev);
-		if (!err)
-			return err;
-	}
-
 	/*
 	 * Test if the device is actually needing the firmware. As most
 	 * BIOSes will initialize the device for us. If the device is
@@ -591,21 +584,39 @@ int renesas_xhci_check_request_fw(struct pci_dev *pdev,
 			(struct xhci_driver_data *)id->driver_data;
 	const char *fw_name = driver_data->firmware;
 	const struct firmware *fw;
+	bool has_rom;
 	int err;
 
+	/* Check if device has ROM and loaded, if so skip everything */
+	has_rom = renesas_check_rom(pdev);
+	if (has_rom) {
+		err = renesas_check_rom_state(pdev);
+		if (!err)
+			return 0;
+		else if (err != -ENOENT)
+			has_rom = false;
+	}
+
 	err = renesas_fw_check_running(pdev);
 	/* Continue ahead, if the firmware is already running. */
 	if (err == 0)
 		return 0;
 
+	/* no firmware interface available */
 	if (err != 1)
-		return err;
+		return has_rom ? 0 : err;
 
 	pci_dev_get(pdev);
-	err = request_firmware(&fw, fw_name, &pdev->dev);
+	err = firmware_request_nowarn(&fw, fw_name, &pdev->dev);
 	pci_dev_put(pdev);
 	if (err) {
-		dev_err(&pdev->dev, "request_firmware failed: %d\n", err);
+		if (has_rom) {
+			dev_info(&pdev->dev, "failed to load firmware %s, fallback to ROM\n",
+				 fw_name);
+			return 0;
+		}
+		dev_err(&pdev->dev, "failed to load firmware %s: %d\n",
+			fw_name, err);
 		return err;
 	}
 
diff --git a/drivers/usb/serial/ch341.c b/drivers/usb/serial/ch341.c
index 8a521b5ea769..2db917eab799 100644
--- a/drivers/usb/serial/ch341.c
+++ b/drivers/usb/serial/ch341.c
@@ -851,7 +851,6 @@ static struct usb_serial_driver ch341_device = {
 		.owner	= THIS_MODULE,
 		.name	= "ch341-uart",
 	},
-	.bulk_in_size      = 512,
 	.id_table          = id_table,
 	.num_ports         = 1,
 	.open              = ch341_open,
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 039450069ca4..29c765cc8495 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2074,6 +2074,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(4) | RSVD(5) },
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x0105, 0xff),			/* Fibocom NL678 series */
 	  .driver_info = RSVD(6) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0xff, 0x30) },	/* Fibocom FG150 Diag */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x2cb7, 0x010b, 0xff, 0, 0) },		/* Fibocom FG150 AT */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2cb7, 0x01a0, 0xff) },			/* Fibocom NL668-AM/NL652-EU (laptop MBIM) */
 	{ USB_DEVICE_INTERFACE_CLASS(0x2df3, 0x9d03, 0xff) },			/* LongSung M5710 */
 	{ USB_DEVICE_INTERFACE_CLASS(0x305a, 0x1404, 0xff) },			/* GosunCn GM500 RNDIS */
diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 1b886d80ba1c..b3853b09d484 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -341,6 +341,7 @@ struct tcpm_port {
 	bool vbus_source;
 	bool vbus_charge;
 
+	/* Set to true when Discover_Identity Command is expected to be sent in Ready states. */
 	bool send_discover;
 	bool op_vsafe5v;
 
@@ -370,6 +371,7 @@ struct tcpm_port {
 	struct hrtimer send_discover_timer;
 	struct kthread_work send_discover_work;
 	bool state_machine_running;
+	/* Set to true when VDM State Machine has following actions. */
 	bool vdm_sm_running;
 
 	struct completion tx_complete;
@@ -1403,6 +1405,7 @@ static void tcpm_queue_vdm(struct tcpm_port *port, const u32 header,
 	/* Set ready, vdm state machine will actually send */
 	port->vdm_retries = 0;
 	port->vdm_state = VDM_STATE_READY;
+	port->vdm_sm_running = true;
 
 	mod_vdm_delayed_work(port, 0);
 }
@@ -1645,7 +1648,6 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 				rlen = 1;
 			} else {
 				tcpm_register_partner_altmodes(port);
-				port->vdm_sm_running = false;
 			}
 			break;
 		case CMD_ENTER_MODE:
@@ -1693,14 +1695,12 @@ static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 				      (VDO_SVDM_VERS(svdm_version));
 			break;
 		}
-		port->vdm_sm_running = false;
 		break;
 	default:
 		response[0] = p[0] | VDO_CMDT(CMDT_RSP_NAK);
 		rlen = 1;
 		response[0] = (response[0] & ~VDO_SVDM_VERS_MASK) |
 			      (VDO_SVDM_VERS(svdm_version));
-		port->vdm_sm_running = false;
 		break;
 	}
 
@@ -1741,6 +1741,20 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 	}
 
 	if (PD_VDO_SVDM(p[0]) && (adev || tcpm_vdm_ams(port) || port->nr_snk_vdo)) {
+		/*
+		 * Here a SVDM is received (INIT or RSP or unknown). Set the vdm_sm_running in
+		 * advance because we are dropping the lock but may send VDMs soon.
+		 * For the cases of INIT received:
+		 *  - If no response to send, it will be cleared later in this function.
+		 *  - If there are responses to send, it will be cleared in the state machine.
+		 * For the cases of RSP received:
+		 *  - If no further INIT to send, it will be cleared later in this function.
+		 *  - Otherwise, it will be cleared in the state machine if timeout or it will go
+		 *    back here until no further INIT to send.
+		 * For the cases of unknown type received:
+		 *  - We will send NAK and the flag will be cleared in the state machine.
+		 */
+		port->vdm_sm_running = true;
 		rlen = tcpm_pd_svdm(port, adev, p, cnt, response, &adev_action);
 	} else {
 		if (port->negotiated_rev >= PD_REV30)
@@ -1809,6 +1823,8 @@ static void tcpm_handle_vdm_request(struct tcpm_port *port,
 
 	if (rlen > 0)
 		tcpm_queue_vdm(port, response[0], &response[1], rlen - 1);
+	else
+		port->vdm_sm_running = false;
 }
 
 static void tcpm_send_vdm(struct tcpm_port *port, u32 vid, int cmd,
@@ -1874,8 +1890,10 @@ static void vdm_run_state_machine(struct tcpm_port *port)
 		 * if there's traffic or we're not in PDO ready state don't send
 		 * a VDM.
 		 */
-		if (port->state != SRC_READY && port->state != SNK_READY)
+		if (port->state != SRC_READY && port->state != SNK_READY) {
+			port->vdm_sm_running = false;
 			break;
+		}
 
 		/* TODO: AMS operation for Unstructured VDM */
 		if (PD_VDO_SVDM(vdo_hdr) && PD_VDO_CMDT(vdo_hdr) == CMDT_INIT) {
@@ -2528,10 +2546,6 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 								       TYPEC_PWR_MODE_PD,
 								       port->pps_data.active,
 								       port->supply_voltage);
-				/* Set VDM running flag ASAP */
-				if (port->data_role == TYPEC_HOST &&
-				    port->send_discover)
-					port->vdm_sm_running = true;
 				tcpm_set_state(port, SNK_READY, 0);
 			} else {
 				/*
@@ -2569,14 +2583,10 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 		switch (port->state) {
 		case SNK_NEGOTIATE_CAPABILITIES:
 			/* USB PD specification, Figure 8-43 */
-			if (port->explicit_contract) {
+			if (port->explicit_contract)
 				next_state = SNK_READY;
-				if (port->data_role == TYPEC_HOST &&
-				    port->send_discover)
-					port->vdm_sm_running = true;
-			} else {
+			else
 				next_state = SNK_WAIT_CAPABILITIES;
-			}
 
 			/* Threshold was relaxed before sending Request. Restore it back. */
 			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
@@ -2591,10 +2601,6 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			port->pps_status = (type == PD_CTRL_WAIT ?
 					    -EAGAIN : -EOPNOTSUPP);
 
-			if (port->data_role == TYPEC_HOST &&
-			    port->send_discover)
-				port->vdm_sm_running = true;
-
 			/* Threshold was relaxed before sending Request. Restore it back. */
 			tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_PD,
 							       port->pps_data.active,
@@ -2670,10 +2676,6 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 			}
 			break;
 		case DR_SWAP_SEND:
-			if (port->data_role == TYPEC_DEVICE &&
-			    port->send_discover)
-				port->vdm_sm_running = true;
-
 			tcpm_set_state(port, DR_SWAP_CHANGE_DR, 0);
 			break;
 		case PR_SWAP_SEND:
@@ -2711,7 +2713,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 					   PD_MSG_CTRL_NOT_SUPP,
 					   NONE_AMS);
 		} else {
-			if (port->vdm_sm_running) {
+			if (port->send_discover) {
 				tcpm_queue_message(port, PD_MSG_CTRL_WAIT);
 				break;
 			}
@@ -2727,7 +2729,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 					   PD_MSG_CTRL_NOT_SUPP,
 					   NONE_AMS);
 		} else {
-			if (port->vdm_sm_running) {
+			if (port->send_discover) {
 				tcpm_queue_message(port, PD_MSG_CTRL_WAIT);
 				break;
 			}
@@ -2736,7 +2738,7 @@ static void tcpm_pd_ctrl_request(struct tcpm_port *port,
 		}
 		break;
 	case PD_CTRL_VCONN_SWAP:
-		if (port->vdm_sm_running) {
+		if (port->send_discover) {
 			tcpm_queue_message(port, PD_MSG_CTRL_WAIT);
 			break;
 		}
@@ -4470,18 +4472,20 @@ static void run_state_machine(struct tcpm_port *port)
 	/* DR_Swap states */
 	case DR_SWAP_SEND:
 		tcpm_pd_send_control(port, PD_CTRL_DR_SWAP);
+		if (port->data_role == TYPEC_DEVICE || port->negotiated_rev > PD_REV20)
+			port->send_discover = true;
 		tcpm_set_state_cond(port, DR_SWAP_SEND_TIMEOUT,
 				    PD_T_SENDER_RESPONSE);
 		break;
 	case DR_SWAP_ACCEPT:
 		tcpm_pd_send_control(port, PD_CTRL_ACCEPT);
-		/* Set VDM state machine running flag ASAP */
-		if (port->data_role == TYPEC_DEVICE && port->send_discover)
-			port->vdm_sm_running = true;
+		if (port->data_role == TYPEC_DEVICE || port->negotiated_rev > PD_REV20)
+			port->send_discover = true;
 		tcpm_set_state_cond(port, DR_SWAP_CHANGE_DR, 0);
 		break;
 	case DR_SWAP_SEND_TIMEOUT:
 		tcpm_swap_complete(port, -ETIMEDOUT);
+		port->send_discover = false;
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
@@ -4493,7 +4497,6 @@ static void run_state_machine(struct tcpm_port *port)
 		} else {
 			tcpm_set_roles(port, true, port->pwr_role,
 				       TYPEC_HOST);
-			port->send_discover = true;
 		}
 		tcpm_ams_finish(port);
 		tcpm_set_state(port, ready_state(port), 0);
@@ -4633,8 +4636,6 @@ static void run_state_machine(struct tcpm_port *port)
 		break;
 	case VCONN_SWAP_SEND_TIMEOUT:
 		tcpm_swap_complete(port, -ETIMEDOUT);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case VCONN_SWAP_START:
@@ -4650,14 +4651,10 @@ static void run_state_machine(struct tcpm_port *port)
 	case VCONN_SWAP_TURN_ON_VCONN:
 		tcpm_set_vconn(port, true);
 		tcpm_pd_send_control(port, PD_CTRL_PS_RDY);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 	case VCONN_SWAP_TURN_OFF_VCONN:
 		tcpm_set_vconn(port, false);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, ready_state(port), 0);
 		break;
 
@@ -4665,8 +4662,6 @@ static void run_state_machine(struct tcpm_port *port)
 	case PR_SWAP_CANCEL:
 	case VCONN_SWAP_CANCEL:
 		tcpm_swap_complete(port, port->swap_status);
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		if (port->pwr_role == TYPEC_SOURCE)
 			tcpm_set_state(port, SRC_READY, 0);
 		else
@@ -5016,9 +5011,6 @@ static void _tcpm_pd_vbus_on(struct tcpm_port *port)
 	switch (port->state) {
 	case SNK_TRANSITION_SINK_VBUS:
 		port->explicit_contract = true;
-		/* Set the VDM flag ASAP */
-		if (port->data_role == TYPEC_HOST && port->send_discover)
-			port->vdm_sm_running = true;
 		tcpm_set_state(port, SNK_READY, 0);
 		break;
 	case SNK_DISCOVERY:
@@ -5412,15 +5404,18 @@ static void tcpm_send_discover_work(struct kthread_work *work)
 	if (!port->send_discover)
 		goto unlock;
 
+	if (port->data_role == TYPEC_DEVICE && port->negotiated_rev < PD_REV30) {
+		port->send_discover = false;
+		goto unlock;
+	}
+
 	/* Retry if the port is not idle */
 	if ((port->state != SRC_READY && port->state != SNK_READY) || port->vdm_sm_running) {
 		mod_send_discover_delayed_work(port, SEND_DISCOVER_RETRY_MS);
 		goto unlock;
 	}
 
-	/* Only send the Message if the port is host for PD rev2.0 */
-	if (port->data_role == TYPEC_HOST || port->negotiated_rev > PD_REV20)
-		tcpm_send_vdm(port, USB_SID_PD, CMD_DISCOVER_IDENT, NULL, 0);
+	tcpm_send_vdm(port, USB_SID_PD, CMD_DISCOVER_IDENT, NULL, 0);
 
 unlock:
 	mutex_unlock(&port->lock);
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 4af8fa259d65..14e2043d7685 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -359,7 +359,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			iov = wiov;
 		else {
 			iov = riov;
-			if (unlikely(wiov && wiov->i)) {
+			if (unlikely(wiov && wiov->used)) {
 				vringh_bad("Readable desc %p after writable",
 					   &descs[i]);
 				err = -EINVAL;
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 222d630c41fc..b35bb2d57f62 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -576,6 +576,13 @@ static void virtio_pci_remove(struct pci_dev *pci_dev)
 	struct virtio_pci_device *vp_dev = pci_get_drvdata(pci_dev);
 	struct device *dev = get_device(&vp_dev->vdev.dev);
 
+	/*
+	 * Device is marked broken on surprise removal so that virtio upper
+	 * layers can abort any ongoing operation.
+	 */
+	if (!pci_device_is_present(pci_dev))
+		virtio_break_device(&vp_dev->vdev);
+
 	pci_disable_sriov(pci_dev);
 
 	unregister_virtio_device(&vp_dev->vdev);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6b7aa26c5384..6c730d6d50f7 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2268,7 +2268,7 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->broken;
+	return READ_ONCE(vq->broken);
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
@@ -2283,7 +2283,9 @@ void virtio_break_device(struct virtio_device *dev)
 	spin_lock(&dev->vqs_list_lock);
 	list_for_each_entry(_vq, &dev->vqs, list) {
 		struct vring_virtqueue *vq = to_vvq(_vq);
-		vq->broken = true;
+
+		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */
+		WRITE_ONCE(vq->broken, true);
 	}
 	spin_unlock(&dev->vqs_list_lock);
 }
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index e28acf482e0c..e9b9dd03f44a 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -149,6 +149,9 @@ virtio_vdpa_setup_vq(struct virtio_device *vdev, unsigned int index,
 	if (!name)
 		return NULL;
 
+	if (index >= vdpa->nvqs)
+		return ERR_PTR(-ENOENT);
+
 	/* Queue shouldn't already be set up. */
 	if (ops->get_vq_ready(vdpa, index))
 		return ERR_PTR(-ENOENT);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 5d188d5af6fa..6328deb27d12 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -603,7 +603,7 @@ static noinline int compress_file_range(struct async_chunk *async_chunk)
 	 * inode has not been flagged as nocompress.  This flag can
 	 * change at any time if we discover bad compression ratios.
 	 */
-	if (nr_pages > 1 && inode_need_compress(BTRFS_I(inode), start, end)) {
+	if (inode_need_compress(BTRFS_I(inode), start, end)) {
 		WARN_ON(pages);
 		pages = kcalloc(nr_pages, sizeof(struct page *), GFP_NOFS);
 		if (!pages) {
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9f723b744863..7d5875824be7 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -2137,7 +2137,7 @@ int btrfs_rm_device(struct btrfs_fs_info *fs_info, const char *device_path,
 
 	if (IS_ERR(device)) {
 		if (PTR_ERR(device) == -ENOENT &&
-		    strcmp(device_path, "missing") == 0)
+		    device_path && strcmp(device_path, "missing") == 0)
 			ret = BTRFS_ERROR_DEV_MISSING_NOT_FOUND;
 		else
 			ret = PTR_ERR(device);
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index c79b8dff25d7..805c656a2e72 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -1753,7 +1753,11 @@ int __ceph_mark_dirty_caps(struct ceph_inode_info *ci, int mask,
 
 struct ceph_cap_flush *ceph_alloc_cap_flush(void)
 {
-	return kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	struct ceph_cap_flush *cf;
+
+	cf = kmem_cache_alloc(ceph_cap_flush_cachep, GFP_KERNEL);
+	cf->is_capsnap = false;
+	return cf;
 }
 
 void ceph_free_cap_flush(struct ceph_cap_flush *cf)
@@ -1788,7 +1792,7 @@ static bool __detach_cap_flush_from_mdsc(struct ceph_mds_client *mdsc,
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->g_list);
+	list_del_init(&cf->g_list);
 	return wake;
 }
 
@@ -1803,7 +1807,7 @@ static bool __detach_cap_flush_from_ci(struct ceph_inode_info *ci,
 		prev->wake = true;
 		wake = false;
 	}
-	list_del(&cf->i_list);
+	list_del_init(&cf->i_list);
 	return wake;
 }
 
@@ -2423,7 +2427,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 	ci->i_ceph_flags &= ~CEPH_I_KICK_FLUSH;
 
 	list_for_each_entry_reverse(cf, &ci->i_cap_flush_list, i_list) {
-		if (!cf->caps) {
+		if (cf->is_capsnap) {
 			last_snap_flush = cf->tid;
 			break;
 		}
@@ -2442,7 +2446,7 @@ static void __kick_flushing_caps(struct ceph_mds_client *mdsc,
 
 		first_tid = cf->tid + 1;
 
-		if (cf->caps) {
+		if (!cf->is_capsnap) {
 			struct cap_msg_args arg;
 
 			dout("kick_flushing_caps %p cap %p tid %llu %s\n",
@@ -3589,7 +3593,7 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 			cleaned = cf->caps;
 
 		/* Is this a capsnap? */
-		if (cf->caps == 0)
+		if (cf->is_capsnap)
 			continue;
 
 		if (cf->tid <= flush_tid) {
@@ -3662,8 +3666,9 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
 	while (!list_empty(&to_remove)) {
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
-		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		list_del_init(&cf->i_list);
+		if (!cf->is_capsnap)
+			ceph_free_cap_flush(cf);
 	}
 
 	if (wake_ci)
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 2c5701bfe4e8..9e24fcea152b 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -1621,7 +1621,7 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		spin_lock(&mdsc->cap_dirty_lock);
 
 		list_for_each_entry(cf, &to_remove, i_list)
-			list_del(&cf->g_list);
+			list_del_init(&cf->g_list);
 
 		if (!list_empty(&ci->i_dirty_item)) {
 			pr_warn_ratelimited(
@@ -1673,8 +1673,9 @@ static int remove_session_caps_cb(struct inode *inode, struct ceph_cap *cap,
 		struct ceph_cap_flush *cf;
 		cf = list_first_entry(&to_remove,
 				      struct ceph_cap_flush, i_list);
-		list_del(&cf->i_list);
-		ceph_free_cap_flush(cf);
+		list_del_init(&cf->i_list);
+		if (!cf->is_capsnap)
+			ceph_free_cap_flush(cf);
 	}
 
 	wake_up_all(&ci->i_cap_wq);
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index ae20504326b8..1ecd6a5391b4 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -487,6 +487,9 @@ void ceph_queue_cap_snap(struct ceph_inode_info *ci)
 		pr_err("ENOMEM allocating ceph_cap_snap on %p\n", inode);
 		return;
 	}
+	capsnap->cap_flush.is_capsnap = true;
+	INIT_LIST_HEAD(&capsnap->cap_flush.i_list);
+	INIT_LIST_HEAD(&capsnap->cap_flush.g_list);
 
 	spin_lock(&ci->i_ceph_lock);
 	used = __ceph_caps_used(ci);
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 3b5207c82767..3b6a61116036 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -182,8 +182,9 @@ struct ceph_cap {
 
 struct ceph_cap_flush {
 	u64 tid;
-	int caps; /* 0 means capsnap */
+	int caps;
 	bool wake; /* wake up flush waiters when finish ? */
+	bool is_capsnap; /* true means capsnap */
 	struct list_head g_list; // global
 	struct list_head i_list; // per inode
 };
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index a73b0376e6f3..af74599ae1cf 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -384,3 +384,47 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 	return ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(fscrypt_get_symlink);
+
+/**
+ * fscrypt_symlink_getattr() - set the correct st_size for encrypted symlinks
+ * @path: the path for the encrypted symlink being queried
+ * @stat: the struct being filled with the symlink's attributes
+ *
+ * Override st_size of encrypted symlinks to be the length of the decrypted
+ * symlink target (or the no-key encoded symlink target, if the key is
+ * unavailable) rather than the length of the encrypted symlink target.  This is
+ * necessary for st_size to match the symlink target that userspace actually
+ * sees.  POSIX requires this, and some userspace programs depend on it.
+ *
+ * This requires reading the symlink target from disk if needed, setting up the
+ * inode's encryption key if possible, and then decrypting or encoding the
+ * symlink target.  This makes lstat() more heavyweight than is normally the
+ * case.  However, decrypted symlink targets will be cached in ->i_link, so
+ * usually the symlink won't have to be read and decrypted again later if/when
+ * it is actually followed, readlink() is called, or lstat() is called again.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int fscrypt_symlink_getattr(const struct path *path, struct kstat *stat)
+{
+	struct dentry *dentry = path->dentry;
+	struct inode *inode = d_inode(dentry);
+	const char *link;
+	DEFINE_DELAYED_CALL(done);
+
+	/*
+	 * To get the symlink target that userspace will see (whether it's the
+	 * decrypted target or the no-key encoded target), we can just get it in
+	 * the same way the VFS does during path resolution and readlink().
+	 */
+	link = READ_ONCE(inode->i_link);
+	if (!link) {
+		link = inode->i_op->get_link(dentry, inode, &done);
+		if (IS_ERR(link))
+			return PTR_ERR(link);
+	}
+	stat->size = strlen(link);
+	do_delayed_call(&done);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fscrypt_symlink_getattr);
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index dd05af983092..69109746e6e2 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -52,10 +52,20 @@ static const char *ext4_encrypted_get_link(struct dentry *dentry,
 	return paddr;
 }
 
+static int ext4_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	ext4_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
+	.getattr	= ext4_encrypted_symlink_getattr,
 	.listxattr	= ext4_listxattr,
 };
 
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index d4139e166b95..ddaa11c762d1 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1313,9 +1313,19 @@ static const char *f2fs_encrypted_get_link(struct dentry *dentry,
 	return target;
 }
 
+static int f2fs_encrypted_symlink_getattr(struct user_namespace *mnt_userns,
+					  const struct path *path,
+					  struct kstat *stat, u32 request_mask,
+					  unsigned int query_flags)
+{
+	f2fs_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	return fscrypt_symlink_getattr(path, stat);
+}
+
 const struct inode_operations f2fs_encrypted_symlink_inode_operations = {
 	.get_link	= f2fs_encrypted_get_link,
-	.getattr	= f2fs_getattr,
+	.getattr	= f2fs_encrypted_symlink_getattr,
 	.setattr	= f2fs_setattr,
 	.listxattr	= f2fs_listxattr,
 };
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9df82eee440a..f6ddc7182943 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7105,16 +7105,6 @@ static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
 	table->files = NULL;
 }
 
-static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
-{
-	spin_lock_bh(&ctx->rsrc_ref_lock);
-}
-
-static inline void io_rsrc_ref_unlock(struct io_ring_ctx *ctx)
-{
-	spin_unlock_bh(&ctx->rsrc_ref_lock);
-}
-
 static void io_rsrc_node_destroy(struct io_rsrc_node *ref_node)
 {
 	percpu_ref_exit(&ref_node->refs);
@@ -7131,9 +7121,9 @@ static void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 		struct io_rsrc_node *rsrc_node = ctx->rsrc_node;
 
 		rsrc_node->rsrc_data = data_to_kill;
-		io_rsrc_ref_lock(ctx);
+		spin_lock_irq(&ctx->rsrc_ref_lock);
 		list_add_tail(&rsrc_node->node, &ctx->rsrc_ref_list);
-		io_rsrc_ref_unlock(ctx);
+		spin_unlock_irq(&ctx->rsrc_ref_lock);
 
 		atomic_inc(&data_to_kill->refs);
 		percpu_ref_kill(&rsrc_node->refs);
@@ -7625,9 +7615,10 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 {
 	struct io_rsrc_node *node = container_of(ref, struct io_rsrc_node, refs);
 	struct io_ring_ctx *ctx = node->rsrc_data->ctx;
+	unsigned long flags;
 	bool first_add = false;
 
-	io_rsrc_ref_lock(ctx);
+	spin_lock_irqsave(&ctx->rsrc_ref_lock, flags);
 	node->done = true;
 
 	while (!list_empty(&ctx->rsrc_ref_list)) {
@@ -7639,7 +7630,7 @@ static void io_rsrc_node_ref_zero(struct percpu_ref *ref)
 		list_del(&node->node);
 		first_add |= llist_add(&node->llist, &ctx->rsrc_put_llist);
 	}
-	io_rsrc_ref_unlock(ctx);
+	spin_unlock_irqrestore(&ctx->rsrc_ref_lock, flags);
 
 	if (first_add)
 		mod_delayed_work(system_wq, &ctx->rsrc_put_work, HZ);
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 41ebf52f1bbc..ebde05c9cf62 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -392,6 +392,7 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	 */
 	take_dentry_name_snapshot(&name, real);
 	this = lookup_one_len(name.name.name, connected, name.name.len);
+	release_dentry_name_snapshot(&name);
 	err = PTR_ERR(this);
 	if (IS_ERR(this)) {
 		goto fail;
@@ -406,7 +407,6 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
 	}
 
 out:
-	release_dentry_name_snapshot(&name);
 	dput(parent);
 	inode_unlock(dir);
 	return this;
diff --git a/fs/pipe.c b/fs/pipe.c
index 8e6ef62aeb1c..6d4342bad9f1 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -363,10 +363,9 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		 * _very_ unlikely case that the pipe was full, but we got
 		 * no data.
 		 */
-		if (unlikely(was_full)) {
+		if (unlikely(was_full))
 			wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM);
-			kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-		}
+		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 
 		/*
 		 * But because we didn't read anything, at this point we can
@@ -385,12 +384,11 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
 		wake_next_reader = false;
 	__pipe_unlock(pipe);
 
-	if (was_full) {
+	if (was_full)
 		wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM);
-		kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
-	}
 	if (wake_next_reader)
 		wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
+	kill_fasync(&pipe->fasync_writers, SIGIO, POLL_OUT);
 	if (ret > 0)
 		file_accessed(filp);
 	return ret;
@@ -444,9 +442,6 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 #endif
 
 	/*
-	 * Epoll nonsensically wants a wakeup whether the pipe
-	 * was already empty or not.
-	 *
 	 * If it wasn't empty we try to merge new data into
 	 * the last buffer.
 	 *
@@ -455,9 +450,9 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 	 * spanning multiple pages.
 	 */
 	head = pipe->head;
-	was_empty = true;
+	was_empty = pipe_empty(head, pipe->tail);
 	chars = total_len & (PAGE_SIZE-1);
-	if (chars && !pipe_empty(head, pipe->tail)) {
+	if (chars && !was_empty) {
 		unsigned int mask = pipe->ring_size - 1;
 		struct pipe_buffer *buf = &pipe->bufs[(head - 1) & mask];
 		int offset = buf->offset + buf->len;
@@ -568,10 +563,9 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 		 * become empty while we dropped the lock.
 		 */
 		__pipe_unlock(pipe);
-		if (was_empty) {
+		if (was_empty)
 			wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
-			kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-		}
+		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 		wait_event_interruptible_exclusive(pipe->wr_wait, pipe_writable(pipe));
 		__pipe_lock(pipe);
 		was_empty = pipe_empty(pipe->head, pipe->tail);
@@ -590,11 +584,13 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
 	 * This is particularly important for small writes, because of
 	 * how (for example) the GNU make jobserver uses small writes to
 	 * wake up pending jobs
+	 *
+	 * Epoll nonsensically wants a wakeup whether the pipe
+	 * was already empty or not.
 	 */
-	if (was_empty) {
+	if (was_empty || pipe->poll_usage)
 		wake_up_interruptible_sync_poll(&pipe->rd_wait, EPOLLIN | EPOLLRDNORM);
-		kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
-	}
+	kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
 	if (wake_next_writer)
 		wake_up_interruptible_sync_poll(&pipe->wr_wait, EPOLLOUT | EPOLLWRNORM);
 	if (ret > 0 && sb_start_write_trylock(file_inode(filp)->i_sb)) {
@@ -654,6 +650,9 @@ pipe_poll(struct file *filp, poll_table *wait)
 	struct pipe_inode_info *pipe = filp->private_data;
 	unsigned int head, tail;
 
+	/* Epoll has some historical nasty semantics, this enables them */
+	pipe->poll_usage = 1;
+
 	/*
 	 * Reading pipe state only -- no need for acquiring the semaphore.
 	 *
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 2e4e1d159969..5cfa28cd00cd 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1630,6 +1630,17 @@ static const char *ubifs_get_link(struct dentry *dentry,
 	return fscrypt_get_symlink(inode, ui->data, ui->data_len, done);
 }
 
+static int ubifs_symlink_getattr(struct user_namespace *mnt_userns,
+				 const struct path *path, struct kstat *stat,
+				 u32 request_mask, unsigned int query_flags)
+{
+	ubifs_getattr(mnt_userns, path, stat, request_mask, query_flags);
+
+	if (IS_ENCRYPTED(d_inode(path->dentry)))
+		return fscrypt_symlink_getattr(path, stat);
+	return 0;
+}
+
 const struct address_space_operations ubifs_file_address_operations = {
 	.readpage       = ubifs_readpage,
 	.writepage      = ubifs_writepage,
@@ -1655,7 +1666,7 @@ const struct inode_operations ubifs_file_inode_operations = {
 const struct inode_operations ubifs_symlink_inode_operations = {
 	.get_link    = ubifs_get_link,
 	.setattr     = ubifs_setattr,
-	.getattr     = ubifs_getattr,
+	.getattr     = ubifs_symlink_getattr,
 	.listxattr   = ubifs_listxattr,
 	.update_time = ubifs_update_time,
 };
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 2ea1387bb497..b7bfd0cd4f3e 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -253,6 +253,7 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 				unsigned int max_size,
 				struct delayed_call *done);
+int fscrypt_symlink_getattr(const struct path *path, struct kstat *stat);
 static inline void fscrypt_set_ops(struct super_block *sb,
 				   const struct fscrypt_operations *s_cop)
 {
@@ -583,6 +584,12 @@ static inline const char *fscrypt_get_symlink(struct inode *inode,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline int fscrypt_symlink_getattr(const struct path *path,
+					  struct kstat *stat)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void fscrypt_set_ops(struct super_block *sb,
 				   const struct fscrypt_operations *s_cop)
 {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..043ef83c8420 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4012,6 +4012,10 @@ int netdev_rx_handler_register(struct net_device *dev,
 void netdev_rx_handler_unregister(struct net_device *dev);
 
 bool dev_valid_name(const char *name);
+static inline bool is_socket_ioctl_cmd(unsigned int cmd)
+{
+	return _IOC_TYPE(cmd) == SOCK_IOC_TYPE;
+}
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf *, int);
diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 10279c4830ac..ada1296c87d5 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -196,6 +196,9 @@ struct ip_set_region {
 	u32 elements;		/* Number of elements vs timeout */
 };
 
+/* Max range where every element is added/deleted in one step */
+#define IPSET_MAX_RANGE		(1<<20)
+
 /* The max revision number supported by any set type + 1 */
 #define IPSET_REVISION_MAX	9
 
diff --git a/include/linux/once.h b/include/linux/once.h
index 9225ee6d96c7..ae6f4eb41cbe 100644
--- a/include/linux/once.h
+++ b/include/linux/once.h
@@ -7,7 +7,7 @@
 
 bool __do_once_start(bool *done, unsigned long *flags);
 void __do_once_done(bool *done, struct static_key_true *once_key,
-		    unsigned long *flags);
+		    unsigned long *flags, struct module *mod);
 
 /* Call a function exactly once. The idea of DO_ONCE() is to perform
  * a function call such as initialization of random seeds, etc, only
@@ -46,7 +46,7 @@ void __do_once_done(bool *done, struct static_key_true *once_key,
 			if (unlikely(___ret)) {				     \
 				func(__VA_ARGS__);			     \
 				__do_once_done(&___done, &___once_key,	     \
-					       &___flags);		     \
+					       &___flags, THIS_MODULE);	     \
 			}						     \
 		}							     \
 		___ret;							     \
diff --git a/include/linux/pipe_fs_i.h b/include/linux/pipe_fs_i.h
index 5d2705f1d01c..fc5642431b92 100644
--- a/include/linux/pipe_fs_i.h
+++ b/include/linux/pipe_fs_i.h
@@ -48,6 +48,7 @@ struct pipe_buffer {
  *	@files: number of struct file referring this pipe (protected by ->i_lock)
  *	@r_counter: reader counter
  *	@w_counter: writer counter
+ *	@poll_usage: is this pipe used for epoll, which has crazy wakeups?
  *	@fasync_readers: reader side fasync
  *	@fasync_writers: writer side fasync
  *	@bufs: the circular array of pipe buffers
@@ -70,6 +71,7 @@ struct pipe_inode_info {
 	unsigned int files;
 	unsigned int r_counter;
 	unsigned int w_counter;
+	unsigned int poll_usage;
 	struct page *tmp_page;
 	struct fasync_struct *fasync_readers;
 	struct fasync_struct *fasync_writers;
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 0db36360ef21..cb7fbd747ae1 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -115,6 +115,7 @@ struct stmmac_axi {
 
 #define EST_GCL		1024
 struct stmmac_est {
+	struct mutex lock;
 	int enable;
 	u32 btr_offset[2];
 	u32 btr[2];
diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 6c91902f4f45..39241207ec04 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -593,7 +593,6 @@ static void prune_tree_chunks(struct audit_tree *victim, bool tagged)
 		spin_lock(&hash_lock);
 	}
 	spin_unlock(&hash_lock);
-	put_tree(victim);
 }
 
 /*
@@ -602,6 +601,7 @@ static void prune_tree_chunks(struct audit_tree *victim, bool tagged)
 static void prune_one(struct audit_tree *victim)
 {
 	prune_tree_chunks(victim, false);
+	put_tree(victim);
 }
 
 /* trim the uncommitted chunks from tree */
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0fbe7ef6b155..6b58fd978b70 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5148,8 +5148,6 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 	case BPF_MAP_TYPE_RINGBUF:
 		if (func_id != BPF_FUNC_ringbuf_output &&
 		    func_id != BPF_FUNC_ringbuf_reserve &&
-		    func_id != BPF_FUNC_ringbuf_submit &&
-		    func_id != BPF_FUNC_ringbuf_discard &&
 		    func_id != BPF_FUNC_ringbuf_query)
 			goto error;
 		break;
@@ -5258,6 +5256,12 @@ static int check_map_func_compatibility(struct bpf_verifier_env *env,
 		if (map->map_type != BPF_MAP_TYPE_PERF_EVENT_ARRAY)
 			goto error;
 		break;
+	case BPF_FUNC_ringbuf_output:
+	case BPF_FUNC_ringbuf_reserve:
+	case BPF_FUNC_ringbuf_query:
+		if (map->map_type != BPF_MAP_TYPE_RINGBUF)
+			goto error;
+		break;
 	case BPF_FUNC_get_stackid:
 		if (map->map_type != BPF_MAP_TYPE_STACK_TRACE)
 			goto error;
diff --git a/kernel/cred.c b/kernel/cred.c
index 9c2759166bd8..0f84958d1db9 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -286,13 +286,13 @@ struct cred *prepare_creds(void)
 	new->security = NULL;
 #endif
 
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
-		goto error;
-
 	new->ucounts = get_ucounts(new->ucounts);
 	if (!new->ucounts)
 		goto error;
 
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+		goto error;
+
 	validate_creds(new);
 	return new;
 
@@ -753,13 +753,13 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 #ifdef CONFIG_SECURITY
 	new->security = NULL;
 #endif
-	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
-		goto error;
-
 	new->ucounts = get_ucounts(new->ucounts);
 	if (!new->ucounts)
 		goto error;
 
+	if (security_prepare_creds(new, old, GFP_KERNEL_ACCOUNT) < 0)
+		goto error;
+
 	put_cred(old);
 	validate_creds(new);
 	return new;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 35f7efed75c4..f2bc99ca01e5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1977,6 +1977,9 @@ static inline struct task_struct *get_push_task(struct rq *rq)
 	if (p->nr_cpus_allowed == 1)
 		return NULL;
 
+	if (p->migration_disabled)
+		return NULL;
+
 	rq->push_busy = true;
 	return get_task_struct(p);
 }
diff --git a/lib/once.c b/lib/once.c
index 8b7d6235217e..59149bf3bfb4 100644
--- a/lib/once.c
+++ b/lib/once.c
@@ -3,10 +3,12 @@
 #include <linux/spinlock.h>
 #include <linux/once.h>
 #include <linux/random.h>
+#include <linux/module.h>
 
 struct once_work {
 	struct work_struct work;
 	struct static_key_true *key;
+	struct module *module;
 };
 
 static void once_deferred(struct work_struct *w)
@@ -16,10 +18,11 @@ static void once_deferred(struct work_struct *w)
 	work = container_of(w, struct once_work, work);
 	BUG_ON(!static_key_enabled(work->key));
 	static_branch_disable(work->key);
+	module_put(work->module);
 	kfree(work);
 }
 
-static void once_disable_jump(struct static_key_true *key)
+static void once_disable_jump(struct static_key_true *key, struct module *mod)
 {
 	struct once_work *w;
 
@@ -29,6 +32,8 @@ static void once_disable_jump(struct static_key_true *key)
 
 	INIT_WORK(&w->work, once_deferred);
 	w->key = key;
+	w->module = mod;
+	__module_get(mod);
 	schedule_work(&w->work);
 }
 
@@ -53,11 +58,11 @@ bool __do_once_start(bool *done, unsigned long *flags)
 EXPORT_SYMBOL(__do_once_start);
 
 void __do_once_done(bool *done, struct static_key_true *once_key,
-		    unsigned long *flags)
+		    unsigned long *flags, struct module *mod)
 	__releases(once_lock)
 {
 	*done = true;
 	spin_unlock_irqrestore(&once_lock, *flags);
-	once_disable_jump(once_key);
+	once_disable_jump(once_key, mod);
 }
 EXPORT_SYMBOL(__do_once_done);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 70620d0dd923..1bf3f8681250 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1854,6 +1854,7 @@ int __ref offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 failed_removal_pcplists_disabled:
+	lru_cache_enable();
 	zone_pcp_enable(zone);
 failed_removal:
 	pr_debug("memory offlining [mem %#010llx-%#010llx] failed due to %s\n",
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c6e75bd0035d..89c7369805e9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2597,6 +2597,7 @@ static int do_setlink(const struct sk_buff *skb,
 		return err;
 
 	if (tb[IFLA_NET_NS_PID] || tb[IFLA_NET_NS_FD] || tb[IFLA_TARGET_NETNSID]) {
+		const char *pat = ifname && ifname[0] ? ifname : NULL;
 		struct net *net;
 		int new_ifindex;
 
@@ -2612,7 +2613,7 @@ static int do_setlink(const struct sk_buff *skb,
 		else
 			new_ifindex = 0;
 
-		err = __dev_change_net_namespace(dev, net, ifname, new_ifindex);
+		err = __dev_change_net_namespace(dev, net, pat, new_ifindex);
 		put_net(net);
 		if (err)
 			goto errout;
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index a68bf4c6fe9b..ff34cde983d4 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -468,6 +468,8 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
 
 static int gre_handle_offloads(struct sk_buff *skb, bool csum)
 {
+	if (csum && skb_checksum_start(skb) < skb->data)
+		return -EINVAL;
 	return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
 }
 
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 78d1e5afc452..d8811e1fbd6c 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -600,14 +600,14 @@ static struct fib_nh_exception *fnhe_oldest(struct fnhe_hash_bucket *hash)
 	return oldest;
 }
 
-static inline u32 fnhe_hashfun(__be32 daddr)
+static u32 fnhe_hashfun(__be32 daddr)
 {
-	static u32 fnhe_hashrnd __read_mostly;
-	u32 hval;
+	static siphash_key_t fnhe_hash_key __read_mostly;
+	u64 hval;
 
-	net_get_random_once(&fnhe_hashrnd, sizeof(fnhe_hashrnd));
-	hval = jhash_1word((__force u32)daddr, fnhe_hashrnd);
-	return hash_32(hval, FNHE_HASH_SHIFT);
+	net_get_random_once(&fnhe_hash_key, sizeof(fnhe_hash_key));
+	hval = siphash_1u32((__force u32)daddr, &fnhe_hash_key);
+	return hash_64(hval, FNHE_HASH_SHIFT);
 }
 
 static void fill_route_from_fnhe(struct rtable *rt, struct fib_nh_exception *fnhe)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 09e84161b731..67c74469503a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -41,6 +41,7 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 #include <linux/jhash.h>
+#include <linux/siphash.h>
 #include <net/net_namespace.h>
 #include <net/snmp.h>
 #include <net/ipv6.h>
@@ -1484,17 +1485,24 @@ static void rt6_exception_remove_oldest(struct rt6_exception_bucket *bucket)
 static u32 rt6_exception_hash(const struct in6_addr *dst,
 			      const struct in6_addr *src)
 {
-	static u32 seed __read_mostly;
-	u32 val;
+	static siphash_key_t rt6_exception_key __read_mostly;
+	struct {
+		struct in6_addr dst;
+		struct in6_addr src;
+	} __aligned(SIPHASH_ALIGNMENT) combined = {
+		.dst = *dst,
+	};
+	u64 val;
 
-	net_get_random_once(&seed, sizeof(seed));
-	val = jhash2((const u32 *)dst, sizeof(*dst)/sizeof(u32), seed);
+	net_get_random_once(&rt6_exception_key, sizeof(rt6_exception_key));
 
 #ifdef CONFIG_IPV6_SUBTREES
 	if (src)
-		val = jhash2((const u32 *)src, sizeof(*src)/sizeof(u32), val);
+		combined.src = *src;
 #endif
-	return hash_32(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
+	val = siphash(&combined, sizeof(combined), &rt6_exception_key);
+
+	return hash_64(val, FIB6_EXCEPTION_BUCKET_SIZE_SHIFT);
 }
 
 /* Helper function to find the cached rt in the hash table
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index d1bef23fd4f5..dd30c03d5a23 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -132,8 +132,11 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -144,6 +147,10 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	hosts = h->netmask == 32 ? 1 : 2 << (32 - h->netmask - 1);
 
+	/* 64bit division is not allowed on 32bit */
+	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried) {
 		ip = ntohl(h->next.ip);
 		e.ip = htonl(ip);
diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
index 18346d18aa16..153de3457423 100644
--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -121,6 +121,8 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	e.mark = ntohl(nla_get_be32(tb[IPSET_ATTR_MARK]));
 	e.mark &= h->markmask;
+	if (e.mark == 0 && e.ip == 0)
+		return -IPSET_ERR_HASH_ELEM;
 
 	if (adt == IPSET_TEST ||
 	    !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR])) {
@@ -133,8 +135,11 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP_TO], &ip_to);
 		if (ret)
 			return ret;
-		if (ip > ip_to)
+		if (ip > ip_to) {
+			if (e.mark == 0 && ip_to == 0)
+				return -IPSET_ERR_HASH_ELEM;
 			swap(ip, ip_to);
+		}
 	} else if (tb[IPSET_ATTR_CIDR]) {
 		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
@@ -143,6 +148,9 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
+	if (((u64)ip_to - ip + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index e1ca11196515..7303138e46be 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -173,6 +173,9 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index ab179e064597..334fb1ad0e86 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -180,6 +180,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	for (; ip <= ip_to; ip++) {
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 8f075b44cf64..7df94f437f60 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -253,6 +253,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			swap(port, port_to);
 	}
 
+	if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	ip2_to = ip2_from;
 	if (tb[IPSET_ATTR_IP2_TO]) {
 		ret = ip_set_get_hostipaddr4(tb[IPSET_ATTR_IP2_TO], &ip2_to);
diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
index c1a11f041ac6..1422739d9aa2 100644
--- a/net/netfilter/ipset/ip_set_hash_net.c
+++ b/net/netfilter/ipset/ip_set_hash_net.c
@@ -140,7 +140,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_net4_elem e = { .cidr = HOST_MASK };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -188,6 +188,15 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
+
 	if (retried)
 		ip = ntohl(h->next.ip);
 	do {
diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
index ddd51c2e1cb3..9810f5bf63f5 100644
--- a/net/netfilter/ipset/ip_set_hash_netiface.c
+++ b/net/netfilter/ipset/ip_set_hash_netiface.c
@@ -202,7 +202,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netiface4_elem e = { .cidr = HOST_MASK, .elem = 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 ip = 0, ip_to = 0;
+	u32 ip = 0, ip_to = 0, ipn, n = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -256,6 +256,14 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried)
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
index 6532f0505e66..3d09eefe998a 100644
--- a/net/netfilter/ipset/ip_set_hash_netnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netnet.c
@@ -168,7 +168,8 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0;
-	u32 ip2 = 0, ip2_from = 0, ip2_to = 0;
+	u32 ip2 = 0, ip2_from = 0, ip2_to = 0, ipn;
+	u64 n = 0, m = 0;
 	int ret;
 
 	if (tb[IPSET_ATTR_LINENO])
@@ -244,6 +245,19 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index ec1564a1cb5a..09cf72eb37f8 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -158,7 +158,8 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netport4_elem e = { .cidr = HOST_MASK - 1 };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
-	u32 port, port_to, p = 0, ip = 0, ip_to = 0;
+	u32 port, port_to, p = 0, ip = 0, ip_to = 0, ipn;
+	u64 n = 0;
 	bool with_ports = false;
 	u8 cidr;
 	int ret;
@@ -235,6 +236,14 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip, ip_to, e.cidr + 1);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &cidr);
+		n++;
+	} while (ipn++ < ip_to);
+
+	if (n*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip);
diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 0e91d1e82f1c..19bcdb3141f6 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -182,7 +182,8 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2;
+	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
+	u64 n = 0, m = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -284,6 +285,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
+	ipn = ip;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
+		n++;
+	} while (ipn++ < ip_to);
+	ipn = ip2_from;
+	do {
+		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
+		m++;
+	} while (ipn++ < ip2_to);
+
+	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
+		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 69079a382d3a..6ba9f4b8d145 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -68,22 +68,17 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
-	u32			last_bucket;
+	u32			next_bucket;
 	bool			exiting;
 	bool			early_drop;
-	long			next_gc_run;
 };
 
 static __read_mostly struct kmem_cache *nf_conntrack_cachep;
 static DEFINE_SPINLOCK(nf_conntrack_locks_all_lock);
 static __read_mostly bool nf_conntrack_locks_all;
 
-/* every gc cycle scans at most 1/GC_MAX_BUCKETS_DIV part of table */
-#define GC_MAX_BUCKETS_DIV	128u
-/* upper bound of full table scan */
-#define GC_MAX_SCAN_JIFFIES	(16u * HZ)
-/* desired ratio of entries found to be expired */
-#define GC_EVICT_RATIO	50u
+#define GC_SCAN_INTERVAL	(120u * HZ)
+#define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
 
 static struct conntrack_gc_work conntrack_gc_work;
 
@@ -1359,17 +1354,13 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned int min_interval = max(HZ / GC_MAX_BUCKETS_DIV, 1u);
-	unsigned int i, goal, buckets = 0, expired_count = 0;
-	unsigned int nf_conntrack_max95 = 0;
+	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
+	unsigned int i, hashsz, nf_conntrack_max95 = 0;
+	unsigned long next_run = GC_SCAN_INTERVAL;
 	struct conntrack_gc_work *gc_work;
-	unsigned int ratio, scanned = 0;
-	unsigned long next_run;
-
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
-	goal = nf_conntrack_htable_size / GC_MAX_BUCKETS_DIV;
-	i = gc_work->last_bucket;
+	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
@@ -1377,15 +1368,15 @@ static void gc_worker(struct work_struct *work)
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
 		struct hlist_nulls_node *n;
-		unsigned int hashsz;
 		struct nf_conn *tmp;
 
-		i++;
 		rcu_read_lock();
 
 		nf_conntrack_get_ht(&ct_hash, &hashsz);
-		if (i >= hashsz)
-			i = 0;
+		if (i >= hashsz) {
+			rcu_read_unlock();
+			break;
+		}
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
@@ -1393,7 +1384,6 @@ static void gc_worker(struct work_struct *work)
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
 
-			scanned++;
 			if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
 				nf_ct_offload_timeout(tmp);
 				continue;
@@ -1401,7 +1391,6 @@ static void gc_worker(struct work_struct *work)
 
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
-				expired_count++;
 				continue;
 			}
 
@@ -1434,7 +1423,14 @@ static void gc_worker(struct work_struct *work)
 		 */
 		rcu_read_unlock();
 		cond_resched();
-	} while (++buckets < goal);
+		i++;
+
+		if (time_after(jiffies, end_time) && i < hashsz) {
+			gc_work->next_bucket = i;
+			next_run = 0;
+			break;
+		}
+	} while (i < hashsz);
 
 	if (gc_work->exiting)
 		return;
@@ -1445,40 +1441,17 @@ static void gc_worker(struct work_struct *work)
 	 *
 	 * This worker is only here to reap expired entries when system went
 	 * idle after a busy period.
-	 *
-	 * The heuristics below are supposed to balance conflicting goals:
-	 *
-	 * 1. Minimize time until we notice a stale entry
-	 * 2. Maximize scan intervals to not waste cycles
-	 *
-	 * Normally, expire ratio will be close to 0.
-	 *
-	 * As soon as a sizeable fraction of the entries have expired
-	 * increase scan frequency.
 	 */
-	ratio = scanned ? expired_count * 100 / scanned : 0;
-	if (ratio > GC_EVICT_RATIO) {
-		gc_work->next_gc_run = min_interval;
-	} else {
-		unsigned int max = GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV;
-
-		BUILD_BUG_ON((GC_MAX_SCAN_JIFFIES / GC_MAX_BUCKETS_DIV) == 0);
-
-		gc_work->next_gc_run += min_interval;
-		if (gc_work->next_gc_run > max)
-			gc_work->next_gc_run = max;
+	if (next_run) {
+		gc_work->early_drop = false;
+		gc_work->next_bucket = 0;
 	}
-
-	next_run = gc_work->next_gc_run;
-	gc_work->last_bucket = i;
-	gc_work->early_drop = false;
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
 	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
-	gc_work->next_gc_run = HZ;
 	gc_work->exiting = false;
 }
 
diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 67993bcfecde..52b7f6490d24 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 	}
 
-	if (len != ALIGN(size, 4) + hdrlen)
+	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
index 9b6ffff72f2d..28c1b0022178 100644
--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -131,9 +131,9 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
 		cpu_relax();
 	}
 
-	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_len,
+	ret = ib_map_mr_sg_zbva(frmr->mr, ibmr->sg, ibmr->sg_dma_len,
 				&off, PAGE_SIZE);
-	if (unlikely(ret != ibmr->sg_len))
+	if (unlikely(ret != ibmr->sg_dma_len))
 		return ret < 0 ? ret : -EINVAL;
 
 	if (cmpxchg(&frmr->fr_state,
diff --git a/net/sched/sch_ets.c b/net/sched/sch_ets.c
index c1e84d1eeaba..c76701ac35ab 100644
--- a/net/sched/sch_ets.c
+++ b/net/sched/sch_ets.c
@@ -660,6 +660,13 @@ static int ets_qdisc_change(struct Qdisc *sch, struct nlattr *opt,
 	sch_tree_lock(sch);
 
 	q->nbands = nbands;
+	for (i = nstrict; i < q->nstrict; i++) {
+		INIT_LIST_HEAD(&q->classes[i].alist);
+		if (q->classes[i].qdisc->q.qlen) {
+			list_add_tail(&q->classes[i].alist, &q->active);
+			q->classes[i].deficit = quanta[i];
+		}
+	}
 	q->nstrict = nstrict;
 	memcpy(q->prio2band, priomap, sizeof(priomap));
 
diff --git a/net/socket.c b/net/socket.c
index 4f2c6d2795d0..877f1fb61719 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1054,7 +1054,7 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 		rtnl_unlock();
 		if (!err && copy_to_user(argp, &ifc, sizeof(struct ifconf)))
 			err = -EFAULT;
-	} else {
+	} else if (is_socket_ioctl_cmd(cmd)) {
 		struct ifreq ifr;
 		bool need_copyout;
 		if (copy_from_user(&ifr, argp, sizeof(struct ifreq)))
@@ -1063,6 +1063,8 @@ static long sock_do_ioctl(struct net *net, struct socket *sock,
 		if (!err && need_copyout)
 			if (copy_to_user(argp, &ifr, sizeof(struct ifreq)))
 				return -EFAULT;
+	} else {
+		err = -ENOTTY;
 	}
 	return err;
 }
@@ -3251,6 +3253,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
 	struct ifreq ifreq;
 	u32 data32;
 
+	if (!is_socket_ioctl_cmd(cmd))
+		return -ENOTTY;
 	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
 		return -EFAULT;
 	if (get_user(data32, &u_ifreq32->ifr_data))
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index d66a8e44a1ae..dbb41821b1b8 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -835,7 +835,8 @@ static int svc_handle_xprt(struct svc_rqst *rqstp, struct svc_xprt *xprt)
 		rqstp->rq_stime = ktime_get();
 		rqstp->rq_reserved = serv->sv_max_mesg;
 		atomic_add(rqstp->rq_reserved, &xprt->xpt_reserved);
-	}
+	} else
+		svc_xprt_received(xprt);
 out:
 	trace_svc_handle_xprt(xprt, len);
 	return len;
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 9bdc5147a65a..a0dce194a404 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1528,7 +1528,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 
 	if (unlikely(syn && !rc)) {
 		tipc_set_sk_state(sk, TIPC_CONNECTING);
-		if (timeout) {
+		if (dlen && timeout) {
 			timeout = msecs_to_jiffies(timeout);
 			tipc_wait_for_connect(sock, &timeout);
 		}
diff --git a/sound/soc/codecs/rt5682.c b/sound/soc/codecs/rt5682.c
index abcd6f483788..51ecaa2abcd1 100644
--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -44,6 +44,7 @@ static const struct reg_sequence patch_list[] = {
 	{RT5682_I2C_CTRL, 0x000f},
 	{RT5682_PLL2_INTERNAL, 0x8266},
 	{RT5682_SAR_IL_CMD_3, 0x8365},
+	{RT5682_SAR_IL_CMD_6, 0x0180},
 };
 
 void rt5682_apply_patch_list(struct rt5682_priv *rt5682, struct device *dev)
diff --git a/sound/soc/soc-component.c b/sound/soc/soc-component.c
index 3a5e84e16a87..c8dfd0de30e4 100644
--- a/sound/soc/soc-component.c
+++ b/sound/soc/soc-component.c
@@ -148,86 +148,75 @@ int snd_soc_component_set_bias_level(struct snd_soc_component *component,
 	return soc_component_ret(component, ret);
 }
 
-static int soc_component_pin(struct snd_soc_component *component,
-			     const char *pin,
-			     int (*pin_func)(struct snd_soc_dapm_context *dapm,
-					     const char *pin))
-{
-	struct snd_soc_dapm_context *dapm =
-		snd_soc_component_get_dapm(component);
-	char *full_name;
-	int ret;
-
-	if (!component->name_prefix) {
-		ret = pin_func(dapm, pin);
-		goto end;
-	}
-
-	full_name = kasprintf(GFP_KERNEL, "%s %s", component->name_prefix, pin);
-	if (!full_name) {
-		ret = -ENOMEM;
-		goto end;
-	}
-
-	ret = pin_func(dapm, full_name);
-	kfree(full_name);
-end:
-	return soc_component_ret(component, ret);
-}
-
 int snd_soc_component_enable_pin(struct snd_soc_component *component,
 				 const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_enable_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_enable_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_enable_pin);
 
 int snd_soc_component_enable_pin_unlocked(struct snd_soc_component *component,
 					  const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_enable_pin_unlocked);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_enable_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_enable_pin_unlocked);
 
 int snd_soc_component_disable_pin(struct snd_soc_component *component,
 				  const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_disable_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_disable_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_disable_pin);
 
 int snd_soc_component_disable_pin_unlocked(struct snd_soc_component *component,
 					   const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_disable_pin_unlocked);
+	struct snd_soc_dapm_context *dapm = 
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_disable_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_disable_pin_unlocked);
 
 int snd_soc_component_nc_pin(struct snd_soc_component *component,
 			     const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_nc_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_nc_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_nc_pin);
 
 int snd_soc_component_nc_pin_unlocked(struct snd_soc_component *component,
 				      const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_nc_pin_unlocked);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_nc_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_nc_pin_unlocked);
 
 int snd_soc_component_get_pin_status(struct snd_soc_component *component,
 				     const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_get_pin_status);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_get_pin_status(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_get_pin_status);
 
 int snd_soc_component_force_enable_pin(struct snd_soc_component *component,
 				       const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_force_enable_pin);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_force_enable_pin(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_force_enable_pin);
 
@@ -235,7 +224,9 @@ int snd_soc_component_force_enable_pin_unlocked(
 	struct snd_soc_component *component,
 	const char *pin)
 {
-	return soc_component_pin(component, pin, snd_soc_dapm_force_enable_pin_unlocked);
+	struct snd_soc_dapm_context *dapm =
+		snd_soc_component_get_dapm(component);
+	return snd_soc_dapm_force_enable_pin_unlocked(dapm, pin);
 }
 EXPORT_SYMBOL_GPL(snd_soc_component_force_enable_pin_unlocked);
 
diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
index b587b9a7a124..0d7bbe49359d 100644
--- a/tools/virtio/Makefile
+++ b/tools/virtio/Makefile
@@ -4,7 +4,8 @@ test: virtio_test vringh_test
 virtio_test: virtio_ring.o virtio_test.o
 vringh_test: vringh_test.o vringh.o virtio_ring.o
 
-CFLAGS += -g -O2 -Werror -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
+CFLAGS += -g -O2 -Werror -Wno-maybe-uninitialized -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -include ../../include/linux/kconfig.h
+LDFLAGS += -lpthread
 vpath %.c ../../drivers/virtio ../../drivers/vhost
 mod:
 	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test V=${V}
diff --git a/tools/virtio/linux/spinlock.h b/tools/virtio/linux/spinlock.h
new file mode 100644
index 000000000000..028e3cdcc5d3
--- /dev/null
+++ b/tools/virtio/linux/spinlock.h
@@ -0,0 +1,56 @@
+#ifndef SPINLOCK_H_STUB
+#define SPINLOCK_H_STUB
+
+#include <pthread.h>
+
+typedef pthread_spinlock_t  spinlock_t;
+
+static inline void spin_lock_init(spinlock_t *lock)
+{
+	int r = pthread_spin_init(lock, 0);
+	assert(!r);
+}
+
+static inline void spin_lock(spinlock_t *lock)
+{
+	int ret = pthread_spin_lock(lock);
+	assert(!ret);
+}
+
+static inline void spin_unlock(spinlock_t *lock)
+{
+	int ret = pthread_spin_unlock(lock);
+	assert(!ret);
+}
+
+static inline void spin_lock_bh(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_bh(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static inline void spin_lock_irq(spinlock_t *lock)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_irq(spinlock_t *lock)
+{
+	spin_unlock(lock);
+}
+
+static inline void spin_lock_irqsave(spinlock_t *lock, unsigned long f)
+{
+	spin_lock(lock);
+}
+
+static inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned long f)
+{
+	spin_unlock(lock);
+}
+
+#endif
diff --git a/tools/virtio/linux/virtio.h b/tools/virtio/linux/virtio.h
index 5d90254ddae4..363b98228301 100644
--- a/tools/virtio/linux/virtio.h
+++ b/tools/virtio/linux/virtio.h
@@ -3,6 +3,7 @@
 #define LINUX_VIRTIO_H
 #include <linux/scatterlist.h>
 #include <linux/kernel.h>
+#include <linux/spinlock.h>
 
 struct device {
 	void *parent;
@@ -12,6 +13,7 @@ struct virtio_device {
 	struct device dev;
 	u64 features;
 	struct list_head vqs;
+	spinlock_t vqs_list_lock;
 };
 
 struct virtqueue {
