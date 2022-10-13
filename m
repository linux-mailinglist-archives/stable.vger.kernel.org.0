Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD36C5FE065
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbiJMSJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbiJMSIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:08:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 217403470D;
        Thu, 13 Oct 2022 11:06:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55848619F7;
        Thu, 13 Oct 2022 18:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B0AC433D6;
        Thu, 13 Oct 2022 18:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684074;
        bh=5fGeL9rrSeEnEiyxIZ1qrK6yt0BsEelbTs8rHswWTrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OFkiqKKeB4JRTYj5cAUN2BuyrjxrFoQ/j0M8uzxK+gUE2tODiuEJWkIyMobdZilkp
         kRiyqMApMGAI9CQIvD/VkR5AsP1HERl8PWLowln9evEVC6vCOXbZyT77/RVEZPvdos
         JBvKu/2nSziX24ZNewvuUjAjeT4XkRDeN5Yv9yxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Laurent Dufour <laurent.dufour@fr.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.0 17/34] Revert "powerpc/rtas: Implement reentrant rtas call"
Date:   Thu, 13 Oct 2022 19:52:55 +0200
Message-Id: <20221013175146.967941800@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

commit f88aabad33ea22be2ce1c60d8901942e4e2a9edb upstream.

At the time this was submitted by Leonardo, I confirmed -- or thought
I had confirmed -- with PowerVM partition firmware development that
the following RTAS functions:

- ibm,get-xive
- ibm,int-off
- ibm,int-on
- ibm,set-xive

were safe to call on multiple CPUs simultaneously, not only with
respect to themselves as indicated by PAPR, but with arbitrary other
RTAS calls:

https://lore.kernel.org/linuxppc-dev/875zcy2v8o.fsf@linux.ibm.com/

Recent discussion with firmware development makes it clear that this
is not true, and that the code in commit b664db8e3f97 ("powerpc/rtas:
Implement reentrant rtas call") is unsafe, likely explaining several
strange bugs we've seen in internal testing involving DLPAR and
LPM. These scenarios use ibm,configure-connector, whose internal state
can be corrupted by the concurrent use of the "reentrant" functions,
leading to symptoms like endless busy statuses from RTAS.

Fixes: b664db8e3f97 ("powerpc/rtas: Implement reentrant rtas call")
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Reviewed-by: Laurent Dufour <laurent.dufour@fr.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220907220111.223267-1-nathanl@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/paca.h     |    1 
 arch/powerpc/include/asm/rtas.h     |    1 
 arch/powerpc/kernel/paca.c          |   32 ---------------------
 arch/powerpc/kernel/rtas.c          |   54 ------------------------------------
 arch/powerpc/sysdev/xics/ics-rtas.c |   22 +++++++-------
 5 files changed, 11 insertions(+), 99 deletions(-)

--- a/arch/powerpc/include/asm/paca.h
+++ b/arch/powerpc/include/asm/paca.h
@@ -263,7 +263,6 @@ struct paca_struct {
 	u64 l1d_flush_size;
 #endif
 #ifdef CONFIG_PPC_PSERIES
-	struct rtas_args *rtas_args_reentrant;
 	u8 *mce_data_buf;		/* buffer to hold per cpu rtas errlog */
 #endif /* CONFIG_PPC_PSERIES */
 
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
--- a/arch/powerpc/kernel/paca.c
+++ b/arch/powerpc/kernel/paca.c
@@ -16,7 +16,6 @@
 #include <asm/kexec.h>
 #include <asm/svm.h>
 #include <asm/ultravisor.h>
-#include <asm/rtas.h>
 
 #include "setup.h"
 
@@ -170,30 +169,6 @@ static struct slb_shadow * __init new_sl
 }
 #endif /* CONFIG_PPC_64S_HASH_MMU */
 
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
@@ -232,10 +207,6 @@ void __init initialise_paca(struct paca_
 	/* For now -- if we have threads this will be adjusted later */
 	new_paca->tcd_ptr = &new_paca->tcd;
 #endif
-
-#ifdef CONFIG_PPC_PSERIES
-	new_paca->rtas_args_reentrant = NULL;
-#endif
 }
 
 /* Put the paca pointer into r13 and SPRG_PACA */
@@ -308,9 +279,6 @@ void __init allocate_paca(int cpu)
 #ifdef CONFIG_PPC_64S_HASH_MMU
 	paca->slb_shadow_ptr = new_slb_shadow(cpu, limit);
 #endif
-#ifdef CONFIG_PPC_PSERIES
-	paca->rtas_args_reentrant = new_rtas_args(cpu, limit);
-#endif
 	paca_struct_size += sizeof(struct paca_struct);
 }
 
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -43,7 +43,6 @@
 #include <asm/time.h>
 #include <asm/mmu.h>
 #include <asm/topology.h>
-#include <asm/paca.h>
 
 /* This is here deliberately so it's only used in this file */
 void enter_rtas(unsigned long);
@@ -932,59 +931,6 @@ void rtas_activate_firmware(void)
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
  * get_pseries_errorlog() - Find a specific pseries error log in an RTAS
  *                          extended event log.
--- a/arch/powerpc/sysdev/xics/ics-rtas.c
+++ b/arch/powerpc/sysdev/xics/ics-rtas.c
@@ -36,8 +36,8 @@ static void ics_rtas_unmask_irq(struct i
 
 	server = xics_get_irq_server(d->irq, irq_data_get_affinity_mask(d), 0);
 
-	call_status = rtas_call_reentrant(ibm_set_xive, 3, 1, NULL, hw_irq,
-					  server, DEFAULT_PRIORITY);
+	call_status = rtas_call(ibm_set_xive, 3, 1, NULL, hw_irq, server,
+				DEFAULT_PRIORITY);
 	if (call_status != 0) {
 		printk(KERN_ERR
 			"%s: ibm_set_xive irq %u server %x returned %d\n",
@@ -46,7 +46,7 @@ static void ics_rtas_unmask_irq(struct i
 	}
 
 	/* Now unmask the interrupt (often a no-op) */
-	call_status = rtas_call_reentrant(ibm_int_on, 1, 1, NULL, hw_irq);
+	call_status = rtas_call(ibm_int_on, 1, 1, NULL, hw_irq);
 	if (call_status != 0) {
 		printk(KERN_ERR "%s: ibm_int_on irq=%u returned %d\n",
 			__func__, hw_irq, call_status);
@@ -68,7 +68,7 @@ static void ics_rtas_mask_real_irq(unsig
 	if (hw_irq == XICS_IPI)
 		return;
 
-	call_status = rtas_call_reentrant(ibm_int_off, 1, 1, NULL, hw_irq);
+	call_status = rtas_call(ibm_int_off, 1, 1, NULL, hw_irq);
 	if (call_status != 0) {
 		printk(KERN_ERR "%s: ibm_int_off irq=%u returned %d\n",
 			__func__, hw_irq, call_status);
@@ -76,8 +76,8 @@ static void ics_rtas_mask_real_irq(unsig
 	}
 
 	/* Have to set XIVE to 0xff to be able to remove a slot */
-	call_status = rtas_call_reentrant(ibm_set_xive, 3, 1, NULL, hw_irq,
-					  xics_default_server, 0xff);
+	call_status = rtas_call(ibm_set_xive, 3, 1, NULL, hw_irq,
+				xics_default_server, 0xff);
 	if (call_status != 0) {
 		printk(KERN_ERR "%s: ibm_set_xive(0xff) irq=%u returned %d\n",
 			__func__, hw_irq, call_status);
@@ -108,7 +108,7 @@ static int ics_rtas_set_affinity(struct
 	if (hw_irq == XICS_IPI || hw_irq == XICS_IRQ_SPURIOUS)
 		return -1;
 
-	status = rtas_call_reentrant(ibm_get_xive, 1, 3, xics_status, hw_irq);
+	status = rtas_call(ibm_get_xive, 1, 3, xics_status, hw_irq);
 
 	if (status) {
 		printk(KERN_ERR "%s: ibm,get-xive irq=%u returns %d\n",
@@ -126,8 +126,8 @@ static int ics_rtas_set_affinity(struct
 	pr_debug("%s: irq %d [hw 0x%x] server: 0x%x\n", __func__, d->irq,
 		 hw_irq, irq_server);
 
-	status = rtas_call_reentrant(ibm_set_xive, 3, 1, NULL,
-				     hw_irq, irq_server, xics_status[1]);
+	status = rtas_call(ibm_set_xive, 3, 1, NULL,
+			   hw_irq, irq_server, xics_status[1]);
 
 	if (status) {
 		printk(KERN_ERR "%s: ibm,set-xive irq=%u returns %d\n",
@@ -158,7 +158,7 @@ static int ics_rtas_check(struct ics *ic
 		return -EINVAL;
 
 	/* Check if RTAS knows about this interrupt */
-	rc = rtas_call_reentrant(ibm_get_xive, 1, 3, status, hw_irq);
+	rc = rtas_call(ibm_get_xive, 1, 3, status, hw_irq);
 	if (rc)
 		return -ENXIO;
 
@@ -174,7 +174,7 @@ static long ics_rtas_get_server(struct i
 {
 	int rc, status[2];
 
-	rc = rtas_call_reentrant(ibm_get_xive, 1, 3, status, vec);
+	rc = rtas_call(ibm_get_xive, 1, 3, status, vec);
 	if (rc)
 		return -1;
 	return status[0];


