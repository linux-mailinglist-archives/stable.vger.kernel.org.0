Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98CD5FF8BE
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 08:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJOGWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 02:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiJOGVg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 02:21:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3772C63841;
        Fri, 14 Oct 2022 23:21:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAECD606DC;
        Sat, 15 Oct 2022 06:21:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD12C433B5;
        Sat, 15 Oct 2022 06:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665814888;
        bh=FMv4zvbRVK0sXn2cVlVn+b0FQTm7AV448nU5ItvEHjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MUh06ssrHsD2JXRgOuEfDdf6oKOxt0drWM7SEiwCGfvDO4z0OwGnPSAZbHjh3My8Q
         fjCS+HB2onrH0lhfvR4C6jQewT0LlR6dzvWTVBThWj33Q7RewqzKYiY/mHiuCcRSUS
         PgQS/vvy0m+GAIURzomBcNPz2JKfi5/+Esb5i1TY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.74
Date:   Sat, 15 Oct 2022 08:22:02 +0200
Message-Id: <1665814921220101@kroah.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <166581492119138@kroah.com>
References: <166581492119138@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index fc47032dabb8..86b6ca862e39 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 73
+SUBLEVEL = 74
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/powerpc/include/asm/paca.h b/arch/powerpc/include/asm/paca.h
index dc05a862e72a..c5c9e2515315 100644
--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -263,7 +263,6 @@ struct paca_struct {
 	u64 l1d_flush_size;
 #endif
 #ifdef CONFIG_PPC_PSERIES
-	struct rtas_args *rtas_args_reentrant;
 	u8 *mce_data_buf;		/* buffer to hold per cpu rtas errlog */
 #endif /* CONFIG_PPC_PSERIES */
 
diff --git a/arch/powerpc/include/asm/rtas.h b/arch/powerpc/include/asm/rtas.h
index 9dc97d2f9d27..a05b34cf5f40 100644
--- a/arch/powerpc/include/asm/rtas.h
+++ b/arch/powerpc/include/asm/rtas.h
@@ -240,7 +240,6 @@ extern struct rtas_t rtas;
 extern int rtas_token(const char *service);
 extern int rtas_service_present(const char *service);
 extern int rtas_call(int token, int, int, int *, ...);
-int rtas_call_reentrant(int token, int nargs, int nret, int *outputs, ...);
 void rtas_call_unlocked(struct rtas_args *args, int token, int nargs,
 			int nret, ...);
 extern void __noreturn rtas_restart(char *cmd);
diff --git a/arch/powerpc/kernel/paca.c b/arch/powerpc/kernel/paca.c
index 9bd30cac852b..2de557663a96 100644
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -16,7 +16,6 @@
 #include <asm/kexec.h>
 #include <asm/svm.h>
 #include <asm/ultravisor.h>
-#include <asm/rtas.h>
 
 #include "setup.h"
 
@@ -172,30 +171,6 @@ static struct slb_shadow * __init new_slb_shadow(int cpu, unsigned long limit)
 
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
-#ifdef CONFIG_PPC_PSERIES
-/**
- * new_rtas_args() - Allocates rtas args
- * @cpu:	CPU number
- * @limit:	Memory limit for this allocation
- *
- * Allocates a struct rtas_args and return it's pointer,
- * if not in Hypervisor mode
- *
- * Return:	Pointer to allocated rtas_args
- *		NULL if CPU in Hypervisor Mode
- */
-static struct rtas_args * __init new_rtas_args(int cpu, unsigned long limit)
-{
-	limit = min_t(unsigned long, limit, RTAS_INSTANTIATE_MAX);
-
-	if (early_cpu_has_feature(CPU_FTR_HVMODE))
-		return NULL;
-
-	return alloc_paca_data(sizeof(struct rtas_args), L1_CACHE_BYTES,
-			       limit, cpu);
-}
-#endif /* CONFIG_PPC_PSERIES */
-
 /* The Paca is an array with one entry per processor.  Each contains an
  * lppaca, which contains the information shared between the
  * hypervisor and Linux.
@@ -234,10 +209,6 @@ void __init initialise_paca(struct paca_struct *new_paca, int cpu)
 	/* For now -- if we have threads this will be adjusted later */
 	new_paca->tcd_ptr = &new_paca->tcd;
 #endif
-
-#ifdef CONFIG_PPC_PSERIES
-	new_paca->rtas_args_reentrant = NULL;
-#endif
 }
 
 /* Put the paca pointer into r13 and SPRG_PACA */
@@ -309,9 +280,6 @@ void __init allocate_paca(int cpu)
 #endif
 #ifdef CONFIG_PPC_BOOK3S_64
 	paca->slb_shadow_ptr = new_slb_shadow(cpu, limit);
-#endif
-#ifdef CONFIG_PPC_PSERIES
-	paca->rtas_args_reentrant = new_rtas_args(cpu, limit);
 #endif
 	paca_struct_size += sizeof(struct paca_struct);
 }
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index e8f44084d251..7834ce3aa7f1 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -42,7 +42,6 @@
 #include <asm/time.h>
 #include <asm/mmu.h>
 #include <asm/topology.h>
-#include <asm/paca.h>
 
 /* This is here deliberately so it's only used in this file */
 void enter_rtas(unsigned long);
@@ -845,59 +844,6 @@ void rtas_activate_firmware(void)
 		pr_err("ibm,activate-firmware failed (%i)\n", fwrc);
 }
 
-#ifdef CONFIG_PPC_PSERIES
-/**
- * rtas_call_reentrant() - Used for reentrant rtas calls
- * @token:	Token for desired reentrant RTAS call
- * @nargs:	Number of Input Parameters
- * @nret:	Number of Output Parameters
- * @outputs:	Array of outputs
- * @...:	Inputs for desired RTAS call
- *
- * According to LoPAR documentation, only "ibm,int-on", "ibm,int-off",
- * "ibm,get-xive" and "ibm,set-xive" are currently reentrant.
- * Reentrant calls need their own rtas_args buffer, so not using rtas.args, but
- * PACA one instead.
- *
- * Return:	-1 on error,
- *		First output value of RTAS call if (nret > 0),
- *		0 otherwise,
- */
-int rtas_call_reentrant(int token, int nargs, int nret, int *outputs, ...)
-{
-	va_list list;
-	struct rtas_args *args;
-	unsigned long flags;
-	int i, ret = 0;
-
-	if (!rtas.entry || token == RTAS_UNKNOWN_SERVICE)
-		return -1;
-
-	local_irq_save(flags);
-	preempt_disable();
-
-	/* We use the per-cpu (PACA) rtas args buffer */
-	args = local_paca->rtas_args_reentrant;
-
-	va_start(list, outputs);
-	va_rtas_call_unlocked(args, token, nargs, nret, list);
-	va_end(list);
-
-	if (nret > 1 && outputs)
-		for (i = 0; i < nret - 1; ++i)
-			outputs[i] = be32_to_cpu(args->rets[i + 1]);
-
-	if (nret > 0)
-		ret = be32_to_cpu(args->rets[0]);
-
-	local_irq_restore(flags);
-	preempt_enable();
-
-	return ret;
-}
-
-#endif /* CONFIG_PPC_PSERIES */
-
 /**
  * Find a specific pseries error log in an RTAS extended event log.
  * @log: RTAS error/event log
diff --git a/arch/powerpc/sysdev/xics/ics-rtas.c b/arch/powerpc/sysdev/xics/ics-rtas.c
index b9da317b7a2d..4533d4a46ece 100644
--- a/arch/powerpc/sysdev/xics/ics-rtas.c
+++ b/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -37,8 +37,8 @@ static void ics_rtas_unmask_irq(struct irq_data *d)
 
 	server = xics_get_irq_server(d->irq, irq_data_get_affinity_mask(d), 0);
 
-	call_status = rtas_call_reentrant(ibm_set_xive, 3, 1, NULL, hw_irq,
-					  server, DEFAULT_PRIORITY);
+	call_status = rtas_call(ibm_set_xive, 3, 1, NULL, hw_irq, server,
+				DEFAULT_PRIORITY);
 	if (call_status != 0) {
 		printk(KERN_ERR
 			"%s: ibm_set_xive irq %u server %x returned %d\n",
@@ -47,7 +47,7 @@ static void ics_rtas_unmask_irq(struct irq_data *d)
 	}
 
 	/* Now unmask the interrupt (often a no-op) */
-	call_status = rtas_call_reentrant(ibm_int_on, 1, 1, NULL, hw_irq);
+	call_status = rtas_call(ibm_int_on, 1, 1, NULL, hw_irq);
 	if (call_status != 0) {
 		printk(KERN_ERR "%s: ibm_int_on irq=%u returned %d\n",
 			__func__, hw_irq, call_status);
@@ -69,7 +69,7 @@ static void ics_rtas_mask_real_irq(unsigned int hw_irq)
 	if (hw_irq == XICS_IPI)
 		return;
 
-	call_status = rtas_call_reentrant(ibm_int_off, 1, 1, NULL, hw_irq);
+	call_status = rtas_call(ibm_int_off, 1, 1, NULL, hw_irq);
 	if (call_status != 0) {
 		printk(KERN_ERR "%s: ibm_int_off irq=%u returned %d\n",
 			__func__, hw_irq, call_status);
@@ -77,8 +77,8 @@ static void ics_rtas_mask_real_irq(unsigned int hw_irq)
 	}
 
 	/* Have to set XIVE to 0xff to be able to remove a slot */
-	call_status = rtas_call_reentrant(ibm_set_xive, 3, 1, NULL, hw_irq,
-					  xics_default_server, 0xff);
+	call_status = rtas_call(ibm_set_xive, 3, 1, NULL, hw_irq,
+				xics_default_server, 0xff);
 	if (call_status != 0) {
 		printk(KERN_ERR "%s: ibm_set_xive(0xff) irq=%u returned %d\n",
 			__func__, hw_irq, call_status);
@@ -109,7 +109,7 @@ static int ics_rtas_set_affinity(struct irq_data *d,
 	if (hw_irq == XICS_IPI || hw_irq == XICS_IRQ_SPURIOUS)
 		return -1;
 
-	status = rtas_call_reentrant(ibm_get_xive, 1, 3, xics_status, hw_irq);
+	status = rtas_call(ibm_get_xive, 1, 3, xics_status, hw_irq);
 
 	if (status) {
 		printk(KERN_ERR "%s: ibm,get-xive irq=%u returns %d\n",
@@ -127,8 +127,8 @@ static int ics_rtas_set_affinity(struct irq_data *d,
 	pr_debug("%s: irq %d [hw 0x%x] server: 0x%x\n", __func__, d->irq,
 		 hw_irq, irq_server);
 
-	status = rtas_call_reentrant(ibm_set_xive, 3, 1, NULL,
-				     hw_irq, irq_server, xics_status[1]);
+	status = rtas_call(ibm_set_xive, 3, 1, NULL,
+			   hw_irq, irq_server, xics_status[1]);
 
 	if (status) {
 		printk(KERN_ERR "%s: ibm,set-xive irq=%u returns %d\n",
@@ -159,7 +159,7 @@ static int ics_rtas_check(struct ics *ics, unsigned int hw_irq)
 		return -EINVAL;
 
 	/* Check if RTAS knows about this interrupt */
-	rc = rtas_call_reentrant(ibm_get_xive, 1, 3, status, hw_irq);
+	rc = rtas_call(ibm_get_xive, 1, 3, status, hw_irq);
 	if (rc)
 		return -ENXIO;
 
@@ -175,7 +175,7 @@ static long ics_rtas_get_server(struct ics *ics, unsigned long vec)
 {
 	int rc, status[2];
 
-	rc = rtas_call_reentrant(ibm_get_xive, 1, 3, status, vec);
+	rc = rtas_call(ibm_get_xive, 1, 3, status, vec);
 	if (rc)
 		return -1;
 	return status[0];
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1c596b5cdb27..d8e3b547e0ae 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -702,8 +702,8 @@ static const struct memdev {
 #endif
 	 [5] = { "zero", 0666, &zero_fops, 0 },
 	 [7] = { "full", 0666, &full_fops, 0 },
-	 [8] = { "random", 0666, &random_fops, 0 },
-	 [9] = { "urandom", 0666, &urandom_fops, 0 },
+	 [8] = { "random", 0666, &random_fops, FMODE_NOWAIT },
+	 [9] = { "urandom", 0666, &urandom_fops, FMODE_NOWAIT },
 #ifdef CONFIG_PRINTK
 	[11] = { "kmsg", 0644, &kmsg_fops, 0 },
 #endif
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7bd6eb15d432..8642326de6e1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -894,20 +894,23 @@ void __init add_bootloader_randomness(const void *buf, size_t len)
 }
 
 struct fast_pool {
-	struct work_struct mix;
 	unsigned long pool[4];
 	unsigned long last;
 	unsigned int count;
+	struct timer_list mix;
 };
 
+static void mix_interrupt_randomness(struct timer_list *work);
+
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness) = {
 #ifdef CONFIG_64BIT
 #define FASTMIX_PERM SIPHASH_PERMUTATION
-	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 }
+	.pool = { SIPHASH_CONST_0, SIPHASH_CONST_1, SIPHASH_CONST_2, SIPHASH_CONST_3 },
 #else
 #define FASTMIX_PERM HSIPHASH_PERMUTATION
-	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 }
+	.pool = { HSIPHASH_CONST_0, HSIPHASH_CONST_1, HSIPHASH_CONST_2, HSIPHASH_CONST_3 },
 #endif
+	.mix = __TIMER_INITIALIZER(mix_interrupt_randomness, 0)
 };
 
 /*
@@ -949,7 +952,7 @@ int __cold random_online_cpu(unsigned int cpu)
 }
 #endif
 
-static void mix_interrupt_randomness(struct work_struct *work)
+static void mix_interrupt_randomness(struct timer_list *work)
 {
 	struct fast_pool *fast_pool = container_of(work, struct fast_pool, mix);
 	/*
@@ -980,7 +983,7 @@ static void mix_interrupt_randomness(struct work_struct *work)
 	local_irq_enable();
 
 	mix_pool_bytes(pool, sizeof(pool));
-	credit_init_bits(max(1u, (count & U16_MAX) / 64));
+	credit_init_bits(clamp_t(unsigned int, (count & U16_MAX) / 64, 1, sizeof(pool) * 8));
 
 	memzero_explicit(pool, sizeof(pool));
 }
@@ -1003,10 +1006,11 @@ void add_interrupt_randomness(int irq)
 	if (new_count < 1024 && !time_is_before_jiffies(fast_pool->last + HZ))
 		return;
 
-	if (unlikely(!fast_pool->mix.func))
-		INIT_WORK(&fast_pool->mix, mix_interrupt_randomness);
 	fast_pool->count |= MIX_INFLIGHT;
-	queue_work_on(raw_smp_processor_id(), system_highpri_wq, &fast_pool->mix);
+	if (!timer_pending(&fast_pool->mix)) {
+		fast_pool->mix.expires = jiffies;
+		add_timer_on(&fast_pool->mix, raw_smp_processor_id());
+	}
 }
 EXPORT_SYMBOL_GPL(add_interrupt_randomness);
 
@@ -1298,6 +1302,11 @@ static ssize_t random_read_iter(struct kiocb *kiocb, struct iov_iter *iter)
 {
 	int ret;
 
+	if (!crng_ready() &&
+	    ((kiocb->ki_flags & (IOCB_NOWAIT | IOCB_NOIO)) ||
+	     (kiocb->ki_filp->f_flags & O_NONBLOCK)))
+		return -EAGAIN;
+
 	ret = wait_for_random_bytes();
 	if (ret != 0)
 		return ret;
diff --git a/drivers/crypto/qat/qat_common/qat_asym_algs.c b/drivers/crypto/qat/qat_common/qat_asym_algs.c
index 7173a2a0a484..5f11929cf9ba 100644
--- a/drivers/crypto/qat/qat_common/qat_asym_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_asym_algs.c
@@ -332,13 +332,13 @@ static int qat_dh_compute_value(struct kpp_request *req)
 	qat_req->out.dh.out_tab[1] = 0;
 	/* Mapping in.in.b or in.in_g2.xa is the same */
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.dh.in.b,
-					 sizeof(qat_req->in.dh.in.b),
+					 sizeof(struct qat_dh_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.dh.r,
-					  sizeof(qat_req->out.dh.r),
+					  sizeof(struct qat_dh_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
@@ -728,13 +728,13 @@ static int qat_rsa_enc(struct akcipher_request *req)
 	qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.enc.m,
-					 sizeof(qat_req->in.rsa.enc.m),
+					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.enc.c,
-					  sizeof(qat_req->out.rsa.enc.c),
+					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
@@ -873,13 +873,13 @@ static int qat_rsa_dec(struct akcipher_request *req)
 		qat_req->in.rsa.in_tab[3] = 0;
 	qat_req->out.rsa.out_tab[1] = 0;
 	qat_req->phy_in = dma_map_single(dev, &qat_req->in.rsa.dec.c,
-					 sizeof(qat_req->in.rsa.dec.c),
+					 sizeof(struct qat_rsa_input_params),
 					 DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_in)))
 		goto unmap_dst;
 
 	qat_req->phy_out = dma_map_single(dev, &qat_req->out.rsa.dec.m,
-					  sizeof(qat_req->out.rsa.dec.m),
+					  sizeof(struct qat_rsa_output_params),
 					  DMA_TO_DEVICE);
 	if (unlikely(dma_mapping_error(dev, qat_req->phy_out)))
 		goto unmap_in_params;
diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 4c914f75a902..dbfabd229a7c 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -113,6 +113,8 @@ static const struct xpad_device {
 	u8 xtype;
 } xpad_device[] = {
 	{ 0x0079, 0x18d4, "GPD Win 2 X-Box Controller", 0, XTYPE_XBOX360 },
+	{ 0x03eb, 0xff01, "Wooting One (Legacy)", 0, XTYPE_XBOX360 },
+	{ 0x03eb, 0xff02, "Wooting Two (Legacy)", 0, XTYPE_XBOX360 },
 	{ 0x044f, 0x0f00, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f03, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
@@ -244,6 +246,7 @@ static const struct xpad_device {
 	{ 0x0f0d, 0x0063, "Hori Real Arcade Pro Hayabusa (USA) Xbox One", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x0067, "HORIPAD ONE", 0, XTYPE_XBOXONE },
 	{ 0x0f0d, 0x0078, "Hori Real Arcade Pro V Kai Xbox One", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
+	{ 0x0f0d, 0x00c5, "Hori Fighting Commander ONE", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0f30, 0x010b, "Philips Recoil", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x0202, "Joytech Advanced Controller", 0, XTYPE_XBOX },
 	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", 0, XTYPE_XBOX },
@@ -260,6 +263,7 @@ static const struct xpad_device {
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x1430, 0xf801, "RedOctane Controller", 0, XTYPE_XBOX360 },
 	{ 0x146b, 0x0601, "BigBen Interactive XBOX 360 Controller", 0, XTYPE_XBOX360 },
+	{ 0x146b, 0x0604, "Bigben Interactive DAIJA Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1532, 0x0037, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x1532, 0x0a00, "Razer Atrox Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x1532, 0x0a03, "Razer Wildcat", 0, XTYPE_XBOXONE },
@@ -325,6 +329,7 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5502, "Hori Fighting Stick VX Alt", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5503, "Hori Fighting Edge", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5506, "Hori SOULCALIBUR V Stick", 0, XTYPE_XBOX360 },
+	{ 0x24c6, 0x5510, "Hori Fighting Commander ONE (Xbox 360/PC Mode)", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x550d, "Hori GEM Xbox controller", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x550e, "Hori Real Arcade Pro V Kai 360", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x24c6, 0x551a, "PowerA FUSION Pro Controller", 0, XTYPE_XBOXONE },
@@ -334,6 +339,14 @@ static const struct xpad_device {
 	{ 0x24c6, 0x5b03, "Thrustmaster Ferrari 458 Racing Wheel", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0x5d04, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x24c6, 0xfafe, "Rock Candy Gamepad for Xbox 360", 0, XTYPE_XBOX360 },
+	{ 0x2563, 0x058d, "OneXPlayer Gamepad", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
+	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
@@ -419,6 +432,7 @@ static const signed short xpad_abs_triggers[] = {
 static const struct usb_device_id xpad_table[] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	XPAD_XBOX360_VENDOR(0x0079),		/* GPD Win 2 Controller */
+	XPAD_XBOX360_VENDOR(0x03eb),		/* Wooting Keyboards (Legacy) */
 	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x045e),		/* Microsoft X-Box One controllers */
@@ -429,6 +443,7 @@ static const struct usb_device_id xpad_table[] = {
 	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOXONE_VENDOR(0x0738),		/* Mad Catz FightStick TE 2 */
 	XPAD_XBOX360_VENDOR(0x07ff),		/* Mad Catz GamePad */
+	XPAD_XBOX360_VENDOR(0x0c12),		/* Zeroplus X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x0e6f),		/* 0x0e6f X-Box 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x0e6f),		/* 0x0e6f X-Box One controllers */
 	XPAD_XBOX360_VENDOR(0x0f0d),		/* Hori Controllers */
@@ -450,8 +465,12 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA Controllers */
 	XPAD_XBOX360_VENDOR(0x24c6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA Controllers */
+	XPAD_XBOX360_VENDOR(0x2563),		/* OneXPlayer Gamepad */
+	XPAD_XBOX360_VENDOR(0x260d),		/* Dareu H101 */
+	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Pro 2 Wired Controller for Xbox */
 	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke X-Box One pad */
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
+	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	{ }
 };
@@ -1972,7 +1991,6 @@ static struct usb_driver xpad_driver = {
 	.disconnect	= xpad_disconnect,
 	.suspend	= xpad_suspend,
 	.resume		= xpad_resume,
-	.reset_resume	= xpad_resume,
 	.id_table	= xpad_table,
 };
 
diff --git a/drivers/misc/pci_endpoint_test.c b/drivers/misc/pci_endpoint_test.c
index 2ed7e3aaff3a..4e4c0884d35e 100644
--- a/drivers/misc/pci_endpoint_test.c
+++ b/drivers/misc/pci_endpoint_test.c
@@ -332,6 +332,22 @@ static bool pci_endpoint_test_msi_irq(struct pci_endpoint_test *test,
 	return false;
 }
 
+static int pci_endpoint_test_validate_xfer_params(struct device *dev,
+		struct pci_endpoint_test_xfer_param *param, size_t alignment)
+{
+	if (!param->size) {
+		dev_dbg(dev, "Data size is zero\n");
+		return -EINVAL;
+	}
+
+	if (param->size > SIZE_MAX - alignment) {
+		dev_dbg(dev, "Maximum transfer data size exceeded\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 				   unsigned long arg)
 {
@@ -363,9 +379,11 @@ static bool pci_endpoint_test_copy(struct pci_endpoint_test *test,
 		return false;
 	}
 
+	err = pci_endpoint_test_validate_xfer_params(dev, &param, alignment);
+	if (err)
+		return false;
+
 	size = param.size;
-	if (size > SIZE_MAX - alignment)
-		goto err;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
@@ -497,9 +515,11 @@ static bool pci_endpoint_test_write(struct pci_endpoint_test *test,
 		return false;
 	}
 
+	err = pci_endpoint_test_validate_xfer_params(dev, &param, alignment);
+	if (err)
+		return false;
+
 	size = param.size;
-	if (size > SIZE_MAX - alignment)
-		goto err;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
@@ -595,9 +615,11 @@ static bool pci_endpoint_test_read(struct pci_endpoint_test *test,
 		return false;
 	}
 
+	err = pci_endpoint_test_validate_xfer_params(dev, &param, alignment);
+	if (err)
+		return false;
+
 	size = param.size;
-	if (size > SIZE_MAX - alignment)
-		goto err;
 
 	use_dma = !!(param.flags & PCITEST_FLAGS_USE_DMA);
 	if (use_dma)
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 52a2574b7d13..b228567b2a73 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3749,6 +3749,8 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	rx_status.band = channel->band;
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
+	if (rx_status.rate_idx >= data2->hw->wiphy->bands[rx_status.band]->n_bitrates)
+		goto out;
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
 	hdr = (void *)skb->data;
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index f1ba7f5b52a8..b5267dae3355 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -665,16 +665,17 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 		return 0;
 	case PASSTHRU_CMD:
 		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
-			struct st_drvver ver;
+			const struct st_drvver ver = {
+				.major = ST_VER_MAJOR,
+				.minor = ST_VER_MINOR,
+				.oem = ST_OEM,
+				.build = ST_BUILD_VER,
+				.signature[0] = PASSTHRU_SIGNATURE,
+				.console_id = host->max_id - 1,
+				.host_no = hba->host->host_no,
+			};
 			size_t cp_len = sizeof(ver);
 
-			ver.major = ST_VER_MAJOR;
-			ver.minor = ST_VER_MINOR;
-			ver.oem = ST_OEM;
-			ver.build = ST_BUILD_VER;
-			ver.signature[0] = PASSTHRU_SIGNATURE;
-			ver.console_id = host->max_id - 1;
-			ver.host_no = hba->host->host_no;
 			cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
 			if (sizeof(ver) == cp_len)
 				cmd->result = DID_OK << 16;
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 586ef5551e76..b1e844bf31f8 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -177,6 +177,7 @@ static const struct usb_device_id id_table[] = {
 	{DEVICE_SWI(0x413c, 0x81b3)},	/* Dell Wireless 5809e Gobi(TM) 4G LTE Mobile Broadband Card (rev3) */
 	{DEVICE_SWI(0x413c, 0x81b5)},	/* Dell Wireless 5811e QDL */
 	{DEVICE_SWI(0x413c, 0x81b6)},	/* Dell Wireless 5811e QDL */
+	{DEVICE_SWI(0x413c, 0x81c2)},	/* Dell Wireless 5811e */
 	{DEVICE_SWI(0x413c, 0x81cb)},	/* Dell Wireless 5816e QDL */
 	{DEVICE_SWI(0x413c, 0x81cc)},	/* Dell Wireless 5816e */
 	{DEVICE_SWI(0x413c, 0x81cf)},   /* Dell Wireless 5819 */
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index e34d52df4a13..53bffda3c76c 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -703,6 +703,12 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	if (dentry->d_name.len > NAME_MAX)
 		return -ENAMETOOLONG;
 
+	/*
+	 * Do not truncate the file, since atomic_open is called before the
+	 * permission check. The caller will do the truncation afterward.
+	 */
+	flags &= ~O_TRUNC;
+
 	if (flags & O_CREAT) {
 		if (ceph_quota_is_max_files_exceeded(dir))
 			return -EDQUOT;
@@ -770,9 +776,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 	}
 
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
-	err = ceph_mdsc_do_request(mdsc,
-				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
-				   req);
+	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
 	if (err == -ENOENT) {
 		dentry = ceph_handle_snapdir(req, dentry);
 		if (IS_ERR(dentry)) {
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index 2466f8b8be95..f4e74fac2c51 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -332,6 +332,7 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
+	struct buffer_head *bh;
 	int err = -ENOMEM;
 	ino_t ino;
 
@@ -347,11 +348,25 @@ struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 	ii->i_state = BIT(NILFS_I_NEW);
 	ii->i_root = root;
 
-	err = nilfs_ifile_create_inode(root->ifile, &ino, &ii->i_bh);
+	err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
 	if (unlikely(err))
 		goto failed_ifile_create_inode;
 	/* reference count of i_bh inherits from nilfs_mdt_read_block() */
 
+	if (unlikely(ino < NILFS_USER_INO)) {
+		nilfs_warn(sb,
+			   "inode bitmap is inconsistent for reserved inodes");
+		do {
+			brelse(bh);
+			err = nilfs_ifile_create_inode(root->ifile, &ino, &bh);
+			if (unlikely(err))
+				goto failed_ifile_create_inode;
+		} while (ino < NILFS_USER_INO);
+
+		nilfs_info(sb, "repaired inode bitmap for reserved inodes");
+	}
+	ii->i_bh = bh;
+
 	atomic64_inc(&root->inodes_count);
 	inode_init_owner(&init_user_ns, inode, dir, mode);
 	inode->i_ino = ino;
@@ -444,6 +459,8 @@ int nilfs_read_inode_common(struct inode *inode,
 	inode->i_atime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
 	inode->i_ctime.tv_nsec = le32_to_cpu(raw_inode->i_ctime_nsec);
 	inode->i_mtime.tv_nsec = le32_to_cpu(raw_inode->i_mtime_nsec);
+	if (nilfs_is_metadata_file_inode(inode) && !S_ISREG(inode->i_mode))
+		return -EIO; /* this inode is for metadata and corrupted */
 	if (inode->i_nlink == 0)
 		return -ESTALE; /* this inode is deleted */
 
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 314a23a16689..96c5cab5c8ae 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -875,9 +875,11 @@ static int nilfs_segctor_create_checkpoint(struct nilfs_sc_info *sci)
 		nilfs_mdt_mark_dirty(nilfs->ns_cpfile);
 		nilfs_cpfile_put_checkpoint(
 			nilfs->ns_cpfile, nilfs->ns_cno, bh_cp);
-	} else
-		WARN_ON(err == -EINVAL || err == -ENOENT);
-
+	} else if (err == -EINVAL || err == -ENOENT) {
+		nilfs_error(sci->sc_super,
+			    "checkpoint creation failed due to metadata corruption.");
+		err = -EIO;
+	}
 	return err;
 }
 
@@ -891,7 +893,11 @@ static int nilfs_segctor_fill_in_checkpoint(struct nilfs_sc_info *sci)
 	err = nilfs_cpfile_get_checkpoint(nilfs->ns_cpfile, nilfs->ns_cno, 0,
 					  &raw_cp, &bh_cp);
 	if (unlikely(err)) {
-		WARN_ON(err == -EINVAL || err == -ENOENT);
+		if (err == -EINVAL || err == -ENOENT) {
+			nilfs_error(sci->sc_super,
+				    "checkpoint finalization failed due to metadata corruption.");
+			err = -EIO;
+		}
 		goto failed_ibh;
 	}
 	raw_cp->cp_snapshot_list.ssl_next = 0;
@@ -2786,10 +2792,9 @@ int nilfs_attach_log_writer(struct super_block *sb, struct nilfs_root *root)
 	inode_attach_wb(nilfs->ns_bdev->bd_inode, NULL);
 
 	err = nilfs_segctor_start_thread(nilfs->ns_writer);
-	if (err) {
-		kfree(nilfs->ns_writer);
-		nilfs->ns_writer = NULL;
-	}
+	if (unlikely(err))
+		nilfs_detach_log_writer(sb);
+
 	return err;
 }
 
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 59afe8787cf7..685249233f2f 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -211,7 +211,7 @@ static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
 	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
 
 static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
-					   void *buf, int buflen)
+					   const void *buf, int buflen)
 {
 	return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
 				   buf, buflen);
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index e43176794149..0d2bab9d351c 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -478,7 +478,7 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 				     size_t len)
 {
 	u16 capab, tid, timeout, ba_policy, buf_size, start_seq_num;
-	struct ieee802_11_elems elems = { };
+	struct ieee802_11_elems *elems = NULL;
 	u8 dialog_token;
 	int ies_len;
 
@@ -496,16 +496,18 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	ies_len = len - offsetof(struct ieee80211_mgmt,
 				 u.action.u.addba_req.variable);
 	if (ies_len) {
-		ieee802_11_parse_elems(mgmt->u.action.u.addba_req.variable,
-                                ies_len, true, &elems, mgmt->bssid, NULL);
-		if (elems.parse_error)
-			return;
+		elems = ieee802_11_parse_elems(mgmt->u.action.u.addba_req.variable,
+					       ies_len, true, mgmt->bssid, NULL);
+		if (!elems || elems->parse_error)
+			goto free;
 	}
 
 	__ieee80211_start_rx_ba_session(sta, dialog_token, timeout,
 					start_seq_num, ba_policy, tid,
 					buf_size, true, false,
-					elems.addba_ext_ie);
+					elems ? elems->addba_ext_ie : NULL);
+free:
+	kfree(elems);
 }
 
 void ieee80211_manage_rx_ba_offl(struct ieee80211_vif *vif,
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 1e133ca58e78..48e0260f3424 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -9,7 +9,7 @@
  * Copyright 2009, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2016 Intel Deutschland GmbH
- * Copyright(c) 2018-2020 Intel Corporation
+ * Copyright(c) 2018-2021 Intel Corporation
  */
 
 #include <linux/delay.h>
@@ -1593,7 +1593,7 @@ void ieee80211_rx_mgmt_probe_beacon(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_rx_status *rx_status)
 {
 	size_t baselen;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 
 	BUILD_BUG_ON(offsetof(typeof(mgmt->u.probe_resp), variable) !=
 		     offsetof(typeof(mgmt->u.beacon), variable));
@@ -1606,10 +1606,14 @@ void ieee80211_rx_mgmt_probe_beacon(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-			       false, &elems, mgmt->bssid, NULL);
+	elems = ieee802_11_parse_elems(mgmt->u.probe_resp.variable,
+				       len - baselen, false,
+				       mgmt->bssid, NULL);
 
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems);
+	if (elems) {
+		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, elems);
+		kfree(elems);
+	}
 }
 
 void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
@@ -1618,7 +1622,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	int ies_len;
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
@@ -1655,15 +1659,16 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			if (ies_len < 0)
 				break;
 
-			ieee802_11_parse_elems(
+			elems = ieee802_11_parse_elems(
 				mgmt->u.action.u.chan_switch.variable,
-				ies_len, true, &elems, mgmt->bssid, NULL);
-
-			if (elems.parse_error)
-				break;
-
-			ieee80211_rx_mgmt_spectrum_mgmt(sdata, mgmt, skb->len,
-							rx_status, &elems);
+				ies_len, true, mgmt->bssid, NULL);
+
+			if (elems && !elems->parse_error)
+				ieee80211_rx_mgmt_spectrum_mgmt(sdata, mgmt,
+								skb->len,
+								rx_status,
+								elems);
+			kfree(elems);
 			break;
 		}
 	}
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f7bea4af2ddb..21549a440b38 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -631,10 +631,9 @@ struct ieee80211_if_ocb {
  */
 struct ieee802_11_elems;
 struct ieee80211_mesh_sync_ops {
-	void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata,
-			     u16 stype,
-			     struct ieee80211_mgmt *mgmt,
-			     struct ieee802_11_elems *elems,
+	void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata, u16 stype,
+			     struct ieee80211_mgmt *mgmt, unsigned int len,
+			     const struct ieee80211_meshconf_ie *mesh_cfg,
 			     struct ieee80211_rx_status *rx_status);
 
 	/* should be called with beacon_data under RCU read lock */
@@ -1533,6 +1532,7 @@ struct ieee80211_csa_ie {
 struct ieee802_11_elems {
 	const u8 *ie_start;
 	size_t total_len;
+	u32 crc;
 
 	/* pointers to IEs */
 	const struct ieee80211_tdls_lnkie *lnk_id;
@@ -1542,7 +1542,6 @@ struct ieee802_11_elems {
 	const u8 *supp_rates;
 	const u8 *ds_params;
 	const struct ieee80211_tim_ie *tim;
-	const u8 *challenge;
 	const u8 *rsn;
 	const u8 *rsnx;
 	const u8 *erp_info;
@@ -1596,7 +1595,6 @@ struct ieee802_11_elems {
 	u8 ssid_len;
 	u8 supp_rates_len;
 	u8 tim_len;
-	u8 challenge_len;
 	u8 rsn_len;
 	u8 rsnx_len;
 	u8 ext_supp_rates_len;
@@ -1615,6 +1613,14 @@ struct ieee802_11_elems {
 
 	/* whether a parse error occurred while retrieving these elements */
 	bool parse_error;
+
+	/*
+	 * scratch buffer that can be used for various element parsing related
+	 * tasks, e.g., element de-fragmentation etc.
+	 */
+	size_t scratch_len;
+	u8 *scratch_pos;
+	u8 scratch[];
 };
 
 static inline struct ieee80211_local *hw_to_local(
@@ -2219,18 +2225,18 @@ static inline void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb_tid(sdata, skb, 7);
 }
 
-u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
-			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc, u8 *transmitter_bssid,
-			       u8 *bss_bssid);
-static inline void ieee802_11_parse_elems(const u8 *start, size_t len,
-					  bool action,
-					  struct ieee802_11_elems *elems,
-					  u8 *transmitter_bssid,
-					  u8 *bss_bssid)
+struct ieee802_11_elems *ieee802_11_parse_elems_crc(const u8 *start, size_t len,
+						    bool action,
+						    u64 filter, u32 crc,
+						    const u8 *transmitter_bssid,
+						    const u8 *bss_bssid);
+static inline struct ieee802_11_elems *
+ieee802_11_parse_elems(const u8 *start, size_t len, bool action,
+		       const u8 *transmitter_bssid,
+		       const u8 *bss_bssid)
 {
-	ieee802_11_parse_elems_crc(start, len, action, elems, 0, 0,
-				   transmitter_bssid, bss_bssid);
+	return ieee802_11_parse_elems_crc(start, len, action, 0, 0,
+					  transmitter_bssid, bss_bssid);
 }
 
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 42bd81a30310..6847fdf93439 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1247,7 +1247,7 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	struct sk_buff *presp;
 	struct beacon_data *bcn;
 	struct ieee80211_mgmt *hdr;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	size_t baselen;
 	u8 *pos;
 
@@ -1256,22 +1256,24 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(pos, len - baselen, false, &elems, mgmt->bssid,
-			       NULL);
-
-	if (!elems.mesh_id)
+	elems = ieee802_11_parse_elems(pos, len - baselen, false, mgmt->bssid,
+				       NULL);
+	if (!elems)
 		return;
 
+	if (!elems->mesh_id)
+		goto free;
+
 	/* 802.11-2012 10.1.4.3.2 */
 	if ((!ether_addr_equal(mgmt->da, sdata->vif.addr) &&
 	     !is_broadcast_ether_addr(mgmt->da)) ||
-	    elems.ssid_len != 0)
-		return;
+	    elems->ssid_len != 0)
+		goto free;
 
-	if (elems.mesh_id_len != 0 &&
-	    (elems.mesh_id_len != ifmsh->mesh_id_len ||
-	     memcmp(elems.mesh_id, ifmsh->mesh_id, ifmsh->mesh_id_len)))
-		return;
+	if (elems->mesh_id_len != 0 &&
+	    (elems->mesh_id_len != ifmsh->mesh_id_len ||
+	     memcmp(elems->mesh_id, ifmsh->mesh_id, ifmsh->mesh_id_len)))
+		goto free;
 
 	rcu_read_lock();
 	bcn = rcu_dereference(ifmsh->beacon);
@@ -1295,6 +1297,8 @@ ieee80211_mesh_rx_probe_req(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, presp);
 out:
 	rcu_read_unlock();
+free:
+	kfree(elems);
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
@@ -1305,7 +1309,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	struct ieee80211_channel *channel;
 	size_t baselen;
 	int freq;
@@ -1320,42 +1324,47 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
-			       false, &elems, mgmt->bssid, NULL);
+	elems = ieee802_11_parse_elems(mgmt->u.probe_resp.variable,
+				       len - baselen,
+				       false, mgmt->bssid, NULL);
+	if (!elems)
+		return;
 
 	/* ignore non-mesh or secure / unsecure mismatch */
-	if ((!elems.mesh_id || !elems.mesh_config) ||
-	    (elems.rsn && sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) ||
-	    (!elems.rsn && sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE))
-		return;
+	if ((!elems->mesh_id || !elems->mesh_config) ||
+	    (elems->rsn && sdata->u.mesh.security == IEEE80211_MESH_SEC_NONE) ||
+	    (!elems->rsn && sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE))
+		goto free;
 
-	if (elems.ds_params)
-		freq = ieee80211_channel_to_frequency(elems.ds_params[0], band);
+	if (elems->ds_params)
+		freq = ieee80211_channel_to_frequency(elems->ds_params[0], band);
 	else
 		freq = rx_status->freq;
 
 	channel = ieee80211_get_channel(local->hw.wiphy, freq);
 
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
-		return;
+		goto free;
 
-	if (mesh_matches_local(sdata, &elems)) {
+	if (mesh_matches_local(sdata, elems)) {
 		mpl_dbg(sdata, "rssi_threshold=%d,rx_status->signal=%d\n",
 			sdata->u.mesh.mshcfg.rssi_threshold, rx_status->signal);
 		if (!sdata->u.mesh.user_mpm ||
 		    sdata->u.mesh.mshcfg.rssi_threshold == 0 ||
 		    sdata->u.mesh.mshcfg.rssi_threshold < rx_status->signal)
-			mesh_neighbour_update(sdata, mgmt->sa, &elems,
+			mesh_neighbour_update(sdata, mgmt->sa, elems,
 					      rx_status);
 
 		if (ifmsh->csa_role != IEEE80211_MESH_CSA_ROLE_INIT &&
 		    !sdata->vif.csa_active)
-			ieee80211_mesh_process_chnswitch(sdata, &elems, true);
+			ieee80211_mesh_process_chnswitch(sdata, elems, true);
 	}
 
 	if (ifmsh->sync_ops)
-		ifmsh->sync_ops->rx_bcn_presp(sdata,
-			stype, mgmt, &elems, rx_status);
+		ifmsh->sync_ops->rx_bcn_presp(sdata, stype, mgmt, len,
+					      elems->mesh_config, rx_status);
+free:
+	kfree(elems);
 }
 
 int ieee80211_mesh_finish_csa(struct ieee80211_sub_if_data *sdata)
@@ -1447,7 +1456,7 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 			      struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	u16 pre_value;
 	bool fwd_csa = true;
 	size_t baselen;
@@ -1460,33 +1469,37 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	pos = mgmt->u.action.u.chan_switch.variable;
 	baselen = offsetof(struct ieee80211_mgmt,
 			   u.action.u.chan_switch.variable);
-	ieee802_11_parse_elems(pos, len - baselen, true, &elems,
-			       mgmt->bssid, NULL);
-
-	if (!mesh_matches_local(sdata, &elems))
+	elems = ieee802_11_parse_elems(pos, len - baselen, true,
+				       mgmt->bssid, NULL);
+	if (!elems)
 		return;
 
-	ifmsh->chsw_ttl = elems.mesh_chansw_params_ie->mesh_ttl;
+	if (!mesh_matches_local(sdata, elems))
+		goto free;
+
+	ifmsh->chsw_ttl = elems->mesh_chansw_params_ie->mesh_ttl;
 	if (!--ifmsh->chsw_ttl)
 		fwd_csa = false;
 
-	pre_value = le16_to_cpu(elems.mesh_chansw_params_ie->mesh_pre_value);
+	pre_value = le16_to_cpu(elems->mesh_chansw_params_ie->mesh_pre_value);
 	if (ifmsh->pre_value >= pre_value)
-		return;
+		goto free;
 
 	ifmsh->pre_value = pre_value;
 
 	if (!sdata->vif.csa_active &&
-	    !ieee80211_mesh_process_chnswitch(sdata, &elems, false)) {
+	    !ieee80211_mesh_process_chnswitch(sdata, elems, false)) {
 		mcsa_dbg(sdata, "Failed to process CSA action frame");
-		return;
+		goto free;
 	}
 
 	/* forward or re-broadcast the CSA frame */
 	if (fwd_csa) {
-		if (mesh_fwd_csa_frame(sdata, mgmt, len, &elems) < 0)
+		if (mesh_fwd_csa_frame(sdata, mgmt, len, elems) < 0)
 			mcsa_dbg(sdata, "Failed to forward the CSA frame");
 	}
+free:
+	kfree(elems);
 }
 
 static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index a05b615deb51..44a6fdb6efbd 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2008, 2009 open80211s Ltd.
- * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2019, 2021 Intel Corporation
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  */
 
@@ -908,7 +908,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	size_t baselen;
 	u32 path_metric;
 	struct sta_info *sta;
@@ -926,37 +926,41 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	baselen = (u8 *) mgmt->u.action.u.mesh_action.variable - (u8 *) mgmt;
-	ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
-			       len - baselen, false, &elems, mgmt->bssid, NULL);
+	elems = ieee802_11_parse_elems(mgmt->u.action.u.mesh_action.variable,
+				       len - baselen, false, mgmt->bssid, NULL);
+	if (!elems)
+		return;
 
-	if (elems.preq) {
-		if (elems.preq_len != 37)
+	if (elems->preq) {
+		if (elems->preq_len != 37)
 			/* Right now we support just 1 destination and no AE */
-			return;
-		path_metric = hwmp_route_info_get(sdata, mgmt, elems.preq,
+			goto free;
+		path_metric = hwmp_route_info_get(sdata, mgmt, elems->preq,
 						  MPATH_PREQ);
 		if (path_metric)
-			hwmp_preq_frame_process(sdata, mgmt, elems.preq,
+			hwmp_preq_frame_process(sdata, mgmt, elems->preq,
 						path_metric);
 	}
-	if (elems.prep) {
-		if (elems.prep_len != 31)
+	if (elems->prep) {
+		if (elems->prep_len != 31)
 			/* Right now we support no AE */
-			return;
-		path_metric = hwmp_route_info_get(sdata, mgmt, elems.prep,
+			goto free;
+		path_metric = hwmp_route_info_get(sdata, mgmt, elems->prep,
 						  MPATH_PREP);
 		if (path_metric)
-			hwmp_prep_frame_process(sdata, mgmt, elems.prep,
+			hwmp_prep_frame_process(sdata, mgmt, elems->prep,
 						path_metric);
 	}
-	if (elems.perr) {
-		if (elems.perr_len != 15)
+	if (elems->perr) {
+		if (elems->perr_len != 15)
 			/* Right now we support only one destination per PERR */
-			return;
-		hwmp_perr_frame_process(sdata, mgmt, elems.perr);
+			goto free;
+		hwmp_perr_frame_process(sdata, mgmt, elems->perr);
 	}
-	if (elems.rann)
-		hwmp_rann_frame_process(sdata, mgmt, elems.rann);
+	if (elems->rann)
+		hwmp_rann_frame_process(sdata, mgmt, elems->rann);
+free:
+	kfree(elems);
 }
 
 /**
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a6915847d78a..a829470dd59e 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
  * Copyright (c) 2008, 2009 open80211s Ltd.
- * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2019, 2021 Intel Corporation
  * Author:     Luis Carlos Cobo <luisca@cozybit.com>
  */
 #include <linux/gfp.h>
@@ -1200,7 +1200,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len,
 			 struct ieee80211_rx_status *rx_status)
 {
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	size_t baselen;
 	u8 *baseaddr;
 
@@ -1228,7 +1228,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 		if (baselen > len)
 			return;
 	}
-	ieee802_11_parse_elems(baseaddr, len - baselen, true, &elems,
-			       mgmt->bssid, NULL);
-	mesh_process_plink_frame(sdata, mgmt, &elems, rx_status);
+	elems = ieee802_11_parse_elems(baseaddr, len - baselen, true,
+				       mgmt->bssid, NULL);
+	mesh_process_plink_frame(sdata, mgmt, elems, rx_status);
+	kfree(elems);
 }
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index fde93de2b80a..9e342cc2504c 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -3,6 +3,7 @@
  * Copyright 2011-2012, Pavel Zubarev <pavel.zubarev@gmail.com>
  * Copyright 2011-2012, Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
  * Copyright 2011-2012, cozybit Inc.
+ * Copyright (C) 2021 Intel Corporation
  */
 
 #include "ieee80211_i.h"
@@ -35,12 +36,12 @@ struct sync_method {
 /**
  * mesh_peer_tbtt_adjusting - check if an mp is currently adjusting its TBTT
  *
- * @ie: information elements of a management frame from the mesh peer
+ * @cfg: mesh config element from the mesh peer (or %NULL)
  */
-static bool mesh_peer_tbtt_adjusting(struct ieee802_11_elems *ie)
+static bool mesh_peer_tbtt_adjusting(const struct ieee80211_meshconf_ie *cfg)
 {
-	return (ie->mesh_config->meshconf_cap &
-			IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
+	return cfg &&
+	       (cfg->meshconf_cap & IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING);
 }
 
 void mesh_sync_adjust_tsf(struct ieee80211_sub_if_data *sdata)
@@ -76,11 +77,11 @@ void mesh_sync_adjust_tsf(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
-				   u16 stype,
-				   struct ieee80211_mgmt *mgmt,
-				   struct ieee802_11_elems *elems,
-				   struct ieee80211_rx_status *rx_status)
+static void
+mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata, u16 stype,
+			      struct ieee80211_mgmt *mgmt, unsigned int len,
+			      const struct ieee80211_meshconf_ie *mesh_cfg,
+			      struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
@@ -101,10 +102,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (ieee80211_have_rx_timestamp(rx_status))
 		t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
-						       24 + 12 +
-						       elems->total_len +
-						       FCS_LEN,
-						       24);
+						       len + FCS_LEN, 24);
 	else
 		t_r = drv_get_tsf(local, sdata);
 
@@ -119,7 +117,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	 * dot11MeshNbrOffsetMaxNeighbor non-peer non-MBSS neighbors
 	 */
 
-	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
+	if (mesh_peer_tbtt_adjusting(mesh_cfg)) {
 		msync_dbg(sdata, "STA %pM : is adjusting TBTT\n",
 			  sta->sta.addr);
 		goto no_sync;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 1548f532dc1a..cc6d38a2e6d5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2889,17 +2889,17 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
+	const struct element *challenge;
 	u8 *pos;
-	struct ieee802_11_elems elems;
 	u32 tx_flags = 0;
 	struct ieee80211_prep_tx_info info = {
 		.subtype = IEEE80211_STYPE_AUTH,
 	};
 
 	pos = mgmt->u.auth.variable;
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, auth_data->bss->bssid);
-	if (!elems.challenge)
+	challenge = cfg80211_find_elem(WLAN_EID_CHALLENGE, pos,
+				       len - (pos - (u8 *)mgmt));
+	if (!challenge)
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata, &info);
@@ -2907,7 +2907,8 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
-			    elems.challenge - 2, elems.challenge_len + 2,
+			    (void *)challenge,
+			    challenge->datalen + sizeof(*challenge),
 			    auth_data->bss->bssid, auth_data->bss->bssid,
 			    auth_data->key, auth_data->key_len,
 			    auth_data->key_idx, tx_flags);
@@ -3316,8 +3317,11 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		aid = 0; /* TODO */
 	}
 	capab_info = le16_to_cpu(mgmt->u.assoc_resp.capab_info);
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+	elems = ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false,
+				       mgmt->bssid, assoc_data->bss->bssid);
+
+	if (!elems)
+		return false;
 
 	if (elems->aid_resp)
 		aid = le16_to_cpu(elems->aid_resp->aid);
@@ -3339,7 +3343,8 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	if (!is_s1g && !elems->supp_rates) {
 		sdata_info(sdata, "no SuppRates element in AssocResp\n");
-		return false;
+		ret = false;
+		goto out;
 	}
 
 	sdata->vif.bss_conf.aid = aid;
@@ -3361,7 +3366,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	     (!(ifmgd->flags & IEEE80211_STA_DISABLE_VHT) &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems bss_elems;
+		struct ieee802_11_elems *bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -3369,16 +3374,22 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			bss_ies = kmemdup(ies, sizeof(*ies) + ies->len,
 					  GFP_ATOMIC);
 		rcu_read_unlock();
-		if (!bss_ies)
-			return false;
+		if (!bss_ies) {
+			ret = false;
+			goto out;
+		}
+
+		bss_elems = ieee802_11_parse_elems(bss_ies->data, bss_ies->len,
+						   false, mgmt->bssid,
+						   assoc_data->bss->bssid);
+		if (!bss_elems) {
+			ret = false;
+			goto out;
+		}
 
-		ieee802_11_parse_elems(bss_ies->data, bss_ies->len,
-				       false, &bss_elems,
-				       mgmt->bssid,
-				       assoc_data->bss->bssid);
 		if (assoc_data->wmm &&
-		    !elems->wmm_param && bss_elems.wmm_param) {
-			elems->wmm_param = bss_elems.wmm_param;
+		    !elems->wmm_param && bss_elems->wmm_param) {
+			elems->wmm_param = bss_elems->wmm_param;
 			sdata_info(sdata,
 				   "AP bug: WMM param missing from AssocResp\n");
 		}
@@ -3387,30 +3398,32 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		 * Also check if we requested HT/VHT, otherwise the AP doesn't
 		 * have to include the IEs in the (re)association response.
 		 */
-		if (!elems->ht_cap_elem && bss_elems.ht_cap_elem &&
+		if (!elems->ht_cap_elem && bss_elems->ht_cap_elem &&
 		    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
-			elems->ht_cap_elem = bss_elems.ht_cap_elem;
+			elems->ht_cap_elem = bss_elems->ht_cap_elem;
 			sdata_info(sdata,
 				   "AP bug: HT capability missing from AssocResp\n");
 		}
-		if (!elems->ht_operation && bss_elems.ht_operation &&
+		if (!elems->ht_operation && bss_elems->ht_operation &&
 		    !(ifmgd->flags & IEEE80211_STA_DISABLE_HT)) {
-			elems->ht_operation = bss_elems.ht_operation;
+			elems->ht_operation = bss_elems->ht_operation;
 			sdata_info(sdata,
 				   "AP bug: HT operation missing from AssocResp\n");
 		}
-		if (!elems->vht_cap_elem && bss_elems.vht_cap_elem &&
+		if (!elems->vht_cap_elem && bss_elems->vht_cap_elem &&
 		    !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT)) {
-			elems->vht_cap_elem = bss_elems.vht_cap_elem;
+			elems->vht_cap_elem = bss_elems->vht_cap_elem;
 			sdata_info(sdata,
 				   "AP bug: VHT capa missing from AssocResp\n");
 		}
-		if (!elems->vht_operation && bss_elems.vht_operation &&
+		if (!elems->vht_operation && bss_elems->vht_operation &&
 		    !(ifmgd->flags & IEEE80211_STA_DISABLE_VHT)) {
-			elems->vht_operation = bss_elems.vht_operation;
+			elems->vht_operation = bss_elems->vht_operation;
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
+
+		kfree(bss_elems);
 	}
 
 	/*
@@ -3661,6 +3674,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 
 	ret = true;
  out:
+	kfree(elems);
 	kfree(bss_ies);
 	return ret;
 }
@@ -3672,7 +3686,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
 	u16 capab_info, status_code, aid;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	int ac, uapsd_queues = -1;
 	u8 *pos;
 	bool reassoc;
@@ -3729,14 +3743,16 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	    fils_decrypt_assoc_resp(sdata, (u8 *)mgmt, &len, assoc_data) < 0)
 		return;
 
-	ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false, &elems,
-			       mgmt->bssid, assoc_data->bss->bssid);
+	elems = ieee802_11_parse_elems(pos, len - (pos - (u8 *)mgmt), false,
+				       mgmt->bssid, assoc_data->bss->bssid);
+	if (!elems)
+		goto notify_driver;
 
 	if (status_code == WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY &&
-	    elems.timeout_int &&
-	    elems.timeout_int->type == WLAN_TIMEOUT_ASSOC_COMEBACK) {
+	    elems->timeout_int &&
+	    elems->timeout_int->type == WLAN_TIMEOUT_ASSOC_COMEBACK) {
 		u32 tu, ms;
-		tu = le32_to_cpu(elems.timeout_int->value);
+		tu = le32_to_cpu(elems->timeout_int->value);
 		ms = tu * 1024 / 1000;
 		sdata_info(sdata,
 			   "%pM rejected association temporarily; comeback duration %u TU (%u ms)\n",
@@ -3756,7 +3772,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		event.u.mlme.reason = status_code;
 		drv_event_callback(sdata->local, sdata, &event);
 	} else {
-		if (!ieee80211_assoc_success(sdata, cbss, mgmt, len, &elems)) {
+		if (!ieee80211_assoc_success(sdata, cbss, mgmt, len, elems)) {
 			/* oops -- internal error -- send timeout for now */
 			ieee80211_destroy_assoc_data(sdata, false, false);
 			cfg80211_assoc_timeout(sdata->dev, cbss);
@@ -3786,6 +3802,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 			       ifmgd->assoc_req_ies, ifmgd->assoc_req_ies_len);
 notify_driver:
 	drv_mgd_complete_tx(sdata->local, sdata, &info);
+	kfree(elems);
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
@@ -3990,7 +4007,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	struct ieee80211_mgmt *mgmt = (void *) hdr;
 	size_t baselen;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct ieee80211_channel *chan;
@@ -4036,15 +4053,16 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	if (ifmgd->assoc_data && ifmgd->assoc_data->need_beacon &&
 	    ieee80211_rx_our_beacon(bssid, ifmgd->assoc_data->bss)) {
-		ieee802_11_parse_elems(variable,
-				       len - baselen, false, &elems,
-				       bssid,
-				       ifmgd->assoc_data->bss->bssid);
+		elems = ieee802_11_parse_elems(variable, len - baselen, false,
+					       bssid,
+					       ifmgd->assoc_data->bss->bssid);
+		if (!elems)
+			return;
 
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status);
 
-		if (elems.dtim_period)
-			ifmgd->dtim_period = elems.dtim_period;
+		if (elems->dtim_period)
+			ifmgd->dtim_period = elems->dtim_period;
 		ifmgd->have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
 		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
@@ -4052,17 +4070,17 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				le64_to_cpu(mgmt->u.beacon.timestamp);
 			sdata->vif.bss_conf.sync_device_ts =
 				rx_status->device_timestamp;
-			sdata->vif.bss_conf.sync_dtim_count = elems.dtim_count;
+			sdata->vif.bss_conf.sync_dtim_count = elems->dtim_count;
 		}
 
-		if (elems.mbssid_config_ie)
+		if (elems->mbssid_config_ie)
 			bss_conf->profile_periodicity =
-				elems.mbssid_config_ie->profile_periodicity;
+				elems->mbssid_config_ie->profile_periodicity;
 		else
 			bss_conf->profile_periodicity = 0;
 
-		if (elems.ext_capab_len >= 11 &&
-		    (elems.ext_capab[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
+		if (elems->ext_capab_len >= 11 &&
+		    (elems->ext_capab[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
 			bss_conf->ema_ap = true;
 		else
 			bss_conf->ema_ap = false;
@@ -4071,6 +4089,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ifmgd->assoc_data->timeout = jiffies;
 		ifmgd->assoc_data->timeout_started = true;
 		run_again(sdata, ifmgd->assoc_data->timeout);
+		kfree(elems);
 		return;
 	}
 
@@ -4102,13 +4121,15 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (!ieee80211_is_s1g_beacon(hdr->frame_control))
 		ncrc = crc32_be(0, (void *)&mgmt->u.beacon.beacon_int, 4);
-	ncrc = ieee802_11_parse_elems_crc(variable,
-					  len - baselen, false, &elems,
-					  care_about_ies, ncrc,
-					  mgmt->bssid, bssid);
+	elems = ieee802_11_parse_elems_crc(variable, len - baselen,
+					   false, care_about_ies, ncrc,
+					   mgmt->bssid, bssid);
+	if (!elems)
+		return;
+	ncrc = elems->crc;
 
 	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
-	    ieee80211_check_tim(elems.tim, elems.tim_len, bss_conf->aid)) {
+	    ieee80211_check_tim(elems->tim, elems->tim_len, bss_conf->aid)) {
 		if (local->hw.conf.dynamic_ps_timeout > 0) {
 			if (local->hw.conf.flags & IEEE80211_CONF_PS) {
 				local->hw.conf.flags &= ~IEEE80211_CONF_PS;
@@ -4178,12 +4199,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			le64_to_cpu(mgmt->u.beacon.timestamp);
 		sdata->vif.bss_conf.sync_device_ts =
 			rx_status->device_timestamp;
-		sdata->vif.bss_conf.sync_dtim_count = elems.dtim_count;
+		sdata->vif.bss_conf.sync_dtim_count = elems->dtim_count;
 	}
 
 	if ((ncrc == ifmgd->beacon_crc && ifmgd->beacon_crc_valid) ||
 	    ieee80211_is_s1g_short_beacon(mgmt->frame_control))
-		return;
+		goto free;
 	ifmgd->beacon_crc = ncrc;
 	ifmgd->beacon_crc_valid = true;
 
@@ -4191,12 +4212,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 	ieee80211_sta_process_chanswitch(sdata, rx_status->mactime,
 					 rx_status->device_timestamp,
-					 &elems, true);
+					 elems, true);
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_WMM) &&
-	    ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
-				     elems.wmm_param_len,
-				     elems.mu_edca_param_set))
+	    ieee80211_sta_wmm_params(local, sdata, elems->wmm_param,
+				     elems->wmm_param_len,
+				     elems->mu_edca_param_set))
 		changed |= BSS_CHANGED_QOS;
 
 	/*
@@ -4205,7 +4226,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (!ifmgd->have_beacon) {
 		/* a few bogus AP send dtim_period = 0 or no TIM IE */
-		bss_conf->dtim_period = elems.dtim_period ?: 1;
+		bss_conf->dtim_period = elems->dtim_period ?: 1;
 
 		changed |= BSS_CHANGED_BEACON_INFO;
 		ifmgd->have_beacon = true;
@@ -4217,9 +4238,9 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		ieee80211_recalc_ps_vif(sdata);
 	}
 
-	if (elems.erp_info) {
+	if (elems->erp_info) {
 		erp_valid = true;
-		erp_value = elems.erp_info[0];
+		erp_value = elems->erp_info[0];
 	} else {
 		erp_valid = false;
 	}
@@ -4232,12 +4253,12 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&local->sta_mtx);
 	sta = sta_info_get(sdata, bssid);
 
-	changed |= ieee80211_recalc_twt_req(sdata, sta, &elems);
+	changed |= ieee80211_recalc_twt_req(sdata, sta, elems);
 
-	if (ieee80211_config_bw(sdata, sta, elems.ht_cap_elem,
-				elems.vht_cap_elem, elems.ht_operation,
-				elems.vht_operation, elems.he_operation,
-				elems.s1g_oper, bssid, &changed)) {
+	if (ieee80211_config_bw(sdata, sta, elems->ht_cap_elem,
+				elems->vht_cap_elem, elems->ht_operation,
+				elems->vht_operation, elems->he_operation,
+				elems->s1g_oper, bssid, &changed)) {
 		mutex_unlock(&local->sta_mtx);
 		sdata_info(sdata,
 			   "failed to follow AP %pM bandwidth change, disconnect\n",
@@ -4249,21 +4270,23 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					    sizeof(deauth_buf), true,
 					    WLAN_REASON_DEAUTH_LEAVING,
 					    false);
-		return;
+		goto free;
 	}
 
-	if (sta && elems.opmode_notif)
-		ieee80211_vht_handle_opmode(sdata, sta, *elems.opmode_notif,
+	if (sta && elems->opmode_notif)
+		ieee80211_vht_handle_opmode(sdata, sta, *elems->opmode_notif,
 					    rx_status->band);
 	mutex_unlock(&local->sta_mtx);
 
 	changed |= ieee80211_handle_pwr_constr(sdata, chan, mgmt,
-					       elems.country_elem,
-					       elems.country_elem_len,
-					       elems.pwr_constr_elem,
-					       elems.cisco_dtpc_elem);
+					       elems->country_elem,
+					       elems->country_elem_len,
+					       elems->pwr_constr_elem,
+					       elems->cisco_dtpc_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
+free:
+	kfree(elems);
 }
 
 void ieee80211_sta_rx_queued_ext(struct ieee80211_sub_if_data *sdata,
@@ -4292,7 +4315,6 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
 	u16 fc;
-	struct ieee802_11_elems elems;
 	int ies_len;
 
 	rx_status = (struct ieee80211_rx_status *) skb->cb;
@@ -4324,6 +4346,8 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 		break;
 	case IEEE80211_STYPE_ACTION:
 		if (mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT) {
+			struct ieee802_11_elems *elems;
+
 			ies_len = skb->len -
 				  offsetof(struct ieee80211_mgmt,
 					   u.action.u.chan_switch.variable);
@@ -4332,18 +4356,19 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 				break;
 
 			/* CSA IE cannot be overridden, no need for BSSID */
-			ieee802_11_parse_elems(
-				mgmt->u.action.u.chan_switch.variable,
-				ies_len, true, &elems, mgmt->bssid, NULL);
-
-			if (elems.parse_error)
-				break;
-
-			ieee80211_sta_process_chanswitch(sdata,
-						 rx_status->mactime,
-						 rx_status->device_timestamp,
-						 &elems, false);
+			elems = ieee802_11_parse_elems(
+					mgmt->u.action.u.chan_switch.variable,
+					ies_len, true, mgmt->bssid, NULL);
+
+			if (elems && !elems->parse_error)
+				ieee80211_sta_process_chanswitch(sdata,
+								 rx_status->mactime,
+								 rx_status->device_timestamp,
+								 elems, false);
+			kfree(elems);
 		} else if (mgmt->u.action.category == WLAN_CATEGORY_PUBLIC) {
+			struct ieee802_11_elems *elems;
+
 			ies_len = skb->len -
 				  offsetof(struct ieee80211_mgmt,
 					   u.action.u.ext_chan_switch.variable);
@@ -4355,21 +4380,22 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 			 * extended CSA IE can't be overridden, no need for
 			 * BSSID
 			 */
-			ieee802_11_parse_elems(
-				mgmt->u.action.u.ext_chan_switch.variable,
-				ies_len, true, &elems, mgmt->bssid, NULL);
-
-			if (elems.parse_error)
-				break;
-
-			/* for the handling code pretend this was also an IE */
-			elems.ext_chansw_ie =
-				&mgmt->u.action.u.ext_chan_switch.data;
+			elems = ieee802_11_parse_elems(
+					mgmt->u.action.u.ext_chan_switch.variable,
+					ies_len, true, mgmt->bssid, NULL);
+
+			if (elems && !elems->parse_error) {
+				/* for the handling code pretend it was an IE */
+				elems->ext_chansw_ie =
+					&mgmt->u.action.u.ext_chan_switch.data;
+
+				ieee80211_sta_process_chanswitch(sdata,
+								 rx_status->mactime,
+								 rx_status->device_timestamp,
+								 elems, false);
+			}
 
-			ieee80211_sta_process_chanswitch(sdata,
-						 rx_status->mactime,
-						 rx_status->device_timestamp,
-						 &elems, false);
+			kfree(elems);
 		}
 		break;
 	}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 743e97ba352c..175ead6b19cb 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1982,10 +1982,11 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 
 		if (mmie_keyidx < NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS ||
 		    mmie_keyidx >= NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS +
-		    NUM_DEFAULT_BEACON_KEYS) {
-			cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
-						     skb->data,
-						     skb->len);
+				   NUM_DEFAULT_BEACON_KEYS) {
+			if (rx->sdata->dev)
+				cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
+							     skb->data,
+							     skb->len);
 			return RX_DROP_MONITOR; /* unexpected BIP keyidx */
 		}
 
@@ -2133,7 +2134,8 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	/* either the frame has been decrypted or will be dropped */
 	status->flag |= RX_FLAG_DECRYPTED;
 
-	if (unlikely(ieee80211_is_beacon(fc) && result == RX_DROP_UNUSABLE))
+	if (unlikely(ieee80211_is_beacon(fc) && result == RX_DROP_UNUSABLE &&
+		     rx->sdata->dev))
 		cfg80211_rx_unprot_mlme_mgmt(rx->sdata->dev,
 					     skb->data, skb->len);
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index d6afaacaf7ef..e692a2487eb5 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -9,7 +9,7 @@
  * Copyright 2007, Michael Wu <flamingice@sourmilk.net>
  * Copyright 2013-2015  Intel Mobile Communications GmbH
  * Copyright 2016-2017  Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 #include <linux/if_arp.h>
@@ -155,7 +155,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	};
 	bool signal_valid;
 	struct ieee80211_sub_if_data *scan_sdata;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	size_t baselen;
 	u8 *elements;
 
@@ -209,8 +209,10 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	if (baselen > len)
 		return NULL;
 
-	ieee802_11_parse_elems(elements, len - baselen, false, &elems,
-			       mgmt->bssid, cbss->bssid);
+	elems = ieee802_11_parse_elems(elements, len - baselen, false,
+				       mgmt->bssid, cbss->bssid);
+	if (!elems)
+		return NULL;
 
 	/* In case the signal is invalid update the status */
 	signal_valid = channel == cbss->channel;
@@ -218,15 +220,17 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 	bss = (void *)cbss->priv;
-	ieee80211_update_bss_from_elems(local, bss, &elems, rx_status, beacon);
+	ieee80211_update_bss_from_elems(local, bss, elems, rx_status, beacon);
 
 	list_for_each_entry(non_tx_cbss, &cbss->nontrans_list, nontrans_list) {
 		non_tx_bss = (void *)non_tx_cbss->priv;
 
-		ieee80211_update_bss_from_elems(local, non_tx_bss, &elems,
+		ieee80211_update_bss_from_elems(local, non_tx_bss, elems,
 						rx_status, beacon);
 	}
 
+	kfree(elems);
+
 	return bss;
 }
 
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 45e532ad1215..137be9ec94af 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -6,7 +6,7 @@
  * Copyright 2014, Intel Corporation
  * Copyright 2014  Intel Mobile Communications GmbH
  * Copyright 2015 - 2016 Intel Deutschland GmbH
- * Copyright (C) 2019 Intel Corporation
+ * Copyright (C) 2019, 2021 Intel Corporation
  */
 
 #include <linux/ieee80211.h>
@@ -1684,7 +1684,7 @@ ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems = NULL;
 	struct sta_info *sta;
 	struct ieee80211_tdls_data *tf = (void *)skb->data;
 	bool local_initiator;
@@ -1718,16 +1718,20 @@ ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
 		goto call_drv;
 	}
 
-	ieee802_11_parse_elems(tf->u.chan_switch_resp.variable,
-			       skb->len - baselen, false, &elems,
-			       NULL, NULL);
-	if (elems.parse_error) {
+	elems = ieee802_11_parse_elems(tf->u.chan_switch_resp.variable,
+				       skb->len - baselen, false, NULL, NULL);
+	if (!elems) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (elems->parse_error) {
 		tdls_dbg(sdata, "Invalid IEs in TDLS channel switch resp\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
-	if (!elems.ch_sw_timing || !elems.lnk_id) {
+	if (!elems->ch_sw_timing || !elems->lnk_id) {
 		tdls_dbg(sdata, "TDLS channel switch resp - missing IEs\n");
 		ret = -EINVAL;
 		goto out;
@@ -1735,15 +1739,15 @@ ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
 
 	/* validate the initiator is set correctly */
 	local_initiator =
-		!memcmp(elems.lnk_id->init_sta, sdata->vif.addr, ETH_ALEN);
+		!memcmp(elems->lnk_id->init_sta, sdata->vif.addr, ETH_ALEN);
 	if (local_initiator == sta->sta.tdls_initiator) {
 		tdls_dbg(sdata, "TDLS chan switch invalid lnk-id initiator\n");
 		ret = -EINVAL;
 		goto out;
 	}
 
-	params.switch_time = le16_to_cpu(elems.ch_sw_timing->switch_time);
-	params.switch_timeout = le16_to_cpu(elems.ch_sw_timing->switch_timeout);
+	params.switch_time = le16_to_cpu(elems->ch_sw_timing->switch_time);
+	params.switch_timeout = le16_to_cpu(elems->ch_sw_timing->switch_timeout);
 
 	params.tmpl_skb =
 		ieee80211_tdls_ch_sw_resp_tmpl_get(sta, &params.ch_sw_tm_ie);
@@ -1763,6 +1767,7 @@ ieee80211_process_tdls_channel_switch_resp(struct ieee80211_sub_if_data *sdata,
 out:
 	mutex_unlock(&local->sta_mtx);
 	dev_kfree_skb_any(params.tmpl_skb);
+	kfree(elems);
 	return ret;
 }
 
@@ -1771,7 +1776,7 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 					  struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee802_11_elems elems;
+	struct ieee802_11_elems *elems;
 	struct cfg80211_chan_def chandef;
 	struct ieee80211_channel *chan;
 	enum nl80211_channel_type chan_type;
@@ -1831,22 +1836,27 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 		return -EINVAL;
 	}
 
-	ieee802_11_parse_elems(tf->u.chan_switch_req.variable,
-			       skb->len - baselen, false, &elems, NULL, NULL);
-	if (elems.parse_error) {
+	elems = ieee802_11_parse_elems(tf->u.chan_switch_req.variable,
+				       skb->len - baselen, false, NULL, NULL);
+	if (!elems)
+		return -ENOMEM;
+
+	if (elems->parse_error) {
 		tdls_dbg(sdata, "Invalid IEs in TDLS channel switch req\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free;
 	}
 
-	if (!elems.ch_sw_timing || !elems.lnk_id) {
+	if (!elems->ch_sw_timing || !elems->lnk_id) {
 		tdls_dbg(sdata, "TDLS channel switch req - missing IEs\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free;
 	}
 
-	if (!elems.sec_chan_offs) {
+	if (!elems->sec_chan_offs) {
 		chan_type = NL80211_CHAN_HT20;
 	} else {
-		switch (elems.sec_chan_offs->sec_chan_offs) {
+		switch (elems->sec_chan_offs->sec_chan_offs) {
 		case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
 			chan_type = NL80211_CHAN_HT40PLUS;
 			break;
@@ -1865,7 +1875,8 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 	if (!cfg80211_reg_can_beacon_relax(sdata->local->hw.wiphy, &chandef,
 					   sdata->wdev.iftype)) {
 		tdls_dbg(sdata, "TDLS chan switch to forbidden channel\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free;
 	}
 
 	mutex_lock(&local->sta_mtx);
@@ -1881,7 +1892,7 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 
 	/* validate the initiator is set correctly */
 	local_initiator =
-		!memcmp(elems.lnk_id->init_sta, sdata->vif.addr, ETH_ALEN);
+		!memcmp(elems->lnk_id->init_sta, sdata->vif.addr, ETH_ALEN);
 	if (local_initiator == sta->sta.tdls_initiator) {
 		tdls_dbg(sdata, "TDLS chan switch invalid lnk-id initiator\n");
 		ret = -EINVAL;
@@ -1889,16 +1900,16 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 	}
 
 	/* peer should have known better */
-	if (!sta->sta.ht_cap.ht_supported && elems.sec_chan_offs &&
-	    elems.sec_chan_offs->sec_chan_offs) {
+	if (!sta->sta.ht_cap.ht_supported && elems->sec_chan_offs &&
+	    elems->sec_chan_offs->sec_chan_offs) {
 		tdls_dbg(sdata, "TDLS chan switch - wide chan unsupported\n");
 		ret = -ENOTSUPP;
 		goto out;
 	}
 
 	params.chandef = &chandef;
-	params.switch_time = le16_to_cpu(elems.ch_sw_timing->switch_time);
-	params.switch_timeout = le16_to_cpu(elems.ch_sw_timing->switch_timeout);
+	params.switch_time = le16_to_cpu(elems->ch_sw_timing->switch_time);
+	params.switch_timeout = le16_to_cpu(elems->ch_sw_timing->switch_timeout);
 
 	params.tmpl_skb =
 		ieee80211_tdls_ch_sw_resp_tmpl_get(sta,
@@ -1917,6 +1928,8 @@ ieee80211_process_tdls_channel_switch_req(struct ieee80211_sub_if_data *sdata,
 out:
 	mutex_unlock(&local->sta_mtx);
 	dev_kfree_skb_any(params.tmpl_skb);
+free:
+	kfree(elems);
 	return ret;
 }
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index be1911d8089f..354badd32793 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1117,10 +1117,6 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			} else
 				elem_parse_failed = true;
 			break;
-		case WLAN_EID_CHALLENGE:
-			elems->challenge = pos;
-			elems->challenge_len = elen;
-			break;
 		case WLAN_EID_VENDOR_SPECIFIC:
 			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
 			    pos[2] == 0xf2) {
@@ -1400,8 +1396,8 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 
 static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 					    struct ieee802_11_elems *elems,
-					    u8 *transmitter_bssid,
-					    u8 *bss_bssid,
+					    const u8 *transmitter_bssid,
+					    const u8 *bss_bssid,
 					    u8 *nontransmitted_profile)
 {
 	const struct element *elem, *sub;
@@ -1414,6 +1410,8 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, start, len) {
 		if (elem->datalen < 2)
 			continue;
+		if (elem->data[0] < 1 || elem->data[0] > 8)
+			continue;
 
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
 			u8 new_bssid[ETH_ALEN];
@@ -1466,31 +1464,36 @@ static size_t ieee802_11_find_bssid_profile(const u8 *start, size_t len,
 	return found ? profile_len : 0;
 }
 
-u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
-			       struct ieee802_11_elems *elems,
-			       u64 filter, u32 crc, u8 *transmitter_bssid,
-			       u8 *bss_bssid)
+struct ieee802_11_elems *ieee802_11_parse_elems_crc(const u8 *start, size_t len,
+						    bool action, u64 filter,
+						    u32 crc,
+						    const u8 *transmitter_bssid,
+						    const u8 *bss_bssid)
 {
+	struct ieee802_11_elems *elems;
 	const struct element *non_inherit = NULL;
 	u8 *nontransmitted_profile;
 	int nontransmitted_profile_len = 0;
 
-	memset(elems, 0, sizeof(*elems));
+	elems = kzalloc(sizeof(*elems) + len, GFP_ATOMIC);
+	if (!elems)
+		return NULL;
 	elems->ie_start = start;
 	elems->total_len = len;
 
-	nontransmitted_profile = kmalloc(len, GFP_ATOMIC);
-	if (nontransmitted_profile) {
-		nontransmitted_profile_len =
-			ieee802_11_find_bssid_profile(start, len, elems,
-						      transmitter_bssid,
-						      bss_bssid,
-						      nontransmitted_profile);
-		non_inherit =
-			cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
-					       nontransmitted_profile,
-					       nontransmitted_profile_len);
-	}
+	elems->scratch_len = len;
+	elems->scratch_pos = elems->scratch;
+
+	nontransmitted_profile = elems->scratch_pos;
+	nontransmitted_profile_len =
+		ieee802_11_find_bssid_profile(start, len, elems,
+					      transmitter_bssid,
+					      bss_bssid,
+					      nontransmitted_profile);
+	non_inherit =
+		cfg80211_find_ext_elem(WLAN_EID_EXT_NON_INHERITANCE,
+				       nontransmitted_profile,
+				       nontransmitted_profile_len);
 
 	crc = _ieee802_11_parse_elems_crc(start, len, action, elems, filter,
 					  crc, non_inherit);
@@ -1519,9 +1522,9 @@ u32 ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 	    offsetofend(struct ieee80211_bssid_index, dtim_count))
 		elems->dtim_count = elems->bssid_index->dtim_count;
 
-	kfree(nontransmitted_profile);
+	elems->crc = crc;
 
-	return crc;
+	return elems;
 }
 
 void ieee80211_regulatory_limit_wmm_params(struct ieee80211_sub_if_data *sdata,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 1a8b76c9dd56..f0de22a6caf7 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -143,18 +143,12 @@ static inline void bss_ref_get(struct cfg80211_registered_device *rdev,
 	lockdep_assert_held(&rdev->bss_lock);
 
 	bss->refcount++;
-	if (bss->pub.hidden_beacon_bss) {
-		bss = container_of(bss->pub.hidden_beacon_bss,
-				   struct cfg80211_internal_bss,
-				   pub);
-		bss->refcount++;
-	}
-	if (bss->pub.transmitted_bss) {
-		bss = container_of(bss->pub.transmitted_bss,
-				   struct cfg80211_internal_bss,
-				   pub);
-		bss->refcount++;
-	}
+
+	if (bss->pub.hidden_beacon_bss)
+		bss_from_pub(bss->pub.hidden_beacon_bss)->refcount++;
+
+	if (bss->pub.transmitted_bss)
+		bss_from_pub(bss->pub.transmitted_bss)->refcount++;
 }
 
 static inline void bss_ref_put(struct cfg80211_registered_device *rdev,
@@ -304,7 +298,8 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 	tmp_old = cfg80211_find_ie(WLAN_EID_SSID, ie, ielen);
 	tmp_old = (tmp_old) ? tmp_old + tmp_old[1] + 2 : ie;
 
-	while (tmp_old + tmp_old[1] + 2 - ie <= ielen) {
+	while (tmp_old + 2 - ie <= ielen &&
+	       tmp_old + tmp_old[1] + 2 - ie <= ielen) {
 		if (tmp_old[0] == 0) {
 			tmp_old++;
 			continue;
@@ -364,7 +359,8 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 	 * copied to new ie, skip ssid, capability, bssid-index ie
 	 */
 	tmp_new = sub_copy;
-	while (tmp_new + tmp_new[1] + 2 - sub_copy <= subie_len) {
+	while (tmp_new + 2 - sub_copy <= subie_len &&
+	       tmp_new + tmp_new[1] + 2 - sub_copy <= subie_len) {
 		if (!(tmp_new[0] == WLAN_EID_NON_TX_BSSID_CAP ||
 		      tmp_new[0] == WLAN_EID_SSID)) {
 			memcpy(pos, tmp_new, tmp_new[1] + 2);
@@ -429,6 +425,15 @@ cfg80211_add_nontrans_list(struct cfg80211_bss *trans_bss,
 
 	rcu_read_unlock();
 
+	/*
+	 * This is a bit weird - it's not on the list, but already on another
+	 * one! The only way that could happen is if there's some BSSID/SSID
+	 * shared by multiple APs in their multi-BSSID profiles, potentially
+	 * with hidden SSID mixed in ... ignore it.
+	 */
+	if (!list_empty(&nontrans_bss->nontrans_list))
+		return -EINVAL;
+
 	/* add to the list */
 	list_add_tail(&nontrans_bss->nontrans_list, &trans_bss->nontrans_list);
 	return 0;
@@ -1604,6 +1609,23 @@ struct cfg80211_non_tx_bss {
 	u8 bssid_index;
 };
 
+static void cfg80211_update_hidden_bsses(struct cfg80211_internal_bss *known,
+					 const struct cfg80211_bss_ies *new_ies,
+					 const struct cfg80211_bss_ies *old_ies)
+{
+	struct cfg80211_internal_bss *bss;
+
+	/* Assign beacon IEs to all sub entries */
+	list_for_each_entry(bss, &known->hidden_list, hidden_list) {
+		const struct cfg80211_bss_ies *ies;
+
+		ies = rcu_access_pointer(bss->pub.beacon_ies);
+		WARN_ON(ies != old_ies);
+
+		rcu_assign_pointer(bss->pub.beacon_ies, new_ies);
+	}
+}
+
 static bool
 cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			  struct cfg80211_internal_bss *known,
@@ -1627,7 +1649,6 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
 	} else if (rcu_access_pointer(new->pub.beacon_ies)) {
 		const struct cfg80211_bss_ies *old;
-		struct cfg80211_internal_bss *bss;
 
 		if (known->pub.hidden_beacon_bss &&
 		    !list_empty(&known->hidden_list)) {
@@ -1655,16 +1676,7 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 		if (old == rcu_access_pointer(known->pub.ies))
 			rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
 
-		/* Assign beacon IEs to all sub entries */
-		list_for_each_entry(bss, &known->hidden_list, hidden_list) {
-			const struct cfg80211_bss_ies *ies;
-
-			ies = rcu_access_pointer(bss->pub.beacon_ies);
-			WARN_ON(ies != old);
-
-			rcu_assign_pointer(bss->pub.beacon_ies,
-					   new->pub.beacon_ies);
-		}
+		cfg80211_update_hidden_bsses(known, new->pub.beacon_ies, old);
 
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
@@ -1741,6 +1753,8 @@ cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		new->refcount = 1;
 		INIT_LIST_HEAD(&new->hidden_list);
 		INIT_LIST_HEAD(&new->pub.nontrans_list);
+		/* we'll set this later if it was non-NULL */
+		new->pub.transmitted_bss = NULL;
 
 		if (rcu_access_pointer(tmp->pub.proberesp_ies)) {
 			hidden = rb_find_bss(rdev, tmp, BSS_CMP_HIDE_ZLEN);
@@ -1981,10 +1995,15 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 		spin_lock_bh(&rdev->bss_lock);
 		if (cfg80211_add_nontrans_list(non_tx_data->tx_bss,
 					       &res->pub)) {
-			if (__cfg80211_unlink_bss(rdev, res))
+			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				res = NULL;
+			}
 		}
 		spin_unlock_bh(&rdev->bss_lock);
+
+		if (!res)
+			return NULL;
 	}
 
 	trace_cfg80211_return_bss(&res->pub);
@@ -2103,6 +2122,8 @@ static void cfg80211_parse_mbssid_data(struct wiphy *wiphy,
 	for_each_element_id(elem, WLAN_EID_MULTIPLE_BSSID, ie, ielen) {
 		if (elem->datalen < 4)
 			continue;
+		if (elem->data[0] < 1 || (int)elem->data[0] > 8)
+			continue;
 		for_each_element(sub, elem->data + 1, elem->datalen - 1) {
 			u8 profile_len;
 
@@ -2238,7 +2259,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	size_t new_ie_len;
 	struct cfg80211_bss_ies *new_ies;
 	const struct cfg80211_bss_ies *old;
-	u8 cpy_len;
+	size_t cpy_len;
 
 	lockdep_assert_held(&wiphy_to_rdev(wiphy)->bss_lock);
 
@@ -2305,6 +2326,8 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	} else {
 		old = rcu_access_pointer(nontrans_bss->beacon_ies);
 		rcu_assign_pointer(nontrans_bss->beacon_ies, new_ies);
+		cfg80211_update_hidden_bsses(bss_from_pub(nontrans_bss),
+					     new_ies, old);
 		rcu_assign_pointer(nontrans_bss->ies, new_ies);
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index 555d2dfc0ff7..185c609c6e38 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -30,7 +30,7 @@ static const struct dmi_system_id uefi_skip_cert[] = {
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir8,2") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacBookAir9,1") },
-	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacMini8,1") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "Macmini8,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index cc94da9151c3..b5b71a285119 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2523,7 +2523,8 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_NOPM },
 	/* Poulsbo */
 	{ PCI_DEVICE(0x8086, 0x811b),
-	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },
+	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE |
+	  AZX_DCAPS_POSFIX_LPIB },
 	/* Oaktrail */
 	{ PCI_DEVICE(0x8086, 0x080a),
 	  .driver_data = AZX_DRIVER_SCH | AZX_DCAPS_INTEL_PCH_BASE },
