Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3786F5852D9
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiG2PiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237540AbiG2PhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:37:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A918586C38;
        Fri, 29 Jul 2022 08:37:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5BEE61D14;
        Fri, 29 Jul 2022 15:37:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013DFC433C1;
        Fri, 29 Jul 2022 15:37:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659109033;
        bh=FZ1sF5+KfNG4xjnEC/7KeV7kT4x311GLlEof4plX96A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fd0Tg8SxmJf8EiTP5qd4/4pZ/6n4UE6fmymJ5e24QXCPDlx5cPuAT/jbBcnQaxzH/
         Wrb75eUQS+G90ylKcFZCXP3XHEgFiR+2PXRT0RjuJdTH7bwwlP6c4xWNBhrATQdi4k
         5UHKEgNIkBYOq2JAFIH5CU7/0rMDvlh0/O2MpVH8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.58
Date:   Fri, 29 Jul 2022 17:37:01 +0200
Message-Id: <165910902032118@kroah.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <165910902019237@kroah.com>
References: <165910902019237@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 5e795202111f..f4804ce37c58 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -948,7 +948,7 @@ how much memory needs to be free before kswapd goes back to sleep.
 
 The unit is in fractions of 10,000. The default value of 10 means the
 distances between watermarks are 0.1% of the available memory in the
-node/system. The maximum value is 1000, or 10% of memory.
+node/system. The maximum value is 3000, or 30% of memory.
 
 A high rate of threads entering direct reclaim (allocstall) or kswapd
 going to sleep prematurely (kswapd_low_wmark_hit_quickly) can indicate
diff --git a/Makefile b/Makefile
index 69bfff4d9c2d..d7ba0de250cb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 57
+SUBLEVEL = 58
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 90635ef5dafa..6dc952b0df4a 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -59,7 +59,7 @@ srmcons_do_receive_chars(struct tty_port *port)
 	} while((result.bits.status & 1) && (++loops < 10));
 
 	if (count)
-		tty_schedule_flip(port);
+		tty_flip_buffer_push(port);
 
 	return count;
 }
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index e03f45f7711a..583e1ff0c0bf 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -75,6 +75,7 @@ ifeq ($(CONFIG_PERF_EVENTS),y)
 endif
 
 KBUILD_CFLAGS_MODULE += $(call cc-option,-mno-relax)
+KBUILD_AFLAGS_MODULE += $(call as-option,-Wa$(comma)-mno-relax)
 
 # GCC versions that support the "-mstrict-align" option default to allowing
 # unaligned accesses.  While unaligned accesses are explicitly allowed in the
diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 7755cb4ff9fc..82ff3785bf69 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -21,6 +21,7 @@
  * Based on Virtio MMIO driver by Pawel Moll, copyright 2011-2014, ARM Ltd.
  */
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/virtio.h>
@@ -49,6 +50,7 @@ struct virtio_uml_platform_data {
 struct virtio_uml_device {
 	struct virtio_device vdev;
 	struct platform_device *pdev;
+	struct virtio_uml_platform_data *pdata;
 
 	spinlock_t sock_lock;
 	int sock, req_fd, irq;
@@ -61,6 +63,7 @@ struct virtio_uml_device {
 
 	u8 config_changed_irq:1;
 	uint64_t vq_irq_vq_map;
+	int recv_rc;
 };
 
 struct virtio_uml_vq_info {
@@ -146,14 +149,6 @@ static int vhost_user_recv(struct virtio_uml_device *vu_dev,
 
 	rc = vhost_user_recv_header(fd, msg);
 
-	if (rc == -ECONNRESET && vu_dev->registered) {
-		struct virtio_uml_platform_data *pdata;
-
-		pdata = vu_dev->pdev->dev.platform_data;
-
-		virtio_break_device(&vu_dev->vdev);
-		schedule_work(&pdata->conn_broken_wk);
-	}
 	if (rc)
 		return rc;
 	size = msg->header.size;
@@ -162,6 +157,21 @@ static int vhost_user_recv(struct virtio_uml_device *vu_dev,
 	return full_read(fd, &msg->payload, size, false);
 }
 
+static void vhost_user_check_reset(struct virtio_uml_device *vu_dev,
+				   int rc)
+{
+	struct virtio_uml_platform_data *pdata = vu_dev->pdata;
+
+	if (rc != -ECONNRESET)
+		return;
+
+	if (!vu_dev->registered)
+		return;
+
+	virtio_break_device(&vu_dev->vdev);
+	schedule_work(&pdata->conn_broken_wk);
+}
+
 static int vhost_user_recv_resp(struct virtio_uml_device *vu_dev,
 				struct vhost_user_msg *msg,
 				size_t max_payload_size)
@@ -169,8 +179,10 @@ static int vhost_user_recv_resp(struct virtio_uml_device *vu_dev,
 	int rc = vhost_user_recv(vu_dev, vu_dev->sock, msg,
 				 max_payload_size, true);
 
-	if (rc)
+	if (rc) {
+		vhost_user_check_reset(vu_dev, rc);
 		return rc;
+	}
 
 	if (msg->header.flags != (VHOST_USER_FLAG_REPLY | VHOST_USER_VERSION))
 		return -EPROTO;
@@ -367,6 +379,7 @@ static irqreturn_t vu_req_read_message(struct virtio_uml_device *vu_dev,
 				 sizeof(msg.msg.payload) +
 				 sizeof(msg.extra_payload));
 
+	vu_dev->recv_rc = rc;
 	if (rc)
 		return IRQ_NONE;
 
@@ -410,7 +423,9 @@ static irqreturn_t vu_req_interrupt(int irq, void *data)
 	if (!um_irq_timetravel_handler_used())
 		ret = vu_req_read_message(vu_dev, NULL);
 
-	if (vu_dev->vq_irq_vq_map) {
+	if (vu_dev->recv_rc) {
+		vhost_user_check_reset(vu_dev, vu_dev->recv_rc);
+	} else if (vu_dev->vq_irq_vq_map) {
 		struct virtqueue *vq;
 
 		virtio_device_for_each_vq((&vu_dev->vdev), vq) {
@@ -1115,21 +1130,63 @@ void virtio_uml_set_no_vq_suspend(struct virtio_device *vdev,
 		 no_vq_suspend ? "dis" : "en");
 }
 
+static void vu_of_conn_broken(struct work_struct *wk)
+{
+	/*
+	 * We can't remove the device from the devicetree so the only thing we
+	 * can do is warn.
+	 */
+	WARN_ON(1);
+}
+
 /* Platform device */
 
+static struct virtio_uml_platform_data *
+virtio_uml_create_pdata(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct virtio_uml_platform_data *pdata;
+	int ret;
+
+	if (!np)
+		return ERR_PTR(-EINVAL);
+
+	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_WORK(&pdata->conn_broken_wk, vu_of_conn_broken);
+	pdata->pdev = pdev;
+
+	ret = of_property_read_string(np, "socket-path", &pdata->socket_path);
+	if (ret)
+		return ERR_PTR(ret);
+
+	ret = of_property_read_u32(np, "virtio-device-id",
+				   &pdata->virtio_device_id);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return pdata;
+}
+
 static int virtio_uml_probe(struct platform_device *pdev)
 {
 	struct virtio_uml_platform_data *pdata = pdev->dev.platform_data;
 	struct virtio_uml_device *vu_dev;
 	int rc;
 
-	if (!pdata)
-		return -EINVAL;
+	if (!pdata) {
+		pdata = virtio_uml_create_pdata(pdev);
+		if (IS_ERR(pdata))
+			return PTR_ERR(pdata);
+	}
 
 	vu_dev = kzalloc(sizeof(*vu_dev), GFP_KERNEL);
 	if (!vu_dev)
 		return -ENOMEM;
 
+	vu_dev->pdata = pdata;
 	vu_dev->vdev.dev.parent = &pdev->dev;
 	vu_dev->vdev.dev.release = virtio_uml_release_dev;
 	vu_dev->vdev.config = &virtio_uml_config_ops;
diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 5bd3baf36d87..6b44263d7efb 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -268,19 +268,16 @@
 1:	popl	%ds
 2:	popl	%es
 3:	popl	%fs
-	addl	$(4 + \pop), %esp	/* pop the unused "gs" slot */
+4:	addl	$(4 + \pop), %esp	/* pop the unused "gs" slot */
 	IRET_FRAME
-.pushsection .fixup, "ax"
-4:	movl	$0, (%esp)
-	jmp	1b
-5:	movl	$0, (%esp)
-	jmp	2b
-6:	movl	$0, (%esp)
-	jmp	3b
-.popsection
-	_ASM_EXTABLE(1b, 4b)
-	_ASM_EXTABLE(2b, 5b)
-	_ASM_EXTABLE(3b, 6b)
+
+	/*
+	 * There is no _ASM_EXTABLE_TYPE_REG() for ASM, however since this is
+	 * ASM the registers are known and we can trivially hard-code them.
+	 */
+	_ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_POP_ZERO|EX_REG_DS)
+	_ASM_EXTABLE_TYPE(2b, 3b, EX_TYPE_POP_ZERO|EX_REG_ES)
+	_ASM_EXTABLE_TYPE(3b, 4b, EX_TYPE_POP_ZERO|EX_REG_FS)
 .endm
 
 .macro RESTORE_ALL_NMI cr3_reg:req pop=0
@@ -923,10 +920,8 @@ SYM_FUNC_START(entry_SYSENTER_32)
 	sti
 	sysexit
 
-.pushsection .fixup, "ax"
-2:	movl	$0, PT_FS(%esp)
-	jmp	1b
-.popsection
+2:	movl    $0, PT_FS(%esp)
+	jmp     1b
 	_ASM_EXTABLE(1b, 2b)
 
 .Lsysenter_fix_flags:
@@ -994,8 +989,7 @@ restore_all_switch_stack:
 	 */
 	iret
 
-.section .fixup, "ax"
-SYM_CODE_START(asm_iret_error)
+.Lasm_iret_error:
 	pushl	$0				# no error code
 	pushl	$iret_error
 
@@ -1012,9 +1006,8 @@ SYM_CODE_START(asm_iret_error)
 #endif
 
 	jmp	handle_exception
-SYM_CODE_END(asm_iret_error)
-.previous
-	_ASM_EXTABLE(.Lirq_return, asm_iret_error)
+
+	_ASM_EXTABLE(.Lirq_return, .Lasm_iret_error)
 SYM_FUNC_END(entry_INT80_32)
 
 .macro FIXUP_ESPFIX_STACK
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 3ad3da9a7d97..6dd47c9ec788 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -122,28 +122,19 @@
 
 #ifdef __KERNEL__
 
+# include <asm/extable_fixup_types.h>
+
 /* Exception table entry */
 #ifdef __ASSEMBLY__
-# define _ASM_EXTABLE_HANDLE(from, to, handler)			\
+
+# define _ASM_EXTABLE_TYPE(from, to, type)			\
 	.pushsection "__ex_table","a" ;				\
 	.balign 4 ;						\
 	.long (from) - . ;					\
 	.long (to) - . ;					\
-	.long (handler) - . ;					\
+	.long type ;						\
 	.popsection
 
-# define _ASM_EXTABLE(from, to)					\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_default)
-
-# define _ASM_EXTABLE_UA(from, to)				\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_uaccess)
-
-# define _ASM_EXTABLE_CPY(from, to)				\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_copy)
-
-# define _ASM_EXTABLE_FAULT(from, to)				\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_fault)
-
 # ifdef CONFIG_KPROBES
 #  define _ASM_NOKPROBE(entry)					\
 	.pushsection "_kprobe_blacklist","aw" ;			\
@@ -155,26 +146,51 @@
 # endif
 
 #else /* ! __ASSEMBLY__ */
-# define _EXPAND_EXTABLE_HANDLE(x) #x
-# define _ASM_EXTABLE_HANDLE(from, to, handler)			\
+
+# define DEFINE_EXTABLE_TYPE_REG \
+	".macro extable_type_reg type:req reg:req\n"						\
+	".set .Lfound, 0\n"									\
+	".set .Lregnr, 0\n"									\
+	".irp rs,rax,rcx,rdx,rbx,rsp,rbp,rsi,rdi,r8,r9,r10,r11,r12,r13,r14,r15\n"		\
+	".ifc \\reg, %%\\rs\n"									\
+	".set .Lfound, .Lfound+1\n"								\
+	".long \\type + (.Lregnr << 8)\n"							\
+	".endif\n"										\
+	".set .Lregnr, .Lregnr+1\n"								\
+	".endr\n"										\
+	".set .Lregnr, 0\n"									\
+	".irp rs,eax,ecx,edx,ebx,esp,ebp,esi,edi,r8d,r9d,r10d,r11d,r12d,r13d,r14d,r15d\n"	\
+	".ifc \\reg, %%\\rs\n"									\
+	".set .Lfound, .Lfound+1\n"								\
+	".long \\type + (.Lregnr << 8)\n"							\
+	".endif\n"										\
+	".set .Lregnr, .Lregnr+1\n"								\
+	".endr\n"										\
+	".if (.Lfound != 1)\n"									\
+	".error \"extable_type_reg: bad register argument\"\n"					\
+	".endif\n"										\
+	".endm\n"
+
+# define UNDEFINE_EXTABLE_TYPE_REG \
+	".purgem extable_type_reg\n"
+
+# define _ASM_EXTABLE_TYPE(from, to, type)			\
 	" .pushsection \"__ex_table\",\"a\"\n"			\
 	" .balign 4\n"						\
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - .\n"				\
-	" .long (" _EXPAND_EXTABLE_HANDLE(handler) ") - .\n"	\
+	" .long " __stringify(type) " \n"			\
 	" .popsection\n"
 
-# define _ASM_EXTABLE(from, to)					\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_default)
-
-# define _ASM_EXTABLE_UA(from, to)				\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_uaccess)
-
-# define _ASM_EXTABLE_CPY(from, to)				\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_copy)
-
-# define _ASM_EXTABLE_FAULT(from, to)				\
-	_ASM_EXTABLE_HANDLE(from, to, ex_handler_fault)
+# define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
+	" .pushsection \"__ex_table\",\"a\"\n"					\
+	" .balign 4\n"								\
+	" .long (" #from ") - .\n"						\
+	" .long (" #to ") - .\n"						\
+	DEFINE_EXTABLE_TYPE_REG							\
+	"extable_type_reg reg=" __stringify(reg) ", type=" __stringify(type) " \n"\
+	UNDEFINE_EXTABLE_TYPE_REG						\
+	" .popsection\n"
 
 /* For C file, we already have NOKPROBE_SYMBOL macro */
 
@@ -188,6 +204,17 @@ register unsigned long current_stack_pointer asm(_ASM_SP);
 #define ASM_CALL_CONSTRAINT "+r" (current_stack_pointer)
 #endif /* __ASSEMBLY__ */
 
-#endif /* __KERNEL__ */
+#define _ASM_EXTABLE(from, to)					\
+	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_DEFAULT)
 
+#define _ASM_EXTABLE_UA(from, to)				\
+	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_UACCESS)
+
+#define _ASM_EXTABLE_CPY(from, to)				\
+	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_COPY)
+
+#define _ASM_EXTABLE_FAULT(from, to)				\
+	_ASM_EXTABLE_TYPE(from, to, EX_TYPE_FAULT)
+
+#endif /* __KERNEL__ */
 #endif /* _ASM_X86_ASM_H */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 3781a7f489ef..d370718e222b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -300,6 +300,7 @@
 #define X86_FEATURE_RETPOLINE_LFENCE	(11*32+13) /* "" Use LFENCE for Spectre variant 2 */
 #define X86_FEATURE_RETHUNK		(11*32+14) /* "" Use REturn THUNK */
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
+#define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/include/asm/extable.h b/arch/x86/include/asm/extable.h
index 1f0cbc52937c..155c991ba95e 100644
--- a/arch/x86/include/asm/extable.h
+++ b/arch/x86/include/asm/extable.h
@@ -1,12 +1,18 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _ASM_X86_EXTABLE_H
 #define _ASM_X86_EXTABLE_H
+
+#include <asm/extable_fixup_types.h>
+
 /*
- * The exception table consists of triples of addresses relative to the
- * exception table entry itself. The first address is of an instruction
- * that is allowed to fault, the second is the target at which the program
- * should continue. The third is a handler function to deal with the fault
- * caused by the instruction in the first field.
+ * The exception table consists of two addresses relative to the
+ * exception table entry itself and a type selector field.
+ *
+ * The first address is of an instruction that is allowed to fault, the
+ * second is the target at which the program should continue.
+ *
+ * The type entry is used by fixup_exception() to select the handler to
+ * deal with the fault caused by the instruction in the first field.
  *
  * All the routines below use bits of fixup code that are out of line
  * with the main instruction path.  This means when everything is well,
@@ -15,7 +21,7 @@
  */
 
 struct exception_table_entry {
-	int insn, fixup, handler;
+	int insn, fixup, data;
 };
 struct pt_regs;
 
@@ -25,21 +31,27 @@ struct pt_regs;
 	do {							\
 		(a)->fixup = (b)->fixup + (delta);		\
 		(b)->fixup = (tmp).fixup - (delta);		\
-		(a)->handler = (b)->handler + (delta);		\
-		(b)->handler = (tmp).handler - (delta);		\
+		(a)->data = (b)->data;				\
+		(b)->data = (tmp).data;				\
 	} while (0)
 
-enum handler_type {
-	EX_HANDLER_NONE,
-	EX_HANDLER_FAULT,
-	EX_HANDLER_UACCESS,
-	EX_HANDLER_OTHER
-};
-
 extern int fixup_exception(struct pt_regs *regs, int trapnr,
 			   unsigned long error_code, unsigned long fault_addr);
 extern int fixup_bug(struct pt_regs *regs, int trapnr);
-extern enum handler_type ex_get_fault_handler_type(unsigned long ip);
+extern int ex_get_fixup_type(unsigned long ip);
 extern void early_fixup_exception(struct pt_regs *regs, int trapnr);
 
+#ifdef CONFIG_X86_MCE
+extern void ex_handler_msr_mce(struct pt_regs *regs, bool wrmsr);
+#else
+static inline void ex_handler_msr_mce(struct pt_regs *regs, bool wrmsr) { }
+#endif
+
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_X86_64)
+bool ex_handler_bpf(const struct exception_table_entry *x, struct pt_regs *regs);
+#else
+static inline bool ex_handler_bpf(const struct exception_table_entry *x,
+				  struct pt_regs *regs) { return false; }
+#endif
+
 #endif
diff --git a/arch/x86/include/asm/extable_fixup_types.h b/arch/x86/include/asm/extable_fixup_types.h
new file mode 100644
index 000000000000..b3b785b9bb14
--- /dev/null
+++ b/arch/x86/include/asm/extable_fixup_types.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_EXTABLE_FIXUP_TYPES_H
+#define _ASM_X86_EXTABLE_FIXUP_TYPES_H
+
+/*
+ * Our IMM is signed, as such it must live at the top end of the word. Also,
+ * since C99 hex constants are of ambigious type, force cast the mask to 'int'
+ * so that FIELD_GET() will DTRT and sign extend the value when it extracts it.
+ */
+#define EX_DATA_TYPE_MASK		((int)0x000000FF)
+#define EX_DATA_REG_MASK		((int)0x00000F00)
+#define EX_DATA_FLAG_MASK		((int)0x0000F000)
+#define EX_DATA_IMM_MASK		((int)0xFFFF0000)
+
+#define EX_DATA_REG_SHIFT		8
+#define EX_DATA_FLAG_SHIFT		12
+#define EX_DATA_IMM_SHIFT		16
+
+#define EX_DATA_REG(reg)		((reg) << EX_DATA_REG_SHIFT)
+#define EX_DATA_FLAG(flag)		((flag) << EX_DATA_FLAG_SHIFT)
+#define EX_DATA_IMM(imm)		((imm) << EX_DATA_IMM_SHIFT)
+
+/* segment regs */
+#define EX_REG_DS			EX_DATA_REG(8)
+#define EX_REG_ES			EX_DATA_REG(9)
+#define EX_REG_FS			EX_DATA_REG(10)
+#define EX_REG_GS			EX_DATA_REG(11)
+
+/* flags */
+#define EX_FLAG_CLEAR_AX		EX_DATA_FLAG(1)
+#define EX_FLAG_CLEAR_DX		EX_DATA_FLAG(2)
+#define EX_FLAG_CLEAR_AX_DX		EX_DATA_FLAG(3)
+
+/* types */
+#define	EX_TYPE_NONE			 0
+#define	EX_TYPE_DEFAULT			 1
+#define	EX_TYPE_FAULT			 2
+#define	EX_TYPE_UACCESS			 3
+#define	EX_TYPE_COPY			 4
+#define	EX_TYPE_CLEAR_FS		 5
+#define	EX_TYPE_FPU_RESTORE		 6
+#define	EX_TYPE_BPF			 7
+#define	EX_TYPE_WRMSR			 8
+#define	EX_TYPE_RDMSR			 9
+#define	EX_TYPE_WRMSR_SAFE		10 /* reg := -EIO */
+#define	EX_TYPE_RDMSR_SAFE		11 /* reg := -EIO */
+#define	EX_TYPE_WRMSR_IN_MCE		12
+#define	EX_TYPE_RDMSR_IN_MCE		13
+#define	EX_TYPE_DEFAULT_MCE_SAFE	14
+#define	EX_TYPE_FAULT_MCE_SAFE		15
+
+#define	EX_TYPE_POP_REG			16 /* sp += sizeof(long) */
+#define EX_TYPE_POP_ZERO		(EX_TYPE_POP_REG | EX_DATA_IMM(0))
+
+#define	EX_TYPE_IMM_REG			17 /* reg := (long)imm */
+#define	EX_TYPE_EFAULT_REG		(EX_TYPE_IMM_REG | EX_DATA_IMM(-EFAULT))
+
+#endif
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 5a18694a89b2..ce6fc4f8d1d1 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -126,7 +126,7 @@ extern void save_fpregs_to_fpstate(struct fpu *fpu);
 #define kernel_insn(insn, output, input...)				\
 	asm volatile("1:" #insn "\n\t"					\
 		     "2:\n"						\
-		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_fprestore)	\
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FPU_RESTORE)	\
 		     : output : input)
 
 static inline int fnsave_to_user_sigframe(struct fregs_state __user *fx)
@@ -253,7 +253,7 @@ static inline void fxsave(struct fxregs_state *fx)
 				 XRSTORS, X86_FEATURE_XSAVES)		\
 		     "\n"						\
 		     "3:\n"						\
-		     _ASM_EXTABLE_HANDLE(661b, 3b, ex_handler_fprestore)\
+		     _ASM_EXTABLE_TYPE(661b, 3b, EX_TYPE_FPU_RESTORE)	\
 		     :							\
 		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
 		     : "memory")
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index f9c00110a69a..99d345b686fa 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -17,13 +17,9 @@ do {								\
 	int oldval = 0, ret;					\
 	asm volatile("1:\t" insn "\n"				\
 		     "2:\n"					\
-		     "\t.section .fixup,\"ax\"\n"		\
-		     "3:\tmov\t%3, %1\n"			\
-		     "\tjmp\t2b\n"				\
-		     "\t.previous\n"				\
-		     _ASM_EXTABLE_UA(1b, 3b)			\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %1) \
 		     : "=r" (oldval), "=r" (ret), "+m" (*uaddr)	\
-		     : "i" (-EFAULT), "0" (oparg), "1" (0));	\
+		     : "0" (oparg), "1" (0));	\
 	if (ret)						\
 		goto label;					\
 	*oval = oldval;						\
@@ -39,15 +35,11 @@ do {								\
 		     "3:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"	\
 		     "\tjnz\t2b\n"				\
 		     "4:\n"					\
-		     "\t.section .fixup,\"ax\"\n"		\
-		     "5:\tmov\t%5, %1\n"			\
-		     "\tjmp\t4b\n"				\
-		     "\t.previous\n"				\
-		     _ASM_EXTABLE_UA(1b, 5b)			\
-		     _ASM_EXTABLE_UA(3b, 5b)			\
+		     _ASM_EXTABLE_TYPE_REG(1b, 4b, EX_TYPE_EFAULT_REG, %1) \
+		     _ASM_EXTABLE_TYPE_REG(3b, 4b, EX_TYPE_EFAULT_REG, %1) \
 		     : "=&a" (oldval), "=&r" (ret),		\
 		       "+m" (*uaddr), "=&r" (tem)		\
-		     : "r" (oparg), "i" (-EFAULT), "1" (0));	\
+		     : "r" (oparg), "1" (0));			\
 	if (ret)						\
 		goto label;					\
 	*oval = oldval;						\
@@ -95,15 +87,11 @@ static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
 	if (!user_access_begin(uaddr, sizeof(u32)))
 		return -EFAULT;
 	asm volatile("\n"
-		"1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
+		"1:\t" LOCK_PREFIX "cmpxchgl %3, %2\n"
 		"2:\n"
-		"\t.section .fixup, \"ax\"\n"
-		"3:\tmov     %3, %0\n"
-		"\tjmp     2b\n"
-		"\t.previous\n"
-		_ASM_EXTABLE_UA(1b, 3b)
+		_ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %0) \
 		: "+r" (ret), "=a" (oldval), "+m" (*uaddr)
-		: "i" (-EFAULT), "r" (newval), "1" (oldval)
+		: "r" (newval), "1" (oldval)
 		: "memory"
 	);
 	user_access_end();
diff --git a/arch/x86/include/asm/insn-eval.h b/arch/x86/include/asm/insn-eval.h
index 4ec3613551e3..3df123f437c9 100644
--- a/arch/x86/include/asm/insn-eval.h
+++ b/arch/x86/include/asm/insn-eval.h
@@ -15,6 +15,8 @@
 #define INSN_CODE_SEG_OPND_SZ(params) (params & 0xf)
 #define INSN_CODE_SEG_PARAMS(oper_sz, addr_sz) (oper_sz | (addr_sz << 4))
 
+int pt_regs_offset(struct pt_regs *regs, int regno);
+
 bool insn_has_rep_prefix(struct insn *insn);
 void __user *insn_get_addr_ref(struct insn *insn, struct pt_regs *regs);
 int insn_get_modrm_rm_off(struct insn *insn, struct pt_regs *regs);
diff --git a/arch/x86/include/asm/mshyperv.h b/arch/x86/include/asm/mshyperv.h
index adccbc209169..c2b9ab94408e 100644
--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -176,13 +176,6 @@ bool hv_vcpu_is_preempted(int vcpu);
 static inline void hv_apic_init(void) {}
 #endif
 
-static inline void hv_set_msi_entry_from_desc(union hv_msi_entry *msi_entry,
-					      struct msi_desc *msi_desc)
-{
-	msi_entry->address.as_uint32 = msi_desc->msg.address_lo;
-	msi_entry->data.as_uint32 = msi_desc->msg.data;
-}
-
 struct irq_domain *hv_create_pci_msi_domain(void);
 
 int hv_map_ioapic_interrupt(int ioapic_id, bool level, int vcpu, int vector,
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index a3f87f1015d3..d42e6c6b47b1 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -92,7 +92,7 @@ static __always_inline unsigned long long __rdmsr(unsigned int msr)
 
 	asm volatile("1: rdmsr\n"
 		     "2:\n"
-		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_rdmsr_unsafe)
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_RDMSR)
 		     : EAX_EDX_RET(val, low, high) : "c" (msr));
 
 	return EAX_EDX_VAL(val, low, high);
@@ -102,7 +102,7 @@ static __always_inline void __wrmsr(unsigned int msr, u32 low, u32 high)
 {
 	asm volatile("1: wrmsr\n"
 		     "2:\n"
-		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_wrmsr_unsafe)
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR)
 		     : : "c" (msr), "a"(low), "d" (high) : "memory");
 }
 
@@ -137,17 +137,11 @@ static inline unsigned long long native_read_msr_safe(unsigned int msr,
 {
 	DECLARE_ARGS(val, low, high);
 
-	asm volatile("2: rdmsr ; xor %[err],%[err]\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3: mov %[fault],%[err]\n\t"
-		     "xorl %%eax, %%eax\n\t"
-		     "xorl %%edx, %%edx\n\t"
-		     "jmp 1b\n\t"
-		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
+	asm volatile("1: rdmsr ; xor %[err],%[err]\n"
+		     "2:\n\t"
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_RDMSR_SAFE, %[err])
 		     : [err] "=r" (*err), EAX_EDX_RET(val, low, high)
-		     : "c" (msr), [fault] "i" (-EIO));
+		     : "c" (msr));
 	if (tracepoint_enabled(read_msr))
 		do_trace_read_msr(msr, EAX_EDX_VAL(val, low, high), *err);
 	return EAX_EDX_VAL(val, low, high);
@@ -169,15 +163,11 @@ native_write_msr_safe(unsigned int msr, u32 low, u32 high)
 {
 	int err;
 
-	asm volatile("2: wrmsr ; xor %[err],%[err]\n"
-		     "1:\n\t"
-		     ".section .fixup,\"ax\"\n\t"
-		     "3:  mov %[fault],%[err] ; jmp 1b\n\t"
-		     ".previous\n\t"
-		     _ASM_EXTABLE(2b, 3b)
+	asm volatile("1: wrmsr ; xor %[err],%[err]\n"
+		     "2:\n\t"
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_WRMSR_SAFE, %[err])
 		     : [err] "=a" (err)
-		     : "c" (msr), "0" (low), "d" (high),
-		       [fault] "i" (-EIO)
+		     : "c" (msr), "0" (low), "d" (high)
 		     : "memory");
 	if (tracepoint_enabled(write_msr))
 		do_trace_write_msr(msr, ((u64)high << 32 | low), err);
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 0a87b2bc4ef9..9a79b96e5521 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -298,6 +298,8 @@ do {									\
 	alternative_msr_write(MSR_IA32_SPEC_CTRL,			\
 			      spec_ctrl_current() | SPEC_CTRL_IBRS,	\
 			      X86_FEATURE_USE_IBRS_FW);			\
+	alternative_msr_write(MSR_IA32_PRED_CMD, PRED_CMD_IBPB,		\
+			      X86_FEATURE_USE_IBPB_FW);			\
 } while (0)
 
 #define firmware_restrict_branch_speculation_end()			\
diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
index 72044026eb3c..8dd8e8ec9fa5 100644
--- a/arch/x86/include/asm/segment.h
+++ b/arch/x86/include/asm/segment.h
@@ -339,7 +339,7 @@ static inline void __loadsegment_fs(unsigned short value)
 		     "1:	movw %0, %%fs			\n"
 		     "2:					\n"
 
-		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_clear_fs)
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_CLEAR_FS)
 
 		     : : "rm" (value) : "memory");
 }
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index bb1430283c72..ab5e57737309 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -414,6 +414,103 @@ do {									\
 
 #endif // CONFIG_CC_ASM_GOTO_OUTPUT
 
+#ifdef CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+#endif // CONFIG_X86_32
+#else  // !CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	int __err = 0;							\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     CC_SET(z)						\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG,	\
+					   %[errout])			\
+		     : CC_OUT(z) (success),				\
+		       [errout] "+r" (__err),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory");					\
+	if (unlikely(__err))						\
+		goto label;						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+/*
+ * Unlike the normal CMPXCHG, hardcode ECX for both success/fail and error.
+ * There are only six GPRs available and four (EAX, EBX, ECX, and EDX) are
+ * hardcoded by CMPXCHG8B, leaving only ESI and EDI.  If the compiler uses
+ * both ESI and EDI for the memory operand, compilation will fail if the error
+ * is an input+output as there will be no register available for input.
+ */
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	int __result;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     "mov $0, %%ecx\n\t"				\
+		     "setz %%cl\n"					\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %%ecx) \
+		     : [result]"=c" (__result),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory", "cc");					\
+	if (unlikely(__result < 0))					\
+		goto label;						\
+	if (unlikely(!__result))					\
+		*_old = __old;						\
+	likely(__result);					})
+#endif // CONFIG_X86_32
+#endif // CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+
 /* FIXME: this hack is definitely wrong -AK */
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct __user *)(x))
@@ -506,6 +603,51 @@ do {										\
 } while (0)
 #endif // CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
+extern void __try_cmpxchg_user_wrong_size(void);
+
+#ifndef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _oldp, _nval, _label)		\
+	__try_cmpxchg_user_asm("q", "r", (_ptr), (_oldp), (_nval), _label)
+#endif
+
+/*
+ * Force the pointer to u<size> to match the size expected by the asm helper.
+ * clang/LLVM compiles all cases and only discards the unused paths after
+ * processing errors, which breaks i386 if the pointer is an 8-byte value.
+ */
+#define unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label) ({			\
+	bool __ret;								\
+	__chk_user_ptr(_ptr);							\
+	switch (sizeof(*(_ptr))) {						\
+	case 1:	__ret = __try_cmpxchg_user_asm("b", "q",			\
+					       (__force u8 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 2:	__ret = __try_cmpxchg_user_asm("w", "r",			\
+					       (__force u16 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 4:	__ret = __try_cmpxchg_user_asm("l", "r",			\
+					       (__force u32 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 8:	__ret = __try_cmpxchg64_user_asm((__force u64 *)(_ptr), (_oldp),\
+						 (_nval), _label);		\
+		break;								\
+	default: __try_cmpxchg_user_wrong_size();				\
+	}									\
+	__ret;						})
+
+/* "Returns" 0 on success, 1 on failure, -EFAULT if the access faults. */
+#define __try_cmpxchg_user(_ptr, _oldp, _nval, _label)	({		\
+	int __ret = -EFAULT;						\
+	__uaccess_begin_nospec();					\
+	__ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);	\
+_label:									\
+	__uaccess_end();						\
+	__ret;								\
+							})
+
 /*
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 8ed9ccf53b62..98a8b59f87f3 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -554,7 +554,9 @@ void __init_or_module noinline apply_returns(s32 *start, s32 *end)
 			dest = addr + insn.length + insn.immediate.value;
 
 		if (__static_call_fixup(addr, op, dest) ||
-		    WARN_ON_ONCE(dest != &__x86_return_thunk))
+		    WARN_ONCE(dest != &__x86_return_thunk,
+			      "missing return thunk: %pS-%pS: %*ph",
+			      addr, dest, 5, addr))
 			continue;
 
 		DPRINTK("return thunk at: %pS (%px) len: %d to: %pS",
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 650333fce795..18a7ea1cffda 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -968,6 +968,7 @@ static inline const char *spectre_v2_module_string(void) { return ""; }
 #define SPECTRE_V2_LFENCE_MSG "WARNING: LFENCE mitigation is not recommended for this CPU, data leaks possible!\n"
 #define SPECTRE_V2_EIBRS_EBPF_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS on, data leaks possible via Spectre v2 BHB attacks!\n"
 #define SPECTRE_V2_EIBRS_LFENCE_EBPF_SMT_MSG "WARNING: Unprivileged eBPF is enabled with eIBRS+LFENCE mitigation and SMT, data leaks possible via Spectre v2 BHB attacks!\n"
+#define SPECTRE_V2_IBRS_PERF_MSG "WARNING: IBRS mitigation selected on Enhanced IBRS CPU, this may cause unnecessary performance loss\n"
 
 #ifdef CONFIG_BPF_SYSCALL
 void unpriv_ebpf_notify(int new_state)
@@ -1408,6 +1409,8 @@ static void __init spectre_v2_select_mitigation(void)
 
 	case SPECTRE_V2_IBRS:
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
+		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
+			pr_warn(SPECTRE_V2_IBRS_PERF_MSG);
 		break;
 
 	case SPECTRE_V2_LFENCE:
@@ -1509,7 +1512,16 @@ static void __init spectre_v2_select_mitigation(void)
 	 * the CPU supports Enhanced IBRS, kernel might un-intentionally not
 	 * enable IBRS around firmware calls.
 	 */
-	if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
+	if (boot_cpu_has_bug(X86_BUG_RETBLEED) &&
+	    (boot_cpu_data.x86_vendor == X86_VENDOR_AMD ||
+	     boot_cpu_data.x86_vendor == X86_VENDOR_HYGON)) {
+
+		if (retbleed_cmd != RETBLEED_CMD_IBPB) {
+			setup_force_cpu_cap(X86_FEATURE_USE_IBPB_FW);
+			pr_info("Enabling Speculation Barrier for firmware calls\n");
+		}
+
+	} else if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 848cfb013f58..773037e5fd76 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -382,13 +382,16 @@ static int msr_to_offset(u32 msr)
 	return -1;
 }
 
-__visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
-				      struct pt_regs *regs, int trapnr,
-				      unsigned long error_code,
-				      unsigned long fault_addr)
+void ex_handler_msr_mce(struct pt_regs *regs, bool wrmsr)
 {
-	pr_emerg("MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
-		 (unsigned int)regs->cx, regs->ip, (void *)regs->ip);
+	if (wrmsr) {
+		pr_emerg("MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
+			 (unsigned int)regs->cx, (unsigned int)regs->dx, (unsigned int)regs->ax,
+			 regs->ip, (void *)regs->ip);
+	} else {
+		pr_emerg("MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
+			 (unsigned int)regs->cx, regs->ip, (void *)regs->ip);
+	}
 
 	show_stack_regs(regs);
 
@@ -396,8 +399,6 @@ __visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
 
 	while (true)
 		cpu_relax();
-
-	return true;
 }
 
 /* MSR access wrappers used for error injection */
@@ -429,32 +430,13 @@ static noinstr u64 mce_rdmsrl(u32 msr)
 	 */
 	asm volatile("1: rdmsr\n"
 		     "2:\n"
-		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_rdmsr_fault)
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_RDMSR_IN_MCE)
 		     : EAX_EDX_RET(val, low, high) : "c" (msr));
 
 
 	return EAX_EDX_VAL(val, low, high);
 }
 
-__visible bool ex_handler_wrmsr_fault(const struct exception_table_entry *fixup,
-				      struct pt_regs *regs, int trapnr,
-				      unsigned long error_code,
-				      unsigned long fault_addr)
-{
-	pr_emerg("MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
-		 (unsigned int)regs->cx, (unsigned int)regs->dx, (unsigned int)regs->ax,
-		  regs->ip, (void *)regs->ip);
-
-	show_stack_regs(regs);
-
-	panic("MCA architectural violation!\n");
-
-	while (true)
-		cpu_relax();
-
-	return true;
-}
-
 static noinstr void mce_wrmsrl(u32 msr, u64 v)
 {
 	u32 low, high;
@@ -479,7 +461,7 @@ static noinstr void mce_wrmsrl(u32 msr, u64 v)
 	/* See comment in mce_rdmsrl() */
 	asm volatile("1: wrmsr\n"
 		     "2:\n"
-		     _ASM_EXTABLE_HANDLE(1b, 2b, ex_handler_wrmsr_fault)
+		     _ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_WRMSR_IN_MCE)
 		     : : "c" (msr), "a"(low), "d" (high) : "memory");
 }
 
diff --git a/arch/x86/kernel/cpu/mce/internal.h b/arch/x86/kernel/cpu/mce/internal.h
index 88dcc79cfb07..80dc94313bcf 100644
--- a/arch/x86/kernel/cpu/mce/internal.h
+++ b/arch/x86/kernel/cpu/mce/internal.h
@@ -186,14 +186,4 @@ extern bool amd_filter_mce(struct mce *m);
 static inline bool amd_filter_mce(struct mce *m)			{ return false; };
 #endif
 
-__visible bool ex_handler_rdmsr_fault(const struct exception_table_entry *fixup,
-				      struct pt_regs *regs, int trapnr,
-				      unsigned long error_code,
-				      unsigned long fault_addr);
-
-__visible bool ex_handler_wrmsr_fault(const struct exception_table_entry *fixup,
-				      struct pt_regs *regs, int trapnr,
-				      unsigned long error_code,
-				      unsigned long fault_addr);
-
 #endif /* __X86_MCE_INTERNAL_H__ */
diff --git a/arch/x86/kernel/cpu/mce/severity.c b/arch/x86/kernel/cpu/mce/severity.c
index 17e631443116..d9b77a74f8d2 100644
--- a/arch/x86/kernel/cpu/mce/severity.c
+++ b/arch/x86/kernel/cpu/mce/severity.c
@@ -265,25 +265,26 @@ static bool is_copy_from_user(struct pt_regs *regs)
  */
 static int error_context(struct mce *m, struct pt_regs *regs)
 {
-	enum handler_type t;
-
 	if ((m->cs & 3) == 3)
 		return IN_USER;
 	if (!mc_recoverable(m->mcgstatus))
 		return IN_KERNEL;
 
-	t = ex_get_fault_handler_type(m->ip);
-	if (t == EX_HANDLER_FAULT) {
-		m->kflags |= MCE_IN_KERNEL_RECOV;
-		return IN_KERNEL_RECOV;
-	}
-	if (t == EX_HANDLER_UACCESS && regs && is_copy_from_user(regs)) {
-		m->kflags |= MCE_IN_KERNEL_RECOV;
+	switch (ex_get_fixup_type(m->ip)) {
+	case EX_TYPE_UACCESS:
+	case EX_TYPE_COPY:
+		if (!regs || !is_copy_from_user(regs))
+			return IN_KERNEL;
 		m->kflags |= MCE_IN_KERNEL_COPYIN;
+		fallthrough;
+	case EX_TYPE_FAULT:
+	case EX_TYPE_FAULT_MCE_SAFE:
+	case EX_TYPE_DEFAULT_MCE_SAFE:
+		m->kflags |= MCE_IN_KERNEL_RECOV;
 		return IN_KERNEL_RECOV;
+	default:
+		return IN_KERNEL;
 	}
-
-	return IN_KERNEL;
 }
 
 static int mce_severity_amd_smca(struct mce *m, enum context err_ctx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4525d0b25a43..bd410926fda5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6894,15 +6894,8 @@ static int emulator_write_emulated(struct x86_emulate_ctxt *ctxt,
 				   exception, &write_emultor);
 }
 
-#define CMPXCHG_TYPE(t, ptr, old, new) \
-	(cmpxchg((t *)(ptr), *(t *)(old), *(t *)(new)) == *(t *)(old))
-
-#ifdef CONFIG_X86_64
-#  define CMPXCHG64(ptr, old, new) CMPXCHG_TYPE(u64, ptr, old, new)
-#else
-#  define CMPXCHG64(ptr, old, new) \
-	(cmpxchg64((u64 *)(ptr), *(u64 *)(old), *(u64 *)(new)) == *(u64 *)(old))
-#endif
+#define emulator_try_cmpxchg_user(t, ptr, old, new) \
+	(__try_cmpxchg_user((t __user *)(ptr), (t *)(old), *(t *)(new), efault ## t))
 
 static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned long addr,
@@ -6911,12 +6904,11 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 				     unsigned int bytes,
 				     struct x86_exception *exception)
 {
-	struct kvm_host_map map;
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	u64 page_line_mask;
+	unsigned long hva;
 	gpa_t gpa;
-	char *kaddr;
-	bool exchanged;
+	int r;
 
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes > 8 || (bytes & (bytes - 1)))
@@ -6940,31 +6932,32 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (((gpa + bytes - 1) & page_line_mask) != (gpa & page_line_mask))
 		goto emul_write;
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
+	hva = kvm_vcpu_gfn_to_hva(vcpu, gpa_to_gfn(gpa));
+	if (kvm_is_error_hva(hva))
 		goto emul_write;
 
-	kaddr = map.hva + offset_in_page(gpa);
+	hva += offset_in_page(gpa);
 
 	switch (bytes) {
 	case 1:
-		exchanged = CMPXCHG_TYPE(u8, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u8, hva, old, new);
 		break;
 	case 2:
-		exchanged = CMPXCHG_TYPE(u16, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u16, hva, old, new);
 		break;
 	case 4:
-		exchanged = CMPXCHG_TYPE(u32, kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u32, hva, old, new);
 		break;
 	case 8:
-		exchanged = CMPXCHG64(kaddr, old, new);
+		r = emulator_try_cmpxchg_user(u64, hva, old, new);
 		break;
 	default:
 		BUG();
 	}
 
-	kvm_vcpu_unmap(vcpu, &map, true);
-
-	if (!exchanged)
+	if (r < 0)
+		goto emul_write;
+	if (r)
 		return X86EMUL_CMPXCHG_FAILED;
 
 	kvm_page_track_write(vcpu, gpa, new, bytes);
diff --git a/arch/x86/lib/insn-eval.c b/arch/x86/lib/insn-eval.c
index eb3ccffb9b9d..c8a962c2e653 100644
--- a/arch/x86/lib/insn-eval.c
+++ b/arch/x86/lib/insn-eval.c
@@ -412,32 +412,44 @@ static short get_segment_selector(struct pt_regs *regs, int seg_reg_idx)
 #endif /* CONFIG_X86_64 */
 }
 
-static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
-			  enum reg_type type)
+static const int pt_regoff[] = {
+	offsetof(struct pt_regs, ax),
+	offsetof(struct pt_regs, cx),
+	offsetof(struct pt_regs, dx),
+	offsetof(struct pt_regs, bx),
+	offsetof(struct pt_regs, sp),
+	offsetof(struct pt_regs, bp),
+	offsetof(struct pt_regs, si),
+	offsetof(struct pt_regs, di),
+#ifdef CONFIG_X86_64
+	offsetof(struct pt_regs, r8),
+	offsetof(struct pt_regs, r9),
+	offsetof(struct pt_regs, r10),
+	offsetof(struct pt_regs, r11),
+	offsetof(struct pt_regs, r12),
+	offsetof(struct pt_regs, r13),
+	offsetof(struct pt_regs, r14),
+	offsetof(struct pt_regs, r15),
+#else
+	offsetof(struct pt_regs, ds),
+	offsetof(struct pt_regs, es),
+	offsetof(struct pt_regs, fs),
+	offsetof(struct pt_regs, gs),
+#endif
+};
+
+int pt_regs_offset(struct pt_regs *regs, int regno)
+{
+	if ((unsigned)regno < ARRAY_SIZE(pt_regoff))
+		return pt_regoff[regno];
+	return -EDOM;
+}
+
+static int get_regno(struct insn *insn, enum reg_type type)
 {
+	int nr_registers = ARRAY_SIZE(pt_regoff);
 	int regno = 0;
 
-	static const int regoff[] = {
-		offsetof(struct pt_regs, ax),
-		offsetof(struct pt_regs, cx),
-		offsetof(struct pt_regs, dx),
-		offsetof(struct pt_regs, bx),
-		offsetof(struct pt_regs, sp),
-		offsetof(struct pt_regs, bp),
-		offsetof(struct pt_regs, si),
-		offsetof(struct pt_regs, di),
-#ifdef CONFIG_X86_64
-		offsetof(struct pt_regs, r8),
-		offsetof(struct pt_regs, r9),
-		offsetof(struct pt_regs, r10),
-		offsetof(struct pt_regs, r11),
-		offsetof(struct pt_regs, r12),
-		offsetof(struct pt_regs, r13),
-		offsetof(struct pt_regs, r14),
-		offsetof(struct pt_regs, r15),
-#endif
-	};
-	int nr_registers = ARRAY_SIZE(regoff);
 	/*
 	 * Don't possibly decode a 32-bit instructions as
 	 * reading a 64-bit-only register.
@@ -505,7 +517,18 @@ static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
 		WARN_ONCE(1, "decoded an instruction with an invalid register");
 		return -EINVAL;
 	}
-	return regoff[regno];
+	return regno;
+}
+
+static int get_reg_offset(struct insn *insn, struct pt_regs *regs,
+			  enum reg_type type)
+{
+	int regno = get_regno(insn, type);
+
+	if (regno < 0)
+		return regno;
+
+	return pt_regs_offset(regs, regno);
 }
 
 /**
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index e1664e9f969c..13d838e6030b 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -2,48 +2,50 @@
 #include <linux/extable.h>
 #include <linux/uaccess.h>
 #include <linux/sched/debug.h>
+#include <linux/bitfield.h>
 #include <xen/xen.h>
 
 #include <asm/fpu/internal.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>
+#include <asm/insn-eval.h>
 
-typedef bool (*ex_handler_t)(const struct exception_table_entry *,
-			    struct pt_regs *, int, unsigned long,
-			    unsigned long);
+static inline unsigned long *pt_regs_nr(struct pt_regs *regs, int nr)
+{
+	int reg_offset = pt_regs_offset(regs, nr);
+	static unsigned long __dummy;
+
+	if (WARN_ON_ONCE(reg_offset < 0))
+		return &__dummy;
+
+	return (unsigned long *)((unsigned long)regs + reg_offset);
+}
 
 static inline unsigned long
 ex_fixup_addr(const struct exception_table_entry *x)
 {
 	return (unsigned long)&x->fixup + x->fixup;
 }
-static inline ex_handler_t
-ex_fixup_handler(const struct exception_table_entry *x)
-{
-	return (ex_handler_t)((unsigned long)&x->handler + x->handler);
-}
 
-__visible bool ex_handler_default(const struct exception_table_entry *fixup,
-				  struct pt_regs *regs, int trapnr,
-				  unsigned long error_code,
-				  unsigned long fault_addr)
+static bool ex_handler_default(const struct exception_table_entry *e,
+			       struct pt_regs *regs)
 {
-	regs->ip = ex_fixup_addr(fixup);
+	if (e->data & EX_FLAG_CLEAR_AX)
+		regs->ax = 0;
+	if (e->data & EX_FLAG_CLEAR_DX)
+		regs->dx = 0;
+
+	regs->ip = ex_fixup_addr(e);
 	return true;
 }
-EXPORT_SYMBOL(ex_handler_default);
 
-__visible bool ex_handler_fault(const struct exception_table_entry *fixup,
-				struct pt_regs *regs, int trapnr,
-				unsigned long error_code,
-				unsigned long fault_addr)
+static bool ex_handler_fault(const struct exception_table_entry *fixup,
+			     struct pt_regs *regs, int trapnr)
 {
-	regs->ip = ex_fixup_addr(fixup);
 	regs->ax = trapnr;
-	return true;
+	return ex_handler_default(fixup, regs);
 }
-EXPORT_SYMBOL_GPL(ex_handler_fault);
 
 /*
  * Handler for when we fail to restore a task's FPU state.  We should never get
@@ -55,10 +57,8 @@ EXPORT_SYMBOL_GPL(ex_handler_fault);
  * of vulnerability by restoring from the initial state (essentially, zeroing
  * out all the FPU registers) if we can't restore from the task's FPU state.
  */
-__visible bool ex_handler_fprestore(const struct exception_table_entry *fixup,
-				    struct pt_regs *regs, int trapnr,
-				    unsigned long error_code,
-				    unsigned long fault_addr)
+static bool ex_handler_fprestore(const struct exception_table_entry *fixup,
+				 struct pt_regs *regs)
 {
 	regs->ip = ex_fixup_addr(fixup);
 
@@ -68,98 +68,75 @@ __visible bool ex_handler_fprestore(const struct exception_table_entry *fixup,
 	__restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
 	return true;
 }
-EXPORT_SYMBOL_GPL(ex_handler_fprestore);
 
-__visible bool ex_handler_uaccess(const struct exception_table_entry *fixup,
-				  struct pt_regs *regs, int trapnr,
-				  unsigned long error_code,
-				  unsigned long fault_addr)
+static bool ex_handler_uaccess(const struct exception_table_entry *fixup,
+			       struct pt_regs *regs, int trapnr)
 {
 	WARN_ONCE(trapnr == X86_TRAP_GP, "General protection fault in user access. Non-canonical address?");
-	regs->ip = ex_fixup_addr(fixup);
-	return true;
+	return ex_handler_default(fixup, regs);
 }
-EXPORT_SYMBOL(ex_handler_uaccess);
 
-__visible bool ex_handler_copy(const struct exception_table_entry *fixup,
-			       struct pt_regs *regs, int trapnr,
-			       unsigned long error_code,
-			       unsigned long fault_addr)
+static bool ex_handler_copy(const struct exception_table_entry *fixup,
+			    struct pt_regs *regs, int trapnr)
 {
 	WARN_ONCE(trapnr == X86_TRAP_GP, "General protection fault in user access. Non-canonical address?");
-	regs->ip = ex_fixup_addr(fixup);
-	regs->ax = trapnr;
-	return true;
+	return ex_handler_fault(fixup, regs, trapnr);
 }
-EXPORT_SYMBOL(ex_handler_copy);
 
-__visible bool ex_handler_rdmsr_unsafe(const struct exception_table_entry *fixup,
-				       struct pt_regs *regs, int trapnr,
-				       unsigned long error_code,
-				       unsigned long fault_addr)
+static bool ex_handler_msr(const struct exception_table_entry *fixup,
+			   struct pt_regs *regs, bool wrmsr, bool safe, int reg)
 {
-	if (pr_warn_once("unchecked MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
+	if (!safe && wrmsr &&
+	    pr_warn_once("unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
+			 (unsigned int)regs->cx, (unsigned int)regs->dx,
+			 (unsigned int)regs->ax,  regs->ip, (void *)regs->ip))
+		show_stack_regs(regs);
+
+	if (!safe && !wrmsr &&
+	    pr_warn_once("unchecked MSR access error: RDMSR from 0x%x at rIP: 0x%lx (%pS)\n",
 			 (unsigned int)regs->cx, regs->ip, (void *)regs->ip))
 		show_stack_regs(regs);
 
-	/* Pretend that the read succeeded and returned 0. */
-	regs->ip = ex_fixup_addr(fixup);
-	regs->ax = 0;
-	regs->dx = 0;
-	return true;
-}
-EXPORT_SYMBOL(ex_handler_rdmsr_unsafe);
+	if (!wrmsr) {
+		/* Pretend that the read succeeded and returned 0. */
+		regs->ax = 0;
+		regs->dx = 0;
+	}
 
-__visible bool ex_handler_wrmsr_unsafe(const struct exception_table_entry *fixup,
-				       struct pt_regs *regs, int trapnr,
-				       unsigned long error_code,
-				       unsigned long fault_addr)
-{
-	if (pr_warn_once("unchecked MSR access error: WRMSR to 0x%x (tried to write 0x%08x%08x) at rIP: 0x%lx (%pS)\n",
-			 (unsigned int)regs->cx, (unsigned int)regs->dx,
-			 (unsigned int)regs->ax,  regs->ip, (void *)regs->ip))
-		show_stack_regs(regs);
+	if (safe)
+		*pt_regs_nr(regs, reg) = -EIO;
 
-	/* Pretend that the write succeeded. */
-	regs->ip = ex_fixup_addr(fixup);
-	return true;
+	return ex_handler_default(fixup, regs);
 }
-EXPORT_SYMBOL(ex_handler_wrmsr_unsafe);
 
-__visible bool ex_handler_clear_fs(const struct exception_table_entry *fixup,
-				   struct pt_regs *regs, int trapnr,
-				   unsigned long error_code,
-				   unsigned long fault_addr)
+static bool ex_handler_clear_fs(const struct exception_table_entry *fixup,
+				struct pt_regs *regs)
 {
 	if (static_cpu_has(X86_BUG_NULL_SEG))
 		asm volatile ("mov %0, %%fs" : : "rm" (__USER_DS));
 	asm volatile ("mov %0, %%fs" : : "rm" (0));
-	return ex_handler_default(fixup, regs, trapnr, error_code, fault_addr);
+	return ex_handler_default(fixup, regs);
 }
-EXPORT_SYMBOL(ex_handler_clear_fs);
 
-enum handler_type ex_get_fault_handler_type(unsigned long ip)
+static bool ex_handler_imm_reg(const struct exception_table_entry *fixup,
+			       struct pt_regs *regs, int reg, int imm)
 {
-	const struct exception_table_entry *e;
-	ex_handler_t handler;
+	*pt_regs_nr(regs, reg) = (long)imm;
+	return ex_handler_default(fixup, regs);
+}
 
-	e = search_exception_tables(ip);
-	if (!e)
-		return EX_HANDLER_NONE;
-	handler = ex_fixup_handler(e);
-	if (handler == ex_handler_fault)
-		return EX_HANDLER_FAULT;
-	else if (handler == ex_handler_uaccess || handler == ex_handler_copy)
-		return EX_HANDLER_UACCESS;
-	else
-		return EX_HANDLER_OTHER;
+int ex_get_fixup_type(unsigned long ip)
+{
+	const struct exception_table_entry *e = search_exception_tables(ip);
+
+	return e ? FIELD_GET(EX_DATA_TYPE_MASK, e->data) : EX_TYPE_NONE;
 }
 
 int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 		    unsigned long fault_addr)
 {
 	const struct exception_table_entry *e;
-	ex_handler_t handler;
+	int type, reg, imm;
 
 #ifdef CONFIG_PNPBIOS
 	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
@@ -179,8 +156,48 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 	if (!e)
 		return 0;
 
-	handler = ex_fixup_handler(e);
-	return handler(e, regs, trapnr, error_code, fault_addr);
+	type = FIELD_GET(EX_DATA_TYPE_MASK, e->data);
+	reg  = FIELD_GET(EX_DATA_REG_MASK,  e->data);
+	imm  = FIELD_GET(EX_DATA_IMM_MASK,  e->data);
+
+	switch (type) {
+	case EX_TYPE_DEFAULT:
+	case EX_TYPE_DEFAULT_MCE_SAFE:
+		return ex_handler_default(e, regs);
+	case EX_TYPE_FAULT:
+	case EX_TYPE_FAULT_MCE_SAFE:
+		return ex_handler_fault(e, regs, trapnr);
+	case EX_TYPE_UACCESS:
+		return ex_handler_uaccess(e, regs, trapnr);
+	case EX_TYPE_COPY:
+		return ex_handler_copy(e, regs, trapnr);
+	case EX_TYPE_CLEAR_FS:
+		return ex_handler_clear_fs(e, regs);
+	case EX_TYPE_FPU_RESTORE:
+		return ex_handler_fprestore(e, regs);
+	case EX_TYPE_BPF:
+		return ex_handler_bpf(e, regs);
+	case EX_TYPE_WRMSR:
+		return ex_handler_msr(e, regs, true, false, reg);
+	case EX_TYPE_RDMSR:
+		return ex_handler_msr(e, regs, false, false, reg);
+	case EX_TYPE_WRMSR_SAFE:
+		return ex_handler_msr(e, regs, true, true, reg);
+	case EX_TYPE_RDMSR_SAFE:
+		return ex_handler_msr(e, regs, false, true, reg);
+	case EX_TYPE_WRMSR_IN_MCE:
+		ex_handler_msr_mce(regs, true);
+		break;
+	case EX_TYPE_RDMSR_IN_MCE:
+		ex_handler_msr_mce(regs, false);
+		break;
+	case EX_TYPE_POP_REG:
+		regs->sp += sizeof(long);
+		fallthrough;
+	case EX_TYPE_IMM_REG:
+		return ex_handler_imm_reg(e, regs, reg, imm);
+	}
+	BUG();
 }
 
 extern unsigned int early_recursion_flag;
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 131f7ceb54dc..dccaab2113f9 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -832,9 +832,7 @@ static int emit_atomic(u8 **pprog, u8 atomic_op,
 	return 0;
 }
 
-static bool ex_handler_bpf(const struct exception_table_entry *x,
-			   struct pt_regs *regs, int trapnr,
-			   unsigned long error_code, unsigned long fault_addr)
+bool ex_handler_bpf(const struct exception_table_entry *x, struct pt_regs *regs)
 {
 	u32 reg = x->fixup >> 8;
 
@@ -1344,12 +1342,7 @@ st:			if (is_imm8(insn->off))
 				}
 				ex->insn = delta;
 
-				delta = (u8 *)ex_handler_bpf - (u8 *)&ex->handler;
-				if (!is_simm32(delta)) {
-					pr_err("extable->handler doesn't fit into 32-bit\n");
-					return -EFAULT;
-				}
-				ex->handler = delta;
+				ex->data = EX_TYPE_BPF;
 
 				if (dst_reg > BPF_REG_9) {
 					pr_err("verifier error\n");
diff --git a/drivers/accessibility/speakup/spk_ttyio.c b/drivers/accessibility/speakup/spk_ttyio.c
index 0d1f397cd896..08cf8a17754b 100644
--- a/drivers/accessibility/speakup/spk_ttyio.c
+++ b/drivers/accessibility/speakup/spk_ttyio.c
@@ -88,7 +88,7 @@ static int spk_ttyio_receive_buf2(struct tty_struct *tty,
 	}
 
 	if (!ldisc_data->buf_free)
-		/* ttyio_in will tty_schedule_flip */
+		/* ttyio_in will tty_flip_buffer_push */
 		return 0;
 
 	/* Make sure the consumer has read buf before we have seen
@@ -312,7 +312,7 @@ static unsigned char ttyio_in(struct spk_synth *in_synth, int timeout)
 	mb();
 	ldisc_data->buf_free = true;
 	/* Let TTY push more characters */
-	tty_schedule_flip(tty->port);
+	tty_flip_buffer_push(tty->port);
 
 	return rv;
 }
diff --git a/drivers/bus/mhi/pci_generic.c b/drivers/bus/mhi/pci_generic.c
index 0982642a7907..b780990faf80 100644
--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -406,11 +406,90 @@ static const struct mhi_pci_dev_info mhi_mv31_info = {
 	.mru_default = 32768,
 };
 
+static const struct mhi_channel_config mhi_telit_fn980_hw_v1_channels[] = {
+	MHI_CHANNEL_CONFIG_UL(14, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(15, "QMI", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(20, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_DL_AUTOQUEUE(21, "IPCR", 16, 0),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0", 128, 1),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0", 128, 2),
+};
+
+static struct mhi_event_config mhi_telit_fn980_hw_v1_events[] = {
+	MHI_EVENT_CONFIG_CTRL(0, 128),
+	MHI_EVENT_CONFIG_HW_DATA(1, 1024, 100),
+	MHI_EVENT_CONFIG_HW_DATA(2, 2048, 101)
+};
+
+static struct mhi_controller_config modem_telit_fn980_hw_v1_config = {
+	.max_channels = 128,
+	.timeout_ms = 20000,
+	.num_channels = ARRAY_SIZE(mhi_telit_fn980_hw_v1_channels),
+	.ch_cfg = mhi_telit_fn980_hw_v1_channels,
+	.num_events = ARRAY_SIZE(mhi_telit_fn980_hw_v1_events),
+	.event_cfg = mhi_telit_fn980_hw_v1_events,
+};
+
+static const struct mhi_pci_dev_info mhi_telit_fn980_hw_v1_info = {
+	.name = "telit-fn980-hwv1",
+	.fw = "qcom/sdx55m/sbl1.mbn",
+	.edl = "qcom/sdx55m/edl.mbn",
+	.config = &modem_telit_fn980_hw_v1_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.mru_default = 32768,
+	.sideband_wake = false,
+};
+
+static const struct mhi_channel_config mhi_telit_fn990_channels[] = {
+	MHI_CHANNEL_CONFIG_UL_SBL(2, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_DL_SBL(3, "SAHARA", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(4, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_DL(5, "DIAG", 64, 1),
+	MHI_CHANNEL_CONFIG_UL(12, "MBIM", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(13, "MBIM", 32, 0),
+	MHI_CHANNEL_CONFIG_UL(32, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_DL(33, "DUN", 32, 0),
+	MHI_CHANNEL_CONFIG_HW_UL(100, "IP_HW0_MBIM", 128, 2),
+	MHI_CHANNEL_CONFIG_HW_DL(101, "IP_HW0_MBIM", 128, 3),
+};
+
+static struct mhi_event_config mhi_telit_fn990_events[] = {
+	MHI_EVENT_CONFIG_CTRL(0, 128),
+	MHI_EVENT_CONFIG_DATA(1, 128),
+	MHI_EVENT_CONFIG_HW_DATA(2, 1024, 100),
+	MHI_EVENT_CONFIG_HW_DATA(3, 2048, 101)
+};
+
+static const struct mhi_controller_config modem_telit_fn990_config = {
+	.max_channels = 128,
+	.timeout_ms = 20000,
+	.num_channels = ARRAY_SIZE(mhi_telit_fn990_channels),
+	.ch_cfg = mhi_telit_fn990_channels,
+	.num_events = ARRAY_SIZE(mhi_telit_fn990_events),
+	.event_cfg = mhi_telit_fn990_events,
+};
+
+static const struct mhi_pci_dev_info mhi_telit_fn990_info = {
+	.name = "telit-fn990",
+	.config = &modem_telit_fn990_config,
+	.bar_num = MHI_PCI_DEFAULT_BAR_NUM,
+	.dma_data_width = 32,
+	.sideband_wake = false,
+	.mru_default = 32768,
+};
+
 static const struct pci_device_id mhi_pci_id_table[] = {
+	/* Telit FN980 hardware revision v1 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0306, 0x1C5D, 0x2000),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn980_hw_v1_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0306),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx55_info },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QCOM, 0x0304),
 		.driver_data = (kernel_ulong_t) &mhi_qcom_sdx24_info },
+	/* Telit FN990 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_QCOM, 0x0308, 0x1c5d, 0x2010),
+		.driver_data = (kernel_ulong_t) &mhi_telit_fn990_info },
 	{ PCI_DEVICE(0x1eac, 0x1001), /* EM120R-GL (sdx24) */
 		.driver_data = (kernel_ulong_t) &mhi_quectel_em1xx_info },
 	{ PCI_DEVICE(0x1eac, 0x1002), /* EM160R-GL (sdx24) */
diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index 8fd44703115f..359fb7989dfb 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -52,13 +52,6 @@ static int adf_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
-	/* Temporarily set the number of crypto instances to zero to avoid
-	 * registering the crypto algorithms.
-	 * This will be removed when the algorithms will support the
-	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
-	 */
-	instances = 0;
-
 	for (i = 0; i < instances; i++) {
 		val = i;
 		bank = i * 2;
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 9c57abdf56b7..fc477f016213 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -15,6 +15,7 @@ intel_qat-objs := adf_cfg.o \
 	qat_crypto.o \
 	qat_algs.o \
 	qat_asym_algs.o \
+	qat_algs_send.o \
 	qat_uclo.o \
 	qat_hal.o
 
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
index 8ba28409fb74..630d0483c4e0 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.c
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -8,6 +8,9 @@
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
 
+#define ADF_MAX_RING_THRESHOLD		80
+#define ADF_PERCENT(tot, percent)	(((tot) * (percent)) / 100)
+
 static inline u32 adf_modulo(u32 data, u32 shift)
 {
 	u32 div = data >> shift;
@@ -77,6 +80,11 @@ static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, u32 ring)
 				      bank->irq_mask);
 }
 
+bool adf_ring_nearly_full(struct adf_etr_ring_data *ring)
+{
+	return atomic_read(ring->inflights) > ring->threshold;
+}
+
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg)
 {
 	struct adf_hw_csr_ops *csr_ops = GET_CSR_OPS(ring->bank->accel_dev);
@@ -217,6 +225,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	struct adf_etr_bank_data *bank;
 	struct adf_etr_ring_data *ring;
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	int max_inflights;
 	u32 ring_num;
 	int ret;
 
@@ -263,6 +272,8 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 	ring->ring_size = adf_verify_ring_size(msg_size, num_msgs);
 	ring->head = 0;
 	ring->tail = 0;
+	max_inflights = ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size);
+	ring->threshold = ADF_PERCENT(max_inflights, ADF_MAX_RING_THRESHOLD);
 	atomic_set(ring->inflights, 0);
 	ret = adf_init_ring(ring);
 	if (ret)
diff --git a/drivers/crypto/qat/qat_common/adf_transport.h b/drivers/crypto/qat/qat_common/adf_transport.h
index 2c95f1697c76..e6ef6f9b7691 100644
--- a/drivers/crypto/qat/qat_common/adf_transport.h
+++ b/drivers/crypto/qat/qat_common/adf_transport.h
@@ -14,6 +14,7 @@ int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
 		    const char *ring_name, adf_callback_fn callback,
 		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
 
+bool adf_ring_nearly_full(struct adf_etr_ring_data *ring);
 int adf_send_message(struct adf_etr_ring_data *ring, u32 *msg);
 void adf_remove_ring(struct adf_etr_ring_data *ring);
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
index 501bcf0f1809..8b2c92ba7ca1 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_internal.h
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -22,6 +22,7 @@ struct adf_etr_ring_data {
 	spinlock_t lock;	/* protects ring data struct */
 	u16 head;
 	u16 tail;
+	u32 threshold;
 	u8 ring_number;
 	u8 ring_size;
 	u8 msg_size;
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index f998ed58457c..873533dc43a7 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -17,7 +17,7 @@
 #include <crypto/xts.h>
 #include <linux/dma-mapping.h>
 #include "adf_accel_devices.h"
-#include "adf_transport.h"
+#include "qat_algs_send.h"
 #include "adf_common_drv.h"
 #include "qat_crypto.h"
 #include "icp_qat_hw.h"
@@ -46,19 +46,6 @@
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
-struct qat_alg_buf {
-	u32 len;
-	u32 resrvd;
-	u64 addr;
-} __packed;
-
-struct qat_alg_buf_list {
-	u64 resrvd;
-	u32 num_bufs;
-	u32 num_mapped_bufs;
-	struct qat_alg_buf bufers[];
-} __packed __aligned(64);
-
 /* Common content descriptor */
 struct qat_alg_cd {
 	union {
@@ -693,7 +680,10 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 				 bl->bufers[i].len, DMA_BIDIRECTIONAL);
 
 	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
-	kfree(bl);
+
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bl);
+
 	if (blp != blpout) {
 		/* If out of place operation dma unmap only data */
 		int bufless = blout->num_bufs - blout->num_mapped_bufs;
@@ -704,7 +694,9 @@ static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
 					 DMA_BIDIRECTIONAL);
 		}
 		dma_unmap_single(dev, blpout, sz_out, DMA_TO_DEVICE);
-		kfree(blout);
+
+		if (!qat_req->buf.sgl_dst_valid)
+			kfree(blout);
 	}
 }
 
@@ -721,15 +713,24 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 	dma_addr_t blp = DMA_MAPPING_ERROR;
 	dma_addr_t bloutp = DMA_MAPPING_ERROR;
 	struct scatterlist *sg;
-	size_t sz_out, sz = struct_size(bufl, bufers, n + 1);
+	size_t sz_out, sz = struct_size(bufl, bufers, n);
+	int node = dev_to_node(&GET_DEV(inst->accel_dev));
 
 	if (unlikely(!n))
 		return -EINVAL;
 
-	bufl = kzalloc_node(sz, GFP_ATOMIC,
-			    dev_to_node(&GET_DEV(inst->accel_dev)));
-	if (unlikely(!bufl))
-		return -ENOMEM;
+	qat_req->buf.sgl_src_valid = false;
+	qat_req->buf.sgl_dst_valid = false;
+
+	if (n > QAT_MAX_BUFF_DESC) {
+		bufl = kzalloc_node(sz, GFP_ATOMIC, node);
+		if (unlikely(!bufl))
+			return -ENOMEM;
+	} else {
+		bufl = &qat_req->buf.sgl_src.sgl_hdr;
+		memset(bufl, 0, sizeof(struct qat_alg_buf_list));
+		qat_req->buf.sgl_src_valid = true;
+	}
 
 	for_each_sg(sgl, sg, n, i)
 		bufl->bufers[i].addr = DMA_MAPPING_ERROR;
@@ -760,12 +761,18 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 		struct qat_alg_buf *bufers;
 
 		n = sg_nents(sglout);
-		sz_out = struct_size(buflout, bufers, n + 1);
+		sz_out = struct_size(buflout, bufers, n);
 		sg_nctr = 0;
-		buflout = kzalloc_node(sz_out, GFP_ATOMIC,
-				       dev_to_node(&GET_DEV(inst->accel_dev)));
-		if (unlikely(!buflout))
-			goto err_in;
+
+		if (n > QAT_MAX_BUFF_DESC) {
+			buflout = kzalloc_node(sz_out, GFP_ATOMIC, node);
+			if (unlikely(!buflout))
+				goto err_in;
+		} else {
+			buflout = &qat_req->buf.sgl_dst.sgl_hdr;
+			memset(buflout, 0, sizeof(struct qat_alg_buf_list));
+			qat_req->buf.sgl_dst_valid = true;
+		}
 
 		bufers = buflout->bufers;
 		for_each_sg(sglout, sg, n, i)
@@ -810,7 +817,9 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 			dma_unmap_single(dev, buflout->bufers[i].addr,
 					 buflout->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
-	kfree(buflout);
+
+	if (!qat_req->buf.sgl_dst_valid)
+		kfree(buflout);
 
 err_in:
 	if (!dma_mapping_error(dev, blp))
@@ -823,7 +832,8 @@ static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
 					 bufl->bufers[i].len,
 					 DMA_BIDIRECTIONAL);
 
-	kfree(bufl);
+	if (!qat_req->buf.sgl_src_valid)
+		kfree(bufl);
 
 	dev_err(dev, "Failed to map buf for dma\n");
 	return -ENOMEM;
@@ -925,8 +935,25 @@ void qat_alg_callback(void *resp)
 	struct icp_qat_fw_la_resp *qat_resp = resp;
 	struct qat_crypto_request *qat_req =
 				(void *)(__force long)qat_resp->opaque_data;
+	struct qat_instance_backlog *backlog = qat_req->alg_req.backlog;
 
 	qat_req->cb(qat_resp, qat_req);
+
+	qat_alg_send_backlog(backlog);
+}
+
+static int qat_alg_send_sym_message(struct qat_crypto_request *qat_req,
+				    struct qat_crypto_instance *inst,
+				    struct crypto_async_request *base)
+{
+	struct qat_alg_req *alg_req = &qat_req->alg_req;
+
+	alg_req->fw_req = (u32 *)&qat_req->req;
+	alg_req->tx_ring = inst->sym_tx;
+	alg_req->base = base;
+	alg_req->backlog = &inst->backlog;
+
+	return qat_alg_send_message(alg_req);
 }
 
 static int qat_alg_aead_dec(struct aead_request *areq)
@@ -939,7 +966,7 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	int digst_size = crypto_aead_authsize(aead_tfm);
-	int ret, ctr = 0;
+	int ret;
 	u32 cipher_len;
 
 	cipher_len = areq->cryptlen - digst_size;
@@ -965,15 +992,12 @@ static int qat_alg_aead_dec(struct aead_request *areq)
 	auth_param = (void *)((u8 *)cipher_param + sizeof(*cipher_param));
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + cipher_param->cipher_length;
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
 
-	if (ret == -EAGAIN) {
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
+	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+
+	return ret;
 }
 
 static int qat_alg_aead_enc(struct aead_request *areq)
@@ -986,7 +1010,7 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	struct icp_qat_fw_la_auth_req_params *auth_param;
 	struct icp_qat_fw_la_bulk_req *msg;
 	u8 *iv = areq->iv;
-	int ret, ctr = 0;
+	int ret;
 
 	if (areq->cryptlen % AES_BLOCK_SIZE != 0)
 		return -EINVAL;
@@ -1013,15 +1037,11 @@ static int qat_alg_aead_enc(struct aead_request *areq)
 	auth_param->auth_off = 0;
 	auth_param->auth_len = areq->assoclen + areq->cryptlen;
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
-	if (ret == -EAGAIN) {
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &areq->base);
+	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+
+	return ret;
 }
 
 static int qat_alg_skcipher_rekey(struct qat_alg_skcipher_ctx *ctx,
@@ -1174,7 +1194,7 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	int ret, ctr = 0;
+	int ret;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1198,15 +1218,11 @@ static int qat_alg_skcipher_encrypt(struct skcipher_request *req)
 
 	qat_alg_set_req_iv(qat_req);
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
-	if (ret == -EAGAIN) {
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
+	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+
+	return ret;
 }
 
 static int qat_alg_skcipher_blk_encrypt(struct skcipher_request *req)
@@ -1243,7 +1259,7 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	struct qat_crypto_request *qat_req = skcipher_request_ctx(req);
 	struct icp_qat_fw_la_cipher_req_params *cipher_param;
 	struct icp_qat_fw_la_bulk_req *msg;
-	int ret, ctr = 0;
+	int ret;
 
 	if (req->cryptlen == 0)
 		return 0;
@@ -1268,15 +1284,11 @@ static int qat_alg_skcipher_decrypt(struct skcipher_request *req)
 	qat_alg_set_req_iv(qat_req);
 	qat_alg_update_iv(qat_req);
 
-	do {
-		ret = adf_send_message(ctx->inst->sym_tx, (u32 *)msg);
-	} while (ret == -EAGAIN && ctr++ < 10);
-
-	if (ret == -EAGAIN) {
+	ret = qat_alg_send_sym_message(qat_req, ctx->inst, &req->base);
+	if (ret == -ENOSPC)
 		qat_alg_free_bufl(ctx->inst, qat_req);
-		return -EBUSY;
-	}
-	return -EINPROGRESS;
+
+	return ret;
 }
 
 static int qat_alg_skcipher_blk_decrypt(struct skcipher_request *req)
diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.c b/drivers/crypto/qat/qat_common/qat_algs_send.c
new file mode 100644
index 000000000000..ff5b4347f783
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
+/* Copyright(c) 2022 Intel Corporation */
+#include "adf_transport.h"
+#include "qat_algs_send.h"
+#include "qat_crypto.h"
+
+#define ADF_MAX_RETRIES		20
+
+static int qat_alg_send_message_retry(struct qat_alg_req *req)
+{
+	int ret = 0, ctr = 0;
+
+	do {
+		ret = adf_send_message(req->tx_ring, req->fw_req);
+	} while (ret == -EAGAIN && ctr++ < ADF_MAX_RETRIES);
+
+	if (ret == -EAGAIN)
+		return -ENOSPC;
+
+	return -EINPROGRESS;
+}
+
+void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
+{
+	struct qat_alg_req *req, *tmp;
+
+	spin_lock_bh(&backlog->lock);
+	list_for_each_entry_safe(req, tmp, &backlog->list, list) {
+		if (adf_send_message(req->tx_ring, req->fw_req)) {
+			/* The HW ring is full. Do nothing.
+			 * qat_alg_send_backlog() will be invoked again by
+			 * another callback.
+			 */
+			break;
+		}
+		list_del(&req->list);
+		req->base->complete(req->base, -EINPROGRESS);
+	}
+	spin_unlock_bh(&backlog->lock);
+}
+
+static void qat_alg_backlog_req(struct qat_alg_req *req,
+				struct qat_instance_backlog *backlog)
+{
+	INIT_LIST_HEAD(&req->list);
+
+	spin_lock_bh(&backlog->lock);
+	list_add_tail(&req->list, &backlog->list);
+	spin_unlock_bh(&backlog->lock);
+}
+
+static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
+{
+	struct qat_instance_backlog *backlog = req->backlog;
+	struct adf_etr_ring_data *tx_ring = req->tx_ring;
+	u32 *fw_req = req->fw_req;
+
+	/* If any request is already backlogged, then add to backlog list */
+	if (!list_empty(&backlog->list))
+		goto enqueue;
+
+	/* If ring is nearly full, then add to backlog list */
+	if (adf_ring_nearly_full(tx_ring))
+		goto enqueue;
+
+	/* If adding request to HW ring fails, then add to backlog list */
+	if (adf_send_message(tx_ring, fw_req))
+		goto enqueue;
+
+	return -EINPROGRESS;
+
+enqueue:
+	qat_alg_backlog_req(req, backlog);
+
+	return -EBUSY;
+}
+
+int qat_alg_send_message(struct qat_alg_req *req)
+{
+	u32 flags = req->base->flags;
+
+	if (flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		return qat_alg_send_message_maybacklog(req);
+	else
+		return qat_alg_send_message_retry(req);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_algs_send.h b/drivers/crypto/qat/qat_common/qat_algs_send.h
new file mode 100644
index 000000000000..5ce9f4f69d8f
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_algs_send.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2022 Intel Corporation */
+#ifndef QAT_ALGS_SEND_H
+#define QAT_ALGS_SEND_H
+
+#include "qat_crypto.h"
+
+int qat_alg_send_message(struct qat_alg_req *req);
+void qat_alg_send_backlog(struct qat_instance_backlog *backlog);
+
+#endif
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index b0b78445418b..7173a2a0a484 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -12,6 +12,7 @@
 #include <crypto/scatterwalk.h>
 #include "icp_qat_fw_pke.h"
 #include "adf_accel_devices.h"
+#include "qat_algs_send.h"
 #include "adf_transport.h"
 #include "adf_common_drv.h"
 #include "qat_crypto.h"
@@ -135,8 +136,23 @@ struct qat_asym_request {
 	} areq;
 	int err;
 	void (*cb)(struct icp_qat_fw_pke_resp *resp);
+	struct qat_alg_req alg_req;
 } __aligned(64);
 
+static int qat_alg_send_asym_message(struct qat_asym_request *qat_req,
+				     struct qat_crypto_instance *inst,
+				     struct crypto_async_request *base)
+{
+	struct qat_alg_req *alg_req = &qat_req->alg_req;
+
+	alg_req->fw_req = (u32 *)&qat_req->req;
+	alg_req->tx_ring = inst->pke_tx;
+	alg_req->base = base;
+	alg_req->backlog = &inst->backlog;
+
+	return qat_alg_send_message(alg_req);
+}
+
 static void qat_dh_cb(struct icp_qat_fw_pke_resp *resp)
 {
 	struct qat_asym_request *req = (void *)(__force long)resp->opaque;
@@ -148,26 +164,21 @@ static void qat_dh_cb(struct icp_qat_fw_pke_resp *resp)
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
 	if (areq->src) {
-		if (req->src_align)
-			dma_free_coherent(dev, req->ctx.dh->p_size,
-					  req->src_align, req->in.dh.in.b);
-		else
-			dma_unmap_single(dev, req->in.dh.in.b,
-					 req->ctx.dh->p_size, DMA_TO_DEVICE);
+		dma_unmap_single(dev, req->in.dh.in.b, req->ctx.dh->p_size,
+				 DMA_TO_DEVICE);
+		kfree_sensitive(req->src_align);
 	}
 
 	areq->dst_len = req->ctx.dh->p_size;
 	if (req->dst_align) {
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
-
-		dma_free_coherent(dev, req->ctx.dh->p_size, req->dst_align,
-				  req->out.dh.r);
-	} else {
-		dma_unmap_single(dev, req->out.dh.r, req->ctx.dh->p_size,
-				 DMA_FROM_DEVICE);
+		kfree_sensitive(req->dst_align);
 	}
 
+	dma_unmap_single(dev, req->out.dh.r, req->ctx.dh->p_size,
+			 DMA_FROM_DEVICE);
+
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_dh_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
@@ -213,8 +224,9 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(kpp_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	int ret;
 	int n_input_params = 0;
+	u8 *vaddr;
 
 	if (unlikely(!ctx->xa))
 		return -EINVAL;
@@ -223,6 +235,10 @@ static int qat_dh_compute_value(struct kpp_request *req)
 		req->dst_len = ctx->p_size;
 		return -EOVERFLOW;
 	}
+
+	if (req->src_len > ctx->p_size)
+		return -EINVAL;
+
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -271,27 +287,24 @@ static int qat_dh_compute_value(struct kpp_request *req)
 		 */
 		if (sg_is_last(req->src) && req->src_len == ctx->p_size) {
 			qat_req->src_align = NULL;
-			qat_req->in.dh.in.b = dma_map_single(dev,
-							     sg_virt(req->src),
-							     req->src_len,
-							     DMA_TO_DEVICE);
-			if (unlikely(dma_mapping_error(dev,
-						       qat_req->in.dh.in.b)))
-				return ret;
-
+			vaddr = sg_virt(req->src);
 		} else {
 			int shift = ctx->p_size - req->src_len;
 
-			qat_req->src_align = dma_alloc_coherent(dev,
-								ctx->p_size,
-								&qat_req->in.dh.in.b,
-								GFP_KERNEL);
+			qat_req->src_align = kzalloc(ctx->p_size, GFP_KERNEL);
 			if (unlikely(!qat_req->src_align))
 				return ret;
 
 			scatterwalk_map_and_copy(qat_req->src_align + shift,
 						 req->src, 0, req->src_len, 0);
+
+			vaddr = qat_req->src_align;
 		}
+
+		qat_req->in.dh.in.b = dma_map_single(dev, vaddr, ctx->p_size,
+						     DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, qat_req->in.dh.in.b)))
+			goto unmap_src;
 	}
 	/*
 	 * dst can be of any size in valid range, but HW expects it to be the
@@ -302,20 +315,18 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	 */
 	if (sg_is_last(req->dst) && req->dst_len == ctx->p_size) {
 		qat_req->dst_align = NULL;
-		qat_req->out.dh.r = dma_map_single(dev, sg_virt(req->dst),
-						   req->dst_len,
-						   DMA_FROM_DEVICE);
-
-		if (unlikely(dma_mapping_error(dev, qat_req->out.dh.r)))
-			goto unmap_src;
-
+		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = dma_alloc_coherent(dev, ctx->p_size,
-							&qat_req->out.dh.r,
-							GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->p_size, GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
+
+		vaddr = qat_req->dst_align;
 	}
+	qat_req->out.dh.r = dma_map_single(dev, vaddr, ctx->p_size,
+					   DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->out.dh.r)))
+		goto unmap_dst;
 
 	qat_req->in.dh.in_tab[n_input_params] = 0;
 	qat_req->out.dh.out_tab[1] = 0;
@@ -338,13 +349,13 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	msg->input_param_count = n_input_params;
 	msg->output_param_count = 1;
 
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (u32 *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
+	ret = qat_alg_send_asym_message(qat_req, inst, &req->base);
+	if (ret == -ENOSPC)
+		goto unmap_all;
 
-	if (!ret)
-		return -EINPROGRESS;
+	return ret;
 
+unmap_all:
 	if (!dma_mapping_error(dev, qat_req->phy_out))
 		dma_unmap_single(dev, qat_req->phy_out,
 				 sizeof(struct qat_dh_output_params),
@@ -355,23 +366,17 @@ static int qat_dh_compute_value(struct kpp_request *req)
 				 sizeof(struct qat_dh_input_params),
 				 DMA_TO_DEVICE);
 unmap_dst:
-	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->p_size, qat_req->dst_align,
-				  qat_req->out.dh.r);
-	else
-		if (!dma_mapping_error(dev, qat_req->out.dh.r))
-			dma_unmap_single(dev, qat_req->out.dh.r, ctx->p_size,
-					 DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.dh.r))
+		dma_unmap_single(dev, qat_req->out.dh.r, ctx->p_size,
+				 DMA_FROM_DEVICE);
+	kfree_sensitive(qat_req->dst_align);
 unmap_src:
 	if (req->src) {
-		if (qat_req->src_align)
-			dma_free_coherent(dev, ctx->p_size, qat_req->src_align,
-					  qat_req->in.dh.in.b);
-		else
-			if (!dma_mapping_error(dev, qat_req->in.dh.in.b))
-				dma_unmap_single(dev, qat_req->in.dh.in.b,
-						 ctx->p_size,
-						 DMA_TO_DEVICE);
+		if (!dma_mapping_error(dev, qat_req->in.dh.in.b))
+			dma_unmap_single(dev, qat_req->in.dh.in.b,
+					 ctx->p_size,
+					 DMA_TO_DEVICE);
+		kfree_sensitive(qat_req->src_align);
 	}
 	return ret;
 }
@@ -420,14 +425,17 @@ static int qat_dh_set_params(struct qat_dh_ctx *ctx, struct dh *params)
 static void qat_dh_clear_ctx(struct device *dev, struct qat_dh_ctx *ctx)
 {
 	if (ctx->g) {
+		memset(ctx->g, 0, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->g, ctx->dma_g);
 		ctx->g = NULL;
 	}
 	if (ctx->xa) {
+		memset(ctx->xa, 0, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->xa, ctx->dma_xa);
 		ctx->xa = NULL;
 	}
 	if (ctx->p) {
+		memset(ctx->p, 0, ctx->p_size);
 		dma_free_coherent(dev, ctx->p_size, ctx->p, ctx->dma_p);
 		ctx->p = NULL;
 	}
@@ -510,25 +518,22 @@ static void qat_rsa_cb(struct icp_qat_fw_pke_resp *resp)
 
 	err = (err == ICP_QAT_FW_COMN_STATUS_FLAG_OK) ? 0 : -EINVAL;
 
-	if (req->src_align)
-		dma_free_coherent(dev, req->ctx.rsa->key_sz, req->src_align,
-				  req->in.rsa.enc.m);
-	else
-		dma_unmap_single(dev, req->in.rsa.enc.m, req->ctx.rsa->key_sz,
-				 DMA_TO_DEVICE);
+	kfree_sensitive(req->src_align);
+
+	dma_unmap_single(dev, req->in.rsa.enc.m, req->ctx.rsa->key_sz,
+			 DMA_TO_DEVICE);
 
 	areq->dst_len = req->ctx.rsa->key_sz;
 	if (req->dst_align) {
 		scatterwalk_map_and_copy(req->dst_align, areq->dst, 0,
 					 areq->dst_len, 1);
 
-		dma_free_coherent(dev, req->ctx.rsa->key_sz, req->dst_align,
-				  req->out.rsa.enc.c);
-	} else {
-		dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
-				 DMA_FROM_DEVICE);
+		kfree_sensitive(req->dst_align);
 	}
 
+	dma_unmap_single(dev, req->out.rsa.enc.c, req->ctx.rsa->key_sz,
+			 DMA_FROM_DEVICE);
+
 	dma_unmap_single(dev, req->phy_in, sizeof(struct qat_rsa_input_params),
 			 DMA_TO_DEVICE);
 	dma_unmap_single(dev, req->phy_out,
@@ -542,8 +547,11 @@ void qat_alg_asym_callback(void *_resp)
 {
 	struct icp_qat_fw_pke_resp *resp = _resp;
 	struct qat_asym_request *areq = (void *)(__force long)resp->opaque;
+	struct qat_instance_backlog *backlog = areq->alg_req.backlog;
 
 	areq->cb(resp);
+
+	qat_alg_send_backlog(backlog);
 }
 
 #define PKE_RSA_EP_512 0x1c161b21
@@ -642,7 +650,8 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	u8 *vaddr;
+	int ret;
 
 	if (unlikely(!ctx->n || !ctx->e))
 		return -EINVAL;
@@ -651,6 +660,10 @@ static int qat_rsa_enc(struct akcipher_request *req)
 		req->dst_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
+
+	if (req->src_len > ctx->key_sz)
+		return -EINVAL;
+
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -679,40 +692,39 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	 */
 	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
 		qat_req->src_align = NULL;
-		qat_req->in.rsa.enc.m = dma_map_single(dev, sg_virt(req->src),
-						   req->src_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.enc.m)))
-			return ret;
-
+		vaddr = sg_virt(req->src);
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
-		qat_req->src_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->in.rsa.enc.m,
-							GFP_KERNEL);
+		qat_req->src_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
 		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
 					 0, req->src_len, 0);
+		vaddr = qat_req->src_align;
 	}
-	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
-		qat_req->dst_align = NULL;
-		qat_req->out.rsa.enc.c = dma_map_single(dev, sg_virt(req->dst),
-							req->dst_len,
-							DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.enc.c)))
-			goto unmap_src;
+	qat_req->in.rsa.enc.m = dma_map_single(dev, vaddr, ctx->key_sz,
+					       DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.enc.m)))
+		goto unmap_src;
 
+	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->out.rsa.enc.c,
-							GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
-
+		vaddr = qat_req->dst_align;
 	}
+
+	qat_req->out.rsa.enc.c = dma_map_single(dev, vaddr, ctx->key_sz,
+						DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.enc.c)))
+		goto unmap_dst;
+
 	qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
@@ -732,13 +744,14 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	msg->pke_mid.opaque = (u64)(__force long)qat_req;
 	msg->input_param_count = 3;
 	msg->output_param_count = 1;
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (u32 *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
 
-	if (!ret)
-		return -EINPROGRESS;
+	ret = qat_alg_send_asym_message(qat_req, inst, &req->base);
+	if (ret == -ENOSPC)
+		goto unmap_all;
 
+	return ret;
+
+unmap_all:
 	if (!dma_mapping_error(dev, qat_req->phy_out))
 		dma_unmap_single(dev, qat_req->phy_out,
 				 sizeof(struct qat_rsa_output_params),
@@ -749,21 +762,15 @@ static int qat_rsa_enc(struct akcipher_request *req)
 				 sizeof(struct qat_rsa_input_params),
 				 DMA_TO_DEVICE);
 unmap_dst:
-	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
-				  qat_req->out.rsa.enc.c);
-	else
-		if (!dma_mapping_error(dev, qat_req->out.rsa.enc.c))
-			dma_unmap_single(dev, qat_req->out.rsa.enc.c,
-					 ctx->key_sz, DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.rsa.enc.c))
+		dma_unmap_single(dev, qat_req->out.rsa.enc.c,
+				 ctx->key_sz, DMA_FROM_DEVICE);
+	kfree_sensitive(qat_req->dst_align);
 unmap_src:
-	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.rsa.enc.m);
-	else
-		if (!dma_mapping_error(dev, qat_req->in.rsa.enc.m))
-			dma_unmap_single(dev, qat_req->in.rsa.enc.m,
-					 ctx->key_sz, DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->in.rsa.enc.m))
+		dma_unmap_single(dev, qat_req->in.rsa.enc.m, ctx->key_sz,
+				 DMA_TO_DEVICE);
+	kfree_sensitive(qat_req->src_align);
 	return ret;
 }
 
@@ -776,7 +783,8 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	struct qat_asym_request *qat_req =
 			PTR_ALIGN(akcipher_request_ctx(req), 64);
 	struct icp_qat_fw_pke_request *msg = &qat_req->req;
-	int ret, ctr = 0;
+	u8 *vaddr;
+	int ret;
 
 	if (unlikely(!ctx->n || !ctx->d))
 		return -EINVAL;
@@ -785,6 +793,10 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		req->dst_len = ctx->key_sz;
 		return -EOVERFLOW;
 	}
+
+	if (req->src_len > ctx->key_sz)
+		return -EINVAL;
+
 	memset(msg, '\0', sizeof(*msg));
 	ICP_QAT_FW_PKE_HDR_VALID_FLAG_SET(msg->pke_hdr,
 					  ICP_QAT_FW_COMN_REQ_FLAG_SET);
@@ -823,40 +835,37 @@ static int qat_rsa_dec(struct akcipher_request *req)
 	 */
 	if (sg_is_last(req->src) && req->src_len == ctx->key_sz) {
 		qat_req->src_align = NULL;
-		qat_req->in.rsa.dec.c = dma_map_single(dev, sg_virt(req->src),
-						   req->dst_len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.dec.c)))
-			return ret;
-
+		vaddr = sg_virt(req->src);
 	} else {
 		int shift = ctx->key_sz - req->src_len;
 
-		qat_req->src_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->in.rsa.dec.c,
-							GFP_KERNEL);
+		qat_req->src_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->src_align))
 			return ret;
 
 		scatterwalk_map_and_copy(qat_req->src_align + shift, req->src,
 					 0, req->src_len, 0);
+		vaddr = qat_req->src_align;
 	}
-	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
-		qat_req->dst_align = NULL;
-		qat_req->out.rsa.dec.m = dma_map_single(dev, sg_virt(req->dst),
-						    req->dst_len,
-						    DMA_FROM_DEVICE);
 
-		if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.dec.m)))
-			goto unmap_src;
+	qat_req->in.rsa.dec.c = dma_map_single(dev, vaddr, ctx->key_sz,
+					       DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->in.rsa.dec.c)))
+		goto unmap_src;
 
+	if (sg_is_last(req->dst) && req->dst_len == ctx->key_sz) {
+		qat_req->dst_align = NULL;
+		vaddr = sg_virt(req->dst);
 	} else {
-		qat_req->dst_align = dma_alloc_coherent(dev, ctx->key_sz,
-							&qat_req->out.rsa.dec.m,
-							GFP_KERNEL);
+		qat_req->dst_align = kzalloc(ctx->key_sz, GFP_KERNEL);
 		if (unlikely(!qat_req->dst_align))
 			goto unmap_src;
-
+		vaddr = qat_req->dst_align;
 	}
+	qat_req->out.rsa.dec.m = dma_map_single(dev, vaddr, ctx->key_sz,
+						DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(dev, qat_req->out.rsa.dec.m)))
+		goto unmap_dst;
 
 	if (ctx->crt_mode)
 		qat_req->in.rsa.in_tab[6] = 0;
@@ -884,13 +893,14 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		msg->input_param_count = 3;
 
 	msg->output_param_count = 1;
-	do {
-		ret = adf_send_message(ctx->inst->pke_tx, (u32 *)msg);
-	} while (ret == -EBUSY && ctr++ < 100);
 
-	if (!ret)
-		return -EINPROGRESS;
+	ret = qat_alg_send_asym_message(qat_req, inst, &req->base);
+	if (ret == -ENOSPC)
+		goto unmap_all;
+
+	return ret;
 
+unmap_all:
 	if (!dma_mapping_error(dev, qat_req->phy_out))
 		dma_unmap_single(dev, qat_req->phy_out,
 				 sizeof(struct qat_rsa_output_params),
@@ -901,21 +911,15 @@ static int qat_rsa_dec(struct akcipher_request *req)
 				 sizeof(struct qat_rsa_input_params),
 				 DMA_TO_DEVICE);
 unmap_dst:
-	if (qat_req->dst_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->dst_align,
-				  qat_req->out.rsa.dec.m);
-	else
-		if (!dma_mapping_error(dev, qat_req->out.rsa.dec.m))
-			dma_unmap_single(dev, qat_req->out.rsa.dec.m,
-					 ctx->key_sz, DMA_FROM_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->out.rsa.dec.m))
+		dma_unmap_single(dev, qat_req->out.rsa.dec.m,
+				 ctx->key_sz, DMA_FROM_DEVICE);
+	kfree_sensitive(qat_req->dst_align);
 unmap_src:
-	if (qat_req->src_align)
-		dma_free_coherent(dev, ctx->key_sz, qat_req->src_align,
-				  qat_req->in.rsa.dec.c);
-	else
-		if (!dma_mapping_error(dev, qat_req->in.rsa.dec.c))
-			dma_unmap_single(dev, qat_req->in.rsa.dec.c,
-					 ctx->key_sz, DMA_TO_DEVICE);
+	if (!dma_mapping_error(dev, qat_req->in.rsa.dec.c))
+		dma_unmap_single(dev, qat_req->in.rsa.dec.c, ctx->key_sz,
+				 DMA_TO_DEVICE);
+	kfree_sensitive(qat_req->src_align);
 	return ret;
 }
 
@@ -1233,18 +1237,8 @@ static void qat_rsa_exit_tfm(struct crypto_akcipher *tfm)
 	struct qat_rsa_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct device *dev = &GET_DEV(ctx->inst->accel_dev);
 
-	if (ctx->n)
-		dma_free_coherent(dev, ctx->key_sz, ctx->n, ctx->dma_n);
-	if (ctx->e)
-		dma_free_coherent(dev, ctx->key_sz, ctx->e, ctx->dma_e);
-	if (ctx->d) {
-		memset(ctx->d, '\0', ctx->key_sz);
-		dma_free_coherent(dev, ctx->key_sz, ctx->d, ctx->dma_d);
-	}
+	qat_rsa_clear_ctx(dev, ctx);
 	qat_crypto_put_instance(ctx->inst);
-	ctx->n = NULL;
-	ctx->e = NULL;
-	ctx->d = NULL;
 }
 
 static struct akcipher_alg rsa = {
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 3efbb3883601..994e43fab0a4 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -136,13 +136,6 @@ int qat_crypto_dev_config(struct adf_accel_dev *accel_dev)
 	if (ret)
 		goto err;
 
-	/* Temporarily set the number of crypto instances to zero to avoid
-	 * registering the crypto algorithms.
-	 * This will be removed when the algorithms will support the
-	 * CRYPTO_TFM_REQ_MAY_BACKLOG flag
-	 */
-	instances = 0;
-
 	for (i = 0; i < instances; i++) {
 		val = i;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_BANK_NUM, i);
@@ -328,6 +321,9 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 				      &inst->pke_rx);
 		if (ret)
 			goto err;
+
+		INIT_LIST_HEAD(&inst->backlog.list);
+		spin_lock_init(&inst->backlog.lock);
 	}
 	return 0;
 err:
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
index b6a4c95ae003..245b6d9a3650 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.h
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -9,6 +9,19 @@
 #include "adf_accel_devices.h"
 #include "icp_qat_fw_la.h"
 
+struct qat_instance_backlog {
+	struct list_head list;
+	spinlock_t lock; /* protects backlog list */
+};
+
+struct qat_alg_req {
+	u32 *fw_req;
+	struct adf_etr_ring_data *tx_ring;
+	struct crypto_async_request *base;
+	struct list_head list;
+	struct qat_instance_backlog *backlog;
+};
+
 struct qat_crypto_instance {
 	struct adf_etr_ring_data *sym_tx;
 	struct adf_etr_ring_data *sym_rx;
@@ -19,8 +32,29 @@ struct qat_crypto_instance {
 	unsigned long state;
 	int id;
 	atomic_t refctr;
+	struct qat_instance_backlog backlog;
 };
 
+#define QAT_MAX_BUFF_DESC	4
+
+struct qat_alg_buf {
+	u32 len;
+	u32 resrvd;
+	u64 addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	u64 resrvd;
+	u32 num_bufs;
+	u32 num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed;
+
+struct qat_alg_fixed_buf_list {
+	struct qat_alg_buf_list sgl_hdr;
+	struct qat_alg_buf descriptors[QAT_MAX_BUFF_DESC];
+} __packed __aligned(64);
+
 struct qat_crypto_request_buffs {
 	struct qat_alg_buf_list *bl;
 	dma_addr_t blp;
@@ -28,6 +62,10 @@ struct qat_crypto_request_buffs {
 	dma_addr_t bloutp;
 	size_t sz;
 	size_t sz_out;
+	bool sgl_src_valid;
+	bool sgl_dst_valid;
+	struct qat_alg_fixed_buf_list sgl_src;
+	struct qat_alg_fixed_buf_list sgl_dst;
 };
 
 struct qat_crypto_request;
@@ -53,6 +91,7 @@ struct qat_crypto_request {
 		u8 iv[AES_BLOCK_SIZE];
 	};
 	bool encryption;
+	struct qat_alg_req alg_req;
 };
 
 static inline bool adf_hw_dev_has_crypto(struct adf_accel_dev *accel_dev)
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 33683295a0bf..64befd6f702b 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -351,6 +351,9 @@ static const struct regmap_config pca953x_i2c_regmap = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
+	.use_single_read = true,
+	.use_single_write = true,
+
 	.readable_reg = pca953x_readable_register,
 	.writeable_reg = pca953x_writeable_register,
 	.volatile_reg = pca953x_volatile_register,
@@ -894,15 +897,18 @@ static int pca953x_irq_setup(struct pca953x_chip *chip,
 static int device_pca95xx_init(struct pca953x_chip *chip, u32 invert)
 {
 	DECLARE_BITMAP(val, MAX_LINE);
+	u8 regaddr;
 	int ret;
 
-	ret = regcache_sync_region(chip->regmap, chip->regs->output,
-				   chip->regs->output + NBANK(chip));
+	regaddr = pca953x_recalc_addr(chip, chip->regs->output, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr,
+				   regaddr + NBANK(chip) - 1);
 	if (ret)
 		goto out;
 
-	ret = regcache_sync_region(chip->regmap, chip->regs->direction,
-				   chip->regs->direction + NBANK(chip));
+	regaddr = pca953x_recalc_addr(chip, chip->regs->direction, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr,
+				   regaddr + NBANK(chip) - 1);
 	if (ret)
 		goto out;
 
@@ -1115,14 +1121,14 @@ static int pca953x_regcache_sync(struct device *dev)
 	 * sync these registers first and only then sync the rest.
 	 */
 	regaddr = pca953x_recalc_addr(chip, chip->regs->direction, 0);
-	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip) - 1);
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO dir registers: %d\n", ret);
 		return ret;
 	}
 
 	regaddr = pca953x_recalc_addr(chip, chip->regs->output, 0);
-	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip) - 1);
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO out registers: %d\n", ret);
 		return ret;
@@ -1132,7 +1138,7 @@ static int pca953x_regcache_sync(struct device *dev)
 	if (chip->driver_data & PCA_PCAL) {
 		regaddr = pca953x_recalc_addr(chip, PCAL953X_IN_LATCH, 0);
 		ret = regcache_sync_region(chip->regmap, regaddr,
-					   regaddr + NBANK(chip));
+					   regaddr + NBANK(chip) - 1);
 		if (ret) {
 			dev_err(dev, "Failed to sync INT latch registers: %d\n",
 				ret);
@@ -1141,7 +1147,7 @@ static int pca953x_regcache_sync(struct device *dev)
 
 		regaddr = pca953x_recalc_addr(chip, PCAL953X_INT_MASK, 0);
 		ret = regcache_sync_region(chip->regmap, regaddr,
-					   regaddr + NBANK(chip));
+					   regaddr + NBANK(chip) - 1);
 		if (ret) {
 			dev_err(dev, "Failed to sync INT mask registers: %d\n",
 				ret);
diff --git a/drivers/gpio/gpio-xilinx.c b/drivers/gpio/gpio-xilinx.c
index a1b66338d077..db616ae560a3 100644
--- a/drivers/gpio/gpio-xilinx.c
+++ b/drivers/gpio/gpio-xilinx.c
@@ -99,7 +99,7 @@ static inline void xgpio_set_value32(unsigned long *map, int bit, u32 v)
 	const unsigned long offset = (bit % BITS_PER_LONG) & BIT(5);
 
 	map[index] &= ~(0xFFFFFFFFul << offset);
-	map[index] |= v << offset;
+	map[index] |= (unsigned long)v << offset;
 }
 
 static inline int xgpio_regoffset(struct xgpio_instance *chip, int ch)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d35a6f6d158e..e3dfea3d44a4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -70,6 +70,7 @@
 #include <linux/pci.h>
 #include <linux/firmware.h>
 #include <linux/component.h>
+#include <linux/dmi.h>
 
 #include <drm/drm_atomic.h>
 #include <drm/drm_atomic_uapi.h>
@@ -215,6 +216,8 @@ static void handle_cursor_update(struct drm_plane *plane,
 static const struct drm_format_info *
 amd_get_format_info(const struct drm_mode_fb_cmd2 *cmd);
 
+static void handle_hpd_irq_helper(struct amdgpu_dm_connector *aconnector);
+
 static bool
 is_timing_unchanged_for_freesync(struct drm_crtc_state *old_crtc_state,
 				 struct drm_crtc_state *new_crtc_state);
@@ -618,6 +621,113 @@ static void dm_dcn_vertical_interrupt0_high_irq(void *interrupt_params)
 }
 #endif
 
+/**
+ * dmub_aux_setconfig_reply_callback - Callback for AUX or SET_CONFIG command.
+ * @adev: amdgpu_device pointer
+ * @notify: dmub notification structure
+ *
+ * Dmub AUX or SET_CONFIG command completion processing callback
+ * Copies dmub notification to DM which is to be read by AUX command.
+ * issuing thread and also signals the event to wake up the thread.
+ */
+void dmub_aux_setconfig_callback(struct amdgpu_device *adev, struct dmub_notification *notify)
+{
+	if (adev->dm.dmub_notify)
+		memcpy(adev->dm.dmub_notify, notify, sizeof(struct dmub_notification));
+	if (notify->type == DMUB_NOTIFICATION_AUX_REPLY)
+		complete(&adev->dm.dmub_aux_transfer_done);
+}
+
+/**
+ * dmub_hpd_callback - DMUB HPD interrupt processing callback.
+ * @adev: amdgpu_device pointer
+ * @notify: dmub notification structure
+ *
+ * Dmub Hpd interrupt processing callback. Gets displayindex through the
+ * ink index and calls helper to do the processing.
+ */
+void dmub_hpd_callback(struct amdgpu_device *adev, struct dmub_notification *notify)
+{
+	struct amdgpu_dm_connector *aconnector;
+	struct drm_connector *connector;
+	struct drm_connector_list_iter iter;
+	struct dc_link *link;
+	uint8_t link_index = 0;
+	struct drm_device *dev;
+
+	if (adev == NULL)
+		return;
+
+	if (notify == NULL) {
+		DRM_ERROR("DMUB HPD callback notification was NULL");
+		return;
+	}
+
+	if (notify->link_index > adev->dm.dc->link_count) {
+		DRM_ERROR("DMUB HPD index (%u)is abnormal", notify->link_index);
+		return;
+	}
+
+	link_index = notify->link_index;
+	link = adev->dm.dc->links[link_index];
+	dev = adev->dm.ddev;
+
+	drm_connector_list_iter_begin(dev, &iter);
+	drm_for_each_connector_iter(connector, &iter) {
+		aconnector = to_amdgpu_dm_connector(connector);
+		if (link && aconnector->dc_link == link) {
+			DRM_INFO("DMUB HPD callback: link_index=%u\n", link_index);
+			handle_hpd_irq_helper(aconnector);
+			break;
+		}
+	}
+	drm_connector_list_iter_end(&iter);
+
+}
+
+/**
+ * register_dmub_notify_callback - Sets callback for DMUB notify
+ * @adev: amdgpu_device pointer
+ * @type: Type of dmub notification
+ * @callback: Dmub interrupt callback function
+ * @dmub_int_thread_offload: offload indicator
+ *
+ * API to register a dmub callback handler for a dmub notification
+ * Also sets indicator whether callback processing to be offloaded.
+ * to dmub interrupt handling thread
+ * Return: true if successfully registered, false if there is existing registration
+ */
+bool register_dmub_notify_callback(struct amdgpu_device *adev, enum dmub_notification_type type,
+dmub_notify_interrupt_callback_t callback, bool dmub_int_thread_offload)
+{
+	if (callback != NULL && type < ARRAY_SIZE(adev->dm.dmub_thread_offload)) {
+		adev->dm.dmub_callback[type] = callback;
+		adev->dm.dmub_thread_offload[type] = dmub_int_thread_offload;
+	} else
+		return false;
+
+	return true;
+}
+
+static void dm_handle_hpd_work(struct work_struct *work)
+{
+	struct dmub_hpd_work *dmub_hpd_wrk;
+
+	dmub_hpd_wrk = container_of(work, struct dmub_hpd_work, handle_hpd_work);
+
+	if (!dmub_hpd_wrk->dmub_notify) {
+		DRM_ERROR("dmub_hpd_wrk dmub_notify is NULL");
+		return;
+	}
+
+	if (dmub_hpd_wrk->dmub_notify->type < ARRAY_SIZE(dmub_hpd_wrk->adev->dm.dmub_callback)) {
+		dmub_hpd_wrk->adev->dm.dmub_callback[dmub_hpd_wrk->dmub_notify->type](dmub_hpd_wrk->adev,
+		dmub_hpd_wrk->dmub_notify);
+	}
+	kfree(dmub_hpd_wrk);
+
+}
+
 #define DMUB_TRACE_MAX_READ 64
 /**
  * dm_dmub_outbox1_low_irq() - Handles Outbox interrupt
@@ -634,18 +744,33 @@ static void dm_dmub_outbox1_low_irq(void *interrupt_params)
 	struct amdgpu_display_manager *dm = &adev->dm;
 	struct dmcub_trace_buf_entry entry = { 0 };
 	uint32_t count = 0;
+	struct dmub_hpd_work *dmub_hpd_wrk;
 
 	if (dc_enable_dmub_notifications(adev->dm.dc)) {
+		dmub_hpd_wrk = kzalloc(sizeof(*dmub_hpd_wrk), GFP_ATOMIC);
+		if (!dmub_hpd_wrk) {
+			DRM_ERROR("Failed to allocate dmub_hpd_wrk");
+			return;
+		}
+		INIT_WORK(&dmub_hpd_wrk->handle_hpd_work, dm_handle_hpd_work);
+
 		if (irq_params->irq_src == DC_IRQ_SOURCE_DMCUB_OUTBOX) {
 			do {
 				dc_stat_get_dmub_notification(adev->dm.dc, &notify);
-			} while (notify.pending_notification);
+				if (notify.type >= ARRAY_SIZE(dm->dmub_thread_offload)) {
+					DRM_ERROR("DM: notify type %d larger than the array size %zu!", notify.type,
+					ARRAY_SIZE(dm->dmub_thread_offload));
+					continue;
+				}
+				if (dm->dmub_thread_offload[notify.type] == true) {
+					dmub_hpd_wrk->dmub_notify = &notify;
+					dmub_hpd_wrk->adev = adev;
+					queue_work(adev->dm.delayed_hpd_wq, &dmub_hpd_wrk->handle_hpd_work);
+				} else {
+					dm->dmub_callback[notify.type](adev, &notify);
+				}
 
-			if (adev->dm.dmub_notify)
-				memcpy(adev->dm.dmub_notify, &notify, sizeof(struct dmub_notification));
-			if (notify.type == DMUB_NOTIFICATION_AUX_REPLY)
-				complete(&adev->dm.dmub_aux_transfer_done);
-			// TODO : HPD Implementation
+			} while (notify.pending_notification);
 
 		} else {
 			DRM_ERROR("DM: Failed to receive correct outbox IRQ !");
@@ -900,6 +1025,11 @@ static int dm_dmub_hw_init(struct amdgpu_device *adev)
 		return 0;
 	}
 
+	/* Reset DMCUB if it was previously running - before we overwrite its memory. */
+	status = dmub_srv_hw_reset(dmub_srv);
+	if (status != DMUB_STATUS_OK)
+		DRM_WARN("Error resetting DMUB HW: %d\n", status);
+
 	hdr = (const struct dmcub_firmware_header_v1_0 *)dmub_fw->data;
 
 	fw_inst_const = dmub_fw->data +
@@ -1109,6 +1239,149 @@ static void vblank_control_worker(struct work_struct *work)
 }
 
 #endif
+
+static void dm_handle_hpd_rx_offload_work(struct work_struct *work)
+{
+	struct hpd_rx_irq_offload_work *offload_work;
+	struct amdgpu_dm_connector *aconnector;
+	struct dc_link *dc_link;
+	struct amdgpu_device *adev;
+	enum dc_connection_type new_connection_type = dc_connection_none;
+	unsigned long flags;
+
+	offload_work = container_of(work, struct hpd_rx_irq_offload_work, work);
+	aconnector = offload_work->offload_wq->aconnector;
+
+	if (!aconnector) {
+		DRM_ERROR("Can't retrieve aconnector in hpd_rx_irq_offload_work");
+		goto skip;
+	}
+
+	adev = drm_to_adev(aconnector->base.dev);
+	dc_link = aconnector->dc_link;
+
+	mutex_lock(&aconnector->hpd_lock);
+	if (!dc_link_detect_sink(dc_link, &new_connection_type))
+		DRM_ERROR("KMS: Failed to detect connector\n");
+	mutex_unlock(&aconnector->hpd_lock);
+
+	if (new_connection_type == dc_connection_none)
+		goto skip;
+
+	if (amdgpu_in_reset(adev))
+		goto skip;
+
+	mutex_lock(&adev->dm.dc_lock);
+	if (offload_work->data.bytes.device_service_irq.bits.AUTOMATED_TEST)
+		dc_link_dp_handle_automated_test(dc_link);
+	else if ((dc_link->connector_signal != SIGNAL_TYPE_EDP) &&
+			hpd_rx_irq_check_link_loss_status(dc_link, &offload_work->data) &&
+			dc_link_dp_allow_hpd_rx_irq(dc_link)) {
+		dc_link_dp_handle_link_loss(dc_link);
+		spin_lock_irqsave(&offload_work->offload_wq->offload_lock, flags);
+		offload_work->offload_wq->is_handling_link_loss = false;
+		spin_unlock_irqrestore(&offload_work->offload_wq->offload_lock, flags);
+	}
+	mutex_unlock(&adev->dm.dc_lock);
+
+skip:
+	kfree(offload_work);
+
+}
+
+static struct hpd_rx_irq_offload_work_queue *hpd_rx_irq_create_workqueue(struct dc *dc)
+{
+	int max_caps = dc->caps.max_links;
+	int i = 0;
+	struct hpd_rx_irq_offload_work_queue *hpd_rx_offload_wq = NULL;
+
+	hpd_rx_offload_wq = kcalloc(max_caps, sizeof(*hpd_rx_offload_wq), GFP_KERNEL);
+
+	if (!hpd_rx_offload_wq)
+		return NULL;
+
+
+	for (i = 0; i < max_caps; i++) {
+		hpd_rx_offload_wq[i].wq =
+				    create_singlethread_workqueue("amdgpu_dm_hpd_rx_offload_wq");
+
+		if (hpd_rx_offload_wq[i].wq == NULL) {
+			DRM_ERROR("create amdgpu_dm_hpd_rx_offload_wq fail!");
+			return NULL;
+		}
+
+		spin_lock_init(&hpd_rx_offload_wq[i].offload_lock);
+	}
+
+	return hpd_rx_offload_wq;
+}
+
+struct amdgpu_stutter_quirk {
+	u16 chip_vendor;
+	u16 chip_device;
+	u16 subsys_vendor;
+	u16 subsys_device;
+	u8 revision;
+};
+
+static const struct amdgpu_stutter_quirk amdgpu_stutter_quirk_list[] = {
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=214417 */
+	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc8 },
+	{ 0, 0, 0, 0, 0 },
+};
+
+static bool dm_should_disable_stutter(struct pci_dev *pdev)
+{
+	const struct amdgpu_stutter_quirk *p = amdgpu_stutter_quirk_list;
+
+	while (p && p->chip_device != 0) {
+		if (pdev->vendor == p->chip_vendor &&
+		    pdev->device == p->chip_device &&
+		    pdev->subsystem_vendor == p->subsys_vendor &&
+		    pdev->subsystem_device == p->subsys_device &&
+		    pdev->revision == p->revision) {
+			return true;
+		}
+		++p;
+	}
+	return false;
+}
+
+static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3260"),
+		},
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3460"),
+		},
+	},
+	{}
+};
+
+static void retrieve_dmi_info(struct amdgpu_display_manager *dm)
+{
+	const struct dmi_system_id *dmi_id;
+
+	dm->aux_hpd_discon_quirk = false;
+
+	dmi_id = dmi_first_match(hpd_disconnect_quirk_table);
+	if (dmi_id) {
+		dm->aux_hpd_discon_quirk = true;
+		DRM_INFO("aux_hpd_discon_quirk attached\n");
+	}
+}
+
 static int amdgpu_dm_init(struct amdgpu_device *adev)
 {
 	struct dc_init_data init_data;
@@ -1200,6 +1473,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 	init_data.flags.power_down_display_on_boot = true;
 
 	INIT_LIST_HEAD(&adev->dm.da_list);
+
+	retrieve_dmi_info(&adev->dm);
+
 	/* Display Core create. */
 	adev->dm.dc = dc_create(&init_data);
 
@@ -1217,6 +1493,8 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	if (adev->asic_type != CHIP_CARRIZO && adev->asic_type != CHIP_STONEY)
 		adev->dm.dc->debug.disable_stutter = amdgpu_pp_feature_mask & PP_STUTTER_MODE ? false : true;
+	if (dm_should_disable_stutter(adev->pdev))
+		adev->dm.dc->debug.disable_stutter = true;
 
 	if (amdgpu_dc_debug_mask & DC_DISABLE_STUTTER)
 		adev->dm.dc->debug.disable_stutter = true;
@@ -1235,6 +1513,12 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 
 	dc_hardware_init(adev->dm.dc);
 
+	adev->dm.hpd_rx_offload_wq = hpd_rx_irq_create_workqueue(adev->dm.dc);
+	if (!adev->dm.hpd_rx_offload_wq) {
+		DRM_ERROR("amdgpu: failed to create hpd rx offload workqueue.\n");
+		goto error;
+	}
+
 #if defined(CONFIG_DRM_AMD_DC_DCN)
 	if ((adev->flags & AMD_IS_APU) && (adev->asic_type >= CHIP_CARRIZO)) {
 		struct dc_phy_addr_space_config pa_config;
@@ -1287,7 +1571,25 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 			DRM_INFO("amdgpu: fail to allocate adev->dm.dmub_notify");
 			goto error;
 		}
+
+		adev->dm.delayed_hpd_wq = create_singlethread_workqueue("amdgpu_dm_hpd_wq");
+		if (!adev->dm.delayed_hpd_wq) {
+			DRM_ERROR("amdgpu: failed to create hpd offload workqueue.\n");
+			goto error;
+		}
+
 		amdgpu_dm_outbox_init(adev);
+#if defined(CONFIG_DRM_AMD_DC_DCN)
+		if (!register_dmub_notify_callback(adev, DMUB_NOTIFICATION_AUX_REPLY,
+			dmub_aux_setconfig_callback, false)) {
+			DRM_ERROR("amdgpu: fail to register dmub aux callback");
+			goto error;
+		}
+		if (!register_dmub_notify_callback(adev, DMUB_NOTIFICATION_HPD, dmub_hpd_callback, true)) {
+			DRM_ERROR("amdgpu: fail to register dmub hpd callback");
+			goto error;
+		}
+#endif
 	}
 
 	if (amdgpu_dm_initialize_drm_device(adev)) {
@@ -1369,6 +1671,8 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 	if (dc_enable_dmub_notifications(adev->dm.dc)) {
 		kfree(adev->dm.dmub_notify);
 		adev->dm.dmub_notify = NULL;
+		destroy_workqueue(adev->dm.delayed_hpd_wq);
+		adev->dm.delayed_hpd_wq = NULL;
 	}
 
 	if (adev->dm.dmub_bo)
@@ -1394,6 +1698,18 @@ static void amdgpu_dm_fini(struct amdgpu_device *adev)
 		adev->dm.freesync_module = NULL;
 	}
 
+	if (adev->dm.hpd_rx_offload_wq) {
+		for (i = 0; i < adev->dm.dc->caps.max_links; i++) {
+			if (adev->dm.hpd_rx_offload_wq[i].wq) {
+				destroy_workqueue(adev->dm.hpd_rx_offload_wq[i].wq);
+				adev->dm.hpd_rx_offload_wq[i].wq = NULL;
+			}
+		}
+
+		kfree(adev->dm.hpd_rx_offload_wq);
+		adev->dm.hpd_rx_offload_wq = NULL;
+	}
+
 	mutex_destroy(&adev->dm.audio_lock);
 	mutex_destroy(&adev->dm.dc_lock);
 
@@ -2013,6 +2329,16 @@ static enum dc_status amdgpu_dm_commit_zero_streams(struct dc *dc)
 	return res;
 }
 
+static void hpd_rx_irq_work_suspend(struct amdgpu_display_manager *dm)
+{
+	int i;
+
+	if (dm->hpd_rx_offload_wq) {
+		for (i = 0; i < dm->dc->caps.max_links; i++)
+			flush_workqueue(dm->hpd_rx_offload_wq[i].wq);
+	}
+}
+
 static int dm_suspend(void *handle)
 {
 	struct amdgpu_device *adev = handle;
@@ -2034,6 +2360,8 @@ static int dm_suspend(void *handle)
 
 		amdgpu_dm_irq_suspend(adev);
 
+		hpd_rx_irq_work_suspend(dm);
+
 		return ret;
 	}
 
@@ -2044,6 +2372,8 @@ static int dm_suspend(void *handle)
 
 	amdgpu_dm_irq_suspend(adev);
 
+	hpd_rx_irq_work_suspend(dm);
+
 	dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D3);
 
 	return 0;
@@ -2654,9 +2984,8 @@ void amdgpu_dm_update_connector_after_detect(
 		dc_sink_release(sink);
 }
 
-static void handle_hpd_irq(void *param)
+static void handle_hpd_irq_helper(struct amdgpu_dm_connector *aconnector)
 {
-	struct amdgpu_dm_connector *aconnector = (struct amdgpu_dm_connector *)param;
 	struct drm_connector *connector = &aconnector->base;
 	struct drm_device *dev = connector->dev;
 	enum dc_connection_type new_connection_type = dc_connection_none;
@@ -2715,7 +3044,15 @@ static void handle_hpd_irq(void *param)
 
 }
 
-static void dm_handle_hpd_rx_irq(struct amdgpu_dm_connector *aconnector)
+static void handle_hpd_irq(void *param)
+{
+	struct amdgpu_dm_connector *aconnector = (struct amdgpu_dm_connector *)param;
+
+	handle_hpd_irq_helper(aconnector);
+
+}
+
+static void dm_handle_mst_sideband_msg(struct amdgpu_dm_connector *aconnector)
 {
 	uint8_t esi[DP_PSR_ERROR_STATUS - DP_SINK_COUNT_ESI] = { 0 };
 	uint8_t dret;
@@ -2793,6 +3130,25 @@ static void dm_handle_hpd_rx_irq(struct amdgpu_dm_connector *aconnector)
 		DRM_DEBUG_DRIVER("Loop exceeded max iterations\n");
 }
 
+static void schedule_hpd_rx_offload_work(struct hpd_rx_irq_offload_work_queue *offload_wq,
+							union hpd_irq_data hpd_irq_data)
+{
+	struct hpd_rx_irq_offload_work *offload_work =
+				kzalloc(sizeof(*offload_work), GFP_KERNEL);
+
+	if (!offload_work) {
+		DRM_ERROR("Failed to allocate hpd_rx_irq_offload_work.\n");
+		return;
+	}
+
+	INIT_WORK(&offload_work->work, dm_handle_hpd_rx_offload_work);
+	offload_work->data = hpd_irq_data;
+	offload_work->offload_wq = offload_wq;
+
+	queue_work(offload_wq->wq, &offload_work->work);
+	DRM_DEBUG_KMS("queue work to handle hpd_rx offload work");
+}
+
 static void handle_hpd_rx_irq(void *param)
 {
 	struct amdgpu_dm_connector *aconnector = (struct amdgpu_dm_connector *)param;
@@ -2804,14 +3160,16 @@ static void handle_hpd_rx_irq(void *param)
 	enum dc_connection_type new_connection_type = dc_connection_none;
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	union hpd_irq_data hpd_irq_data;
-	bool lock_flag = 0;
+	bool link_loss = false;
+	bool has_left_work = false;
+	int idx = aconnector->base.index;
+	struct hpd_rx_irq_offload_work_queue *offload_wq = &adev->dm.hpd_rx_offload_wq[idx];
 
 	memset(&hpd_irq_data, 0, sizeof(hpd_irq_data));
 
 	if (adev->dm.disable_hpd_irq)
 		return;
 
-
 	/*
 	 * TODO:Temporary add mutex to protect hpd interrupt not have a gpio
 	 * conflict, after implement i2c helper, this mutex should be
@@ -2819,43 +3177,41 @@ static void handle_hpd_rx_irq(void *param)
 	 */
 	mutex_lock(&aconnector->hpd_lock);
 
-	read_hpd_rx_irq_data(dc_link, &hpd_irq_data);
+	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data,
+						&link_loss, true, &has_left_work);
 
-	if ((dc_link->cur_link_settings.lane_count != LANE_COUNT_UNKNOWN) ||
-		(dc_link->type == dc_connection_mst_branch)) {
-		if (hpd_irq_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY) {
-			result = true;
-			dm_handle_hpd_rx_irq(aconnector);
-			goto out;
-		} else if (hpd_irq_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY) {
-			result = false;
-			dm_handle_hpd_rx_irq(aconnector);
+	if (!has_left_work)
+		goto out;
+
+	if (hpd_irq_data.bytes.device_service_irq.bits.AUTOMATED_TEST) {
+		schedule_hpd_rx_offload_work(offload_wq, hpd_irq_data);
+		goto out;
+	}
+
+	if (dc_link_dp_allow_hpd_rx_irq(dc_link)) {
+		if (hpd_irq_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY ||
+			hpd_irq_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY) {
+			dm_handle_mst_sideband_msg(aconnector);
 			goto out;
 		}
-	}
 
-	/*
-	 * TODO: We need the lock to avoid touching DC state while it's being
-	 * modified during automated compliance testing, or when link loss
-	 * happens. While this should be split into subhandlers and proper
-	 * interfaces to avoid having to conditionally lock like this in the
-	 * outer layer, we need this workaround temporarily to allow MST
-	 * lightup in some scenarios to avoid timeout.
-	 */
-	if (!amdgpu_in_reset(adev) &&
-	    (hpd_rx_irq_check_link_loss_status(dc_link, &hpd_irq_data) ||
-	     hpd_irq_data.bytes.device_service_irq.bits.AUTOMATED_TEST)) {
-		mutex_lock(&adev->dm.dc_lock);
-		lock_flag = 1;
-	}
+		if (link_loss) {
+			bool skip = false;
 
-#ifdef CONFIG_DRM_AMD_DC_HDCP
-	result = dc_link_handle_hpd_rx_irq(dc_link, &hpd_irq_data, NULL);
-#else
-	result = dc_link_handle_hpd_rx_irq(dc_link, NULL, NULL);
-#endif
-	if (!amdgpu_in_reset(adev) && lock_flag)
-		mutex_unlock(&adev->dm.dc_lock);
+			spin_lock(&offload_wq->offload_lock);
+			skip = offload_wq->is_handling_link_loss;
+
+			if (!skip)
+				offload_wq->is_handling_link_loss = true;
+
+			spin_unlock(&offload_wq->offload_lock);
+
+			if (!skip)
+				schedule_hpd_rx_offload_work(offload_wq, hpd_irq_data);
+
+			goto out;
+		}
+	}
 
 out:
 	if (result && !is_mst_root_connector) {
@@ -2940,6 +3296,10 @@ static void register_hpd_handlers(struct amdgpu_device *adev)
 			amdgpu_dm_irq_register_interrupt(adev, &int_params,
 					handle_hpd_rx_irq,
 					(void *) aconnector);
+
+			if (adev->dm.hpd_rx_offload_wq)
+				adev->dm.hpd_rx_offload_wq[connector->index].aconnector =
+					aconnector;
 		}
 	}
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index 46d6e65f6bd4..f9c3e5a41713 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -47,6 +47,8 @@
 #define AMDGPU_DM_MAX_CRTC 6
 
 #define AMDGPU_DM_MAX_NUM_EDP 2
+
+#define AMDGPU_DMUB_NOTIFICATION_MAX 5
 /*
 #include "include/amdgpu_dal_power_if.h"
 #include "amdgpu_dm_irq.h"
@@ -86,6 +88,21 @@ struct dm_compressor_info {
 	uint64_t gpu_addr;
 };
 
+typedef void (*dmub_notify_interrupt_callback_t)(struct amdgpu_device *adev, struct dmub_notification *notify);
+
+/**
+ * struct dmub_hpd_work - Handle time consuming work in low priority outbox IRQ
+ *
+ * @handle_hpd_work: Work to be executed in a separate thread to handle hpd_low_irq
+ * @dmub_notify:  notification for callback function
+ * @adev: amdgpu_device pointer
+ */
+struct dmub_hpd_work {
+	struct work_struct handle_hpd_work;
+	struct dmub_notification *dmub_notify;
+	struct amdgpu_device *adev;
+};
+
 /**
  * struct vblank_control_work - Work data for vblank control
  * @work: Kernel work data for the work event
@@ -154,6 +171,48 @@ struct dal_allocation {
 	u64 gpu_addr;
 };
 
+/**
+ * struct hpd_rx_irq_offload_work_queue - Work queue to handle hpd_rx_irq
+ * offload work
+ */
+struct hpd_rx_irq_offload_work_queue {
+	/**
+	 * @wq: workqueue structure to queue offload work.
+	 */
+	struct workqueue_struct *wq;
+	/**
+	 * @offload_lock: To protect fields of offload work queue.
+	 */
+	spinlock_t offload_lock;
+	/**
+	 * @is_handling_link_loss: Used to prevent inserting link loss event when
+	 * we're handling link loss
+	 */
+	bool is_handling_link_loss;
+	/**
+	 * @aconnector: The aconnector that this work queue is attached to
+	 */
+	struct amdgpu_dm_connector *aconnector;
+};
+
+/**
+ * struct hpd_rx_irq_offload_work - hpd_rx_irq offload work structure
+ */
+struct hpd_rx_irq_offload_work {
+	/**
+	 * @work: offload work
+	 */
+	struct work_struct work;
+	/**
+	 * @data: reference irq data which is used while handling offload work
+	 */
+	union hpd_irq_data data;
+	/**
+	 * @offload_wq: offload work queue that this work is queued to
+	 */
+	struct hpd_rx_irq_offload_work_queue *offload_wq;
+};
+
 /**
  * struct amdgpu_display_manager - Central amdgpu display manager device
  *
@@ -190,8 +249,30 @@ struct amdgpu_display_manager {
 	 */
 	struct dmub_srv *dmub_srv;
 
+	/**
+	 * @dmub_notify:
+	 *
+	 * Notification from DMUB.
+	 */
+
 	struct dmub_notification *dmub_notify;
 
+	/**
+	 * @dmub_callback:
+	 *
+	 * Callback functions to handle notification from DMUB.
+	 */
+
+	dmub_notify_interrupt_callback_t dmub_callback[AMDGPU_DMUB_NOTIFICATION_MAX];
+
+	/**
+	 * @dmub_thread_offload:
+	 *
+	 * Flag to indicate if callback is offload.
+	 */
+
+	bool dmub_thread_offload[AMDGPU_DMUB_NOTIFICATION_MAX];
+
 	/**
 	 * @dmub_fb_info:
 	 *
@@ -422,7 +503,12 @@ struct amdgpu_display_manager {
 	 */
 	struct crc_rd_work *crc_rd_wrk;
 #endif
-
+	/**
+	 * @hpd_rx_offload_wq:
+	 *
+	 * Work queue to offload works of hpd_rx_irq
+	 */
+	struct hpd_rx_irq_offload_work_queue *hpd_rx_offload_wq;
 	/**
 	 * @mst_encoders:
 	 *
@@ -439,6 +525,7 @@ struct amdgpu_display_manager {
 	 */
 	struct list_head da_list;
 	struct completion dmub_aux_transfer_done;
+	struct workqueue_struct *delayed_hpd_wq;
 
 	/**
 	 * @brightness:
@@ -452,6 +539,14 @@ struct amdgpu_display_manager {
 	 * last successfully applied backlight values.
 	 */
 	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
+
+	/**
+	 * @aux_hpd_discon_quirk:
+	 *
+	 * quirk for hpd discon while aux is on-going.
+	 * occurred on certain intel platform
+	 */
+	bool aux_hpd_discon_quirk;
 };
 
 enum dsc_clock_force_state {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 74885ff77f96..652cf108b3c2 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -55,6 +55,8 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	ssize_t result = 0;
 	struct aux_payload payload;
 	enum aux_return_code_type operation_result;
+	struct amdgpu_device *adev;
+	struct ddc_service *ddc;
 
 	if (WARN_ON(msg->size > 16))
 		return -E2BIG;
@@ -71,6 +73,21 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
 	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
 				      &operation_result);
 
+	/*
+	 * w/a on certain intel platform where hpd is unexpected to pull low during
+	 * 1st sideband message transaction by return AUX_RET_ERROR_HPD_DISCON
+	 * aux transaction is succuess in such case, therefore bypass the error
+	 */
+	ddc = TO_DM_AUX(aux)->ddc_service;
+	adev = ddc->ctx->driver_context;
+	if (adev->dm.aux_hpd_discon_quirk) {
+		if (msg->address == DP_SIDEBAND_MSG_DOWN_REQ_BASE &&
+			operation_result == AUX_RET_ERROR_HPD_DISCON) {
+			result = 0;
+			operation_result = AUX_RET_SUCCESS;
+		}
+	}
+
 	if (payload.write && result >= 0)
 		result = msg->size;
 
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index b37c4d2e7a1e..1bde9d4e82d4 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1788,6 +1788,11 @@ void dc_post_update_surfaces_to_stream(struct dc *dc)
 
 	post_surface_trace(dc);
 
+	if (dc->ctx->dce_version >= DCE_VERSION_MAX)
+		TRACE_DCN_CLOCK_STATE(&context->bw_ctx.bw.dcn.clk);
+	else
+		TRACE_DCE_CLOCK_STATE(&context->bw_ctx.bw.dce);
+
 	if (is_flip_pending_in_pipes(dc, context))
 		return;
 
@@ -2974,6 +2979,14 @@ void dc_commit_updates_for_stream(struct dc *dc,
 			if (new_pipe->plane_state && new_pipe->plane_state != old_pipe->plane_state)
 				new_pipe->plane_state->force_full_update = true;
 		}
+	} else if (update_type == UPDATE_TYPE_FAST && dc_ctx->dce_version >= DCE_VERSION_MAX) {
+		/*
+		 * Previous frame finished and HW is ready for optimization.
+		 *
+		 * Only relevant for DCN behavior where we can guarantee the optimization
+		 * is safe to apply - retain the legacy behavior for DCE.
+		 */
+		dc_post_update_surfaces_to_stream(dc);
 	}
 
 
@@ -3030,14 +3043,11 @@ void dc_commit_updates_for_stream(struct dc *dc,
 				pipe_ctx->plane_state->force_full_update = false;
 		}
 	}
-	/*let's use current_state to update watermark etc*/
-	if (update_type >= UPDATE_TYPE_FULL) {
-		dc_post_update_surfaces_to_stream(dc);
 
-		if (dc_ctx->dce_version >= DCE_VERSION_MAX)
-			TRACE_DCN_CLOCK_STATE(&context->bw_ctx.bw.dcn.clk);
-		else
-			TRACE_DCE_CLOCK_STATE(&context->bw_ctx.bw.dce);
+	/* Legacy optimization path for DCE. */
+	if (update_type >= UPDATE_TYPE_FULL && dc_ctx->dce_version < DCE_VERSION_MAX) {
+		dc_post_update_surfaces_to_stream(dc);
+		TRACE_DCE_CLOCK_STATE(&context->bw_ctx.bw.dce);
 	}
 
 	return;
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 05f81d44aa6c..6d5dc5ab3d8c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2075,7 +2075,7 @@ static struct dc_link_settings get_max_link_cap(struct dc_link *link)
 	return max_link_cap;
 }
 
-enum dc_status read_hpd_rx_irq_data(
+static enum dc_status read_hpd_rx_irq_data(
 	struct dc_link *link,
 	union hpd_irq_data *irq_data)
 {
@@ -2743,7 +2743,7 @@ void decide_link_settings(struct dc_stream_state *stream,
 }
 
 /*************************Short Pulse IRQ***************************/
-static bool allow_hpd_rx_irq(const struct dc_link *link)
+bool dc_link_dp_allow_hpd_rx_irq(const struct dc_link *link)
 {
 	/*
 	 * Don't handle RX IRQ unless one of following is met:
@@ -3177,7 +3177,7 @@ static void dp_test_get_audio_test_data(struct dc_link *link, bool disable_video
 	}
 }
 
-static void handle_automated_test(struct dc_link *link)
+void dc_link_dp_handle_automated_test(struct dc_link *link)
 {
 	union test_request test_request;
 	union test_response test_response;
@@ -3226,17 +3226,50 @@ static void handle_automated_test(struct dc_link *link)
 			sizeof(test_response));
 }
 
-bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss)
+void dc_link_dp_handle_link_loss(struct dc_link *link)
+{
+	int i;
+	struct pipe_ctx *pipe_ctx;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+		if (pipe_ctx && pipe_ctx->stream && pipe_ctx->stream->link == link)
+			break;
+	}
+
+	if (pipe_ctx == NULL || pipe_ctx->stream == NULL)
+		return;
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+		if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
+				pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe) {
+			core_link_disable_stream(pipe_ctx);
+		}
+	}
+
+	for (i = 0; i < MAX_PIPES; i++) {
+		pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
+		if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
+				pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe) {
+			core_link_enable_stream(link->dc->current_state, pipe_ctx);
+		}
+	}
+}
+
+bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd_irq_dpcd_data, bool *out_link_loss,
+							bool defer_handling, bool *has_left_work)
 {
 	union hpd_irq_data hpd_irq_dpcd_data = { { { {0} } } };
 	union device_service_irq device_service_clear = { { 0 } };
 	enum dc_status result;
 	bool status = false;
-	struct pipe_ctx *pipe_ctx;
-	int i;
 
 	if (out_link_loss)
 		*out_link_loss = false;
+
+	if (has_left_work)
+		*has_left_work = false;
 	/* For use cases related to down stream connection status change,
 	 * PSR and device auto test, refer to function handle_sst_hpd_irq
 	 * in DAL2.1*/
@@ -3268,11 +3301,14 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 			&device_service_clear.raw,
 			sizeof(device_service_clear.raw));
 		device_service_clear.raw = 0;
-		handle_automated_test(link);
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
+		else
+			dc_link_dp_handle_automated_test(link);
 		return false;
 	}
 
-	if (!allow_hpd_rx_irq(link)) {
+	if (!dc_link_dp_allow_hpd_rx_irq(link)) {
 		DC_LOG_HW_HPD_IRQ("%s: skipping HPD handling on %d\n",
 			__func__, link->link_index);
 		return false;
@@ -3286,12 +3322,18 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 	 * so do not handle as a normal sink status change interrupt.
 	 */
 
-	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY)
+	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.UP_REQ_MSG_RDY) {
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
 		return true;
+	}
 
 	/* check if we have MST msg and return since we poll for it */
-	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY)
+	if (hpd_irq_dpcd_data.bytes.device_service_irq.bits.DOWN_REP_MSG_RDY) {
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
 		return false;
+	}
 
 	/* For now we only handle 'Downstream port status' case.
 	 * If we got sink count changed it means
@@ -3308,29 +3350,10 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *link, union hpd_irq_data *out_hpd
 					sizeof(hpd_irq_dpcd_data),
 					"Status: ");
 
-		for (i = 0; i < MAX_PIPES; i++) {
-			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream && pipe_ctx->stream->link == link)
-				break;
-		}
-
-		if (pipe_ctx == NULL || pipe_ctx->stream == NULL)
-			return false;
-
-
-		for (i = 0; i < MAX_PIPES; i++) {
-			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
-					pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe)
-				core_link_disable_stream(pipe_ctx);
-		}
-
-		for (i = 0; i < MAX_PIPES; i++) {
-			pipe_ctx = &link->dc->current_state->res_ctx.pipe_ctx[i];
-			if (pipe_ctx && pipe_ctx->stream && !pipe_ctx->stream->dpms_off &&
-					pipe_ctx->stream->link == link && !pipe_ctx->prev_odm_pipe)
-				core_link_enable_stream(link->dc->current_state, pipe_ctx);
-		}
+		if (defer_handling && has_left_work)
+			*has_left_work = true;
+		else
+			dc_link_dp_handle_link_loss(link);
 
 		status = false;
 		if (out_link_loss)
diff --git a/drivers/gpu/drm/amd/display/dc/dc_link.h b/drivers/gpu/drm/amd/display/dc/dc_link.h
index 83845d006c54..9b7c32f7fd86 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_link.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_link.h
@@ -296,7 +296,8 @@ enum dc_status dc_link_allocate_mst_payload(struct pipe_ctx *pipe_ctx);
  * false - no change in Downstream port status. No further action required
  * from DM. */
 bool dc_link_handle_hpd_rx_irq(struct dc_link *dc_link,
-		union hpd_irq_data *hpd_irq_dpcd_data, bool *out_link_loss);
+		union hpd_irq_data *hpd_irq_dpcd_data, bool *out_link_loss,
+		bool defer_handling, bool *has_left_work);
 
 /*
  * On eDP links this function call will stall until T12 has elapsed.
@@ -305,9 +306,9 @@ bool dc_link_handle_hpd_rx_irq(struct dc_link *dc_link,
  */
 bool dc_link_wait_for_t12(struct dc_link *link);
 
-enum dc_status read_hpd_rx_irq_data(
-	struct dc_link *link,
-	union hpd_irq_data *irq_data);
+void dc_link_dp_handle_automated_test(struct dc_link *link);
+void dc_link_dp_handle_link_loss(struct dc_link *link);
+bool dc_link_dp_allow_hpd_rx_irq(const struct dc_link *link);
 
 struct dc_sink_init_data;
 
diff --git a/drivers/gpu/drm/drm_gem_ttm_helper.c b/drivers/gpu/drm/drm_gem_ttm_helper.c
index ecf3d2a54a98..759c65bfd284 100644
--- a/drivers/gpu/drm/drm_gem_ttm_helper.c
+++ b/drivers/gpu/drm/drm_gem_ttm_helper.c
@@ -64,8 +64,13 @@ int drm_gem_ttm_vmap(struct drm_gem_object *gem,
 		     struct dma_buf_map *map)
 {
 	struct ttm_buffer_object *bo = drm_gem_ttm_of_gem(gem);
+	int ret;
+
+	dma_resv_lock(gem->resv, NULL);
+	ret = ttm_bo_vmap(bo, map);
+	dma_resv_unlock(gem->resv);
 
-	return ttm_bo_vmap(bo, map);
+	return ret;
 }
 EXPORT_SYMBOL(drm_gem_ttm_vmap);
 
@@ -82,7 +87,9 @@ void drm_gem_ttm_vunmap(struct drm_gem_object *gem,
 {
 	struct ttm_buffer_object *bo = drm_gem_ttm_of_gem(gem);
 
+	dma_resv_lock(gem->resv, NULL);
 	ttm_bo_vunmap(bo, map);
+	dma_resv_unlock(gem->resv);
 }
 EXPORT_SYMBOL(drm_gem_ttm_vunmap);
 
diff --git a/drivers/gpu/drm/imx/dcss/dcss-dev.c b/drivers/gpu/drm/imx/dcss/dcss-dev.c
index c849533ca83e..3f5750cc2673 100644
--- a/drivers/gpu/drm/imx/dcss/dcss-dev.c
+++ b/drivers/gpu/drm/imx/dcss/dcss-dev.c
@@ -207,6 +207,7 @@ struct dcss_dev *dcss_dev_create(struct device *dev, bool hdmi_output)
 
 	ret = dcss_submodules_init(dcss);
 	if (ret) {
+		of_node_put(dcss->of_port);
 		dev_err(dev, "submodules initialization failed\n");
 		goto clks_err;
 	}
@@ -237,6 +238,8 @@ void dcss_dev_destroy(struct dcss_dev *dcss)
 		dcss_clocks_disable(dcss);
 	}
 
+	of_node_put(dcss->of_port);
+
 	pm_runtime_disable(dcss->dev);
 
 	dcss_submodules_stop(dcss);
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 3d6f8ee355bf..630cfa4ddd46 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -388,9 +388,9 @@ static irqreturn_t cdns_i2c_slave_isr(void *ptr)
  */
 static irqreturn_t cdns_i2c_master_isr(void *ptr)
 {
-	unsigned int isr_status, avail_bytes, updatetx;
+	unsigned int isr_status, avail_bytes;
 	unsigned int bytes_to_send;
-	bool hold_quirk;
+	bool updatetx;
 	struct cdns_i2c *id = ptr;
 	/* Signal completion only after everything is updated */
 	int done_flag = 0;
@@ -410,11 +410,7 @@ static irqreturn_t cdns_i2c_master_isr(void *ptr)
 	 * Check if transfer size register needs to be updated again for a
 	 * large data receive operation.
 	 */
-	updatetx = 0;
-	if (id->recv_count > id->curr_recv_count)
-		updatetx = 1;
-
-	hold_quirk = (id->quirks & CDNS_I2C_BROKEN_HOLD_BIT) && updatetx;
+	updatetx = id->recv_count > id->curr_recv_count;
 
 	/* When receiving, handle data interrupt and completion interrupt */
 	if (id->p_recv_buf &&
@@ -445,7 +441,7 @@ static irqreturn_t cdns_i2c_master_isr(void *ptr)
 				break;
 			}
 
-			if (cdns_is_holdquirk(id, hold_quirk))
+			if (cdns_is_holdquirk(id, updatetx))
 				break;
 		}
 
@@ -456,7 +452,7 @@ static irqreturn_t cdns_i2c_master_isr(void *ptr)
 		 * maintain transfer size non-zero while performing a large
 		 * receive operation.
 		 */
-		if (cdns_is_holdquirk(id, hold_quirk)) {
+		if (cdns_is_holdquirk(id, updatetx)) {
 			/* wait while fifo is full */
 			while (cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET) !=
 			       (id->curr_recv_count - CDNS_I2C_FIFO_DEPTH))
@@ -478,22 +474,6 @@ static irqreturn_t cdns_i2c_master_isr(void *ptr)
 						  CDNS_I2C_XFER_SIZE_OFFSET);
 				id->curr_recv_count = id->recv_count;
 			}
-		} else if (id->recv_count && !hold_quirk &&
-						!id->curr_recv_count) {
-
-			/* Set the slave address in address register*/
-			cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
-						CDNS_I2C_ADDR_OFFSET);
-
-			if (id->recv_count > CDNS_I2C_TRANSFER_SIZE) {
-				cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-				id->curr_recv_count = CDNS_I2C_TRANSFER_SIZE;
-			} else {
-				cdns_i2c_writereg(id->recv_count,
-						CDNS_I2C_XFER_SIZE_OFFSET);
-				id->curr_recv_count = id->recv_count;
-			}
 		}
 
 		/* Clear hold (if not repeated start) and signal completion */
diff --git a/drivers/i2c/busses/i2c-mlxcpld.c b/drivers/i2c/busses/i2c-mlxcpld.c
index 015e11c4663f..077d716c73ca 100644
--- a/drivers/i2c/busses/i2c-mlxcpld.c
+++ b/drivers/i2c/busses/i2c-mlxcpld.c
@@ -49,7 +49,7 @@
 #define MLXCPLD_LPCI2C_NACK_IND		2
 
 #define MLXCPLD_I2C_FREQ_1000KHZ_SET	0x04
-#define MLXCPLD_I2C_FREQ_400KHZ_SET	0x0c
+#define MLXCPLD_I2C_FREQ_400KHZ_SET	0x0e
 #define MLXCPLD_I2C_FREQ_100KHZ_SET	0x42
 
 enum mlxcpld_i2c_frequency {
diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 632f65e53b63..60d4e9c151ff 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -4221,10 +4221,6 @@ void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
 	struct irdma_cm_node *cm_node;
 	struct list_head teardown_list;
 	struct ib_qp_attr attr;
-	struct irdma_sc_vsi *vsi = &iwdev->vsi;
-	struct irdma_sc_qp *sc_qp;
-	struct irdma_qp *qp;
-	int i;
 
 	INIT_LIST_HEAD(&teardown_list);
 
@@ -4241,52 +4237,6 @@ void irdma_cm_teardown_connections(struct irdma_device *iwdev, u32 *ipaddr,
 			irdma_cm_disconn(cm_node->iwqp);
 		irdma_rem_ref_cm_node(cm_node);
 	}
-	if (!iwdev->roce_mode)
-		return;
-
-	INIT_LIST_HEAD(&teardown_list);
-	for (i = 0; i < IRDMA_MAX_USER_PRIORITY; i++) {
-		mutex_lock(&vsi->qos[i].qos_mutex);
-		list_for_each_safe (list_node, list_core_temp,
-				    &vsi->qos[i].qplist) {
-			u32 qp_ip[4];
-
-			sc_qp = container_of(list_node, struct irdma_sc_qp,
-					     list);
-			if (sc_qp->qp_uk.qp_type != IRDMA_QP_TYPE_ROCE_RC)
-				continue;
-
-			qp = sc_qp->qp_uk.back_qp;
-			if (!disconnect_all) {
-				if (nfo->ipv4)
-					qp_ip[0] = qp->udp_info.local_ipaddr[3];
-				else
-					memcpy(qp_ip,
-					       &qp->udp_info.local_ipaddr[0],
-					       sizeof(qp_ip));
-			}
-
-			if (disconnect_all ||
-			    (nfo->vlan_id == (qp->udp_info.vlan_tag & VLAN_VID_MASK) &&
-			     !memcmp(qp_ip, ipaddr, nfo->ipv4 ? 4 : 16))) {
-				spin_lock(&iwdev->rf->qptable_lock);
-				if (iwdev->rf->qp_table[sc_qp->qp_uk.qp_id]) {
-					irdma_qp_add_ref(&qp->ibqp);
-					list_add(&qp->teardown_entry,
-						 &teardown_list);
-				}
-				spin_unlock(&iwdev->rf->qptable_lock);
-			}
-		}
-		mutex_unlock(&vsi->qos[i].qos_mutex);
-	}
-
-	list_for_each_safe (list_node, list_core_temp, &teardown_list) {
-		qp = container_of(list_node, struct irdma_qp, teardown_entry);
-		attr.qp_state = IB_QPS_ERR;
-		irdma_modify_qp_roce(&qp->ibqp, &attr, IB_QP_STATE, NULL);
-		irdma_qp_rem_ref(&qp->ibqp);
-	}
 }
 
 /**
diff --git a/drivers/infiniband/hw/irdma/i40iw_hw.c b/drivers/infiniband/hw/irdma/i40iw_hw.c
index 64148ad8a604..040d4e2b9767 100644
--- a/drivers/infiniband/hw/irdma/i40iw_hw.c
+++ b/drivers/infiniband/hw/irdma/i40iw_hw.c
@@ -202,6 +202,7 @@ void i40iw_init_hw(struct irdma_sc_dev *dev)
 	dev->hw_attrs.uk_attrs.max_hw_read_sges = I40IW_MAX_SGE_RD;
 	dev->hw_attrs.max_hw_device_pages = I40IW_MAX_PUSH_PAGE_COUNT;
 	dev->hw_attrs.uk_attrs.max_hw_inline = I40IW_MAX_INLINE_DATA_SIZE;
+	dev->hw_attrs.page_size_cap = SZ_4K | SZ_2M;
 	dev->hw_attrs.max_hw_ird = I40IW_MAX_IRD_SIZE;
 	dev->hw_attrs.max_hw_ord = I40IW_MAX_ORD_SIZE;
 	dev->hw_attrs.max_hw_wqes = I40IW_MAX_WQ_ENTRIES;
diff --git a/drivers/infiniband/hw/irdma/icrdma_hw.c b/drivers/infiniband/hw/irdma/icrdma_hw.c
index cf53b17510cd..5986fd906308 100644
--- a/drivers/infiniband/hw/irdma/icrdma_hw.c
+++ b/drivers/infiniband/hw/irdma/icrdma_hw.c
@@ -139,6 +139,7 @@ void icrdma_init_hw(struct irdma_sc_dev *dev)
 	dev->cqp_db = dev->hw_regs[IRDMA_CQPDB];
 	dev->cq_ack_db = dev->hw_regs[IRDMA_CQACK];
 	dev->irq_ops = &icrdma_irq_ops;
+	dev->hw_attrs.page_size_cap = SZ_4K | SZ_2M | SZ_1G;
 	dev->hw_attrs.max_hw_ird = ICRDMA_MAX_IRD_SIZE;
 	dev->hw_attrs.max_hw_ord = ICRDMA_MAX_ORD_SIZE;
 	dev->hw_attrs.max_stat_inst = ICRDMA_MAX_STATS_COUNT;
diff --git a/drivers/infiniband/hw/irdma/irdma.h b/drivers/infiniband/hw/irdma/irdma.h
index 46c12334c735..4789e85d717b 100644
--- a/drivers/infiniband/hw/irdma/irdma.h
+++ b/drivers/infiniband/hw/irdma/irdma.h
@@ -127,6 +127,7 @@ struct irdma_hw_attrs {
 	u64 max_hw_outbound_msg_size;
 	u64 max_hw_inbound_msg_size;
 	u64 max_mr_size;
+	u64 page_size_cap;
 	u32 min_hw_qp_id;
 	u32 min_hw_aeq_size;
 	u32 max_hw_aeq_size;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 8a3ac4257e86..0eef46428691 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -29,7 +29,7 @@ static int irdma_query_device(struct ib_device *ibdev,
 	props->vendor_part_id = pcidev->device;
 
 	props->hw_ver = rf->pcidev->revision;
-	props->page_size_cap = SZ_4K | SZ_2M | SZ_1G;
+	props->page_size_cap = hw_attrs->page_size_cap;
 	props->max_mr_size = hw_attrs->max_mr_size;
 	props->max_qp = rf->max_qp - rf->used_qps;
 	props->max_qp_wr = hw_attrs->max_qp_wr;
@@ -2776,7 +2776,7 @@ static struct ib_mr *irdma_reg_user_mr(struct ib_pd *pd, u64 start, u64 len,
 
 	if (req.reg_type == IRDMA_MEMREG_TYPE_MEM) {
 		iwmr->page_size = ib_umem_find_best_pgsz(region,
-							 SZ_4K | SZ_2M | SZ_1G,
+							 iwdev->rf->sc_dev.hw_attrs.page_size_cap,
 							 virt);
 		if (unlikely(!iwmr->page_size)) {
 			kfree(iwmr);
diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
index b72b387c08ef..aef722dfdef5 100644
--- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
@@ -644,8 +644,8 @@ static int bch_set_geometry(struct gpmi_nand_data *this)
  *         RDN_DELAY = -----------------------     {3}
  *                           RP
  */
-static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
-				     const struct nand_sdr_timings *sdr)
+static int gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
+				    const struct nand_sdr_timings *sdr)
 {
 	struct gpmi_nfc_hardware_timing *hw = &this->hw;
 	struct resources *r = &this->resources;
@@ -655,32 +655,44 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 	unsigned int tRP_ps;
 	bool use_half_period;
 	int sample_delay_ps, sample_delay_factor;
-	u16 busy_timeout_cycles;
+	unsigned int busy_timeout_cycles;
 	u8 wrn_dly_sel;
+	unsigned long clk_rate, min_rate;
+	u64 busy_timeout_ps;
 
 	if (sdr->tRC_min >= 30000) {
 		/* ONFI non-EDO modes [0-3] */
 		hw->clk_rate = 22000000;
+		min_rate = 0;
 		wrn_dly_sel = BV_GPMI_CTRL1_WRN_DLY_SEL_4_TO_8NS;
 	} else if (sdr->tRC_min >= 25000) {
 		/* ONFI EDO mode 4 */
 		hw->clk_rate = 80000000;
+		min_rate = 22000000;
 		wrn_dly_sel = BV_GPMI_CTRL1_WRN_DLY_SEL_NO_DELAY;
 	} else {
 		/* ONFI EDO mode 5 */
 		hw->clk_rate = 100000000;
+		min_rate = 80000000;
 		wrn_dly_sel = BV_GPMI_CTRL1_WRN_DLY_SEL_NO_DELAY;
 	}
 
-	hw->clk_rate = clk_round_rate(r->clock[0], hw->clk_rate);
+	clk_rate = clk_round_rate(r->clock[0], hw->clk_rate);
+	if (clk_rate <= min_rate) {
+		dev_err(this->dev, "clock setting: expected %ld, got %ld\n",
+			hw->clk_rate, clk_rate);
+		return -ENOTSUPP;
+	}
 
+	hw->clk_rate = clk_rate;
 	/* SDR core timings are given in picoseconds */
 	period_ps = div_u64((u64)NSEC_PER_SEC * 1000, hw->clk_rate);
 
 	addr_setup_cycles = TO_CYCLES(sdr->tALS_min, period_ps);
 	data_setup_cycles = TO_CYCLES(sdr->tDS_min, period_ps);
 	data_hold_cycles = TO_CYCLES(sdr->tDH_min, period_ps);
-	busy_timeout_cycles = TO_CYCLES(sdr->tWB_max + sdr->tR_max, period_ps);
+	busy_timeout_ps = max(sdr->tBERS_max, sdr->tPROG_max);
+	busy_timeout_cycles = TO_CYCLES(busy_timeout_ps, period_ps);
 
 	hw->timing0 = BF_GPMI_TIMING0_ADDRESS_SETUP(addr_setup_cycles) |
 		      BF_GPMI_TIMING0_DATA_HOLD(data_hold_cycles) |
@@ -714,6 +726,7 @@ static void gpmi_nfc_compute_timings(struct gpmi_nand_data *this,
 		hw->ctrl1n |= BF_GPMI_CTRL1_RDN_DELAY(sample_delay_factor) |
 			      BM_GPMI_CTRL1_DLL_ENABLE |
 			      (use_half_period ? BM_GPMI_CTRL1_HALF_PERIOD : 0);
+	return 0;
 }
 
 static int gpmi_nfc_apply_timings(struct gpmi_nand_data *this)
@@ -769,6 +782,7 @@ static int gpmi_setup_interface(struct nand_chip *chip, int chipnr,
 {
 	struct gpmi_nand_data *this = nand_get_controller_data(chip);
 	const struct nand_sdr_timings *sdr;
+	int ret;
 
 	/* Retrieve required NAND timings */
 	sdr = nand_get_sdr_timings(conf);
@@ -784,7 +798,9 @@ static int gpmi_setup_interface(struct nand_chip *chip, int chipnr,
 		return 0;
 
 	/* Do the actual derivation of the controller timings */
-	gpmi_nfc_compute_timings(this, sdr);
+	ret = gpmi_nfc_compute_timings(this, sdr);
+	if (ret)
+		return ret;
 
 	this->hw.must_apply_timings = true;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 7c2968a639eb..4c4e6990c0ae 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -414,18 +414,21 @@ int ksz_switch_register(struct ksz_device *dev,
 		ports = of_get_child_by_name(dev->dev->of_node, "ethernet-ports");
 		if (!ports)
 			ports = of_get_child_by_name(dev->dev->of_node, "ports");
-		if (ports)
+		if (ports) {
 			for_each_available_child_of_node(ports, port) {
 				if (of_property_read_u32(port, "reg",
 							 &port_num))
 					continue;
 				if (!(dev->port_mask & BIT(port_num))) {
 					of_node_put(port);
+					of_node_put(ports);
 					return -EINVAL;
 				}
 				of_get_phy_mode(port,
 						&dev->ports[port_num].interface);
 			}
+			of_node_put(ports);
+		}
 		dev->synclko_125 = of_property_read_bool(dev->dev->of_node,
 							 "microchip,synclko-125");
 	}
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 924c3f129992..1a2a7536ff8a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3372,12 +3372,28 @@ static const struct of_device_id sja1105_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, sja1105_dt_ids);
 
+static const struct spi_device_id sja1105_spi_ids[] = {
+	{ "sja1105e" },
+	{ "sja1105t" },
+	{ "sja1105p" },
+	{ "sja1105q" },
+	{ "sja1105r" },
+	{ "sja1105s" },
+	{ "sja1110a" },
+	{ "sja1110b" },
+	{ "sja1110c" },
+	{ "sja1110d" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, sja1105_spi_ids);
+
 static struct spi_driver sja1105_driver = {
 	.driver = {
 		.name  = "sja1105",
 		.owner = THIS_MODULE,
 		.of_match_table = of_match_ptr(sja1105_dt_ids),
 	},
+	.id_table = sja1105_spi_ids,
 	.probe  = sja1105_probe,
 	.remove = sja1105_remove,
 	.shutdown = sja1105_shutdown,
diff --git a/drivers/net/dsa/vitesse-vsc73xx-spi.c b/drivers/net/dsa/vitesse-vsc73xx-spi.c
index 645398901e05..922ae22fad66 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-spi.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-spi.c
@@ -207,10 +207,20 @@ static const struct of_device_id vsc73xx_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, vsc73xx_of_match);
 
+static const struct spi_device_id vsc73xx_spi_ids[] = {
+	{ "vsc7385" },
+	{ "vsc7388" },
+	{ "vsc7395" },
+	{ "vsc7398" },
+	{ },
+};
+MODULE_DEVICE_TABLE(spi, vsc73xx_spi_ids);
+
 static struct spi_driver vsc73xx_spi_driver = {
 	.probe = vsc73xx_spi_probe,
 	.remove = vsc73xx_spi_remove,
 	.shutdown = vsc73xx_spi_shutdown,
+	.id_table = vsc73xx_spi_ids,
 	.driver = {
 		.name = "vsc73xx-spi",
 		.of_match_table = vsc73xx_of_match,
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 4af5561cbfc5..ddfe9208529a 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1236,8 +1236,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	csk->sndbuf = newsk->sk_sndbuf;
 	csk->smac_idx = ((struct port_info *)netdev_priv(ndev))->smt_idx;
 	RCV_WSCALE(tp) = select_rcv_wscale(tcp_full_space(newsk),
-					   sock_net(newsk)->
-						ipv4.sysctl_tcp_window_scaling,
+					   READ_ONCE(sock_net(newsk)->
+						     ipv4.sysctl_tcp_window_scaling),
 					   tp->window_clamp);
 	neigh_release(n);
 	inet_inherit_port(&tcp_hashinfo, lsk, newsk);
@@ -1384,7 +1384,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 #endif
 	}
 	if (req->tcpopt.wsf <= 14 &&
-	    sock_net(sk)->ipv4.sysctl_tcp_window_scaling) {
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling)) {
 		inet_rsk(oreq)->wscale_ok = 1;
 		inet_rsk(oreq)->snd_wscale = req->tcpopt.wsf;
 	}
@@ -1392,7 +1392,7 @@ static void chtls_pass_accept_request(struct sock *sk,
 	th_ecn = tcph->ece && tcph->cwr;
 	if (th_ecn) {
 		ect = !INET_ECN_is_not_ect(ip_dsfield);
-		ecn_ok = sock_net(sk)->ipv4.sysctl_tcp_ecn;
+		ecn_ok = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn);
 		if ((!ect && ecn_ok) || tcp_ca_needs_ecn(sk))
 			inet_rsk(oreq)->ecn_ok = 1;
 	}
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 649c5c429bd7..1288b5e3d220 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -2287,7 +2287,7 @@ int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num, u32 *state)
 
 /* Uses sync mcc */
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data)
+				      u8 page_num, u32 off, u32 len, u8 *data)
 {
 	struct be_dma_mem cmd;
 	struct be_mcc_wrb *wrb;
@@ -2321,10 +2321,10 @@ int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
 	req->port = cpu_to_le32(adapter->hba_port_num);
 	req->page_num = cpu_to_le32(page_num);
 	status = be_mcc_notify_wait(adapter);
-	if (!status) {
+	if (!status && len > 0) {
 		struct be_cmd_resp_port_type *resp = cmd.va;
 
-		memcpy(data, resp->page_data, PAGE_DATA_LEN);
+		memcpy(data, resp->page_data + off, len);
 	}
 err:
 	mutex_unlock(&adapter->mcc_lock);
@@ -2415,7 +2415,7 @@ int be_cmd_query_cable_type(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		switch (adapter->phy.interface_type) {
 		case PHY_TYPE_QSFP:
@@ -2440,7 +2440,7 @@ int be_cmd_query_sfp_info(struct be_adapter *adapter)
 	int status;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		strlcpy(adapter->phy.vendor_name, page_data +
 			SFP_VENDOR_NAME_OFFSET, SFP_VENDOR_NAME_LEN - 1);
diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.h b/drivers/net/ethernet/emulex/benet/be_cmds.h
index c30d6d6f0f3a..9e17d6a7ab8c 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.h
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.h
@@ -2427,7 +2427,7 @@ int be_cmd_set_beacon_state(struct be_adapter *adapter, u8 port_num, u8 beacon,
 int be_cmd_get_beacon_state(struct be_adapter *adapter, u8 port_num,
 			    u32 *state);
 int be_cmd_read_port_transceiver_data(struct be_adapter *adapter,
-				      u8 page_num, u8 *data);
+				      u8 page_num, u32 off, u32 len, u8 *data);
 int be_cmd_query_cable_type(struct be_adapter *adapter);
 int be_cmd_query_sfp_info(struct be_adapter *adapter);
 int lancer_cmd_read_object(struct be_adapter *adapter, struct be_dma_mem *cmd,
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index f9955308b93d..010a0024f3ce 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -1342,7 +1342,7 @@ static int be_get_module_info(struct net_device *netdev,
 		return -EOPNOTSUPP;
 
 	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   page_data);
+						   0, PAGE_DATA_LEN, page_data);
 	if (!status) {
 		if (!page_data[SFP_PLUS_SFF_8472_COMP]) {
 			modinfo->type = ETH_MODULE_SFF_8079;
@@ -1360,25 +1360,32 @@ static int be_get_module_eeprom(struct net_device *netdev,
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	int status;
+	u32 begin, end;
 
 	if (!check_privilege(adapter, MAX_PRIVILEGES))
 		return -EOPNOTSUPP;
 
-	status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0,
-						   data);
-	if (status)
-		goto err;
+	begin = eeprom->offset;
+	end = eeprom->offset + eeprom->len;
+
+	if (begin < PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A0, begin,
+							   min_t(u32, end, PAGE_DATA_LEN) - begin,
+							   data);
+		if (status)
+			goto err;
+
+		data += PAGE_DATA_LEN - begin;
+		begin = PAGE_DATA_LEN;
+	}
 
-	if (eeprom->offset + eeprom->len > PAGE_DATA_LEN) {
-		status = be_cmd_read_port_transceiver_data(adapter,
-							   TR_PAGE_A2,
-							   data +
-							   PAGE_DATA_LEN);
+	if (end > PAGE_DATA_LEN) {
+		status = be_cmd_read_port_transceiver_data(adapter, TR_PAGE_A2,
+							   begin - PAGE_DATA_LEN,
+							   end - begin, data);
 		if (status)
 			goto err;
 	}
-	if (eeprom->offset)
-		memcpy(data, data + eeprom->offset, eeprom->len);
 err:
 	return be_cmd_status(status);
 }
diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index 13382df2f2ef..bcf680e83811 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -630,7 +630,6 @@ struct e1000_phy_info {
 	bool disable_polarity_correction;
 	bool is_mdix;
 	bool polarity_correction;
-	bool reset_disable;
 	bool speed_downgraded;
 	bool autoneg_wait_to_complete;
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index e6c8e6d5234f..9466f65a6da7 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -2050,10 +2050,6 @@ static s32 e1000_check_reset_block_ich8lan(struct e1000_hw *hw)
 	bool blocked = false;
 	int i = 0;
 
-	/* Check the PHY (LCD) reset flag */
-	if (hw->phy.reset_disable)
-		return true;
-
 	while ((blocked = !(er32(FWSM) & E1000_ICH_FWSM_RSPCIPHY)) &&
 	       (i++ < 30))
 		usleep_range(10000, 11000);
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 638a3ddd7ada..2504b11c3169 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -271,7 +271,6 @@
 #define I217_CGFREG_ENABLE_MTA_RESET	0x0002
 #define I217_MEMPWR			PHY_REG(772, 26)
 #define I217_MEMPWR_DISABLE_SMB_RELEASE	0x0010
-#define I217_MEMPWR_MOEM		0x1000
 
 /* Receive Address Initial CRC Calculation */
 #define E1000_PCH_RAICC(_n)	(0x05F50 + ((_n) * 4))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index ce48e630fe55..407bbb4cc236 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6499,6 +6499,10 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
 	    hw->mac.type >= e1000_pch_adp) {
+		/* Keep the GPT clock enabled for CSME */
+		mac_data = er32(FEXTNVM);
+		mac_data |= BIT(3);
+		ew32(FEXTNVM, mac_data);
 		/* Request ME unconfigure the device from S0ix */
 		mac_data = er32(H2ME);
 		mac_data &= ~E1000_H2ME_START_DPG;
@@ -6992,21 +6996,8 @@ static __maybe_unused int e1000e_pm_suspend(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
-	u16 phy_data;
 	int rc;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
-	    hw->mac.type >= e1000_pch_adp) {
-		/* Mask OEM Bits / Gig Disable / Restart AN (772_26[12] = 1) */
-		e1e_rphy(hw, I217_MEMPWR, &phy_data);
-		phy_data |= I217_MEMPWR_MOEM;
-		e1e_wphy(hw, I217_MEMPWR, phy_data);
-
-		/* Disable LCD reset */
-		hw->phy.reset_disable = true;
-	}
-
 	e1000e_flush_lpic(pdev);
 
 	e1000e_pm_freeze(dev);
@@ -7028,8 +7019,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	struct net_device *netdev = pci_get_drvdata(to_pci_dev(dev));
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = to_pci_dev(dev);
-	struct e1000_hw *hw = &adapter->hw;
-	u16 phy_data;
 	int rc;
 
 	/* Introduce S0ix implementation */
@@ -7040,17 +7029,6 @@ static __maybe_unused int e1000e_pm_resume(struct device *dev)
 	if (rc)
 		return rc;
 
-	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
-	    hw->mac.type >= e1000_pch_adp) {
-		/* Unmask OEM Bits / Gig Disable / Restart AN 772_26[12] = 0 */
-		e1e_rphy(hw, I217_MEMPWR, &phy_data);
-		phy_data &= ~I217_MEMPWR_MOEM;
-		e1e_wphy(hw, I217_MEMPWR, phy_data);
-
-		/* Enable LCD reset */
-		hw->phy.reset_disable = false;
-	}
-
 	return e1000e_pm_thaw(dev);
 }
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 02594e4d6258..c801b128e5b2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -10631,7 +10631,7 @@ static int i40e_reset(struct i40e_pf *pf)
  **/
 static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 {
-	int old_recovery_mode_bit = test_bit(__I40E_RECOVERY_MODE, pf->state);
+	const bool is_recovery_mode_reported = i40e_check_recovery_mode(pf);
 	struct i40e_vsi *vsi = pf->vsi[pf->lan_vsi];
 	struct i40e_hw *hw = &pf->hw;
 	i40e_status ret;
@@ -10639,13 +10639,11 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	int v;
 
 	if (test_bit(__I40E_EMP_RESET_INTR_RECEIVED, pf->state) &&
-	    i40e_check_recovery_mode(pf)) {
+	    is_recovery_mode_reported)
 		i40e_set_ethtool_ops(pf->vsi[pf->lan_vsi]->netdev);
-	}
 
 	if (test_bit(__I40E_DOWN, pf->state) &&
-	    !test_bit(__I40E_RECOVERY_MODE, pf->state) &&
-	    !old_recovery_mode_bit)
+	    !test_bit(__I40E_RECOVERY_MODE, pf->state))
 		goto clear_recovery;
 	dev_dbg(&pf->pdev->dev, "Rebuilding internal switch\n");
 
@@ -10672,13 +10670,12 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	 * accordingly with regard to resources initialization
 	 * and deinitialization
 	 */
-	if (test_bit(__I40E_RECOVERY_MODE, pf->state) ||
-	    old_recovery_mode_bit) {
+	if (test_bit(__I40E_RECOVERY_MODE, pf->state)) {
 		if (i40e_get_capabilities(pf,
 					  i40e_aqc_opc_list_func_capabilities))
 			goto end_unlock;
 
-		if (test_bit(__I40E_RECOVERY_MODE, pf->state)) {
+		if (is_recovery_mode_reported) {
 			/* we're staying in recovery mode so we'll reinitialize
 			 * misc vector here
 			 */
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 3525eab8e9f9..5448ed0e0357 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1250,11 +1250,10 @@ static struct iavf_rx_buffer *iavf_get_rx_buffer(struct iavf_ring *rx_ring,
 {
 	struct iavf_rx_buffer *rx_buffer;
 
-	if (!size)
-		return NULL;
-
 	rx_buffer = &rx_ring->rx_bi[rx_ring->next_to_clean];
 	prefetchw(rx_buffer->page);
+	if (!size)
+		return rx_buffer;
 
 	/* we are reusing so sync this buffer for CPU use */
 	dma_sync_single_range_for_cpu(rx_ring->dev,
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index f99819fc559d..2a84f57ea68b 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6159,6 +6159,9 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg)
 	u8 __iomem *hw_addr = READ_ONCE(hw->hw_addr);
 	u32 value = 0;
 
+	if (IGC_REMOVED(hw_addr))
+		return ~value;
+
 	value = readl(&hw_addr[reg]);
 
 	/* reads should not return all F's */
diff --git a/drivers/net/ethernet/intel/igc/igc_regs.h b/drivers/net/ethernet/intel/igc/igc_regs.h
index e197a33d93a0..026c3b65fc37 100644
--- a/drivers/net/ethernet/intel/igc/igc_regs.h
+++ b/drivers/net/ethernet/intel/igc/igc_regs.h
@@ -306,7 +306,8 @@ u32 igc_rd32(struct igc_hw *hw, u32 reg);
 #define wr32(reg, val) \
 do { \
 	u8 __iomem *hw_addr = READ_ONCE((hw)->hw_addr); \
-	writel((val), &hw_addr[(reg)]); \
+	if (!IGC_REMOVED(hw_addr)) \
+		writel((val), &hw_addr[(reg)]); \
 } while (0)
 
 #define rd32(reg) (igc_rd32(hw, reg))
@@ -318,4 +319,6 @@ do { \
 
 #define array_rd32(reg, offset) (igc_rd32(hw, (reg) + ((offset) << 2)))
 
+#define IGC_REMOVED(h) unlikely(!(h))
+
 #endif
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index a604552fa634..c375a5d54b40 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -770,6 +770,7 @@ struct ixgbe_adapter {
 #ifdef CONFIG_IXGBE_IPSEC
 	struct ixgbe_ipsec *ipsec;
 #endif /* CONFIG_IXGBE_IPSEC */
+	spinlock_t vfs_lock;
 };
 
 static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 750b02bb2fdc..8cb20af51ecd 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6397,6 +6397,9 @@ static int ixgbe_sw_init(struct ixgbe_adapter *adapter,
 	/* n-tuple support exists, always init our spinlock */
 	spin_lock_init(&adapter->fdir_perfect_lock);
 
+	/* init spinlock to avoid concurrency of VF resources */
+	spin_lock_init(&adapter->vfs_lock);
+
 #ifdef CONFIG_IXGBE_DCB
 	ixgbe_init_dcb(adapter);
 #endif
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index aaebdae8b5ff..0078ae592616 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -204,10 +204,13 @@ void ixgbe_enable_sriov(struct ixgbe_adapter *adapter, unsigned int max_vfs)
 int ixgbe_disable_sriov(struct ixgbe_adapter *adapter)
 {
 	unsigned int num_vfs = adapter->num_vfs, vf;
+	unsigned long flags;
 	int rss;
 
+	spin_lock_irqsave(&adapter->vfs_lock, flags);
 	/* set num VFs to 0 to prevent access to vfinfo */
 	adapter->num_vfs = 0;
+	spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 
 	/* put the reference to all of the vf devices */
 	for (vf = 0; vf < num_vfs; ++vf) {
@@ -1305,8 +1308,10 @@ static void ixgbe_rcv_ack_from_vf(struct ixgbe_adapter *adapter, u32 vf)
 void ixgbe_msg_task(struct ixgbe_adapter *adapter)
 {
 	struct ixgbe_hw *hw = &adapter->hw;
+	unsigned long flags;
 	u32 vf;
 
+	spin_lock_irqsave(&adapter->vfs_lock, flags);
 	for (vf = 0; vf < adapter->num_vfs; vf++) {
 		/* process any reset requests */
 		if (!ixgbe_check_for_rst(hw, vf))
@@ -1320,6 +1325,7 @@ void ixgbe_msg_task(struct ixgbe_adapter *adapter)
 		if (!ixgbe_check_for_ack(hw, vf))
 			ixgbe_rcv_ack_from_vf(adapter, vf);
 	}
+	spin_unlock_irqrestore(&adapter->vfs_lock, flags);
 }
 
 void ixgbe_disable_tx_rx(struct ixgbe_adapter *adapter)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d7d90cdce4f6..55de90d5ae59 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5196,7 +5196,7 @@ static bool mlxsw_sp_fi_is_gateway(const struct mlxsw_sp *mlxsw_sp,
 {
 	const struct fib_nh *nh = fib_info_nh(fi, 0);
 
-	return nh->fib_nh_scope == RT_SCOPE_LINK ||
+	return nh->fib_nh_gw_family ||
 	       mlxsw_sp_nexthop4_ipip_type(mlxsw_sp, nh, NULL);
 }
 
@@ -9588,7 +9588,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 	unsigned long *fields = config->fields;
 	u32 hash_fields;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		mlxsw_sp_mp4_hash_outer_addr(config);
 		break;
@@ -9606,7 +9606,7 @@ static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_mp_hash_inner_l3(config);
 		break;
 	case 3:
-		hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+		hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 		/* Outer */
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_NOT_TCP_NOT_UDP);
 		MLXSW_SP_MP_HASH_HEADER_SET(headers, IPV4_EN_TCP_UDP);
@@ -9787,13 +9787,14 @@ static int mlxsw_sp_dscp_init(struct mlxsw_sp *mlxsw_sp)
 static int __mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct net *net = mlxsw_sp_net(mlxsw_sp);
-	bool usp = net->ipv4.sysctl_ip_fwd_update_priority;
 	char rgcr_pl[MLXSW_REG_RGCR_LEN];
 	u64 max_rifs;
+	bool usp;
 
 	if (!MLXSW_CORE_RES_VALID(mlxsw_sp->core, MAX_RIFS))
 		return -EIO;
 	max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
+	usp = READ_ONCE(net->ipv4.sysctl_ip_fwd_update_priority);
 
 	mlxsw_reg_rgcr_pack(rgcr_pl, true, true);
 	mlxsw_reg_rgcr_max_router_interfaces_set(rgcr_pl, max_rifs);
diff --git a/drivers/net/ethernet/netronome/nfp/flower/action.c b/drivers/net/ethernet/netronome/nfp/flower/action.c
index 2a432de11858..df5a6a0bf1d5 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/action.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
@@ -472,7 +472,7 @@ nfp_fl_set_tun(struct nfp_app *app, struct nfp_fl_set_tun *set_tun,
 			set_tun->ttl = ip4_dst_hoplimit(&rt->dst);
 			ip_rt_put(rt);
 		} else {
-			set_tun->ttl = net->ipv4.sysctl_ip_default_ttl;
+			set_tun->ttl = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 		}
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index b21745368983..412abfabd28b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -219,6 +219,9 @@ static void dwmac4_map_mtl_dma(struct mac_device_info *hw, u32 queue, u32 chan)
 	if (queue == 0 || queue == 4) {
 		value &= ~MTL_RXQ_DMA_Q04MDMACH_MASK;
 		value |= MTL_RXQ_DMA_Q04MDMACH(chan);
+	} else if (queue > 4) {
+		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue - 4);
+		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue - 4);
 	} else {
 		value &= ~MTL_RXQ_DMA_QXMDMACH_MASK(queue);
 		value |= MTL_RXQ_DMA_QXMDMACH(chan, queue);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 8f563b446d5c..dc31501fec8f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -800,14 +800,6 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
-	if (priv->hw->xpcs) {
-		ret = xpcs_config_eee(priv->hw->xpcs,
-				      priv->plat->mult_fact_100ns,
-				      edata->eee_enabled);
-		if (ret)
-			return ret;
-	}
-
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 9c1e19ea6fcd..b4f83c865568 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -844,19 +844,10 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	struct timespec64 now;
 	u32 sec_inc = 0;
 	u64 temp = 0;
-	int ret;
 
 	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
 		return -EOPNOTSUPP;
 
-	ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
-	if (ret < 0) {
-		netdev_warn(priv->dev,
-			    "failed to enable PTP reference clock: %pe\n",
-			    ERR_PTR(ret));
-		return ret;
-	}
-
 	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
 	priv->systime_flags = systime_flags;
 
@@ -3325,6 +3316,14 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 
 	stmmac_mmc_setup(priv);
 
+	if (ptp_register) {
+		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+		if (ret < 0)
+			netdev_warn(priv->dev,
+				    "failed to enable PTP reference clock: %pe\n",
+				    ERR_PTR(ret));
+	}
+
 	ret = stmmac_init_ptp(priv);
 	if (ret == -EOPNOTSUPP)
 		netdev_warn(priv->dev, "PTP not supported by HW\n");
@@ -7279,8 +7278,6 @@ int stmmac_dvr_remove(struct device *dev)
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
 	pm_runtime_get_sync(dev);
-	pm_runtime_disable(dev);
-	pm_runtime_put_noidle(dev);
 
 	stmmac_stop_all_dma(priv);
 	stmmac_mac_set(priv, priv->ioaddr, false);
@@ -7307,6 +7304,9 @@ int stmmac_dvr_remove(struct device *dev)
 	mutex_destroy(&priv->lock);
 	bitmap_free(priv->af_xdp_zc_qps);
 
+	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_dvr_remove);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 11e1055e8260..9f5cac4000da 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -815,7 +815,13 @@ static int __maybe_unused stmmac_pltfr_noirq_resume(struct device *dev)
 		if (ret)
 			return ret;
 
-		stmmac_init_tstamp_counter(priv, priv->systime_flags);
+		ret = clk_prepare_enable(priv->plat->clk_ptp_ref);
+		if (ret < 0) {
+			netdev_warn(priv->dev,
+				    "failed to enable PTP reference clock: %pe\n",
+				    ERR_PTR(ret));
+			return ret;
+		}
 	}
 
 	return 0;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index ea60453fe69a..f92d6a12831f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1097,7 +1097,10 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 
 	len = run_ebpf_filter(tun, skb, len);
-	if (len == 0 || pskb_trim(skb, len))
+	if (len == 0)
+		goto drop;
+
+	if (pskb_trim(skb, len))
 		goto drop;
 
 	if (unlikely(skb_orphan_frags_rx(skb, GFP_ATOMIC)))
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 0a2c3860179e..e1b9b78b474e 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1796,7 +1796,7 @@ static const struct driver_info ax88179_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1809,7 +1809,7 @@ static const struct driver_info ax88178a_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1822,7 +1822,7 @@ static const struct driver_info cypress_GX3_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1835,7 +1835,7 @@ static const struct driver_info dlink_dub1312_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1848,7 +1848,7 @@ static const struct driver_info sitecom_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1861,7 +1861,7 @@ static const struct driver_info samsung_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1874,7 +1874,7 @@ static const struct driver_info lenovo_info = {
 	.link_reset = ax88179_link_reset,
 	.reset = ax88179_reset,
 	.stop = ax88179_stop,
-	.flags = FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags = FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1887,7 +1887,7 @@ static const struct driver_info belkin_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1900,7 +1900,7 @@ static const struct driver_info toshiba_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop = ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
@@ -1913,7 +1913,7 @@ static const struct driver_info mct_info = {
 	.link_reset = ax88179_link_reset,
 	.reset	= ax88179_reset,
 	.stop	= ax88179_stop,
-	.flags	= FLAG_ETHER | FLAG_FRAMING_AX,
+	.flags	= FLAG_ETHER | FLAG_FRAMING_AX | FLAG_SEND_ZLP,
 	.rx_fixup = ax88179_rx_fixup,
 	.tx_fixup = ax88179_tx_fixup,
 };
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d467a9f3bb44..0d1d92ef7909 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -32,7 +32,7 @@
 #define NETNEXT_VERSION		"12"
 
 /* Information for net */
-#define NET_VERSION		"12"
+#define NET_VERSION		"13"
 
 #define DRIVER_VERSION		"v1." NETNEXT_VERSION "." NET_VERSION
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
@@ -5915,7 +5915,8 @@ static void r8153_enter_oob(struct r8152 *tp)
 
 	wait_oob_link_list_ready(tp);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
 
 	switch (tp->version) {
 	case RTL_VER_03:
@@ -5951,6 +5952,10 @@ static void r8153_enter_oob(struct r8152 *tp)
 	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+
 	rxdy_gated_en(tp, false);
 
 	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
@@ -6553,6 +6558,9 @@ static void rtl8156_down(struct r8152 *tp)
 	rtl_disable(tp);
 	rtl_reset_bmu(tp);
 
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
+
 	/* Clear teredo wake event. bit[15:8] is the teredo wakeup
 	 * type. Set it to zero. bits[7:0] are the W1C bits about
 	 * the events. Set them to all 1 to clear them.
@@ -6563,6 +6571,10 @@ static void rtl8156_down(struct r8152 *tp)
 	ocp_data |= NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+
 	rtl_rx_vlan_en(tp, true);
 	rxdy_gated_en(tp, false);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
index 45d0b36d79b5..d552c656ac9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/uefi.h
@@ -2,7 +2,8 @@
 /*
  * Copyright(c) 2021 Intel Corporation
  */
-
+#ifndef __iwl_fw_uefi__
+#define __iwl_fw_uefi__
 
 #define IWL_UEFI_OEM_PNVM_NAME		L"UefiCnvWlanOemSignedPnvm"
 #define IWL_UEFI_REDUCED_POWER_NAME	L"UefiCnvWlanReducedPower"
@@ -40,3 +41,5 @@ void *iwl_uefi_get_reduced_power(struct iwl_trans *trans, size_t *len)
 	return ERR_PTR(-EOPNOTSUPP);
 }
 #endif /* CONFIG_EFI */
+
+#endif /* __iwl_fw_uefi__ */
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index d03aedc3286b..029599d68ca7 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1100,7 +1100,7 @@ mt76_sta_add(struct mt76_dev *dev, struct ieee80211_vif *vif,
 			continue;
 
 		mtxq = (struct mt76_txq *)sta->txq[i]->drv_priv;
-		mtxq->wcid = wcid;
+		mtxq->wcid = wcid->idx;
 	}
 
 	ewma_signal_init(&wcid->rssi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 6e4d69715927..d1f00706d41e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -263,7 +263,7 @@ struct mt76_wcid {
 };
 
 struct mt76_txq {
-	struct mt76_wcid *wcid;
+	u16 wcid;
 
 	u16 agg_ssn;
 	bool send_bar;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index 7f52a4a11cea..0b7b87b4cc21 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -74,7 +74,7 @@ mt7603_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	mt7603_wtbl_init(dev, idx, mvif->idx, bc_addr);
 
 	mtxq = (struct mt76_txq *)vif->txq->drv_priv;
-	mtxq->wcid = &mvif->sta.wcid;
+	mtxq->wcid = idx;
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
index 60a41d082961..7c52a4d85cea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -235,7 +235,7 @@ static int mt7615_add_interface(struct ieee80211_hw *hw,
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 	if (vif->txq) {
 		mtxq = (struct mt76_txq *)vif->txq->drv_priv;
-		mtxq->wcid = &mvif->sta.wcid;
+		mtxq->wcid = idx;
 	}
 
 	ret = mt7615_mcu_add_dev_info(phy, vif, true);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index ccdbab341271..db7a4ffcad55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -288,7 +288,8 @@ mt76x02_vif_init(struct mt76x02_dev *dev, struct ieee80211_vif *vif,
 	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
 	mtxq = (struct mt76_txq *)vif->txq->drv_priv;
-	mtxq->wcid = &mvif->group_wcid;
+	rcu_assign_pointer(dev->mt76.wcid[MT_VIF_WCID(idx)], &mvif->group_wcid);
+	mtxq->wcid = MT_VIF_WCID(idx);
 }
 
 int
@@ -341,6 +342,7 @@ void mt76x02_remove_interface(struct ieee80211_hw *hw,
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
 
 	dev->mt76.vif_mask &= ~BIT(mvif->idx);
+	rcu_assign_pointer(dev->mt76.wcid[mvif->group_wcid.idx], NULL);
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_interface);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/main.c b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
index c25f8da590dd..6aca470e2401 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/main.c
@@ -243,7 +243,7 @@ static int mt7915_add_interface(struct ieee80211_hw *hw,
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 	if (vif->txq) {
 		mtxq = (struct mt76_txq *)vif->txq->drv_priv;
-		mtxq->wcid = &mvif->sta.wcid;
+		mtxq->wcid = idx;
 	}
 
 	if (vif->type != NL80211_IFTYPE_AP &&
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 13a7ae3d8351..6cb65391427f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -283,7 +283,7 @@ static int mt7921_add_interface(struct ieee80211_hw *hw,
 	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
 	if (vif->txq) {
 		mtxq = (struct mt76_txq *)vif->txq->drv_priv;
-		mtxq->wcid = &mvif->sta.wcid;
+		mtxq->wcid = idx;
 	}
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index dabc0de2ec65..9b490ff36bd6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -1306,7 +1306,7 @@ int mt7921_mcu_sta_update(struct mt7921_dev *dev, struct ieee80211_sta *sta,
 	return mt76_connac_mcu_sta_cmd(&dev->mphy, &info);
 }
 
-int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
+int __mt7921e_mcu_drv_pmctrl(struct mt7921_dev *dev)
 {
 	int i, err = 0;
 
@@ -1325,28 +1325,38 @@ int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 	return err;
 }
 
-int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
+int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
 {
 	struct mt76_phy *mphy = &dev->mt76.phy;
 	struct mt76_connac_pm *pm = &dev->pm;
-	int err = 0;
-
-	mutex_lock(&pm->mutex);
+	int err;
 
-	if (!test_bit(MT76_STATE_PM, &mphy->state))
+	err = __mt7921e_mcu_drv_pmctrl(dev);
+	if (err < 0)
 		goto out;
 
-	err = __mt7921_mcu_drv_pmctrl(dev);
-        if (err < 0)
-            goto out;
-
 	mt7921_wpdma_reinit_cond(dev);
 	clear_bit(MT76_STATE_PM, &mphy->state);
 
 	pm->stats.last_wake_event = jiffies;
 	pm->stats.doze_time += pm->stats.last_wake_event -
 			       pm->stats.last_doze_event;
+out:
+	return err;
+}
 
+int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev)
+{
+	struct mt76_phy *mphy = &dev->mt76.phy;
+	struct mt76_connac_pm *pm = &dev->pm;
+	int err = 0;
+
+	mutex_lock(&pm->mutex);
+
+	if (!test_bit(MT76_STATE_PM, &mphy->state))
+		goto out;
+
+	err = __mt7921_mcu_drv_pmctrl(dev);
 out:
 	mutex_unlock(&pm->mutex);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 32d4f2cab94e..6eb03d6705a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -374,6 +374,7 @@ int mt7921_mcu_uni_rx_ba(struct mt7921_dev *dev,
 			 bool enable);
 void mt7921_scan_work(struct work_struct *work);
 int mt7921_mcu_uni_bss_ps(struct mt7921_dev *dev, struct ieee80211_vif *vif);
+int __mt7921e_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int __mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_drv_pmctrl(struct mt7921_dev *dev);
 int mt7921_mcu_fw_pmctrl(struct mt7921_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
index 3d35838ef306..36e6495ae658 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci.c
@@ -95,36 +95,37 @@ static u32 __mt7921_reg_addr(struct mt7921_dev *dev, u32 addr)
 		u32 mapped;
 		u32 size;
 	} fixed_map[] = {
-		{ 0x00400000, 0x80000, 0x10000}, /* WF_MCU_SYSRAM */
-		{ 0x00410000, 0x90000, 0x10000}, /* WF_MCU_SYSRAM (configure register) */
-		{ 0x40000000, 0x70000, 0x10000}, /* WF_UMAC_SYSRAM */
+		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
+		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
+		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
+		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
+		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
+		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
+		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
+		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
+		{ 0x00400000, 0x80000, 0x10000 }, /* WF_MCU_SYSRAM */
+		{ 0x00410000, 0x90000, 0x10000 }, /* WF_MCU_SYSRAM (configure register) */
+		{ 0x40000000, 0x70000, 0x10000 }, /* WF_UMAC_SYSRAM */
 		{ 0x54000000, 0x02000, 0x1000 }, /* WFDMA PCIE0 MCU DMA0 */
 		{ 0x55000000, 0x03000, 0x1000 }, /* WFDMA PCIE0 MCU DMA1 */
 		{ 0x58000000, 0x06000, 0x1000 }, /* WFDMA PCIE1 MCU DMA0 (MEM_DMA) */
 		{ 0x59000000, 0x07000, 0x1000 }, /* WFDMA PCIE1 MCU DMA1 */
 		{ 0x7c000000, 0xf0000, 0x10000 }, /* CONN_INFRA */
 		{ 0x7c020000, 0xd0000, 0x10000 }, /* CONN_INFRA, WFDMA */
-		{ 0x7c060000, 0xe0000, 0x10000}, /* CONN_INFRA, conn_host_csr_top */
+		{ 0x7c060000, 0xe0000, 0x10000 }, /* CONN_INFRA, conn_host_csr_top */
 		{ 0x80020000, 0xb0000, 0x10000 }, /* WF_TOP_MISC_OFF */
 		{ 0x81020000, 0xc0000, 0x10000 }, /* WF_TOP_MISC_ON */
 		{ 0x820c0000, 0x08000, 0x4000 }, /* WF_UMAC_TOP (PLE) */
 		{ 0x820c8000, 0x0c000, 0x2000 }, /* WF_UMAC_TOP (PSE) */
-		{ 0x820cc000, 0x0e000, 0x2000 }, /* WF_UMAC_TOP (PP) */
+		{ 0x820cc000, 0x0e000, 0x1000 }, /* WF_UMAC_TOP (PP) */
+		{ 0x820cd000, 0x0f000, 0x1000 }, /* WF_MDP_TOP */
 		{ 0x820ce000, 0x21c00, 0x0200 }, /* WF_LMAC_TOP (WF_SEC) */
 		{ 0x820cf000, 0x22000, 0x1000 }, /* WF_LMAC_TOP (WF_PF) */
-		{ 0x820d0000, 0x30000, 0x10000 }, /* WF_LMAC_TOP (WF_WTBLON) */
 		{ 0x820e0000, 0x20000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_CFG) */
 		{ 0x820e1000, 0x20400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_TRB) */
-		{ 0x820e2000, 0x20800, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_AGG) */
-		{ 0x820e3000, 0x20c00, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_ARB) */
-		{ 0x820e4000, 0x21000, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_TMAC) */
-		{ 0x820e5000, 0x21400, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_RMAC) */
-		{ 0x820e7000, 0x21e00, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_DMA) */
 		{ 0x820e9000, 0x23400, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_WTBLOFF) */
 		{ 0x820ea000, 0x24000, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_ETBF) */
-		{ 0x820eb000, 0x24200, 0x0400 }, /* WF_LMAC_TOP BN0 (WF_LPON) */
 		{ 0x820ec000, 0x24600, 0x0200 }, /* WF_LMAC_TOP BN0 (WF_INT) */
-		{ 0x820ed000, 0x24800, 0x0800 }, /* WF_LMAC_TOP BN0 (WF_MIB) */
 		{ 0x820f0000, 0xa0000, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_CFG) */
 		{ 0x820f1000, 0xa0600, 0x0200 }, /* WF_LMAC_TOP BN1 (WF_TRB) */
 		{ 0x820f2000, 0xa0800, 0x0400 }, /* WF_LMAC_TOP BN1 (WF_AGG) */
@@ -191,7 +192,6 @@ static u32 mt7921_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
 	return dev->bus_ops->rmw(mdev, addr, mask, val);
 }
 
-
 static int mt7921_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *id)
 {
@@ -264,7 +264,7 @@ static int mt7921_pci_probe(struct pci_dev *pdev,
 	bus_ops->rmw = mt7921_rmw;
 	dev->mt76.bus = bus_ops;
 
-	ret = __mt7921_mcu_drv_pmctrl(dev);
+	ret = __mt7921e_mcu_drv_pmctrl(dev);
 	if (ret)
 		goto err_free_dev;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
index 41c2855e7a3d..9266fb3909ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/regs.h
@@ -14,7 +14,7 @@
 #define MT_MCU_INT_EVENT_SER_TRIGGER	BIT(2)
 #define MT_MCU_INT_EVENT_RESET_DONE	BIT(3)
 
-#define MT_PLE_BASE			0x8000
+#define MT_PLE_BASE			0x820c0000
 #define MT_PLE(ofs)			(MT_PLE_BASE + (ofs))
 
 #define MT_PLE_FL_Q0_CTRL		MT_PLE(0x3e0)
@@ -25,7 +25,7 @@
 #define MT_PLE_AC_QEMPTY(_n)		MT_PLE(0x500 + 0x40 * (_n))
 #define MT_PLE_AMSDU_PACK_MSDU_CNT(n)	MT_PLE(0x10e0 + ((n) << 2))
 
-#define MT_MDP_BASE			0xf000
+#define MT_MDP_BASE			0x820cd000
 #define MT_MDP(ofs)			(MT_MDP_BASE + (ofs))
 
 #define MT_MDP_DCR0			MT_MDP(0x000)
@@ -48,7 +48,7 @@
 #define MT_MDP_TO_WM			1
 
 /* TMAC: band 0(0x21000), band 1(0xa1000) */
-#define MT_WF_TMAC_BASE(_band)		((_band) ? 0xa1000 : 0x21000)
+#define MT_WF_TMAC_BASE(_band)		((_band) ? 0x820f4000 : 0x820e4000)
 #define MT_WF_TMAC(_band, ofs)		(MT_WF_TMAC_BASE(_band) + (ofs))
 
 #define MT_TMAC_TCR0(_band)		MT_WF_TMAC(_band, 0)
@@ -73,7 +73,7 @@
 #define MT_TMAC_TRCR0(_band)		MT_WF_TMAC(_band, 0x09c)
 #define MT_TMAC_TFCR0(_band)		MT_WF_TMAC(_band, 0x1e0)
 
-#define MT_WF_DMA_BASE(_band)		((_band) ? 0xa1e00 : 0x21e00)
+#define MT_WF_DMA_BASE(_band)		((_band) ? 0x820f7000 : 0x820e7000)
 #define MT_WF_DMA(_band, ofs)		(MT_WF_DMA_BASE(_band) + (ofs))
 
 #define MT_DMA_DCR0(_band)		MT_WF_DMA(_band, 0x000)
@@ -81,7 +81,7 @@
 #define MT_DMA_DCR0_RXD_G5_EN		BIT(23)
 
 /* LPON: band 0(0x24200), band 1(0xa4200) */
-#define MT_WF_LPON_BASE(_band)		((_band) ? 0xa4200 : 0x24200)
+#define MT_WF_LPON_BASE(_band)		((_band) ? 0x820fb000 : 0x820eb000)
 #define MT_WF_LPON(_band, ofs)		(MT_WF_LPON_BASE(_band) + (ofs))
 
 #define MT_LPON_UTTR0(_band)		MT_WF_LPON(_band, 0x080)
@@ -92,7 +92,7 @@
 #define MT_LPON_TCR_SW_WRITE		BIT(0)
 
 /* MIB: band 0(0x24800), band 1(0xa4800) */
-#define MT_WF_MIB_BASE(_band)		((_band) ? 0xa4800 : 0x24800)
+#define MT_WF_MIB_BASE(_band)		((_band) ? 0x820fd000 : 0x820ed000)
 #define MT_WF_MIB(_band, ofs)		(MT_WF_MIB_BASE(_band) + (ofs))
 
 #define MT_MIB_SCR1(_band)		MT_WF_MIB(_band, 0x004)
@@ -141,7 +141,7 @@
 #define MT_MIB_ARNG(_band, n)		MT_WF_MIB(_band, 0x0b0 + ((n) << 2))
 #define MT_MIB_ARNCR_RANGE(val, n)	(((val) >> ((n) << 3)) & GENMASK(7, 0))
 
-#define MT_WTBLON_TOP_BASE		0x34000
+#define MT_WTBLON_TOP_BASE		0x820d4000
 #define MT_WTBLON_TOP(ofs)		(MT_WTBLON_TOP_BASE + (ofs))
 #define MT_WTBLON_TOP_WDUCR		MT_WTBLON_TOP(0x200)
 #define MT_WTBLON_TOP_WDUCR_GROUP	GENMASK(2, 0)
@@ -151,7 +151,7 @@
 #define MT_WTBL_UPDATE_ADM_COUNT_CLEAR	BIT(12)
 #define MT_WTBL_UPDATE_BUSY		BIT(31)
 
-#define MT_WTBL_BASE			0x38000
+#define MT_WTBL_BASE			0x820d8000
 #define MT_WTBL_LMAC_ID			GENMASK(14, 8)
 #define MT_WTBL_LMAC_DW			GENMASK(7, 2)
 #define MT_WTBL_LMAC_OFFS(_id, _dw)	(MT_WTBL_BASE | \
@@ -159,7 +159,7 @@
 					FIELD_PREP(MT_WTBL_LMAC_DW, _dw))
 
 /* AGG: band 0(0x20800), band 1(0xa0800) */
-#define MT_WF_AGG_BASE(_band)		((_band) ? 0xa0800 : 0x20800)
+#define MT_WF_AGG_BASE(_band)		((_band) ? 0x820f2000 : 0x820e2000)
 #define MT_WF_AGG(_band, ofs)		(MT_WF_AGG_BASE(_band) + (ofs))
 
 #define MT_AGG_AWSCR0(_band, _n)	MT_WF_AGG(_band, 0x05c + (_n) * 4)
@@ -190,7 +190,7 @@
 #define MT_AGG_ATCR3(_band)		MT_WF_AGG(_band, 0x0f4)
 
 /* ARB: band 0(0x20c00), band 1(0xa0c00) */
-#define MT_WF_ARB_BASE(_band)		((_band) ? 0xa0c00 : 0x20c00)
+#define MT_WF_ARB_BASE(_band)		((_band) ? 0x820f3000 : 0x820e3000)
 #define MT_WF_ARB(_band, ofs)		(MT_WF_ARB_BASE(_band) + (ofs))
 
 #define MT_ARB_SCR(_band)		MT_WF_ARB(_band, 0x080)
@@ -200,7 +200,7 @@
 #define MT_ARB_DRNGR0(_band, _n)	MT_WF_ARB(_band, 0x194 + (_n) * 4)
 
 /* RMAC: band 0(0x21400), band 1(0xa1400) */
-#define MT_WF_RMAC_BASE(_band)		((_band) ? 0xa1400 : 0x21400)
+#define MT_WF_RMAC_BASE(_band)		((_band) ? 0x820f5000 : 0x820e5000)
 #define MT_WF_RMAC(_band, ofs)		(MT_WF_RMAC_BASE(_band) + (ofs))
 
 #define MT_WF_RFCR(_band)		MT_WF_RMAC(_band, 0x000)
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index f0f7a913eaab..dce6f6b5f071 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -406,12 +406,11 @@ mt76_txq_stopped(struct mt76_queue *q)
 
 static int
 mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_queue *q,
-		    struct mt76_txq *mtxq)
+		    struct mt76_txq *mtxq, struct mt76_wcid *wcid)
 {
 	struct mt76_dev *dev = phy->dev;
 	struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
 	enum mt76_txq_id qid = mt76_txq_get_qid(txq);
-	struct mt76_wcid *wcid = mtxq->wcid;
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
 	int n_frames = 1;
@@ -491,8 +490,8 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 			break;
 
 		mtxq = (struct mt76_txq *)txq->drv_priv;
-		wcid = mtxq->wcid;
-		if (wcid && test_bit(MT_WCID_FLAG_PS, &wcid->flags))
+		wcid = rcu_dereference(dev->wcid[mtxq->wcid]);
+		if (!wcid || test_bit(MT_WCID_FLAG_PS, &wcid->flags))
 			continue;
 
 		spin_lock_bh(&q->lock);
@@ -511,7 +510,7 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 		}
 
 		if (!mt76_txq_stopped(q))
-			n_frames = mt76_txq_send_burst(phy, q, mtxq);
+			n_frames = mt76_txq_send_burst(phy, q, mtxq, wcid);
 
 		spin_unlock_bh(&q->lock);
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 29b56ea01132..0c9cdbaf5cd6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3660,7 +3660,7 @@ static int nvme_add_ns_cdev(struct nvme_ns *ns)
 }
 
 static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
-		unsigned nsid, struct nvme_ns_ids *ids)
+		unsigned nsid, struct nvme_ns_ids *ids, bool is_shared)
 {
 	struct nvme_ns_head *head;
 	size_t size = sizeof(*head);
@@ -3684,15 +3684,9 @@ static struct nvme_ns_head *nvme_alloc_ns_head(struct nvme_ctrl *ctrl,
 	head->subsys = ctrl->subsys;
 	head->ns_id = nsid;
 	head->ids = *ids;
+	head->shared = is_shared;
 	kref_init(&head->ref);
 
-	ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, &head->ids);
-	if (ret) {
-		dev_err(ctrl->device,
-			"duplicate IDs for nsid %d\n", nsid);
-		goto out_cleanup_srcu;
-	}
-
 	if (head->ids.csi) {
 		ret = nvme_get_effects_log(ctrl, head->ids.csi, &head->effects);
 		if (ret)
@@ -3731,12 +3725,17 @@ static int nvme_init_ns_head(struct nvme_ns *ns, unsigned nsid,
 	mutex_lock(&ctrl->subsys->lock);
 	head = nvme_find_ns_head(ctrl, nsid);
 	if (!head) {
-		head = nvme_alloc_ns_head(ctrl, nsid, ids);
+		ret = nvme_subsys_check_duplicate_ids(ctrl->subsys, ids);
+		if (ret) {
+			dev_err(ctrl->device,
+				"duplicate IDs for nsid %d\n", nsid);
+			goto out_unlock;
+		}
+		head = nvme_alloc_ns_head(ctrl, nsid, ids, is_shared);
 		if (IS_ERR(head)) {
 			ret = PTR_ERR(head);
 			goto out_unlock;
 		}
-		head->shared = is_shared;
 	} else {
 		ret = -EINVAL;
 		if (!is_shared || !head->shared) {
diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index 5b156c563e3a..9b54715a4b63 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1142,6 +1142,10 @@ static void hv_int_desc_free(struct hv_pci_dev *hpdev,
 		u8 buffer[sizeof(struct pci_delete_interrupt)];
 	} ctxt;
 
+	if (!int_desc->vector_count) {
+		kfree(int_desc);
+		return;
+	}
 	memset(&ctxt, 0, sizeof(ctxt));
 	int_pkt = (struct pci_delete_interrupt *)&ctxt.pkt.message;
 	int_pkt->message_type.type =
@@ -1204,6 +1208,28 @@ static void hv_irq_mask(struct irq_data *data)
 	pci_msi_mask_irq(data);
 }
 
+static unsigned int hv_msi_get_int_vector(struct irq_data *data)
+{
+	struct irq_cfg *cfg = irqd_cfg(data);
+
+	return cfg->vector;
+}
+
+static int hv_msi_prepare(struct irq_domain *domain, struct device *dev,
+			  int nvec, msi_alloc_info_t *info)
+{
+	int ret = pci_msi_prepare(domain, dev, nvec, info);
+
+	/*
+	 * By using the interrupt remapper in the hypervisor IOMMU, contiguous
+	 * CPU vectors is not needed for multi-MSI
+	 */
+	if (info->type == X86_IRQ_ALLOC_TYPE_PCI_MSI)
+		info->flags &= ~X86_IRQ_ALLOC_CONTIGUOUS_VECTORS;
+
+	return ret;
+}
+
 /**
  * hv_irq_unmask() - "Unmask" the IRQ by setting its current
  * affinity.
@@ -1219,6 +1245,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	struct msi_desc *msi_desc = irq_data_get_msi_desc(data);
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_retarget_device_interrupt *params;
+	struct tran_int_desc *int_desc;
 	struct hv_pcibus_device *hbus;
 	struct cpumask *dest;
 	cpumask_var_t tmp;
@@ -1233,6 +1260,7 @@ static void hv_irq_unmask(struct irq_data *data)
 	pdev = msi_desc_to_pci_dev(msi_desc);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
+	int_desc = data->chip_data;
 
 	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
 
@@ -1240,7 +1268,8 @@ static void hv_irq_unmask(struct irq_data *data)
 	memset(params, 0, sizeof(*params));
 	params->partition_id = HV_PARTITION_ID_SELF;
 	params->int_entry.source = HV_INTERRUPT_SOURCE_MSI;
-	hv_set_msi_entry_from_desc(&params->int_entry.msi_entry, msi_desc);
+	params->int_entry.msi_entry.address.as_uint32 = int_desc->address & 0xffffffff;
+	params->int_entry.msi_entry.data.as_uint32 = int_desc->data;
 	params->device_id = (hbus->hdev->dev_instance.b[5] << 24) |
 			   (hbus->hdev->dev_instance.b[4] << 16) |
 			   (hbus->hdev->dev_instance.b[7] << 8) |
@@ -1341,12 +1370,12 @@ static void hv_pci_compose_compl(void *context, struct pci_response *resp,
 
 static u32 hv_compose_msi_req_v1(
 	struct pci_create_interrupt *int_pkt, struct cpumask *affinity,
-	u32 slot, u8 vector)
+	u32 slot, u8 vector, u8 vector_count)
 {
 	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE;
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = APIC_DELIVERY_MODE_FIXED;
 
 	/*
@@ -1369,14 +1398,14 @@ static int hv_compose_msi_req_get_cpu(struct cpumask *affinity)
 
 static u32 hv_compose_msi_req_v2(
 	struct pci_create_interrupt2 *int_pkt, struct cpumask *affinity,
-	u32 slot, u8 vector)
+	u32 slot, u8 vector, u8 vector_count)
 {
 	int cpu;
 
 	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE2;
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = APIC_DELIVERY_MODE_FIXED;
 	cpu = hv_compose_msi_req_get_cpu(affinity);
 	int_pkt->int_desc.processor_array[0] =
@@ -1388,7 +1417,7 @@ static u32 hv_compose_msi_req_v2(
 
 static u32 hv_compose_msi_req_v3(
 	struct pci_create_interrupt3 *int_pkt, struct cpumask *affinity,
-	u32 slot, u32 vector)
+	u32 slot, u32 vector, u8 vector_count)
 {
 	int cpu;
 
@@ -1396,7 +1425,7 @@ static u32 hv_compose_msi_req_v3(
 	int_pkt->wslot.slot = slot;
 	int_pkt->int_desc.vector = vector;
 	int_pkt->int_desc.reserved = 0;
-	int_pkt->int_desc.vector_count = 1;
+	int_pkt->int_desc.vector_count = vector_count;
 	int_pkt->int_desc.delivery_mode = APIC_DELIVERY_MODE_FIXED;
 	cpu = hv_compose_msi_req_get_cpu(affinity);
 	int_pkt->int_desc.processor_array[0] =
@@ -1419,7 +1448,6 @@ static u32 hv_compose_msi_req_v3(
  */
 static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
 	struct hv_pcibus_device *hbus;
 	struct vmbus_channel *channel;
 	struct hv_pci_dev *hpdev;
@@ -1428,6 +1456,8 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	struct cpumask *dest;
 	struct compose_comp_ctxt comp;
 	struct tran_int_desc *int_desc;
+	struct msi_desc *msi_desc;
+	u8 vector, vector_count;
 	struct {
 		struct pci_packet pci_pkt;
 		union {
@@ -1440,7 +1470,17 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	u32 size;
 	int ret;
 
-	pdev = msi_desc_to_pci_dev(irq_data_get_msi_desc(data));
+	/* Reuse the previous allocation */
+	if (data->chip_data) {
+		int_desc = data->chip_data;
+		msg->address_hi = int_desc->address >> 32;
+		msg->address_lo = int_desc->address & 0xffffffff;
+		msg->data = int_desc->data;
+		return;
+	}
+
+	msi_desc  = irq_data_get_msi_desc(data);
+	pdev = msi_desc_to_pci_dev(msi_desc);
 	dest = irq_data_get_effective_affinity_mask(data);
 	pbus = pdev->bus;
 	hbus = container_of(pbus->sysdata, struct hv_pcibus_device, sysdata);
@@ -1449,17 +1489,40 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	if (!hpdev)
 		goto return_null_message;
 
-	/* Free any previous message that might have already been composed. */
-	if (data->chip_data) {
-		int_desc = data->chip_data;
-		data->chip_data = NULL;
-		hv_int_desc_free(hpdev, int_desc);
-	}
-
 	int_desc = kzalloc(sizeof(*int_desc), GFP_ATOMIC);
 	if (!int_desc)
 		goto drop_reference;
 
+	if (!msi_desc->msi_attrib.is_msix && msi_desc->nvec_used > 1) {
+		/*
+		 * If this is not the first MSI of Multi MSI, we already have
+		 * a mapping.  Can exit early.
+		 */
+		if (msi_desc->irq != data->irq) {
+			data->chip_data = int_desc;
+			int_desc->address = msi_desc->msg.address_lo |
+					    (u64)msi_desc->msg.address_hi << 32;
+			int_desc->data = msi_desc->msg.data +
+					 (data->irq - msi_desc->irq);
+			msg->address_hi = msi_desc->msg.address_hi;
+			msg->address_lo = msi_desc->msg.address_lo;
+			msg->data = int_desc->data;
+			put_pcichild(hpdev);
+			return;
+		}
+		/*
+		 * The vector we select here is a dummy value.  The correct
+		 * value gets sent to the hypervisor in unmask().  This needs
+		 * to be aligned with the count, and also not zero.  Multi-msi
+		 * is powers of 2 up to 32, so 32 will always work here.
+		 */
+		vector = 32;
+		vector_count = msi_desc->nvec_used;
+	} else {
+		vector = hv_msi_get_int_vector(data);
+		vector_count = 1;
+	}
+
 	memset(&ctxt, 0, sizeof(ctxt));
 	init_completion(&comp.comp_pkt.host_event);
 	ctxt.pci_pkt.completion_func = hv_pci_compose_compl;
@@ -1470,7 +1533,8 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	case PCI_PROTOCOL_VERSION_1_2:
@@ -1478,14 +1542,16 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	case PCI_PROTOCOL_VERSION_1_4:
 		size = hv_compose_msi_req_v3(&ctxt.int_pkts.v3,
 					dest,
 					hpdev->desc.win_slot.slot,
-					cfg->vector);
+					vector,
+					vector_count);
 		break;
 
 	default:
@@ -1601,7 +1667,7 @@ static struct irq_chip hv_msi_irq_chip = {
 };
 
 static struct msi_domain_ops hv_msi_ops = {
-	.msi_prepare	= pci_msi_prepare,
+	.msi_prepare	= hv_msi_prepare,
 	.msi_free	= hv_msi_free,
 };
 
diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 85a0052bb0e6..7338bc353347 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -341,12 +341,12 @@ static int armada_37xx_pmx_set_by_name(struct pinctrl_dev *pctldev,
 				       struct armada_37xx_pin_group *grp)
 {
 	struct armada_37xx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
+	struct device *dev = info->dev;
 	unsigned int reg = SELECTION;
 	unsigned int mask = grp->reg_mask;
 	int func, val;
 
-	dev_dbg(info->dev, "enable function %s group %s\n",
-		name, grp->name);
+	dev_dbg(dev, "enable function %s group %s\n", name, grp->name);
 
 	func = match_string(grp->funcs, NB_FUNCS, name);
 	if (func < 0)
@@ -722,25 +722,22 @@ static unsigned int armada_37xx_irq_startup(struct irq_data *d)
 static int armada_37xx_irqchip_register(struct platform_device *pdev,
 					struct armada_37xx_pinctrl *info)
 {
-	struct device_node *np = info->dev->of_node;
 	struct gpio_chip *gc = &info->gpio_chip;
 	struct irq_chip *irqchip = &info->irq_chip;
 	struct gpio_irq_chip *girq = &gc->irq;
 	struct device *dev = &pdev->dev;
-	struct resource res;
+	struct device_node *np;
 	int ret = -ENODEV, i, nr_irq_parent;
 
 	/* Check if we have at least one gpio-controller child node */
-	for_each_child_of_node(info->dev->of_node, np) {
+	for_each_child_of_node(dev->of_node, np) {
 		if (of_property_read_bool(np, "gpio-controller")) {
 			ret = 0;
 			break;
 		}
 	}
-	if (ret) {
-		dev_err(dev, "no gpio-controller child node\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "no gpio-controller child node\n");
 
 	nr_irq_parent = of_irq_count(np);
 	spin_lock_init(&info->irq_lock);
@@ -750,12 +747,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 		return 0;
 	}
 
-	if (of_address_to_resource(info->dev->of_node, 1, &res)) {
-		dev_err(dev, "cannot find IO resource\n");
-		return -ENOENT;
-	}
-
-	info->base = devm_ioremap_resource(info->dev, &res);
+	info->base = devm_platform_ioremap_resource(pdev, 1);
 	if (IS_ERR(info->base))
 		return PTR_ERR(info->base);
 
@@ -774,8 +766,7 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 	 * the chained irq with all of them.
 	 */
 	girq->num_parents = nr_irq_parent;
-	girq->parents = devm_kcalloc(&pdev->dev, nr_irq_parent,
-				     sizeof(*girq->parents), GFP_KERNEL);
+	girq->parents = devm_kcalloc(dev, nr_irq_parent, sizeof(*girq->parents), GFP_KERNEL);
 	if (!girq->parents)
 		return -ENOMEM;
 	for (i = 0; i < nr_irq_parent; i++) {
@@ -794,11 +785,12 @@ static int armada_37xx_irqchip_register(struct platform_device *pdev,
 static int armada_37xx_gpiochip_register(struct platform_device *pdev,
 					struct armada_37xx_pinctrl *info)
 {
+	struct device *dev = &pdev->dev;
 	struct device_node *np;
 	struct gpio_chip *gc;
 	int ret = -ENODEV;
 
-	for_each_child_of_node(info->dev->of_node, np) {
+	for_each_child_of_node(dev->of_node, np) {
 		if (of_find_property(np, "gpio-controller", NULL)) {
 			ret = 0;
 			break;
@@ -811,19 +803,16 @@ static int armada_37xx_gpiochip_register(struct platform_device *pdev,
 
 	gc = &info->gpio_chip;
 	gc->ngpio = info->data->nr_pins;
-	gc->parent = &pdev->dev;
+	gc->parent = dev;
 	gc->base = -1;
 	gc->of_node = np;
 	gc->label = info->data->name;
 
 	ret = armada_37xx_irqchip_register(pdev, info);
-	if (ret)
-		return ret;
-	ret = devm_gpiochip_add_data(&pdev->dev, gc, info);
 	if (ret)
 		return ret;
 
-	return 0;
+	return devm_gpiochip_add_data(dev, gc, info);
 }
 
 /**
@@ -874,13 +863,13 @@ static int armada_37xx_add_function(struct armada_37xx_pmx_func *funcs,
 static int armada_37xx_fill_group(struct armada_37xx_pinctrl *info)
 {
 	int n, num = 0, funcsize = info->data->nr_pins;
+	struct device *dev = info->dev;
 
 	for (n = 0; n < info->ngroups; n++) {
 		struct armada_37xx_pin_group *grp = &info->groups[n];
 		int i, j, f;
 
-		grp->pins = devm_kcalloc(info->dev,
-					 grp->npins + grp->extra_npins,
+		grp->pins = devm_kcalloc(dev, grp->npins + grp->extra_npins,
 					 sizeof(*grp->pins),
 					 GFP_KERNEL);
 		if (!grp->pins)
@@ -898,8 +887,7 @@ static int armada_37xx_fill_group(struct armada_37xx_pinctrl *info)
 			ret = armada_37xx_add_function(info->funcs, &funcsize,
 					    grp->funcs[f]);
 			if (ret == -EOVERFLOW)
-				dev_err(info->dev,
-					"More functions than pins(%d)\n",
+				dev_err(dev, "More functions than pins(%d)\n",
 					info->data->nr_pins);
 			if (ret < 0)
 				continue;
@@ -925,6 +913,7 @@ static int armada_37xx_fill_group(struct armada_37xx_pinctrl *info)
 static int armada_37xx_fill_func(struct armada_37xx_pinctrl *info)
 {
 	struct armada_37xx_pmx_func *funcs = info->funcs;
+	struct device *dev = info->dev;
 	int n;
 
 	for (n = 0; n < info->nfuncs; n++) {
@@ -932,8 +921,7 @@ static int armada_37xx_fill_func(struct armada_37xx_pinctrl *info)
 		const char **groups;
 		int g;
 
-		funcs[n].groups = devm_kcalloc(info->dev,
-					       funcs[n].ngroups,
+		funcs[n].groups = devm_kcalloc(dev, funcs[n].ngroups,
 					       sizeof(*(funcs[n].groups)),
 					       GFP_KERNEL);
 		if (!funcs[n].groups)
@@ -962,6 +950,7 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	const struct armada_37xx_pin_data *pin_data = info->data;
 	struct pinctrl_desc *ctrldesc = &info->pctl;
 	struct pinctrl_pin_desc *pindesc, *pdesc;
+	struct device *dev = &pdev->dev;
 	int pin, ret;
 
 	info->groups = pin_data->groups;
@@ -973,9 +962,7 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	ctrldesc->pmxops = &armada_37xx_pmx_ops;
 	ctrldesc->confops = &armada_37xx_pinconf_ops;
 
-	pindesc = devm_kcalloc(&pdev->dev,
-			       pin_data->nr_pins, sizeof(*pindesc),
-			       GFP_KERNEL);
+	pindesc = devm_kcalloc(dev, pin_data->nr_pins, sizeof(*pindesc), GFP_KERNEL);
 	if (!pindesc)
 		return -ENOMEM;
 
@@ -994,14 +981,10 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	 * we allocate functions for number of pins and hope there are
 	 * fewer unique functions than pins available
 	 */
-	info->funcs = devm_kcalloc(&pdev->dev,
-				   pin_data->nr_pins,
-				   sizeof(struct armada_37xx_pmx_func),
-				   GFP_KERNEL);
+	info->funcs = devm_kcalloc(dev, pin_data->nr_pins, sizeof(*info->funcs), GFP_KERNEL);
 	if (!info->funcs)
 		return -ENOMEM;
 
-
 	ret = armada_37xx_fill_group(info);
 	if (ret)
 		return ret;
@@ -1010,11 +993,9 @@ static int armada_37xx_pinctrl_register(struct platform_device *pdev,
 	if (ret)
 		return ret;
 
-	info->pctl_dev = devm_pinctrl_register(&pdev->dev, ctrldesc, info);
-	if (IS_ERR(info->pctl_dev)) {
-		dev_err(&pdev->dev, "could not register pinctrl driver\n");
-		return PTR_ERR(info->pctl_dev);
-	}
+	info->pctl_dev = devm_pinctrl_register(dev, ctrldesc, info);
+	if (IS_ERR(info->pctl_dev))
+		return dev_err_probe(dev, PTR_ERR(info->pctl_dev), "could not register pinctrl driver\n");
 
 	return 0;
 }
@@ -1135,28 +1116,40 @@ static const struct of_device_id armada_37xx_pinctrl_of_match[] = {
 	{ },
 };
 
+static const struct regmap_config armada_37xx_pinctrl_regmap_config = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+	.use_raw_spinlock = true,
+};
+
 static int __init armada_37xx_pinctrl_probe(struct platform_device *pdev)
 {
 	struct armada_37xx_pinctrl *info;
 	struct device *dev = &pdev->dev;
-	struct device_node *np = dev->of_node;
 	struct regmap *regmap;
+	void __iomem *base;
 	int ret;
 
-	info = devm_kzalloc(dev, sizeof(struct armada_37xx_pinctrl),
-			    GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
-
-	info->dev = dev;
+	base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
+	if (IS_ERR(base)) {
+		dev_err(dev, "failed to ioremap base address: %pe\n", base);
+		return PTR_ERR(base);
+	}
 
-	regmap = syscon_node_to_regmap(np);
+	regmap = devm_regmap_init_mmio(dev, base,
+				       &armada_37xx_pinctrl_regmap_config);
 	if (IS_ERR(regmap)) {
-		dev_err(&pdev->dev, "cannot get regmap\n");
+		dev_err(dev, "failed to create regmap: %pe\n", regmap);
 		return PTR_ERR(regmap);
 	}
-	info->regmap = regmap;
 
+	info = devm_kzalloc(dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->dev = dev;
+	info->regmap = regmap;
 	info->data = of_device_get_match_data(dev);
 
 	ret = armada_37xx_pinctrl_register(pdev, info);
diff --git a/drivers/pinctrl/ralink/Kconfig b/drivers/pinctrl/ralink/Kconfig
index a76ee3deb8c3..d0f0a8f2b9b7 100644
--- a/drivers/pinctrl/ralink/Kconfig
+++ b/drivers/pinctrl/ralink/Kconfig
@@ -3,37 +3,33 @@ menu "Ralink pinctrl drivers"
         depends on RALINK
 
 config PINCTRL_RALINK
-        bool "Ralink pin control support"
-        default y if RALINK
-
-config PINCTRL_RT2880
-        bool "RT2880 pinctrl driver for RALINK/Mediatek SOCs"
+        bool "Ralink pinctrl driver"
         select PINMUX
         select GENERIC_PINCONF
 
 config PINCTRL_MT7620
         bool "mt7620 pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_MT7620
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_MT7621
         bool "mt7621 pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_MT7621
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_RT288X
         bool "RT288X pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_RT288X
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_RT305X
         bool "RT305X pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_RT305X
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 config PINCTRL_RT3883
         bool "RT3883 pinctrl driver for RALINK/Mediatek SOCs"
         depends on RALINK && SOC_RT3883
-        select PINCTRL_RT2880
+        select PINCTRL_RALINK
 
 endmenu
diff --git a/drivers/pinctrl/ralink/Makefile b/drivers/pinctrl/ralink/Makefile
index a15610206ced..2c1323b74e96 100644
--- a/drivers/pinctrl/ralink/Makefile
+++ b/drivers/pinctrl/ralink/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_PINCTRL_RT2880)   += pinctrl-rt2880.o
+obj-$(CONFIG_PINCTRL_RALINK)   += pinctrl-ralink.o
 
 obj-$(CONFIG_PINCTRL_MT7620)   += pinctrl-mt7620.o
 obj-$(CONFIG_PINCTRL_MT7621)   += pinctrl-mt7621.o
diff --git a/drivers/pinctrl/ralink/pinctrl-mt7620.c b/drivers/pinctrl/ralink/pinctrl-mt7620.c
index 6853b5b8b0fe..51b863d85c51 100644
--- a/drivers/pinctrl/ralink/pinctrl-mt7620.c
+++ b/drivers/pinctrl/ralink/pinctrl-mt7620.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define MT7620_GPIO_MODE_UART0_SHIFT	2
 #define MT7620_GPIO_MODE_UART0_MASK	0x7
@@ -54,20 +54,20 @@
 #define MT7620_GPIO_MODE_EPHY		15
 #define MT7620_GPIO_MODE_PA		20
 
-static struct rt2880_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_grp[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartlite_grp[] = { FUNC("uartlite", 0, 15, 2) };
-static struct rt2880_pmx_func mdio_grp[] = {
+static struct ralink_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_grp[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartlite_grp[] = { FUNC("uartlite", 0, 15, 2) };
+static struct ralink_pmx_func mdio_grp[] = {
 	FUNC("mdio", MT7620_GPIO_MODE_MDIO, 22, 2),
 	FUNC("refclk", MT7620_GPIO_MODE_MDIO_REFCLK, 22, 2),
 };
-static struct rt2880_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 24, 12) };
-static struct rt2880_pmx_func refclk_grp[] = { FUNC("spi refclk", 0, 37, 3) };
-static struct rt2880_pmx_func ephy_grp[] = { FUNC("ephy", 0, 40, 5) };
-static struct rt2880_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 60, 12) };
-static struct rt2880_pmx_func wled_grp[] = { FUNC("wled", 0, 72, 1) };
-static struct rt2880_pmx_func pa_grp[] = { FUNC("pa", 0, 18, 4) };
-static struct rt2880_pmx_func uartf_grp[] = {
+static struct ralink_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 24, 12) };
+static struct ralink_pmx_func refclk_grp[] = { FUNC("spi refclk", 0, 37, 3) };
+static struct ralink_pmx_func ephy_grp[] = { FUNC("ephy", 0, 40, 5) };
+static struct ralink_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 60, 12) };
+static struct ralink_pmx_func wled_grp[] = { FUNC("wled", 0, 72, 1) };
+static struct ralink_pmx_func pa_grp[] = { FUNC("pa", 0, 18, 4) };
+static struct ralink_pmx_func uartf_grp[] = {
 	FUNC("uartf", MT7620_GPIO_MODE_UARTF, 7, 8),
 	FUNC("pcm uartf", MT7620_GPIO_MODE_PCM_UARTF, 7, 8),
 	FUNC("pcm i2s", MT7620_GPIO_MODE_PCM_I2S, 7, 8),
@@ -76,20 +76,20 @@ static struct rt2880_pmx_func uartf_grp[] = {
 	FUNC("gpio uartf", MT7620_GPIO_MODE_GPIO_UARTF, 7, 4),
 	FUNC("gpio i2s", MT7620_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-static struct rt2880_pmx_func wdt_grp[] = {
+static struct ralink_pmx_func wdt_grp[] = {
 	FUNC("wdt rst", 0, 17, 1),
 	FUNC("wdt refclk", 0, 17, 1),
 	};
-static struct rt2880_pmx_func pcie_rst_grp[] = {
+static struct ralink_pmx_func pcie_rst_grp[] = {
 	FUNC("pcie rst", MT7620_GPIO_MODE_PCIE_RST, 36, 1),
 	FUNC("pcie refclk", MT7620_GPIO_MODE_PCIE_REF, 36, 1)
 };
-static struct rt2880_pmx_func nd_sd_grp[] = {
+static struct ralink_pmx_func nd_sd_grp[] = {
 	FUNC("nand", MT7620_GPIO_MODE_NAND, 45, 15),
 	FUNC("sd", MT7620_GPIO_MODE_SD, 47, 13)
 };
 
-static struct rt2880_pmx_group mt7620a_pinmux_data[] = {
+static struct ralink_pmx_group mt7620a_pinmux_data[] = {
 	GRP("i2c", i2c_grp, 1, MT7620_GPIO_MODE_I2C),
 	GRP("uartf", uartf_grp, MT7620_GPIO_MODE_UART0_MASK,
 		MT7620_GPIO_MODE_UART0_SHIFT),
@@ -112,262 +112,262 @@ static struct rt2880_pmx_group mt7620a_pinmux_data[] = {
 	{ 0 }
 };
 
-static struct rt2880_pmx_func pwm1_grp_mt7628[] = {
+static struct ralink_pmx_func pwm1_grp_mt76x8[] = {
 	FUNC("sdxc d6", 3, 19, 1),
 	FUNC("utif", 2, 19, 1),
 	FUNC("gpio", 1, 19, 1),
 	FUNC("pwm1", 0, 19, 1),
 };
 
-static struct rt2880_pmx_func pwm0_grp_mt7628[] = {
+static struct ralink_pmx_func pwm0_grp_mt76x8[] = {
 	FUNC("sdxc d7", 3, 18, 1),
 	FUNC("utif", 2, 18, 1),
 	FUNC("gpio", 1, 18, 1),
 	FUNC("pwm0", 0, 18, 1),
 };
 
-static struct rt2880_pmx_func uart2_grp_mt7628[] = {
+static struct ralink_pmx_func uart2_grp_mt76x8[] = {
 	FUNC("sdxc d5 d4", 3, 20, 2),
 	FUNC("pwm", 2, 20, 2),
 	FUNC("gpio", 1, 20, 2),
 	FUNC("uart2", 0, 20, 2),
 };
 
-static struct rt2880_pmx_func uart1_grp_mt7628[] = {
+static struct ralink_pmx_func uart1_grp_mt76x8[] = {
 	FUNC("sw_r", 3, 45, 2),
 	FUNC("pwm", 2, 45, 2),
 	FUNC("gpio", 1, 45, 2),
 	FUNC("uart1", 0, 45, 2),
 };
 
-static struct rt2880_pmx_func i2c_grp_mt7628[] = {
+static struct ralink_pmx_func i2c_grp_mt76x8[] = {
 	FUNC("-", 3, 4, 2),
 	FUNC("debug", 2, 4, 2),
 	FUNC("gpio", 1, 4, 2),
 	FUNC("i2c", 0, 4, 2),
 };
 
-static struct rt2880_pmx_func refclk_grp_mt7628[] = { FUNC("refclk", 0, 37, 1) };
-static struct rt2880_pmx_func perst_grp_mt7628[] = { FUNC("perst", 0, 36, 1) };
-static struct rt2880_pmx_func wdt_grp_mt7628[] = { FUNC("wdt", 0, 38, 1) };
-static struct rt2880_pmx_func spi_grp_mt7628[] = { FUNC("spi", 0, 7, 4) };
+static struct ralink_pmx_func refclk_grp_mt76x8[] = { FUNC("refclk", 0, 37, 1) };
+static struct ralink_pmx_func perst_grp_mt76x8[] = { FUNC("perst", 0, 36, 1) };
+static struct ralink_pmx_func wdt_grp_mt76x8[] = { FUNC("wdt", 0, 38, 1) };
+static struct ralink_pmx_func spi_grp_mt76x8[] = { FUNC("spi", 0, 7, 4) };
 
-static struct rt2880_pmx_func sd_mode_grp_mt7628[] = {
+static struct ralink_pmx_func sd_mode_grp_mt76x8[] = {
 	FUNC("jtag", 3, 22, 8),
 	FUNC("utif", 2, 22, 8),
 	FUNC("gpio", 1, 22, 8),
 	FUNC("sdxc", 0, 22, 8),
 };
 
-static struct rt2880_pmx_func uart0_grp_mt7628[] = {
+static struct ralink_pmx_func uart0_grp_mt76x8[] = {
 	FUNC("-", 3, 12, 2),
 	FUNC("-", 2, 12, 2),
 	FUNC("gpio", 1, 12, 2),
 	FUNC("uart0", 0, 12, 2),
 };
 
-static struct rt2880_pmx_func i2s_grp_mt7628[] = {
+static struct ralink_pmx_func i2s_grp_mt76x8[] = {
 	FUNC("antenna", 3, 0, 4),
 	FUNC("pcm", 2, 0, 4),
 	FUNC("gpio", 1, 0, 4),
 	FUNC("i2s", 0, 0, 4),
 };
 
-static struct rt2880_pmx_func spi_cs1_grp_mt7628[] = {
+static struct ralink_pmx_func spi_cs1_grp_mt76x8[] = {
 	FUNC("-", 3, 6, 1),
 	FUNC("refclk", 2, 6, 1),
 	FUNC("gpio", 1, 6, 1),
 	FUNC("spi cs1", 0, 6, 1),
 };
 
-static struct rt2880_pmx_func spis_grp_mt7628[] = {
+static struct ralink_pmx_func spis_grp_mt76x8[] = {
 	FUNC("pwm_uart2", 3, 14, 4),
 	FUNC("utif", 2, 14, 4),
 	FUNC("gpio", 1, 14, 4),
 	FUNC("spis", 0, 14, 4),
 };
 
-static struct rt2880_pmx_func gpio_grp_mt7628[] = {
+static struct ralink_pmx_func gpio_grp_mt76x8[] = {
 	FUNC("pcie", 3, 11, 1),
 	FUNC("refclk", 2, 11, 1),
 	FUNC("gpio", 1, 11, 1),
 	FUNC("gpio", 0, 11, 1),
 };
 
-static struct rt2880_pmx_func p4led_kn_grp_mt7628[] = {
+static struct ralink_pmx_func p4led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 30, 1),
 	FUNC("utif", 2, 30, 1),
 	FUNC("gpio", 1, 30, 1),
 	FUNC("p4led_kn", 0, 30, 1),
 };
 
-static struct rt2880_pmx_func p3led_kn_grp_mt7628[] = {
+static struct ralink_pmx_func p3led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 31, 1),
 	FUNC("utif", 2, 31, 1),
 	FUNC("gpio", 1, 31, 1),
 	FUNC("p3led_kn", 0, 31, 1),
 };
 
-static struct rt2880_pmx_func p2led_kn_grp_mt7628[] = {
+static struct ralink_pmx_func p2led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 32, 1),
 	FUNC("utif", 2, 32, 1),
 	FUNC("gpio", 1, 32, 1),
 	FUNC("p2led_kn", 0, 32, 1),
 };
 
-static struct rt2880_pmx_func p1led_kn_grp_mt7628[] = {
+static struct ralink_pmx_func p1led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 33, 1),
 	FUNC("utif", 2, 33, 1),
 	FUNC("gpio", 1, 33, 1),
 	FUNC("p1led_kn", 0, 33, 1),
 };
 
-static struct rt2880_pmx_func p0led_kn_grp_mt7628[] = {
+static struct ralink_pmx_func p0led_kn_grp_mt76x8[] = {
 	FUNC("jtag", 3, 34, 1),
 	FUNC("rsvd", 2, 34, 1),
 	FUNC("gpio", 1, 34, 1),
 	FUNC("p0led_kn", 0, 34, 1),
 };
 
-static struct rt2880_pmx_func wled_kn_grp_mt7628[] = {
+static struct ralink_pmx_func wled_kn_grp_mt76x8[] = {
 	FUNC("rsvd", 3, 35, 1),
 	FUNC("rsvd", 2, 35, 1),
 	FUNC("gpio", 1, 35, 1),
 	FUNC("wled_kn", 0, 35, 1),
 };
 
-static struct rt2880_pmx_func p4led_an_grp_mt7628[] = {
+static struct ralink_pmx_func p4led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 39, 1),
 	FUNC("utif", 2, 39, 1),
 	FUNC("gpio", 1, 39, 1),
 	FUNC("p4led_an", 0, 39, 1),
 };
 
-static struct rt2880_pmx_func p3led_an_grp_mt7628[] = {
+static struct ralink_pmx_func p3led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 40, 1),
 	FUNC("utif", 2, 40, 1),
 	FUNC("gpio", 1, 40, 1),
 	FUNC("p3led_an", 0, 40, 1),
 };
 
-static struct rt2880_pmx_func p2led_an_grp_mt7628[] = {
+static struct ralink_pmx_func p2led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 41, 1),
 	FUNC("utif", 2, 41, 1),
 	FUNC("gpio", 1, 41, 1),
 	FUNC("p2led_an", 0, 41, 1),
 };
 
-static struct rt2880_pmx_func p1led_an_grp_mt7628[] = {
+static struct ralink_pmx_func p1led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 42, 1),
 	FUNC("utif", 2, 42, 1),
 	FUNC("gpio", 1, 42, 1),
 	FUNC("p1led_an", 0, 42, 1),
 };
 
-static struct rt2880_pmx_func p0led_an_grp_mt7628[] = {
+static struct ralink_pmx_func p0led_an_grp_mt76x8[] = {
 	FUNC("jtag", 3, 43, 1),
 	FUNC("rsvd", 2, 43, 1),
 	FUNC("gpio", 1, 43, 1),
 	FUNC("p0led_an", 0, 43, 1),
 };
 
-static struct rt2880_pmx_func wled_an_grp_mt7628[] = {
+static struct ralink_pmx_func wled_an_grp_mt76x8[] = {
 	FUNC("rsvd", 3, 44, 1),
 	FUNC("rsvd", 2, 44, 1),
 	FUNC("gpio", 1, 44, 1),
 	FUNC("wled_an", 0, 44, 1),
 };
 
-#define MT7628_GPIO_MODE_MASK		0x3
-
-#define MT7628_GPIO_MODE_P4LED_KN	58
-#define MT7628_GPIO_MODE_P3LED_KN	56
-#define MT7628_GPIO_MODE_P2LED_KN	54
-#define MT7628_GPIO_MODE_P1LED_KN	52
-#define MT7628_GPIO_MODE_P0LED_KN	50
-#define MT7628_GPIO_MODE_WLED_KN	48
-#define MT7628_GPIO_MODE_P4LED_AN	42
-#define MT7628_GPIO_MODE_P3LED_AN	40
-#define MT7628_GPIO_MODE_P2LED_AN	38
-#define MT7628_GPIO_MODE_P1LED_AN	36
-#define MT7628_GPIO_MODE_P0LED_AN	34
-#define MT7628_GPIO_MODE_WLED_AN	32
-#define MT7628_GPIO_MODE_PWM1		30
-#define MT7628_GPIO_MODE_PWM0		28
-#define MT7628_GPIO_MODE_UART2		26
-#define MT7628_GPIO_MODE_UART1		24
-#define MT7628_GPIO_MODE_I2C		20
-#define MT7628_GPIO_MODE_REFCLK		18
-#define MT7628_GPIO_MODE_PERST		16
-#define MT7628_GPIO_MODE_WDT		14
-#define MT7628_GPIO_MODE_SPI		12
-#define MT7628_GPIO_MODE_SDMODE		10
-#define MT7628_GPIO_MODE_UART0		8
-#define MT7628_GPIO_MODE_I2S		6
-#define MT7628_GPIO_MODE_CS1		4
-#define MT7628_GPIO_MODE_SPIS		2
-#define MT7628_GPIO_MODE_GPIO		0
-
-static struct rt2880_pmx_group mt7628an_pinmux_data[] = {
-	GRP_G("pwm1", pwm1_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_PWM1),
-	GRP_G("pwm0", pwm0_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_PWM0),
-	GRP_G("uart2", uart2_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_UART2),
-	GRP_G("uart1", uart1_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_UART1),
-	GRP_G("i2c", i2c_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_I2C),
-	GRP("refclk", refclk_grp_mt7628, 1, MT7628_GPIO_MODE_REFCLK),
-	GRP("perst", perst_grp_mt7628, 1, MT7628_GPIO_MODE_PERST),
-	GRP("wdt", wdt_grp_mt7628, 1, MT7628_GPIO_MODE_WDT),
-	GRP("spi", spi_grp_mt7628, 1, MT7628_GPIO_MODE_SPI),
-	GRP_G("sdmode", sd_mode_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_SDMODE),
-	GRP_G("uart0", uart0_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_UART0),
-	GRP_G("i2s", i2s_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_I2S),
-	GRP_G("spi cs1", spi_cs1_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_CS1),
-	GRP_G("spis", spis_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_SPIS),
-	GRP_G("gpio", gpio_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_GPIO),
-	GRP_G("wled_an", wled_an_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_WLED_AN),
-	GRP_G("p0led_an", p0led_an_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P0LED_AN),
-	GRP_G("p1led_an", p1led_an_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P1LED_AN),
-	GRP_G("p2led_an", p2led_an_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P2LED_AN),
-	GRP_G("p3led_an", p3led_an_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P3LED_AN),
-	GRP_G("p4led_an", p4led_an_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P4LED_AN),
-	GRP_G("wled_kn", wled_kn_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_WLED_KN),
-	GRP_G("p0led_kn", p0led_kn_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P0LED_KN),
-	GRP_G("p1led_kn", p1led_kn_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P1LED_KN),
-	GRP_G("p2led_kn", p2led_kn_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P2LED_KN),
-	GRP_G("p3led_kn", p3led_kn_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P3LED_KN),
-	GRP_G("p4led_kn", p4led_kn_grp_mt7628, MT7628_GPIO_MODE_MASK,
-				1, MT7628_GPIO_MODE_P4LED_KN),
+#define MT76X8_GPIO_MODE_MASK		0x3
+
+#define MT76X8_GPIO_MODE_P4LED_KN	58
+#define MT76X8_GPIO_MODE_P3LED_KN	56
+#define MT76X8_GPIO_MODE_P2LED_KN	54
+#define MT76X8_GPIO_MODE_P1LED_KN	52
+#define MT76X8_GPIO_MODE_P0LED_KN	50
+#define MT76X8_GPIO_MODE_WLED_KN	48
+#define MT76X8_GPIO_MODE_P4LED_AN	42
+#define MT76X8_GPIO_MODE_P3LED_AN	40
+#define MT76X8_GPIO_MODE_P2LED_AN	38
+#define MT76X8_GPIO_MODE_P1LED_AN	36
+#define MT76X8_GPIO_MODE_P0LED_AN	34
+#define MT76X8_GPIO_MODE_WLED_AN	32
+#define MT76X8_GPIO_MODE_PWM1		30
+#define MT76X8_GPIO_MODE_PWM0		28
+#define MT76X8_GPIO_MODE_UART2		26
+#define MT76X8_GPIO_MODE_UART1		24
+#define MT76X8_GPIO_MODE_I2C		20
+#define MT76X8_GPIO_MODE_REFCLK		18
+#define MT76X8_GPIO_MODE_PERST		16
+#define MT76X8_GPIO_MODE_WDT		14
+#define MT76X8_GPIO_MODE_SPI		12
+#define MT76X8_GPIO_MODE_SDMODE		10
+#define MT76X8_GPIO_MODE_UART0		8
+#define MT76X8_GPIO_MODE_I2S		6
+#define MT76X8_GPIO_MODE_CS1		4
+#define MT76X8_GPIO_MODE_SPIS		2
+#define MT76X8_GPIO_MODE_GPIO		0
+
+static struct ralink_pmx_group mt76x8_pinmux_data[] = {
+	GRP_G("pwm1", pwm1_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_PWM1),
+	GRP_G("pwm0", pwm0_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_PWM0),
+	GRP_G("uart2", uart2_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_UART2),
+	GRP_G("uart1", uart1_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_UART1),
+	GRP_G("i2c", i2c_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_I2C),
+	GRP("refclk", refclk_grp_mt76x8, 1, MT76X8_GPIO_MODE_REFCLK),
+	GRP("perst", perst_grp_mt76x8, 1, MT76X8_GPIO_MODE_PERST),
+	GRP("wdt", wdt_grp_mt76x8, 1, MT76X8_GPIO_MODE_WDT),
+	GRP("spi", spi_grp_mt76x8, 1, MT76X8_GPIO_MODE_SPI),
+	GRP_G("sdmode", sd_mode_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_SDMODE),
+	GRP_G("uart0", uart0_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_UART0),
+	GRP_G("i2s", i2s_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_I2S),
+	GRP_G("spi cs1", spi_cs1_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_CS1),
+	GRP_G("spis", spis_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_SPIS),
+	GRP_G("gpio", gpio_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_GPIO),
+	GRP_G("wled_an", wled_an_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_WLED_AN),
+	GRP_G("p0led_an", p0led_an_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P0LED_AN),
+	GRP_G("p1led_an", p1led_an_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P1LED_AN),
+	GRP_G("p2led_an", p2led_an_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P2LED_AN),
+	GRP_G("p3led_an", p3led_an_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P3LED_AN),
+	GRP_G("p4led_an", p4led_an_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P4LED_AN),
+	GRP_G("wled_kn", wled_kn_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_WLED_KN),
+	GRP_G("p0led_kn", p0led_kn_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P0LED_KN),
+	GRP_G("p1led_kn", p1led_kn_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P1LED_KN),
+	GRP_G("p2led_kn", p2led_kn_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P2LED_KN),
+	GRP_G("p3led_kn", p3led_kn_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P3LED_KN),
+	GRP_G("p4led_kn", p4led_kn_grp_mt76x8, MT76X8_GPIO_MODE_MASK,
+				1, MT76X8_GPIO_MODE_P4LED_KN),
 	{ 0 }
 };
 
 static int mt7620_pinmux_probe(struct platform_device *pdev)
 {
 	if (is_mt76x8())
-		return rt2880_pinmux_init(pdev, mt7628an_pinmux_data);
+		return ralink_pinmux_init(pdev, mt76x8_pinmux_data);
 	else
-		return rt2880_pinmux_init(pdev, mt7620a_pinmux_data);
+		return ralink_pinmux_init(pdev, mt7620a_pinmux_data);
 }
 
 static const struct of_device_id mt7620_pinmux_match[] = {
diff --git a/drivers/pinctrl/ralink/pinctrl-mt7621.c b/drivers/pinctrl/ralink/pinctrl-mt7621.c
index 7d96144c474e..14b89cb43d4c 100644
--- a/drivers/pinctrl/ralink/pinctrl-mt7621.c
+++ b/drivers/pinctrl/ralink/pinctrl-mt7621.c
@@ -3,7 +3,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define MT7621_GPIO_MODE_UART1		1
 #define MT7621_GPIO_MODE_I2C		2
@@ -34,40 +34,40 @@
 #define MT7621_GPIO_MODE_SDHCI_SHIFT	18
 #define MT7621_GPIO_MODE_SDHCI_GPIO	1
 
-static struct rt2880_pmx_func uart1_grp[] =  { FUNC("uart1", 0, 1, 2) };
-static struct rt2880_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 3, 2) };
-static struct rt2880_pmx_func uart3_grp[] = {
+static struct ralink_pmx_func uart1_grp[] =  { FUNC("uart1", 0, 1, 2) };
+static struct ralink_pmx_func i2c_grp[] =  { FUNC("i2c", 0, 3, 2) };
+static struct ralink_pmx_func uart3_grp[] = {
 	FUNC("uart3", 0, 5, 4),
 	FUNC("i2s", 2, 5, 4),
 	FUNC("spdif3", 3, 5, 4),
 };
-static struct rt2880_pmx_func uart2_grp[] = {
+static struct ralink_pmx_func uart2_grp[] = {
 	FUNC("uart2", 0, 9, 4),
 	FUNC("pcm", 2, 9, 4),
 	FUNC("spdif2", 3, 9, 4),
 };
-static struct rt2880_pmx_func jtag_grp[] = { FUNC("jtag", 0, 13, 5) };
-static struct rt2880_pmx_func wdt_grp[] = {
+static struct ralink_pmx_func jtag_grp[] = { FUNC("jtag", 0, 13, 5) };
+static struct ralink_pmx_func wdt_grp[] = {
 	FUNC("wdt rst", 0, 18, 1),
 	FUNC("wdt refclk", 2, 18, 1),
 };
-static struct rt2880_pmx_func pcie_rst_grp[] = {
+static struct ralink_pmx_func pcie_rst_grp[] = {
 	FUNC("pcie rst", MT7621_GPIO_MODE_PCIE_RST, 19, 1),
 	FUNC("pcie refclk", MT7621_GPIO_MODE_PCIE_REF, 19, 1)
 };
-static struct rt2880_pmx_func mdio_grp[] = { FUNC("mdio", 0, 20, 2) };
-static struct rt2880_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 22, 12) };
-static struct rt2880_pmx_func spi_grp[] = {
+static struct ralink_pmx_func mdio_grp[] = { FUNC("mdio", 0, 20, 2) };
+static struct ralink_pmx_func rgmii2_grp[] = { FUNC("rgmii2", 0, 22, 12) };
+static struct ralink_pmx_func spi_grp[] = {
 	FUNC("spi", 0, 34, 7),
 	FUNC("nand1", 2, 34, 7),
 };
-static struct rt2880_pmx_func sdhci_grp[] = {
+static struct ralink_pmx_func sdhci_grp[] = {
 	FUNC("sdhci", 0, 41, 8),
 	FUNC("nand2", 2, 41, 8),
 };
-static struct rt2880_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 49, 12) };
+static struct ralink_pmx_func rgmii1_grp[] = { FUNC("rgmii1", 0, 49, 12) };
 
-static struct rt2880_pmx_group mt7621_pinmux_data[] = {
+static struct ralink_pmx_group mt7621_pinmux_data[] = {
 	GRP("uart1", uart1_grp, 1, MT7621_GPIO_MODE_UART1),
 	GRP("i2c", i2c_grp, 1, MT7621_GPIO_MODE_I2C),
 	GRP_G("uart3", uart3_grp, MT7621_GPIO_MODE_UART3_MASK,
@@ -92,7 +92,7 @@ static struct rt2880_pmx_group mt7621_pinmux_data[] = {
 
 static int mt7621_pinmux_probe(struct platform_device *pdev)
 {
-	return rt2880_pinmux_init(pdev, mt7621_pinmux_data);
+	return ralink_pinmux_init(pdev, mt7621_pinmux_data);
 }
 
 static const struct of_device_id mt7621_pinmux_match[] = {
diff --git a/drivers/pinctrl/ralink/pinctrl-ralink.c b/drivers/pinctrl/ralink/pinctrl-ralink.c
new file mode 100644
index 000000000000..3a8268a43d74
--- /dev/null
+++ b/drivers/pinctrl/ralink/pinctrl-ralink.c
@@ -0,0 +1,351 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Copyright (C) 2013 John Crispin <blogic@openwrt.org>
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/pinctrl/pinctrl.h>
+#include <linux/pinctrl/pinconf.h>
+#include <linux/pinctrl/pinconf-generic.h>
+#include <linux/pinctrl/pinmux.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pinctrl/machine.h>
+
+#include <asm/mach-ralink/ralink_regs.h>
+#include <asm/mach-ralink/mt7620.h>
+
+#include "pinctrl-ralink.h"
+#include "../core.h"
+#include "../pinctrl-utils.h"
+
+#define SYSC_REG_GPIO_MODE	0x60
+#define SYSC_REG_GPIO_MODE2	0x64
+
+struct ralink_priv {
+	struct device *dev;
+
+	struct pinctrl_pin_desc *pads;
+	struct pinctrl_desc *desc;
+
+	struct ralink_pmx_func **func;
+	int func_count;
+
+	struct ralink_pmx_group *groups;
+	const char **group_names;
+	int group_count;
+
+	u8 *gpio;
+	int max_pins;
+};
+
+static int ralink_get_group_count(struct pinctrl_dev *pctrldev)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+
+	return p->group_count;
+}
+
+static const char *ralink_get_group_name(struct pinctrl_dev *pctrldev,
+					 unsigned int group)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+
+	return (group >= p->group_count) ? NULL : p->group_names[group];
+}
+
+static int ralink_get_group_pins(struct pinctrl_dev *pctrldev,
+				 unsigned int group,
+				 const unsigned int **pins,
+				 unsigned int *num_pins)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+
+	if (group >= p->group_count)
+		return -EINVAL;
+
+	*pins = p->groups[group].func[0].pins;
+	*num_pins = p->groups[group].func[0].pin_count;
+
+	return 0;
+}
+
+static const struct pinctrl_ops ralink_pctrl_ops = {
+	.get_groups_count	= ralink_get_group_count,
+	.get_group_name		= ralink_get_group_name,
+	.get_group_pins		= ralink_get_group_pins,
+	.dt_node_to_map		= pinconf_generic_dt_node_to_map_all,
+	.dt_free_map		= pinconf_generic_dt_free_map,
+};
+
+static int ralink_pmx_func_count(struct pinctrl_dev *pctrldev)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+
+	return p->func_count;
+}
+
+static const char *ralink_pmx_func_name(struct pinctrl_dev *pctrldev,
+					unsigned int func)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+
+	return p->func[func]->name;
+}
+
+static int ralink_pmx_group_get_groups(struct pinctrl_dev *pctrldev,
+				       unsigned int func,
+				       const char * const **groups,
+				       unsigned int * const num_groups)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+
+	if (p->func[func]->group_count == 1)
+		*groups = &p->group_names[p->func[func]->groups[0]];
+	else
+		*groups = p->group_names;
+
+	*num_groups = p->func[func]->group_count;
+
+	return 0;
+}
+
+static int ralink_pmx_group_enable(struct pinctrl_dev *pctrldev,
+				   unsigned int func, unsigned int group)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+	u32 mode = 0;
+	u32 reg = SYSC_REG_GPIO_MODE;
+	int i;
+	int shift;
+
+	/* dont allow double use */
+	if (p->groups[group].enabled) {
+		dev_err(p->dev, "%s is already enabled\n",
+			p->groups[group].name);
+		return 0;
+	}
+
+	p->groups[group].enabled = 1;
+	p->func[func]->enabled = 1;
+
+	shift = p->groups[group].shift;
+	if (shift >= 32) {
+		shift -= 32;
+		reg = SYSC_REG_GPIO_MODE2;
+	}
+	mode = rt_sysc_r32(reg);
+	mode &= ~(p->groups[group].mask << shift);
+
+	/* mark the pins as gpio */
+	for (i = 0; i < p->groups[group].func[0].pin_count; i++)
+		p->gpio[p->groups[group].func[0].pins[i]] = 1;
+
+	/* function 0 is gpio and needs special handling */
+	if (func == 0) {
+		mode |= p->groups[group].gpio << shift;
+	} else {
+		for (i = 0; i < p->func[func]->pin_count; i++)
+			p->gpio[p->func[func]->pins[i]] = 0;
+		mode |= p->func[func]->value << shift;
+	}
+	rt_sysc_w32(mode, reg);
+
+	return 0;
+}
+
+static int ralink_pmx_group_gpio_request_enable(struct pinctrl_dev *pctrldev,
+						struct pinctrl_gpio_range *range,
+						unsigned int pin)
+{
+	struct ralink_priv *p = pinctrl_dev_get_drvdata(pctrldev);
+
+	if (!p->gpio[pin]) {
+		dev_err(p->dev, "pin %d is not set to gpio mux\n", pin);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct pinmux_ops ralink_pmx_group_ops = {
+	.get_functions_count	= ralink_pmx_func_count,
+	.get_function_name	= ralink_pmx_func_name,
+	.get_function_groups	= ralink_pmx_group_get_groups,
+	.set_mux		= ralink_pmx_group_enable,
+	.gpio_request_enable	= ralink_pmx_group_gpio_request_enable,
+};
+
+static struct pinctrl_desc ralink_pctrl_desc = {
+	.owner		= THIS_MODULE,
+	.name		= "ralink-pinmux",
+	.pctlops	= &ralink_pctrl_ops,
+	.pmxops		= &ralink_pmx_group_ops,
+};
+
+static struct ralink_pmx_func gpio_func = {
+	.name = "gpio",
+};
+
+static int ralink_pinmux_index(struct ralink_priv *p)
+{
+	struct ralink_pmx_group *mux = p->groups;
+	int i, j, c = 0;
+
+	/* count the mux functions */
+	while (mux->name) {
+		p->group_count++;
+		mux++;
+	}
+
+	/* allocate the group names array needed by the gpio function */
+	p->group_names = devm_kcalloc(p->dev, p->group_count,
+				      sizeof(char *), GFP_KERNEL);
+	if (!p->group_names)
+		return -ENOMEM;
+
+	for (i = 0; i < p->group_count; i++) {
+		p->group_names[i] = p->groups[i].name;
+		p->func_count += p->groups[i].func_count;
+	}
+
+	/* we have a dummy function[0] for gpio */
+	p->func_count++;
+
+	/* allocate our function and group mapping index buffers */
+	p->func = devm_kcalloc(p->dev, p->func_count,
+			       sizeof(*p->func), GFP_KERNEL);
+	gpio_func.groups = devm_kcalloc(p->dev, p->group_count, sizeof(int),
+					GFP_KERNEL);
+	if (!p->func || !gpio_func.groups)
+		return -ENOMEM;
+
+	/* add a backpointer to the function so it knows its group */
+	gpio_func.group_count = p->group_count;
+	for (i = 0; i < gpio_func.group_count; i++)
+		gpio_func.groups[i] = i;
+
+	p->func[c] = &gpio_func;
+	c++;
+
+	/* add remaining functions */
+	for (i = 0; i < p->group_count; i++) {
+		for (j = 0; j < p->groups[i].func_count; j++) {
+			p->func[c] = &p->groups[i].func[j];
+			p->func[c]->groups = devm_kzalloc(p->dev, sizeof(int),
+						    GFP_KERNEL);
+			if (!p->func[c]->groups)
+				return -ENOMEM;
+			p->func[c]->groups[0] = i;
+			p->func[c]->group_count = 1;
+			c++;
+		}
+	}
+	return 0;
+}
+
+static int ralink_pinmux_pins(struct ralink_priv *p)
+{
+	int i, j;
+
+	/*
+	 * loop over the functions and initialize the pins array.
+	 * also work out the highest pin used.
+	 */
+	for (i = 0; i < p->func_count; i++) {
+		int pin;
+
+		if (!p->func[i]->pin_count)
+			continue;
+
+		p->func[i]->pins = devm_kcalloc(p->dev,
+						p->func[i]->pin_count,
+						sizeof(int),
+						GFP_KERNEL);
+		if (!p->func[i]->pins)
+			return -ENOMEM;
+		for (j = 0; j < p->func[i]->pin_count; j++)
+			p->func[i]->pins[j] = p->func[i]->pin_first + j;
+
+		pin = p->func[i]->pin_first + p->func[i]->pin_count;
+		if (pin > p->max_pins)
+			p->max_pins = pin;
+	}
+
+	/* the buffer that tells us which pins are gpio */
+	p->gpio = devm_kcalloc(p->dev, p->max_pins, sizeof(u8), GFP_KERNEL);
+	/* the pads needed to tell pinctrl about our pins */
+	p->pads = devm_kcalloc(p->dev, p->max_pins,
+			       sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
+	if (!p->pads || !p->gpio)
+		return -ENOMEM;
+
+	memset(p->gpio, 1, sizeof(u8) * p->max_pins);
+	for (i = 0; i < p->func_count; i++) {
+		if (!p->func[i]->pin_count)
+			continue;
+
+		for (j = 0; j < p->func[i]->pin_count; j++)
+			p->gpio[p->func[i]->pins[j]] = 0;
+	}
+
+	/* pin 0 is always a gpio */
+	p->gpio[0] = 1;
+
+	/* set the pads */
+	for (i = 0; i < p->max_pins; i++) {
+		/* strlen("ioXY") + 1 = 5 */
+		char *name = devm_kzalloc(p->dev, 5, GFP_KERNEL);
+
+		if (!name)
+			return -ENOMEM;
+		snprintf(name, 5, "io%d", i);
+		p->pads[i].number = i;
+		p->pads[i].name = name;
+	}
+	p->desc->pins = p->pads;
+	p->desc->npins = p->max_pins;
+
+	return 0;
+}
+
+int ralink_pinmux_init(struct platform_device *pdev,
+		       struct ralink_pmx_group *data)
+{
+	struct ralink_priv *p;
+	struct pinctrl_dev *dev;
+	int err;
+
+	if (!data)
+		return -ENOTSUPP;
+
+	/* setup the private data */
+	p = devm_kzalloc(&pdev->dev, sizeof(struct ralink_priv), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	p->dev = &pdev->dev;
+	p->desc = &ralink_pctrl_desc;
+	p->groups = data;
+	platform_set_drvdata(pdev, p);
+
+	/* init the device */
+	err = ralink_pinmux_index(p);
+	if (err) {
+		dev_err(&pdev->dev, "failed to load index\n");
+		return err;
+	}
+
+	err = ralink_pinmux_pins(p);
+	if (err) {
+		dev_err(&pdev->dev, "failed to load pins\n");
+		return err;
+	}
+	dev = pinctrl_register(p->desc, &pdev->dev, p);
+
+	return PTR_ERR_OR_ZERO(dev);
+}
diff --git a/drivers/pinctrl/ralink/pinctrl-ralink.h b/drivers/pinctrl/ralink/pinctrl-ralink.h
new file mode 100644
index 000000000000..134969409585
--- /dev/null
+++ b/drivers/pinctrl/ralink/pinctrl-ralink.h
@@ -0,0 +1,53 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ *  Copyright (C) 2012 John Crispin <john@phrozen.org>
+ */
+
+#ifndef _PINCTRL_RALINK_H__
+#define _PINCTRL_RALINK_H__
+
+#define FUNC(name, value, pin_first, pin_count) \
+	{ name, value, pin_first, pin_count }
+
+#define GRP(_name, _func, _mask, _shift) \
+	{ .name = _name, .mask = _mask, .shift = _shift, \
+	  .func = _func, .gpio = _mask, \
+	  .func_count = ARRAY_SIZE(_func) }
+
+#define GRP_G(_name, _func, _mask, _gpio, _shift) \
+	{ .name = _name, .mask = _mask, .shift = _shift, \
+	  .func = _func, .gpio = _gpio, \
+	  .func_count = ARRAY_SIZE(_func) }
+
+struct ralink_pmx_group;
+
+struct ralink_pmx_func {
+	const char *name;
+	const char value;
+
+	int pin_first;
+	int pin_count;
+	int *pins;
+
+	int *groups;
+	int group_count;
+
+	int enabled;
+};
+
+struct ralink_pmx_group {
+	const char *name;
+	int enabled;
+
+	const u32 shift;
+	const char mask;
+	const char gpio;
+
+	struct ralink_pmx_func *func;
+	int func_count;
+};
+
+int ralink_pinmux_init(struct platform_device *pdev,
+		       struct ralink_pmx_group *data);
+
+#endif
diff --git a/drivers/pinctrl/ralink/pinctrl-rt2880.c b/drivers/pinctrl/ralink/pinctrl-rt2880.c
deleted file mode 100644
index 96fc06d1b8b9..000000000000
--- a/drivers/pinctrl/ralink/pinctrl-rt2880.c
+++ /dev/null
@@ -1,349 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *  Copyright (C) 2013 John Crispin <blogic@openwrt.org>
- */
-
-#include <linux/module.h>
-#include <linux/device.h>
-#include <linux/io.h>
-#include <linux/platform_device.h>
-#include <linux/slab.h>
-#include <linux/of.h>
-#include <linux/pinctrl/pinctrl.h>
-#include <linux/pinctrl/pinconf.h>
-#include <linux/pinctrl/pinconf-generic.h>
-#include <linux/pinctrl/pinmux.h>
-#include <linux/pinctrl/consumer.h>
-#include <linux/pinctrl/machine.h>
-
-#include <asm/mach-ralink/ralink_regs.h>
-#include <asm/mach-ralink/mt7620.h>
-
-#include "pinmux.h"
-#include "../core.h"
-#include "../pinctrl-utils.h"
-
-#define SYSC_REG_GPIO_MODE	0x60
-#define SYSC_REG_GPIO_MODE2	0x64
-
-struct rt2880_priv {
-	struct device *dev;
-
-	struct pinctrl_pin_desc *pads;
-	struct pinctrl_desc *desc;
-
-	struct rt2880_pmx_func **func;
-	int func_count;
-
-	struct rt2880_pmx_group *groups;
-	const char **group_names;
-	int group_count;
-
-	u8 *gpio;
-	int max_pins;
-};
-
-static int rt2880_get_group_count(struct pinctrl_dev *pctrldev)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-
-	return p->group_count;
-}
-
-static const char *rt2880_get_group_name(struct pinctrl_dev *pctrldev,
-					 unsigned int group)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-
-	return (group >= p->group_count) ? NULL : p->group_names[group];
-}
-
-static int rt2880_get_group_pins(struct pinctrl_dev *pctrldev,
-				 unsigned int group,
-				 const unsigned int **pins,
-				 unsigned int *num_pins)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-
-	if (group >= p->group_count)
-		return -EINVAL;
-
-	*pins = p->groups[group].func[0].pins;
-	*num_pins = p->groups[group].func[0].pin_count;
-
-	return 0;
-}
-
-static const struct pinctrl_ops rt2880_pctrl_ops = {
-	.get_groups_count	= rt2880_get_group_count,
-	.get_group_name		= rt2880_get_group_name,
-	.get_group_pins		= rt2880_get_group_pins,
-	.dt_node_to_map		= pinconf_generic_dt_node_to_map_all,
-	.dt_free_map		= pinconf_generic_dt_free_map,
-};
-
-static int rt2880_pmx_func_count(struct pinctrl_dev *pctrldev)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-
-	return p->func_count;
-}
-
-static const char *rt2880_pmx_func_name(struct pinctrl_dev *pctrldev,
-					unsigned int func)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-
-	return p->func[func]->name;
-}
-
-static int rt2880_pmx_group_get_groups(struct pinctrl_dev *pctrldev,
-				       unsigned int func,
-				       const char * const **groups,
-				       unsigned int * const num_groups)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-
-	if (p->func[func]->group_count == 1)
-		*groups = &p->group_names[p->func[func]->groups[0]];
-	else
-		*groups = p->group_names;
-
-	*num_groups = p->func[func]->group_count;
-
-	return 0;
-}
-
-static int rt2880_pmx_group_enable(struct pinctrl_dev *pctrldev,
-				   unsigned int func, unsigned int group)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-	u32 mode = 0;
-	u32 reg = SYSC_REG_GPIO_MODE;
-	int i;
-	int shift;
-
-	/* dont allow double use */
-	if (p->groups[group].enabled) {
-		dev_err(p->dev, "%s is already enabled\n",
-			p->groups[group].name);
-		return 0;
-	}
-
-	p->groups[group].enabled = 1;
-	p->func[func]->enabled = 1;
-
-	shift = p->groups[group].shift;
-	if (shift >= 32) {
-		shift -= 32;
-		reg = SYSC_REG_GPIO_MODE2;
-	}
-	mode = rt_sysc_r32(reg);
-	mode &= ~(p->groups[group].mask << shift);
-
-	/* mark the pins as gpio */
-	for (i = 0; i < p->groups[group].func[0].pin_count; i++)
-		p->gpio[p->groups[group].func[0].pins[i]] = 1;
-
-	/* function 0 is gpio and needs special handling */
-	if (func == 0) {
-		mode |= p->groups[group].gpio << shift;
-	} else {
-		for (i = 0; i < p->func[func]->pin_count; i++)
-			p->gpio[p->func[func]->pins[i]] = 0;
-		mode |= p->func[func]->value << shift;
-	}
-	rt_sysc_w32(mode, reg);
-
-	return 0;
-}
-
-static int rt2880_pmx_group_gpio_request_enable(struct pinctrl_dev *pctrldev,
-						struct pinctrl_gpio_range *range,
-						unsigned int pin)
-{
-	struct rt2880_priv *p = pinctrl_dev_get_drvdata(pctrldev);
-
-	if (!p->gpio[pin]) {
-		dev_err(p->dev, "pin %d is not set to gpio mux\n", pin);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static const struct pinmux_ops rt2880_pmx_group_ops = {
-	.get_functions_count	= rt2880_pmx_func_count,
-	.get_function_name	= rt2880_pmx_func_name,
-	.get_function_groups	= rt2880_pmx_group_get_groups,
-	.set_mux		= rt2880_pmx_group_enable,
-	.gpio_request_enable	= rt2880_pmx_group_gpio_request_enable,
-};
-
-static struct pinctrl_desc rt2880_pctrl_desc = {
-	.owner		= THIS_MODULE,
-	.name		= "rt2880-pinmux",
-	.pctlops	= &rt2880_pctrl_ops,
-	.pmxops		= &rt2880_pmx_group_ops,
-};
-
-static struct rt2880_pmx_func gpio_func = {
-	.name = "gpio",
-};
-
-static int rt2880_pinmux_index(struct rt2880_priv *p)
-{
-	struct rt2880_pmx_group *mux = p->groups;
-	int i, j, c = 0;
-
-	/* count the mux functions */
-	while (mux->name) {
-		p->group_count++;
-		mux++;
-	}
-
-	/* allocate the group names array needed by the gpio function */
-	p->group_names = devm_kcalloc(p->dev, p->group_count,
-				      sizeof(char *), GFP_KERNEL);
-	if (!p->group_names)
-		return -ENOMEM;
-
-	for (i = 0; i < p->group_count; i++) {
-		p->group_names[i] = p->groups[i].name;
-		p->func_count += p->groups[i].func_count;
-	}
-
-	/* we have a dummy function[0] for gpio */
-	p->func_count++;
-
-	/* allocate our function and group mapping index buffers */
-	p->func = devm_kcalloc(p->dev, p->func_count,
-			       sizeof(*p->func), GFP_KERNEL);
-	gpio_func.groups = devm_kcalloc(p->dev, p->group_count, sizeof(int),
-					GFP_KERNEL);
-	if (!p->func || !gpio_func.groups)
-		return -ENOMEM;
-
-	/* add a backpointer to the function so it knows its group */
-	gpio_func.group_count = p->group_count;
-	for (i = 0; i < gpio_func.group_count; i++)
-		gpio_func.groups[i] = i;
-
-	p->func[c] = &gpio_func;
-	c++;
-
-	/* add remaining functions */
-	for (i = 0; i < p->group_count; i++) {
-		for (j = 0; j < p->groups[i].func_count; j++) {
-			p->func[c] = &p->groups[i].func[j];
-			p->func[c]->groups = devm_kzalloc(p->dev, sizeof(int),
-						    GFP_KERNEL);
-			if (!p->func[c]->groups)
-				return -ENOMEM;
-			p->func[c]->groups[0] = i;
-			p->func[c]->group_count = 1;
-			c++;
-		}
-	}
-	return 0;
-}
-
-static int rt2880_pinmux_pins(struct rt2880_priv *p)
-{
-	int i, j;
-
-	/*
-	 * loop over the functions and initialize the pins array.
-	 * also work out the highest pin used.
-	 */
-	for (i = 0; i < p->func_count; i++) {
-		int pin;
-
-		if (!p->func[i]->pin_count)
-			continue;
-
-		p->func[i]->pins = devm_kcalloc(p->dev,
-						p->func[i]->pin_count,
-						sizeof(int),
-						GFP_KERNEL);
-		for (j = 0; j < p->func[i]->pin_count; j++)
-			p->func[i]->pins[j] = p->func[i]->pin_first + j;
-
-		pin = p->func[i]->pin_first + p->func[i]->pin_count;
-		if (pin > p->max_pins)
-			p->max_pins = pin;
-	}
-
-	/* the buffer that tells us which pins are gpio */
-	p->gpio = devm_kcalloc(p->dev, p->max_pins, sizeof(u8), GFP_KERNEL);
-	/* the pads needed to tell pinctrl about our pins */
-	p->pads = devm_kcalloc(p->dev, p->max_pins,
-			       sizeof(struct pinctrl_pin_desc), GFP_KERNEL);
-	if (!p->pads || !p->gpio)
-		return -ENOMEM;
-
-	memset(p->gpio, 1, sizeof(u8) * p->max_pins);
-	for (i = 0; i < p->func_count; i++) {
-		if (!p->func[i]->pin_count)
-			continue;
-
-		for (j = 0; j < p->func[i]->pin_count; j++)
-			p->gpio[p->func[i]->pins[j]] = 0;
-	}
-
-	/* pin 0 is always a gpio */
-	p->gpio[0] = 1;
-
-	/* set the pads */
-	for (i = 0; i < p->max_pins; i++) {
-		/* strlen("ioXY") + 1 = 5 */
-		char *name = devm_kzalloc(p->dev, 5, GFP_KERNEL);
-
-		if (!name)
-			return -ENOMEM;
-		snprintf(name, 5, "io%d", i);
-		p->pads[i].number = i;
-		p->pads[i].name = name;
-	}
-	p->desc->pins = p->pads;
-	p->desc->npins = p->max_pins;
-
-	return 0;
-}
-
-int rt2880_pinmux_init(struct platform_device *pdev,
-		       struct rt2880_pmx_group *data)
-{
-	struct rt2880_priv *p;
-	struct pinctrl_dev *dev;
-	int err;
-
-	if (!data)
-		return -ENOTSUPP;
-
-	/* setup the private data */
-	p = devm_kzalloc(&pdev->dev, sizeof(struct rt2880_priv), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	p->dev = &pdev->dev;
-	p->desc = &rt2880_pctrl_desc;
-	p->groups = data;
-	platform_set_drvdata(pdev, p);
-
-	/* init the device */
-	err = rt2880_pinmux_index(p);
-	if (err) {
-		dev_err(&pdev->dev, "failed to load index\n");
-		return err;
-	}
-
-	err = rt2880_pinmux_pins(p);
-	if (err) {
-		dev_err(&pdev->dev, "failed to load pins\n");
-		return err;
-	}
-	dev = pinctrl_register(p->desc, &pdev->dev, p);
-
-	return PTR_ERR_OR_ZERO(dev);
-}
diff --git a/drivers/pinctrl/ralink/pinctrl-rt288x.c b/drivers/pinctrl/ralink/pinctrl-rt288x.c
index 0744aebbace5..40c45140ff8a 100644
--- a/drivers/pinctrl/ralink/pinctrl-rt288x.c
+++ b/drivers/pinctrl/ralink/pinctrl-rt288x.c
@@ -4,7 +4,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define RT2880_GPIO_MODE_I2C		BIT(0)
 #define RT2880_GPIO_MODE_UART0		BIT(1)
@@ -15,15 +15,15 @@
 #define RT2880_GPIO_MODE_SDRAM		BIT(6)
 #define RT2880_GPIO_MODE_PCI		BIT(7)
 
-static struct rt2880_pmx_func i2c_func[] = { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 7, 8) };
-static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
-static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
-static struct rt2880_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
-static struct rt2880_pmx_func pci_func[] = { FUNC("pci", 0, 40, 32) };
+static struct ralink_pmx_func i2c_func[] = { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 7, 8) };
+static struct ralink_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct ralink_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct ralink_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
+static struct ralink_pmx_func pci_func[] = { FUNC("pci", 0, 40, 32) };
 
-static struct rt2880_pmx_group rt2880_pinmux_data_act[] = {
+static struct ralink_pmx_group rt2880_pinmux_data_act[] = {
 	GRP("i2c", i2c_func, 1, RT2880_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT2880_GPIO_MODE_SPI),
 	GRP("uartlite", uartlite_func, 1, RT2880_GPIO_MODE_UART0),
@@ -36,7 +36,7 @@ static struct rt2880_pmx_group rt2880_pinmux_data_act[] = {
 
 static int rt288x_pinmux_probe(struct platform_device *pdev)
 {
-	return rt2880_pinmux_init(pdev, rt2880_pinmux_data_act);
+	return ralink_pinmux_init(pdev, rt2880_pinmux_data_act);
 }
 
 static const struct of_device_id rt288x_pinmux_match[] = {
diff --git a/drivers/pinctrl/ralink/pinctrl-rt305x.c b/drivers/pinctrl/ralink/pinctrl-rt305x.c
index 5d8fa156c003..25527ca1ccaa 100644
--- a/drivers/pinctrl/ralink/pinctrl-rt305x.c
+++ b/drivers/pinctrl/ralink/pinctrl-rt305x.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define RT305X_GPIO_MODE_UART0_SHIFT	2
 #define RT305X_GPIO_MODE_UART0_MASK	0x7
@@ -31,9 +31,9 @@
 #define RT3352_GPIO_MODE_LNA		18
 #define RT3352_GPIO_MODE_PA		20
 
-static struct rt2880_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartf_func[] = {
+static struct ralink_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartf_func[] = {
 	FUNC("uartf", RT305X_GPIO_MODE_UARTF, 7, 8),
 	FUNC("pcm uartf", RT305X_GPIO_MODE_PCM_UARTF, 7, 8),
 	FUNC("pcm i2s", RT305X_GPIO_MODE_PCM_I2S, 7, 8),
@@ -42,28 +42,28 @@ static struct rt2880_pmx_func uartf_func[] = {
 	FUNC("gpio uartf", RT305X_GPIO_MODE_GPIO_UARTF, 7, 4),
 	FUNC("gpio i2s", RT305X_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
-static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
-static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
-static struct rt2880_pmx_func rt5350_led_func[] = { FUNC("led", 0, 22, 5) };
-static struct rt2880_pmx_func rt5350_cs1_func[] = {
+static struct ralink_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
+static struct ralink_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct ralink_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct ralink_pmx_func rt5350_led_func[] = { FUNC("led", 0, 22, 5) };
+static struct ralink_pmx_func rt5350_cs1_func[] = {
 	FUNC("spi_cs1", 0, 27, 1),
 	FUNC("wdg_cs1", 1, 27, 1),
 };
-static struct rt2880_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
-static struct rt2880_pmx_func rt3352_rgmii_func[] = {
+static struct ralink_pmx_func sdram_func[] = { FUNC("sdram", 0, 24, 16) };
+static struct ralink_pmx_func rt3352_rgmii_func[] = {
 	FUNC("rgmii", 0, 24, 12)
 };
-static struct rt2880_pmx_func rgmii_func[] = { FUNC("rgmii", 0, 40, 12) };
-static struct rt2880_pmx_func rt3352_lna_func[] = { FUNC("lna", 0, 36, 2) };
-static struct rt2880_pmx_func rt3352_pa_func[] = { FUNC("pa", 0, 38, 2) };
-static struct rt2880_pmx_func rt3352_led_func[] = { FUNC("led", 0, 40, 5) };
-static struct rt2880_pmx_func rt3352_cs1_func[] = {
+static struct ralink_pmx_func rgmii_func[] = { FUNC("rgmii", 0, 40, 12) };
+static struct ralink_pmx_func rt3352_lna_func[] = { FUNC("lna", 0, 36, 2) };
+static struct ralink_pmx_func rt3352_pa_func[] = { FUNC("pa", 0, 38, 2) };
+static struct ralink_pmx_func rt3352_led_func[] = { FUNC("led", 0, 40, 5) };
+static struct ralink_pmx_func rt3352_cs1_func[] = {
 	FUNC("spi_cs1", 0, 45, 1),
 	FUNC("wdg_cs1", 1, 45, 1),
 };
 
-static struct rt2880_pmx_group rt3050_pinmux_data[] = {
+static struct ralink_pmx_group rt3050_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
@@ -76,7 +76,7 @@ static struct rt2880_pmx_group rt3050_pinmux_data[] = {
 	{ 0 }
 };
 
-static struct rt2880_pmx_group rt3352_pinmux_data[] = {
+static struct ralink_pmx_group rt3352_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
@@ -92,7 +92,7 @@ static struct rt2880_pmx_group rt3352_pinmux_data[] = {
 	{ 0 }
 };
 
-static struct rt2880_pmx_group rt5350_pinmux_data[] = {
+static struct ralink_pmx_group rt5350_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT305X_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT305X_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT305X_GPIO_MODE_UART0_MASK,
@@ -107,11 +107,11 @@ static struct rt2880_pmx_group rt5350_pinmux_data[] = {
 static int rt305x_pinmux_probe(struct platform_device *pdev)
 {
 	if (soc_is_rt5350())
-		return rt2880_pinmux_init(pdev, rt5350_pinmux_data);
+		return ralink_pinmux_init(pdev, rt5350_pinmux_data);
 	else if (soc_is_rt305x() || soc_is_rt3350())
-		return rt2880_pinmux_init(pdev, rt3050_pinmux_data);
+		return ralink_pinmux_init(pdev, rt3050_pinmux_data);
 	else if (soc_is_rt3352())
-		return rt2880_pinmux_init(pdev, rt3352_pinmux_data);
+		return ralink_pinmux_init(pdev, rt3352_pinmux_data);
 	else
 		return -EINVAL;
 }
diff --git a/drivers/pinctrl/ralink/pinctrl-rt3883.c b/drivers/pinctrl/ralink/pinctrl-rt3883.c
index 3e0e1b4caa64..0b8674dbe188 100644
--- a/drivers/pinctrl/ralink/pinctrl-rt3883.c
+++ b/drivers/pinctrl/ralink/pinctrl-rt3883.c
@@ -3,7 +3,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
-#include "pinmux.h"
+#include "pinctrl-ralink.h"
 
 #define RT3883_GPIO_MODE_UART0_SHIFT	2
 #define RT3883_GPIO_MODE_UART0_MASK	0x7
@@ -39,9 +39,9 @@
 #define RT3883_GPIO_MODE_LNA_G_GPIO	0x3
 #define RT3883_GPIO_MODE_LNA_G		_RT3883_GPIO_MODE_LNA_G(RT3883_GPIO_MODE_LNA_G_MASK)
 
-static struct rt2880_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
-static struct rt2880_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
-static struct rt2880_pmx_func uartf_func[] = {
+static struct ralink_pmx_func i2c_func[] =  { FUNC("i2c", 0, 1, 2) };
+static struct ralink_pmx_func spi_func[] = { FUNC("spi", 0, 3, 4) };
+static struct ralink_pmx_func uartf_func[] = {
 	FUNC("uartf", RT3883_GPIO_MODE_UARTF, 7, 8),
 	FUNC("pcm uartf", RT3883_GPIO_MODE_PCM_UARTF, 7, 8),
 	FUNC("pcm i2s", RT3883_GPIO_MODE_PCM_I2S, 7, 8),
@@ -50,21 +50,21 @@ static struct rt2880_pmx_func uartf_func[] = {
 	FUNC("gpio uartf", RT3883_GPIO_MODE_GPIO_UARTF, 7, 4),
 	FUNC("gpio i2s", RT3883_GPIO_MODE_GPIO_I2S, 7, 4),
 };
-static struct rt2880_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
-static struct rt2880_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
-static struct rt2880_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
-static struct rt2880_pmx_func lna_a_func[] = { FUNC("lna a", 0, 32, 3) };
-static struct rt2880_pmx_func lna_g_func[] = { FUNC("lna g", 0, 35, 3) };
-static struct rt2880_pmx_func pci_func[] = {
+static struct ralink_pmx_func uartlite_func[] = { FUNC("uartlite", 0, 15, 2) };
+static struct ralink_pmx_func jtag_func[] = { FUNC("jtag", 0, 17, 5) };
+static struct ralink_pmx_func mdio_func[] = { FUNC("mdio", 0, 22, 2) };
+static struct ralink_pmx_func lna_a_func[] = { FUNC("lna a", 0, 32, 3) };
+static struct ralink_pmx_func lna_g_func[] = { FUNC("lna g", 0, 35, 3) };
+static struct ralink_pmx_func pci_func[] = {
 	FUNC("pci-dev", 0, 40, 32),
 	FUNC("pci-host2", 1, 40, 32),
 	FUNC("pci-host1", 2, 40, 32),
 	FUNC("pci-fnc", 3, 40, 32)
 };
-static struct rt2880_pmx_func ge1_func[] = { FUNC("ge1", 0, 72, 12) };
-static struct rt2880_pmx_func ge2_func[] = { FUNC("ge2", 0, 84, 12) };
+static struct ralink_pmx_func ge1_func[] = { FUNC("ge1", 0, 72, 12) };
+static struct ralink_pmx_func ge2_func[] = { FUNC("ge2", 0, 84, 12) };
 
-static struct rt2880_pmx_group rt3883_pinmux_data[] = {
+static struct ralink_pmx_group rt3883_pinmux_data[] = {
 	GRP("i2c", i2c_func, 1, RT3883_GPIO_MODE_I2C),
 	GRP("spi", spi_func, 1, RT3883_GPIO_MODE_SPI),
 	GRP("uartf", uartf_func, RT3883_GPIO_MODE_UART0_MASK,
@@ -83,7 +83,7 @@ static struct rt2880_pmx_group rt3883_pinmux_data[] = {
 
 static int rt3883_pinmux_probe(struct platform_device *pdev)
 {
-	return rt2880_pinmux_init(pdev, rt3883_pinmux_data);
+	return ralink_pinmux_init(pdev, rt3883_pinmux_data);
 }
 
 static const struct of_device_id rt3883_pinmux_match[] = {
diff --git a/drivers/pinctrl/ralink/pinmux.h b/drivers/pinctrl/ralink/pinmux.h
deleted file mode 100644
index 0046abe3bcc7..000000000000
--- a/drivers/pinctrl/ralink/pinmux.h
+++ /dev/null
@@ -1,53 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- *  Copyright (C) 2012 John Crispin <john@phrozen.org>
- */
-
-#ifndef _RT288X_PINMUX_H__
-#define _RT288X_PINMUX_H__
-
-#define FUNC(name, value, pin_first, pin_count) \
-	{ name, value, pin_first, pin_count }
-
-#define GRP(_name, _func, _mask, _shift) \
-	{ .name = _name, .mask = _mask, .shift = _shift, \
-	  .func = _func, .gpio = _mask, \
-	  .func_count = ARRAY_SIZE(_func) }
-
-#define GRP_G(_name, _func, _mask, _gpio, _shift) \
-	{ .name = _name, .mask = _mask, .shift = _shift, \
-	  .func = _func, .gpio = _gpio, \
-	  .func_count = ARRAY_SIZE(_func) }
-
-struct rt2880_pmx_group;
-
-struct rt2880_pmx_func {
-	const char *name;
-	const char value;
-
-	int pin_first;
-	int pin_count;
-	int *pins;
-
-	int *groups;
-	int group_count;
-
-	int enabled;
-};
-
-struct rt2880_pmx_group {
-	const char *name;
-	int enabled;
-
-	const u32 shift;
-	const char mask;
-	const char gpio;
-
-	struct rt2880_pmx_func *func;
-	int func_count;
-};
-
-int rt2880_pinmux_init(struct platform_device *pdev,
-		       struct rt2880_pmx_group *data);
-
-#endif
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 97a4fb5a9328..d3fa8cf0d72c 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1299,15 +1299,17 @@ static int stm32_gpiolib_register_bank(struct stm32_pinctrl *pctl,
 	bank->bank_ioport_nr = bank_ioport_nr;
 	spin_lock_init(&bank->lock);
 
-	/* create irq hierarchical domain */
-	bank->fwnode = of_node_to_fwnode(np);
+	if (pctl->domain) {
+		/* create irq hierarchical domain */
+		bank->fwnode = of_node_to_fwnode(np);
 
-	bank->domain = irq_domain_create_hierarchy(pctl->domain, 0,
-					STM32_GPIO_IRQ_LINE, bank->fwnode,
-					&stm32_gpio_domain_ops, bank);
+		bank->domain = irq_domain_create_hierarchy(pctl->domain, 0, STM32_GPIO_IRQ_LINE,
+							   bank->fwnode, &stm32_gpio_domain_ops,
+							   bank);
 
-	if (!bank->domain)
-		return -ENODEV;
+		if (!bank->domain)
+			return -ENODEV;
+	}
 
 	err = gpiochip_add_data(&bank->gpio_chip, bank);
 	if (err) {
@@ -1477,6 +1479,8 @@ int stm32_pctl_probe(struct platform_device *pdev)
 	pctl->domain = stm32_pctrl_get_irq_domain(np);
 	if (IS_ERR(pctl->domain))
 		return PTR_ERR(pctl->domain);
+	if (!pctl->domain)
+		dev_warn(dev, "pinctrl without interrupt support\n");
 
 	/* hwspinlock is optional */
 	hwlock_id = of_hwspin_lock_get_id(pdev->dev.of_node, 0);
diff --git a/drivers/power/reset/arm-versatile-reboot.c b/drivers/power/reset/arm-versatile-reboot.c
index 08d0a07b58ef..c7624d7611a7 100644
--- a/drivers/power/reset/arm-versatile-reboot.c
+++ b/drivers/power/reset/arm-versatile-reboot.c
@@ -146,6 +146,7 @@ static int __init versatile_reboot_probe(void)
 	versatile_reboot_type = (enum versatile_reboot)reboot_id->data;
 
 	syscon_regmap = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(syscon_regmap))
 		return PTR_ERR(syscon_regmap);
 
diff --git a/drivers/s390/char/keyboard.h b/drivers/s390/char/keyboard.h
index c467589c7f45..c06d399b9b1f 100644
--- a/drivers/s390/char/keyboard.h
+++ b/drivers/s390/char/keyboard.h
@@ -56,7 +56,7 @@ static inline void
 kbd_put_queue(struct tty_port *port, int ch)
 {
 	tty_insert_flip_char(port, ch, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static inline void
@@ -64,5 +64,5 @@ kbd_puts_queue(struct tty_port *port, char *cp)
 {
 	while (*cp)
 		tty_insert_flip_char(port, *cp++, 0);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index bb3f78013a13..88e164e3d2ea 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3196,6 +3196,9 @@ static int megasas_map_queues(struct Scsi_Host *shost)
 	qoff += map->nr_queues;
 	offset += map->nr_queues;
 
+	/* we never use READ queue, so can't cheat blk-mq */
+	shost->tag_set.map[HCTX_TYPE_READ].nr_queues = 0;
+
 	/* Setup Poll hctx */
 	map = &shost->tag_set.map[HCTX_TYPE_POLL];
 	map->nr_queues = instance->iopoll_q_count;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5c9a31f18b7f..4a7248421bcd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5638,7 +5638,7 @@ int ufshcd_wb_toggle(struct ufs_hba *hba, bool enable)
 	}
 
 	hba->dev_info.wb_enabled = enable;
-	dev_info(hba->dev, "%s Write Booster %s\n",
+	dev_dbg(hba->dev, "%s Write Booster %s\n",
 			__func__, enable ? "enabled" : "disabled");
 
 	return ret;
diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 775c0bf2f923..0933948d7df3 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -1138,10 +1138,14 @@ static void bcm2835_spi_handle_err(struct spi_controller *ctlr,
 	struct bcm2835_spi *bs = spi_controller_get_devdata(ctlr);
 
 	/* if an error occurred and we have an active dma, then terminate */
-	dmaengine_terminate_sync(ctlr->dma_tx);
-	bs->tx_dma_active = false;
-	dmaengine_terminate_sync(ctlr->dma_rx);
-	bs->rx_dma_active = false;
+	if (ctlr->dma_tx) {
+		dmaengine_terminate_sync(ctlr->dma_tx);
+		bs->tx_dma_active = false;
+	}
+	if (ctlr->dma_rx) {
+		dmaengine_terminate_sync(ctlr->dma_rx);
+		bs->rx_dma_active = false;
+	}
 	bcm2835_spi_undo_prologue(bs);
 
 	/* and reset */
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 0e32920af10d..7ca3cd8eb574 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -151,7 +151,7 @@ static irqreturn_t goldfish_tty_interrupt(int irq, void *dev_id)
 	address = (unsigned long)(void *)buf;
 	goldfish_tty_rw(qtty, address, count, 0);
 
-	tty_schedule_flip(&qtty->port);
+	tty_flip_buffer_push(&qtty->port);
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index bf17e90858b8..a29ec5a93839 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1383,7 +1383,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		if (inited && !tty_throttled(tty) &&
 				MoxaPortRxQueue(p) > 0) { /* RX */
 			MoxaPortReadData(p);
-			tty_schedule_flip(&p->port);
+			tty_flip_buffer_push(&p->port);
 		}
 	} else {
 		clear_bit(EMPTYWAIT, &p->statusflags);
@@ -1408,7 +1408,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 
 	if (tty && (intr & IntrBreak) && !I_IGNBRK(tty)) { /* BREAK */
 		tty_insert_flip_char(&p->port, 0, TTY_BREAK);
-		tty_schedule_flip(&p->port);
+		tty_flip_buffer_push(&p->port);
 	}
 
 	if (intr & IntrLine)
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 74bfabe5b453..752dab3356d7 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -111,21 +111,11 @@ static void pty_unthrottle(struct tty_struct *tty)
 static int pty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 {
 	struct tty_struct *to = tty->link;
-	unsigned long flags;
 
-	if (tty->flow.stopped)
+	if (tty->flow.stopped || !c)
 		return 0;
 
-	if (c > 0) {
-		spin_lock_irqsave(&to->port->lock, flags);
-		/* Stuff the data into the input queue of the other end */
-		c = tty_insert_flip_string(to->port, buf, c);
-		spin_unlock_irqrestore(&to->port->lock, flags);
-		/* And shovel */
-		if (c)
-			tty_flip_buffer_push(to->port);
-	}
-	return c;
+	return tty_insert_flip_string_and_push_buffer(to->port, buf, c);
 }
 
 /**
diff --git a/drivers/tty/serial/lpc32xx_hs.c b/drivers/tty/serial/lpc32xx_hs.c
index b199d7859961..07c4161eb4cc 100644
--- a/drivers/tty/serial/lpc32xx_hs.c
+++ b/drivers/tty/serial/lpc32xx_hs.c
@@ -341,7 +341,7 @@ static irqreturn_t serial_lpc32xx_interrupt(int irq, void *dev_id)
 		       LPC32XX_HSUART_IIR(port->membase));
 		port->icount.overrun++;
 		tty_insert_flip_char(tport, 0, TTY_OVERRUN);
-		tty_schedule_flip(tport);
+		tty_flip_buffer_push(tport);
 	}
 
 	/* Data received? */
diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index ab226da75f7b..8eb64898b159 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -442,13 +442,13 @@ static void mvebu_uart_shutdown(struct uart_port *port)
 	}
 }
 
-static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
+static unsigned int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 {
 	unsigned int d_divisor, m_divisor;
 	u32 brdv, osamp;
 
 	if (!port->uartclk)
-		return -EOPNOTSUPP;
+		return 0;
 
 	/*
 	 * The baudrate is derived from the UART clock thanks to two divisors:
@@ -472,7 +472,7 @@ static int mvebu_uart_baud_rate_set(struct uart_port *port, unsigned int baud)
 	osamp &= ~OSAMP_DIVISORS_MASK;
 	writel(osamp, port->membase + UART_OSAMP);
 
-	return 0;
+	return DIV_ROUND_CLOSEST(port->uartclk, d_divisor * m_divisor);
 }
 
 static void mvebu_uart_set_termios(struct uart_port *port,
@@ -509,15 +509,11 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 	max_baud = 230400;
 
 	baud = uart_get_baud_rate(port, termios, old, min_baud, max_baud);
-	if (mvebu_uart_baud_rate_set(port, baud)) {
-		/* No clock available, baudrate cannot be changed */
-		if (old)
-			baud = uart_get_baud_rate(port, old, NULL,
-						  min_baud, max_baud);
-	} else {
-		tty_termios_encode_baud_rate(termios, baud, baud);
-		uart_update_timeout(port, termios->c_cflag, baud);
-	}
+	baud = mvebu_uart_baud_rate_set(port, baud);
+
+	/* In case baudrate cannot be changed, report previous old value */
+	if (baud == 0 && old)
+		baud = tty_termios_baud_rate(old);
 
 	/* Only the following flag changes are supported */
 	if (old) {
@@ -528,6 +524,11 @@ static void mvebu_uart_set_termios(struct uart_port *port,
 		termios->c_cflag |= CS8;
 	}
 
+	if (baud != 0) {
+		tty_termios_encode_baud_rate(termios, baud, baud);
+		uart_update_timeout(port, termios->c_cflag, baud);
+	}
+
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
diff --git a/drivers/tty/tty.h b/drivers/tty/tty.h
index b710c5ef89ab..f310a8274df1 100644
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -111,4 +111,7 @@ static inline void tty_audit_tiocsti(struct tty_struct *tty, char ch)
 
 ssize_t redirected_tty_write(struct kiocb *, struct iov_iter *);
 
+int tty_insert_flip_string_and_push_buffer(struct tty_port *port,
+		const unsigned char *chars, size_t cnt);
+
 #endif
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 6127f84b92b1..f3143ae4bf7f 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -402,27 +402,6 @@ int __tty_insert_flip_char(struct tty_port *port, unsigned char ch, char flag)
 }
 EXPORT_SYMBOL(__tty_insert_flip_char);
 
-/**
- *	tty_schedule_flip	-	push characters to ldisc
- *	@port: tty port to push from
- *
- *	Takes any pending buffers and transfers their ownership to the
- *	ldisc side of the queue. It then schedules those characters for
- *	processing by the line discipline.
- */
-
-void tty_schedule_flip(struct tty_port *port)
-{
-	struct tty_bufhead *buf = &port->buf;
-
-	/* paired w/ acquire in flush_to_ldisc(); ensures
-	 * flush_to_ldisc() sees buffer data.
-	 */
-	smp_store_release(&buf->tail->commit, buf->tail->used);
-	queue_work(system_unbound_wq, &buf->work);
-}
-EXPORT_SYMBOL(tty_schedule_flip);
-
 /**
  *	tty_prepare_flip_string		-	make room for characters
  *	@port: tty port
@@ -554,6 +533,15 @@ static void flush_to_ldisc(struct work_struct *work)
 
 }
 
+static inline void tty_flip_buffer_commit(struct tty_buffer *tail)
+{
+	/*
+	 * Paired w/ acquire in flush_to_ldisc(); ensures flush_to_ldisc() sees
+	 * buffer data.
+	 */
+	smp_store_release(&tail->commit, tail->used);
+}
+
 /**
  *	tty_flip_buffer_push	-	terminal
  *	@port: tty port to push
@@ -567,10 +555,44 @@ static void flush_to_ldisc(struct work_struct *work)
 
 void tty_flip_buffer_push(struct tty_port *port)
 {
-	tty_schedule_flip(port);
+	struct tty_bufhead *buf = &port->buf;
+
+	tty_flip_buffer_commit(buf->tail);
+	queue_work(system_unbound_wq, &buf->work);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);
 
+/**
+ * tty_insert_flip_string_and_push_buffer - add characters to the tty buffer and
+ *	push
+ * @port: tty port
+ * @chars: characters
+ * @size: size
+ *
+ * The function combines tty_insert_flip_string() and tty_flip_buffer_push()
+ * with the exception of properly holding the @port->lock.
+ *
+ * To be used only internally (by pty currently).
+ *
+ * Returns: the number added.
+ */
+int tty_insert_flip_string_and_push_buffer(struct tty_port *port,
+		const unsigned char *chars, size_t size)
+{
+	struct tty_bufhead *buf = &port->buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&port->lock, flags);
+	size = tty_insert_flip_string(port, chars, size);
+	if (size)
+		tty_flip_buffer_commit(buf->tail);
+	spin_unlock_irqrestore(&port->lock, flags);
+
+	queue_work(system_unbound_wq, &buf->work);
+
+	return size;
+}
+
 /**
  *	tty_buffer_init		-	prepare a tty buffer structure
  *	@port: tty port to initialise
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index c7fbbcdcc346..3700cd057f27 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -324,13 +324,13 @@ int kbd_rate(struct kbd_repeat *rpt)
 static void put_queue(struct vc_data *vc, int ch)
 {
 	tty_insert_flip_char(&vc->port, ch, 0);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void puts_queue(struct vc_data *vc, const char *cp)
 {
 	tty_insert_flip_string(&vc->port, cp, strlen(cp));
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void applkey(struct vc_data *vc, int key, char mode)
@@ -584,7 +584,7 @@ static void fn_inc_console(struct vc_data *vc)
 static void fn_send_intr(struct vc_data *vc)
 {
 	tty_insert_flip_char(&vc->port, 0, TTY_BREAK);
-	tty_schedule_flip(&vc->port);
+	tty_flip_buffer_push(&vc->port);
 }
 
 static void fn_scroll_forw(struct vc_data *vc)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 55283a7f973f..dfc1f4b445f3 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -1833,7 +1833,7 @@ static void csi_m(struct vc_data *vc)
 static void respond_string(const char *p, size_t len, struct tty_port *port)
 {
 	tty_insert_flip_string(port, p, len);
-	tty_schedule_flip(port);
+	tty_flip_buffer_push(port);
 }
 
 static void cursor_report(struct vc_data *vc, struct tty_struct *tty)
diff --git a/drivers/usb/host/xhci-dbgcap.c b/drivers/usb/host/xhci-dbgcap.c
index ccb0156fcebe..46c8f3c187f7 100644
--- a/drivers/usb/host/xhci-dbgcap.c
+++ b/drivers/usb/host/xhci-dbgcap.c
@@ -914,59 +914,6 @@ static void xhci_dbc_handle_events(struct work_struct *work)
 	mod_delayed_work(system_wq, &dbc->event_work, 1);
 }
 
-static void xhci_do_dbc_exit(struct xhci_hcd *xhci)
-{
-	unsigned long		flags;
-
-	spin_lock_irqsave(&xhci->lock, flags);
-	kfree(xhci->dbc);
-	xhci->dbc = NULL;
-	spin_unlock_irqrestore(&xhci->lock, flags);
-}
-
-static int xhci_do_dbc_init(struct xhci_hcd *xhci)
-{
-	u32			reg;
-	struct xhci_dbc		*dbc;
-	unsigned long		flags;
-	void __iomem		*base;
-	int			dbc_cap_offs;
-
-	base = &xhci->cap_regs->hc_capbase;
-	dbc_cap_offs = xhci_find_next_ext_cap(base, 0, XHCI_EXT_CAPS_DEBUG);
-	if (!dbc_cap_offs)
-		return -ENODEV;
-
-	dbc = kzalloc(sizeof(*dbc), GFP_KERNEL);
-	if (!dbc)
-		return -ENOMEM;
-
-	dbc->regs = base + dbc_cap_offs;
-
-	/* We will avoid using DbC in xhci driver if it's in use. */
-	reg = readl(&dbc->regs->control);
-	if (reg & DBC_CTRL_DBC_ENABLE) {
-		kfree(dbc);
-		return -EBUSY;
-	}
-
-	spin_lock_irqsave(&xhci->lock, flags);
-	if (xhci->dbc) {
-		spin_unlock_irqrestore(&xhci->lock, flags);
-		kfree(dbc);
-		return -EBUSY;
-	}
-	xhci->dbc = dbc;
-	spin_unlock_irqrestore(&xhci->lock, flags);
-
-	dbc->xhci = xhci;
-	dbc->dev = xhci_to_hcd(xhci)->self.sysdev;
-	INIT_DELAYED_WORK(&dbc->event_work, xhci_dbc_handle_events);
-	spin_lock_init(&dbc->lock);
-
-	return 0;
-}
-
 static ssize_t dbc_show(struct device *dev,
 			struct device_attribute *attr,
 			char *buf)
@@ -1026,44 +973,86 @@ static ssize_t dbc_store(struct device *dev,
 
 static DEVICE_ATTR_RW(dbc);
 
-int xhci_dbc_init(struct xhci_hcd *xhci)
+struct xhci_dbc *
+xhci_alloc_dbc(struct device *dev, void __iomem *base, const struct dbc_driver *driver)
 {
+	struct xhci_dbc		*dbc;
 	int			ret;
-	struct device		*dev = xhci_to_hcd(xhci)->self.controller;
 
-	ret = xhci_do_dbc_init(xhci);
-	if (ret)
-		goto init_err3;
+	dbc = kzalloc(sizeof(*dbc), GFP_KERNEL);
+	if (!dbc)
+		return NULL;
 
-	ret = xhci_dbc_tty_probe(xhci);
-	if (ret)
-		goto init_err2;
+	dbc->regs = base;
+	dbc->dev = dev;
+	dbc->driver = driver;
+
+	if (readl(&dbc->regs->control) & DBC_CTRL_DBC_ENABLE)
+		return NULL;
+
+	INIT_DELAYED_WORK(&dbc->event_work, xhci_dbc_handle_events);
+	spin_lock_init(&dbc->lock);
 
 	ret = device_create_file(dev, &dev_attr_dbc);
 	if (ret)
-		goto init_err1;
+		goto err;
 
-	return 0;
+	return dbc;
+err:
+	kfree(dbc);
+	return NULL;
+}
+
+/* undo what xhci_alloc_dbc() did */
+void xhci_dbc_remove(struct xhci_dbc *dbc)
+{
+	if (!dbc)
+		return;
+	/* stop hw, stop wq and call dbc->ops->stop() */
+	xhci_dbc_stop(dbc);
+
+	/* remove sysfs files */
+	device_remove_file(dbc->dev, &dev_attr_dbc);
+
+	kfree(dbc);
+}
+
+
+int xhci_create_dbc_dev(struct xhci_hcd *xhci)
+{
+	struct device		*dev;
+	void __iomem		*base;
+	int			ret;
+	int			dbc_cap_offs;
+
+	/* create all parameters needed resembling a dbc device */
+	dev = xhci_to_hcd(xhci)->self.controller;
+	base = &xhci->cap_regs->hc_capbase;
+
+	dbc_cap_offs = xhci_find_next_ext_cap(base, 0, XHCI_EXT_CAPS_DEBUG);
+	if (!dbc_cap_offs)
+		return -ENODEV;
+
+	/* already allocated and in use */
+	if (xhci->dbc)
+		return -EBUSY;
+
+	ret = xhci_dbc_tty_probe(dev, base + dbc_cap_offs, xhci);
 
-init_err1:
-	xhci_dbc_tty_remove(xhci->dbc);
-init_err2:
-	xhci_do_dbc_exit(xhci);
-init_err3:
 	return ret;
 }
 
-void xhci_dbc_exit(struct xhci_hcd *xhci)
+void xhci_remove_dbc_dev(struct xhci_hcd *xhci)
 {
-	struct device		*dev = xhci_to_hcd(xhci)->self.controller;
+	unsigned long		flags;
 
 	if (!xhci->dbc)
 		return;
 
-	device_remove_file(dev, &dev_attr_dbc);
 	xhci_dbc_tty_remove(xhci->dbc);
-	xhci_dbc_stop(xhci->dbc);
-	xhci_do_dbc_exit(xhci);
+	spin_lock_irqsave(&xhci->lock, flags);
+	xhci->dbc = NULL;
+	spin_unlock_irqrestore(&xhci->lock, flags);
 }
 
 #ifdef CONFIG_PM
diff --git a/drivers/usb/host/xhci-dbgcap.h b/drivers/usb/host/xhci-dbgcap.h
index c70b78d504eb..8b5b363a0719 100644
--- a/drivers/usb/host/xhci-dbgcap.h
+++ b/drivers/usb/host/xhci-dbgcap.h
@@ -194,10 +194,13 @@ static inline struct dbc_ep *get_out_ep(struct xhci_dbc *dbc)
 }
 
 #ifdef CONFIG_USB_XHCI_DBGCAP
-int xhci_dbc_init(struct xhci_hcd *xhci);
-void xhci_dbc_exit(struct xhci_hcd *xhci);
-int xhci_dbc_tty_probe(struct xhci_hcd *xhci);
+int xhci_create_dbc_dev(struct xhci_hcd *xhci);
+void xhci_remove_dbc_dev(struct xhci_hcd *xhci);
+int xhci_dbc_tty_probe(struct device *dev, void __iomem *res, struct xhci_hcd *xhci);
 void xhci_dbc_tty_remove(struct xhci_dbc *dbc);
+struct xhci_dbc *xhci_alloc_dbc(struct device *dev, void __iomem *res,
+				 const struct dbc_driver *driver);
+void xhci_dbc_remove(struct xhci_dbc *dbc);
 struct dbc_request *dbc_alloc_request(struct xhci_dbc *dbc,
 				      unsigned int direction,
 				      gfp_t flags);
@@ -208,12 +211,12 @@ int xhci_dbc_suspend(struct xhci_hcd *xhci);
 int xhci_dbc_resume(struct xhci_hcd *xhci);
 #endif /* CONFIG_PM */
 #else
-static inline int xhci_dbc_init(struct xhci_hcd *xhci)
+static inline int xhci_create_dbc_dev(struct xhci_hcd *xhci)
 {
 	return 0;
 }
 
-static inline void xhci_dbc_exit(struct xhci_hcd *xhci)
+static inline void xhci_remove_dbc_dev(struct xhci_hcd *xhci)
 {
 }
 
diff --git a/drivers/usb/host/xhci-dbgtty.c b/drivers/usb/host/xhci-dbgtty.c
index eb46e642e87a..18bcc96853ae 100644
--- a/drivers/usb/host/xhci-dbgtty.c
+++ b/drivers/usb/host/xhci-dbgtty.c
@@ -468,9 +468,9 @@ static const struct dbc_driver dbc_driver = {
 	.disconnect		= xhci_dbc_tty_unregister_device,
 };
 
-int xhci_dbc_tty_probe(struct xhci_hcd *xhci)
+int xhci_dbc_tty_probe(struct device *dev, void __iomem *base, struct xhci_hcd *xhci)
 {
-	struct xhci_dbc		*dbc = xhci->dbc;
+	struct xhci_dbc		*dbc;
 	struct dbc_port		*port;
 	int			status;
 
@@ -485,13 +485,22 @@ int xhci_dbc_tty_probe(struct xhci_hcd *xhci)
 		goto out;
 	}
 
-	dbc->driver = &dbc_driver;
-	dbc->priv = port;
+	dbc_tty_driver->driver_state = port;
+
+	dbc = xhci_alloc_dbc(dev, base, &dbc_driver);
+	if (!dbc) {
+		status = -ENOMEM;
+		goto out2;
+	}
 
+	dbc->priv = port;
 
-	dbc_tty_driver->driver_state = port;
+	/* get rid of xhci once this is a real driver binding to a device */
+	xhci->dbc = dbc;
 
 	return 0;
+out2:
+	kfree(port);
 out:
 	/* dbc_tty_exit will be called by module_exit() in the future */
 	dbc_tty_exit();
@@ -506,8 +515,7 @@ void xhci_dbc_tty_remove(struct xhci_dbc *dbc)
 {
 	struct dbc_port         *port = dbc_to_port(dbc);
 
-	dbc->driver = NULL;
-	dbc->priv = NULL;
+	xhci_dbc_remove(dbc);
 	kfree(port);
 
 	/* dbc_tty_exit will be called by  module_exit() in the future */
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 94fe7d64e762..d76c10f9ad80 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -693,7 +693,9 @@ int xhci_run(struct usb_hcd *hcd)
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
-	xhci_dbc_init(xhci);
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
+
+	xhci_create_dbc_dev(xhci);
 
 	xhci_debugfs_init(xhci);
 
@@ -723,7 +725,7 @@ static void xhci_stop(struct usb_hcd *hcd)
 		return;
 	}
 
-	xhci_dbc_exit(xhci);
+	xhci_remove_dbc_dev(xhci);
 
 	spin_lock_irq(&xhci->lock);
 	xhci->xhc_state |= XHCI_STATE_HALTED;
diff --git a/fs/dlm/lock.c b/fs/dlm/lock.c
index bb9e85e8819c..9f93496d2cc9 100644
--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -4065,13 +4065,14 @@ static void send_repeat_remove(struct dlm_ls *ls, char *ms_name, int len)
 	rv = _create_message(ls, sizeof(struct dlm_message) + len,
 			     dir_nodeid, DLM_MSG_REMOVE, &ms, &mh);
 	if (rv)
-		return;
+		goto out;
 
 	memcpy(ms->m_extra, name, len);
 	ms->m_hash = hash;
 
 	send_message(mh, ms);
 
+out:
 	spin_lock(&ls->ls_remove_spin);
 	ls->ls_remove_len = 0;
 	memset(ls->ls_remove_name, 0, DLM_RESNAME_MAXLEN);
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 9d8ada781250..8a7f4c0830f3 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -1069,6 +1069,7 @@ static int exfat_rename_file(struct inode *inode, struct exfat_chain *p_dir,
 
 		exfat_remove_entries(inode, p_dir, oldentry, 0,
 			num_old_entries);
+		ei->dir = *p_dir;
 		ei->entry = newentry;
 	} else {
 		if (exfat_get_entry_type(epold) == TYPE_FILE) {
@@ -1159,28 +1160,6 @@ static int exfat_move_file(struct inode *inode, struct exfat_chain *p_olddir,
 	return 0;
 }
 
-static void exfat_update_parent_info(struct exfat_inode_info *ei,
-		struct inode *parent_inode)
-{
-	struct exfat_sb_info *sbi = EXFAT_SB(parent_inode->i_sb);
-	struct exfat_inode_info *parent_ei = EXFAT_I(parent_inode);
-	loff_t parent_isize = i_size_read(parent_inode);
-
-	/*
-	 * the problem that struct exfat_inode_info caches wrong parent info.
-	 *
-	 * because of flag-mismatch of ei->dir,
-	 * there is abnormal traversing cluster chain.
-	 */
-	if (unlikely(parent_ei->flags != ei->dir.flags ||
-		     parent_isize != EXFAT_CLU_TO_B(ei->dir.size, sbi) ||
-		     parent_ei->start_clu != ei->dir.dir)) {
-		exfat_chain_set(&ei->dir, parent_ei->start_clu,
-			EXFAT_B_TO_CLU_ROUND_UP(parent_isize, sbi),
-			parent_ei->flags);
-	}
-}
-
 /* rename or move a old file into a new file */
 static int __exfat_rename(struct inode *old_parent_inode,
 		struct exfat_inode_info *ei, struct inode *new_parent_inode,
@@ -1211,9 +1190,9 @@ static int __exfat_rename(struct inode *old_parent_inode,
 		return -ENOENT;
 	}
 
-	exfat_update_parent_info(ei, old_parent_inode);
-
-	exfat_chain_dup(&olddir, &ei->dir);
+	exfat_chain_set(&olddir, EXFAT_I(old_parent_inode)->start_clu,
+		EXFAT_B_TO_CLU_ROUND_UP(i_size_read(old_parent_inode), sbi),
+		EXFAT_I(old_parent_inode)->flags);
 	dentry = ei->entry;
 
 	ep = exfat_get_dentry(sb, &olddir, dentry, &old_bh, NULL);
@@ -1233,8 +1212,6 @@ static int __exfat_rename(struct inode *old_parent_inode,
 			goto out;
 		}
 
-		exfat_update_parent_info(new_ei, new_parent_inode);
-
 		p_dir = &(new_ei->dir);
 		new_entry = new_ei->entry;
 		ep = exfat_get_dentry(sb, p_dir, new_entry, &new_bh, NULL);
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 5d66faecd4ef..013fc5931bc3 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -25,7 +25,7 @@ static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
 /* shared constants to be used in various sysctls */
-const int sysctl_vals[] = { 0, 1, INT_MAX };
+const int sysctl_vals[] = { -1, 0, 1, 2, 4, 100, 200, 1000, 3000, INT_MAX };
 EXPORT_SYMBOL(sysctl_vals);
 
 /* Support for permanently empty directories */
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 4c6f9045baca..3f597cad2c33 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -116,23 +116,29 @@ void xfs_perag_put(struct xfs_perag *pag);
 
 /*
  * Perag iteration APIs
- *
- * XXX: for_each_perag_range() usage really needs an iterator to clean up when
- * we terminate at end_agno because we may have taken a reference to the perag
- * beyond end_agno. Right now callers have to be careful to catch and clean that
- * up themselves. This is not necessary for the callers of for_each_perag() and
- * for_each_perag_from() because they terminate at sb_agcount where there are
- * no perag structures in tree beyond end_agno.
  */
-#define for_each_perag_range(mp, next_agno, end_agno, pag) \
-	for ((pag) = xfs_perag_get((mp), (next_agno)); \
-		(pag) != NULL && (next_agno) <= (end_agno); \
-		(next_agno) = (pag)->pag_agno + 1, \
-		xfs_perag_put(pag), \
-		(pag) = xfs_perag_get((mp), (next_agno)))
+static inline struct xfs_perag *
+xfs_perag_next(
+	struct xfs_perag	*pag,
+	xfs_agnumber_t		*agno,
+	xfs_agnumber_t		end_agno)
+{
+	struct xfs_mount	*mp = pag->pag_mount;
+
+	*agno = pag->pag_agno + 1;
+	xfs_perag_put(pag);
+	if (*agno > end_agno)
+		return NULL;
+	return xfs_perag_get(mp, *agno);
+}
+
+#define for_each_perag_range(mp, agno, end_agno, pag) \
+	for ((pag) = xfs_perag_get((mp), (agno)); \
+		(pag) != NULL; \
+		(pag) = xfs_perag_next((pag), &(agno), (end_agno)))
 
-#define for_each_perag_from(mp, next_agno, pag) \
-	for_each_perag_range((mp), (next_agno), (mp)->m_sb.sb_agcount, (pag))
+#define for_each_perag_from(mp, agno, pag) \
+	for_each_perag_range((mp), (agno), (mp)->m_sb.sb_agcount - 1, (pag))
 
 
 #define for_each_perag(mp, agno, pag) \
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index ac9e80152b5c..89c8a1498df1 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -662,7 +662,7 @@ xfs_btree_bload_compute_geometry(
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels < XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -724,7 +724,7 @@ xfs_btree_bload_compute_geometry(
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels == XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 09269f478df9..fba52e75e98b 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -372,7 +372,7 @@ int
 xfs_ioc_attr_list(
 	struct xfs_inode		*dp,
 	void __user			*ubuf,
-	int				bufsize,
+	size_t				bufsize,
 	int				flags,
 	struct xfs_attrlist_cursor __user *ucursor)
 {
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 28453a6d4461..845d3bcab74b 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -38,8 +38,9 @@ xfs_readlink_by_handle(
 int xfs_ioc_attrmulti_one(struct file *parfilp, struct inode *inode,
 		uint32_t opcode, void __user *uname, void __user *value,
 		uint32_t *len, uint32_t flags);
-int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf, int bufsize,
-	int flags, struct xfs_attrlist_cursor __user *ucursor);
+int xfs_ioc_attr_list(struct xfs_inode *dp, void __user *ubuf,
+		      size_t bufsize, int flags,
+		      struct xfs_attrlist_cursor __user *ucursor);
 
 extern struct dentry *
 xfs_handle_to_dentry(
diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 4e035aca6f7e..6093fa6db260 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -41,6 +41,22 @@
 
 #define __bf_shf(x) (__builtin_ffsll(x) - 1)
 
+#define __scalar_type_to_unsigned_cases(type)				\
+		unsigned type:	(unsigned type)0,			\
+		signed type:	(unsigned type)0
+
+#define __unsigned_scalar_typeof(x) typeof(				\
+		_Generic((x),						\
+			char:	(unsigned char)0,			\
+			__scalar_type_to_unsigned_cases(char),		\
+			__scalar_type_to_unsigned_cases(short),		\
+			__scalar_type_to_unsigned_cases(int),		\
+			__scalar_type_to_unsigned_cases(long),		\
+			__scalar_type_to_unsigned_cases(long long),	\
+			default: (x)))
+
+#define __bf_cast_unsigned(type, x)	((__unsigned_scalar_typeof(type))(x))
+
 #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
 	({								\
 		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
@@ -49,7 +65,8 @@
 		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
 				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
 				 _pfx "value too large for the field"); \
-		BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,		\
+		BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >	\
+				 __bf_cast_unsigned(_reg, ~0ull),	\
 				 _pfx "type of reg too small for mask"); \
 		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
 					      (1ULL << __bf_shf(_mask))); \
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e213acaa91ec..cbd719e5329a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -304,6 +304,41 @@ struct sk_buff_head {
 
 struct sk_buff;
 
+/* The reason of skb drop, which is used in kfree_skb_reason().
+ * en...maybe they should be splited by group?
+ *
+ * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
+ * used to translate the reason to string.
+ */
+enum skb_drop_reason {
+	SKB_DROP_REASON_NOT_SPECIFIED,	/* drop reason is not specified */
+	SKB_DROP_REASON_NO_SOCKET,	/* socket not found */
+	SKB_DROP_REASON_PKT_TOO_SMALL,	/* packet size is too small */
+	SKB_DROP_REASON_TCP_CSUM,	/* TCP checksum error */
+	SKB_DROP_REASON_SOCKET_FILTER,	/* dropped by socket filter */
+	SKB_DROP_REASON_UDP_CSUM,	/* UDP checksum error */
+	SKB_DROP_REASON_NETFILTER_DROP,	/* dropped by netfilter */
+	SKB_DROP_REASON_OTHERHOST,	/* packet don't belong to current
+					 * host (interface is in promisc
+					 * mode)
+					 */
+	SKB_DROP_REASON_IP_CSUM,	/* IP checksum error */
+	SKB_DROP_REASON_IP_INHDR,	/* there is something wrong with
+					 * IP header (see
+					 * IPSTATS_MIB_INHDRERRORS)
+					 */
+	SKB_DROP_REASON_IP_RPFILTER,	/* IP rpfilter validate failed.
+					 * see the document for rp_filter
+					 * in ip-sysctl.rst for more
+					 * information
+					 */
+	SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST, /* destination address of L2
+						  * is multicast, but L3 is
+						  * unicast.
+						  */
+	SKB_DROP_REASON_MAX,
+};
+
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
  * buffers which do not start on a page boundary.
@@ -1074,8 +1109,18 @@ static inline bool skb_unref(struct sk_buff *skb)
 	return true;
 }
 
+void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason);
+
+/**
+ *	kfree_skb - free an sk_buff with 'NOT_SPECIFIED' reason
+ *	@skb: buffer to free
+ */
+static inline void kfree_skb(struct sk_buff *skb)
+{
+	kfree_skb_reason(skb, SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 void skb_release_head_state(struct sk_buff *skb);
-void kfree_skb(struct sk_buff *skb);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 1fa2b69c6fc3..fa372b4c2313 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -38,9 +38,16 @@ struct ctl_table_header;
 struct ctl_dir;
 
 /* Keep the same order as in fs/proc/proc_sysctl.c */
-#define SYSCTL_ZERO	((void *)&sysctl_vals[0])
-#define SYSCTL_ONE	((void *)&sysctl_vals[1])
-#define SYSCTL_INT_MAX	((void *)&sysctl_vals[2])
+#define SYSCTL_NEG_ONE			((void *)&sysctl_vals[0])
+#define SYSCTL_ZERO			((void *)&sysctl_vals[1])
+#define SYSCTL_ONE			((void *)&sysctl_vals[2])
+#define SYSCTL_TWO			((void *)&sysctl_vals[3])
+#define SYSCTL_FOUR			((void *)&sysctl_vals[4])
+#define SYSCTL_ONE_HUNDRED		((void *)&sysctl_vals[5])
+#define SYSCTL_TWO_HUNDRED		((void *)&sysctl_vals[6])
+#define SYSCTL_ONE_THOUSAND		((void *)&sysctl_vals[7])
+#define SYSCTL_THREE_THOUSAND		((void *)&sysctl_vals[8])
+#define SYSCTL_INT_MAX			((void *)&sysctl_vals[9])
 
 extern const int sysctl_vals[];
 
diff --git a/include/linux/tty_flip.h b/include/linux/tty_flip.h
index 32284992b31a..1fb727b7b969 100644
--- a/include/linux/tty_flip.h
+++ b/include/linux/tty_flip.h
@@ -17,7 +17,6 @@ extern int tty_insert_flip_string_fixed_flag(struct tty_port *port,
 extern int tty_prepare_flip_string(struct tty_port *port,
 		unsigned char **chars, size_t size);
 extern void tty_flip_buffer_push(struct tty_port *port);
-void tty_schedule_flip(struct tty_port *port);
 int __tty_insert_flip_char(struct tty_port *port, unsigned char ch, char flag);
 
 static inline int tty_insert_flip_char(struct tty_port *port,
diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 3fecc4a411a1..355835639ae5 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -422,6 +422,71 @@ static inline struct sk_buff *bt_skb_send_alloc(struct sock *sk,
 	return NULL;
 }
 
+/* Shall not be called with lock_sock held */
+static inline struct sk_buff *bt_skb_sendmsg(struct sock *sk,
+					     struct msghdr *msg,
+					     size_t len, size_t mtu,
+					     size_t headroom, size_t tailroom)
+{
+	struct sk_buff *skb;
+	size_t size = min_t(size_t, len, mtu);
+	int err;
+
+	skb = bt_skb_send_alloc(sk, size + headroom + tailroom,
+				msg->msg_flags & MSG_DONTWAIT, &err);
+	if (!skb)
+		return ERR_PTR(err);
+
+	skb_reserve(skb, headroom);
+	skb_tailroom_reserve(skb, mtu, tailroom);
+
+	if (!copy_from_iter_full(skb_put(skb, size), size, &msg->msg_iter)) {
+		kfree_skb(skb);
+		return ERR_PTR(-EFAULT);
+	}
+
+	skb->priority = sk->sk_priority;
+
+	return skb;
+}
+
+/* Similar to bt_skb_sendmsg but can split the msg into multiple fragments
+ * accourding to the MTU.
+ */
+static inline struct sk_buff *bt_skb_sendmmsg(struct sock *sk,
+					      struct msghdr *msg,
+					      size_t len, size_t mtu,
+					      size_t headroom, size_t tailroom)
+{
+	struct sk_buff *skb, **frag;
+
+	skb = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
+	if (IS_ERR_OR_NULL(skb))
+		return skb;
+
+	len -= skb->len;
+	if (!len)
+		return skb;
+
+	/* Add remaining data over MTU as continuation fragments */
+	frag = &skb_shinfo(skb)->frag_list;
+	while (len) {
+		struct sk_buff *tmp;
+
+		tmp = bt_skb_sendmsg(sk, msg, len, mtu, headroom, tailroom);
+		if (IS_ERR(tmp)) {
+			return skb;
+		}
+
+		len -= tmp->len;
+
+		*frag = tmp;
+		frag = &(*frag)->next;
+	}
+
+	return skb;
+}
+
 int bt_to_errno(u16 code);
 
 void hci_sock_set_flag(struct sock *sk, int nr);
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 98e1ec1a14f0..749bb1e46087 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -207,7 +207,7 @@ static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 					int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_tcp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index d81b7f85819e..c307a547d2cb 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -107,7 +107,8 @@ static inline struct inet_request_sock *inet_rsk(const struct request_sock *sk)
 
 static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 {
-	if (!sk->sk_mark && sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept)
+	if (!sk->sk_mark &&
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fwmark_accept))
 		return skb->mark;
 
 	return sk->sk_mark;
@@ -116,14 +117,15 @@ static inline u32 inet_request_mark(const struct sock *sk, struct sk_buff *skb)
 static inline int inet_request_bound_dev_if(const struct sock *sk,
 					    struct sk_buff *skb)
 {
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!sk->sk_bound_dev_if && net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!bound_dev_if && READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept))
 		return l3mdev_master_ifindex_by_index(net, skb->skb_iif);
 #endif
 
-	return sk->sk_bound_dev_if;
+	return bound_dev_if;
 }
 
 static inline int inet_sk_bound_l3mdev(const struct sock *sk)
@@ -131,7 +133,7 @@ static inline int inet_sk_bound_l3mdev(const struct sock *sk)
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	struct net *net = sock_net(sk);
 
-	if (!net->ipv4.sysctl_tcp_l3mdev_accept)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept))
 		return l3mdev_master_ifindex_by_index(net,
 						      sk->sk_bound_dev_if);
 #endif
@@ -373,7 +375,7 @@ static inline bool inet_get_convert_csum(struct sock *sk)
 static inline bool inet_can_nonlocal_bind(struct net *net,
 					  struct inet_sock *inet)
 {
-	return net->ipv4.sysctl_ip_nonlocal_bind ||
+	return READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind) ||
 		inet->freebind || inet->transparent;
 }
 
diff --git a/include/net/ip.h b/include/net/ip.h
index a77a9e1c6c04..8462ced0c21e 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -352,7 +352,7 @@ static inline bool sysctl_dev_name_is_allowed(const char *name)
 
 static inline bool inet_port_requires_bind_service(struct net *net, unsigned short port)
 {
-	return port < net->ipv4.sysctl_ip_prot_sock;
+	return port < READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 }
 
 #else
@@ -379,7 +379,7 @@ void ipfrag_init(void);
 void ip_static_sysctl_init(void);
 
 #define IP4_REPLY_MARK(net, mark) \
-	((net)->ipv4.sysctl_fwmark_reflect ? (mark) : 0)
+	(READ_ONCE((net)->ipv4.sysctl_fwmark_reflect) ? (mark) : 0)
 
 static inline bool ip_is_fragment(const struct iphdr *iph)
 {
@@ -441,7 +441,7 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 	struct net *net = dev_net(dst->dev);
 	unsigned int mtu;
 
-	if (net->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding) {
 		mtu = rt->rt_pmtu;
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 6c5b2efc4f17..d60a10cfc382 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -74,7 +74,6 @@ struct netns_ipv4 {
 	struct sock		*mc_autojoin_sk;
 
 	struct inet_peer_base	*peers;
-	struct sock  * __percpu	*tcp_sk;
 	struct fqdir		*fqdir;
 
 	u8 sysctl_icmp_echo_ignore_all;
diff --git a/include/net/route.h b/include/net/route.h
index 2551f3f03b37..30610101ea14 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -360,7 +360,7 @@ static inline int ip4_dst_hoplimit(const struct dst_entry *dst)
 	struct net *net = dev_net(dst->dev);
 
 	if (hoplimit == 0)
-		hoplimit = net->ipv4.sysctl_ip_default_ttl;
+		hoplimit = READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	return hoplimit;
 }
 
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 3b97db2d438f..8ce8aafeef0f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1390,8 +1390,8 @@ static inline void tcp_slow_start_after_idle_check(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	s32 delta;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle || tp->packets_out ||
-	    ca_ops->cong_control)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) ||
+	    tp->packets_out || ca_ops->cong_control)
 		return;
 	delta = tcp_jiffies32 - tp->lsndtime;
 	if (delta > inet_csk(sk)->icsk_rto)
@@ -1469,21 +1469,24 @@ static inline int keepalive_intvl_when(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
 
-	return tp->keepalive_intvl ? : net->ipv4.sysctl_tcp_keepalive_intvl;
+	return tp->keepalive_intvl ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_intvl);
 }
 
 static inline int keepalive_time_when(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
 
-	return tp->keepalive_time ? : net->ipv4.sysctl_tcp_keepalive_time;
+	return tp->keepalive_time ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_time);
 }
 
 static inline int keepalive_probes(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
 
-	return tp->keepalive_probes ? : net->ipv4.sysctl_tcp_keepalive_probes;
+	return tp->keepalive_probes ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_keepalive_probes);
 }
 
 static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
@@ -1496,7 +1499,8 @@ static inline u32 keepalive_time_elapsed(const struct tcp_sock *tp)
 
 static inline int tcp_fin_time(const struct sock *sk)
 {
-	int fin_timeout = tcp_sk(sk)->linger2 ? : sock_net(sk)->ipv4.sysctl_tcp_fin_timeout;
+	int fin_timeout = tcp_sk(sk)->linger2 ? :
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fin_timeout);
 	const int rto = inet_csk(sk)->icsk_rto;
 
 	if (fin_timeout < (rto << 2) - (rto >> 1))
@@ -1990,7 +1994,7 @@ void __tcp_v4_send_check(struct sk_buff *skb, __be32 saddr, __be32 daddr);
 static inline u32 tcp_notsent_lowat(const struct tcp_sock *tp)
 {
 	struct net *net = sock_net((struct sock *)tp);
-	return tp->notsent_lowat ?: net->ipv4.sysctl_tcp_notsent_lowat;
+	return tp->notsent_lowat ?: READ_ONCE(net->ipv4.sysctl_tcp_notsent_lowat);
 }
 
 bool tcp_stream_memory_free(const struct sock *sk, int wake);
diff --git a/include/net/udp.h b/include/net/udp.h
index 909ecf447e0f..438b1b01a56c 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -262,7 +262,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 				       int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_udp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_udp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 9e92f22eb086..485a1d3034a4 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,29 +9,63 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
+#define TRACE_SKB_DROP_REASON					\
+	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
+	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
+	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
+	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
+	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
+	EM(SKB_DROP_REASON_NETFILTER_DROP, NETFILTER_DROP)	\
+	EM(SKB_DROP_REASON_OTHERHOST, OTHERHOST)		\
+	EM(SKB_DROP_REASON_IP_CSUM, IP_CSUM)			\
+	EM(SKB_DROP_REASON_IP_INHDR, IP_INHDR)			\
+	EM(SKB_DROP_REASON_IP_RPFILTER, IP_RPFILTER)		\
+	EM(SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST,		\
+	   UNICAST_IN_L2_MULTICAST)				\
+	EMe(SKB_DROP_REASON_MAX, MAX)
+
+#undef EM
+#undef EMe
+
+#define EM(a, b)	TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+TRACE_SKB_DROP_REASON
+
+#undef EM
+#undef EMe
+#define EM(a, b)	{ a, #b },
+#define EMe(a, b)	{ a, #b }
+
 /*
  * Tracepoint for free an sk_buff:
  */
 TRACE_EVENT(kfree_skb,
 
-	TP_PROTO(struct sk_buff *skb, void *location),
+	TP_PROTO(struct sk_buff *skb, void *location,
+		 enum skb_drop_reason reason),
 
-	TP_ARGS(skb, location),
+	TP_ARGS(skb, location, reason),
 
 	TP_STRUCT__entry(
-		__field(	void *,		skbaddr		)
-		__field(	void *,		location	)
-		__field(	unsigned short,	protocol	)
+		__field(void *,		skbaddr)
+		__field(void *,		location)
+		__field(unsigned short,	protocol)
+		__field(enum skb_drop_reason,	reason)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->location = location;
 		__entry->protocol = ntohs(skb->protocol);
+		__entry->reason = reason;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p",
-		__entry->skbaddr, __entry->protocol, __entry->location)
+	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
+		  __entry->skbaddr, __entry->protocol, __entry->location,
+		  __print_symbolic(__entry->reason,
+				   TRACE_SKB_DROP_REASON))
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 15946c11524e..4ce500eac2ef 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -66,11 +66,13 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
 {
 	u8 *ptr = NULL;
 
-	if (k >= SKF_NET_OFF)
+	if (k >= SKF_NET_OFF) {
 		ptr = skb_network_header(skb) + k - SKF_NET_OFF;
-	else if (k >= SKF_LL_OFF)
+	} else if (k >= SKF_LL_OFF) {
+		if (unlikely(!skb_mac_header_was_set(skb)))
+			return NULL;
 		ptr = skb_mac_header(skb) + k - SKF_LL_OFF;
-
+	}
 	if (ptr >= skb->head && ptr + size <= skb_tail_pointer(skb))
 		return ptr;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7e05d937560..c6c7a4d80573 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6355,10 +6355,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 
 		if (!atomic_inc_not_zero(&event->rb->mmap_count)) {
 			/*
-			 * Raced against perf_mmap_close() through
-			 * perf_event_set_output(). Try again, hope for better
-			 * luck.
+			 * Raced against perf_mmap_close(); remove the
+			 * event and try again.
 			 */
+			ring_buffer_attach(event, NULL);
 			mutex_unlock(&event->mmap_mutex);
 			goto again;
 		}
@@ -11892,14 +11892,25 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	goto out;
 }
 
+static void mutex_lock_double(struct mutex *a, struct mutex *b)
+{
+	if (b < a)
+		swap(a, b);
+
+	mutex_lock(a);
+	mutex_lock_nested(b, SINGLE_DEPTH_NESTING);
+}
+
 static int
 perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 {
 	struct perf_buffer *rb = NULL;
 	int ret = -EINVAL;
 
-	if (!output_event)
+	if (!output_event) {
+		mutex_lock(&event->mmap_mutex);
 		goto set;
+	}
 
 	/* don't allow circular references */
 	if (event == output_event)
@@ -11937,8 +11948,15 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	    event->pmu != output_event->pmu)
 		goto out;
 
+	/*
+	 * Hold both mmap_mutex to serialize against perf_mmap_close().  Since
+	 * output_event is already on rb->event_list, and the list iteration
+	 * restarts after every removal, it is guaranteed this new event is
+	 * observed *OR* if output_event is already removed, it's guaranteed we
+	 * observe !rb->mmap_count.
+	 */
+	mutex_lock_double(&event->mmap_mutex, &output_event->mmap_mutex);
 set:
-	mutex_lock(&event->mmap_mutex);
 	/* Can't redirect output if we've got an active mmap() */
 	if (atomic_read(&event->mmap_count))
 		goto unlock;
@@ -11948,6 +11966,12 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 		rb = ring_buffer_get(output_event);
 		if (!rb)
 			goto unlock;
+
+		/* did we race against perf_mmap_close() */
+		if (!atomic_read(&rb->mmap_count)) {
+			ring_buffer_put(rb);
+			goto unlock;
+		}
 	}
 
 	ring_buffer_attach(event, rb);
@@ -11955,20 +11979,13 @@ perf_event_set_output(struct perf_event *event, struct perf_event *output_event)
 	ret = 0;
 unlock:
 	mutex_unlock(&event->mmap_mutex);
+	if (output_event)
+		mutex_unlock(&output_event->mmap_mutex);
 
 out:
 	return ret;
 }
 
-static void mutex_lock_double(struct mutex *a, struct mutex *b)
-{
-	if (b < a)
-		swap(a, b);
-
-	mutex_lock(a);
-	mutex_lock_nested(b, SINGLE_DEPTH_NESTING);
-}
-
 static int perf_event_set_clock(struct perf_event *event, clockid_t clk_id)
 {
 	bool nmi_safe = false;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fffcb1aa77b7..ee673a205e22 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1561,7 +1561,10 @@ static void enqueue_task_dl(struct rq *rq, struct task_struct *p, int flags)
 		 * the throttle.
 		 */
 		p->dl.dl_throttled = 0;
-		BUG_ON(!is_dl_boosted(&p->dl) || flags != ENQUEUE_REPLENISH);
+		if (!(flags & ENQUEUE_REPLENISH))
+			printk_deferred_once("sched: DL de-boosted task PID %d: REPLENISH flag missing\n",
+					     task_pid_nr(p));
+
 		return;
 	}
 
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 25c18b2df684..23c08bf3db58 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -113,15 +113,9 @@
 static int sixty = 60;
 #endif
 
-static int __maybe_unused neg_one = -1;
-static int __maybe_unused two = 2;
-static int __maybe_unused four = 4;
 static unsigned long zero_ul;
 static unsigned long one_ul = 1;
 static unsigned long long_max = LONG_MAX;
-static int one_hundred = 100;
-static int two_hundred = 200;
-static int one_thousand = 1000;
 #ifdef CONFIG_PRINTK
 static int ten_thousand = 10000;
 #endif
@@ -1972,7 +1966,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &neg_one,
+		.extra1		= SYSCTL_NEG_ONE,
 		.extra2		= SYSCTL_ONE,
 	},
 #endif
@@ -2314,7 +2308,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax_sysadmin,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 #endif
 	{
@@ -2574,7 +2568,7 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &neg_one,
+		.extra1		= SYSCTL_NEG_ONE,
 	},
 #endif
 #ifdef CONFIG_RT_MUTEXES
@@ -2636,7 +2630,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_cpu_time_max_percent_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
+		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 	{
 		.procname	= "perf_event_max_stack",
@@ -2654,7 +2648,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_event_max_stack_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_thousand,
+		.extra2		= SYSCTL_ONE_THOUSAND,
 	},
 #endif
 	{
@@ -2685,7 +2679,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= bpf_unpriv_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "bpf_stats_enabled",
@@ -2739,7 +2733,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= overcommit_policy_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "panic_on_oom",
@@ -2748,7 +2742,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "oom_kill_allocating_task",
@@ -2793,7 +2787,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= dirty_background_ratio_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
+		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 	{
 		.procname	= "dirty_background_bytes",
@@ -2810,7 +2804,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= dirty_ratio_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
+		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 	{
 		.procname	= "dirty_bytes",
@@ -2850,7 +2844,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two_hundred,
+		.extra2		= SYSCTL_TWO_HUNDRED,
 	},
 #ifdef CONFIG_NUMA
 	{
@@ -2909,7 +2903,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0200,
 		.proc_handler	= drop_caches_sysctl_handler,
 		.extra1		= SYSCTL_ONE,
-		.extra2		= &four,
+		.extra2		= SYSCTL_FOUR,
 	},
 #ifdef CONFIG_COMPACTION
 	{
@@ -2926,7 +2920,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= compaction_proactiveness_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
+		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 	{
 		.procname	= "extfrag_threshold",
@@ -2971,7 +2965,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= watermark_scale_factor_sysctl_handler,
 		.extra1		= SYSCTL_ONE,
-		.extra2		= &one_thousand,
+		.extra2		= SYSCTL_THREE_THOUSAND,
 	},
 	{
 		.procname	= "percpu_pagelist_high_fraction",
@@ -3050,7 +3044,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sysctl_min_unmapped_ratio_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
+		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 	{
 		.procname	= "min_slab_ratio",
@@ -3059,7 +3053,7 @@ static struct ctl_table vm_table[] = {
 		.mode		= 0644,
 		.proc_handler	= sysctl_min_slab_ratio_sysctl_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &one_hundred,
+		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 #endif
 #ifdef CONFIG_SMP
@@ -3349,7 +3343,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "protected_regular",
@@ -3358,7 +3352,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0600,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "suid_dumpable",
@@ -3367,7 +3361,7 @@ static struct ctl_table fs_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax_coredump,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &two,
+		.extra2		= SYSCTL_TWO,
 	},
 #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
 	{
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 6de5d4d63165..bedc5caceec7 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_seq.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
+obj-$(CONFIG_TRACING) += 	pid_list.o
 obj-$(CONFIG_TRACING_MAP) += tracing_map.o
 obj-$(CONFIG_PREEMPTIRQ_DELAY_TEST) += preemptirq_delay_test.o
 obj-$(CONFIG_SYNTH_EVENT_GEN_TEST) += synth_event_gen_test.o
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 53a1af21d25c..e215a9c96971 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -7184,10 +7184,10 @@ static void clear_ftrace_pids(struct trace_array *tr, int type)
 	synchronize_rcu();
 
 	if ((type & TRACE_PIDS) && pid_list)
-		trace_free_pid_list(pid_list);
+		trace_pid_list_free(pid_list);
 
 	if ((type & TRACE_NO_PIDS) && no_pid_list)
-		trace_free_pid_list(no_pid_list);
+		trace_pid_list_free(no_pid_list);
 }
 
 void ftrace_clear_pids(struct trace_array *tr)
@@ -7428,7 +7428,7 @@ pid_write(struct file *filp, const char __user *ubuf,
 
 	if (filtered_pids) {
 		synchronize_rcu();
-		trace_free_pid_list(filtered_pids);
+		trace_pid_list_free(filtered_pids);
 	} else if (pid_list && !other_pids) {
 		/* Register a probe to set whether to ignore the tracing of a task */
 		register_trace_sched_switch(ftrace_filter_pid_sched_switch_probe, tr);
diff --git a/kernel/trace/pid_list.c b/kernel/trace/pid_list.c
new file mode 100644
index 000000000000..4483ef70b562
--- /dev/null
+++ b/kernel/trace/pid_list.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 VMware Inc, Steven Rostedt <rostedt@goodmis.org>
+ */
+#include <linux/vmalloc.h>
+#include <linux/slab.h>
+#include "trace.h"
+
+/**
+ * trace_pid_list_is_set - test if the pid is set in the list
+ * @pid_list: The pid list to test
+ * @pid: The pid to to see if set in the list.
+ *
+ * Tests if @pid is is set in the @pid_list. This is usually called
+ * from the scheduler when a task is scheduled. Its pid is checked
+ * if it should be traced or not.
+ *
+ * Return true if the pid is in the list, false otherwise.
+ */
+bool trace_pid_list_is_set(struct trace_pid_list *pid_list, unsigned int pid)
+{
+	/*
+	 * If pid_max changed after filtered_pids was created, we
+	 * by default ignore all pids greater than the previous pid_max.
+	 */
+	if (pid >= pid_list->pid_max)
+		return false;
+
+	return test_bit(pid, pid_list->pids);
+}
+
+/**
+ * trace_pid_list_set - add a pid to the list
+ * @pid_list: The pid list to add the @pid to.
+ * @pid: The pid to add.
+ *
+ * Adds @pid to @pid_list. This is usually done explicitly by a user
+ * adding a task to be traced, or indirectly by the fork function
+ * when children should be traced and a task's pid is in the list.
+ *
+ * Return 0 on success, negative otherwise.
+ */
+int trace_pid_list_set(struct trace_pid_list *pid_list, unsigned int pid)
+{
+	/* Sorry, but we don't support pid_max changing after setting */
+	if (pid >= pid_list->pid_max)
+		return -EINVAL;
+
+	set_bit(pid, pid_list->pids);
+
+	return 0;
+}
+
+/**
+ * trace_pid_list_clear - remove a pid from the list
+ * @pid_list: The pid list to remove the @pid from.
+ * @pid: The pid to remove.
+ *
+ * Removes @pid from @pid_list. This is usually done explicitly by a user
+ * removing tasks from tracing, or indirectly by the exit function
+ * when a task that is set to be traced exits.
+ *
+ * Return 0 on success, negative otherwise.
+ */
+int trace_pid_list_clear(struct trace_pid_list *pid_list, unsigned int pid)
+{
+	/* Sorry, but we don't support pid_max changing after setting */
+	if (pid >= pid_list->pid_max)
+		return -EINVAL;
+
+	clear_bit(pid, pid_list->pids);
+
+	return 0;
+}
+
+/**
+ * trace_pid_list_next - return the next pid in the list
+ * @pid_list: The pid list to examine.
+ * @pid: The pid to start from
+ * @next: The pointer to place the pid that is set starting from @pid.
+ *
+ * Looks for the next consecutive pid that is in @pid_list starting
+ * at the pid specified by @pid. If one is set (including @pid), then
+ * that pid is placed into @next.
+ *
+ * Return 0 when a pid is found, -1 if there are no more pids included.
+ */
+int trace_pid_list_next(struct trace_pid_list *pid_list, unsigned int pid,
+			unsigned int *next)
+{
+	pid = find_next_bit(pid_list->pids, pid_list->pid_max, pid);
+
+	if (pid < pid_list->pid_max) {
+		*next = pid;
+		return 0;
+	}
+	return -1;
+}
+
+/**
+ * trace_pid_list_first - return the first pid in the list
+ * @pid_list: The pid list to examine.
+ * @pid: The pointer to place the pid first found pid that is set.
+ *
+ * Looks for the first pid that is set in @pid_list, and places it
+ * into @pid if found.
+ *
+ * Return 0 when a pid is found, -1 if there are no pids set.
+ */
+int trace_pid_list_first(struct trace_pid_list *pid_list, unsigned int *pid)
+{
+	unsigned int first;
+
+	first = find_first_bit(pid_list->pids, pid_list->pid_max);
+
+	if (first < pid_list->pid_max) {
+		*pid = first;
+		return 0;
+	}
+	return -1;
+}
+
+/**
+ * trace_pid_list_alloc - create a new pid_list
+ *
+ * Allocates a new pid_list to store pids into.
+ *
+ * Returns the pid_list on success, NULL otherwise.
+ */
+struct trace_pid_list *trace_pid_list_alloc(void)
+{
+	struct trace_pid_list *pid_list;
+
+	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
+	if (!pid_list)
+		return NULL;
+
+	pid_list->pid_max = READ_ONCE(pid_max);
+
+	pid_list->pids = vzalloc((pid_list->pid_max + 7) >> 3);
+	if (!pid_list->pids) {
+		kfree(pid_list);
+		return NULL;
+	}
+	return pid_list;
+}
+
+/**
+ * trace_pid_list_free - Frees an allocated pid_list.
+ *
+ * Frees the memory for a pid_list that was allocated.
+ */
+void trace_pid_list_free(struct trace_pid_list *pid_list)
+{
+	if (!pid_list)
+		return;
+
+	vfree(pid_list->pids);
+	kfree(pid_list);
+}
diff --git a/kernel/trace/pid_list.h b/kernel/trace/pid_list.h
new file mode 100644
index 000000000000..80d0ecfe1536
--- /dev/null
+++ b/kernel/trace/pid_list.h
@@ -0,0 +1,13 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Do not include this file directly. */
+
+#ifndef _TRACE_INTERNAL_PID_LIST_H
+#define _TRACE_INTERNAL_PID_LIST_H
+
+struct trace_pid_list {
+	int			pid_max;
+	unsigned long		*pids;
+};
+
+#endif /* _TRACE_INTERNAL_PID_LIST_H */
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index f752f2574630..d93f9c59f50e 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -516,12 +516,6 @@ int call_filter_check_discard(struct trace_event_call *call, void *rec,
 	return 0;
 }
 
-void trace_free_pid_list(struct trace_pid_list *pid_list)
-{
-	vfree(pid_list->pids);
-	kfree(pid_list);
-}
-
 /**
  * trace_find_filtered_pid - check if a pid exists in a filtered_pid list
  * @filtered_pids: The list of pids to check
@@ -532,14 +526,7 @@ void trace_free_pid_list(struct trace_pid_list *pid_list)
 bool
 trace_find_filtered_pid(struct trace_pid_list *filtered_pids, pid_t search_pid)
 {
-	/*
-	 * If pid_max changed after filtered_pids was created, we
-	 * by default ignore all pids greater than the previous pid_max.
-	 */
-	if (search_pid >= filtered_pids->pid_max)
-		return false;
-
-	return test_bit(search_pid, filtered_pids->pids);
+	return trace_pid_list_is_set(filtered_pids, search_pid);
 }
 
 /**
@@ -596,15 +583,11 @@ void trace_filter_add_remove_task(struct trace_pid_list *pid_list,
 			return;
 	}
 
-	/* Sorry, but we don't support pid_max changing after setting */
-	if (task->pid >= pid_list->pid_max)
-		return;
-
 	/* "self" is set for forks, and NULL for exits */
 	if (self)
-		set_bit(task->pid, pid_list->pids);
+		trace_pid_list_set(pid_list, task->pid);
 	else
-		clear_bit(task->pid, pid_list->pids);
+		trace_pid_list_clear(pid_list, task->pid);
 }
 
 /**
@@ -621,18 +604,19 @@ void trace_filter_add_remove_task(struct trace_pid_list *pid_list,
  */
 void *trace_pid_next(struct trace_pid_list *pid_list, void *v, loff_t *pos)
 {
-	unsigned long pid = (unsigned long)v;
+	long pid = (unsigned long)v;
+	unsigned int next;
 
 	(*pos)++;
 
 	/* pid already is +1 of the actual previous bit */
-	pid = find_next_bit(pid_list->pids, pid_list->pid_max, pid);
+	if (trace_pid_list_next(pid_list, pid, &next) < 0)
+		return NULL;
 
-	/* Return pid + 1 to allow zero to be represented */
-	if (pid < pid_list->pid_max)
-		return (void *)(pid + 1);
+	pid = next;
 
-	return NULL;
+	/* Return pid + 1 to allow zero to be represented */
+	return (void *)(pid + 1);
 }
 
 /**
@@ -649,12 +633,14 @@ void *trace_pid_next(struct trace_pid_list *pid_list, void *v, loff_t *pos)
 void *trace_pid_start(struct trace_pid_list *pid_list, loff_t *pos)
 {
 	unsigned long pid;
+	unsigned int first;
 	loff_t l = 0;
 
-	pid = find_first_bit(pid_list->pids, pid_list->pid_max);
-	if (pid >= pid_list->pid_max)
+	if (trace_pid_list_first(pid_list, &first) < 0)
 		return NULL;
 
+	pid = first;
+
 	/* Return pid + 1 so that zero can be the exit value */
 	for (pid++; pid && l < *pos;
 	     pid = (unsigned long)trace_pid_next(pid_list, (void *)pid, &l))
@@ -690,7 +676,7 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	unsigned long val;
 	int nr_pids = 0;
 	ssize_t read = 0;
-	ssize_t ret = 0;
+	ssize_t ret;
 	loff_t pos;
 	pid_t pid;
 
@@ -703,55 +689,48 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	 * the user. If the operation fails, then the current list is
 	 * not modified.
 	 */
-	pid_list = kmalloc(sizeof(*pid_list), GFP_KERNEL);
+	pid_list = trace_pid_list_alloc();
 	if (!pid_list) {
 		trace_parser_put(&parser);
 		return -ENOMEM;
 	}
 
-	pid_list->pid_max = READ_ONCE(pid_max);
-
-	/* Only truncating will shrink pid_max */
-	if (filtered_pids && filtered_pids->pid_max > pid_list->pid_max)
-		pid_list->pid_max = filtered_pids->pid_max;
-
-	pid_list->pids = vzalloc((pid_list->pid_max + 7) >> 3);
-	if (!pid_list->pids) {
-		trace_parser_put(&parser);
-		kfree(pid_list);
-		return -ENOMEM;
-	}
-
 	if (filtered_pids) {
 		/* copy the current bits to the new max */
-		for_each_set_bit(pid, filtered_pids->pids,
-				 filtered_pids->pid_max) {
-			set_bit(pid, pid_list->pids);
+		ret = trace_pid_list_first(filtered_pids, &pid);
+		while (!ret) {
+			trace_pid_list_set(pid_list, pid);
+			ret = trace_pid_list_next(filtered_pids, pid + 1, &pid);
 			nr_pids++;
 		}
 	}
 
+	ret = 0;
 	while (cnt > 0) {
 
 		pos = 0;
 
 		ret = trace_get_user(&parser, ubuf, cnt, &pos);
-		if (ret < 0 || !trace_parser_loaded(&parser))
+		if (ret < 0)
 			break;
 
 		read += ret;
 		ubuf += ret;
 		cnt -= ret;
 
+		if (!trace_parser_loaded(&parser))
+			break;
+
 		ret = -EINVAL;
 		if (kstrtoul(parser.buffer, 0, &val))
 			break;
-		if (val >= pid_list->pid_max)
-			break;
 
 		pid = (pid_t)val;
 
-		set_bit(pid, pid_list->pids);
+		if (trace_pid_list_set(pid_list, pid) < 0) {
+			ret = -1;
+			break;
+		}
 		nr_pids++;
 
 		trace_parser_clear(&parser);
@@ -760,14 +739,13 @@ int trace_pid_write(struct trace_pid_list *filtered_pids,
 	trace_parser_put(&parser);
 
 	if (ret < 0) {
-		trace_free_pid_list(pid_list);
+		trace_pid_list_free(pid_list);
 		return ret;
 	}
 
 	if (!nr_pids) {
 		/* Cleared the list of pids */
-		trace_free_pid_list(pid_list);
-		read = ret;
+		trace_pid_list_free(pid_list);
 		pid_list = NULL;
 	}
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 421374c304fc..d6763366a320 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,8 @@
 #include <linux/ctype.h>
 #include <linux/once_lite.h>
 
+#include "pid_list.h"
+
 #ifdef CONFIG_FTRACE_SYSCALLS
 #include <asm/unistd.h>		/* For NR_SYSCALLS	     */
 #include <asm/syscall.h>	/* some archs define it here */
@@ -191,10 +193,14 @@ struct trace_options {
 	struct trace_option_dentry	*topts;
 };
 
-struct trace_pid_list {
-	int				pid_max;
-	unsigned long			*pids;
-};
+struct trace_pid_list *trace_pid_list_alloc(void);
+void trace_pid_list_free(struct trace_pid_list *pid_list);
+bool trace_pid_list_is_set(struct trace_pid_list *pid_list, unsigned int pid);
+int trace_pid_list_set(struct trace_pid_list *pid_list, unsigned int pid);
+int trace_pid_list_clear(struct trace_pid_list *pid_list, unsigned int pid);
+int trace_pid_list_first(struct trace_pid_list *pid_list, unsigned int *pid);
+int trace_pid_list_next(struct trace_pid_list *pid_list, unsigned int pid,
+			unsigned int *next);
 
 enum {
 	TRACE_PIDS		= BIT(0),
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c072e8b9849c..c4f654efb77a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -407,7 +407,14 @@ static void test_event_printk(struct trace_event_call *call)
 				a = strchr(fmt + i, '&');
 				if ((a && (a < r)) || test_field(r, call))
 					dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_dynamic_array(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
+			} else if ((r = strstr(fmt + i, "__get_sockaddr(")) &&
+				   (!c || r < c)) {
+				dereference_flags &= ~(1ULL << arg);
 			}
+
 		next_arg:
 			i--;
 			arg++;
@@ -893,10 +900,10 @@ static void __ftrace_clear_event_pids(struct trace_array *tr, int type)
 	tracepoint_synchronize_unregister();
 
 	if ((type & TRACE_PIDS) && pid_list)
-		trace_free_pid_list(pid_list);
+		trace_pid_list_free(pid_list);
 
 	if ((type & TRACE_NO_PIDS) && no_pid_list)
-		trace_free_pid_list(no_pid_list);
+		trace_pid_list_free(no_pid_list);
 }
 
 static void ftrace_clear_event_pids(struct trace_array *tr, int type)
@@ -1975,7 +1982,7 @@ event_pid_write(struct file *filp, const char __user *ubuf,
 
 	if (filtered_pids) {
 		tracepoint_synchronize_unregister();
-		trace_free_pid_list(filtered_pids);
+		trace_pid_list_free(filtered_pids);
 	} else if (pid_list && !other_pids) {
 		register_pid_events(tr);
 	}
diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index b1ae7c9c3b47..debebcd2664e 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -34,6 +34,27 @@ MODULE_LICENSE("GPL");
 #define WATCH_QUEUE_NOTE_SIZE 128
 #define WATCH_QUEUE_NOTES_PER_PAGE (PAGE_SIZE / WATCH_QUEUE_NOTE_SIZE)
 
+/*
+ * This must be called under the RCU read-lock, which makes
+ * sure that the wqueue still exists. It can then take the lock,
+ * and check that the wqueue hasn't been destroyed, which in
+ * turn makes sure that the notification pipe still exists.
+ */
+static inline bool lock_wqueue(struct watch_queue *wqueue)
+{
+	spin_lock_bh(&wqueue->lock);
+	if (unlikely(wqueue->defunct)) {
+		spin_unlock_bh(&wqueue->lock);
+		return false;
+	}
+	return true;
+}
+
+static inline void unlock_wqueue(struct watch_queue *wqueue)
+{
+	spin_unlock_bh(&wqueue->lock);
+}
+
 static void watch_queue_pipe_buf_release(struct pipe_inode_info *pipe,
 					 struct pipe_buffer *buf)
 {
@@ -69,6 +90,10 @@ static const struct pipe_buf_operations watch_queue_pipe_buf_ops = {
 
 /*
  * Post a notification to a watch queue.
+ *
+ * Must be called with the RCU lock for reading, and the
+ * watch_queue lock held, which guarantees that the pipe
+ * hasn't been released.
  */
 static bool post_one_notification(struct watch_queue *wqueue,
 				  struct watch_notification *n)
@@ -85,9 +110,6 @@ static bool post_one_notification(struct watch_queue *wqueue,
 
 	spin_lock_irq(&pipe->rd_wait.lock);
 
-	if (wqueue->defunct)
-		goto out;
-
 	mask = pipe->ring_size - 1;
 	head = pipe->head;
 	tail = pipe->tail;
@@ -203,7 +225,10 @@ void __post_watch_notification(struct watch_list *wlist,
 		if (security_post_notification(watch->cred, cred, n) < 0)
 			continue;
 
-		post_one_notification(wqueue, n);
+		if (lock_wqueue(wqueue)) {
+			post_one_notification(wqueue, n);
+			unlock_wqueue(wqueue);
+		}
 	}
 
 	rcu_read_unlock();
@@ -465,11 +490,12 @@ int add_watch_to_object(struct watch *watch, struct watch_list *wlist)
 		return -EAGAIN;
 	}
 
-	spin_lock_bh(&wqueue->lock);
-	kref_get(&wqueue->usage);
-	kref_get(&watch->usage);
-	hlist_add_head(&watch->queue_node, &wqueue->watches);
-	spin_unlock_bh(&wqueue->lock);
+	if (lock_wqueue(wqueue)) {
+		kref_get(&wqueue->usage);
+		kref_get(&watch->usage);
+		hlist_add_head(&watch->queue_node, &wqueue->watches);
+		unlock_wqueue(wqueue);
+	}
 
 	hlist_add_head(&watch->list_node, &wlist->watchers);
 	return 0;
@@ -523,20 +549,15 @@ int remove_watch_from_object(struct watch_list *wlist, struct watch_queue *wq,
 
 	wqueue = rcu_dereference(watch->queue);
 
-	/* We don't need the watch list lock for the next bit as RCU is
-	 * protecting *wqueue from deallocation.
-	 */
-	if (wqueue) {
+	if (lock_wqueue(wqueue)) {
 		post_one_notification(wqueue, &n.watch);
 
-		spin_lock_bh(&wqueue->lock);
-
 		if (!hlist_unhashed(&watch->queue_node)) {
 			hlist_del_init_rcu(&watch->queue_node);
 			put_watch(watch);
 		}
 
-		spin_unlock_bh(&wqueue->lock);
+		unlock_wqueue(wqueue);
 	}
 
 	if (wlist->release_watch) {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e75872035c76..9db0158155e1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -347,7 +347,7 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
  */
 static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
 {
-	if (!pol)
+	if (!pol || pol->mode == MPOL_LOCAL)
 		return;
 	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 11f6ef657d82..17687848daec 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -443,7 +443,7 @@ static void batadv_bla_send_claim(struct batadv_priv *bat_priv, u8 *mac,
 	batadv_add_counter(bat_priv, BATADV_CNT_RX_BYTES,
 			   skb->len + ETH_HLEN);
 
-	netif_rx(skb);
+	netif_rx_any_context(skb);
 out:
 	batadv_hardif_put(primary_if);
 }
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index f2bacb464ccf..7324764384b6 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -549,22 +549,58 @@ struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel)
 	return dlc;
 }
 
+static int rfcomm_dlc_send_frag(struct rfcomm_dlc *d, struct sk_buff *frag)
+{
+	int len = frag->len;
+
+	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+
+	if (len > d->mtu)
+		return -EINVAL;
+
+	rfcomm_make_uih(frag, d->addr);
+	__skb_queue_tail(&d->tx_queue, frag);
+
+	return len;
+}
+
 int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
-	int len = skb->len;
+	unsigned long flags;
+	struct sk_buff *frag, *next;
+	int len;
 
 	if (d->state != BT_CONNECTED)
 		return -ENOTCONN;
 
-	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
+	frag = skb_shinfo(skb)->frag_list;
+	skb_shinfo(skb)->frag_list = NULL;
 
-	if (len > d->mtu)
-		return -EINVAL;
+	/* Queue all fragments atomically. */
+	spin_lock_irqsave(&d->tx_queue.lock, flags);
 
-	rfcomm_make_uih(skb, d->addr);
-	skb_queue_tail(&d->tx_queue, skb);
+	len = rfcomm_dlc_send_frag(d, skb);
+	if (len < 0 || !frag)
+		goto unlock;
+
+	for (; frag; frag = next) {
+		int ret;
+
+		next = frag->next;
+
+		ret = rfcomm_dlc_send_frag(d, frag);
+		if (ret < 0) {
+			kfree_skb(frag);
+			goto unlock;
+		}
+
+		len += ret;
+	}
+
+unlock:
+	spin_unlock_irqrestore(&d->tx_queue.lock, flags);
 
-	if (!test_bit(RFCOMM_TX_THROTTLED, &d->flags))
+	if (len > 0 && !test_bit(RFCOMM_TX_THROTTLED, &d->flags))
 		rfcomm_schedule();
 	return len;
 }
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 2c95bb58f901..4bf4ea6cbb5e 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -575,46 +575,20 @@ static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	lock_sock(sk);
 
 	sent = bt_sock_wait_ready(sk, msg->msg_flags);
-	if (sent)
-		goto done;
-
-	while (len) {
-		size_t size = min_t(size_t, len, d->mtu);
-		int err;
-
-		skb = sock_alloc_send_skb(sk, size + RFCOMM_SKB_RESERVE,
-				msg->msg_flags & MSG_DONTWAIT, &err);
-		if (!skb) {
-			if (sent == 0)
-				sent = err;
-			break;
-		}
-		skb_reserve(skb, RFCOMM_SKB_HEAD_RESERVE);
-
-		err = memcpy_from_msg(skb_put(skb, size), msg, size);
-		if (err) {
-			kfree_skb(skb);
-			if (sent == 0)
-				sent = err;
-			break;
-		}
 
-		skb->priority = sk->sk_priority;
+	release_sock(sk);
 
-		err = rfcomm_dlc_send(d, skb);
-		if (err < 0) {
-			kfree_skb(skb);
-			if (sent == 0)
-				sent = err;
-			break;
-		}
+	if (sent)
+		return sent;
 
-		sent += size;
-		len  -= size;
-	}
+	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
+			      RFCOMM_SKB_TAIL_RESERVE);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
 
-done:
-	release_sock(sk);
+	sent = rfcomm_dlc_send(d, skb);
+	if (sent < 0)
+		kfree_skb(skb);
 
 	return sent;
 }
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index c7b43c75677f..9a8814d4565a 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -280,12 +280,10 @@ static int sco_connect(struct hci_dev *hdev, struct sock *sk)
 	return err;
 }
 
-static int sco_send_frame(struct sock *sk, void *buf, int len,
-			  unsigned int msg_flags)
+static int sco_send_frame(struct sock *sk, struct sk_buff *skb)
 {
 	struct sco_conn *conn = sco_pi(sk)->conn;
-	struct sk_buff *skb;
-	int err;
+	int len = skb->len;
 
 	/* Check outgoing MTU */
 	if (len > conn->mtu)
@@ -293,11 +291,6 @@ static int sco_send_frame(struct sock *sk, void *buf, int len,
 
 	BT_DBG("sk %p len %d", sk, len);
 
-	skb = bt_skb_send_alloc(sk, len, msg_flags & MSG_DONTWAIT, &err);
-	if (!skb)
-		return err;
-
-	memcpy(skb_put(skb, len), buf, len);
 	hci_send_sco(conn->hcon, skb);
 
 	return len;
@@ -727,7 +720,7 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len)
 {
 	struct sock *sk = sock->sk;
-	void *buf;
+	struct sk_buff *skb;
 	int err;
 
 	BT_DBG("sock %p, sk %p", sock, sk);
@@ -739,24 +732,21 @@ static int sco_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (msg->msg_flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-
-	if (memcpy_from_msg(buf, msg, len)) {
-		kfree(buf);
-		return -EFAULT;
-	}
+	skb = bt_skb_sendmsg(sk, msg, len, len, 0, 0);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
 
 	lock_sock(sk);
 
 	if (sk->sk_state == BT_CONNECTED)
-		err = sco_send_frame(sk, buf, len, msg->msg_flags);
+		err = sco_send_frame(sk, skb);
 	else
 		err = -ENOTCONN;
 
 	release_sock(sk);
-	kfree(buf);
+
+	if (err < 0)
+		kfree_skb(skb);
 	return err;
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 6111506a4105..12b1811cb488 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5005,7 +5005,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
 				trace_consume_skb(skb);
 			else
-				trace_kfree_skb(skb, net_tx_action);
+				trace_kfree_skb(skb, net_tx_action,
+						SKB_DROP_REASON_NOT_SPECIFIED);
 
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 				__kfree_skb(skb);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 1d99b731e5b2..78202141930f 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -110,7 +110,8 @@ static u32 net_dm_queue_len = 1000;
 
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
-				void *location);
+				void *location,
+				enum skb_drop_reason reason);
 	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
 				int work, int budget);
 	void (*work_item_func)(struct work_struct *work);
@@ -262,7 +263,9 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
-static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
+static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
+				void *location,
+				enum skb_drop_reason reason)
 {
 	trace_drop_common(skb, location);
 }
@@ -494,7 +497,8 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 
 static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 					      struct sk_buff *skb,
-					      void *location)
+					      void *location,
+					      enum skb_drop_reason reason)
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
diff --git a/net/core/filter.c b/net/core/filter.c
index 8b2bc855714b..ac64395611ae 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6734,7 +6734,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
 		return -EINVAL;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
 		return -EINVAL;
 
 	if (!th->ack || th->rst || th->syn)
@@ -6809,7 +6809,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
 		return -EINVAL;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
 		return -ENOENT;
 
 	if (!th->syn || th->ack || th->fin || th->rst)
diff --git a/net/core/secure_seq.c b/net/core/secure_seq.c
index 7131cd1fb2ad..189eea1372d5 100644
--- a/net/core/secure_seq.c
+++ b/net/core/secure_seq.c
@@ -64,7 +64,7 @@ u32 secure_tcpv6_ts_off(const struct net *net,
 		.daddr = *(struct in6_addr *)daddr,
 	};
 
-	if (net->ipv4.sysctl_tcp_timestamps != 1)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
 		return 0;
 
 	ts_secret_init();
@@ -120,7 +120,7 @@ EXPORT_SYMBOL(secure_ipv6_port_ephemeral);
 #ifdef CONFIG_INET
 u32 secure_tcp_ts_off(const struct net *net, __be32 saddr, __be32 daddr)
 {
-	if (net->ipv4.sysctl_tcp_timestamps != 1)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_timestamps) != 1)
 		return 0;
 
 	ts_secret_init();
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 7ef0f5a8ab03..5ebef94e14dc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -759,21 +759,23 @@ void __kfree_skb(struct sk_buff *skb)
 EXPORT_SYMBOL(__kfree_skb);
 
 /**
- *	kfree_skb - free an sk_buff
+ *	kfree_skb_reason - free an sk_buff with special reason
  *	@skb: buffer to free
+ *	@reason: reason why this skb is dropped
  *
  *	Drop a reference to the buffer and free it if the usage count has
- *	hit zero.
+ *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
+ *	tracepoint.
  */
-void kfree_skb(struct sk_buff *skb)
+void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	if (!skb_unref(skb))
 		return;
 
-	trace_kfree_skb(skb, __builtin_return_address(0));
+	trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
-EXPORT_SYMBOL(kfree_skb);
+EXPORT_SYMBOL(kfree_skb_reason);
 
 void kfree_skb_list(struct sk_buff *segs)
 {
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 3f00a28fe762..5daa1fa54249 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -387,7 +387,7 @@ void reuseport_stop_listen_sock(struct sock *sk)
 		prog = rcu_dereference_protected(reuse->prog,
 						 lockdep_is_held(&reuseport_lock));
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req ||
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_migrate_req) ||
 		    (prog && prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE)) {
 			/* Migration capable, move sk from the listening section
 			 * to the closed section.
@@ -545,7 +545,7 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	hash = migrating_sk->sk_hash;
 	prog = rcu_dereference(reuse->prog);
 	if (!prog || prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE) {
-		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req)
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_migrate_req))
 			goto select_by_hash;
 		goto failure;
 	}
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 44f21278003d..e4b2ced66261 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -220,7 +220,7 @@ int inet_listen(struct socket *sock, int backlog)
 		 * because the socket was in TCP_LISTEN state previously but
 		 * was shutdown() rather than close().
 		 */
-		tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
+		tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
 		if ((tcp_fastopen & TFO_SERVER_WO_SOCKOPT1) &&
 		    (tcp_fastopen & TFO_SERVER_ENABLE) &&
 		    !inet_csk(sk)->icsk_accept_queue.fastopenq.max_qlen) {
@@ -338,7 +338,7 @@ static int inet_create(struct net *net, struct socket *sock, int protocol,
 			inet->hdrincl = 1;
 	}
 
-	if (net->ipv4.sysctl_ip_no_pmtu_disc)
+	if (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc))
 		inet->pmtudisc = IP_PMTUDISC_DONT;
 	else
 		inet->pmtudisc = IP_PMTUDISC_WANT;
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 674694d8ac61..55de6fa83dea 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -2233,7 +2233,7 @@ void fib_select_multipath(struct fib_result *res, int hash)
 	}
 
 	change_nexthops(fi) {
-		if (net->ipv4.sysctl_fib_multipath_use_neigh) {
+		if (READ_ONCE(net->ipv4.sysctl_fib_multipath_use_neigh)) {
 			if (!fib_good_nh(nexthop_nh))
 				continue;
 			if (!first) {
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index a5cc89506c1e..609c4ff7edc6 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -887,7 +887,7 @@ static bool icmp_unreach(struct sk_buff *skb)
 			 * values please see
 			 * Documentation/networking/ip-sysctl.rst
 			 */
-			switch (net->ipv4.sysctl_ip_no_pmtu_disc) {
+			switch (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc)) {
 			default:
 				net_dbg_ratelimited("%pI4: fragmentation needed and DF set\n",
 						    &iph->daddr);
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 930f6c41f519..9f4674244aff 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -467,7 +467,8 @@ static struct sk_buff *add_grec(struct sk_buff *skb, struct ip_mc_list *pmc,
 
 	if (pmc->multiaddr == IGMP_ALL_HOSTS)
 		return skb;
-	if (ipv4_is_local_multicast(pmc->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(pmc->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return skb;
 
 	mtu = READ_ONCE(dev->mtu);
@@ -593,7 +594,7 @@ static int igmpv3_send_report(struct in_device *in_dev, struct ip_mc_list *pmc)
 			if (pmc->multiaddr == IGMP_ALL_HOSTS)
 				continue;
 			if (ipv4_is_local_multicast(pmc->multiaddr) &&
-			     !net->ipv4.sysctl_igmp_llm_reports)
+			    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 				continue;
 			spin_lock_bh(&pmc->lock);
 			if (pmc->sfcount[MCAST_EXCLUDE])
@@ -736,7 +737,8 @@ static int igmp_send_report(struct in_device *in_dev, struct ip_mc_list *pmc,
 	if (type == IGMPV3_HOST_MEMBERSHIP_REPORT)
 		return igmpv3_send_report(in_dev, pmc);
 
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return 0;
 
 	if (type == IGMP_HOST_LEAVE_MESSAGE)
@@ -920,7 +922,8 @@ static bool igmp_heard_report(struct in_device *in_dev, __be32 group)
 
 	if (group == IGMP_ALL_HOSTS)
 		return false;
-	if (ipv4_is_local_multicast(group) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(group) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return false;
 
 	rcu_read_lock();
@@ -1045,7 +1048,7 @@ static bool igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 		spin_lock_bh(&im->lock);
 		if (im->tm_running)
@@ -1296,7 +1299,8 @@ static void __igmp_group_dropped(struct ip_mc_list *im, gfp_t gfp)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	reporter = im->reporter;
@@ -1338,7 +1342,8 @@ static void igmp_group_added(struct ip_mc_list *im)
 #ifdef CONFIG_IP_MULTICAST
 	if (im->multiaddr == IGMP_ALL_HOSTS)
 		return;
-	if (ipv4_is_local_multicast(im->multiaddr) && !net->ipv4.sysctl_igmp_llm_reports)
+	if (ipv4_is_local_multicast(im->multiaddr) &&
+	    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 		return;
 
 	if (in_dev->dead)
@@ -1642,7 +1647,7 @@ static void ip_mc_rejoin_groups(struct in_device *in_dev)
 		if (im->multiaddr == IGMP_ALL_HOSTS)
 			continue;
 		if (ipv4_is_local_multicast(im->multiaddr) &&
-		    !net->ipv4.sysctl_igmp_llm_reports)
+		    !READ_ONCE(net->ipv4.sysctl_igmp_llm_reports))
 			continue;
 
 		/* a failover is happening and switches
@@ -2192,7 +2197,7 @@ static int __ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr,
 		count++;
 	}
 	err = -ENOBUFS;
-	if (count >= net->ipv4.sysctl_igmp_max_memberships)
+	if (count >= READ_ONCE(net->ipv4.sysctl_igmp_max_memberships))
 		goto done;
 	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL);
 	if (!iml)
@@ -2379,7 +2384,7 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 	}
 	/* else, add a new source to the filter */
 
-	if (psl && psl->sl_count >= net->ipv4.sysctl_igmp_max_msf) {
+	if (psl && psl->sl_count >= READ_ONCE(net->ipv4.sysctl_igmp_max_msf)) {
 		err = -ENOBUFS;
 		goto done;
 	}
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 62a67fdc344c..a53f9bf7886f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -259,7 +259,7 @@ inet_csk_find_open_port(struct sock *sk, struct inet_bind_bucket **tb_ret, int *
 		goto other_half_scan;
 	}
 
-	if (net->ipv4.sysctl_ip_autobind_reuse && !relax) {
+	if (READ_ONCE(net->ipv4.sysctl_ip_autobind_reuse) && !relax) {
 		/* We still have a chance to connect to different destinations */
 		relax = true;
 		goto ports_exhausted;
@@ -829,7 +829,8 @@ static void reqsk_timer_handler(struct timer_list *t)
 
 	icsk = inet_csk(sk_listener);
 	net = sock_net(sk_listener);
-	max_syn_ack_retries = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_synack_retries;
+	max_syn_ack_retries = icsk->icsk_syn_retries ? :
+		READ_ONCE(net->ipv4.sysctl_tcp_synack_retries);
 	/* Normally all the openreqs are young and become mature
 	 * (i.e. converted to established socket) for first timeout.
 	 * If synack was not acknowledged for 1 second, it means
diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 00ec819f949b..29730edda220 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -151,7 +151,7 @@ int ip_forward(struct sk_buff *skb)
 	    !skb_sec_path(skb))
 		ip_rt_send_redirect(skb);
 
-	if (net->ipv4.sysctl_ip_fwd_update_priority)
+	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_update_priority))
 		skb->priority = rt_tos2priority(iph->tos);
 
 	return NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD,
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 3a025c011971..d5222c0fa87c 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -318,8 +318,10 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 {
 	const struct iphdr *iph = ip_hdr(skb);
 	int (*edemux)(struct sk_buff *skb);
+	int err, drop_reason;
 	struct rtable *rt;
-	int err;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	if (ip_can_use_hint(skb, iph, hint)) {
 		err = ip_route_use_hint(skb, iph->daddr, iph->saddr, iph->tos,
@@ -396,19 +398,23 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
 		 * so-called "hole-196" attack) so do it for both.
 		 */
 		if (in_dev &&
-		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST))
+		    IN_DEV_ORCONF(in_dev, DROP_UNICAST_IN_L2_MULTICAST)) {
+			drop_reason = SKB_DROP_REASON_UNICAST_IN_L2_MULTICAST;
 			goto drop;
+		}
 	}
 
 	return NET_RX_SUCCESS;
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return NET_RX_DROP;
 
 drop_error:
-	if (err == -EXDEV)
+	if (err == -EXDEV) {
+		drop_reason = SKB_DROP_REASON_IP_RPFILTER;
 		__NET_INC_STATS(net, LINUX_MIB_IPRPFILTER);
+	}
 	goto drop;
 }
 
@@ -436,13 +442,16 @@ static int ip_rcv_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
 static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 {
 	const struct iphdr *iph;
+	int drop_reason;
 	u32 len;
 
 	/* When the interface is in promisc. mode, drop all the crap
 	 * that it receives, do not try to analyse it.
 	 */
-	if (skb->pkt_type == PACKET_OTHERHOST)
+	if (skb->pkt_type == PACKET_OTHERHOST) {
+		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
+	}
 
 	__IP_UPD_PO_STATS(net, IPSTATS_MIB_IN, skb->len);
 
@@ -452,6 +461,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 		goto out;
 	}
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto inhdr_error;
 
@@ -488,6 +498,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 
 	len = ntohs(iph->tot_len);
 	if (skb->len < len) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		__IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
 		goto drop;
 	} else if (len < (iph->ihl*4))
@@ -516,11 +527,14 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	return skb;
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_IP_CSUM;
 	__IP_INC_STATS(net, IPSTATS_MIB_CSUMERRORS);
 inhdr_error:
+	if (drop_reason == SKB_DROP_REASON_NOT_SPECIFIED)
+		drop_reason = SKB_DROP_REASON_IP_INHDR;
 	__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 out:
 	return NULL;
 }
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b297bb28556e..38f296afb663 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -782,7 +782,7 @@ static int ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval, int optlen)
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
 	err = -ENOBUFS;
 	if (gsf->gf_numsrc >= 0x1ffffff ||
-	    gsf->gf_numsrc > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+	    gsf->gf_numsrc > READ_ONCE(sock_net(sk)->ipv4.sysctl_igmp_max_msf))
 		goto out_free_gsf;
 
 	err = -EINVAL;
@@ -832,7 +832,7 @@ static int compat_ip_set_mcast_msfilter(struct sock *sk, sockptr_t optval,
 
 	/* numsrc >= (4G-140)/128 overflow in 32 bits */
 	err = -ENOBUFS;
-	if (n > sock_net(sk)->ipv4.sysctl_igmp_max_msf)
+	if (n > READ_ONCE(sock_net(sk)->ipv4.sysctl_igmp_max_msf))
 		goto out_free_gsf;
 	err = set_mcast_msfilter(sk, gf32->gf_interface, n, gf32->gf_fmode,
 				 &gf32->gf_group, gf32->gf_slist_flex);
@@ -1242,7 +1242,7 @@ static int do_ip_setsockopt(struct sock *sk, int level, int optname,
 		}
 		/* numsrc >= (1G-4) overflow in 32 bits */
 		if (msf->imsf_numsrc >= 0x3ffffffcU ||
-		    msf->imsf_numsrc > net->ipv4.sysctl_igmp_max_msf) {
+		    msf->imsf_numsrc > READ_ONCE(net->ipv4.sysctl_igmp_max_msf)) {
 			kfree(msf);
 			err = -ENOBUFS;
 			break;
@@ -1597,7 +1597,7 @@ static int do_ip_getsockopt(struct sock *sk, int level, int optname,
 	{
 		struct net *net = sock_net(sk);
 		val = (inet->uc_ttl == -1 ?
-		       net->ipv4.sysctl_ip_default_ttl :
+		       READ_ONCE(net->ipv4.sysctl_ip_default_ttl) :
 		       inet->uc_ttl);
 		break;
 	}
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 4eed5afca392..f2edb40c0db0 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -62,7 +62,7 @@ struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 	niph->tot_len = htons(nskb->len);
 	ip_send_check(niph);
@@ -115,7 +115,7 @@ struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
 
 	skb_reserve(nskb, LL_MAX_HEADER);
 	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_ICMP,
-				   net->ipv4.sysctl_ip_default_ttl);
+				   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	skb_reset_transport_header(nskb);
 	icmph = skb_put_zero(nskb, sizeof(struct icmphdr));
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index f30273afb539..4b9280a3b673 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -387,7 +387,7 @@ static int snmp_seq_show_ipstats(struct seq_file *seq, void *v)
 
 	seq_printf(seq, "\nIp: %d %d",
 		   IPV4_DEVCONF_ALL(net, FORWARDING) ? 1 : 2,
-		   net->ipv4.sysctl_ip_default_ttl);
+		   READ_ONCE(net->ipv4.sysctl_ip_default_ttl));
 
 	BUILD_BUG_ON(offsetof(struct ipstats_mib, mibs) != 0);
 	snmp_get_cpu_field64_batch(buff64, snmp4_ipstats_list,
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 1db2fda22830..ca59b61fd3a3 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1404,7 +1404,7 @@ u32 ip_mtu_from_fib_result(struct fib_result *res, __be32 daddr)
 	struct fib_info *fi = res->fi;
 	u32 mtu = 0;
 
-	if (dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu ||
+	if (READ_ONCE(dev_net(dev)->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    fi->fib_metrics->metrics[RTAX_LOCK - 1] & (1 << RTAX_MTU))
 		mtu = fi->fib_mtu;
 
@@ -1929,7 +1929,7 @@ static u32 fib_multipath_custom_hash_outer(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool *p_has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
@@ -1958,7 +1958,7 @@ static u32 fib_multipath_custom_hash_inner(const struct net *net,
 					   const struct sk_buff *skb,
 					   bool has_inner)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys keys, hash_keys;
 
 	/* We assume the packet carries an encapsulation, but if none was
@@ -2018,7 +2018,7 @@ static u32 fib_multipath_custom_hash_skb(const struct net *net,
 static u32 fib_multipath_custom_hash_fl4(const struct net *net,
 					 const struct flowi4 *fl4)
 {
-	u32 hash_fields = net->ipv4.sysctl_fib_multipath_hash_fields;
+	u32 hash_fields = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_fields);
 	struct flow_keys hash_keys;
 
 	if (!(hash_fields & FIB_MULTIPATH_HASH_FIELD_OUTER_MASK))
@@ -2048,7 +2048,7 @@ int fib_multipath_hash(const struct net *net, const struct flowi4 *fl4,
 	struct flow_keys hash_keys;
 	u32 mhash = 0;
 
-	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	switch (READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_policy)) {
 	case 0:
 		memset(&hash_keys, 0, sizeof(hash_keys));
 		hash_keys.control.addr_type = FLOW_DISSECTOR_KEY_IPV4_ADDRS;
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 10b469aee492..940839264025 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -249,12 +249,12 @@ bool cookie_timestamp_decode(const struct net *net,
 		return true;
 	}
 
-	if (!net->ipv4.sysctl_tcp_timestamps)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_timestamps))
 		return false;
 
 	tcp_opt->sack_ok = (options & TS_OPT_SACK) ? TCP_SACK_SEEN : 0;
 
-	if (tcp_opt->sack_ok && !net->ipv4.sysctl_tcp_sack)
+	if (tcp_opt->sack_ok && !READ_ONCE(net->ipv4.sysctl_tcp_sack))
 		return false;
 
 	if ((options & TS_OPT_WSCALE_MASK) == TS_OPT_WSCALE_MASK)
@@ -263,7 +263,7 @@ bool cookie_timestamp_decode(const struct net *net,
 	tcp_opt->wscale_ok = 1;
 	tcp_opt->snd_wscale = options & TS_OPT_WSCALE_MASK;
 
-	return net->ipv4.sysctl_tcp_window_scaling != 0;
+	return READ_ONCE(net->ipv4.sysctl_tcp_window_scaling) != 0;
 }
 EXPORT_SYMBOL(cookie_timestamp_decode);
 
@@ -275,7 +275,7 @@ bool cookie_ecn_ok(const struct tcp_options_received *tcp_opt,
 	if (!ecn_ok)
 		return false;
 
-	if (net->ipv4.sysctl_tcp_ecn)
+	if (READ_ONCE(net->ipv4.sysctl_tcp_ecn))
 		return true;
 
 	return dst_feature(dst, RTAX_FEATURE_ECN);
@@ -342,7 +342,8 @@ struct sock *cookie_v4_check(struct sock *sk, struct sk_buff *skb)
 	struct flowi4 fl4;
 	u32 tsoff = 0;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies || !th->ack || th->rst)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
+	    !th->ack || th->rst)
 		goto out;
 
 	if (tcp_synq_no_recent_overflow(sk))
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 616658e7c796..a36728277e32 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -97,7 +97,7 @@ static int ipv4_local_port_range(struct ctl_table *table, int write,
 		 * port limit.
 		 */
 		if ((range[1] < range[0]) ||
-		    (range[0] < net->ipv4.sysctl_ip_prot_sock))
+		    (range[0] < READ_ONCE(net->ipv4.sysctl_ip_prot_sock)))
 			ret = -EINVAL;
 		else
 			set_local_port_range(net, range);
@@ -123,7 +123,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		.extra2 = &ip_privileged_port_max,
 	};
 
-	pports = net->ipv4.sysctl_ip_prot_sock;
+	pports = READ_ONCE(net->ipv4.sysctl_ip_prot_sock);
 
 	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
 
@@ -135,7 +135,7 @@ static int ipv4_privileged_ports(struct ctl_table *table, int write,
 		if (range[0] < pports)
 			ret = -EINVAL;
 		else
-			net->ipv4.sysctl_ip_prot_sock = pports;
+			WRITE_ONCE(net->ipv4.sysctl_ip_prot_sock, pports);
 	}
 
 	return ret;
@@ -689,6 +689,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
 	},
 	{
 		.procname	= "tcp_ecn_fallback",
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 4ac53c8f0583..1abdb8712655 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -447,7 +447,7 @@ void tcp_init_sock(struct sock *sk)
 	tp->snd_cwnd_clamp = ~0;
 	tp->mss_cache = TCP_MSS_DEFAULT;
 
-	tp->reordering = sock_net(sk)->ipv4.sysctl_tcp_reordering;
+	tp->reordering = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering);
 	tcp_assign_congestion_control(sk);
 
 	tp->tsoffset = 0;
@@ -1159,7 +1159,8 @@ static int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 	struct sockaddr *uaddr = msg->msg_name;
 	int err, flags;
 
-	if (!(sock_net(sk)->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) ||
+	if (!(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) &
+	      TFO_CLIENT_ENABLE) ||
 	    (uaddr && msg->msg_namelen >= sizeof(uaddr->sa_family) &&
 	     uaddr->sa_family == AF_UNSPEC))
 		return -EOPNOTSUPP;
@@ -3626,7 +3627,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_FASTOPEN_CONNECT:
 		if (val > 1 || val < 0) {
 			err = -EINVAL;
-		} else if (net->ipv4.sysctl_tcp_fastopen & TFO_CLIENT_ENABLE) {
+		} else if (READ_ONCE(net->ipv4.sysctl_tcp_fastopen) &
+			   TFO_CLIENT_ENABLE) {
 			if (sk->sk_state == TCP_CLOSE)
 				tp->fastopen_connect = val;
 			else
@@ -3974,12 +3976,13 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		val = keepalive_probes(tp);
 		break;
 	case TCP_SYNCNT:
-		val = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
+		val = icsk->icsk_syn_retries ? :
+			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
 		break;
 	case TCP_LINGER2:
 		val = tp->linger2;
 		if (val >= 0)
-			val = (val ? : net->ipv4.sysctl_tcp_fin_timeout) / HZ;
+			val = (val ? : READ_ONCE(net->ipv4.sysctl_tcp_fin_timeout)) / HZ;
 		break;
 	case TCP_DEFER_ACCEPT:
 		val = retrans_to_secs(icsk->icsk_accept_queue.rskq_defer_accept,
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 59412d6354a0..6e0a8ef5e816 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -338,7 +338,7 @@ static bool tcp_fastopen_no_cookie(const struct sock *sk,
 				   const struct dst_entry *dst,
 				   int flag)
 {
-	return (sock_net(sk)->ipv4.sysctl_tcp_fastopen & flag) ||
+	return (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) & flag) ||
 	       tcp_sk(sk)->fastopen_no_cookie ||
 	       (dst && dst_metric(dst, RTAX_FASTOPEN_NO_COOKIE));
 }
@@ -353,7 +353,7 @@ struct sock *tcp_try_fastopen(struct sock *sk, struct sk_buff *skb,
 			      const struct dst_entry *dst)
 {
 	bool syn_data = TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(skb)->seq + 1;
-	int tcp_fastopen = sock_net(sk)->ipv4.sysctl_tcp_fastopen;
+	int tcp_fastopen = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen);
 	struct tcp_fastopen_cookie valid_foc = { .len = -1 };
 	struct sock *child;
 	int ret = 0;
@@ -495,7 +495,7 @@ void tcp_fastopen_active_disable(struct sock *sk)
 {
 	struct net *net = sock_net(sk);
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout))
 		return;
 
 	/* Paired with READ_ONCE() in tcp_fastopen_active_should_disable() */
@@ -516,7 +516,8 @@ void tcp_fastopen_active_disable(struct sock *sk)
  */
 bool tcp_fastopen_active_should_disable(struct sock *sk)
 {
-	unsigned int tfo_bh_timeout = sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout;
+	unsigned int tfo_bh_timeout =
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen_blackhole_timeout);
 	unsigned long timeout;
 	int tfo_da_times;
 	int multiplier;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 0ff2f620f8e4..2d21d8bf3b8c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1043,7 +1043,7 @@ static void tcp_check_sack_reordering(struct sock *sk, const u32 low_seq,
 			 tp->undo_marker ? tp->undo_retrans : 0);
 #endif
 		tp->reordering = min_t(u32, (metric + mss - 1) / mss,
-				       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+				       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	}
 
 	/* This exciting event is worth to be remembered. 8) */
@@ -2022,7 +2022,7 @@ static void tcp_check_reno_reordering(struct sock *sk, const int addend)
 		return;
 
 	tp->reordering = min_t(u32, tp->packets_out + addend,
-			       sock_net(sk)->ipv4.sysctl_tcp_max_reordering);
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_max_reordering));
 	tp->reord_seen++;
 	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPRENOREORDER);
 }
@@ -2087,7 +2087,8 @@ static inline void tcp_init_undo(struct tcp_sock *tp)
 
 static bool tcp_is_rack(const struct sock *sk)
 {
-	return sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_LOSS_DETECTION;
+	return READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		TCP_RACK_LOSS_DETECTION;
 }
 
 /* If we detect SACK reneging, forget all SACK information
@@ -2131,6 +2132,7 @@ void tcp_enter_loss(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	bool new_recovery = icsk->icsk_ca_state < TCP_CA_Recovery;
+	u8 reordering;
 
 	tcp_timeout_mark_lost(sk);
 
@@ -2151,10 +2153,12 @@ void tcp_enter_loss(struct sock *sk)
 	/* Timeout in disordered state after receiving substantial DUPACKs
 	 * suggests that the degree of reordering is over-estimated.
 	 */
+	reordering = READ_ONCE(net->ipv4.sysctl_tcp_reordering);
 	if (icsk->icsk_ca_state <= TCP_CA_Disorder &&
-	    tp->sacked_out >= net->ipv4.sysctl_tcp_reordering)
+	    tp->sacked_out >= reordering)
 		tp->reordering = min_t(unsigned int, tp->reordering,
-				       net->ipv4.sysctl_tcp_reordering);
+				       reordering);
+
 	tcp_set_ca_state(sk, TCP_CA_Loss);
 	tp->high_seq = tp->snd_nxt;
 	tcp_ecn_queue_cwr(tp);
@@ -3457,7 +3461,8 @@ static inline bool tcp_may_raise_cwnd(const struct sock *sk, const int flag)
 	 * new SACK or ECE mark may first advance cwnd here and later reduce
 	 * cwnd in tcp_fastretrans_alert() based on more states.
 	 */
-	if (tcp_sk(sk)->reordering > sock_net(sk)->ipv4.sysctl_tcp_reordering)
+	if (tcp_sk(sk)->reordering >
+	    READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reordering))
 		return flag & FLAG_FORWARD_PROGRESS;
 
 	return flag & FLAG_DATA_ACKED;
@@ -4049,7 +4054,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_WINDOW:
 				if (opsize == TCPOLEN_WINDOW && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_window_scaling) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_window_scaling)) {
 					__u8 snd_wscale = *(__u8 *)ptr;
 					opt_rx->wscale_ok = 1;
 					if (snd_wscale > TCP_MAX_WSCALE) {
@@ -4065,7 +4070,7 @@ void tcp_parse_options(const struct net *net,
 			case TCPOPT_TIMESTAMP:
 				if ((opsize == TCPOLEN_TIMESTAMP) &&
 				    ((estab && opt_rx->tstamp_ok) ||
-				     (!estab && net->ipv4.sysctl_tcp_timestamps))) {
+				     (!estab && READ_ONCE(net->ipv4.sysctl_tcp_timestamps)))) {
 					opt_rx->saw_tstamp = 1;
 					opt_rx->rcv_tsval = get_unaligned_be32(ptr);
 					opt_rx->rcv_tsecr = get_unaligned_be32(ptr + 4);
@@ -4073,7 +4078,7 @@ void tcp_parse_options(const struct net *net,
 				break;
 			case TCPOPT_SACK_PERM:
 				if (opsize == TCPOLEN_SACK_PERM && th->syn &&
-				    !estab && net->ipv4.sysctl_tcp_sack) {
+				    !estab && READ_ONCE(net->ipv4.sysctl_tcp_sack)) {
 					opt_rx->sack_ok = TCP_SACK_SEEN;
 					tcp_sack_reset(opt_rx);
 				}
@@ -5537,7 +5542,7 @@ static void tcp_check_urg(struct sock *sk, const struct tcphdr *th)
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 ptr = ntohs(th->urg_ptr);
 
-	if (ptr && !sock_net(sk)->ipv4.sysctl_tcp_stdurg)
+	if (ptr && !READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_stdurg))
 		ptr--;
 	ptr += ntohl(th->seq);
 
@@ -6669,7 +6674,7 @@ static void tcp_ecn_create_request(struct request_sock *req,
 
 	ect = !INET_ECN_is_not_ect(TCP_SKB_CB(skb)->ip_dsfield);
 	ecn_ok_dst = dst_feature(dst, DST_FEATURE_ECN_MASK);
-	ecn_ok = net->ipv4.sysctl_tcp_ecn || ecn_ok_dst;
+	ecn_ok = READ_ONCE(net->ipv4.sysctl_tcp_ecn) || ecn_ok_dst;
 
 	if (((!ect || th->res1) && ecn_ok) || tcp_ca_needs_ecn(listen_sk) ||
 	    (ecn_ok_dst & DST_FEATURE_ECN_CA) ||
@@ -6735,11 +6740,14 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 {
 	struct request_sock_queue *queue = &inet_csk(sk)->icsk_accept_queue;
 	const char *msg = "Dropping request";
-	bool want_cookie = false;
 	struct net *net = sock_net(sk);
+	bool want_cookie = false;
+	u8 syncookies;
+
+	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 #ifdef CONFIG_SYN_COOKIES
-	if (net->ipv4.sysctl_tcp_syncookies) {
+	if (syncookies) {
 		msg = "Sending cookies";
 		want_cookie = true;
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDOCOOKIES);
@@ -6747,8 +6755,7 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 #endif
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPREQQFULLDROP);
 
-	if (!queue->synflood_warned &&
-	    net->ipv4.sysctl_tcp_syncookies != 2 &&
+	if (!queue->synflood_warned && syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0)
 		net_info_ratelimited("%s: Possible SYN flooding on port %d. %s.  Check SNMP counters.\n",
 				     proto, sk->sk_num, msg);
@@ -6797,7 +6804,7 @@ u16 tcp_get_syncookie_mss(struct request_sock_ops *rsk_ops,
 	struct tcp_sock *tp = tcp_sk(sk);
 	u16 mss;
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_syncookies != 2 &&
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) != 2 &&
 	    !inet_csk_reqsk_queue_is_full(sk))
 		return 0;
 
@@ -6831,13 +6838,15 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 	bool want_cookie = false;
 	struct dst_entry *dst;
 	struct flowi fl;
+	u8 syncookies;
+
+	syncookies = READ_ONCE(net->ipv4.sysctl_tcp_syncookies);
 
 	/* TW buckets are converted to open requests without
 	 * limitations, they conserve resources and peer is
 	 * evidently real one.
 	 */
-	if ((net->ipv4.sysctl_tcp_syncookies == 2 ||
-	     inet_csk_reqsk_queue_is_full(sk)) && !isn) {
+	if ((syncookies == 2 || inet_csk_reqsk_queue_is_full(sk)) && !isn) {
 		want_cookie = tcp_syn_flood_action(sk, rsk_ops->slab_name);
 		if (!want_cookie)
 			goto drop;
@@ -6886,10 +6895,12 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		tcp_rsk(req)->ts_off = af_ops->init_ts_off(net, skb);
 
 	if (!want_cookie && !isn) {
+		int max_syn_backlog = READ_ONCE(net->ipv4.sysctl_max_syn_backlog);
+
 		/* Kill the following clause, if you dislike this way. */
-		if (!net->ipv4.sysctl_tcp_syncookies &&
-		    (net->ipv4.sysctl_max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
-		     (net->ipv4.sysctl_max_syn_backlog >> 2)) &&
+		if (!syncookies &&
+		    (max_syn_backlog - inet_csk_reqsk_queue_len(sk) <
+		     (max_syn_backlog >> 2)) &&
 		    !tcp_peer_is_proven(req, dst)) {
 			/* Without syncookies last quarter of
 			 * backlog is filled with destinations,
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 5d94822fd506..fba02cf6b468 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -91,6 +91,8 @@ static int tcp_v4_md5_hash_hdr(char *md5_hash, const struct tcp_md5sig_key *key,
 struct inet_hashinfo tcp_hashinfo;
 EXPORT_SYMBOL(tcp_hashinfo);
 
+static DEFINE_PER_CPU(struct sock *, ipv4_tcp_sk);
+
 static u32 tcp_v4_init_seq(const struct sk_buff *skb)
 {
 	return secure_tcp_seq(ip_hdr(skb)->daddr,
@@ -106,10 +108,10 @@ static u32 tcp_v4_init_ts_off(const struct net *net, const struct sk_buff *skb)
 
 int tcp_twsk_unique(struct sock *sk, struct sock *sktw, void *twp)
 {
+	int reuse = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tw_reuse);
 	const struct inet_timewait_sock *tw = inet_twsk(sktw);
 	const struct tcp_timewait_sock *tcptw = tcp_twsk(sktw);
 	struct tcp_sock *tp = tcp_sk(sk);
-	int reuse = sock_net(sk)->ipv4.sysctl_tcp_tw_reuse;
 
 	if (reuse == 2) {
 		/* Still does not detect *everything* that goes through
@@ -807,7 +809,8 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 	arg.tos = ip_hdr(skb)->tos;
 	arg.uid = sock_net_uid(net, sk && sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	if (sk) {
 		ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_mark : sk->sk_mark;
@@ -822,6 +825,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
 	local_bh_enable();
@@ -905,7 +909,8 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	arg.tos = tos;
 	arg.uid = sock_net_uid(net, sk_fullsock(sk) ? sk : NULL);
 	local_bh_disable();
-	ctl_sk = this_cpu_read(*net->ipv4.tcp_sk);
+	ctl_sk = this_cpu_read(ipv4_tcp_sk);
+	sock_net_set(ctl_sk, net);
 	ctl_sk->sk_mark = (sk->sk_state == TCP_TIME_WAIT) ?
 			   inet_twsk(sk)->tw_mark : sk->sk_mark;
 	ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
@@ -918,6 +923,7 @@ static void tcp_v4_send_ack(const struct sock *sk,
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	local_bh_enable();
 }
@@ -1970,8 +1976,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
+	int drop_reason;
 	int ret;
 
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
 
@@ -1983,8 +1991,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	th = (const struct tcphdr *)skb->data;
 
-	if (unlikely(th->doff < sizeof(struct tcphdr) / 4))
+	if (unlikely(th->doff < sizeof(struct tcphdr) / 4)) {
+		drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 		goto bad_packet;
+	}
 	if (!pskb_may_pull(skb, th->doff * 4))
 		goto discard_it;
 
@@ -2087,8 +2097,10 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	nf_reset_ct(skb);
 
-	if (tcp_filter(sk, skb))
+	if (tcp_filter(sk, skb)) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
+	}
 	th = (const struct tcphdr *)skb->data;
 	iph = ip_hdr(skb);
 	tcp_v4_fill_cb(skb, iph, th);
@@ -2125,6 +2137,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	return ret;
 
 no_tcp_socket:
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard_it;
 
@@ -2132,6 +2145,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 	if (tcp_checksum_complete(skb)) {
 csum_error:
+		drop_reason = SKB_DROP_REASON_TCP_CSUM;
 		trace_tcp_bad_csum(skb);
 		__TCP_INC_STATS(net, TCP_MIB_CSUMERRORS);
 bad_packet:
@@ -2142,7 +2156,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 
 discard_it:
 	/* Discard frame. */
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 discard_and_relse:
@@ -3103,41 +3117,14 @@ EXPORT_SYMBOL(tcp_prot);
 
 static void __net_exit tcp_sk_exit(struct net *net)
 {
-	int cpu;
-
 	if (net->ipv4.tcp_congestion_control)
 		bpf_module_put(net->ipv4.tcp_congestion_control,
 			       net->ipv4.tcp_congestion_control->owner);
-
-	for_each_possible_cpu(cpu)
-		inet_ctl_sock_destroy(*per_cpu_ptr(net->ipv4.tcp_sk, cpu));
-	free_percpu(net->ipv4.tcp_sk);
 }
 
 static int __net_init tcp_sk_init(struct net *net)
 {
-	int res, cpu, cnt;
-
-	net->ipv4.tcp_sk = alloc_percpu(struct sock *);
-	if (!net->ipv4.tcp_sk)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu) {
-		struct sock *sk;
-
-		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
-					   IPPROTO_TCP, net);
-		if (res)
-			goto fail;
-		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
-
-		/* Please enforce IP_DF and IPID==0 for RST and
-		 * ACK sent in SYN-RECV and TIME-WAIT state.
-		 */
-		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
-
-		*per_cpu_ptr(net->ipv4.tcp_sk, cpu) = sk;
-	}
+	int cnt;
 
 	net->ipv4.sysctl_tcp_ecn = 2;
 	net->ipv4.sysctl_tcp_ecn_fallback = 1;
@@ -3221,10 +3208,6 @@ static int __net_init tcp_sk_init(struct net *net)
 		net->ipv4.tcp_congestion_control = &tcp_reno;
 
 	return 0;
-fail:
-	tcp_sk_exit(net);
-
-	return res;
 }
 
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
@@ -3318,6 +3301,24 @@ static void __init bpf_iter_register(void)
 
 void __init tcp_v4_init(void)
 {
+	int cpu, res;
+
+	for_each_possible_cpu(cpu) {
+		struct sock *sk;
+
+		res = inet_ctl_sock_create(&sk, PF_INET, SOCK_RAW,
+					   IPPROTO_TCP, &init_net);
+		if (res)
+			panic("Failed to create the TCP control socket.\n");
+		sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
+
+		/* Please enforce IP_DF and IPID==0 for RST and
+		 * ACK sent in SYN-RECV and TIME-WAIT state.
+		 */
+		inet_sk(sk)->pmtudisc = IP_PMTUDISC_DO;
+
+		per_cpu(ipv4_tcp_sk, cpu) = sk;
+	}
 	if (register_pernet_subsys(&tcp_sk_ops))
 		panic("Failed to create the TCP control socket.\n");
 
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 7029b0e98edb..a501150deaa3 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -428,7 +428,8 @@ void tcp_update_metrics(struct sock *sk)
 		if (!tcp_metric_locked(tm, TCP_METRIC_REORDERING)) {
 			val = tcp_metric_get(tm, TCP_METRIC_REORDERING);
 			if (val < tp->reordering &&
-			    tp->reordering != net->ipv4.sysctl_tcp_reordering)
+			    tp->reordering !=
+			    READ_ONCE(net->ipv4.sysctl_tcp_reordering))
 				tcp_metric_set(tm, TCP_METRIC_REORDERING,
 					       tp->reordering);
 		}
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 13783fc58e03..41368e77fbb8 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -180,7 +180,7 @@ tcp_timewait_state_process(struct inet_timewait_sock *tw, struct sk_buff *skb,
 			 * Oh well... nobody has a sufficient solution to this
 			 * protocol bug yet.
 			 */
-			if (twsk_net(tw)->ipv4.sysctl_tcp_rfc1337 == 0) {
+			if (!READ_ONCE(twsk_net(tw)->ipv4.sysctl_tcp_rfc1337)) {
 kill:
 				inet_twsk_deschedule_put(tw);
 				return TCP_TW_SUCCESS;
@@ -789,7 +789,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	if (sk != req->rsk_listener)
 		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMIGRATEREQFAILURE);
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_abort_on_overflow) {
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_abort_on_overflow)) {
 		inet_rsk(req)->acked = 1;
 		return NULL;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 509aab1b7ac9..caf9283f9b0f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -324,7 +324,7 @@ static void tcp_ecn_send_syn(struct sock *sk, struct sk_buff *skb)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	bool bpf_needs_ecn = tcp_bpf_ca_needs_ecn(sk);
-	bool use_ecn = sock_net(sk)->ipv4.sysctl_tcp_ecn == 1 ||
+	bool use_ecn = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_ecn) == 1 ||
 		tcp_ca_needs_ecn(sk) || bpf_needs_ecn;
 
 	if (!use_ecn) {
@@ -790,18 +790,18 @@ static unsigned int tcp_syn_options(struct sock *sk, struct sk_buff *skb,
 	opts->mss = tcp_advertise_mss(sk);
 	remaining -= TCPOLEN_MSS_ALIGNED;
 
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_timestamps && !*md5)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_timestamps) && !*md5)) {
 		opts->options |= OPTION_TS;
 		opts->tsval = tcp_skb_timestamp(skb) + tp->tsoffset;
 		opts->tsecr = tp->rx_opt.ts_recent;
 		remaining -= TCPOLEN_TSTAMP_ALIGNED;
 	}
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_window_scaling)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling))) {
 		opts->ws = tp->rx_opt.rcv_wscale;
 		opts->options |= OPTION_WSCALE;
 		remaining -= TCPOLEN_WSCALE_ALIGNED;
 	}
-	if (likely(sock_net(sk)->ipv4.sysctl_tcp_sack)) {
+	if (likely(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_sack))) {
 		opts->options |= OPTION_SACK_ADVERTISE;
 		if (unlikely(!(OPTION_TS & opts->options)))
 			remaining -= TCPOLEN_SACKPERM_ALIGNED;
@@ -1722,7 +1722,8 @@ static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	mss_now -= icsk->icsk_ext_hdr_len;
 
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
-	mss_now = max(mss_now, sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss);
+	mss_now = max(mss_now,
+		      READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_min_snd_mss));
 	return mss_now;
 }
 
@@ -1765,10 +1766,10 @@ void tcp_mtup_init(struct sock *sk)
 	struct inet_connection_sock *icsk = inet_csk(sk);
 	struct net *net = sock_net(sk);
 
-	icsk->icsk_mtup.enabled = net->ipv4.sysctl_tcp_mtu_probing > 1;
+	icsk->icsk_mtup.enabled = READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing) > 1;
 	icsk->icsk_mtup.search_high = tp->rx_opt.mss_clamp + sizeof(struct tcphdr) +
 			       icsk->icsk_af_ops->net_header_len;
-	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, net->ipv4.sysctl_tcp_base_mss);
+	icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, READ_ONCE(net->ipv4.sysctl_tcp_base_mss));
 	icsk->icsk_mtup.probe_size = 0;
 	if (icsk->icsk_mtup.enabled)
 		icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
@@ -1900,7 +1901,7 @@ static void tcp_cwnd_validate(struct sock *sk, bool is_cwnd_limited)
 		if (tp->packets_out > tp->snd_cwnd_used)
 			tp->snd_cwnd_used = tp->packets_out;
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle &&
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_slow_start_after_idle) &&
 		    (s32)(tcp_jiffies32 - tp->snd_cwnd_stamp) >= inet_csk(sk)->icsk_rto &&
 		    !ca_ops->cong_control)
 			tcp_cwnd_application_limited(sk);
@@ -2280,7 +2281,7 @@ static inline void tcp_mtu_check_reprobe(struct sock *sk)
 	u32 interval;
 	s32 delta;
 
-	interval = net->ipv4.sysctl_tcp_probe_interval;
+	interval = READ_ONCE(net->ipv4.sysctl_tcp_probe_interval);
 	delta = tcp_jiffies32 - icsk->icsk_mtup.probe_timestamp;
 	if (unlikely(delta >= interval * HZ)) {
 		int mss = tcp_current_mss(sk);
@@ -2362,7 +2363,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	 * probing process by not resetting search range to its orignal.
 	 */
 	if (probe_size > tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_high) ||
-		interval < net->ipv4.sysctl_tcp_probe_threshold) {
+	    interval < READ_ONCE(net->ipv4.sysctl_tcp_probe_threshold)) {
 		/* Check whether enough time has elaplased for
 		 * another round of probing.
 		 */
@@ -2738,7 +2739,7 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	if (rcu_access_pointer(tp->fastopen_rsk))
 		return false;
 
-	early_retrans = sock_net(sk)->ipv4.sysctl_tcp_early_retrans;
+	early_retrans = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_early_retrans);
 	/* Schedule a loss probe in 2*RTT for SACK capable connections
 	 * not in loss recovery, that are either limited by cwnd or application.
 	 */
@@ -3107,7 +3108,7 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
 	struct sk_buff *skb = to, *tmp;
 	bool first = true;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_retrans_collapse)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_retrans_collapse))
 		return;
 	if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_SYN)
 		return;
@@ -3648,7 +3649,7 @@ static void tcp_connect_init(struct sock *sk)
 	 * See tcp_input.c:tcp_rcv_state_process case TCP_SYN_SENT.
 	 */
 	tp->tcp_header_len = sizeof(struct tcphdr);
-	if (sock_net(sk)->ipv4.sysctl_tcp_timestamps)
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_timestamps))
 		tp->tcp_header_len += TCPOLEN_TSTAMP_ALIGNED;
 
 #ifdef CONFIG_TCP_MD5SIG
@@ -3684,7 +3685,7 @@ static void tcp_connect_init(struct sock *sk)
 				  tp->advmss - (tp->rx_opt.ts_recent_stamp ? tp->tcp_header_len - sizeof(struct tcphdr) : 0),
 				  &tp->rcv_wnd,
 				  &tp->window_clamp,
-				  sock_net(sk)->ipv4.sysctl_tcp_window_scaling,
+				  READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_window_scaling),
 				  &rcv_wscale,
 				  rcv_wnd);
 
@@ -4092,7 +4093,7 @@ void tcp_send_probe0(struct sock *sk)
 
 	icsk->icsk_probes_out++;
 	if (err <= 0) {
-		if (icsk->icsk_backoff < net->ipv4.sysctl_tcp_retries2)
+		if (icsk->icsk_backoff < READ_ONCE(net->ipv4.sysctl_tcp_retries2))
 			icsk->icsk_backoff++;
 		timeout = tcp_probe0_when(sk, TCP_RTO_MAX);
 	} else {
diff --git a/net/ipv4/tcp_recovery.c b/net/ipv4/tcp_recovery.c
index fd113f6226ef..ac14216f6204 100644
--- a/net/ipv4/tcp_recovery.c
+++ b/net/ipv4/tcp_recovery.c
@@ -19,7 +19,8 @@ static u32 tcp_rack_reo_wnd(const struct sock *sk)
 			return 0;
 
 		if (tp->sacked_out >= tp->reordering &&
-		    !(sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_NO_DUPTHRESH))
+		    !(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+		      TCP_RACK_NO_DUPTHRESH))
 			return 0;
 	}
 
@@ -192,7 +193,8 @@ void tcp_rack_update_reo_wnd(struct sock *sk, struct rate_sample *rs)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	if (sock_net(sk)->ipv4.sysctl_tcp_recovery & TCP_RACK_STATIC_REO_WND ||
+	if ((READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_recovery) &
+	     TCP_RACK_STATIC_REO_WND) ||
 	    !rs->prior_delivered)
 		return;
 
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index 20cf4a98c69d..50bba370486e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -143,7 +143,7 @@ static int tcp_out_of_resources(struct sock *sk, bool do_reset)
  */
 static int tcp_orphan_retries(struct sock *sk, bool alive)
 {
-	int retries = sock_net(sk)->ipv4.sysctl_tcp_orphan_retries; /* May be zero. */
+	int retries = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_orphan_retries); /* May be zero. */
 
 	/* We know from an ICMP that something is wrong. */
 	if (sk->sk_err_soft && !alive)
@@ -163,7 +163,7 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 	int mss;
 
 	/* Black hole detection */
-	if (!net->ipv4.sysctl_tcp_mtu_probing)
+	if (!READ_ONCE(net->ipv4.sysctl_tcp_mtu_probing))
 		return;
 
 	if (!icsk->icsk_mtup.enabled) {
@@ -171,9 +171,9 @@ static void tcp_mtu_probing(struct inet_connection_sock *icsk, struct sock *sk)
 		icsk->icsk_mtup.probe_timestamp = tcp_jiffies32;
 	} else {
 		mss = tcp_mtu_to_mss(sk, icsk->icsk_mtup.search_low) >> 1;
-		mss = min(net->ipv4.sysctl_tcp_base_mss, mss);
-		mss = max(mss, net->ipv4.sysctl_tcp_mtu_probe_floor);
-		mss = max(mss, net->ipv4.sysctl_tcp_min_snd_mss);
+		mss = min(READ_ONCE(net->ipv4.sysctl_tcp_base_mss), mss);
+		mss = max(mss, READ_ONCE(net->ipv4.sysctl_tcp_mtu_probe_floor));
+		mss = max(mss, READ_ONCE(net->ipv4.sysctl_tcp_min_snd_mss));
 		icsk->icsk_mtup.search_low = tcp_mss_to_mtu(sk, mss);
 	}
 	tcp_sync_mss(sk, icsk->icsk_pmtu_cookie);
@@ -239,17 +239,18 @@ static int tcp_write_timeout(struct sock *sk)
 	if ((1 << sk->sk_state) & (TCPF_SYN_SENT | TCPF_SYN_RECV)) {
 		if (icsk->icsk_retransmits)
 			__dst_negative_advice(sk);
-		retry_until = icsk->icsk_syn_retries ? : net->ipv4.sysctl_tcp_syn_retries;
+		retry_until = icsk->icsk_syn_retries ? :
+			READ_ONCE(net->ipv4.sysctl_tcp_syn_retries);
 		expired = icsk->icsk_retransmits >= retry_until;
 	} else {
-		if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1, 0)) {
+		if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1), 0)) {
 			/* Black hole detection */
 			tcp_mtu_probing(icsk, sk);
 
 			__dst_negative_advice(sk);
 		}
 
-		retry_until = net->ipv4.sysctl_tcp_retries2;
+		retry_until = READ_ONCE(net->ipv4.sysctl_tcp_retries2);
 		if (sock_flag(sk, SOCK_DEAD)) {
 			const bool alive = icsk->icsk_rto < TCP_RTO_MAX;
 
@@ -380,7 +381,7 @@ static void tcp_probe_timer(struct sock *sk)
 		 msecs_to_jiffies(icsk->icsk_user_timeout))
 		goto abort;
 
-	max_probes = sock_net(sk)->ipv4.sysctl_tcp_retries2;
+	max_probes = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_retries2);
 	if (sock_flag(sk, SOCK_DEAD)) {
 		const bool alive = inet_csk_rto_backoff(icsk, TCP_RTO_MAX) < TCP_RTO_MAX;
 
@@ -406,12 +407,15 @@ abort:		tcp_write_err(sk);
 static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	int max_retries = icsk->icsk_syn_retries ? :
-	    sock_net(sk)->ipv4.sysctl_tcp_synack_retries + 1; /* add one more retry for fastopen */
 	struct tcp_sock *tp = tcp_sk(sk);
+	int max_retries;
 
 	req->rsk_ops->syn_ack_timeout(req);
 
+	/* add one more retry for fastopen */
+	max_retries = icsk->icsk_syn_retries ? :
+		READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_synack_retries) + 1;
+
 	if (req->num_timeout >= max_retries) {
 		tcp_write_err(sk);
 		return;
@@ -574,7 +578,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	 * linear-timeout retransmissions into a black hole
 	 */
 	if (sk->sk_state == TCP_ESTABLISHED &&
-	    (tp->thin_lto || net->ipv4.sysctl_tcp_thin_linear_timeouts) &&
+	    (tp->thin_lto || READ_ONCE(net->ipv4.sysctl_tcp_thin_linear_timeouts)) &&
 	    tcp_stream_is_thin(tp) &&
 	    icsk->icsk_retransmits <= TCP_THIN_LINEAR_RETRIES) {
 		icsk->icsk_backoff = 0;
@@ -585,7 +589,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	}
 	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
 				  tcp_clamp_rto_to_user_timeout(sk), TCP_RTO_MAX);
-	if (retransmits_timed_out(sk, net->ipv4.sysctl_tcp_retries1 + 1, 0))
+	if (retransmits_timed_out(sk, READ_ONCE(net->ipv4.sysctl_tcp_retries1) + 1, 0))
 		__sk_dst_reset(sk);
 
 out:;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 835b9d6e4e68..4ad4daa16cce 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2411,6 +2411,9 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__be32 saddr, daddr;
 	struct net *net = dev_net(skb->dev);
 	bool refcounted;
+	int drop_reason;
+
+	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 	/*
 	 *  Validate the packet.
@@ -2466,6 +2469,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
 
+	drop_reason = SKB_DROP_REASON_NO_SOCKET;
 	__UDP_INC_STATS(net, UDP_MIB_NOPORTS, proto == IPPROTO_UDPLITE);
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 
@@ -2473,10 +2477,11 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * Hmm.  We got an UDP packet to a port to which we
 	 * don't wanna listen.  Ignore it.
 	 */
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 
 short_packet:
+	drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
 	net_dbg_ratelimited("UDP%s: short packet: From %pI4:%u %d/%d to %pI4:%u\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source),
@@ -2489,6 +2494,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	 * RFC1122: OK.  Discards the bad packet silently (as far as
 	 * the network is concerned, anyway) as per 4.1.3.4 (MUST).
 	 */
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	net_dbg_ratelimited("UDP%s: bad checksum. From %pI4:%u to %pI4:%u ulen %d\n",
 			    proto == IPPROTO_UDPLITE ? "Lite" : "",
 			    &saddr, ntohs(uh->source), &daddr, ntohs(uh->dest),
@@ -2496,7 +2502,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 	__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, proto == IPPROTO_UDPLITE);
 drop:
 	__UDP_INC_STATS(net, UDP_MIB_INERRORS, proto == IPPROTO_UDPLITE);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return 0;
 }
 
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index dab4a047590b..3a91d0d40aec 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -226,7 +226,7 @@ static int inet6_create(struct net *net, struct socket *sock, int protocol,
 	RCU_INIT_POINTER(inet->mc_list, NULL);
 	inet->rcv_tos	= 0;
 
-	if (net->ipv4.sysctl_ip_no_pmtu_disc)
+	if (READ_ONCE(net->ipv4.sysctl_ip_no_pmtu_disc))
 		inet->pmtudisc = IP_PMTUDISC_DONT;
 	else
 		inet->pmtudisc = IP_PMTUDISC_WANT;
diff --git a/net/ipv6/syncookies.c b/net/ipv6/syncookies.c
index ca92dd6981de..12ae817aaf2e 100644
--- a/net/ipv6/syncookies.c
+++ b/net/ipv6/syncookies.c
@@ -141,7 +141,8 @@ struct sock *cookie_v6_check(struct sock *sk, struct sk_buff *skb)
 	__u8 rcv_wscale;
 	u32 tsoff = 0;
 
-	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies || !th->ack || th->rst)
+	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies) ||
+	    !th->ack || th->rst)
 		goto out;
 
 	if (tcp_synq_no_recent_overflow(sk))
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 60332fdb6dd4..cca0762a9010 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -592,7 +592,8 @@ int nf_hook_slow(struct sk_buff *skb, struct nf_hook_state *state,
 		case NF_ACCEPT:
 			break;
 		case NF_DROP:
-			kfree_skb(skb);
+			kfree_skb_reason(skb,
+					 SKB_DROP_REASON_NETFILTER_DROP);
 			ret = NF_DROP_GETERR(verdict);
 			if (ret == 0)
 				ret = -EPERM;
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 2dfc5dae0656..049a88f03801 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -427,7 +427,7 @@ synproxy_build_ip(struct net *net, struct sk_buff *skb, __be32 saddr,
 	iph->tos	= 0;
 	iph->id		= 0;
 	iph->frag_off	= htons(IP_DF);
-	iph->ttl	= net->ipv4.sysctl_ip_default_ttl;
+	iph->ttl	= READ_ONCE(net->ipv4.sysctl_ip_default_ttl);
 	iph->protocol	= IPPROTO_TCP;
 	iph->check	= 0;
 	iph->saddr	= saddr;
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index ec0f52567c16..9987decdead2 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -359,7 +359,7 @@ static int sctp_v4_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (addr->v4.sin_addr.s_addr != htonl(INADDR_ANY) &&
 	   ret != RTN_LOCAL &&
 	   !sp->inet.freebind &&
-	   !net->ipv4.sysctl_ip_nonlocal_bind)
+	    !READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind))
 		return 0;
 
 	if (ipv6_only_sock(sctp_opt2sk(sp)))
diff --git a/net/smc/smc_llc.c b/net/smc/smc_llc.c
index ee1f0fdba085..0ef15f8fba90 100644
--- a/net/smc/smc_llc.c
+++ b/net/smc/smc_llc.c
@@ -1787,7 +1787,7 @@ void smc_llc_lgr_init(struct smc_link_group *lgr, struct smc_sock *smc)
 	init_waitqueue_head(&lgr->llc_flow_waiter);
 	init_waitqueue_head(&lgr->llc_msg_waiter);
 	mutex_init(&lgr->llc_conf_mutex);
-	lgr->llc_testlink_time = net->ipv4.sysctl_tcp_keepalive_time;
+	lgr->llc_testlink_time = READ_ONCE(net->ipv4.sysctl_tcp_keepalive_time);
 }
 
 /* called after lgr was removed from lgr_list */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4775431cbd38..4e33150cfb9e 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -97,13 +97,16 @@ static void tls_device_queue_ctx_destruction(struct tls_context *ctx)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tls_device_lock, flags);
+	if (unlikely(!refcount_dec_and_test(&ctx->refcount)))
+		goto unlock;
+
 	list_move_tail(&ctx->list, &tls_device_gc_list);
 
 	/* schedule_work inside the spinlock
 	 * to make sure tls_device_down waits for that work.
 	 */
 	schedule_work(&tls_device_gc_work);
-
+unlock:
 	spin_unlock_irqrestore(&tls_device_lock, flags);
 }
 
@@ -194,8 +197,7 @@ void tls_device_sk_destruct(struct sock *sk)
 		clean_acked_data_disable(inet_csk(sk));
 	}
 
-	if (refcount_dec_and_test(&tls_ctx->refcount))
-		tls_device_queue_ctx_destruction(tls_ctx);
+	tls_device_queue_ctx_destruction(tls_ctx);
 }
 EXPORT_SYMBOL_GPL(tls_device_sk_destruct);
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index a6271b955e11..fb198f9490a0 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2678,8 +2678,10 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		*num_xfrms = 0;
 		return 0;
 	}
-	if (IS_ERR(pols[0]))
+	if (IS_ERR(pols[0])) {
+		*num_pols = 0;
 		return PTR_ERR(pols[0]);
+	}
 
 	*num_xfrms = pols[0]->xfrm_nr;
 
@@ -2694,6 +2696,7 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 		if (pols[1]) {
 			if (IS_ERR(pols[1])) {
 				xfrm_pols_put(pols, *num_pols);
+				*num_pols = 0;
 				return PTR_ERR(pols[1]);
 			}
 			(*num_pols)++;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index f7bfa1916968..b1a04a22166f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2619,7 +2619,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload)
 	int err;
 
 	if (family == AF_INET &&
-	    xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc)
+	    READ_ONCE(xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc))
 		x->props.flags |= XFRM_STATE_NOPMTUDISC;
 
 	err = -EPROTONOSUPPORT;
diff --git a/scripts/sorttable.c b/scripts/sorttable.c
index 6ee4fa882919..278bb53b325c 100644
--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -240,7 +240,7 @@ static void x86_sort_relative_table(char *extab_image, int image_size)
 
 		w(r(loc) + i, loc);
 		w(r(loc + 1) + i + 4, loc + 1);
-		w(r(loc + 2) + i + 8, loc + 2);
+		/* Don't touch the fixup type */
 
 		i += sizeof(uint32_t) * 3;
 	}
@@ -253,7 +253,7 @@ static void x86_sort_relative_table(char *extab_image, int image_size)
 
 		w(r(loc) - i, loc);
 		w(r(loc + 1) - (i + 4), loc + 1);
-		w(r(loc + 2) - (i + 8), loc + 2);
+		/* Don't touch the fixup type */
 
 		i += sizeof(uint32_t) * 3;
 	}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index fa5a93dbe5d2..748b97a2582a 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -2034,6 +2034,10 @@ bool ima_appraise_signature(enum kernel_read_file_id id)
 	if (id >= READING_MAX_ID)
 		return false;
 
+	if (id == READING_KEXEC_IMAGE && !(ima_appraise & IMA_APPRAISE_ENFORCE)
+	    && security_locked_down(LOCKDOWN_KEXEC))
+		return false;
+
 	func = read_idmap[id] ?: FILE_CHECK;
 
 	rcu_read_lock();
diff --git a/tools/perf/tests/perf-time-to-tsc.c b/tools/perf/tests/perf-time-to-tsc.c
index 7c56bc1f4cff..89d25befb171 100644
--- a/tools/perf/tests/perf-time-to-tsc.c
+++ b/tools/perf/tests/perf-time-to-tsc.c
@@ -20,8 +20,6 @@
 #include "tsc.h"
 #include "mmap.h"
 #include "tests.h"
-#include "pmu.h"
-#include "pmu-hybrid.h"
 
 #define CHECK__(x) {				\
 	while ((x) < 0) {			\
@@ -84,18 +82,8 @@ int test__perf_time_to_tsc(struct test *test __maybe_unused, int subtest __maybe
 
 	evlist__config(evlist, &opts, NULL);
 
-	evsel = evlist__first(evlist);
-
-	evsel->core.attr.comm = 1;
-	evsel->core.attr.disabled = 1;
-	evsel->core.attr.enable_on_exec = 0;
-
-	/*
-	 * For hybrid "cycles:u", it creates two events.
-	 * Init the second evsel here.
-	 */
-	if (perf_pmu__has_hybrid() && perf_pmu__hybrid_mounted("cpu_atom")) {
-		evsel = evsel__next(evsel);
+	/* For hybrid "cycles:u", it creates two events */
+	evlist__for_each_entry(evlist, evsel) {
 		evsel->core.attr.comm = 1;
 		evsel->core.attr.disabled = 1;
 		evsel->core.attr.enable_on_exec = 0;
@@ -141,10 +129,12 @@ int test__perf_time_to_tsc(struct test *test __maybe_unused, int subtest __maybe
 				goto next_event;
 
 			if (strcmp(event->comm.comm, comm1) == 0) {
+				CHECK_NOT_NULL__(evsel = evlist__event2evsel(evlist, event));
 				CHECK__(evsel__parse_sample(evsel, event, &sample));
 				comm1_time = sample.time;
 			}
 			if (strcmp(event->comm.comm, comm2) == 0) {
+				CHECK_NOT_NULL__(evsel = evlist__event2evsel(evlist, event));
 				CHECK__(evsel__parse_sample(evsel, event, &sample));
 				comm2_time = sample.time;
 			}
diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 4158da0da2bb..2237d1aac801 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -82,8 +82,9 @@ static int next_cpu(int cpu)
 	return cpu;
 }
 
-static void *migration_worker(void *ign)
+static void *migration_worker(void *__rseq_tid)
 {
+	pid_t rseq_tid = (pid_t)(unsigned long)__rseq_tid;
 	cpu_set_t allowed_mask;
 	int r, i, cpu;
 
@@ -106,7 +107,7 @@ static void *migration_worker(void *ign)
 		 * stable, i.e. while changing affinity is in-progress.
 		 */
 		smp_wmb();
-		r = sched_setaffinity(0, sizeof(allowed_mask), &allowed_mask);
+		r = sched_setaffinity(rseq_tid, sizeof(allowed_mask), &allowed_mask);
 		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
 			    errno, strerror(errno));
 		smp_wmb();
@@ -231,7 +232,8 @@ int main(int argc, char *argv[])
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
-	pthread_create(&migration_thread, NULL, migration_worker, 0);
+	pthread_create(&migration_thread, NULL, migration_worker,
+		       (void *)(unsigned long)gettid());
 
 	for (i = 0; !done; i++) {
 		vcpu_run(vm, VCPU_ID);
diff --git a/tools/testing/selftests/vm/mremap_test.c b/tools/testing/selftests/vm/mremap_test.c
index 8f4dbbd60c09..e3ce33a9954e 100644
--- a/tools/testing/selftests/vm/mremap_test.c
+++ b/tools/testing/selftests/vm/mremap_test.c
@@ -119,59 +119,6 @@ static unsigned long long get_mmap_min_addr(void)
 	return addr;
 }
 
-/*
- * Returns false if the requested remap region overlaps with an
- * existing mapping (e.g text, stack) else returns true.
- */
-static bool is_remap_region_valid(void *addr, unsigned long long size)
-{
-	void *remap_addr = NULL;
-	bool ret = true;
-
-	/* Use MAP_FIXED_NOREPLACE flag to ensure region is not mapped */
-	remap_addr = mmap(addr, size, PROT_READ | PROT_WRITE,
-					 MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
-					 -1, 0);
-
-	if (remap_addr == MAP_FAILED) {
-		if (errno == EEXIST)
-			ret = false;
-	} else {
-		munmap(remap_addr, size);
-	}
-
-	return ret;
-}
-
-/* Returns mmap_min_addr sysctl tunable from procfs */
-static unsigned long long get_mmap_min_addr(void)
-{
-	FILE *fp;
-	int n_matched;
-	static unsigned long long addr;
-
-	if (addr)
-		return addr;
-
-	fp = fopen("/proc/sys/vm/mmap_min_addr", "r");
-	if (fp == NULL) {
-		ksft_print_msg("Failed to open /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		exit(KSFT_SKIP);
-	}
-
-	n_matched = fscanf(fp, "%llu", &addr);
-	if (n_matched != 1) {
-		ksft_print_msg("Failed to read /proc/sys/vm/mmap_min_addr: %s\n",
-			strerror(errno));
-		fclose(fp);
-		exit(KSFT_SKIP);
-	}
-
-	fclose(fp);
-	return addr;
-}
-
 /*
  * Returns the start address of the mapping on success, else returns
  * NULL on failure.
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9eac68ae291e..0816b8018cde 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4172,8 +4172,11 @@ static int kvm_ioctl_create_device(struct kvm *kvm,
 		kvm_put_kvm_no_destroy(kvm);
 		mutex_lock(&kvm->lock);
 		list_del(&dev->vm_node);
+		if (ops->release)
+			ops->release(dev);
 		mutex_unlock(&kvm->lock);
-		ops->destroy(dev);
+		if (ops->destroy)
+			ops->destroy(dev);
 		return ret;
 	}
 
