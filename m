Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61FC26D78CF
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 11:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237806AbjDEJtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 05:49:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbjDEJsF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 05:48:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35975FD7;
        Wed,  5 Apr 2023 02:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D93A62358;
        Wed,  5 Apr 2023 09:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DDC2C433EF;
        Wed,  5 Apr 2023 09:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680688039;
        bh=eBZCf6rY1nXgZxI6vtMOTIQh5tnNfgXDdt7aeCDKHM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xJS6aGfnRU8dxAqEKPlGO79fKNbkWIuyeHL3QtB0kXktMWFMZQ/+Quk5JDPVWCF/c
         oL6nNNfxMT8k+wOZ/OobxGa9BLaUl5xmmn5MgISvtiFckMRwztY+LJCNLJEOhHqY0/
         JnKqRiDSY4dwvCTx55/ES+c3vSf9i1wjNZ3vnV3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.177
Date:   Wed,  5 Apr 2023 11:47:10 +0200
Message-Id: <2023040509-cleaver-greedily-5352@gregkh>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <2023040508-huff-cannot-479f@gregkh>
References: <2023040508-huff-cannot-479f@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 71caf5938361..ae202cc53158 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 176
+SUBLEVEL = 177
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/boot/dts/e60k02.dtsi b/arch/arm/boot/dts/e60k02.dtsi
index 3af1ab4458ef..bd1f58ae2374 100644
--- a/arch/arm/boot/dts/e60k02.dtsi
+++ b/arch/arm/boot/dts/e60k02.dtsi
@@ -296,6 +296,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
diff --git a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
index caa279608803..0fd126db4e5d 100644
--- a/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
+++ b/arch/arm/boot/dts/imx6sl-tolino-shine2hd.dts
@@ -580,6 +580,7 @@ &usdhc3 {
 
 &usbotg1 {
 	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usbotg1>;
 	disable-over-current;
 	srp-disable;
 	hnp-disable;
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index b2a31afb998c..7d42c84649ac 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -30,6 +30,7 @@
 #include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/kallsyms.h>
+#include <linux/extable.h>
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
@@ -549,7 +550,8 @@ static inline void bus_error030 (struct frame *fp)
 			errorcode |= 2;
 
 		if (mmusr & (MMU_I | MMU_WP)) {
-			if (ssw & 4) {
+			/* We might have an exception table for this PC */
+			if (ssw & 4 && !search_exception_tables(fp->ptregs.pc)) {
 				pr_err("Data %s fault at %#010lx in %s (pc=%#lx)\n",
 				       ssw & RW ? "read" : "write",
 				       fp->un.fmtb.daddr,
diff --git a/arch/mips/bmips/dma.c b/arch/mips/bmips/dma.c
index 49061b870680..daef44f68298 100644
--- a/arch/mips/bmips/dma.c
+++ b/arch/mips/bmips/dma.c
@@ -64,6 +64,8 @@ phys_addr_t dma_to_phys(struct device *dev, dma_addr_t dma_addr)
 	return dma_addr;
 }
 
+bool bmips_rac_flush_disable;
+
 void arch_sync_dma_for_cpu_all(void)
 {
 	void __iomem *cbr = BMIPS_GET_CBR();
@@ -74,6 +76,9 @@ void arch_sync_dma_for_cpu_all(void)
 	    boot_cpu_type() != CPU_BMIPS4380)
 		return;
 
+	if (unlikely(bmips_rac_flush_disable))
+		return;
+
 	/* Flush stale data out of the readahead cache */
 	cfg = __raw_readl(cbr + BMIPS_RAC_CONFIG);
 	__raw_writel(cfg | 0x100, cbr + BMIPS_RAC_CONFIG);
diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index 1b06b25aea87..16063081d61e 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -34,6 +34,8 @@
 #define REG_BCM6328_OTP		((void __iomem *)CKSEG1ADDR(0x1000062c))
 #define BCM6328_TP1_DISABLED	BIT(9)
 
+extern bool bmips_rac_flush_disable;
+
 static const unsigned long kbase = VMLINUX_LOAD_ADDRESS & 0xfff00000;
 
 struct bmips_quirk {
@@ -103,6 +105,12 @@ static void bcm6358_quirks(void)
 	 * disable SMP for now
 	 */
 	bmips_smp_enabled = 0;
+
+	/*
+	 * RAC flush causes kernel panics on BCM6358 when booting from TP1
+	 * because the bootloader is not initializing it properly.
+	 */
+	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31));
 }
 
 static void bcm6368_quirks(void)
diff --git a/arch/powerpc/kernel/ptrace/ptrace-view.c b/arch/powerpc/kernel/ptrace/ptrace-view.c
index 7e6478e7ed07..67c126d4f431 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-view.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-view.c
@@ -298,6 +298,9 @@ static int gpr_set(struct task_struct *target, const struct user_regset *regset,
 static int ppr_get(struct task_struct *target, const struct user_regset *regset,
 		   struct membuf to)
 {
+	if (!target->thread.regs)
+		return -EINVAL;
+
 	return membuf_write(&to, &target->thread.regs->ppr, sizeof(u64));
 }
 
@@ -305,6 +308,9 @@ static int ppr_set(struct task_struct *target, const struct user_regset *regset,
 		   unsigned int pos, unsigned int count, const void *kbuf,
 		   const void __user *ubuf)
 {
+	if (!target->thread.regs)
+		return -EINVAL;
+
 	return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 				  &target->thread.regs->ppr, 0, sizeof(u64));
 }
diff --git a/arch/riscv/include/uapi/asm/setup.h b/arch/riscv/include/uapi/asm/setup.h
new file mode 100644
index 000000000000..66b13a522880
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/setup.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
+
+#ifndef _UAPI_ASM_RISCV_SETUP_H
+#define _UAPI_ASM_RISCV_SETUP_H
+
+#define COMMAND_LINE_SIZE	1024
+
+#endif /* _UAPI_ASM_RISCV_SETUP_H */
diff --git a/arch/s390/lib/uaccess.c b/arch/s390/lib/uaccess.c
index 0267405ab7c6..fcfd78f99cb4 100644
--- a/arch/s390/lib/uaccess.c
+++ b/arch/s390/lib/uaccess.c
@@ -339,7 +339,7 @@ static inline unsigned long clear_user_mvcos(void __user *to, unsigned long size
 		"4: slgr  %0,%0\n"
 		"5:\n"
 		EX_TABLE(0b,2b) EX_TABLE(3b,5b)
-		: "+a" (size), "+a" (to), "+a" (tmp1), "=a" (tmp2)
+		: "+&a" (size), "+&a" (to), "+a" (tmp1), "=&a" (tmp2)
 		: "a" (empty_zero_page), "d" (reg0) : "cc", "memory");
 	return size;
 }
diff --git a/arch/sh/include/asm/processor_32.h b/arch/sh/include/asm/processor_32.h
index aa92cc933889..6c7966e62775 100644
--- a/arch/sh/include/asm/processor_32.h
+++ b/arch/sh/include/asm/processor_32.h
@@ -50,6 +50,7 @@
 #define SR_FD		0x00008000
 #define SR_MD		0x40000000
 
+#define SR_USER_MASK	0x00000303	// M, Q, S, T bits
 /*
  * DSP structure and data
  */
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index dd3092911efa..dc13702003f0 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -115,6 +115,7 @@ static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p)
 {
 	unsigned int err = 0;
+	unsigned int sr = regs->sr & ~SR_USER_MASK;
 
 #define COPY(x)		err |= __get_user(regs->x, &sc->sc_##x)
 			COPY(regs[1]);
@@ -130,6 +131,8 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, int *r0_p
 	COPY(sr);	COPY(pc);
 #undef COPY
 
+	regs->sr = (regs->sr & SR_USER_MASK) | sr;
+
 #ifdef CONFIG_SH_FPU
 	if (boot_cpu_data.flags & CPU_HAS_FPU) {
 		int owned_fp;
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 129f23c0ab55..6af68305b795 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -503,7 +503,7 @@ static size_t kstack_depth_to_print = CONFIG_PRINT_STACK_DEPTH;
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
-	size_t len;
+	size_t len, off = 0;
 
 	if (!sp)
 		sp = stack_pointer(task);
@@ -512,9 +512,17 @@ void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 		  kstack_depth_to_print * STACK_DUMP_ENTRY_SIZE);
 
 	printk("%sStack:\n", loglvl);
-	print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
-		       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
-		       sp, len, false);
+	while (off < len) {
+		u8 line[STACK_DUMP_LINE_SIZE];
+		size_t line_len = len - off > STACK_DUMP_LINE_SIZE ?
+			STACK_DUMP_LINE_SIZE : len - off;
+
+		__memcpy(line, (u8 *)sp + off, line_len);
+		print_hex_dump(loglvl, " ", DUMP_PREFIX_NONE,
+			       STACK_DUMP_LINE_SIZE, STACK_DUMP_ENTRY_SIZE,
+			       line, line_len, false);
+		off += STACK_DUMP_LINE_SIZE;
+	}
 	show_trace(task, sp, loglvl);
 }
 
diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index 82f6f1fbe9e7..a217b50439e7 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -2915,6 +2915,7 @@ close_card_oam(struct idt77252_dev *card)
 
 				recycle_rx_pool_skb(card, &vc->rcv.rx_pool);
 			}
+			kfree(vc);
 		}
 	}
 }
@@ -2958,6 +2959,15 @@ open_card_ubr0(struct idt77252_dev *card)
 	return 0;
 }
 
+static void
+close_card_ubr0(struct idt77252_dev *card)
+{
+	struct vc_map *vc = card->vcs[0];
+
+	free_scq(card, vc->scq);
+	kfree(vc);
+}
+
 static int
 idt77252_dev_open(struct idt77252_dev *card)
 {
@@ -3007,6 +3017,7 @@ static void idt77252_dev_close(struct atm_dev *dev)
 	struct idt77252_dev *card = dev->dev_data;
 	u32 conf;
 
+	close_card_ubr0(card);
 	close_card_oam(card);
 
 	conf = SAR_CFG_RXPTH |	/* enable receive path           */
diff --git a/drivers/bluetooth/btqcomsmd.c b/drivers/bluetooth/btqcomsmd.c
index 2acb719e596f..11c7e04bf394 100644
--- a/drivers/bluetooth/btqcomsmd.c
+++ b/drivers/bluetooth/btqcomsmd.c
@@ -122,6 +122,21 @@ static int btqcomsmd_setup(struct hci_dev *hdev)
 	return 0;
 }
 
+static int btqcomsmd_set_bdaddr(struct hci_dev *hdev, const bdaddr_t *bdaddr)
+{
+	int ret;
+
+	ret = qca_set_bdaddr_rome(hdev, bdaddr);
+	if (ret)
+		return ret;
+
+	/* The firmware stops responding for a while after setting the bdaddr,
+	 * causing timeouts for subsequent commands. Sleep a bit to avoid this.
+	 */
+	usleep_range(1000, 10000);
+	return 0;
+}
+
 static int btqcomsmd_probe(struct platform_device *pdev)
 {
 	struct btqcomsmd *btq;
@@ -162,7 +177,7 @@ static int btqcomsmd_probe(struct platform_device *pdev)
 	hdev->close = btqcomsmd_close;
 	hdev->send = btqcomsmd_send;
 	hdev->setup = btqcomsmd_setup;
-	hdev->set_bdaddr = qca_set_bdaddr_rome;
+	hdev->set_bdaddr = btqcomsmd_set_bdaddr;
 
 	ret = hci_register_dev(hdev);
 	if (ret < 0)
diff --git a/drivers/bluetooth/btsdio.c b/drivers/bluetooth/btsdio.c
index 199e8f7d426d..7050a16e7efe 100644
--- a/drivers/bluetooth/btsdio.c
+++ b/drivers/bluetooth/btsdio.c
@@ -352,6 +352,7 @@ static void btsdio_remove(struct sdio_func *func)
 
 	BT_DBG("func %p", func);
 
+	cancel_work_sync(&data->work);
 	if (!data)
 		return;
 
diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 28bb65a5613f..201767823edb 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -192,8 +192,8 @@ static int weim_parse_dt(struct platform_device *pdev, void __iomem *base)
 	const struct of_device_id *of_id = of_match_device(weim_id_table,
 							   &pdev->dev);
 	const struct imx_weim_devtype *devtype = of_id->data;
+	int ret = 0, have_child = 0;
 	struct device_node *child;
-	int ret, have_child = 0;
 	struct cs_timing_state ts = {};
 	u32 reg;
 
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 0f2bac24e564..20dc2452815c 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -74,7 +74,8 @@
 /*
  * Timer values
  */
-#define SSIF_MSG_USEC		20000	/* 20ms between message tries. */
+#define SSIF_MSG_USEC		60000	/* 60ms between message tries (T3). */
+#define SSIF_REQ_RETRY_USEC	60000	/* 60ms between send retries (T6). */
 #define SSIF_MSG_PART_USEC	5000	/* 5ms for a message part */
 
 /* How many times to we retry sending/receiving the message. */
@@ -82,7 +83,9 @@
 #define	SSIF_RECV_RETRIES	250
 
 #define SSIF_MSG_MSEC		(SSIF_MSG_USEC / 1000)
+#define SSIF_REQ_RETRY_MSEC	(SSIF_REQ_RETRY_USEC / 1000)
 #define SSIF_MSG_JIFFIES	((SSIF_MSG_USEC * 1000) / TICK_NSEC)
+#define SSIF_REQ_RETRY_JIFFIES	((SSIF_REQ_RETRY_USEC * 1000) / TICK_NSEC)
 #define SSIF_MSG_PART_JIFFIES	((SSIF_MSG_PART_USEC * 1000) / TICK_NSEC)
 
 /*
@@ -229,6 +232,9 @@ struct ssif_info {
 	bool		    got_alert;
 	bool		    waiting_alert;
 
+	/* Used to inform the timeout that it should do a resend. */
+	bool		    do_resend;
+
 	/*
 	 * If set to true, this will request events the next time the
 	 * state machine is idle.
@@ -510,7 +516,7 @@ static int ipmi_ssif_thread(void *data)
 	return 0;
 }
 
-static int ssif_i2c_send(struct ssif_info *ssif_info,
+static void ssif_i2c_send(struct ssif_info *ssif_info,
 			ssif_i2c_done handler,
 			int read_write, int command,
 			unsigned char *data, unsigned int size)
@@ -522,7 +528,6 @@ static int ssif_i2c_send(struct ssif_info *ssif_info,
 	ssif_info->i2c_data = data;
 	ssif_info->i2c_size = size;
 	complete(&ssif_info->wake_thread);
-	return 0;
 }
 
 
@@ -531,40 +536,36 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 static void start_get(struct ssif_info *ssif_info)
 {
-	int rv;
-
 	ssif_info->rtc_us_timer = 0;
 	ssif_info->multi_pos = 0;
 
-	rv = ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
-			  SSIF_IPMI_RESPONSE,
-			  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
-	if (rv < 0) {
-		/* request failed, just return the error. */
-		if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-			dev_dbg(&ssif_info->client->dev,
-				"Error from i2c_non_blocking_op(5)\n");
-
-		msg_done_handler(ssif_info, -EIO, NULL, 0);
-	}
+	ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
+		  SSIF_IPMI_RESPONSE,
+		  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
 }
 
+static void start_resend(struct ssif_info *ssif_info);
+
 static void retry_timeout(struct timer_list *t)
 {
 	struct ssif_info *ssif_info = from_timer(ssif_info, t, retry_timer);
 	unsigned long oflags, *flags;
-	bool waiting;
+	bool waiting, resend;
 
 	if (ssif_info->stopping)
 		return;
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
+	resend = ssif_info->do_resend;
+	ssif_info->do_resend = false;
 	waiting = ssif_info->waiting_alert;
 	ssif_info->waiting_alert = false;
 	ipmi_ssif_unlock_cond(ssif_info, flags);
 
 	if (waiting)
 		start_get(ssif_info);
+	if (resend)
+		start_resend(ssif_info);
 }
 
 static void watch_timeout(struct timer_list *t)
@@ -613,14 +614,11 @@ static void ssif_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		start_get(ssif_info);
 }
 
-static int start_resend(struct ssif_info *ssif_info);
-
 static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			     unsigned char *data, unsigned int len)
 {
 	struct ipmi_smi_msg *msg;
 	unsigned long oflags, *flags;
-	int rv;
 
 	/*
 	 * We are single-threaded here, so no need for a lock until we
@@ -666,17 +664,10 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 		ssif_info->multi_len = len;
 		ssif_info->multi_pos = 1;
 
-		rv = ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
-				  SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
-				  ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
-		if (rv < 0) {
-			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-				dev_dbg(&ssif_info->client->dev,
-					"Error from i2c_non_blocking_op(1)\n");
-
-			result = -EIO;
-		} else
-			return;
+		ssif_i2c_send(ssif_info, msg_done_handler, I2C_SMBUS_READ,
+			 SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
+			 ssif_info->recv, I2C_SMBUS_BLOCK_DATA);
+		return;
 	} else if (ssif_info->multi_pos) {
 		/* Middle of multi-part read.  Start the next transaction. */
 		int i;
@@ -738,19 +729,12 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 
 			ssif_info->multi_pos++;
 
-			rv = ssif_i2c_send(ssif_info, msg_done_handler,
-					   I2C_SMBUS_READ,
-					   SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
-					   ssif_info->recv,
-					   I2C_SMBUS_BLOCK_DATA);
-			if (rv < 0) {
-				if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-					dev_dbg(&ssif_info->client->dev,
-						"Error from ssif_i2c_send\n");
-
-				result = -EIO;
-			} else
-				return;
+			ssif_i2c_send(ssif_info, msg_done_handler,
+				  I2C_SMBUS_READ,
+				  SSIF_IPMI_MULTI_PART_RESPONSE_MIDDLE,
+				  ssif_info->recv,
+				  I2C_SMBUS_BLOCK_DATA);
+			return;
 		}
 	}
 
@@ -931,37 +915,27 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 static void msg_written_handler(struct ssif_info *ssif_info, int result,
 				unsigned char *data, unsigned int len)
 {
-	int rv;
-
 	/* We are single-threaded here, so no need for a lock. */
 	if (result < 0) {
 		ssif_info->retries_left--;
 		if (ssif_info->retries_left > 0) {
-			if (!start_resend(ssif_info)) {
-				ssif_inc_stat(ssif_info, send_retries);
-				return;
-			}
-			/* request failed, just return the error. */
-			ssif_inc_stat(ssif_info, send_errors);
-
-			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-				dev_dbg(&ssif_info->client->dev,
-					"%s: Out of retries\n", __func__);
-			msg_done_handler(ssif_info, -EIO, NULL, 0);
+			/*
+			 * Wait the retry timeout time per the spec,
+			 * then redo the send.
+			 */
+			ssif_info->do_resend = true;
+			mod_timer(&ssif_info->retry_timer,
+				  jiffies + SSIF_REQ_RETRY_JIFFIES);
 			return;
 		}
 
 		ssif_inc_stat(ssif_info, send_errors);
 
-		/*
-		 * Got an error on transmit, let the done routine
-		 * handle it.
-		 */
 		if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
 			dev_dbg(&ssif_info->client->dev,
-				"%s: Error  %d\n", __func__, result);
+				"%s: Out of retries\n", __func__);
 
-		msg_done_handler(ssif_info, result, NULL, 0);
+		msg_done_handler(ssif_info, -EIO, NULL, 0);
 		return;
 	}
 
@@ -995,18 +969,9 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 			ssif_info->multi_data = NULL;
 		}
 
-		rv = ssif_i2c_send(ssif_info, msg_written_handler,
-				   I2C_SMBUS_WRITE, cmd,
-				   data_to_send, I2C_SMBUS_BLOCK_DATA);
-		if (rv < 0) {
-			/* request failed, just return the error. */
-			ssif_inc_stat(ssif_info, send_errors);
-
-			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-				dev_dbg(&ssif_info->client->dev,
-					"Error from i2c_non_blocking_op(3)\n");
-			msg_done_handler(ssif_info, -EIO, NULL, 0);
-		}
+		ssif_i2c_send(ssif_info, msg_written_handler,
+			  I2C_SMBUS_WRITE, cmd,
+			  data_to_send, I2C_SMBUS_BLOCK_DATA);
 	} else {
 		/* Ready to request the result. */
 		unsigned long oflags, *flags;
@@ -1033,9 +998,8 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 	}
 }
 
-static int start_resend(struct ssif_info *ssif_info)
+static void start_resend(struct ssif_info *ssif_info)
 {
-	int rv;
 	int command;
 
 	ssif_info->got_alert = false;
@@ -1057,12 +1021,8 @@ static int start_resend(struct ssif_info *ssif_info)
 		ssif_info->data[0] = ssif_info->data_len;
 	}
 
-	rv = ssif_i2c_send(ssif_info, msg_written_handler, I2C_SMBUS_WRITE,
-			  command, ssif_info->data, I2C_SMBUS_BLOCK_DATA);
-	if (rv && (ssif_info->ssif_debug & SSIF_DEBUG_MSG))
-		dev_dbg(&ssif_info->client->dev,
-			"Error from i2c_non_blocking_op(4)\n");
-	return rv;
+	ssif_i2c_send(ssif_info, msg_written_handler, I2C_SMBUS_WRITE,
+		   command, ssif_info->data, I2C_SMBUS_BLOCK_DATA);
 }
 
 static int start_send(struct ssif_info *ssif_info,
@@ -1077,7 +1037,8 @@ static int start_send(struct ssif_info *ssif_info,
 	ssif_info->retries_left = SSIF_SEND_RETRIES;
 	memcpy(ssif_info->data + 1, data, len);
 	ssif_info->data_len = len;
-	return start_resend(ssif_info);
+	start_resend(ssif_info);
+	return 0;
 }
 
 /* Must be called with the message lock held. */
@@ -1377,8 +1338,10 @@ static int do_cmd(struct i2c_client *client, int len, unsigned char *msg,
 	ret = i2c_smbus_write_block_data(client, SSIF_IPMI_REQUEST, len, msg);
 	if (ret) {
 		retry_cnt--;
-		if (retry_cnt > 0)
+		if (retry_cnt > 0) {
+			msleep(SSIF_REQ_RETRY_MSEC);
 			goto retry1;
+		}
 		return -ENODEV;
 	}
 
@@ -1519,8 +1482,10 @@ static int start_multipart_test(struct i2c_client *client,
 					 32, msg);
 	if (ret) {
 		retry_cnt--;
-		if (retry_cnt > 0)
+		if (retry_cnt > 0) {
+			msleep(SSIF_REQ_RETRY_MSEC);
 			goto retry_write;
+		}
 		dev_err(&client->dev, "Could not write multi-part start, though the BMC said it could handle it.  Just limit sends to one part.\n");
 		return ret;
 	}
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 4626404be541..ad773a657ed2 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -52,6 +52,39 @@ static bool mailbox_chan_available(struct device *dev, int idx)
 					   "#mbox-cells", idx, NULL);
 }
 
+static int mailbox_chan_validate(struct device *cdev)
+{
+	int num_mb, num_sh, ret = 0;
+	struct device_node *np = cdev->of_node;
+
+	num_mb = of_count_phandle_with_args(np, "mboxes", "#mbox-cells");
+	num_sh = of_count_phandle_with_args(np, "shmem", NULL);
+	/* Bail out if mboxes and shmem descriptors are inconsistent */
+	if (num_mb <= 0 || num_sh > 2 || num_mb != num_sh) {
+		dev_warn(cdev, "Invalid channel descriptor for '%s'\n",
+			 of_node_full_name(np));
+		return -EINVAL;
+	}
+
+	if (num_sh > 1) {
+		struct device_node *np_tx, *np_rx;
+
+		np_tx = of_parse_phandle(np, "shmem", 0);
+		np_rx = of_parse_phandle(np, "shmem", 1);
+		/* SCMI Tx and Rx shared mem areas have to be distinct */
+		if (!np_tx || !np_rx || np_tx == np_rx) {
+			dev_warn(cdev, "Invalid shmem descriptor for '%s'\n",
+				 of_node_full_name(np));
+			ret = -EINVAL;
+		}
+
+		of_node_put(np_tx);
+		of_node_put(np_rx);
+	}
+
+	return ret;
+}
+
 static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 			      bool tx)
 {
@@ -64,6 +97,10 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 	resource_size_t size;
 	struct resource res;
 
+	ret = mailbox_chan_validate(cdev);
+	if (ret)
+		return ret;
+
 	smbox = devm_kzalloc(dev, sizeof(*smbox), GFP_KERNEL);
 	if (!smbox)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index d617e98afb76..767b3d31c720 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -164,6 +164,21 @@ static bool needs_dsc_aux_workaround(struct dc_link *link)
 	return false;
 }
 
+bool is_synaptics_cascaded_panamera(struct dc_link *link, struct drm_dp_mst_port *port)
+{
+	u8 branch_vendor_data[4] = { 0 }; // Vendor data 0x50C ~ 0x50F
+
+	if (drm_dp_dpcd_read(port->mgr->aux, DP_BRANCH_VENDOR_SPECIFIC_START, &branch_vendor_data, 4) == 4) {
+		if (link->dpcd_caps.branch_dev_id == DP_BRANCH_DEVICE_ID_90CC24 &&
+				IS_SYNAPTICS_CASCADED_PANAMERA(link->dpcd_caps.branch_dev_name, branch_vendor_data)) {
+			DRM_INFO("Synaptics Cascaded MST hub\n");
+			return true;
+		}
+	}
+
+	return false;
+}
+
 static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnector)
 {
 	struct dc_sink *dc_sink = aconnector->dc_sink;
@@ -185,6 +200,10 @@ static bool validate_dsc_caps_on_connector(struct amdgpu_dm_connector *aconnecto
 	    needs_dsc_aux_workaround(aconnector->dc_link))
 		aconnector->dsc_aux = &aconnector->mst_port->dm_dp_aux.aux;
 
+	/* synaptics cascaded MST hub case */
+	if (!aconnector->dsc_aux && is_synaptics_cascaded_panamera(aconnector->dc_link, port))
+		aconnector->dsc_aux = port->mgr->aux;
+
 	if (!aconnector->dsc_aux)
 		return false;
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
index b38bd68121ce..5d60e2bf0bd8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.h
@@ -26,6 +26,18 @@
 #ifndef __DAL_AMDGPU_DM_MST_TYPES_H__
 #define __DAL_AMDGPU_DM_MST_TYPES_H__
 
+#define DP_BRANCH_VENDOR_SPECIFIC_START 0x50C
+
+/**
+ * Panamera MST Hub detection
+ * Offset DPCD 050Eh == 0x5A indicates cascaded MST hub case
+ * Check from beginning of branch device vendor specific field (050Ch)
+ */
+#define IS_SYNAPTICS_PANAMERA(branchDevName) (((int)branchDevName[4] & 0xF0) == 0x50 ? 1 : 0)
+#define BRANCH_HW_REVISION_PANAMERA_A2 0x10
+#define SYNAPTICS_CASCADED_HUB_ID  0x5A
+#define IS_SYNAPTICS_CASCADED_PANAMERA(devName, data) ((IS_SYNAPTICS_PANAMERA(devName) && ((int)data[2] == SYNAPTICS_CASCADED_HUB_ID)) ? 1 : 0)
+
 struct amdgpu_display_manager;
 struct amdgpu_dm_connector;
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
index 4aa3426a9ba4..33974cc57e32 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_prime.c
@@ -93,7 +93,15 @@ static void *etnaviv_gem_prime_vmap_impl(struct etnaviv_gem_object *etnaviv_obj)
 static int etnaviv_gem_prime_mmap_obj(struct etnaviv_gem_object *etnaviv_obj,
 		struct vm_area_struct *vma)
 {
-	return dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+	int ret;
+
+	ret = dma_buf_mmap(etnaviv_obj->base.dma_buf, vma, 0);
+	if (!ret) {
+		/* Drop the reference acquired by drm_gem_mmap_obj(). */
+		drm_gem_object_put(&etnaviv_obj->base);
+	}
+
+	return ret;
 }
 
 static const struct etnaviv_gem_ops etnaviv_gem_prime_ops = {
diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
index 45c2556d6395..d46011f7a838 100644
--- a/drivers/gpu/drm/i915/display/intel_display.c
+++ b/drivers/gpu/drm/i915/display/intel_display.c
@@ -13335,6 +13335,7 @@ intel_crtc_prepare_cleared_state(struct intel_crtc_state *crtc_state)
 	 * only fields that are know to not cause problems are preserved. */
 
 	saved_state->uapi = crtc_state->uapi;
+	saved_state->inherited = crtc_state->inherited;
 	saved_state->scaler_state = crtc_state->scaler_state;
 	saved_state->shared_dpll = crtc_state->shared_dpll;
 	saved_state->dpll_hw_state = crtc_state->dpll_hw_state;
diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 0532a5069c04..cae9ac6379a5 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -96,8 +96,7 @@ static void debug_active_init(struct i915_active *ref)
 static void debug_active_activate(struct i915_active *ref)
 {
 	lockdep_assert_held(&ref->tree_lock);
-	if (!atomic_read(&ref->count)) /* before the first inc */
-		debug_object_activate(ref, &active_debug_desc);
+	debug_object_activate(ref, &active_debug_desc);
 }
 
 static void debug_active_deactivate(struct i915_active *ref)
diff --git a/drivers/gpu/drm/meson/meson_drv.c b/drivers/gpu/drm/meson/meson_drv.c
index b0bfe85f5f6a..5c29ddf93eb3 100644
--- a/drivers/gpu/drm/meson/meson_drv.c
+++ b/drivers/gpu/drm/meson/meson_drv.c
@@ -320,38 +320,38 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 	if (priv->afbcd.ops) {
 		ret = priv->afbcd.ops->init(priv);
 		if (ret)
-			return ret;
+			goto free_drm;
 	}
 
 	/* Encoder Initialization */
 
 	ret = meson_venc_cvbs_create(priv);
 	if (ret)
-		goto free_drm;
+		goto exit_afbcd;
 
 	if (has_components) {
 		ret = component_bind_all(drm->dev, drm);
 		if (ret) {
 			dev_err(drm->dev, "Couldn't bind all components\n");
-			goto free_drm;
+			goto exit_afbcd;
 		}
 	}
 
 	ret = meson_plane_create(priv);
 	if (ret)
-		goto free_drm;
+		goto unbind_all;
 
 	ret = meson_overlay_create(priv);
 	if (ret)
-		goto free_drm;
+		goto unbind_all;
 
 	ret = meson_crtc_create(priv);
 	if (ret)
-		goto free_drm;
+		goto unbind_all;
 
 	ret = drm_irq_install(drm, priv->vsync_irq);
 	if (ret)
-		goto free_drm;
+		goto unbind_all;
 
 	drm_mode_config_reset(drm);
 
@@ -369,6 +369,12 @@ static int meson_drv_bind_master(struct device *dev, bool has_components)
 
 uninstall_irq:
 	drm_irq_uninstall(drm);
+unbind_all:
+	if (has_components)
+		component_unbind_all(drm->dev, drm);
+exit_afbcd:
+	if (priv->afbcd.ops)
+		priv->afbcd.ops->exit(priv);
 free_drm:
 	drm_dev_put(drm);
 
diff --git a/drivers/gpu/drm/sun4i/sun4i_drv.c b/drivers/gpu/drm/sun4i/sun4i_drv.c
index c5912fd53772..9c6ae8cfa0b2 100644
--- a/drivers/gpu/drm/sun4i/sun4i_drv.c
+++ b/drivers/gpu/drm/sun4i/sun4i_drv.c
@@ -93,7 +93,7 @@ static int sun4i_drv_bind(struct device *dev)
 	/* drm_vblank_init calls kcalloc, which can fail */
 	ret = drm_vblank_init(drm, drm->mode_config.num_crtc);
 	if (ret)
-		goto cleanup_mode_config;
+		goto unbind_all;
 
 	drm->irq_enabled = true;
 
@@ -117,6 +117,8 @@ static int sun4i_drv_bind(struct device *dev)
 
 finish_poll:
 	drm_kms_helper_poll_fini(drm);
+unbind_all:
+	component_unbind_all(dev, NULL);
 cleanup_mode_config:
 	drm_mode_config_cleanup(drm);
 	of_reserved_mem_device_release(dev);
diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 172f20e88c6c..d902fe43cb81 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1352,6 +1352,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	girq->parents = NULL;
 	girq->default_type = IRQ_TYPE_NONE;
 	girq->handler = handle_simple_irq;
+	girq->threaded = true;
 
 	ret = gpiochip_add_data(&dev->gc, dev);
 	if (ret < 0) {
diff --git a/drivers/hwmon/hwmon.c b/drivers/hwmon/hwmon.c
index d649fea82999..045dc3fd7953 100644
--- a/drivers/hwmon/hwmon.c
+++ b/drivers/hwmon/hwmon.c
@@ -700,6 +700,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 {
 	struct hwmon_device *hwdev;
 	struct device *hdev;
+	struct device *tdev = dev;
 	int i, err, id;
 
 	/* Complain about invalid characters in hwmon name attribute */
@@ -757,7 +758,9 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 	hwdev->name = name;
 	hdev->class = &hwmon_class;
 	hdev->parent = dev;
-	hdev->of_node = dev ? dev->of_node : NULL;
+	while (tdev && !tdev->of_node)
+		tdev = tdev->parent;
+	hdev->of_node = tdev ? tdev->of_node : NULL;
 	hwdev->chip = chip;
 	dev_set_drvdata(hdev, drvdata);
 	dev_set_name(hdev, HWMON_ID_FORMAT, id);
@@ -769,7 +772,7 @@ __hwmon_device_register(struct device *dev, const char *name, void *drvdata,
 
 	INIT_LIST_HEAD(&hwdev->tzdata);
 
-	if (dev && dev->of_node && chip && chip->ops->read &&
+	if (hdev->of_node && chip && chip->ops->read &&
 	    chip->info[0]->type == hwmon_chip &&
 	    (chip->info[0]->config[0] & HWMON_C_REGISTER_TZ)) {
 		err = hwmon_thermal_register_sensors(hdev);
diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index fac9b5c68a6a..85413d3dc394 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -486,6 +486,8 @@ static const struct it87_devices it87_devices[] = {
 #define has_pwm_freq2(data)	((data)->features & FEAT_PWM_FREQ2)
 #define has_six_temp(data)	((data)->features & FEAT_SIX_TEMP)
 #define has_vin3_5v(data)	((data)->features & FEAT_VIN3_5V)
+#define has_scaling(data)	((data)->features & (FEAT_12MV_ADC | \
+						     FEAT_10_9MV_ADC))
 
 struct it87_sio_data {
 	int sioaddr;
@@ -3098,7 +3100,7 @@ static int it87_probe(struct platform_device *pdev)
 			 "Detected broken BIOS defaults, disabling PWM interface\n");
 
 	/* Starting with IT8721F, we handle scaling of internal voltages */
-	if (has_12mv_adc(data)) {
+	if (has_scaling(data)) {
 		if (sio_data->internal & BIT(0))
 			data->in_scaled |= BIT(3);	/* in3 is AVCC */
 		if (sio_data->internal & BIT(1))
diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 8b9ba055c418..2018dbcf241e 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -502,10 +502,14 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 static irqreturn_t lpi2c_imx_isr(int irq, void *dev_id)
 {
 	struct lpi2c_imx_struct *lpi2c_imx = dev_id;
+	unsigned int enabled;
 	unsigned int temp;
 
+	enabled = readl(lpi2c_imx->base + LPI2C_MIER);
+
 	lpi2c_imx_intctrl(lpi2c_imx, 0);
 	temp = readl(lpi2c_imx->base + LPI2C_MSR);
+	temp &= enabled;
 
 	if (temp & MSR_RDF)
 		lpi2c_imx_read_rxfifo(lpi2c_imx);
diff --git a/drivers/i2c/busses/i2c-xgene-slimpro.c b/drivers/i2c/busses/i2c-xgene-slimpro.c
index 63cbb9c7c1b0..76e9dcd63856 100644
--- a/drivers/i2c/busses/i2c-xgene-slimpro.c
+++ b/drivers/i2c/busses/i2c-xgene-slimpro.c
@@ -308,6 +308,9 @@ static int slimpro_i2c_blkwr(struct slimpro_i2c_dev *ctx, u32 chip,
 	u32 msg[3];
 	int rc;
 
+	if (writelen > I2C_SMBUS_BLOCK_MAX)
+		return -EINVAL;
+
 	memcpy(ctx->dma_buffer, data, writelen);
 	paddr = dma_map_single(ctx->dev, ctx->dma_buffer, writelen,
 			       DMA_TO_DEVICE);
diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index b067bfd2699c..0b10c466659e 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -852,8 +852,8 @@ static void alps_process_packet_v6(struct psmouse *psmouse)
 			x = y = z = 0;
 
 		/* Divide 4 since trackpoint's speed is too fast */
-		input_report_rel(dev2, REL_X, (char)x / 4);
-		input_report_rel(dev2, REL_Y, -((char)y / 4));
+		input_report_rel(dev2, REL_X, (s8)x / 4);
+		input_report_rel(dev2, REL_Y, -((s8)y / 4));
 
 		psmouse_report_standard_buttons(dev2, packet[3]);
 
@@ -1104,8 +1104,8 @@ static void alps_process_trackstick_packet_v7(struct psmouse *psmouse)
 	    ((packet[3] & 0x20) << 1);
 	z = (packet[5] & 0x3f) | ((packet[3] & 0x80) >> 1);
 
-	input_report_rel(dev2, REL_X, (char)x);
-	input_report_rel(dev2, REL_Y, -((char)y));
+	input_report_rel(dev2, REL_X, (s8)x);
+	input_report_rel(dev2, REL_Y, -((s8)y));
 	input_report_abs(dev2, ABS_PRESSURE, z);
 
 	psmouse_report_standard_buttons(dev2, packet[1]);
@@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
 	if (reg < 0)
 		return reg;
 
-	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_pitch = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
 
-	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_pitch = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
 
 	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
 	if (reg < 0)
 		return reg;
 
-	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
+	x_electrode = (s8)(reg << 4) >> 4; /* sign extend lower 4 bits */
 	x_electrode = 17 + x_electrode;
 
-	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
+	y_electrode = (s8)reg >> 4; /* sign extend upper 4 bits */
 	y_electrode = 13 + y_electrode;
 
 	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */
diff --git a/drivers/input/mouse/focaltech.c b/drivers/input/mouse/focaltech.c
index 6fd5fff0cbff..c74b99077d16 100644
--- a/drivers/input/mouse/focaltech.c
+++ b/drivers/input/mouse/focaltech.c
@@ -202,8 +202,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	state->pressed = packet[0] >> 7;
 	finger1 = ((packet[0] >> 4) & 0x7) - 1;
 	if (finger1 < FOC_MAX_FINGERS) {
-		state->fingers[finger1].x += (char)packet[1];
-		state->fingers[finger1].y += (char)packet[2];
+		state->fingers[finger1].x += (s8)packet[1];
+		state->fingers[finger1].y += (s8)packet[2];
 	} else {
 		psmouse_err(psmouse, "First finger in rel packet invalid: %d\n",
 			    finger1);
@@ -218,8 +218,8 @@ static void focaltech_process_rel_packet(struct psmouse *psmouse,
 	 */
 	finger2 = ((packet[3] >> 4) & 0x7) - 1;
 	if (finger2 < FOC_MAX_FINGERS) {
-		state->fingers[finger2].x += (char)packet[4];
-		state->fingers[finger2].y += (char)packet[5];
+		state->fingers[finger2].x += (s8)packet[4];
+		state->fingers[finger2].y += (s8)packet[5];
 	}
 }
 
diff --git a/drivers/input/touchscreen/goodix.c b/drivers/input/touchscreen/goodix.c
index b7f87ad4b9a9..098115eb8084 100644
--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -183,10 +183,18 @@ static const unsigned long goodix_irq_flags[] = {
 static const struct dmi_system_id nine_bytes_report[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)
 	{
-		.ident = "Lenovo YogaBook",
-		/* YB1-X91L/F and YB1-X90L/F */
+		/* Lenovo Yoga Book X90F / X90L */
 		.matches = {
-			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X9")
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "YETI-11"),
+		}
+	},
+	{
+		/* Lenovo Yoga Book X91F / X91L */
+		.matches = {
+			/* Non exact match to match F + L versions */
+			DMI_MATCH(DMI_PRODUCT_NAME, "Lenovo YB1-X91"),
 		}
 	},
 #endif
diff --git a/drivers/interconnect/qcom/osm-l3.c b/drivers/interconnect/qcom/osm-l3.c
index 695f28789e98..08a282d57320 100644
--- a/drivers/interconnect/qcom/osm-l3.c
+++ b/drivers/interconnect/qcom/osm-l3.c
@@ -258,7 +258,7 @@ static int qcom_osm_l3_probe(struct platform_device *pdev)
 	qnodes = desc->nodes;
 	num_nodes = desc->num_nodes;
 
-	data = devm_kcalloc(&pdev->dev, num_nodes, sizeof(*node), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, struct_size(data, nodes, num_nodes), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3d975db86434..5d772f322a24 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -67,7 +67,9 @@ struct dm_crypt_io {
 	struct crypt_config *cc;
 	struct bio *base_bio;
 	u8 *integrity_metadata;
-	bool integrity_metadata_from_pool;
+	bool integrity_metadata_from_pool:1;
+	bool in_tasklet:1;
+
 	struct work_struct work;
 	struct tasklet_struct tasklet;
 
@@ -1722,6 +1724,7 @@ static void crypt_io_init(struct dm_crypt_io *io, struct crypt_config *cc,
 	io->ctx.r.req = NULL;
 	io->integrity_metadata = NULL;
 	io->integrity_metadata_from_pool = false;
+	io->in_tasklet = false;
 	atomic_set(&io->io_pending, 0);
 }
 
@@ -1767,14 +1770,13 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	 * our tasklet. In this case we need to delay bio_endio()
 	 * execution to after the tasklet is done and dequeued.
 	 */
-	if (tasklet_trylock(&io->tasklet)) {
-		tasklet_unlock(&io->tasklet);
-		bio_endio(base_bio);
+	if (io->in_tasklet) {
+		INIT_WORK(&io->work, kcryptd_io_bio_endio);
+		queue_work(cc->io_queue, &io->work);
 		return;
 	}
 
-	INIT_WORK(&io->work, kcryptd_io_bio_endio);
-	queue_work(cc->io_queue, &io->work);
+	bio_endio(base_bio);
 }
 
 /*
@@ -1934,6 +1936,7 @@ static int dmcrypt_write(void *data)
 			io = crypt_io_from_node(rb_first(&write_tree));
 			rb_erase(&io->rb_node, &write_tree);
 			kcryptd_io_write(io);
+			cond_resched();
 		} while (!RB_EMPTY_ROOT(&write_tree));
 		blk_finish_plug(&plug);
 	}
@@ -2227,6 +2230,7 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io)
 		 * it is being executed with irqs disabled.
 		 */
 		if (in_irq() || irqs_disabled()) {
+			io->in_tasklet = true;
 			tasklet_init(&io->tasklet, kcryptd_crypt_tasklet, (unsigned long)&io->work);
 			tasklet_schedule(&io->tasklet);
 			return;
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 55443a6598fa..4029281ca383 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -188,7 +188,7 @@ static int dm_stat_in_flight(struct dm_stat_shared *shared)
 	       atomic_read(&shared->in_flight[WRITE]);
 }
 
-void dm_stats_init(struct dm_stats *stats)
+int dm_stats_init(struct dm_stats *stats)
 {
 	int cpu;
 	struct dm_stats_last_position *last;
@@ -196,11 +196,16 @@ void dm_stats_init(struct dm_stats *stats)
 	mutex_init(&stats->mutex);
 	INIT_LIST_HEAD(&stats->list);
 	stats->last = alloc_percpu(struct dm_stats_last_position);
+	if (!stats->last)
+		return -ENOMEM;
+
 	for_each_possible_cpu(cpu) {
 		last = per_cpu_ptr(stats->last, cpu);
 		last->last_sector = (sector_t)ULLONG_MAX;
 		last->last_rw = UINT_MAX;
 	}
+
+	return 0;
 }
 
 void dm_stats_cleanup(struct dm_stats *stats)
diff --git a/drivers/md/dm-stats.h b/drivers/md/dm-stats.h
index 2ddfae678f32..dcac11fce03b 100644
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -22,7 +22,7 @@ struct dm_stats_aux {
 	unsigned long long duration_ns;
 };
 
-void dm_stats_init(struct dm_stats *st);
+int dm_stats_init(struct dm_stats *st);
 void dm_stats_cleanup(struct dm_stats *st);
 
 struct mapped_device;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c890bb3e5185..93140743a999 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3383,6 +3383,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 
 	/*
 	 * Only need to enable discards if the pool should pass
@@ -4259,6 +4260,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 
 	ti->num_flush_bios = 1;
+	ti->limit_swap_bios = true;
 	ti->flush_supported = true;
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c60febd14be1..9029c1004b93 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1910,7 +1910,9 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->bdev)
 		goto bad;
 
-	dm_stats_init(&md->stats);
+	r = dm_stats_init(&md->stats);
+	if (r < 0)
+		goto bad;
 
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0b34637bd66..1553c2495841 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3207,6 +3207,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot == -1) {
 		/* Setting 'slot' on an active array requires also
diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 38f490088d76..dc631c514318 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -172,6 +172,7 @@ struct meson_nfc {
 
 	dma_addr_t daddr;
 	dma_addr_t iaddr;
+	u32 info_bytes;
 
 	unsigned long assigned_cs;
 };
@@ -499,6 +500,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
 					 nfc->daddr, datalen, dir);
 			return ret;
 		}
+		nfc->info_bytes = infolen;
 		cmd = GENCMDIADDRL(NFC_CMD_AIL, nfc->iaddr);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
@@ -516,8 +518,10 @@ static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
 	struct meson_nfc *nfc = nand_get_controller_data(nand);
 
 	dma_unmap_single(nfc->dev, nfc->daddr, datalen, dir);
-	if (infolen)
+	if (infolen) {
 		dma_unmap_single(nfc->dev, nfc->iaddr, infolen, dir);
+		nfc->info_bytes = 0;
+	}
 }
 
 static int meson_nfc_read_buf(struct nand_chip *nand, u8 *buf, int len)
@@ -706,6 +710,8 @@ static void meson_nfc_check_ecc_pages_valid(struct meson_nfc *nfc,
 		usleep_range(10, 15);
 		/* info is updated by nfc dma engine*/
 		smp_rmb();
+		dma_sync_single_for_cpu(nfc->dev, nfc->iaddr, nfc->info_bytes,
+					DMA_FROM_DEVICE);
 		ret = *info & ECC_COMPLETE;
 	} while (!ret);
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index a253476a52b0..0b104a90c0d8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2611,9 +2611,14 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
 	 * If this is the upstream port for this switch, enable
 	 * forwarding of unknown unicasts and multicasts.
 	 */
-	reg = MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP |
-		MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
+	reg = MV88E6185_PORT_CTL0_USE_TAG | MV88E6185_PORT_CTL0_USE_IP |
 		MV88E6XXX_PORT_CTL0_STATE_FORWARDING;
+	/* Forward any IPv4 IGMP or IPv6 MLD frames received
+	 * by a USER port to the CPU port to allow snooping.
+	 */
+	if (dsa_is_user_port(ds, port))
+		reg |= MV88E6XXX_PORT_CTL0_IGMP_MLD_SNOOP;
+
 	err = mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_CTL0, reg);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6928c0b578ab..3a9fcf942a6d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -219,12 +219,12 @@ static const struct pci_device_id bnxt_pci_tbl[] = {
 	{ PCI_VDEVICE(BROADCOM, 0x1750), .driver_data = BCM57508 },
 	{ PCI_VDEVICE(BROADCOM, 0x1751), .driver_data = BCM57504 },
 	{ PCI_VDEVICE(BROADCOM, 0x1752), .driver_data = BCM57502 },
-	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1800), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1801), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57502_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1802), .driver_data = BCM57508_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1803), .driver_data = BCM57502_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0x1804), .driver_data = BCM57504_NPAR },
-	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57502_NPAR },
+	{ PCI_VDEVICE(BROADCOM, 0x1805), .driver_data = BCM57508_NPAR },
 	{ PCI_VDEVICE(BROADCOM, 0xd802), .driver_data = BCM58802 },
 	{ PCI_VDEVICE(BROADCOM, 0xd804), .driver_data = BCM58804 },
 #ifdef CONFIG_BNXT_SRIOV
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 34affd1de91d..b7b07beb17ff 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1198,6 +1198,7 @@ struct bnxt_link_info {
 #define BNXT_LINK_SPEED_40GB	PORT_PHY_QCFG_RESP_LINK_SPEED_40GB
 #define BNXT_LINK_SPEED_50GB	PORT_PHY_QCFG_RESP_LINK_SPEED_50GB
 #define BNXT_LINK_SPEED_100GB	PORT_PHY_QCFG_RESP_LINK_SPEED_100GB
+#define BNXT_LINK_SPEED_200GB	PORT_PHY_QCFG_RESP_LINK_SPEED_200GB
 	u16			support_speeds;
 	u16			support_pam4_speeds;
 	u16			auto_link_speeds;	/* fw adv setting */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 81b63d1c2391..1e67e86fc334 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1653,6 +1653,8 @@ u32 bnxt_fw_to_ethtool_speed(u16 fw_link_speed)
 		return SPEED_50000;
 	case BNXT_LINK_SPEED_100GB:
 		return SPEED_100000;
+	case BNXT_LINK_SPEED_200GB:
+		return SPEED_200000;
 	default:
 		return SPEED_UNKNOWN;
 	}
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index c53a04313944..e0449cc24fbd 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -510,7 +510,10 @@ static int gve_get_link_ksettings(struct net_device *netdev,
 				  struct ethtool_link_ksettings *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
-	int err = gve_adminq_report_link_speed(priv);
+	int err = 0;
+
+	if (priv->link_speed == 0)
+		err = gve_adminq_report_link_speed(priv);
 
 	cmd->base.speed = priv->link_speed;
 	return err;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.c b/drivers/net/ethernet/intel/i40e/i40e_diag.c
index ef4d3762bf37..ca229b0efeb6 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.c
@@ -44,7 +44,7 @@ static i40e_status i40e_diag_reg_pattern_test(struct i40e_hw *hw,
 	return 0;
 }
 
-struct i40e_diag_reg_test_info i40e_reg_list[] = {
+const struct i40e_diag_reg_test_info i40e_reg_list[] = {
 	/* offset               mask         elements   stride */
 	{I40E_QTX_CTL(0),       0x0000FFBF, 1,
 		I40E_QTX_CTL(1) - I40E_QTX_CTL(0)},
@@ -78,27 +78,28 @@ i40e_status i40e_diag_reg_test(struct i40e_hw *hw)
 {
 	i40e_status ret_code = 0;
 	u32 reg, mask;
+	u32 elements;
 	u32 i, j;
 
 	for (i = 0; i40e_reg_list[i].offset != 0 &&
 					     !ret_code; i++) {
 
+		elements = i40e_reg_list[i].elements;
 		/* set actual reg range for dynamically allocated resources */
 		if (i40e_reg_list[i].offset == I40E_QTX_CTL(0) &&
 		    hw->func_caps.num_tx_qp != 0)
-			i40e_reg_list[i].elements = hw->func_caps.num_tx_qp;
+			elements = hw->func_caps.num_tx_qp;
 		if ((i40e_reg_list[i].offset == I40E_PFINT_ITRN(0, 0) ||
 		     i40e_reg_list[i].offset == I40E_PFINT_ITRN(1, 0) ||
 		     i40e_reg_list[i].offset == I40E_PFINT_ITRN(2, 0) ||
 		     i40e_reg_list[i].offset == I40E_QINT_TQCTL(0) ||
 		     i40e_reg_list[i].offset == I40E_QINT_RQCTL(0)) &&
 		    hw->func_caps.num_msix_vectors != 0)
-			i40e_reg_list[i].elements =
-				hw->func_caps.num_msix_vectors - 1;
+			elements = hw->func_caps.num_msix_vectors - 1;
 
 		/* test register access */
 		mask = i40e_reg_list[i].mask;
-		for (j = 0; j < i40e_reg_list[i].elements && !ret_code; j++) {
+		for (j = 0; j < elements && !ret_code; j++) {
 			reg = i40e_reg_list[i].offset +
 			      (j * i40e_reg_list[i].stride);
 			ret_code = i40e_diag_reg_pattern_test(hw, reg, mask);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_diag.h b/drivers/net/ethernet/intel/i40e/i40e_diag.h
index c3340f320a18..1db7c6d57231 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_diag.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_diag.h
@@ -20,7 +20,7 @@ struct i40e_diag_reg_test_info {
 	u32 stride;	/* bytes between each element */
 };
 
-extern struct i40e_diag_reg_test_info i40e_reg_list[];
+extern const struct i40e_diag_reg_test_info i40e_reg_list[];
 
 i40e_status i40e_diag_reg_test(struct i40e_hw *hw);
 i40e_status i40e_diag_eeprom_test(struct i40e_hw *hw);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_common.c b/drivers/net/ethernet/intel/iavf/iavf_common.c
index 8547fc8fdfd6..78423ca401b2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_common.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_common.c
@@ -662,7 +662,7 @@ struct iavf_rx_ptype_decoded iavf_ptype_lookup[] = {
 	/* Non Tunneled IPv6 */
 	IAVF_PTT(88, IP, IPV6, FRG, NONE, NONE, NOF, NONE, PAY3),
 	IAVF_PTT(89, IP, IPV6, NOF, NONE, NONE, NOF, NONE, PAY3),
-	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY3),
+	IAVF_PTT(90, IP, IPV6, NOF, NONE, NONE, NOF, UDP,  PAY4),
 	IAVF_PTT_UNUSED_ENTRY(91),
 	IAVF_PTT(92, IP, IPV6, NOF, NONE, NONE, NOF, TCP,  PAY4),
 	IAVF_PTT(93, IP, IPV6, NOF, NONE, NONE, NOF, SCTP, PAY4),
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index d481a922f018..f411e683eb15 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -1061,7 +1061,7 @@ static inline void iavf_rx_hash(struct iavf_ring *ring,
 		cpu_to_le64((u64)IAVF_RX_DESC_FLTSTAT_RSS_HASH <<
 			    IAVF_RX_DESC_STATUS_FLTSTAT_SHIFT);
 
-	if (ring->netdev->features & NETIF_F_RXHASH)
+	if (!(ring->netdev->features & NETIF_F_RXHASH))
 		return;
 
 	if ((rx_desc->wb.qword1.status_error_len & rss_mask) == rss_mask) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 0ea8e4024d63..c5f465814dec 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -3821,9 +3821,7 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_release_hw_control(adapter);
 
 #ifdef CONFIG_PCI_IOV
-	rtnl_lock();
 	igb_disable_sriov(pdev);
-	rtnl_unlock();
 #endif
 
 	unregister_netdev(netdev);
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index fe8c0a26b720..037ec90ed56c 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1074,7 +1074,7 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 			  igbvf_intr_msix_rx, 0, adapter->rx_ring->name,
 			  netdev);
 	if (err)
-		goto out;
+		goto free_irq_tx;
 
 	adapter->rx_ring->itr_register = E1000_EITR(vector);
 	adapter->rx_ring->itr_val = adapter->current_itr;
@@ -1083,10 +1083,14 @@ static int igbvf_request_msix(struct igbvf_adapter *adapter)
 	err = request_irq(adapter->msix_entries[vector].vector,
 			  igbvf_msix_other, 0, netdev->name, netdev);
 	if (err)
-		goto out;
+		goto free_irq_rx;
 
 	igbvf_configure_msix(adapter);
 	return 0;
+free_irq_rx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
+free_irq_tx:
+	free_irq(adapter->msix_entries[--vector].vector, netdev);
 out:
 	return err;
 }
diff --git a/drivers/net/ethernet/intel/igbvf/vf.c b/drivers/net/ethernet/intel/igbvf/vf.c
index b8ba3f94c363..a47a2e3e548c 100644
--- a/drivers/net/ethernet/intel/igbvf/vf.c
+++ b/drivers/net/ethernet/intel/igbvf/vf.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2009 - 2018 Intel Corporation. */
 
+#include <linux/etherdevice.h>
+
 #include "vf.h"
 
 static s32 e1000_check_for_link_vf(struct e1000_hw *hw);
@@ -131,11 +133,16 @@ static s32 e1000_reset_hw_vf(struct e1000_hw *hw)
 		/* set our "perm_addr" based on info provided by PF */
 		ret_val = mbx->ops.read_posted(hw, msgbuf, 3);
 		if (!ret_val) {
-			if (msgbuf[0] == (E1000_VF_RESET |
-					  E1000_VT_MSGTYPE_ACK))
+			switch (msgbuf[0]) {
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_ACK:
 				memcpy(hw->mac.perm_addr, addr, ETH_ALEN);
-			else
+				break;
+			case E1000_VF_RESET | E1000_VT_MSGTYPE_NACK:
+				eth_zero_addr(hw->mac.perm_addr);
+				break;
+			default:
 				ret_val = -E1000_ERR_MAC_INIT;
+			}
 		}
 	}
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 1a0aae7b128d..3aa0efb542aa 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4874,18 +4874,18 @@ static bool validate_schedule(struct igc_adapter *adapter,
 		if (e->command != TC_TAPRIO_CMD_SET_GATES)
 			return false;
 
-		for (i = 0; i < adapter->num_tx_queues; i++) {
-			if (e->gate_mask & BIT(i))
+		for (i = 0; i < adapter->num_tx_queues; i++)
+			if (e->gate_mask & BIT(i)) {
 				queue_uses[i]++;
 
-			/* There are limitations: A single queue cannot be
-			 * opened and closed multiple times per cycle unless the
-			 * gate stays open. Check for it.
-			 */
-			if (queue_uses[i] > 1 &&
-			    !(prev->gate_mask & BIT(i)))
-				return false;
-		}
+				/* There are limitations: A single queue cannot
+				 * be opened and closed multiple times per cycle
+				 * unless the gate stays open. Check for it.
+				 */
+				if (queue_uses[i] > 1 &&
+				    !(prev->gate_mask & BIT(i)))
+					return false;
+			}
 	}
 
 	return true;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 7c0ae7c38eef..c25fb0cbde27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -117,12 +117,14 @@ static int mlx5e_dcbnl_ieee_getets(struct net_device *netdev,
 	if (!MLX5_CAP_GEN(priv->mdev, ets))
 		return -EOPNOTSUPP;
 
-	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
-	for (i = 0; i < ets->ets_cap; i++) {
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
 		err = mlx5_query_port_prio_tc(mdev, i, &ets->prio_tc[i]);
 		if (err)
 			return err;
+	}
 
+	ets->ets_cap = mlx5_max_tc(priv->mdev) + 1;
+	for (i = 0; i < ets->ets_cap; i++) {
 		err = mlx5_query_port_tc_group(mdev, i, &tc_group[i]);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 548c005ea633..90a10230bf0c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -301,8 +301,7 @@ int mlx5_esw_acl_ingress_vport_bond_update(struct mlx5_eswitch *esw, u16 vport_n
 
 	if (WARN_ON_ONCE(IS_ERR(vport))) {
 		esw_warn(esw->dev, "vport(%d) invalid!\n", vport_num);
-		err = PTR_ERR(vport);
-		goto out;
+		return PTR_ERR(vport);
 	}
 
 	esw_acl_ingress_ofld_rules_destroy(esw, vport);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 78cc6f0bbc72..3ae082c72a2b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1339,6 +1339,7 @@ static void esw_disable_vport(struct mlx5_eswitch *esw, u16 vport_num)
 	 */
 	esw_vport_change_handle_locked(vport);
 	vport->enabled_events = 0;
+	esw_apply_vport_rx_mode(esw, vport, false, false);
 	esw_vport_cleanup(esw, vport);
 	esw->enabled_vports--;
 
diff --git a/drivers/net/ethernet/natsemi/sonic.c b/drivers/net/ethernet/natsemi/sonic.c
index d17d1b4f2585..825356ee3492 100644
--- a/drivers/net/ethernet/natsemi/sonic.c
+++ b/drivers/net/ethernet/natsemi/sonic.c
@@ -292,7 +292,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	 */
 
 	laddr = dma_map_single(lp->device, skb->data, length, DMA_TO_DEVICE);
-	if (!laddr) {
+	if (dma_mapping_error(lp->device, laddr)) {
 		pr_err_ratelimited("%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb_any(skb);
 		return NETDEV_TX_OK;
@@ -509,7 +509,7 @@ static bool sonic_alloc_rb(struct net_device *dev, struct sonic_local *lp,
 
 	*new_addr = dma_map_single(lp->device, skb_put(*new_skb, SONIC_RBSIZE),
 				   SONIC_RBSIZE, DMA_FROM_DEVICE);
-	if (!*new_addr) {
+	if (dma_mapping_error(lp->device, *new_addr)) {
 		dev_kfree_skb(*new_skb);
 		*new_skb = NULL;
 		return false;
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 3541bc95493f..b2a2beb84e54 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4378,6 +4378,9 @@ qed_iov_configure_min_tx_rate(struct qed_dev *cdev, int vfid, u32 rate)
 	}
 
 	vf = qed_iov_get_vf_info(QED_LEADING_HWFN(cdev), (u16)vfid, true);
+	if (!vf)
+		return -EINVAL;
+
 	vport_id = vf->vport_id;
 
 	return qed_configure_vport_wfq(cdev, vport_id, rate);
@@ -5123,7 +5126,7 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		/* Validate that the VF has a configured vport */
 		vf = qed_iov_get_vf_info(hwfn, i, true);
-		if (!vf->vport_instance)
+		if (!vf || !vf->vport_instance)
 			continue;
 
 		memset(&params, 0, sizeof(params));
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index ad655f0a4965..e1aa56be9cc0 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -728,9 +728,15 @@ static int emac_remove(struct platform_device *pdev)
 	struct net_device *netdev = dev_get_drvdata(&pdev->dev);
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
+	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
+
 	unregister_netdev(netdev);
 	netif_napi_del(&adpt->rx_q.napi);
 
+	free_irq(adpt->irq.irq, &adpt->irq);
+	cancel_work_sync(&adpt->work_thread);
+
 	emac_clks_teardown(adpt);
 
 	put_device(&adpt->phydev->mdio.dev);
diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index 913d030d73eb..e18a76f5049f 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -970,6 +970,9 @@ static void rtl8168h_2_hw_phy_config(struct rtl8169_private *tp,
 	/* disable phy pfm mode */
 	phy_modify_paged(phydev, 0x0a44, 0x11, BIT(7), 0);
 
+	/* disable 10m pll off */
+	phy_modify_paged(phydev, 0x0a43, 0x10, BIT(0), 0);
+
 	rtl8168g_disable_aldps(phydev);
 	rtl8168g_config_eee_phy(phydev);
 }
diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index eb1be7302082..32654fe1f8b5 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1304,7 +1304,8 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	struct net_device *net_dev = efx->net_dev;
+	netdev_features_t tun_feats, tso_feats;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1349,20 +1350,30 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
-	/* add encapsulated checksum offload features */
+	/* encap features might change during reset if fw variant changed */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	/* add encapsulated TSO features */
-	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
-		netdev_features_t encap_tso_features;
+		net_dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	else
+		net_dev->hw_enc_features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tun_feats = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
+		    NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tso_feats = NETIF_F_TSO | NETIF_F_TSO6;
 
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
-		efx->net_dev->features |= encap_tso_features;
+	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
+		/* If this is first nic_init, or if it is a reset and a new fw
+		 * variant has added new features, enable them by default.
+		 * If the features are not new, maintain their current value.
+		 */
+		if (!(net_dev->hw_features & tun_feats))
+			net_dev->features |= tun_feats;
+		net_dev->hw_enc_features |= tun_feats | tso_feats;
+		net_dev->hw_features |= tun_feats;
+	} else {
+		net_dev->hw_enc_features &= ~(tun_feats | tso_feats);
+		net_dev->hw_features &= ~tun_feats;
+		net_dev->features &= ~tun_feats;
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
@@ -3977,7 +3988,10 @@ static unsigned int ef10_check_caps(const struct efx_nic *efx,
 	 NETIF_F_HW_VLAN_CTAG_FILTER |	\
 	 NETIF_F_IPV6_CSUM |		\
 	 NETIF_F_RXHASH |		\
-	 NETIF_F_NTUPLE)
+	 NETIF_F_NTUPLE |		\
+	 NETIF_F_SG |			\
+	 NETIF_F_RXCSUM |		\
+	 NETIF_F_RXALL)
 
 const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.is_vf = true,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 29c8d2c99004..c069659c9e2d 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1045,21 +1045,18 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
-		net_dev->features |= NETIF_F_TSO6;
-		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
-			net_dev->hw_enc_features |= NETIF_F_TSO6;
-	}
-	/* Check whether device supports TSO */
-	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+	net_dev->features |= efx->type->offload_features;
+
+	/* Add TSO features */
+	if (efx->type->tso_versions && efx->type->tso_versions(efx))
+		net_dev->features |= NETIF_F_TSO | NETIF_F_TSO6;
+
 	/* Mask for features that also apply to VLAN devices */
 	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
 				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
 				   NETIF_F_RXCSUM);
 
+	/* Determine user configurable features */
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
 	/* Disable receiving frames with bad FCS, by default. */
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index df7de50497a0..af4303523929 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -480,7 +480,6 @@ struct mac_device_info {
 	unsigned int xlgmac;
 	unsigned int num_vlan;
 	u32 vlan_filter[32];
-	unsigned int promisc;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 5b052fdd2696..cd11be005390 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -453,12 +453,6 @@ static int dwmac4_add_hw_vlan_rx_fltr(struct net_device *dev,
 	if (vid > 4095)
 		return -EINVAL;
 
-	if (hw->promisc) {
-		netdev_err(dev,
-			   "Adding VLAN in promisc mode not supported\n");
-		return -EPERM;
-	}
-
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		/* For single VLAN filter, VID 0 means VLAN promiscuous */
@@ -508,12 +502,6 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 {
 	int i, ret = 0;
 
-	if (hw->promisc) {
-		netdev_err(dev,
-			   "Deleting VLAN in promisc mode not supported\n");
-		return -EPERM;
-	}
-
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		if ((hw->vlan_filter[0] & GMAC_VLAN_TAG_VID) == vid) {
@@ -538,39 +526,6 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 	return ret;
 }
 
-static void dwmac4_vlan_promisc_enable(struct net_device *dev,
-				       struct mac_device_info *hw)
-{
-	void __iomem *ioaddr = hw->pcsr;
-	u32 value;
-	u32 hash;
-	u32 val;
-	int i;
-
-	/* Single Rx VLAN Filter */
-	if (hw->num_vlan == 1) {
-		dwmac4_write_single_vlan(dev, 0);
-		return;
-	}
-
-	/* Extended Rx VLAN Filter Enable */
-	for (i = 0; i < hw->num_vlan; i++) {
-		if (hw->vlan_filter[i] & GMAC_VLAN_TAG_DATA_VEN) {
-			val = hw->vlan_filter[i] & ~GMAC_VLAN_TAG_DATA_VEN;
-			dwmac4_write_vlan_filter(dev, hw, i, val);
-		}
-	}
-
-	hash = readl(ioaddr + GMAC_VLAN_HASH_TABLE);
-	if (hash & GMAC_VLAN_VLHT) {
-		value = readl(ioaddr + GMAC_VLAN_TAG);
-		if (value & GMAC_VLAN_VTHM) {
-			value &= ~GMAC_VLAN_VTHM;
-			writel(value, ioaddr + GMAC_VLAN_TAG);
-		}
-	}
-}
-
 static void dwmac4_restore_hw_vlan_rx_fltr(struct net_device *dev,
 					   struct mac_device_info *hw)
 {
@@ -690,22 +645,12 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	}
 
 	/* VLAN filtering */
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (dev->flags & IFF_PROMISC && !hw->vlan_fail_q_en)
+		value &= ~GMAC_PACKET_FILTER_VTFE;
+	else if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		value |= GMAC_PACKET_FILTER_VTFE;
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
-
-	if (dev->flags & IFF_PROMISC && !hw->vlan_fail_q_en) {
-		if (!hw->promisc) {
-			hw->promisc = 1;
-			dwmac4_vlan_promisc_enable(dev, hw);
-		}
-	} else {
-		if (hw->promisc) {
-			hw->promisc = 0;
-			dwmac4_restore_hw_vlan_rx_fltr(dev, hw);
-		}
-	}
 }
 
 static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index d9a5722f561b..524098a7b658 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -317,15 +317,17 @@ static int gelic_card_init_chain(struct gelic_card *card,
 
 	/* set up the hardware pointers in each descriptor */
 	for (i = 0; i < no; i++, descr++) {
+		dma_addr_t cpu_addr;
+
 		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
-		descr->bus_addr =
-			dma_map_single(ctodev(card), descr,
-				       GELIC_DESCR_SIZE,
-				       DMA_BIDIRECTIONAL);
 
-		if (!descr->bus_addr)
+		cpu_addr = dma_map_single(ctodev(card), descr,
+					  GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
+
+		if (dma_mapping_error(ctodev(card), cpu_addr))
 			goto iommu_error;
 
+		descr->bus_addr = cpu_to_be32(cpu_addr);
 		descr->next = descr + 1;
 		descr->prev = descr - 1;
 	}
@@ -365,26 +367,28 @@ static int gelic_card_init_chain(struct gelic_card *card,
  *
  * allocates a new rx skb, iommu-maps it and attaches it to the descriptor.
  * Activate the descriptor state-wise
+ *
+ * Gelic RX sk_buffs must be aligned to GELIC_NET_RXBUF_ALIGN and the length
+ * must be a multiple of GELIC_NET_RXBUF_ALIGN.
  */
 static int gelic_descr_prepare_rx(struct gelic_card *card,
 				  struct gelic_descr *descr)
 {
+	static const unsigned int rx_skb_size =
+		ALIGN(GELIC_NET_MAX_FRAME, GELIC_NET_RXBUF_ALIGN) +
+		GELIC_NET_RXBUF_ALIGN - 1;
+	dma_addr_t cpu_addr;
 	int offset;
-	unsigned int bufsize;
 
 	if (gelic_descr_get_status(descr) !=  GELIC_DESCR_DMA_NOT_IN_USE)
 		dev_info(ctodev(card), "%s: ERROR status\n", __func__);
-	/* we need to round up the buffer size to a multiple of 128 */
-	bufsize = ALIGN(GELIC_NET_MAX_MTU, GELIC_NET_RXBUF_ALIGN);
 
-	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
-	descr->skb = dev_alloc_skb(bufsize + GELIC_NET_RXBUF_ALIGN - 1);
+	descr->skb = netdev_alloc_skb(*card->netdev, rx_skb_size);
 	if (!descr->skb) {
 		descr->buf_addr = 0; /* tell DMAC don't touch memory */
 		return -ENOMEM;
 	}
-	descr->buf_size = cpu_to_be32(bufsize);
+	descr->buf_size = cpu_to_be32(rx_skb_size);
 	descr->dmac_cmd_status = 0;
 	descr->result_size = 0;
 	descr->valid_size = 0;
@@ -395,11 +399,10 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
 	if (offset)
 		skb_reserve(descr->skb, GELIC_NET_RXBUF_ALIGN - offset);
 	/* io-mmu-map the skb */
-	descr->buf_addr = cpu_to_be32(dma_map_single(ctodev(card),
-						     descr->skb->data,
-						     GELIC_NET_MAX_MTU,
-						     DMA_FROM_DEVICE));
-	if (!descr->buf_addr) {
+	cpu_addr = dma_map_single(ctodev(card), descr->skb->data,
+				  GELIC_NET_MAX_FRAME, DMA_FROM_DEVICE);
+	descr->buf_addr = cpu_to_be32(cpu_addr);
+	if (dma_mapping_error(ctodev(card), cpu_addr)) {
 		dev_kfree_skb_any(descr->skb);
 		descr->skb = NULL;
 		dev_info(ctodev(card),
@@ -779,7 +782,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
 
 	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
 
-	if (!buf) {
+	if (dma_mapping_error(ctodev(card), buf)) {
 		dev_err(ctodev(card),
 			"dma map 2 failed (%p, %i). Dropping packet\n",
 			skb->data, skb->len);
@@ -915,7 +918,7 @@ static void gelic_net_pass_skb_up(struct gelic_descr *descr,
 	data_error = be32_to_cpu(descr->data_error);
 	/* unmap skb buffer */
 	dma_unmap_single(ctodev(card), be32_to_cpu(descr->buf_addr),
-			 GELIC_NET_MAX_MTU,
+			 GELIC_NET_MAX_FRAME,
 			 DMA_FROM_DEVICE);
 
 	skb_put(skb, be32_to_cpu(descr->valid_size)?
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.h b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
index 68f324ed4eaf..0d98defb011e 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.h
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.h
@@ -19,8 +19,9 @@
 #define GELIC_NET_RX_DESCRIPTORS        128 /* num of descriptors */
 #define GELIC_NET_TX_DESCRIPTORS        128 /* num of descriptors */
 
-#define GELIC_NET_MAX_MTU               VLAN_ETH_FRAME_LEN
-#define GELIC_NET_MIN_MTU               VLAN_ETH_ZLEN
+#define GELIC_NET_MAX_FRAME             2312
+#define GELIC_NET_MAX_MTU               2294
+#define GELIC_NET_MIN_MTU               64
 #define GELIC_NET_RXBUF_ALIGN           128
 #define GELIC_CARD_RX_CSUM_DEFAULT      1 /* hw chksum */
 #define GELIC_NET_WATCHDOG_TIMEOUT      5*HZ
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 3e337142b516..56cef59c1c87 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -503,6 +503,11 @@ static void
 xirc2ps_detach(struct pcmcia_device *link)
 {
     struct net_device *dev = link->priv;
+    struct local_info *local = netdev_priv(dev);
+
+    netif_carrier_off(dev);
+    netif_tx_disable(dev);
+    cancel_work_sync(&local->tx_timeout_task);
 
     dev_dbg(&link->dev, "detach\n");
 
diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index 95ef3b6f98dd..1c5d70c60354 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -1945,10 +1945,9 @@ static int ca8210_skb_tx(
 	struct ca8210_priv  *priv
 )
 {
-	int status;
 	struct ieee802154_hdr header = { };
 	struct secspec secspec;
-	unsigned int mac_len;
+	int mac_len, status;
 
 	dev_dbg(&priv->spi->dev, "%s called\n", __func__);
 
@@ -1956,6 +1955,8 @@ static int ca8210_skb_tx(
 	 * packet
 	 */
 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
+	if (mac_len < 0)
+		return mac_len;
 
 	secspec.security_level = header.sec.level;
 	secspec.key_id_mode = header.sec.key_id_mode;
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 70c2b585f98d..1e0d62639301 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -159,7 +159,7 @@ int gsi_trans_pool_init_dma(struct device *dev, struct gsi_trans_pool *pool,
 	 * gsi_trans_pool_exit_dma() can assume the total allocated
 	 * size is exactly (count * size).
 	 */
-	total_size = get_order(total_size) << PAGE_SHIFT;
+	total_size = PAGE_SIZE << get_order(total_size);
 
 	virt = dma_alloc_coherent(dev, total_size, &addr, GFP_KERNEL);
 	if (!virt)
diff --git a/drivers/net/mdio/mdio-thunder.c b/drivers/net/mdio/mdio-thunder.c
index 822d2cdd2f35..394b864aaa37 100644
--- a/drivers/net/mdio/mdio-thunder.c
+++ b/drivers/net/mdio/mdio-thunder.c
@@ -104,6 +104,7 @@ static int thunder_mdiobus_pci_probe(struct pci_dev *pdev,
 		if (i >= ARRAY_SIZE(nexus->buses))
 			break;
 	}
+	fwnode_handle_put(fwn);
 	return 0;
 
 err_release_regions:
diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 5bae47f3da40..b254127cea50 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -238,21 +238,23 @@ bool of_mdiobus_child_is_phy(struct device_node *child)
 EXPORT_SYMBOL(of_mdiobus_child_is_phy);
 
 /**
- * of_mdiobus_register - Register mii_bus and create PHYs from the device tree
+ * __of_mdiobus_register - Register mii_bus and create PHYs from the device tree
  * @mdio: pointer to mii_bus structure
  * @np: pointer to device_node of MDIO bus.
+ * @owner: module owning the @mdio object.
  *
  * This function registers the mii_bus structure and registers a phy_device
  * for each child node of @np.
  */
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner)
 {
 	struct device_node *child;
 	bool scanphys = false;
 	int addr, rc;
 
 	if (!np)
-		return mdiobus_register(mdio);
+		return __mdiobus_register(mdio, owner);
 
 	/* Do not continue if the node is disabled */
 	if (!of_device_is_available(np))
@@ -272,7 +274,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
 
 	/* Register the MDIO bus */
-	rc = mdiobus_register(mdio);
+	rc = __mdiobus_register(mdio, owner);
 	if (rc)
 		return rc;
 
@@ -336,7 +338,7 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	mdiobus_unregister(mdio);
 	return rc;
 }
-EXPORT_SYMBOL(of_mdiobus_register);
+EXPORT_SYMBOL(__of_mdiobus_register);
 
 /**
  * of_mdio_find_device - Given a device tree node, find the mdio_device
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index fb182bec8f06..6b7bba720d8c 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -130,14 +130,10 @@ static u16 net_failover_select_queue(struct net_device *dev,
 			txq = ops->ndo_select_queue(primary_dev, skb, sb_dev);
 		else
 			txq = netdev_pick_tx(primary_dev, skb, NULL);
-
-		qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
-
-		return txq;
+	} else {
+		txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
 	}
 
-	txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) : 0;
-
 	/* Save the original txq to restore before passing to the driver */
 	qdisc_skb_cb(skb)->slave_dev_queue_mapping = skb->queue_mapping;
 
diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index a9daff88006b..65b69ff35e40 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -553,15 +553,13 @@ static int dp83869_of_init(struct phy_device *phydev)
 						       &dp83869_internal_delay[0],
 						       delay_size, true);
 	if (dp83869->rx_int_delay < 0)
-		dp83869->rx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->rx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	dp83869->tx_int_delay = phy_get_internal_delay(phydev, dev,
 						       &dp83869_internal_delay[0],
 						       delay_size, false);
 	if (dp83869->tx_int_delay < 0)
-		dp83869->tx_int_delay =
-				dp83869_internal_delay[DP83869_CLK_DELAY_DEF];
+		dp83869->tx_int_delay = DP83869_CLK_DELAY_DEF;
 
 	return ret;
 }
diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index b560e99695df..69b829e6ab35 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -98,13 +98,14 @@ EXPORT_SYMBOL(__devm_mdiobus_register);
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 /**
- * devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
+ * __devm_of_mdiobus_register - Resource managed variant of of_mdiobus_register()
  * @dev:	Device to register mii_bus for
  * @mdio:	MII bus structure to register
  * @np:		Device node to parse
+ * @owner:	Owning module
  */
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np)
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner)
 {
 	struct mdiobus_devres *dr;
 	int ret;
@@ -117,7 +118,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	if (!dr)
 		return -ENOMEM;
 
-	ret = of_mdiobus_register(mdio, np);
+	ret = __of_mdiobus_register(mdio, np, owner);
 	if (ret) {
 		devres_free(dr);
 		return ret;
@@ -127,7 +128,7 @@ int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
 	devres_add(dev, dr);
 	return 0;
 }
-EXPORT_SYMBOL(devm_of_mdiobus_register);
+EXPORT_SYMBOL(__devm_of_mdiobus_register);
 #endif /* CONFIG_OF_MDIO */
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 18e67eb6d8b4..f3e606b6617e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -56,6 +56,18 @@ static const char *phy_state_to_str(enum phy_state st)
 	return NULL;
 }
 
+static void phy_process_state_change(struct phy_device *phydev,
+				     enum phy_state old_state)
+{
+	if (old_state != phydev->state) {
+		phydev_dbg(phydev, "PHY state change %s -> %s\n",
+			   phy_state_to_str(old_state),
+			   phy_state_to_str(phydev->state));
+		if (phydev->drv && phydev->drv->link_change_notify)
+			phydev->drv->link_change_notify(phydev);
+	}
+}
+
 static void phy_link_up(struct phy_device *phydev)
 {
 	phydev->phy_link_change(phydev, true);
@@ -1110,6 +1122,7 @@ EXPORT_SYMBOL(phy_free_interrupt);
 void phy_stop(struct phy_device *phydev)
 {
 	struct net_device *dev = phydev->attached_dev;
+	enum phy_state old_state;
 
 	if (!phy_is_started(phydev) && phydev->state != PHY_DOWN) {
 		WARN(1, "called from state %s\n",
@@ -1118,6 +1131,7 @@ void phy_stop(struct phy_device *phydev)
 	}
 
 	mutex_lock(&phydev->lock);
+	old_state = phydev->state;
 
 	if (phydev->state == PHY_CABLETEST) {
 		phy_abort_cable_test(phydev);
@@ -1128,6 +1142,7 @@ void phy_stop(struct phy_device *phydev)
 		sfp_upstream_stop(phydev->sfp_bus);
 
 	phydev->state = PHY_HALTED;
+	phy_process_state_change(phydev, old_state);
 
 	mutex_unlock(&phydev->lock);
 
@@ -1242,13 +1257,7 @@ void phy_state_machine(struct work_struct *work)
 	if (err < 0)
 		phy_error(phydev);
 
-	if (old_state != phydev->state) {
-		phydev_dbg(phydev, "PHY state change %s -> %s\n",
-			   phy_state_to_str(old_state),
-			   phy_state_to_str(phydev->state));
-		if (phydev->drv && phydev->drv->link_change_notify)
-			phydev->drv->link_change_notify(phydev);
-	}
+	phy_process_state_change(phydev, old_state);
 
 	/* Only re-schedule a PHY state machine change if we are polling the
 	 * PHY, if PHY_IGNORE_INTERRUPT is set, then we will be moving
diff --git a/drivers/net/usb/cdc_mbim.c b/drivers/net/usb/cdc_mbim.c
index 414341c9cf5a..6ad1fb00a35c 100644
--- a/drivers/net/usb/cdc_mbim.c
+++ b/drivers/net/usb/cdc_mbim.c
@@ -663,6 +663,11 @@ static const struct usb_device_id mbim_devs[] = {
 	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
 	},
 
+	/* Telit FE990 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x1bc7, 0x1081, USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&cdc_mbim_info_avoid_altsetting_toggle,
+	},
+
 	/* default entry */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MBIM, USB_CDC_PROTO_NONE),
 	  .driver_info = (unsigned long)&cdc_mbim_info_zlp,
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index bce151e3706a..070910567c44 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1297,6 +1297,7 @@ static const struct usb_device_id products[] = {
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)},	/* Telit FN980 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1060, 2)},	/* Telit LN920 */
 	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1070, 2)},	/* Telit FN990 */
+	{QMI_QUIRK_SET_DTR(0x1bc7, 0x1080, 2)}, /* Telit FE990 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},	/* Telit ME910 */
 	{QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},	/* Telit ME910 dual modem */
 	{QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},	/* Telit LE920 */
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index e1cd4c2de2d3..975f52605867 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1824,6 +1824,12 @@ static int smsc95xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		size = (u16)((header & RX_STS_FL_) >> 16);
 		align_count = (4 - ((size + NET_IP_ALIGN) % 4)) % 4;
 
+		if (unlikely(size > skb->len)) {
+			netif_dbg(dev, rx_err, dev->net,
+				  "size err header=0x%08x\n", header);
+			return 0;
+		}
+
 		if (unlikely(header & RX_STS_ES_)) {
 			netif_dbg(dev, rx_err, dev->net,
 				  "Error header=0x%08x\n", header);
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 1ba974969216..fe99439ad5fb 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -166,7 +166,7 @@ struct xenvif_queue { /* Per-queue data for xenvif */
 	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
 	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
 
-	struct gnttab_copy tx_copy_ops[MAX_PENDING_REQS];
+	struct gnttab_copy tx_copy_ops[2 * MAX_PENDING_REQS];
 	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
 	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
 	/* passed to gnttab_[un]map_refs with pages under (un)mapping */
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index f9373a88cf37..67614e7166ac 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -334,6 +334,7 @@ static int xenvif_count_requests(struct xenvif_queue *queue,
 struct xenvif_tx_cb {
 	u16 copy_pending_idx[XEN_NETBK_LEGACY_SLOTS_MAX + 1];
 	u8 copy_count;
+	u32 split_mask;
 };
 
 #define XENVIF_TX_CB(skb) ((struct xenvif_tx_cb *)(skb)->cb)
@@ -361,6 +362,8 @@ static inline struct sk_buff *xenvif_alloc_skb(unsigned int size)
 	struct sk_buff *skb =
 		alloc_skb(size + NET_SKB_PAD + NET_IP_ALIGN,
 			  GFP_ATOMIC | __GFP_NOWARN);
+
+	BUILD_BUG_ON(sizeof(*XENVIF_TX_CB(skb)) > sizeof(skb->cb));
 	if (unlikely(skb == NULL))
 		return NULL;
 
@@ -396,11 +399,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 	nr_slots = shinfo->nr_frags + 1;
 
 	copy_count(skb) = 0;
+	XENVIF_TX_CB(skb)->split_mask = 0;
 
 	/* Create copy ops for exactly data_len bytes into the skb head. */
 	__skb_put(skb, data_len);
 	while (data_len > 0) {
 		int amount = data_len > txp->size ? txp->size : data_len;
+		bool split = false;
 
 		cop->source.u.ref = txp->gref;
 		cop->source.domid = queue->vif->domid;
@@ -413,6 +418,13 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		cop->dest.u.gmfn = virt_to_gfn(skb->data + skb_headlen(skb)
 				               - data_len);
 
+		/* Don't cross local page boundary! */
+		if (cop->dest.offset + amount > XEN_PAGE_SIZE) {
+			amount = XEN_PAGE_SIZE - cop->dest.offset;
+			XENVIF_TX_CB(skb)->split_mask |= 1U << copy_count(skb);
+			split = true;
+		}
+
 		cop->len = amount;
 		cop->flags = GNTCOPY_source_gref;
 
@@ -420,7 +432,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 		pending_idx = queue->pending_ring[index];
 		callback_param(queue, pending_idx).ctx = NULL;
 		copy_pending_idx(skb, copy_count(skb)) = pending_idx;
-		copy_count(skb)++;
+		if (!split)
+			copy_count(skb)++;
 
 		cop++;
 		data_len -= amount;
@@ -441,7 +454,8 @@ static void xenvif_get_requests(struct xenvif_queue *queue,
 			nr_slots--;
 		} else {
 			/* The copy op partially covered the tx_request.
-			 * The remainder will be mapped.
+			 * The remainder will be mapped or copied in the next
+			 * iteration.
 			 */
 			txp->offset += amount;
 			txp->size -= amount;
@@ -539,6 +553,13 @@ static int xenvif_tx_check_gop(struct xenvif_queue *queue,
 		pending_idx = copy_pending_idx(skb, i);
 
 		newerr = (*gopp_copy)->status;
+
+		/* Split copies need to be handled together. */
+		if (XENVIF_TX_CB(skb)->split_mask & (1U << i)) {
+			(*gopp_copy)++;
+			if (!newerr)
+				newerr = (*gopp_copy)->status;
+		}
 		if (likely(!newerr)) {
 			/* The first frag might still have this slot mapped */
 			if (i < copy_count(skb) - 1 || !sharedslot)
diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.c
index 82b658a3c220..7bfdf5ad77c4 100644
--- a/drivers/pinctrl/pinctrl-amd.c
+++ b/drivers/pinctrl/pinctrl-amd.c
@@ -764,32 +764,34 @@ static const struct pinconf_ops amd_pinconf_ops = {
 	.pin_config_group_set = amd_pinconf_group_set,
 };
 
-static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
+static void amd_gpio_irq_init_pin(struct amd_gpio *gpio_dev, int pin)
 {
-	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	const struct pin_desc *pd;
 	unsigned long flags;
 	u32 pin_reg, mask;
-	int i;
 
 	mask = BIT(WAKE_CNTRL_OFF_S0I3) | BIT(WAKE_CNTRL_OFF_S3) |
 		BIT(INTERRUPT_MASK_OFF) | BIT(INTERRUPT_ENABLE_OFF) |
 		BIT(WAKE_CNTRL_OFF_S4);
 
-	for (i = 0; i < desc->npins; i++) {
-		int pin = desc->pins[i].number;
-		const struct pin_desc *pd = pin_desc_get(gpio_dev->pctrl, pin);
-
-		if (!pd)
-			continue;
+	pd = pin_desc_get(gpio_dev->pctrl, pin);
+	if (!pd)
+		return;
 
-		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
+	pin_reg = readl(gpio_dev->base + pin * 4);
+	pin_reg &= ~mask;
+	writel(pin_reg, gpio_dev->base + pin * 4);
+	raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
+}
 
-		pin_reg = readl(gpio_dev->base + i * 4);
-		pin_reg &= ~mask;
-		writel(pin_reg, gpio_dev->base + i * 4);
+static void amd_gpio_irq_init(struct amd_gpio *gpio_dev)
+{
+	struct pinctrl_desc *desc = gpio_dev->pctrl->desc;
+	int i;
 
-		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
-	}
+	for (i = 0; i < desc->npins; i++)
+		amd_gpio_irq_init_pin(gpio_dev, i);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -842,8 +844,10 @@ static int amd_gpio_resume(struct device *dev)
 	for (i = 0; i < desc->npins; i++) {
 		int pin = desc->pins[i].number;
 
-		if (!amd_gpio_should_save(gpio_dev, pin))
+		if (!amd_gpio_should_save(gpio_dev, pin)) {
+			amd_gpio_irq_init_pin(gpio_dev, pin);
 			continue;
+		}
 
 		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
 		gpio_dev->saved_regs[i] |= readl(gpio_dev->base + pin * 4) & PIN_IRQ_PENDING;
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index d2e2b101978f..315a6c4d9ade 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1139,7 +1139,6 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 		dev_err(dev, "can't add the irq domain\n");
 		return -ENODEV;
 	}
-	atmel_pioctrl->irq_domain->name = "atmel gpio";
 
 	for (i = 0; i < atmel_pioctrl->npins; i++) {
 		int irq = irq_create_mapping(atmel_pioctrl->irq_domain, i);
diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index a4a1b00f7f0d..c42a5b0bc4f0 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -575,7 +575,7 @@ static int ocelot_pinmux_set_mux(struct pinctrl_dev *pctldev,
 	regmap_update_bits(info->map, REG_ALT(0, info, pin->pin),
 			   BIT(p), f << p);
 	regmap_update_bits(info->map, REG_ALT(1, info, pin->pin),
-			   BIT(p), f << (p - 1));
+			   BIT(p), (f >> 1) << p);
 
 	return 0;
 }
diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index 0de7c255254e..d6de5a294128 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -284,7 +284,7 @@ static long cros_ec_chardev_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
 	    u_cmd.insize > EC_MAX_MSG_BYTES)
 		return -EINVAL;
 
-	s_cmd = kmalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
+	s_cmd = kzalloc(sizeof(*s_cmd) + max(u_cmd.outsize, u_cmd.insize),
 			GFP_KERNEL);
 	if (!s_cmd)
 		return -ENOMEM;
diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 8c3c378dce0d..338dd82007e4 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -448,11 +448,9 @@ static ssize_t bq24190_sysfs_show(struct device *dev,
 	if (!info)
 		return -EINVAL;
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	ret = bq24190_read_mask(bdi, info->reg, info->mask, info->shift, &v);
 	if (ret)
@@ -483,11 +481,9 @@ static ssize_t bq24190_sysfs_store(struct device *dev,
 	if (ret < 0)
 		return ret;
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	ret = bq24190_write_mask(bdi, info->reg, info->mask, info->shift, v);
 	if (ret)
@@ -506,10 +502,9 @@ static int bq24190_set_charge_mode(struct regulator_dev *dev, u8 val)
 	struct bq24190_dev_info *bdi = rdev_get_drvdata(dev);
 	int ret;
 
-	ret = pm_runtime_get_sync(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
 	if (ret < 0) {
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", ret);
-		pm_runtime_put_noidle(bdi->dev);
 		return ret;
 	}
 
@@ -539,10 +534,9 @@ static int bq24190_vbus_is_enabled(struct regulator_dev *dev)
 	int ret;
 	u8 val;
 
-	ret = pm_runtime_get_sync(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
 	if (ret < 0) {
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", ret);
-		pm_runtime_put_noidle(bdi->dev);
 		return ret;
 	}
 
@@ -1083,11 +1077,9 @@ static int bq24190_charger_get_property(struct power_supply *psy,
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_CHARGE_TYPE:
@@ -1157,11 +1149,9 @@ static int bq24190_charger_set_property(struct power_supply *psy,
 
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
@@ -1420,11 +1410,9 @@ static int bq24190_battery_get_property(struct power_supply *psy,
 	dev_warn(bdi->dev, "warning: /sys/class/power_supply/bq24190-battery is deprecated\n");
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
@@ -1468,11 +1456,9 @@ static int bq24190_battery_set_property(struct power_supply *psy,
 	dev_warn(bdi->dev, "warning: /sys/class/power_supply/bq24190-battery is deprecated\n");
 	dev_dbg(bdi->dev, "prop: %d\n", psp);
 
-	ret = pm_runtime_get_sync(bdi->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(bdi->dev);
+	ret = pm_runtime_resume_and_get(bdi->dev);
+	if (ret < 0)
 		return ret;
-	}
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
@@ -1626,10 +1612,9 @@ static irqreturn_t bq24190_irq_handler_thread(int irq, void *data)
 	int error;
 
 	bdi->irq_event = true;
-	error = pm_runtime_get_sync(bdi->dev);
+	error = pm_runtime_resume_and_get(bdi->dev);
 	if (error < 0) {
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
 		return IRQ_NONE;
 	}
 	bq24190_check_status(bdi);
@@ -1849,11 +1834,10 @@ static int bq24190_remove(struct i2c_client *client)
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
-	error = pm_runtime_get_sync(bdi->dev);
-	if (error < 0) {
+	cancel_delayed_work_sync(&bdi->input_current_limit_work);
+	error = pm_runtime_resume_and_get(bdi->dev);
+	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
-	}
 
 	bq24190_register_reset(bdi);
 	if (bdi->battery)
@@ -1902,11 +1886,9 @@ static __maybe_unused int bq24190_pm_suspend(struct device *dev)
 	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
 	int error;
 
-	error = pm_runtime_get_sync(bdi->dev);
-	if (error < 0) {
+	error = pm_runtime_resume_and_get(bdi->dev);
+	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
-	}
 
 	bq24190_register_reset(bdi);
 
@@ -1927,11 +1909,9 @@ static __maybe_unused int bq24190_pm_resume(struct device *dev)
 	bdi->f_reg = 0;
 	bdi->ss_reg = BQ24190_REG_SS_VBUS_STAT_MASK; /* impossible state */
 
-	error = pm_runtime_get_sync(bdi->dev);
-	if (error < 0) {
+	error = pm_runtime_resume_and_get(bdi->dev);
+	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-		pm_runtime_put_noidle(bdi->dev);
-	}
 
 	bq24190_register_reset(bdi);
 	bq24190_set_config(bdi);
diff --git a/drivers/power/supply/da9150-charger.c b/drivers/power/supply/da9150-charger.c
index f9314cc0cd75..6b987da58655 100644
--- a/drivers/power/supply/da9150-charger.c
+++ b/drivers/power/supply/da9150-charger.c
@@ -662,6 +662,7 @@ static int da9150_charger_remove(struct platform_device *pdev)
 
 	if (!IS_ERR_OR_NULL(charger->usb_phy))
 		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+	cancel_work_sync(&charger->otg_work);
 
 	power_supply_unregister(charger->battery);
 	power_supply_unregister(charger->usb);
diff --git a/drivers/ptp/ptp_qoriq.c b/drivers/ptp/ptp_qoriq.c
index 08f4cf0ad9e3..8fa9772acf79 100644
--- a/drivers/ptp/ptp_qoriq.c
+++ b/drivers/ptp/ptp_qoriq.c
@@ -601,7 +601,7 @@ static int ptp_qoriq_probe(struct platform_device *dev)
 	return 0;
 
 no_clock:
-	iounmap(ptp_qoriq->base);
+	iounmap(base);
 no_ioremap:
 	release_resource(ptp_qoriq->rsrc);
 no_resource:
diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 3de7709bdcd4..4acfff190807 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -175,7 +175,7 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 		drvdata->enable_clock = devm_clk_get(dev, NULL);
 		if (IS_ERR(drvdata->enable_clock)) {
 			dev_err(dev, "Can't get enable-clock from devicetree\n");
-			return -ENOENT;
+			return PTR_ERR(drvdata->enable_clock);
 		}
 	} else {
 		drvdata->desc.ops = &fixed_voltage_ops;
diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
index 7dc72cb718b0..22128eb44f7f 100644
--- a/drivers/s390/crypto/vfio_ap_drv.c
+++ b/drivers/s390/crypto/vfio_ap_drv.c
@@ -82,8 +82,9 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
 
 static void vfio_ap_matrix_dev_release(struct device *dev)
 {
-	struct ap_matrix_dev *matrix_dev = dev_get_drvdata(dev);
+	struct ap_matrix_dev *matrix_dev;
 
+	matrix_dev = container_of(dev, struct ap_matrix_dev, device);
 	kfree(matrix_dev);
 }
 
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fe8a5e5c0df8..bf0b3178f84d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1036,10 +1036,12 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	if (alua_rtpg_queue(pg, sdev, qdata, true))
+	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
 		fn = NULL;
-	else
+	} else {
+		kfree(qdata);
 		err = SCSI_DH_DEV_OFFLINED;
+	}
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index cd41dc061d87..65971bd80186 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2402,8 +2402,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
-	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
-	return 0;
+	return devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 }
 
 static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 755d68b98160..923ceaba0bf3 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20816,20 +20816,20 @@ lpfc_get_io_buf_from_private_pool(struct lpfc_hba *phba,
 static struct lpfc_io_buf *
 lpfc_get_io_buf_from_expedite_pool(struct lpfc_hba *phba)
 {
-	struct lpfc_io_buf *lpfc_ncmd;
+	struct lpfc_io_buf *lpfc_ncmd = NULL, *iter;
 	struct lpfc_io_buf *lpfc_ncmd_next;
 	unsigned long iflag;
 	struct lpfc_epd_pool *epd_pool;
 
 	epd_pool = &phba->epd_pool;
-	lpfc_ncmd = NULL;
 
 	spin_lock_irqsave(&epd_pool->lock, iflag);
 	if (epd_pool->count > 0) {
-		list_for_each_entry_safe(lpfc_ncmd, lpfc_ncmd_next,
+		list_for_each_entry_safe(iter, lpfc_ncmd_next,
 					 &epd_pool->list, list) {
-			list_del(&lpfc_ncmd->list);
+			list_del(&iter->list);
 			epd_pool->count--;
+			lpfc_ncmd = iter;
 			break;
 		}
 	}
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 7838c7911add..8eb126d48462 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4656,7 +4656,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"task abort issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
@@ -4726,7 +4726,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e1132970f189..38b8ff87ec0a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1762,6 +1762,17 @@ __qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
 		sp = req->outstanding_cmds[cnt];
 		if (sp) {
+			/*
+			 * perform lockless completion during driver unload
+			 */
+			if (qla2x00_chip_is_down(vha)) {
+				req->outstanding_cmds[cnt] = NULL;
+				spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+				sp->done(sp, res);
+				spin_lock_irqsave(qp->qp_lock_ptr, flags);
+				continue;
+			}
+
 			switch (sp->cmd_type) {
 			case TYPE_SRB:
 				qla2x00_abort_srb(qp, sp, res, &flags);
diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 9a8f9f902f3b..f5e121f0ee52 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -232,6 +232,7 @@ static struct {
 	{"SGI", "RAID5", "*", BLIST_SPARSELUN},
 	{"SGI", "TP9100", "*", BLIST_REPORTLUN2},
 	{"SGI", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
+	{"SKhynix", "H28U74301AMR", NULL, BLIST_SKIP_VPD_PAGES},
 	{"IBM", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"SUN", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
 	{"DELL", "Universal Xport", "*", BLIST_NO_ULD_ATTACH},
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 3fa8a0c94bdc..e38aebcabb26 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1013,6 +1013,22 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 				goto do_work;
 			}
 
+			/*
+			 * Check for "Operating parameters have changed"
+			 * due to Hyper-V changing the VHD/VHDX BlockSize
+			 * when adding/removing a differencing disk. This
+			 * causes discard_granularity to change, so do a
+			 * rescan to pick up the new granularity. We don't
+			 * want scsi_report_sense() to output a message
+			 * that a sysadmin wouldn't know what to do with.
+			 */
+			if ((asc == 0x3f) && (ascq != 0x03) &&
+					(ascq != 0x0e)) {
+				process_err_fn = storvsc_device_scan;
+				set_host_byte(scmnd, DID_REQUEUE);
+				goto do_work;
+			}
+
 			/*
 			 * Otherwise, let upper layer deal with the
 			 * error when sense message is present
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ea6ceab1a1b2..f3389e913179 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9311,5 +9311,6 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
index 7a461fbb1566..31cd3c02e517 100644
--- a/drivers/target/iscsi/iscsi_target_parameters.c
+++ b/drivers/target/iscsi/iscsi_target_parameters.c
@@ -1262,18 +1262,20 @@ static struct iscsi_param *iscsi_check_key(
 		return param;
 
 	if (!(param->phase & phase)) {
-		pr_err("Key \"%s\" may not be negotiated during ",
-				param->name);
+		char *phase_name;
+
 		switch (phase) {
 		case PHASE_SECURITY:
-			pr_debug("Security phase.\n");
+			phase_name = "Security";
 			break;
 		case PHASE_OPERATIONAL:
-			pr_debug("Operational phase.\n");
+			phase_name = "Operational";
 			break;
 		default:
-			pr_debug("Unknown phase.\n");
+			phase_name = "Unknown";
 		}
+		pr_err("Key \"%s\" may not be negotiated during %s phase.\n",
+				param->name, phase_name);
 		return NULL;
 	}
 
diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
index 297dc62bca29..372d64756ed6 100644
--- a/drivers/tee/amdtee/core.c
+++ b/drivers/tee/amdtee/core.c
@@ -267,35 +267,34 @@ int amdtee_open_session(struct tee_context *ctx,
 		goto out;
 	}
 
+	/* Open session with loaded TA */
+	handle_open_session(arg, &session_info, param);
+	if (arg->ret != TEEC_SUCCESS) {
+		pr_err("open_session failed %d\n", arg->ret);
+		handle_unload_ta(ta_handle);
+		kref_put(&sess->refcount, destroy_session);
+		goto out;
+	}
+
 	/* Find an empty session index for the given TA */
 	spin_lock(&sess->lock);
 	i = find_first_zero_bit(sess->sess_mask, TEE_NUM_SESSIONS);
-	if (i < TEE_NUM_SESSIONS)
+	if (i < TEE_NUM_SESSIONS) {
+		sess->session_info[i] = session_info;
+		set_session_id(ta_handle, i, &arg->session);
 		set_bit(i, sess->sess_mask);
+	}
 	spin_unlock(&sess->lock);
 
 	if (i >= TEE_NUM_SESSIONS) {
 		pr_err("reached maximum session count %d\n", TEE_NUM_SESSIONS);
+		handle_close_session(ta_handle, session_info);
 		handle_unload_ta(ta_handle);
 		kref_put(&sess->refcount, destroy_session);
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	/* Open session with loaded TA */
-	handle_open_session(arg, &session_info, param);
-	if (arg->ret != TEEC_SUCCESS) {
-		pr_err("open_session failed %d\n", arg->ret);
-		spin_lock(&sess->lock);
-		clear_bit(i, sess->sess_mask);
-		spin_unlock(&sess->lock);
-		handle_unload_ta(ta_handle);
-		kref_put(&sess->refcount, destroy_session);
-		goto out;
-	}
-
-	sess->session_info[i] = session_info;
-	set_session_id(ta_handle, i, &arg->session);
 out:
 	free_pages((u64)ta, get_order(ta_size));
 	return rc;
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index db80dc5dfeba..fd1b59397c70 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -36,7 +36,7 @@
 
 #define NHI_MAILBOX_TIMEOUT	500 /* ms */
 
-static int ring_interrupt_index(struct tb_ring *ring)
+static int ring_interrupt_index(const struct tb_ring *ring)
 {
 	int bit = ring->hop;
 	if (!ring->is_tx)
diff --git a/drivers/thunderbolt/usb4.c b/drivers/thunderbolt/usb4.c
index 0b3a77ade04d..5b45c45e7c5b 100644
--- a/drivers/thunderbolt/usb4.c
+++ b/drivers/thunderbolt/usb4.c
@@ -1636,18 +1636,30 @@ static int usb4_usb3_port_write_allocated_bandwidth(struct tb_port *port,
 						    int downstream_bw)
 {
 	u32 val, ubw, dbw, scale;
-	int ret;
+	int ret, max_bw;
 
-	/* Read the used scale, hardware default is 0 */
-	ret = tb_port_read(port, &scale, TB_CFG_PORT,
-			   port->cap_adap + ADP_USB3_CS_3, 1);
+	/* Figure out suitable scale */
+	scale = 0;
+	max_bw = max(upstream_bw, downstream_bw);
+	while (scale < 64) {
+		if (mbps_to_usb3_bw(max_bw, scale) < 4096)
+			break;
+		scale++;
+	}
+
+	if (WARN_ON(scale >= 64))
+		return -EINVAL;
+
+	ret = tb_port_write(port, &scale, TB_CFG_PORT,
+			    port->cap_adap + ADP_USB3_CS_3, 1);
 	if (ret)
 		return ret;
 
-	scale &= ADP_USB3_CS_3_SCALE_MASK;
 	ubw = mbps_to_usb3_bw(upstream_bw, scale);
 	dbw = mbps_to_usb3_bw(downstream_bw, scale);
 
+	tb_port_dbg(port, "scaled bandwidth %u/%u, scale %u\n", ubw, dbw, scale);
+
 	ret = tb_port_read(port, &val, TB_CFG_PORT,
 			   port->cap_adap + ADP_USB3_CS_2, 1);
 	if (ret)
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 136f2b1460f9..b7922c8da1e6 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -254,7 +254,9 @@ config SERIAL_8250_ASPEED_VUART
 	tristate "Aspeed Virtual UART"
 	depends on SERIAL_8250
 	depends on OF
-	depends on REGMAP && MFD_SYSCON
+	depends on MFD_SYSCON
+	depends on ARCH_ASPEED || COMPILE_TEST
+	select REGMAP
 	help
 	  If you want to use the virtual UART (VUART) device on Aspeed
 	  BMC platforms, enable this option. This enables the 16550A-
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 32cce52800a7..99f29bd930bd 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1278,6 +1278,7 @@ static void lpuart_dma_rx_free(struct uart_port *port)
 	struct dma_chan *chan = sport->dma_rx_chan;
 
 	dmaengine_terminate_all(chan);
+	del_timer_sync(&sport->lpuart_timer);
 	dma_unmap_sg(chan->device->dev, &sport->rx_sgl, 1, DMA_FROM_DEVICE);
 	kfree(sport->rx_ring.buf);
 	sport->rx_ring.tail = 0;
@@ -1743,7 +1744,6 @@ static int lpuart32_startup(struct uart_port *port)
 static void lpuart_dma_shutdown(struct lpuart_port *sport)
 {
 	if (sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
 		lpuart_dma_rx_free(&sport->port);
 		sport->lpuart_dma_rx_use = false;
 	}
@@ -1894,10 +1894,8 @@ lpuart_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -2129,10 +2127,8 @@ lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
 	 * Since timer function acqures sport->port.lock, need to stop before
 	 * acquring same lock because otherwise del_timer_sync() can deadlock.
 	 */
-	if (old && sport->lpuart_dma_rx_use) {
-		del_timer_sync(&sport->lpuart_timer);
+	if (old && sport->lpuart_dma_rx_use)
 		lpuart_dma_rx_free(&sport->port);
-	}
 
 	spin_lock_irqsave(&sport->port.lock, flags);
 
@@ -2766,11 +2762,10 @@ static int __maybe_unused lpuart_suspend(struct device *dev)
 		 * EDMA driver during suspend will forcefully release any
 		 * non-idle DMA channels. If port wakeup is enabled or if port
 		 * is console port or 'no_console_suspend' is set the Rx DMA
-		 * cannot resume as as expected, hence gracefully release the
+		 * cannot resume as expected, hence gracefully release the
 		 * Rx DMA path before suspend and start Rx DMA path on resume.
 		 */
 		if (irq_wake) {
-			del_timer_sync(&sport->lpuart_timer);
 			lpuart_dma_rx_free(&sport->port);
 		}
 
diff --git a/drivers/usb/cdns3/cdns3-pci-wrap.c b/drivers/usb/cdns3/cdns3-pci-wrap.c
index deeea618ba33..1f6320d98a76 100644
--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -60,6 +60,11 @@ static struct pci_dev *cdns3_get_second_fun(struct pci_dev *pdev)
 			return NULL;
 	}
 
+	if (func->devfn != PCI_DEV_FN_HOST_DEVICE &&
+	    func->devfn != PCI_DEV_FN_OTG) {
+		return NULL;
+	}
+
 	return func;
 }
 
diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index 0697eb980e5f..7b00b93dad9b 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -204,6 +204,7 @@ struct hw_bank {
  * @in_lpm: if the core in low power mode
  * @wakeup_int: if wakeup interrupt occur
  * @rev: The revision number for controller
+ * @mutex: protect code from concorrent running when doing role switch
  */
 struct ci_hdrc {
 	struct device			*dev;
@@ -257,6 +258,7 @@ struct ci_hdrc {
 	bool				in_lpm;
 	bool				wakeup_int;
 	enum ci_revision		rev;
+	struct mutex                    mutex;
 };
 
 static inline struct ci_role_driver *ci_role(struct ci_hdrc *ci)
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 127b1a62b1bf..f26dd1f054f2 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -966,9 +966,16 @@ static ssize_t role_store(struct device *dev,
 			     strlen(ci->roles[role]->name)))
 			break;
 
-	if (role == CI_ROLE_END || role == ci->role)
+	if (role == CI_ROLE_END)
 		return -EINVAL;
 
+	mutex_lock(&ci->mutex);
+
+	if (role == ci->role) {
+		mutex_unlock(&ci->mutex);
+		return n;
+	}
+
 	pm_runtime_get_sync(dev);
 	disable_irq(ci->irq);
 	ci_role_stop(ci);
@@ -977,6 +984,7 @@ static ssize_t role_store(struct device *dev,
 		ci_handle_vbus_change(ci);
 	enable_irq(ci->irq);
 	pm_runtime_put_sync(dev);
+	mutex_unlock(&ci->mutex);
 
 	return (ret == 0) ? n : ret;
 }
@@ -1012,6 +1020,7 @@ static int ci_hdrc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	spin_lock_init(&ci->lock);
+	mutex_init(&ci->mutex);
 	ci->dev = dev;
 	ci->platdata = dev_get_platdata(dev);
 	ci->imx28_write_fix = !!(ci->platdata->flags &
diff --git a/drivers/usb/chipidea/otg.c b/drivers/usb/chipidea/otg.c
index d3aada3ce7ec..9a12868ea9b6 100644
--- a/drivers/usb/chipidea/otg.c
+++ b/drivers/usb/chipidea/otg.c
@@ -166,8 +166,10 @@ static int hw_wait_vbus_lower_bsv(struct ci_hdrc *ci)
 
 static void ci_handle_id_switch(struct ci_hdrc *ci)
 {
-	enum ci_role role = ci_otg_role(ci);
+	enum ci_role role;
 
+	mutex_lock(&ci->mutex);
+	role = ci_otg_role(ci);
 	if (role != ci->role) {
 		dev_dbg(ci->dev, "switching from %s to %s\n",
 			ci_role(ci)->name, ci->roles[role]->name);
@@ -197,6 +199,7 @@ static void ci_handle_id_switch(struct ci_hdrc *ci)
 		if (role == CI_ROLE_GADGET)
 			ci_handle_vbus_change(ci);
 	}
+	mutex_unlock(&ci->mutex);
 }
 /**
  * ci_otg_work - perform otg (vbus/id) event handle
diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
index 8851db646ef5..9d0dd09a2015 100644
--- a/drivers/usb/dwc2/platform.c
+++ b/drivers/usb/dwc2/platform.c
@@ -121,13 +121,6 @@ static int dwc2_get_dr_mode(struct dwc2_hsotg *hsotg)
 	return 0;
 }
 
-static void __dwc2_disable_regulators(void *data)
-{
-	struct dwc2_hsotg *hsotg = data;
-
-	regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
-}
-
 static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
 {
 	struct platform_device *pdev = to_platform_device(hsotg->dev);
@@ -138,11 +131,6 @@ static int __dwc2_lowlevel_hw_enable(struct dwc2_hsotg *hsotg)
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(&pdev->dev,
-				       __dwc2_disable_regulators, hsotg);
-	if (ret)
-		return ret;
-
 	if (hsotg->clk) {
 		ret = clk_prepare_enable(hsotg->clk);
 		if (ret)
@@ -198,7 +186,7 @@ static int __dwc2_lowlevel_hw_disable(struct dwc2_hsotg *hsotg)
 	if (hsotg->clk)
 		clk_disable_unprepare(hsotg->clk);
 
-	return 0;
+	return regulator_bulk_disable(ARRAY_SIZE(hsotg->supplies), hsotg->supplies);
 }
 
 /**
@@ -625,7 +613,7 @@ static int dwc2_driver_probe(struct platform_device *dev)
 	if (hsotg->params.activate_stm_id_vb_detection)
 		regulator_disable(hsotg->usb33d);
 error:
-	if (hsotg->dr_mode != USB_DR_MODE_PERIPHERAL)
+	if (hsotg->ll_hw_enabled)
 		dwc2_lowlevel_hw_disable(hsotg);
 	return retval;
 }
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 28a1194f849f..01cecde76140 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1440,6 +1440,44 @@ static int __dwc3_gadget_get_frame(struct dwc3 *dwc)
 	return DWC3_DSTS_SOFFN(reg);
 }
 
+/**
+ * __dwc3_stop_active_transfer - stop the current active transfer
+ * @dep: isoc endpoint
+ * @force: set forcerm bit in the command
+ * @interrupt: command complete interrupt after End Transfer command
+ *
+ * When setting force, the ForceRM bit will be set. In that case
+ * the controller won't update the TRB progress on command
+ * completion. It also won't clear the HWO bit in the TRB.
+ * The command will also not complete immediately in that case.
+ */
+static int __dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force, bool interrupt)
+{
+	struct dwc3 *dwc = dep->dwc;
+	struct dwc3_gadget_ep_cmd_params params;
+	u32 cmd;
+	int ret;
+
+	cmd = DWC3_DEPCMD_ENDTRANSFER;
+	cmd |= force ? DWC3_DEPCMD_HIPRI_FORCERM : 0;
+	cmd |= interrupt ? DWC3_DEPCMD_CMDIOC : 0;
+	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
+	memset(&params, 0, sizeof(params));
+	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
+	WARN_ON_ONCE(ret);
+	dep->resource_index = 0;
+
+	if (!interrupt) {
+		if (!DWC3_IP_IS(DWC3) || DWC3_VER_IS_PRIOR(DWC3, 310A))
+			mdelay(1);
+		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
+	} else if (!ret) {
+		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	}
+
+	return ret;
+}
+
 /**
  * dwc3_gadget_start_isoc_quirk - workaround invalid frame number
  * @dep: isoc endpoint
@@ -1609,21 +1647,8 @@ static int __dwc3_gadget_start_isoc(struct dwc3_ep *dep)
 	 * status, issue END_TRANSFER command and retry on the next XferNotReady
 	 * event.
 	 */
-	if (ret == -EAGAIN) {
-		struct dwc3_gadget_ep_cmd_params params;
-		u32 cmd;
-
-		cmd = DWC3_DEPCMD_ENDTRANSFER |
-			DWC3_DEPCMD_CMDIOC |
-			DWC3_DEPCMD_PARAM(dep->resource_index);
-
-		dep->resource_index = 0;
-		memset(&params, 0, sizeof(params));
-
-		ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-		if (!ret)
-			dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
-	}
+	if (ret == -EAGAIN)
+		ret = __dwc3_stop_active_transfer(dep, false, true);
 
 	return ret;
 }
@@ -3250,10 +3275,6 @@ static void dwc3_reset_gadget(struct dwc3 *dwc)
 static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	bool interrupt)
 {
-	struct dwc3_gadget_ep_cmd_params params;
-	u32 cmd;
-	int ret;
-
 	if (!(dep->flags & DWC3_EP_TRANSFER_STARTED) ||
 	    (dep->flags & DWC3_EP_END_TRANSFER_PENDING))
 		return;
@@ -3282,22 +3303,14 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	 * enabled, the EndTransfer command will have completed upon
 	 * returning from this function.
 	 *
-	 * This mode is NOT available on the DWC_usb31 IP.
+	 * This mode is NOT available on the DWC_usb31 IP.  In this
+	 * case, if the IOC bit is not set, then delay by 1ms
+	 * after issuing the EndTransfer command.  This allows for the
+	 * controller to handle the command completely before DWC3
+	 * remove requests attempts to unmap USB request buffers.
 	 */
 
-	cmd = DWC3_DEPCMD_ENDTRANSFER;
-	cmd |= force ? DWC3_DEPCMD_HIPRI_FORCERM : 0;
-	cmd |= interrupt ? DWC3_DEPCMD_CMDIOC : 0;
-	cmd |= DWC3_DEPCMD_PARAM(dep->resource_index);
-	memset(&params, 0, sizeof(params));
-	ret = dwc3_send_gadget_ep_cmd(dep, cmd, &params);
-	WARN_ON_ONCE(ret);
-	dep->resource_index = 0;
-
-	if (!interrupt)
-		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
-	else
-		dep->flags |= DWC3_EP_END_TRANSFER_PENDING;
+	__dwc3_stop_active_transfer(dep, force, interrupt);
 }
 
 static void dwc3_clear_stall_all_ep(struct dwc3 *dwc)
diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 95605b1ef4eb..6c8b8f5b7e0f 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -613,7 +613,7 @@ void g_audio_cleanup(struct g_audio *g_audio)
 	uac = g_audio->uac;
 	card = uac->card;
 	if (card)
-		snd_card_free(card);
+		snd_card_free_when_closed(card);
 
 	kfree(uac->p_prm.ureq);
 	kfree(uac->c_prm.ureq);
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index c7b763d6d102..1f8c9b16a0fb 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -111,6 +111,13 @@ UNUSUAL_DEV(0x152d, 0x0578, 0x0000, 0x9999,
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BROKEN_FUA),
 
+/* Reported by: Yaroslav Furman <yaro330@gmail.com> */
+UNUSUAL_DEV(0x152d, 0x0583, 0x0000, 0x9999,
+		"JMicron",
+		"JMS583Gen 2",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_REPORT_OPCODES),
+
 /* Reported-by: Thinh Nguyen <thinhn@synopsys.com> */
 UNUSUAL_DEV(0x154b, 0xf00b, 0x0000, 0x9999,
 		"PNY",
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 4cd5c291cdf3..cd3689005c31 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1152,7 +1152,7 @@ static int ucsi_register_port(struct ucsi *ucsi, int index)
 static int ucsi_init(struct ucsi *ucsi)
 {
 	struct ucsi_connector *con;
-	u64 command;
+	u64 command, ntfy;
 	int ret;
 	int i;
 
@@ -1164,8 +1164,8 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable basic notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_CMD_COMPLETE | UCSI_ENABLE_NTFY_ERROR;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_reset;
@@ -1197,12 +1197,13 @@ static int ucsi_init(struct ucsi *ucsi)
 	}
 
 	/* Enable all notifications */
-	ucsi->ntfy = UCSI_ENABLE_NTFY_ALL;
-	command = UCSI_SET_NOTIFICATION_ENABLE | ucsi->ntfy;
+	ntfy = UCSI_ENABLE_NTFY_ALL;
+	command = UCSI_SET_NOTIFICATION_ENABLE | ntfy;
 	ret = ucsi_send_command(ucsi, command, NULL, 0);
 	if (ret < 0)
 		goto err_unregister;
 
+	ucsi->ntfy = ntfy;
 	return 0;
 
 err_unregister:
diff --git a/drivers/video/fbdev/au1200fb.c b/drivers/video/fbdev/au1200fb.c
index c00e01a17368..a8a0a448cdb5 100644
--- a/drivers/video/fbdev/au1200fb.c
+++ b/drivers/video/fbdev/au1200fb.c
@@ -1040,6 +1040,9 @@ static int au1200fb_fb_check_var(struct fb_var_screeninfo *var,
 	u32 pixclock;
 	int screen_size, plane;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	plane = fbdev->plane;
 
 	/* Make sure that the mode respect all LCD controller and
diff --git a/drivers/video/fbdev/geode/lxfb_core.c b/drivers/video/fbdev/geode/lxfb_core.c
index 66c81262d18f..6c6b6efb49f6 100644
--- a/drivers/video/fbdev/geode/lxfb_core.c
+++ b/drivers/video/fbdev/geode/lxfb_core.c
@@ -234,6 +234,9 @@ static void get_modedb(struct fb_videomode **modedb, unsigned int *size)
 
 static int lxfb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (var->xres > 1920 || var->yres > 1440)
 		return -EINVAL;
 
diff --git a/drivers/video/fbdev/intelfb/intelfbdrv.c b/drivers/video/fbdev/intelfb/intelfbdrv.c
index a9579964eaba..8a703adfa936 100644
--- a/drivers/video/fbdev/intelfb/intelfbdrv.c
+++ b/drivers/video/fbdev/intelfb/intelfbdrv.c
@@ -1214,6 +1214,9 @@ static int intelfb_check_var(struct fb_var_screeninfo *var,
 
 	dinfo = GET_DINFO(info);
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	/* update the pitch */
 	if (intelfbhw_validate_mode(dinfo, var) != 0)
 		return -EINVAL;
diff --git a/drivers/video/fbdev/nvidia/nvidia.c b/drivers/video/fbdev/nvidia/nvidia.c
index a372a183c1f0..f9c388a8c10e 100644
--- a/drivers/video/fbdev/nvidia/nvidia.c
+++ b/drivers/video/fbdev/nvidia/nvidia.c
@@ -763,6 +763,8 @@ static int nvidiafb_check_var(struct fb_var_screeninfo *var,
 	int pitch, err = 0;
 
 	NVTRACE_ENTER();
+	if (!var->pixclock)
+		return -EINVAL;
 
 	var->transp.offset = 0;
 	var->transp.length = 0;
diff --git a/drivers/video/fbdev/tgafb.c b/drivers/video/fbdev/tgafb.c
index 666fbe2f671c..98a2977fd427 100644
--- a/drivers/video/fbdev/tgafb.c
+++ b/drivers/video/fbdev/tgafb.c
@@ -166,6 +166,9 @@ tgafb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
 	struct tga_par *par = (struct tga_par *)info->par;
 
+	if (!var->pixclock)
+		return -EINVAL;
+
 	if (par->tga_type == TGA_TYPE_8PLANE) {
 		if (var->bits_per_pixel != 8)
 			return -EINVAL;
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index fc335b5e44df..10686b494f0a 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4254,7 +4254,9 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
 	}
 
 	/* update qgroup status and info */
+	mutex_lock(&fs_info->qgroup_ioctl_lock);
 	err = btrfs_run_qgroups(trans);
+	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (err < 0)
 		btrfs_handle_fs_error(fs_info, err,
 				      "failed to update qgroup status and info");
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9fe6a01ea8b8..3fc689154bb5 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2762,13 +2762,22 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 }
 
 /*
- * called from commit_transaction. Writes all changed qgroups to disk.
+ * Writes all changed qgroups to disk.
+ * Called by the transaction commit path and the qgroup assign ioctl.
  */
 int btrfs_run_qgroups(struct btrfs_trans_handle *trans)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	int ret = 0;
 
+	/*
+	 * In case we are called from the qgroup assign ioctl, assert that we
+	 * are holding the qgroup_ioctl_lock, otherwise we can race with a quota
+	 * disable operation (ioctl) and access a freed quota root.
+	 */
+	if (trans->transaction->state != TRANS_STATE_COMMIT_DOING)
+		lockdep_assert_held(&fs_info->qgroup_ioctl_lock);
+
 	if (!fs_info->quota_root)
 		return ret;
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 15435f983180..83dca79ff042 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -1411,8 +1411,17 @@ struct btrfs_device *btrfs_scan_one_device(const char *path, fmode_t flags,
 	 * later supers, using BTRFS_SUPER_MIRROR_MAX instead
 	 */
 	bytenr = btrfs_sb_offset(0);
-	flags |= FMODE_EXCL;
 
+	/*
+	 * Avoid using flag |= FMODE_EXCL here, as the systemd-udev may
+	 * initiate the device scan which may race with the user's mount
+	 * or mkfs command, resulting in failure.
+	 * Since the device scan is solely for reading purposes, there is
+	 * no need for FMODE_EXCL. Additionally, the devices are read again
+	 * during the mount process. It is ok to get some inconsistent
+	 * values temporarily, as the device paths of the fsid are the only
+	 * required information for assembling the volume.
+	 */
 	bdev = blkdev_get_by_path(path, flags, holder);
 	if (IS_ERR(bdev))
 		return ERR_CAST(bdev);
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index e996f0bef414..59c41412ebaf 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -126,7 +126,10 @@ extern const struct dentry_operations cifs_ci_dentry_ops;
 #ifdef CONFIG_CIFS_DFS_UPCALL
 extern struct vfsmount *cifs_dfs_d_automount(struct path *path);
 #else
-#define cifs_dfs_d_automount NULL
+static inline struct vfsmount *cifs_dfs_d_automount(struct path *path)
+{
+	return ERR_PTR(-EREMOTE);
+}
 #endif
 
 /* Functions related to symlinks */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c279527aae92..95992c93bbe3 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4859,8 +4859,13 @@ CIFSGetDFSRefer(const unsigned int xid, struct cifs_ses *ses,
 		return -ENODEV;
 
 getDFSRetry:
-	rc = smb_init(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc, (void **) &pSMB,
-		      (void **) &pSMBr);
+	/*
+	 * Use smb_init_no_reconnect() instead of smb_init() as
+	 * CIFSGetDFSRefer() may be called from cifs_reconnect_tcon() and thus
+	 * causing an infinite recursion.
+	 */
+	rc = smb_init_no_reconnect(SMB_COM_TRANSACTION2, 15, ses->tcon_ipc,
+				   (void **)&pSMB, (void **)&pSMBr);
 	if (rc)
 		return rc;
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 8fdd34ff20ef..120c7cb11b02 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -593,7 +593,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
 	if (rc == -EOPNOTSUPP) {
 		cifs_dbg(FYI,
 			 "server does not support query network interfaces\n");
-		goto out;
+		ret_data_len = 0;
 	} else if (rc != 0) {
 		cifs_tcon_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6ba185b46ba3..9bd5f8b0511b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1303,7 +1303,8 @@ static int ext4_write_end(struct file *file,
 	bool verity = ext4_verity_in_progress(inode);
 
 	trace_ext4_write_end(inode, pos, len, copied);
-	if (inline_data) {
+	if (inline_data &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
 		ret = ext4_write_inline_data_end(inode, pos, len,
 						 copied, page);
 		if (ret < 0) {
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 530659554870..a0430da033b3 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -451,8 +451,6 @@ static int stuffed_readpage(struct gfs2_inode *ip, struct page *page)
 		return error;
 
 	kaddr = kmap_atomic(page);
-	if (dsize > gfs2_max_stuffed_size(ip))
-		dsize = gfs2_max_stuffed_size(ip);
 	memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 	memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 	kunmap_atomic(kaddr);
diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index b4fde3a8eeb4..eaee95d2ad14 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -69,9 +69,6 @@ static int gfs2_unstuffer_page(struct gfs2_inode *ip, struct buffer_head *dibh,
 		void *kaddr = kmap(page);
 		u64 dsize = i_size_read(inode);
  
-		if (dsize > gfs2_max_stuffed_size(ip))
-			dsize = gfs2_max_stuffed_size(ip);
-
 		memcpy(kaddr, dibh->b_data + sizeof(struct gfs2_dinode), dsize);
 		memset(kaddr + dsize, 0, PAGE_SIZE - dsize);
 		kunmap(page);
diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index bf539eab92c6..db28c240dae3 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -454,6 +454,9 @@ static int gfs2_dinode_in(struct gfs2_inode *ip, const void *buf)
 	ip->i_depth = (u8)depth;
 	ip->i_entries = be32_to_cpu(str->di_entries);
 
+	if (gfs2_is_stuffed(ip) && ip->i_inode.i_size > gfs2_max_stuffed_size(ip))
+		goto corrupt;
+
 	if (S_ISREG(ip->i_inode.i_mode))
 		gfs2_set_aops(&ip->i_inode);
 
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 8653335c17b6..bca5d1bdd79b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -1975,8 +1975,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 	if (!data->rpc_done) {
 		if (data->rpc_status)
 			return ERR_PTR(data->rpc_status);
-		/* cached opens have already been processed */
-		goto update;
+		return nfs4_try_open_cached(data);
 	}
 
 	ret = nfs_refresh_inode(inode, &data->f_attr);
@@ -1985,7 +1984,7 @@ _nfs4_opendata_reclaim_to_nfs4_state(struct nfs4_opendata *data)
 
 	if (data->o_res.delegation_type != 0)
 		nfs4_opendata_check_deleg(data, state);
-update:
+
 	if (!update_open_stateid(state, &data->o_res.stateid,
 				NULL, data->o_arg.fmode))
 		return ERR_PTR(-EAGAIN);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index f82cfe843b99..3c651cbcf897 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1248,13 +1248,6 @@ nfsd4_interssc_connect(struct nl4_server *nss, struct svc_rqst *rqstp,
 	return status;
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-	nfs_do_sb_deactive(ss_mnt->mnt_sb);
-	mntput(ss_mnt);
-}
-
 /*
  * Verify COPY destination stateid.
  *
@@ -1325,11 +1318,6 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
 {
 }
 
-static void
-nfsd4_interssc_disconnect(struct vfsmount *ss_mnt)
-{
-}
-
 static struct file *nfs42_ssc_open(struct vfsmount *ss_mnt,
 				   struct nfs_fh *src_fh,
 				   nfs4_stateid *stateid)
@@ -1471,14 +1459,14 @@ static int nfsd4_do_async_copy(void *data)
 		copy->nf_src = kzalloc(sizeof(struct nfsd_file), GFP_KERNEL);
 		if (!copy->nf_src) {
 			copy->nfserr = nfserr_serverfault;
-			nfsd4_interssc_disconnect(copy->ss_mnt);
+			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
 		copy->nf_src->nf_file = nfs42_ssc_open(copy->ss_mnt, &copy->c_fh,
 					      &copy->stateid);
 		if (IS_ERR(copy->nf_src->nf_file)) {
 			copy->nfserr = nfserr_offload_denied;
-			nfsd4_interssc_disconnect(copy->ss_mnt);
+			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
 	}
@@ -1561,8 +1549,10 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	if (!copy->cp_intra)
-		nfsd4_interssc_disconnect(copy->ss_mnt);
+	/*
+	 * source's vfsmount of inter-copy will be unmounted
+	 * by the laundromat
+	 */
 	goto out;
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 3a1dea5d1448..01235fac5971 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -70,7 +70,7 @@ static int nilfs_ioctl_wrap_copy(struct the_nilfs *nilfs,
 	if (argv->v_index > ~(__u64)0 - argv->v_nmembs)
 		return -EINVAL;
 
-	buf = (void *)__get_free_pages(GFP_NOFS, 0);
+	buf = (void *)get_zeroed_page(GFP_NOFS);
 	if (unlikely(!buf))
 		return -ENOMEM;
 	maxmembs = PAGE_SIZE / argv->v_size;
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index ad20403b383f..9b23e74036eb 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1981,11 +1981,25 @@ int ocfs2_write_end_nolock(struct address_space *mapping,
 	}
 
 	if (unlikely(copied < len) && wc->w_target_page) {
+		loff_t new_isize;
+
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
-		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
-				       start+len);
+		new_isize = max_t(loff_t, i_size_read(inode), pos + copied);
+		if (new_isize > page_offset(wc->w_target_page))
+			ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
+					       start+len);
+		else {
+			/*
+			 * When page is fully beyond new isize (data copy
+			 * failed), do not bother zeroing the page. Invalidate
+			 * it instead so that writeback does not get confused
+			 * put page & buffer dirty bits into inconsistent
+			 * state.
+			 */
+			block_invalidatepage(wc->w_target_page, 0, PAGE_SIZE);
+		}
 	}
 	if (wc->w_target_page)
 		flush_dcache_page(wc->w_target_page);
diff --git a/fs/verity/enable.c b/fs/verity/enable.c
index 734862e608fd..5ceae66e1ae0 100644
--- a/fs/verity/enable.c
+++ b/fs/verity/enable.c
@@ -391,25 +391,27 @@ int fsverity_ioctl_enable(struct file *filp, const void __user *uarg)
 		goto out_drop_write;
 
 	err = enable_verity(filp, &arg);
-	if (err)
-		goto out_allow_write_access;
 
 	/*
-	 * Some pages of the file may have been evicted from pagecache after
-	 * being used in the Merkle tree construction, then read into pagecache
-	 * again by another process reading from the file concurrently.  Since
-	 * these pages didn't undergo verification against the file measurement
-	 * which fs-verity now claims to be enforcing, we have to wipe the
-	 * pagecache to ensure that all future reads are verified.
+	 * We no longer drop the inode's pagecache after enabling verity.  This
+	 * used to be done to try to avoid a race condition where pages could be
+	 * evicted after being used in the Merkle tree construction, then
+	 * re-instantiated by a concurrent read.  Such pages are unverified, and
+	 * the backing storage could have filled them with different content, so
+	 * they shouldn't be used to fulfill reads once verity is enabled.
+	 *
+	 * But, dropping the pagecache has a big performance impact, and it
+	 * doesn't fully solve the race condition anyway.  So for those reasons,
+	 * and also because this race condition isn't very important relatively
+	 * speaking (especially for small-ish files, where the chance of a page
+	 * being used, evicted, *and* re-instantiated all while enabling verity
+	 * is quite small), we no longer drop the inode's pagecache.
 	 */
-	filemap_write_and_wait(inode->i_mapping);
-	invalidate_inode_pages2(inode->i_mapping);
 
 	/*
 	 * allow_write_access() is needed to pair with deny_write_access().
 	 * Regardless, the filesystem won't allow writing to verity files.
 	 */
-out_allow_write_access:
 	allow_write_access(filp);
 out_drop_write:
 	mnt_drop_write_file(filp);
diff --git a/fs/verity/verify.c b/fs/verity/verify.c
index a8b68c6f663d..d3a3a359d815 100644
--- a/fs/verity/verify.c
+++ b/fs/verity/verify.c
@@ -279,15 +279,15 @@ EXPORT_SYMBOL_GPL(fsverity_enqueue_verify_work);
 int __init fsverity_init_workqueue(void)
 {
 	/*
-	 * Use an unbound workqueue to allow bios to be verified in parallel
-	 * even when they happen to complete on the same CPU.  This sacrifices
-	 * locality, but it's worthwhile since hashing is CPU-intensive.
+	 * Use a high-priority workqueue to prioritize verification work, which
+	 * blocks reads from completing, over regular application tasks.
 	 *
-	 * Also use a high-priority workqueue to prioritize verification work,
-	 * which blocks reads from completing, over regular application tasks.
+	 * For performance reasons, don't use an unbound workqueue.  Using an
+	 * unbound workqueue for crypto operations causes excessive scheduler
+	 * latency on ARM64.
 	 */
 	fsverity_read_workqueue = alloc_workqueue("fsverity_read_queue",
-						  WQ_UNBOUND | WQ_HIGHPRI,
+						  WQ_HIGHPRI,
 						  num_online_cpus());
 	if (!fsverity_read_workqueue)
 		return -ENOMEM;
diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 5c2695a42de1..a4075685d9eb 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,7 +344,6 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
-restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -363,19 +362,6 @@ xfs_extent_busy_trim(
 			continue;
 		}
 
-		/*
-		 * If this is a metadata allocation, try to reuse the busy
-		 * extent instead of trimming the allocation.
-		 */
-		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
-			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
-							  busyp, fbno, flen,
-							  false))
-				goto restart;
-			continue;
-		}
-
 		if (bbno <= fbno) {
 			/* start overlap */
 
diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 288ea38c43ad..5ca210e6626c 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -16,6 +16,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_trace.h"
+#include "xfs_error.h"
 
 STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
 
@@ -708,9 +709,11 @@ xfs_trans_dqresv(
 					    XFS_TRANS_DQ_RES_INOS,
 					    ninos);
 	}
-	ASSERT(dqp->q_blk.reserved >= dqp->q_blk.count);
-	ASSERT(dqp->q_rtb.reserved >= dqp->q_rtb.count);
-	ASSERT(dqp->q_ino.reserved >= dqp->q_ino.count);
+
+	if (XFS_IS_CORRUPT(mp, dqp->q_blk.reserved < dqp->q_blk.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_rtb.reserved < dqp->q_rtb.count) ||
+	    XFS_IS_CORRUPT(mp, dqp->q_ino.reserved < dqp->q_ino.count))
+		goto error_corrupt;
 
 	xfs_dqunlock(dqp);
 	return 0;
@@ -720,6 +723,10 @@ xfs_trans_dqresv(
 	if (xfs_dquot_type(dqp) == XFS_DQTYPE_PROJ)
 		return -ENOSPC;
 	return -EDQUOT;
+error_corrupt:
+	xfs_dqunlock(dqp);
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	return -EFSCORRUPTED;
 }
 
 
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 66a089a62c39..b9522eee1257 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -789,7 +789,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 		if (bio->bi_iter.bi_sector != wpsector) {
 			zonefs_warn(inode->i_sb,
 				"Corrupted write pointer %llu for zone at %llu\n",
-				wpsector, zi->i_zsector);
+				bio->bi_iter.bi_sector, zi->i_zsector);
 			ret = -EIO;
 		}
 	}
diff --git a/include/linux/nvme-tcp.h b/include/linux/nvme-tcp.h
index 959e0bd9a913..73364ae91689 100644
--- a/include/linux/nvme-tcp.h
+++ b/include/linux/nvme-tcp.h
@@ -114,8 +114,9 @@ struct nvme_tcp_icresp_pdu {
 struct nvme_tcp_term_pdu {
 	struct nvme_tcp_hdr	hdr;
 	__le16			fes;
-	__le32			fei;
-	__u8			rsvd[8];
+	__le16			feil;
+	__le16			feiu;
+	__u8			rsvd[10];
 };
 
 /**
diff --git a/include/linux/of_mdio.h b/include/linux/of_mdio.h
index f56c6a9230ac..8cc6522ee43a 100644
--- a/include/linux/of_mdio.h
+++ b/include/linux/of_mdio.h
@@ -14,9 +14,25 @@
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
 bool of_mdiobus_child_is_phy(struct device_node *child);
-int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np);
-int devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
-			     struct device_node *np);
+int __of_mdiobus_register(struct mii_bus *mdio, struct device_node *np,
+			  struct module *owner);
+
+static inline int of_mdiobus_register(struct mii_bus *mdio,
+				      struct device_node *np)
+{
+	return __of_mdiobus_register(mdio, np, THIS_MODULE);
+}
+
+int __devm_of_mdiobus_register(struct device *dev, struct mii_bus *mdio,
+			       struct device_node *np, struct module *owner);
+
+static inline int devm_of_mdiobus_register(struct device *dev,
+					   struct mii_bus *mdio,
+					   struct device_node *np)
+{
+	return __devm_of_mdiobus_register(dev, mdio, np, THIS_MODULE);
+}
+
 struct mdio_device *of_mdio_find_device(struct device_node *np);
 struct phy_device *of_phy_find_device(struct device_node *phy_np);
 struct phy_device *
diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 9b8000869b07..7f9d0ab76b14 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -493,6 +493,7 @@ struct l2cap_le_credits {
 
 #define L2CAP_ECRED_MIN_MTU		64
 #define L2CAP_ECRED_MIN_MPS		64
+#define L2CAP_ECRED_MAX_CID		5
 
 struct l2cap_ecred_conn_req {
 	__le16 psm;
diff --git a/include/trace/events/rcu.h b/include/trace/events/rcu.h
index 155b5cb43cfd..2d8790e40901 100644
--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -713,7 +713,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
 	TP_ARGS(rcutorturename, rhp, secs, c_old, c),
 
 	TP_STRUCT__entry(
-		__field(char, rcutorturename[RCUTORTURENAME_LEN])
+		__array(char, rcutorturename, RCUTORTURENAME_LEN)
 		__field(struct rcu_head *, rhp)
 		__field(unsigned long, secs)
 		__field(unsigned long, c_old)
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 73d4b1e32fbd..d3f6a070875c 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -826,7 +826,7 @@ static int __init bpf_jit_charge_init(void)
 {
 	/* Only used as heuristic here to derive limit. */
 	bpf_jit_limit_max = bpf_jit_alloc_exec_limit();
-	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 2,
+	bpf_jit_limit = min_t(u64, round_up(bpf_jit_limit_max >> 1,
 					    PAGE_SIZE), LONG_MAX);
 	return 0;
 }
diff --git a/kernel/compat.c b/kernel/compat.c
index 05adfd6fa8bf..f9f7a79e07c5 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -152,7 +152,7 @@ COMPAT_SYSCALL_DEFINE3(sched_getaffinity, compat_pid_t,  pid, unsigned int, len,
 	if (len & (sizeof(compat_ulong_t)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index d7b61116f15b..e2e1371fbb9d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3817,7 +3817,7 @@ ctx_sched_in(struct perf_event_context *ctx,
 	if (likely(!ctx->nr_events))
 		return;
 
-	if (is_active ^ EVENT_TIME) {
+	if (!(is_active & EVENT_TIME)) {
 		/* start ctx time */
 		__update_context_time(ctx, false);
 		perf_cgroup_set_timestamp(task, ctx);
@@ -8710,7 +8710,7 @@ static void perf_event_bpf_output(struct perf_event *event, void *data)
 
 	perf_event_header__init_id(&bpf_event->event_id.header,
 				   &sample, event);
-	ret = perf_output_begin(&handle, data, event,
+	ret = perf_output_begin(&handle, &sample, event,
 				bpf_event->event_id.header.size);
 	if (ret)
 		return;
diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index 65ca5539c470..a9b0ee63b697 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -13,5 +13,6 @@ CFLAGS_core.o := $(call cc-option,-fno-conserve-stack) \
 obj-y := core.o debugfs.o report.o
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
-CFLAGS_kcsan-test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan-test.o := $(CFLAGS_KCSAN) -fno-omit-frame-pointer
+CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_TEST) += kcsan-test.o
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1303a2607f1f..b4bd02d68185 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1601,6 +1601,9 @@ static inline void dequeue_task(struct rq *rq, struct task_struct *p, int flags)
 
 void activate_task(struct rq *rq, struct task_struct *p, int flags)
 {
+	if (task_on_rq_migrating(p))
+		flags |= ENQUEUE_MIGRATED;
+
 	enqueue_task(rq, p, flags);
 
 	p->on_rq = TASK_ON_RQ_QUEUED;
@@ -6064,14 +6067,14 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+	if (!zalloc_cpumask_var(&mask, GFP_KERNEL))
 		return -ENOMEM;
 
 	ret = sched_getaffinity(pid, mask);
 	if (ret == 0) {
 		unsigned int retlen = min(len, cpumask_size());
 
-		if (copy_to_user(user_mask_ptr, mask, retlen))
+		if (copy_to_user(user_mask_ptr, cpumask_bits(mask), retlen))
 			ret = -EFAULT;
 		else
 			ret = retlen;
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c39d2fc3f994..bb70a7856277 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4274,6 +4274,29 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 #endif
 }
 
+static inline bool entity_is_long_sleeper(struct sched_entity *se)
+{
+	struct cfs_rq *cfs_rq;
+	u64 sleep_time;
+
+	if (se->exec_start == 0)
+		return false;
+
+	cfs_rq = cfs_rq_of(se);
+
+	sleep_time = rq_clock_task(rq_of(cfs_rq));
+
+	/* Happen while migrating because of clock task divergence */
+	if (sleep_time <= se->exec_start)
+		return false;
+
+	sleep_time -= se->exec_start;
+	if (sleep_time > ((1ULL << 63) / scale_load_down(NICE_0_LOAD)))
+		return true;
+
+	return false;
+}
+
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
@@ -4302,8 +4325,29 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 		vruntime -= thresh;
 	}
 
-	/* ensure we never gain time by being placed backwards. */
-	se->vruntime = max_vruntime(se->vruntime, vruntime);
+	/*
+	 * Pull vruntime of the entity being placed to the base level of
+	 * cfs_rq, to prevent boosting it if placed backwards.
+	 * However, min_vruntime can advance much faster than real time, with
+	 * the extreme being when an entity with the minimal weight always runs
+	 * on the cfs_rq. If the waking entity slept for a long time, its
+	 * vruntime difference from min_vruntime may overflow s64 and their
+	 * comparison may get inversed, so ignore the entity's original
+	 * vruntime in that case.
+	 * The maximal vruntime speedup is given by the ratio of normal to
+	 * minimal weight: scale_load_down(NICE_0_LOAD) / MIN_SHARES.
+	 * When placing a migrated waking entity, its exec_start has been set
+	 * from a different rq. In order to take into account a possible
+	 * divergence between new and prev rq's clocks task because of irq and
+	 * stolen time, we take an additional margin.
+	 * So, cutting off on the sleep time of
+	 *     2^63 / scale_load_down(NICE_0_LOAD) ~ 104 days
+	 * should be safe.
+	 */
+	if (entity_is_long_sleeper(se))
+		se->vruntime = vruntime;
+	else
+		se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
@@ -4399,6 +4443,9 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 
 	if (flags & ENQUEUE_WAKEUP)
 		place_entity(cfs_rq, se, 0);
+	/* Entity has migrated, no longer consider this task hot */
+	if (flags & ENQUEUE_MIGRATED)
+		se->exec_start = 0;
 
 	check_schedstat_required();
 	update_stats_enqueue(cfs_rq, se, flags);
@@ -6984,9 +7031,6 @@ static void migrate_task_rq_fair(struct task_struct *p, int new_cpu)
 	/* Tell new CPU we are migrated */
 	p->se.avg.last_update_time = 0;
 
-	/* We have migrated, no longer consider this task hot */
-	p->se.exec_start = 0;
-
 	update_scan_period(p, new_cpu);
 }
 
diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index c736487fc0e4..e0c420eb0b2b 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -146,7 +146,7 @@ static int __init test_gen_kprobe_cmd(void)
 	if (trace_event_file_is_valid(gen_kprobe_test))
 		gen_kprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
-	ret = kprobe_event_delete("gen_kprobe_test");
+	kprobe_event_delete("gen_kprobe_test");
 	goto out;
 }
 
@@ -211,7 +211,7 @@ static int __init test_gen_kretprobe_cmd(void)
 	if (trace_event_file_is_valid(gen_kretprobe_test))
 		gen_kretprobe_test = NULL;
 	/* We got an error after creating the event, delete it */
-	ret = kprobe_event_delete("gen_kretprobe_test");
+	kprobe_event_delete("gen_kretprobe_test");
 	goto out;
 }
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index bde90df6b497..367b1dec2e75 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -710,6 +710,17 @@ void l2cap_chan_del(struct l2cap_chan *chan, int err)
 }
 EXPORT_SYMBOL_GPL(l2cap_chan_del);
 
+static void __l2cap_chan_list_id(struct l2cap_conn *conn, u16 id,
+				 l2cap_chan_func_t func, void *data)
+{
+	struct l2cap_chan *chan, *l;
+
+	list_for_each_entry_safe(chan, l, &conn->chan_l, list) {
+		if (chan->ident == id)
+			func(chan, data);
+	}
+}
+
 static void __l2cap_chan_list(struct l2cap_conn *conn, l2cap_chan_func_t func,
 			      void *data)
 {
@@ -777,23 +788,9 @@ static void l2cap_chan_le_connect_reject(struct l2cap_chan *chan)
 
 static void l2cap_chan_ecred_connect_reject(struct l2cap_chan *chan)
 {
-	struct l2cap_conn *conn = chan->conn;
-	struct l2cap_ecred_conn_rsp rsp;
-	u16 result;
-
-	if (test_bit(FLAG_DEFER_SETUP, &chan->flags))
-		result = L2CAP_CR_LE_AUTHORIZATION;
-	else
-		result = L2CAP_CR_LE_BAD_PSM;
-
 	l2cap_state_change(chan, BT_DISCONN);
 
-	memset(&rsp, 0, sizeof(rsp));
-
-	rsp.result  = cpu_to_le16(result);
-
-	l2cap_send_cmd(conn, chan->ident, L2CAP_LE_CONN_RSP, sizeof(rsp),
-		       &rsp);
+	__l2cap_ecred_conn_rsp_defer(chan);
 }
 
 static void l2cap_chan_connect_reject(struct l2cap_chan *chan)
@@ -848,7 +845,7 @@ void l2cap_chan_close(struct l2cap_chan *chan, int reason)
 					break;
 				case L2CAP_MODE_EXT_FLOWCTL:
 					l2cap_chan_ecred_connect_reject(chan);
-					break;
+					return;
 				}
 			}
 		}
@@ -3934,43 +3931,86 @@ void __l2cap_le_connect_rsp_defer(struct l2cap_chan *chan)
 		       &rsp);
 }
 
-void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan)
+static void l2cap_ecred_list_defer(struct l2cap_chan *chan, void *data)
 {
+	int *result = data;
+
+	if (*result || test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+		return;
+
+	switch (chan->state) {
+	case BT_CONNECT2:
+		/* If channel still pending accept add to result */
+		(*result)++;
+		return;
+	case BT_CONNECTED:
+		return;
+	default:
+		/* If not connected or pending accept it has been refused */
+		*result = -ECONNREFUSED;
+		return;
+	}
+}
+
+struct l2cap_ecred_rsp_data {
 	struct {
 		struct l2cap_ecred_conn_rsp rsp;
-		__le16 dcid[5];
+		__le16 scid[L2CAP_ECRED_MAX_CID];
 	} __packed pdu;
+	int count;
+};
+
+static void l2cap_ecred_rsp_defer(struct l2cap_chan *chan, void *data)
+{
+	struct l2cap_ecred_rsp_data *rsp = data;
+
+	if (test_bit(FLAG_ECRED_CONN_REQ_SENT, &chan->flags))
+		return;
+
+	/* Reset ident so only one response is sent */
+	chan->ident = 0;
+
+	/* Include all channels pending with the same ident */
+	if (!rsp->pdu.rsp.result)
+		rsp->pdu.rsp.dcid[rsp->count++] = cpu_to_le16(chan->scid);
+	else
+		l2cap_chan_del(chan, ECONNRESET);
+}
+
+void __l2cap_ecred_conn_rsp_defer(struct l2cap_chan *chan)
+{
 	struct l2cap_conn *conn = chan->conn;
-	u16 ident = chan->ident;
-	int i = 0;
+	struct l2cap_ecred_rsp_data data;
+	u16 id = chan->ident;
+	int result = 0;
 
-	if (!ident)
+	if (!id)
 		return;
 
-	BT_DBG("chan %p ident %d", chan, ident);
+	BT_DBG("chan %p id %d", chan, id);
 
-	pdu.rsp.mtu     = cpu_to_le16(chan->imtu);
-	pdu.rsp.mps     = cpu_to_le16(chan->mps);
-	pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
-	pdu.rsp.result  = cpu_to_le16(L2CAP_CR_LE_SUCCESS);
+	memset(&data, 0, sizeof(data));
 
-	mutex_lock(&conn->chan_lock);
+	data.pdu.rsp.mtu     = cpu_to_le16(chan->imtu);
+	data.pdu.rsp.mps     = cpu_to_le16(chan->mps);
+	data.pdu.rsp.credits = cpu_to_le16(chan->rx_credits);
+	data.pdu.rsp.result  = cpu_to_le16(L2CAP_CR_LE_SUCCESS);
 
-	list_for_each_entry(chan, &conn->chan_l, list) {
-		if (chan->ident != ident)
-			continue;
+	/* Verify that all channels are ready */
+	__l2cap_chan_list_id(conn, id, l2cap_ecred_list_defer, &result);
 
-		/* Reset ident so only one response is sent */
-		chan->ident = 0;
+	if (result > 0)
+		return;
 
-		/* Include all channels pending with the same ident */
-		pdu.dcid[i++] = cpu_to_le16(chan->scid);
-	}
+	if (result < 0)
+		data.pdu.rsp.result = cpu_to_le16(L2CAP_CR_LE_AUTHORIZATION);
 
-	mutex_unlock(&conn->chan_lock);
+	/* Build response */
+	__l2cap_chan_list_id(conn, id, l2cap_ecred_rsp_defer, &data);
 
-	l2cap_send_cmd(conn, ident, L2CAP_ECRED_CONN_RSP,
-			sizeof(pdu.rsp) + i * sizeof(__le16), &pdu);
+	l2cap_send_cmd(conn, id, L2CAP_ECRED_CONN_RSP,
+		       sizeof(data.pdu.rsp) + (data.count * sizeof(__le16)),
+		       &data.pdu);
 }
 
 void __l2cap_connect_rsp_defer(struct l2cap_chan *chan)
@@ -5952,7 +5992,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	struct l2cap_ecred_conn_req *req = (void *) data;
 	struct {
 		struct l2cap_ecred_conn_rsp rsp;
-		__le16 dcid[5];
+		__le16 dcid[L2CAP_ECRED_MAX_CID];
 	} __packed pdu;
 	struct l2cap_chan *chan, *pchan;
 	u16 mtu, mps;
@@ -5969,6 +6009,14 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		goto response;
 	}
 
+	cmd_len -= sizeof(*req);
+	num_scid = cmd_len / sizeof(u16);
+
+	if (num_scid > ARRAY_SIZE(pdu.dcid)) {
+		result = L2CAP_CR_LE_INVALID_PARAMS;
+		goto response;
+	}
+
 	mtu  = __le16_to_cpu(req->mtu);
 	mps  = __le16_to_cpu(req->mps);
 
@@ -6013,8 +6061,6 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 	}
 
 	result = L2CAP_CR_LE_SUCCESS;
-	cmd_len -= sizeof(*req);
-	num_scid = cmd_len / sizeof(u16);
 
 	for (i = 0; i < num_scid; i++) {
 		u16 scid = __le16_to_cpu(req->scid[i]);
@@ -6067,6 +6113,7 @@ static inline int l2cap_ecred_conn_req(struct l2cap_conn *conn,
 		__set_chan_timer(chan, chan->ops->get_sndtimeo(chan));
 
 		chan->ident = cmd->ident;
+		chan->mode = L2CAP_MODE_EXT_FLOWCTL;
 
 		if (test_bit(FLAG_DEFER_SETUP, &chan->flags)) {
 			l2cap_state_change(chan, BT_CONNECT2);
diff --git a/net/can/bcm.c b/net/can/bcm.c
index afa82adaf6cd..ddba4e12da78 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -936,6 +936,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 
 			cf = op->frames + op->cfsiz * i;
 			err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
+			if (err < 0)
+				goto free_op;
 
 			if (op->flags & CAN_FD_FRAME) {
 				if (cf->len > 64)
@@ -945,12 +947,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 					err = -EINVAL;
 			}
 
-			if (err < 0) {
-				if (op->frames != &op->sframe)
-					kfree(op->frames);
-				kfree(op);
-				return err;
-			}
+			if (err < 0)
+				goto free_op;
 
 			if (msg_head->flags & TX_CP_CAN_ID) {
 				/* copy can_id into frame */
@@ -1021,6 +1019,12 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
 		bcm_tx_start_timer(op);
 
 	return msg_head->nframes * op->cfsiz + MHSIZ;
+
+free_op:
+	if (op->frames != &op->sframe)
+		kfree(op->frames);
+	kfree(op);
+	return err;
 }
 
 /*
diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 20cb6b7dbc69..afc97d65cf2d 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -380,7 +380,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit())
+		if (port->hsr->prot_version != PRP_V1 && net_ratelimit())
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 65ead8a74933..9d1a50657104 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -547,7 +547,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -556,7 +556,7 @@ static void erspan_fb_xmit(struct sk_buff *skb, struct net_device *dev)
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 0010f9e54f13..2332b5b81c55 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -959,7 +959,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		truncate = true;
 	}
 
-	nhoff = skb_network_header(skb) - skb_mac_header(skb);
+	nhoff = skb_network_offset(skb);
 	if (skb->protocol == htons(ETH_P_IP) &&
 	    (ntohs(ip_hdr(skb)->tot_len) > skb->len - nhoff))
 		truncate = true;
@@ -968,7 +968,7 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 		int thoff;
 
 		if (skb_transport_header_was_set(skb))
-			thoff = skb_transport_header(skb) - skb_mac_header(skb);
+			thoff = skb_transport_offset(skb);
 		else
 			thoff = nhoff + sizeof(struct ipv6hdr);
 		if (ntohs(ipv6_hdr(skb)->payload_len) > skb->len - thoff)
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index b9404b056087..eb79f6844466 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -141,12 +141,14 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 u16 __ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta, struct sk_buff *skb)
 {
+	const struct ethhdr *eth = (void *)skb->data;
 	struct mac80211_qos_map *qos_map;
 	bool qos;
 
 	/* all mesh/ocb stations are required to support WME */
-	if (sta && (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-		    sdata->vif.type == NL80211_IFTYPE_OCB))
+	if ((sdata->vif.type == NL80211_IFTYPE_MESH_POINT &&
+	    !is_multicast_ether_addr(eth->h_dest)) ||
+	    (sdata->vif.type == NL80211_IFTYPE_OCB && sta))
 		qos = true;
 	else if (sta)
 		qos = sta->sta.wme;
diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index e537085b184f..54863e68f304 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -386,13 +386,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_128->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_128_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_128_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_128->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_128_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_128,
 				 sizeof(*crypto_info_aes_gcm_128)))
@@ -410,13 +408,11 @@ static int do_tls_getsockopt_conf(struct sock *sk, char __user *optval,
 			rc = -EINVAL;
 			goto out;
 		}
-		lock_sock(sk);
 		memcpy(crypto_info_aes_gcm_256->iv,
 		       cctx->iv + TLS_CIPHER_AES_GCM_256_SALT_SIZE,
 		       TLS_CIPHER_AES_GCM_256_IV_SIZE);
 		memcpy(crypto_info_aes_gcm_256->rec_seq, cctx->rec_seq,
 		       TLS_CIPHER_AES_GCM_256_REC_SEQ_SIZE);
-		release_sock(sk);
 		if (copy_to_user(optval,
 				 crypto_info_aes_gcm_256,
 				 sizeof(*crypto_info_aes_gcm_256)))
@@ -436,6 +432,8 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 {
 	int rc = 0;
 
+	lock_sock(sk);
+
 	switch (optname) {
 	case TLS_TX:
 	case TLS_RX:
@@ -446,6 +444,9 @@ static int do_tls_getsockopt(struct sock *sk, int optname,
 		rc = -ENOPROTOOPT;
 		break;
 	}
+
+	release_sock(sk);
+
 	return rc;
 }
 
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 56a28a686988..42b19feb2b6e 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -153,10 +153,11 @@ static int xdp_umem_account_pages(struct xdp_umem *umem)
 
 static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 {
-	u32 npgs_rem, chunk_size = mr->chunk_size, headroom = mr->headroom;
 	bool unaligned_chunks = mr->flags & XDP_UMEM_UNALIGNED_CHUNK_FLAG;
-	u64 npgs, addr = mr->addr, size = mr->len;
-	unsigned int chunks, chunks_rem;
+	u32 chunk_size = mr->chunk_size, headroom = mr->headroom;
+	u64 addr = mr->addr, size = mr->len;
+	u32 chunks_rem, npgs_rem;
+	u64 chunks, npgs;
 	int err;
 
 	if (chunk_size < XDP_UMEM_MIN_CHUNK_SIZE || chunk_size > PAGE_SIZE) {
@@ -191,8 +192,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (npgs > U32_MAX)
 		return -EINVAL;
 
-	chunks = (unsigned int)div_u64_rem(size, chunk_size, &chunks_rem);
-	if (chunks == 0)
+	chunks = div_u64_rem(size, chunk_size, &chunks_rem);
+	if (!chunks || chunks > U32_MAX)
 		return -EINVAL;
 
 	if (!unaligned_chunks && chunks_rem)
@@ -205,7 +206,7 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	umem->headroom = headroom;
 	umem->chunk_size = chunk_size;
 	umem->chunks = chunks;
-	umem->npgs = (u32)npgs;
+	umem->npgs = npgs;
 	umem->pgs = NULL;
 	umem->user = NULL;
 	umem->flags = mr->flags;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 2da4404276f0..07a0ef2baacd 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -38,9 +38,12 @@ static void cache_requested_key(struct key *key)
 #ifdef CONFIG_KEYS_REQUEST_CACHE
 	struct task_struct *t = current;
 
-	key_put(t->cached_requested_key);
-	t->cached_requested_key = key_get(key);
-	set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	/* Do not cache key if it is a kernel thread */
+	if (!(t->flags & PF_KTHREAD)) {
+		key_put(t->cached_requested_key);
+		t->cached_requested_key = key_get(key);
+		set_tsk_thread_flag(t, TIF_NOTIFY_RESUME);
+	}
 #endif
 }
 
diff --git a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
index 3d6914c64c4a..4cdaeefeb688 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -430,7 +430,7 @@ void HPI_6205(struct hpi_message *phm, struct hpi_response *phr)
 		pao = hpi_find_adapter(phm->adapter_index);
 	} else {
 		/* subsys messages don't address an adapter */
-		_HPI_6205(NULL, phm, phr);
+		phr->error = HPI_ERROR_INVALID_OBJ_INDEX;
 		return;
 	}
 
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 24c2638cde37..6057084da4cf 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4108,8 +4108,10 @@ static int tuning_ctl_set(struct hda_codec *codec, hda_nid_t nid,
 
 	for (i = 0; i < TUNING_CTLS_COUNT; i++)
 		if (nid == ca0132_tuning_ctls[i].nid)
-			break;
+			goto found;
 
+	return -EINVAL;
+found:
 	snd_hda_power_up(codec);
 	dspio_set_param(codec, ca0132_tuning_ctls[i].mid, 0x20,
 			ca0132_tuning_ctls[i].req,
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 48b802563c2d..e35c470eb481 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -973,7 +973,10 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_PINCFG_LENOVO_NOTEBOOK),
+	/* NOTE: we'd need to extend the quirk for 17aa:3977 as the same
+	 * PCI SSID is used on multiple Lenovo models
+	 */
+	SND_PCI_QUIRK(0x17aa, 0x3977, "Lenovo IdeaPad U310", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad", CXT_FIXUP_THINKPAD_ACPI),
@@ -996,6 +999,7 @@ static const struct hda_model_fixup cxt5066_fixup_models[] = {
 	{ .id = CXT_FIXUP_MUTE_LED_GPIO, .name = "mute-led-gpio" },
 	{ .id = CXT_FIXUP_HP_ZBOOK_MUTE_LED, .name = "hp-zbook-mute-led" },
 	{ .id = CXT_FIXUP_HP_MIC_NO_PRESENCE, .name = "hp-mic-fix" },
+	{ .id = CXT_PINCFG_LENOVO_NOTEBOOK, .name = "lenovo-20149" },
 	{}
 };
 
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2cf6600c9ca8..2af9cd7b7999 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9253,6 +9253,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
+	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 9b0d18a7bf35..27fd10b976f7 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -78,7 +78,8 @@ static int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev,
 
 		if (io_port == 1) {
 			/* auto-detect */
-			if (!(io_port = pci_resource_start(chip->pci, 2)))
+			io_port = pci_resource_start(chip->pci, 2);
+			if (!io_port)
 				return -ENODEV;
 		}
 	} else {
@@ -87,7 +88,8 @@ static int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev,
 			for (io_port = 0x201; io_port <= 0x205; io_port++) {
 				if (io_port == 0x203)
 					continue;
-				if ((r = request_region(io_port, 1, "YMFPCI gameport")) != NULL)
+				r = request_region(io_port, 1, "YMFPCI gameport");
+				if (r)
 					break;
 			}
 			if (!r) {
@@ -108,10 +110,13 @@ static int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev,
 		}
 	}
 
-	if (!r && !(r = request_region(io_port, 1, "YMFPCI gameport"))) {
-		dev_err(chip->card->dev,
-			"joystick port %#x is in use.\n", io_port);
-		return -EBUSY;
+	if (!r) {
+		r = request_region(io_port, 1, "YMFPCI gameport");
+		if (!r) {
+			dev_err(chip->card->dev,
+				"joystick port %#x is in use.\n", io_port);
+			return -EBUSY;
+		}
 	}
 
 	chip->gameport = gp = gameport_allocate_port();
@@ -199,8 +204,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 			/* auto-detect */
 			fm_port[dev] = pci_resource_start(pci, 1);
 		}
-		if (fm_port[dev] > 0 &&
-		    (fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3")) != NULL) {
+		if (fm_port[dev] > 0)
+			fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3");
+		if (fm_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_FMEN;
 			pci_write_config_word(pci, PCIR_DSXG_FMBASE, fm_port[dev]);
 		}
@@ -208,8 +214,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 			/* auto-detect */
 			mpu_port[dev] = pci_resource_start(pci, 1) + 0x20;
 		}
-		if (mpu_port[dev] > 0 &&
-		    (mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401")) != NULL) {
+		if (mpu_port[dev] > 0)
+			mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401");
+		if (mpu_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_MEN;
 			pci_write_config_word(pci, PCIR_DSXG_MPU401BASE, mpu_port[dev]);
 		}
@@ -221,8 +228,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		case 0x3a8: legacy_ctrl2 |= 3; break;
 		default: fm_port[dev] = 0; break;
 		}
-		if (fm_port[dev] > 0 &&
-		    (fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3")) != NULL) {
+		if (fm_port[dev] > 0)
+			fm_res = request_region(fm_port[dev], 4, "YMFPCI OPL3");
+		if (fm_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_FMEN;
 		} else {
 			legacy_ctrl2 &= ~YMFPCI_LEGACY2_FMIO;
@@ -235,8 +243,9 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		case 0x334: legacy_ctrl2 |= 3 << 4; break;
 		default: mpu_port[dev] = 0; break;
 		}
-		if (mpu_port[dev] > 0 &&
-		    (mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401")) != NULL) {
+		if (mpu_port[dev] > 0)
+			mpu_res = request_region(mpu_port[dev], 2, "YMFPCI MPU401");
+		if (mpu_res) {
 			legacy_ctrl |= YMFPCI_LEGACY_MEN;
 		} else {
 			legacy_ctrl2 &= ~YMFPCI_LEGACY2_MPUIO;
@@ -250,9 +259,8 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 	pci_read_config_word(pci, PCIR_DSXG_LEGACY, &old_legacy_ctrl);
 	pci_write_config_word(pci, PCIR_DSXG_LEGACY, legacy_ctrl);
 	pci_write_config_word(pci, PCIR_DSXG_ELEGACY, legacy_ctrl2);
-	if ((err = snd_ymfpci_create(card, pci,
-				     old_legacy_ctrl,
-			 	     &chip)) < 0) {
+	err = snd_ymfpci_create(card, pci, old_legacy_ctrl, &chip);
+	if (err  < 0) {
 		release_and_free_resource(mpu_res);
 		release_and_free_resource(fm_res);
 		goto free_card;
@@ -293,11 +301,12 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		goto free_card;
 
 	if (chip->mpu_res) {
-		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_YMFPCI,
-					       mpu_port[dev],
-					       MPU401_INFO_INTEGRATED |
-					       MPU401_INFO_IRQ_HOOK,
-					       -1, &chip->rawmidi)) < 0) {
+		err = snd_mpu401_uart_new(card, 0, MPU401_HW_YMFPCI,
+					  mpu_port[dev],
+					  MPU401_INFO_INTEGRATED |
+					  MPU401_INFO_IRQ_HOOK,
+					  -1, &chip->rawmidi);
+		if (err < 0) {
 			dev_warn(card->dev,
 				 "cannot initialize MPU401 at 0x%lx, skipping...\n",
 				 mpu_port[dev]);
@@ -306,18 +315,22 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		}
 	}
 	if (chip->fm_res) {
-		if ((err = snd_opl3_create(card,
-					   fm_port[dev],
-					   fm_port[dev] + 2,
-					   OPL3_HW_OPL3, 1, &opl3)) < 0) {
+		err = snd_opl3_create(card,
+				      fm_port[dev],
+				      fm_port[dev] + 2,
+				      OPL3_HW_OPL3, 1, &opl3);
+		if (err < 0) {
 			dev_warn(card->dev,
 				 "cannot initialize FM OPL3 at 0x%lx, skipping...\n",
 				 fm_port[dev]);
 			legacy_ctrl &= ~YMFPCI_LEGACY_FMEN;
 			pci_write_config_word(pci, PCIR_DSXG_LEGACY, legacy_ctrl);
-		} else if ((err = snd_opl3_hwdep_new(opl3, 0, 1, NULL)) < 0) {
-			dev_err(card->dev, "cannot create opl3 hwdep\n");
-			goto free_card;
+		} else {
+			err = snd_opl3_hwdep_new(opl3, 0, 1, NULL);
+			if (err < 0) {
+				dev_err(card->dev, "cannot create opl3 hwdep\n");
+				goto free_card;
+			}
 		}
 	}
 
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index cacc6a9d14c8..0cd9b4029dab 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -292,7 +292,8 @@ static void snd_ymfpci_pcm_interrupt(struct snd_ymfpci *chip, struct snd_ymfpci_
 	struct snd_ymfpci_pcm *ypcm;
 	u32 pos, delta;
 	
-	if ((ypcm = voice->ypcm) == NULL)
+	ypcm = voice->ypcm;
+	if (!ypcm)
 		return;
 	if (ypcm->substream == NULL)
 		return;
@@ -628,7 +629,8 @@ static int snd_ymfpci_playback_hw_params(struct snd_pcm_substream *substream,
 	struct snd_ymfpci_pcm *ypcm = runtime->private_data;
 	int err;
 
-	if ((err = snd_ymfpci_pcm_voice_alloc(ypcm, params_channels(hw_params))) < 0)
+	err = snd_ymfpci_pcm_voice_alloc(ypcm, params_channels(hw_params));
+	if (err < 0)
 		return err;
 	return 0;
 }
@@ -932,7 +934,8 @@ static int snd_ymfpci_playback_open(struct snd_pcm_substream *substream)
 	struct snd_ymfpci_pcm *ypcm;
 	int err;
 	
-	if ((err = snd_ymfpci_playback_open_1(substream)) < 0)
+	err = snd_ymfpci_playback_open_1(substream);
+	if (err < 0)
 		return err;
 	ypcm = runtime->private_data;
 	ypcm->output_front = 1;
@@ -954,7 +957,8 @@ static int snd_ymfpci_playback_spdif_open(struct snd_pcm_substream *substream)
 	struct snd_ymfpci_pcm *ypcm;
 	int err;
 	
-	if ((err = snd_ymfpci_playback_open_1(substream)) < 0)
+	err = snd_ymfpci_playback_open_1(substream);
+	if (err < 0)
 		return err;
 	ypcm = runtime->private_data;
 	ypcm->output_front = 0;
@@ -982,7 +986,8 @@ static int snd_ymfpci_playback_4ch_open(struct snd_pcm_substream *substream)
 	struct snd_ymfpci_pcm *ypcm;
 	int err;
 	
-	if ((err = snd_ymfpci_playback_open_1(substream)) < 0)
+	err = snd_ymfpci_playback_open_1(substream);
+	if (err < 0)
 		return err;
 	ypcm = runtime->private_data;
 	ypcm->output_front = 0;
@@ -1124,7 +1129,8 @@ int snd_ymfpci_pcm(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI", device, 32, 1, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI", device, 32, 1, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1157,7 +1163,8 @@ int snd_ymfpci_pcm2(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI - PCM2", device, 0, 1, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI - PCM2", device, 0, 1, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1190,7 +1197,8 @@ int snd_ymfpci_pcm_spdif(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI - IEC958", device, 1, 0, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI - IEC958", device, 1, 0, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1230,7 +1238,8 @@ int snd_ymfpci_pcm_4ch(struct snd_ymfpci *chip, int device)
 	struct snd_pcm *pcm;
 	int err;
 
-	if ((err = snd_pcm_new(chip->card, "YMFPCI - Rear", device, 1, 0, &pcm)) < 0)
+	err = snd_pcm_new(chip->card, "YMFPCI - Rear", device, 1, 0, &pcm);
+	if (err < 0)
 		return err;
 	pcm->private_data = chip;
 
@@ -1785,7 +1794,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 		.read = snd_ymfpci_codec_read,
 	};
 
-	if ((err = snd_ac97_bus(chip->card, 0, &ops, chip, &chip->ac97_bus)) < 0)
+	err = snd_ac97_bus(chip->card, 0, &ops, chip, &chip->ac97_bus);
+	if (err < 0)
 		return err;
 	chip->ac97_bus->private_free = snd_ymfpci_mixer_free_ac97_bus;
 	chip->ac97_bus->no_vra = 1; /* YMFPCI doesn't need VRA */
@@ -1793,7 +1803,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 	memset(&ac97, 0, sizeof(ac97));
 	ac97.private_data = chip;
 	ac97.private_free = snd_ymfpci_mixer_free_ac97;
-	if ((err = snd_ac97_mixer(chip->ac97_bus, &ac97, &chip->ac97)) < 0)
+	err = snd_ac97_mixer(chip->ac97_bus, &ac97, &chip->ac97);
+	if (err < 0)
 		return err;
 
 	/* to be sure */
@@ -1801,7 +1812,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 			     AC97_EA_VRA|AC97_EA_VRM, 0);
 
 	for (idx = 0; idx < ARRAY_SIZE(snd_ymfpci_controls); idx++) {
-		if ((err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_controls[idx], chip))) < 0)
+		err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_controls[idx], chip));
+		if (err < 0)
 			return err;
 	}
 	if (chip->ac97->ext_id & AC97_EI_SDAC) {
@@ -1814,27 +1826,37 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 	/* add S/PDIF control */
 	if (snd_BUG_ON(!chip->pcm_spdif))
 		return -ENXIO;
-	if ((err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_spdif_default, chip))) < 0)
+	kctl = snd_ctl_new1(&snd_ymfpci_spdif_default, chip);
+	err = snd_ctl_add(chip->card, kctl);
+	if (err < 0)
 		return err;
 	kctl->id.device = chip->pcm_spdif->device;
-	if ((err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_spdif_mask, chip))) < 0)
+	kctl = snd_ctl_new1(&snd_ymfpci_spdif_mask, chip);
+	err = snd_ctl_add(chip->card, kctl);
+	if (err < 0)
 		return err;
 	kctl->id.device = chip->pcm_spdif->device;
-	if ((err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_spdif_stream, chip))) < 0)
+	kctl = snd_ctl_new1(&snd_ymfpci_spdif_stream, chip);
+	err = snd_ctl_add(chip->card, kctl);
+	if (err < 0)
 		return err;
 	kctl->id.device = chip->pcm_spdif->device;
 	chip->spdif_pcm_ctl = kctl;
 
 	/* direct recording source */
-	if (chip->device_id == PCI_DEVICE_ID_YAMAHA_754 &&
-	    (err = snd_ctl_add(chip->card, kctl = snd_ctl_new1(&snd_ymfpci_drec_source, chip))) < 0)
-		return err;
+	if (chip->device_id == PCI_DEVICE_ID_YAMAHA_754) {
+		kctl = snd_ctl_new1(&snd_ymfpci_drec_source, chip);
+		err = snd_ctl_add(chip->card, kctl);
+		if (err < 0)
+			return err;
+	}
 
 	/*
 	 * shared rear/line-in
 	 */
 	if (rear_switch) {
-		if ((err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_rear_shared, chip))) < 0)
+		err = snd_ctl_add(chip->card, snd_ctl_new1(&snd_ymfpci_rear_shared, chip));
+		if (err < 0)
 			return err;
 	}
 
@@ -1847,7 +1869,8 @@ int snd_ymfpci_mixer(struct snd_ymfpci *chip, int rear_switch)
 		kctl->id.device = chip->pcm->device;
 		kctl->id.subdevice = idx;
 		kctl->private_value = (unsigned long)substream;
-		if ((err = snd_ctl_add(chip->card, kctl)) < 0)
+		err = snd_ctl_add(chip->card, kctl);
+		if (err < 0)
 			return err;
 		chip->pcm_mixer[idx].left = 0x8000;
 		chip->pcm_mixer[idx].right = 0x8000;
@@ -1928,7 +1951,8 @@ int snd_ymfpci_timer(struct snd_ymfpci *chip, int device)
 	tid.card = chip->card->number;
 	tid.device = device;
 	tid.subdevice = 0;
-	if ((err = snd_timer_new(chip->card, "YMFPCI", &tid, &timer)) >= 0) {
+	err = snd_timer_new(chip->card, "YMFPCI", &tid, &timer);
+	if (err >= 0) {
 		strcpy(timer->name, "YMFPCI timer");
 		timer->private_data = chip;
 		timer->hw = snd_ymfpci_timer_hw;
@@ -2140,7 +2164,7 @@ static int snd_ymfpci_memalloc(struct snd_ymfpci *chip)
 	chip->work_base = ptr;
 	chip->work_base_addr = ptr_addr;
 	
-	snd_BUG_ON(ptr + chip->work_size !=
+	snd_BUG_ON(ptr + PAGE_ALIGN(chip->work_size) !=
 		   chip->work_ptr.area + chip->work_ptr.bytes);
 
 	snd_ymfpci_writel(chip, YDSXGR_PLAYCTRLBASE, chip->bank_base_playback_addr);
@@ -2334,7 +2358,8 @@ int snd_ymfpci_create(struct snd_card *card,
 	*rchip = NULL;
 
 	/* enable PCI device */
-	if ((err = pci_enable_device(pci)) < 0)
+	err = pci_enable_device(pci);
+	if (err < 0)
 		return err;
 
 	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
@@ -2357,7 +2382,8 @@ int snd_ymfpci_create(struct snd_card *card,
 	pci_set_master(pci);
 	chip->src441_used = -1;
 
-	if ((chip->res_reg_area = request_mem_region(chip->reg_area_phys, 0x8000, "YMFPCI")) == NULL) {
+	chip->res_reg_area = request_mem_region(chip->reg_area_phys, 0x8000, "YMFPCI");
+	if (!chip->res_reg_area) {
 		dev_err(chip->card->dev,
 			"unable to grab memory region 0x%lx-0x%lx\n",
 			chip->reg_area_phys, chip->reg_area_phys + 0x8000 - 1);
diff --git a/sound/usb/format.c b/sound/usb/format.c
index e8a63ea2189d..e0fda244a942 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -40,8 +40,12 @@ static u64 parse_audio_format_i_type(struct snd_usb_audio *chip,
 	case UAC_VERSION_1:
 	default: {
 		struct uac_format_type_i_discrete_descriptor *fmt = _fmt;
-		if (format >= 64)
-			return 0; /* invalid format */
+		if (format >= 64) {
+			usb_audio_info(chip,
+				       "%u:%d: invalid format type 0x%llx is detected, processed as PCM\n",
+				       fp->iface, fp->altsetting, format);
+			format = UAC_FORMAT_TYPE_I_PCM;
+		}
 		sample_width = fmt->bBitResolution;
 		sample_bytes = fmt->bSubframeSize;
 		format = 1ULL << format;
diff --git a/tools/bootconfig/test-bootconfig.sh b/tools/bootconfig/test-bootconfig.sh
index baed891d0ba4..e36f178f7dcb 100755
--- a/tools/bootconfig/test-bootconfig.sh
+++ b/tools/bootconfig/test-bootconfig.sh
@@ -87,10 +87,14 @@ xfail grep -i "error" $OUTFILE
 
 echo "Max node number check"
 
-echo -n > $TEMPCONF
-for i in `seq 1 1024` ; do
-   echo "node$i" >> $TEMPCONF
-done
+awk '
+BEGIN {
+  for (i = 0; i < 26; i += 1)
+      printf("%c\n", 65 + i % 26)
+  for (i = 26; i < 8192; i += 1)
+      printf("%c%c%c\n", 65 + i % 26, 65 + (i / 26) % 26, 65 + (i / 26 / 26))
+}
+' > $TEMPCONF
 xpass $BOOTCONF -a $TEMPCONF $INITRD
 
 echo "badnode" >> $TEMPCONF
diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 0e2d63da24e9..558d34fbd331 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -792,14 +792,9 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 				 const struct btf_type *t)
 {
 	const struct btf_member *m;
-	int align, i, bit_sz;
+	int max_align = 1, align, i, bit_sz;
 	__u16 vlen;
 
-	align = btf__align_of(btf, id);
-	/* size of a non-packed struct has to be a multiple of its alignment*/
-	if (align && t->size % align)
-		return true;
-
 	m = btf_members(t);
 	vlen = btf_vlen(t);
 	/* all non-bitfield fields have to be naturally aligned */
@@ -808,8 +803,11 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 		bit_sz = btf_member_bitfield_size(t, i);
 		if (align && bit_sz == 0 && m->offset % (8 * align) != 0)
 			return true;
+		max_align = max(align, max_align);
 	}
-
+	/* size of a non-packed struct has to be a multiple of its alignment */
+	if (t->size % max_align != 0)
+		return true;
 	/*
 	 * if original struct was marked as packed, but its layout is
 	 * naturally aligned, we'll detect that it's not packed
@@ -817,44 +815,97 @@ static bool btf_is_struct_packed(const struct btf *btf, __u32 id,
 	return false;
 }
 
-static int chip_away_bits(int total, int at_most)
-{
-	return total % at_most ? : at_most;
-}
-
 static void btf_dump_emit_bit_padding(const struct btf_dump *d,
-				      int cur_off, int m_off, int m_bit_sz,
-				      int align, int lvl)
+				      int cur_off, int next_off, int next_align,
+				      bool in_bitfield, int lvl)
 {
-	int off_diff = m_off - cur_off;
-	int ptr_bits = d->ptr_sz * 8;
+	const struct {
+		const char *name;
+		int bits;
+	} pads[] = {
+		{"long", d->ptr_sz * 8}, {"int", 32}, {"short", 16}, {"char", 8}
+	};
+	int new_off, pad_bits, bits, i;
+	const char *pad_type;
+
+	if (cur_off >= next_off)
+		return; /* no gap */
+
+	/* For filling out padding we want to take advantage of
+	 * natural alignment rules to minimize unnecessary explicit
+	 * padding. First, we find the largest type (among long, int,
+	 * short, or char) that can be used to force naturally aligned
+	 * boundary. Once determined, we'll use such type to fill in
+	 * the remaining padding gap. In some cases we can rely on
+	 * compiler filling some gaps, but sometimes we need to force
+	 * alignment to close natural alignment with markers like
+	 * `long: 0` (this is always the case for bitfields).  Note
+	 * that even if struct itself has, let's say 4-byte alignment
+	 * (i.e., it only uses up to int-aligned types), using `long:
+	 * X;` explicit padding doesn't actually change struct's
+	 * overall alignment requirements, but compiler does take into
+	 * account that type's (long, in this example) natural
+	 * alignment requirements when adding implicit padding. We use
+	 * this fact heavily and don't worry about ruining correct
+	 * struct alignment requirement.
+	 */
+	for (i = 0; i < ARRAY_SIZE(pads); i++) {
+		pad_bits = pads[i].bits;
+		pad_type = pads[i].name;
 
-	if (off_diff <= 0)
-		/* no gap */
-		return;
-	if (m_bit_sz == 0 && off_diff < align * 8)
-		/* natural padding will take care of a gap */
-		return;
+		new_off = roundup(cur_off, pad_bits);
+		if (new_off <= next_off)
+			break;
+	}
 
-	while (off_diff > 0) {
-		const char *pad_type;
-		int pad_bits;
-
-		if (ptr_bits > 32 && off_diff > 32) {
-			pad_type = "long";
-			pad_bits = chip_away_bits(off_diff, ptr_bits);
-		} else if (off_diff > 16) {
-			pad_type = "int";
-			pad_bits = chip_away_bits(off_diff, 32);
-		} else if (off_diff > 8) {
-			pad_type = "short";
-			pad_bits = chip_away_bits(off_diff, 16);
-		} else {
-			pad_type = "char";
-			pad_bits = chip_away_bits(off_diff, 8);
+	if (new_off > cur_off && new_off <= next_off) {
+		/* We need explicit `<type>: 0` aligning mark if next
+		 * field is right on alignment offset and its
+		 * alignment requirement is less strict than <type>'s
+		 * alignment (so compiler won't naturally align to the
+		 * offset we expect), or if subsequent `<type>: X`,
+		 * will actually completely fit in the remaining hole,
+		 * making compiler basically ignore `<type>: X`
+		 * completely.
+		 */
+		if (in_bitfield ||
+		    (new_off == next_off && roundup(cur_off, next_align * 8) != new_off) ||
+		    (new_off != next_off && next_off - new_off <= new_off - cur_off))
+			/* but for bitfields we'll emit explicit bit count */
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type,
+					in_bitfield ? new_off - cur_off : 0);
+		cur_off = new_off;
+	}
+
+	/* Now we know we start at naturally aligned offset for a chosen
+	 * padding type (long, int, short, or char), and so the rest is just
+	 * a straightforward filling of remaining padding gap with full
+	 * `<type>: sizeof(<type>);` markers, except for the last one, which
+	 * might need smaller than sizeof(<type>) padding.
+	 */
+	while (cur_off != next_off) {
+		bits = min(next_off - cur_off, pad_bits);
+		if (bits == pad_bits) {
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, pad_bits);
+			cur_off += bits;
+			continue;
+		}
+		/* For the remainder padding that doesn't cover entire
+		 * pad_type bit length, we pick the smallest necessary type.
+		 * This is pure aesthetics, we could have just used `long`,
+		 * but having smallest necessary one communicates better the
+		 * scale of the padding gap.
+		 */
+		for (i = ARRAY_SIZE(pads) - 1; i >= 0; i--) {
+			pad_type = pads[i].name;
+			pad_bits = pads[i].bits;
+			if (pad_bits < bits)
+				continue;
+
+			btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, bits);
+			cur_off += bits;
+			break;
 		}
-		btf_dump_printf(d, "\n%s%s: %d;", pfx(lvl), pad_type, pad_bits);
-		off_diff -= pad_bits;
 	}
 }
 
@@ -873,9 +924,11 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 {
 	const struct btf_member *m = btf_members(t);
 	bool is_struct = btf_is_struct(t);
-	int align, i, packed, off = 0;
+	bool packed, prev_bitfield = false;
+	int align, i, off = 0;
 	__u16 vlen = btf_vlen(t);
 
+	align = btf__align_of(d->btf, id);
 	packed = is_struct ? btf_is_struct_packed(d->btf, id, t) : 0;
 
 	btf_dump_printf(d, "%s%s%s {",
@@ -885,33 +938,36 @@ static void btf_dump_emit_struct_def(struct btf_dump *d,
 
 	for (i = 0; i < vlen; i++, m++) {
 		const char *fname;
-		int m_off, m_sz;
+		int m_off, m_sz, m_align;
+		bool in_bitfield;
 
 		fname = btf_name_of(d, m->name_off);
 		m_sz = btf_member_bitfield_size(t, i);
 		m_off = btf_member_bit_offset(t, i);
-		align = packed ? 1 : btf__align_of(d->btf, m->type);
+		m_align = packed ? 1 : btf__align_of(d->btf, m->type);
 
-		btf_dump_emit_bit_padding(d, off, m_off, m_sz, align, lvl + 1);
+		in_bitfield = prev_bitfield && m_sz != 0;
+
+		btf_dump_emit_bit_padding(d, off, m_off, m_align, in_bitfield, lvl + 1);
 		btf_dump_printf(d, "\n%s", pfx(lvl + 1));
 		btf_dump_emit_type_decl(d, m->type, fname, lvl + 1);
 
 		if (m_sz) {
 			btf_dump_printf(d, ": %d", m_sz);
 			off = m_off + m_sz;
+			prev_bitfield = true;
 		} else {
 			m_sz = max((__s64)0, btf__resolve_size(d->btf, m->type));
 			off = m_off + m_sz * 8;
+			prev_bitfield = false;
 		}
+
 		btf_dump_printf(d, ";");
 	}
 
 	/* pad at the end, if necessary */
-	if (is_struct) {
-		align = packed ? 1 : btf__align_of(d->btf, id);
-		btf_dump_emit_bit_padding(d, off, t->size * 8, 0, align,
-					  lvl + 1);
-	}
+	if (is_struct)
+		btf_dump_emit_bit_padding(d, off, t->size * 8, align, false, lvl + 1);
 
 	if (vlen)
 		btf_dump_printf(d, "\n");
diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index f6b7e85b121c..71e3f3a68b9d 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -294,6 +294,8 @@ Alternatively, non-root users can be enabled to run turbostat this way:
 
 # chmod +r /dev/cpu/*/msr
 
+# chmod +r /dev/cpu_dma_latency
+
 .B "turbostat "
 reads hardware counters, but doesn't write them.
 So it will not interfere with the OS or other programs, including
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ef65f7eed1ec..d33c9d427e57 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -5004,7 +5004,7 @@ void print_dev_latency(void)
 
 	retval = read(fd, (void *)&value, sizeof(int));
 	if (retval != sizeof(int)) {
-		warn("read %s\n", path);
+		warn("read failed %s\n", path);
 		close(fd);
 		return;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 48b01150e703..28d22265b825 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -882,6 +882,34 @@ static struct btf_raw_test raw_tests[] = {
 	.btf_load_err = true,
 	.err_str = "Invalid elem",
 },
+{
+	.descr = "var after datasec, ptr followed by modifier",
+	.raw_types = {
+		/* .bss section */				/* [1] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_DATASEC, 0, 2),
+			sizeof(void*)+4),
+		BTF_VAR_SECINFO_ENC(4, 0, sizeof(void*)),
+		BTF_VAR_SECINFO_ENC(6, sizeof(void*), 4),
+		/* int */					/* [2] */
+		BTF_TYPE_INT_ENC(0, BTF_INT_SIGNED, 0, 32, 4),
+		/* int* */					/* [3] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_PTR, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 3, 0),			/* [4] */
+		/* const int */					/* [5] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_CONST, 0, 0), 2),
+		BTF_VAR_ENC(NAME_TBD, 5, 0),			/* [6] */
+		BTF_END_RAW,
+	},
+	.str_sec = "\0a\0b\0c\0",
+	.str_sec_size = sizeof("\0a\0b\0c\0"),
+	.map_type = BPF_MAP_TYPE_ARRAY,
+	.map_name = ".bss",
+	.key_size = sizeof(int),
+	.value_size = sizeof(void*)+4,
+	.key_type_id = 0,
+	.value_type_id = 1,
+	.max_entries = 1,
+},
 /* Test member exceeds the size of struct.
  *
  * struct A {
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
index 8f44767a75fa..22a7cd8fd9ac 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_bitfields.c
@@ -53,7 +53,7 @@ struct bitfields_only_mixed_types {
  */
 /* ------ END-EXPECTED-OUTPUT ------ */
 struct bitfield_mixed_with_others {
-	long: 4; /* char is enough as a backing field */
+	char: 4; /* char is enough as a backing field */
 	int a: 4;
 	/* 8-bit implicit padding */
 	short b; /* combined with previous bitfield */
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
index 1cef3bec1dc7..22dbd1213434 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_packing.c
@@ -58,7 +58,81 @@ union jump_code_union {
 	} __attribute__((packed));
 };
 
-/*------ END-EXPECTED-OUTPUT ------ */
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct nested_packed_but_aligned_struct {
+ *	int x1;
+ *	int x2;
+ *};
+ *
+ *struct outer_implicitly_packed_struct {
+ *	char y1;
+ *	struct nested_packed_but_aligned_struct y2;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct nested_packed_but_aligned_struct {
+	int x1;
+	int x2;
+} __attribute__((packed));
+
+struct outer_implicitly_packed_struct {
+	char y1;
+	struct nested_packed_but_aligned_struct y2;
+};
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct usb_ss_ep_comp_descriptor {
+ *	char: 8;
+ *	char bDescriptorType;
+ *	char bMaxBurst;
+ *	short wBytesPerInterval;
+ *};
+ *
+ *struct usb_host_endpoint {
+ *	long: 64;
+ *	char: 8;
+ *	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+ *	long: 0;
+ *} __attribute__((packed));
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+struct usb_ss_ep_comp_descriptor {
+	char: 8;
+	char bDescriptorType;
+	char bMaxBurst;
+	int: 0;
+	short wBytesPerInterval;
+} __attribute__((packed));
+
+struct usb_host_endpoint {
+	long: 64;
+	char: 8;
+	struct usb_ss_ep_comp_descriptor ss_ep_comp;
+	long: 0;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct nested_packed_struct {
+	int a;
+	char b;
+} __attribute__((packed));
+
+struct outer_nonpacked_struct {
+	short a;
+	struct nested_packed_struct b;
+};
+
+struct outer_packed_struct {
+	short a;
+	struct nested_packed_struct b;
+} __attribute__((packed));
+
+/* ------ END-EXPECTED-OUTPUT ------ */
 
 int f(struct {
 	struct packed_trailing_space _1;
@@ -69,6 +143,10 @@ int f(struct {
 	union union_is_never_packed _6;
 	union union_does_not_need_packing _7;
 	union jump_code_union _8;
+	struct outer_implicitly_packed_struct _9;
+	struct usb_host_endpoint _10;
+	struct outer_nonpacked_struct _11;
+	struct outer_packed_struct _12;
 } *_)
 {
 	return 0;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
index 35c512818a56..0b3cdffbfcf7 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_padding.c
@@ -19,7 +19,7 @@ struct padded_implicitly {
 /*
  *struct padded_explicitly {
  *	int a;
- *	int: 32;
+ *	long: 0;
  *	int b;
  *};
  *
@@ -28,41 +28,28 @@ struct padded_implicitly {
 
 struct padded_explicitly {
 	int a;
-	int: 1; /* algo will explicitly pad with full 32 bits here */
+	int: 1; /* algo will emit aligning `long: 0;` here */
 	int b;
 };
 
 /* ----- START-EXPECTED-OUTPUT ----- */
-/*
- *struct padded_a_lot {
- *	int a;
- *	long: 32;
- *	long: 64;
- *	long: 64;
- *	int b;
- *};
- *
- */
-/* ------ END-EXPECTED-OUTPUT ------ */
-
 struct padded_a_lot {
 	int a;
-	/* 32 bit of implicit padding here, which algo will make explicit */
 	long: 64;
 	long: 64;
 	int b;
 };
 
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 /* ----- START-EXPECTED-OUTPUT ----- */
 /*
  *struct padded_cache_line {
  *	int a;
- *	long: 32;
  *	long: 64;
  *	long: 64;
  *	long: 64;
  *	int b;
- *	long: 32;
  *	long: 64;
  *	long: 64;
  *	long: 64;
@@ -85,7 +72,7 @@ struct padded_cache_line {
  *struct zone {
  *	int a;
  *	short b;
- *	short: 16;
+ *	long: 0;
  *	struct zone_padding __pad__;
  *};
  *
@@ -102,12 +89,160 @@ struct zone {
 	struct zone_padding __pad__;
 };
 
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct padding_wo_named_members {
+	long: 64;
+	long: 64;
+};
+
+struct padding_weird_1 {
+	int a;
+	long: 64;
+	short: 16;
+	short b;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+/*
+ *struct padding_weird_2 {
+ *	long: 56;
+ *	char a;
+ *	long: 56;
+ *	char b;
+ *	char: 8;
+ *};
+ *
+ */
+/* ------ END-EXPECTED-OUTPUT ------ */
+struct padding_weird_2 {
+	int: 32;	/* these paddings will be collapsed into `long: 56;` */
+	short: 16;
+	char: 8;
+	char a;
+	int: 32;	/* these paddings will be collapsed into `long: 56;` */
+	short: 16;
+	char: 8;
+	char b;
+	char: 8;
+};
+
+/* ----- START-EXPECTED-OUTPUT ----- */
+struct exact_1byte {
+	char x;
+};
+
+struct padded_1byte {
+	char: 8;
+};
+
+struct exact_2bytes {
+	short x;
+};
+
+struct padded_2bytes {
+	short: 16;
+};
+
+struct exact_4bytes {
+	int x;
+};
+
+struct padded_4bytes {
+	int: 32;
+};
+
+struct exact_8bytes {
+	long x;
+};
+
+struct padded_8bytes {
+	long: 64;
+};
+
+struct ff_periodic_effect {
+	int: 32;
+	short magnitude;
+	long: 0;
+	short phase;
+	long: 0;
+	int: 32;
+	int custom_len;
+	short *custom_data;
+};
+
+struct ib_wc {
+	long: 64;
+	long: 64;
+	int: 32;
+	int byte_len;
+	void *qp;
+	union {} ex;
+	long: 64;
+	int slid;
+	int wc_flags;
+	long: 64;
+	char smac[6];
+	long: 0;
+	char network_hdr_type;
+};
+
+struct acpi_object_method {
+	long: 64;
+	char: 8;
+	char type;
+	short reference_count;
+	char flags;
+	short: 0;
+	char: 8;
+	char sync_level;
+	long: 64;
+	void *node;
+	void *aml_start;
+	union {} dispatch;
+	long: 64;
+	int aml_length;
+};
+
+struct nested_unpacked {
+	int x;
+};
+
+struct nested_packed {
+	struct nested_unpacked a;
+	char c;
+} __attribute__((packed));
+
+struct outer_mixed_but_unpacked {
+	struct nested_packed b1;
+	short a1;
+	struct nested_packed b2;
+};
+
+/* ------ END-EXPECTED-OUTPUT ------ */
+
 int f(struct {
 	struct padded_implicitly _1;
 	struct padded_explicitly _2;
 	struct padded_a_lot _3;
 	struct padded_cache_line _4;
 	struct zone _5;
+	struct padding_wo_named_members _6;
+	struct padding_weird_1 _7;
+	struct padding_weird_2 _8;
+	struct exact_1byte _100;
+	struct padded_1byte _101;
+	struct exact_2bytes _102;
+	struct padded_2bytes _103;
+	struct exact_4bytes _104;
+	struct padded_4bytes _105;
+	struct exact_8bytes _106;
+	struct padded_8bytes _107;
+	struct ff_periodic_effect _200;
+	struct ib_wc _201;
+	struct acpi_object_method _202;
+	struct outer_mixed_but_unpacked _203;
 } *_)
 {
 	return 0;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 564d5c145fbe..356fd5d1a428 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -154,6 +154,8 @@ static void kvm_uevent_notify_change(unsigned int type, struct kvm *kvm);
 static unsigned long long kvm_createvm_count;
 static unsigned long long kvm_active_vms;
 
+static DEFINE_PER_CPU(cpumask_var_t, cpu_kick_mask);
+
 __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 						   unsigned long start, unsigned long end)
 {
@@ -248,9 +250,13 @@ static void ack_flush(void *_completed)
 {
 }
 
-static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
+static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
 {
-	if (unlikely(!cpus))
+	const struct cpumask *cpus;
+
+	if (likely(cpumask_available(tmp)))
+		cpus = tmp;
+	else
 		cpus = cpu_online_mask;
 
 	if (cpumask_empty(cpus))
@@ -260,30 +266,57 @@ static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
 	return true;
 }
 
+static void kvm_make_vcpu_request(struct kvm *kvm, struct kvm_vcpu *vcpu,
+				  unsigned int req, cpumask_var_t tmp,
+				  int current_cpu)
+{
+	int cpu;
+
+	kvm_make_request(req, vcpu);
+
+	if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
+		return;
+
+	/*
+	 * tmp can be "unavailable" if cpumasks are allocated off stack as
+	 * allocation of the mask is deliberately not fatal and is handled by
+	 * falling back to kicking all online CPUs.
+	 */
+	if (!cpumask_available(tmp))
+		return;
+
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_request_needs_ipi(), which could result in sending an IPI
+	 * to the previous pCPU.  But, that's OK because the purpose of the IPI
+	 * is to ensure the vCPU returns to OUTSIDE_GUEST_MODE, which is
+	 * satisfied if the vCPU migrates. Entering READING_SHADOW_PAGE_TABLES
+	 * after this point is also OK, as the requirement is only that KVM wait
+	 * for vCPUs that were reading SPTEs _before_ any changes were
+	 * finalized. See kvm_vcpu_kick() for more details on handling requests.
+	 */
+	if (kvm_request_needs_ipi(vcpu, req)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		if (cpu != -1 && cpu != current_cpu)
+			__cpumask_set_cpu(cpu, tmp);
+	}
+}
+
 bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 				 struct kvm_vcpu *except,
 				 unsigned long *vcpu_bitmap, cpumask_var_t tmp)
 {
-	int i, cpu, me;
 	struct kvm_vcpu *vcpu;
+	int i, me;
 	bool called;
 
 	me = get_cpu();
 
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if ((vcpu_bitmap && !test_bit(i, vcpu_bitmap)) ||
-		    vcpu == except)
-			continue;
-
-		kvm_make_request(req, vcpu);
-		cpu = vcpu->cpu;
-
-		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
+	for_each_set_bit(i, vcpu_bitmap, KVM_MAX_VCPUS) {
+		vcpu = kvm_get_vcpu(kvm, i);
+		if (!vcpu || vcpu == except)
 			continue;
-
-		if (tmp != NULL && cpu != -1 && cpu != me &&
-		    kvm_request_needs_ipi(vcpu, req))
-			__cpumask_set_cpu(cpu, tmp);
+		kvm_make_vcpu_request(kvm, vcpu, req, tmp, me);
 	}
 
 	called = kvm_kick_many_cpus(tmp, !!(req & KVM_REQUEST_WAIT));
@@ -295,14 +328,25 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 bool kvm_make_all_cpus_request_except(struct kvm *kvm, unsigned int req,
 				      struct kvm_vcpu *except)
 {
-	cpumask_var_t cpus;
+	struct kvm_vcpu *vcpu;
+	struct cpumask *cpus;
 	bool called;
+	int i, me;
 
-	zalloc_cpumask_var(&cpus, GFP_ATOMIC);
+	me = get_cpu();
 
-	called = kvm_make_vcpus_request_mask(kvm, req, except, NULL, cpus);
+	cpus = this_cpu_cpumask_var_ptr(cpu_kick_mask);
+	cpumask_clear(cpus);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu == except)
+			continue;
+		kvm_make_vcpu_request(kvm, vcpu, req, cpus, me);
+	}
+
+	called = kvm_kick_many_cpus(cpus, !!(req & KVM_REQUEST_WAIT));
+	put_cpu();
 
-	free_cpumask_var(cpus);
 	return called;
 }
 
@@ -2937,16 +2981,24 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_wake_up);
  */
 void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 {
-	int me;
-	int cpu = vcpu->cpu;
+	int me, cpu;
 
 	if (kvm_vcpu_wake_up(vcpu))
 		return;
 
+	/*
+	 * Note, the vCPU could get migrated to a different pCPU at any point
+	 * after kvm_arch_vcpu_should_kick(), which could result in sending an
+	 * IPI to the previous pCPU.  But, that's ok because the purpose of the
+	 * IPI is to force the vCPU to leave IN_GUEST_MODE, and migrating the
+	 * vCPU also requires it to leave IN_GUEST_MODE.
+	 */
 	me = get_cpu();
-	if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
-		if (kvm_arch_vcpu_should_kick(vcpu))
+	if (kvm_arch_vcpu_should_kick(vcpu)) {
+		cpu = READ_ONCE(vcpu->cpu);
+		if (cpu != me && (unsigned)cpu < nr_cpu_ids && cpu_online(cpu))
 			smp_send_reschedule(cpu);
+	}
 	put_cpu();
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
@@ -4952,20 +5004,22 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		goto out_free_3;
 	}
 
+	for_each_possible_cpu(cpu) {
+		if (!alloc_cpumask_var_node(&per_cpu(cpu_kick_mask, cpu),
+					    GFP_KERNEL, cpu_to_node(cpu))) {
+			r = -ENOMEM;
+			goto out_free_4;
+		}
+	}
+
 	r = kvm_async_pf_init();
 	if (r)
-		goto out_free;
+		goto out_free_4;
 
 	kvm_chardev_ops.owner = module;
 	kvm_vm_fops.owner = module;
 	kvm_vcpu_fops.owner = module;
 
-	r = misc_register(&kvm_dev);
-	if (r) {
-		pr_err("kvm: misc device register failed\n");
-		goto out_unreg;
-	}
-
 	register_syscore_ops(&kvm_syscore_ops);
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
@@ -4974,13 +5028,28 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 	kvm_init_debug();
 
 	r = kvm_vfio_ops_init();
-	WARN_ON(r);
+	if (WARN_ON_ONCE(r))
+		goto err_vfio;
+
+	/*
+	 * Registration _must_ be the very last thing done, as this exposes
+	 * /dev/kvm to userspace, i.e. all infrastructure must be setup!
+	 */
+	r = misc_register(&kvm_dev);
+	if (r) {
+		pr_err("kvm: misc device register failed\n");
+		goto err_register;
+	}
 
 	return 0;
 
-out_unreg:
+err_register:
+	kvm_vfio_ops_exit();
+err_vfio:
 	kvm_async_pf_deinit();
-out_free:
+out_free_4:
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 out_free_3:
 	unregister_reboot_notifier(&kvm_reboot_notifier);
@@ -5000,8 +5069,18 @@ EXPORT_SYMBOL_GPL(kvm_init);
 
 void kvm_exit(void)
 {
-	debugfs_remove_recursive(kvm_debugfs_dir);
+	int cpu;
+
+	/*
+	 * Note, unregistering /dev/kvm doesn't strictly need to come first,
+	 * fops_get(), a.k.a. try_module_get(), prevents acquiring references
+	 * to KVM while the module is being stopped.
+	 */
 	misc_deregister(&kvm_dev);
+
+	debugfs_remove_recursive(kvm_debugfs_dir);
+	for_each_possible_cpu(cpu)
+		free_cpumask_var(per_cpu(cpu_kick_mask, cpu));
 	kmem_cache_destroy(kvm_vcpu_cache);
 	kvm_async_pf_deinit();
 	unregister_syscore_ops(&kvm_syscore_ops);
