Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059A6535F90
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344430AbiE0LkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351658AbiE0Lj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:39:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3377913B8D1;
        Fri, 27 May 2022 04:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6BA2B824D6;
        Fri, 27 May 2022 11:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA558C385A9;
        Fri, 27 May 2022 11:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651533;
        bh=X1XNy8TH7ZpSDPxThdHUSlYhCXZLMFIpqWoo35o6R1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lP0XTB3YtWzo/y2wr9KK3wQ5PFWplRHSPo2eURlov+P9DeJZPZ0MnWjlhfaXU7L2q
         GEYHonSLtLN9js7Wv20mZxUtRvWT6rLM+rtZvccZMwTrqZ5ulYE8JK11eoBd9Crwl/
         7x3ELExn+NcrbgZJctDeCWyspXDymBMURf2R8c0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Dexuan Cui <decui@microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Liu <wei.liu@kernel.org>, linux-hyperv@vger.kernel.org,
        x86@kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 030/163] random: remove unused irq_flags argument from add_interrupt_randomness()
Date:   Fri, 27 May 2022 10:48:30 +0200
Message-Id: <20220527084832.356162983@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 703f7066f40599c290babdb79dd61319264987e9 upstream.

Since commit
   ee3e00e9e7101 ("random: use registers from interrupted code for CPU's w/o a cycle counter")

the irq_flags argument is no longer used.

Remove unused irq_flags.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: linux-hyperv@vger.kernel.org
Cc: x86@kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mshyperv.c |    2 +-
 drivers/char/random.c          |    4 ++--
 drivers/hv/vmbus_drv.c         |    2 +-
 include/linux/random.h         |    2 +-
 kernel/irq/handle.c            |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -84,7 +84,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_hyperv_sti
 	inc_irq_stat(hyperv_stimer0_count);
 	if (hv_stimer0_handler)
 		hv_stimer0_handler();
-	add_interrupt_randomness(HYPERV_STIMER0_VECTOR, 0);
+	add_interrupt_randomness(HYPERV_STIMER0_VECTOR);
 	ack_APIC_irq();
 
 	set_irq_regs(old_regs);
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -200,7 +200,7 @@
  *	void add_device_randomness(const void *buf, unsigned int size);
  * 	void add_input_randomness(unsigned int type, unsigned int code,
  *                                unsigned int value);
- *	void add_interrupt_randomness(int irq, int irq_flags);
+ *	void add_interrupt_randomness(int irq);
  * 	void add_disk_randomness(struct gendisk *disk);
  *	void add_hwgenerator_randomness(const char *buffer, size_t count,
  *					size_t entropy);
@@ -1273,7 +1273,7 @@ static __u32 get_reg(struct fast_pool *f
 	return *ptr;
 }
 
-void add_interrupt_randomness(int irq, int irq_flags)
+void add_interrupt_randomness(int irq)
 {
 	struct entropy_store	*r;
 	struct fast_pool	*fast_pool = this_cpu_ptr(&irq_randomness);
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1351,7 +1351,7 @@ static void vmbus_isr(void)
 			tasklet_schedule(&hv_cpu->msg_dpc);
 	}
 
-	add_interrupt_randomness(hv_get_vector(), 0);
+	add_interrupt_randomness(hv_get_vector());
 }
 
 /*
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -35,7 +35,7 @@ static inline void add_latent_entropy(vo
 
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value) __latent_entropy;
-extern void add_interrupt_randomness(int irq, int irq_flags) __latent_entropy;
+extern void add_interrupt_randomness(int irq) __latent_entropy;
 
 extern void get_random_bytes(void *buf, int nbytes);
 extern int wait_for_random_bytes(void);
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -195,7 +195,7 @@ irqreturn_t handle_irq_event_percpu(stru
 
 	retval = __handle_irq_event_percpu(desc, &flags);
 
-	add_interrupt_randomness(desc->irq_data.irq, flags);
+	add_interrupt_randomness(desc->irq_data.irq);
 
 	if (!noirqdebug)
 		note_interrupt(desc, retval);


