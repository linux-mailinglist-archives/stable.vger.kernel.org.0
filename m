Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA82458DDA6
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 20:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344431AbiHISDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 14:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344413AbiHISC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 14:02:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F972654A;
        Tue,  9 Aug 2022 11:01:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12FE9B8171A;
        Tue,  9 Aug 2022 18:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61326C433C1;
        Tue,  9 Aug 2022 18:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660068096;
        bh=0DOI+tH+obLM/ah1ir/rAmzRsoGfunCYQfDTahRUfW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tE4Gv26oIjjRTcrIZg1nIpO9oCJ0LV0mcVJu0UFGEF7znvFrH65KIGZWDDDcQqccw
         FJ5mFOFupiV13XEpMOHQAbaYUzj7aD8WnC05FBefGQSrGrDtm3gMeQbW2X19Rf3pS9
         pfFfRNtxivmV9vKWPGXMdqIU2XWeDOCpaW2lt9Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Juergen Christ <jchrist@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [PATCH 4.19 03/32] s390/archrandom: prevent CPACF trng invocations in interrupt context
Date:   Tue,  9 Aug 2022 19:59:54 +0200
Message-Id: <20220809175513.196899624@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809175513.082573955@linuxfoundation.org>
References: <20220809175513.082573955@linuxfoundation.org>
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

From: Harald Freudenberger <freude@linux.ibm.com>

commit 918e75f77af7d2e049bb70469ec0a2c12782d96a upstream.

This patch slightly reworks the s390 arch_get_random_seed_{int,long}
implementation: Make sure the CPACF trng instruction is never
called in any interrupt context. This is done by adding an
additional condition in_task().

Justification:

There are some constrains to satisfy for the invocation of the
arch_get_random_seed_{int,long}() functions:
- They should provide good random data during kernel initialization.
- They should not be called in interrupt context as the TRNG
  instruction is relatively heavy weight and may for example
  make some network loads cause to timeout and buck.

However, it was not clear what kind of interrupt context is exactly
encountered during kernel init or network traffic eventually calling
arch_get_random_seed_long().

After some days of investigations it is clear that the s390
start_kernel function is not running in any interrupt context and
so the trng is called:

Jul 11 18:33:39 t35lp54 kernel:  [<00000001064e90ca>] arch_get_random_seed_long.part.0+0x32/0x70
Jul 11 18:33:39 t35lp54 kernel:  [<000000010715f246>] random_init+0xf6/0x238
Jul 11 18:33:39 t35lp54 kernel:  [<000000010712545c>] start_kernel+0x4a4/0x628
Jul 11 18:33:39 t35lp54 kernel:  [<000000010590402a>] startup_continue+0x2a/0x40

The condition in_task() is true and the CPACF trng provides random data
during kernel startup.

The network traffic however, is more difficult. A typical call stack
looks like this:

Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5600fc>] extract_entropy.constprop.0+0x23c/0x240
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b560136>] crng_reseed+0x36/0xd8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5604b8>] crng_make_state+0x78/0x340
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b5607e0>] _get_random_bytes+0x60/0xf8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b56108a>] get_random_u32+0xda/0x248
Jul 06 17:37:07 t35lp54 kernel:  [<000000008aefe7a8>] kfence_guarded_alloc+0x48/0x4b8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008aeff35e>] __kfence_alloc+0x18e/0x1b8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008aef7f10>] __kmalloc_node_track_caller+0x368/0x4d8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611eac>] kmalloc_reserve+0x44/0xa0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b611f98>] __alloc_skb+0x90/0x178
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b6120dc>] __napi_alloc_skb+0x5c/0x118
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f06b4>] qeth_extract_skb+0x13c/0x680
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b8f6526>] qeth_poll+0x256/0x3f8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63d76e>] __napi_poll.constprop.0+0x46/0x2f8
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b63dbec>] net_rx_action+0x1cc/0x408
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b937302>] __do_softirq+0x132/0x6b0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf46ce>] __irq_exit_rcu+0x13e/0x170
Jul 06 17:37:07 t35lp54 kernel:  [<000000008abf531a>] irq_exit_rcu+0x22/0x50
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b922506>] do_io_irq+0xe6/0x198
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935826>] io_int_handler+0xd6/0x110
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b9358a6>] psw_idle_exit+0x0/0xa
Jul 06 17:37:07 t35lp54 kernel: ([<000000008ab9c59a>] arch_cpu_idle+0x52/0xe0)
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b933cfe>] default_idle_call+0x6e/0xd0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac59f4e>] do_idle+0xf6/0x1b0
Jul 06 17:37:07 t35lp54 kernel:  [<000000008ac5a28e>] cpu_startup_entry+0x36/0x40
Jul 06 17:37:07 t35lp54 kernel:  [<000000008abb0d90>] smp_start_secondary+0x148/0x158
Jul 06 17:37:07 t35lp54 kernel:  [<000000008b935b9e>] restart_int_handler+0x6e/0x90

which confirms that the call is in softirq context. So in_task() covers exactly
the cases where we want to have CPACF trng called: not in nmi, not in hard irq,
not in soft irq but in normal task context and during kernel init.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Juergen Christ <jchrist@linux.ibm.com>
Link: https://lore.kernel.org/r/20220713131721.257907-1-freude@linux.ibm.com
Fixes: e4f74400308c ("s390/archrandom: simplify back to earlier design and initialize earlier")
[agordeev@linux.ibm.com changed desc, added Fixes and Link, removed -stable]
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/archrandom.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/s390/include/asm/archrandom.h
+++ b/arch/s390/include/asm/archrandom.h
@@ -2,7 +2,7 @@
 /*
  * Kernel interface for the s390 arch_random_* functions
  *
- * Copyright IBM Corp. 2017, 2020
+ * Copyright IBM Corp. 2017, 2022
  *
  * Author: Harald Freudenberger <freude@de.ibm.com>
  *
@@ -14,6 +14,7 @@
 #ifdef CONFIG_ARCH_RANDOM
 
 #include <linux/static_key.h>
+#include <linux/preempt.h>
 #include <linux/atomic.h>
 #include <asm/cpacf.h>
 
@@ -32,7 +33,8 @@ static inline bool __must_check arch_get
 
 static inline bool __must_check arch_get_random_seed_long(unsigned long *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;
@@ -42,7 +44,8 @@ static inline bool __must_check arch_get
 
 static inline bool __must_check arch_get_random_seed_int(unsigned int *v)
 {
-	if (static_branch_likely(&s390_arch_random_available)) {
+	if (static_branch_likely(&s390_arch_random_available) &&
+	    in_task()) {
 		cpacf_trng(NULL, 0, (u8 *)v, sizeof(*v));
 		atomic64_add(sizeof(*v), &s390_arch_random_counter);
 		return true;


