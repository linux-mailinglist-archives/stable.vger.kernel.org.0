Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7BE55830D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233801AbiFWRX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbiFWRXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:23:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E246B647B6;
        Thu, 23 Jun 2022 10:01:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEA19615A5;
        Thu, 23 Jun 2022 17:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC878C3411B;
        Thu, 23 Jun 2022 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003701;
        bh=KQhB+Ayk9PXWPbqAsbee6FxnioeW5+Enw6TCr46ztJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nuH+h6r7MEnVf0RSdzaXTEc+noqMw6AT9BFoXJsKATu8GZiJu7A69SRk74kZ5Faxs
         CyOrOCwZz0e/F9JOVjkmhepdeCNMq3lucW1rhV0SMM90uHSxedxhYyssyEwZGOyQIW
         FTubBRiLqB+uHEenCW2wGPB4R2AOldJ41FMB72bA=
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
Subject: [PATCH 4.14 060/237] random: remove unused irq_flags argument from add_interrupt_randomness()
Date:   Thu, 23 Jun 2022 18:41:34 +0200
Message-Id: <20220623164344.884449137@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/char/random.c  |    4 ++--
 drivers/hv/vmbus_drv.c |    2 +-
 include/linux/random.h |    2 +-
 kernel/irq/handle.c    |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

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
@@ -1271,7 +1271,7 @@ static __u32 get_reg(struct fast_pool *f
 	return *ptr;
 }
 
-void add_interrupt_randomness(int irq, int irq_flags)
+void add_interrupt_randomness(int irq)
 {
 	struct entropy_store	*r;
 	struct fast_pool	*fast_pool = this_cpu_ptr(&irq_randomness);
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1064,7 +1064,7 @@ static void vmbus_isr(void)
 			tasklet_schedule(&hv_cpu->msg_dpc);
 	}
 
-	add_interrupt_randomness(HYPERVISOR_CALLBACK_VECTOR, 0);
+	add_interrupt_randomness(HYPERVISOR_CALLBACK_VECTOR);
 }
 
 
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
@@ -186,7 +186,7 @@ irqreturn_t handle_irq_event_percpu(stru
 
 	retval = __handle_irq_event_percpu(desc, &flags);
 
-	add_interrupt_randomness(desc->irq_data.irq, flags);
+	add_interrupt_randomness(desc->irq_data.irq);
 
 	if (!noirqdebug)
 		note_interrupt(desc, retval);


