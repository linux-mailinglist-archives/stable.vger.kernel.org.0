Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0E8B6E620B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbjDRM3e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjDRM3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:29:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAD3C667
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:29:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 071E66313B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6CEC433EF;
        Tue, 18 Apr 2023 12:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820948;
        bh=7IJsnC8ZpEYjPVuan+Epj5W3Tc7ulAqc/g1KojAPAng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLAoyPqkGRS6G1ac83Q6J+UgYH9o0RaHIOn1vfZA/JeD8q5s3MBYAP/qf7Q6LbKgV
         e2t93d7gZJtCSoWpCuyl3olaH3egAMkWXYEjLaSNWOdbjEo5s1z5uERKOxwBck8Njw
         Ogpd3/N4B+dLJL7DZfQRz8WTvGJe+iCwVD4IHqyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "kernelci.org bot" <bot@kernelci.org>,
        Tom Saeger <tom.saeger@oracle.com>
Subject: [PATCH 5.4 04/92] Revert "treewide: Replace DECLARE_TASKLET() with DECLARE_TASKLET_OLD()"
Date:   Tue, 18 Apr 2023 14:20:39 +0200
Message-Id: <20230418120304.868700296@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Saeger <tom.saeger@oracle.com>

This reverts commit 5de7a4254eb2d501cbb59918a152665b29c02109 which
caused mips build failures.

kernelci.org bot reports:

arch/mips/lasat/picvue_proc.c:87:20: error: ‘pvc_display_tasklet’ undeclared
(first use in this function)
arch/mips/lasat/picvue_proc.c:42:44: error: expected ‘)’ before ‘&’ token
arch/mips/lasat/picvue_proc.c:33:13: error: ‘pvc_display’ defined but not used
[-Werror=unused-function]

Link: https://lore.kernel.org/stable/64041dda.170a0220.8cc25.79c9@mx.google.com/
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/omap-keypad.c   |    2 +-
 drivers/input/serio/hil_mlc.c          |    2 +-
 drivers/net/wan/farsync.c              |    4 ++--
 drivers/s390/crypto/ap_bus.c           |    2 +-
 drivers/staging/most/dim2/dim2.c       |    2 +-
 drivers/staging/octeon/ethernet-tx.c   |    2 +-
 drivers/tty/vt/keyboard.c              |    2 +-
 drivers/usb/gadget/udc/snps_udc_core.c |    2 +-
 drivers/usb/host/fhci-sched.c          |    2 +-
 include/linux/interrupt.h              |   15 +++++----------
 kernel/backtracetest.c                 |    2 +-
 kernel/debug/debug_core.c              |    2 +-
 kernel/irq/resend.c                    |    2 +-
 net/atm/pppoatm.c                      |    2 +-
 net/iucv/iucv.c                        |    2 +-
 sound/drivers/pcsp/pcsp_lib.c          |    2 +-
 16 files changed, 21 insertions(+), 26 deletions(-)

--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -46,7 +46,7 @@ struct omap_kp {
 	unsigned short keymap[];
 };
 
-static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);
+static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);
 
 static unsigned int *row_gpios;
 static unsigned int *col_gpios;
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker
 static int			hil_mlcs_probe, hil_mlc_stop;
 
 static void hil_mlcs_process(unsigned long unused);
-static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);
+static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);
 
 
 /* #define HIL_MLC_DEBUG */
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst
 static void fst_process_tx_work_q(unsigned long work_q);
 static void fst_process_int_work_q(unsigned long work_q);
 
-static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);
-static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);
+static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);
+static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);
 
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
 static spinlock_t fst_work_q_lock;
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_sca
  * Tasklet & timer for AP request polling and interrupts
  */
 static void ap_tasklet_fn(unsigned long);
-static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);
+static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);
 static struct task_struct *ap_poll_kthread;
 static DEFINE_MUTEX(ap_poll_thread_mutex);
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames pe
 static DEFINE_SPINLOCK(dim_lock);
 
 static void dim2_tasklet_fn(unsigned long data);
-static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);
+static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);
 
 /**
  * struct hdm_channel - private structure to keep channel specific data
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -41,7 +41,7 @@
 #endif
 
 static void cvm_oct_tx_do_cleanup(unsigned long arg);
-static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup);
+static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, 0);
 
 /* Maximum number of SKBs to try to free per xmit packet. */
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)
 	}
 }
 
-DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);
+DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
 
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) ||\
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) ||\
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -96,7 +96,7 @@ static int stop_pollstall_timer;
 static DECLARE_COMPLETION(on_pollstall_exit);
 
 /* tasklet for usb disconnect */
-static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);
+static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect, 0);
 
 /* endpoint names used for print */
 static const char ep0_string[] = "ep0in";
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -677,7 +677,7 @@ static void process_done_list(unsigned l
 	enable_irq(fhci_to_hcd(fhci)->irq);
 }
 
-DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);
+DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);
 
 /* transfer complted callback */
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -598,17 +598,12 @@ struct tasklet_struct
 	unsigned long data;
 };
 
-#define DECLARE_TASKLET_OLD(name, _func)		\
-struct tasklet_struct name = {				\
-	.count = ATOMIC_INIT(0),			\
-	.func = _func,					\
-}
+#define DECLARE_TASKLET(name, func, data) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
+
+#define DECLARE_TASKLET_DISABLED(name, func, data) \
+struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
 
-#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\
-struct tasklet_struct name = {				\
-	.count = ATOMIC_INIT(1),			\
-	.func = _func,					\
-}
 
 enum
 {
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(
 	complete(&backtrace_work);
 }
 
-static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback);
+static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0);
 
 static void backtrace_test_irq(void)
 {
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned lo
 	atomic_set(&kgdb_break_tasklet_var, 0);
 }
 
-static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);
+static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
 
 void kgdb_schedule_breakpoint(void)
 {
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long ar
 }
 
 /* Tasklet to handle resend: */
-static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);
+static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
 
 #endif
 
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm
 	 * Each PPPoATM instance has its own tasklet - this is just a
 	 * prototypical one used to initialize them
 	 */
-	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);
+	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);
 	if (copy_from_user(&be, arg, sizeof be))
 		return -EFAULT;
 	if (be.encaps != PPPOATM_ENCAPS_AUTODETECT &&
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);
  * The tasklet for fast delivery of iucv interrupts.
  */
 static void iucv_tasklet_fn(unsigned long);
-static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);
+static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);
 
 /*
  * Queue of interrupt buffers for delivery via a work queue
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsign
 	}
 }
 
-static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);
+static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);
 
 /* write the port and returns the next expire time in ns;
  * called at the trigger-start and in hrtimer callback


