Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056515BF84A
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 09:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiIUHwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 03:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiIUHwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 03:52:42 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1EE844FD;
        Wed, 21 Sep 2022 00:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=I529aHH/Kq3yZa57wzdor75Vu3gZs2tmTvHaoGyFizY=; b=ne42DcaBo0XJ3Hgf81izdLp1lj
        ezorS+oP9dU71qdzOuZMImiCiH71LsNnyuooL3WqYt9V/rjKeCkJ8rLzHVyv0sibOMzkDgm2T408y
        yvjz41HOv+NrCH80aci7xbeTdP5ED1Gj79db9SNCDXqW6tKoMhsugh8z/AQAx0KBJsezVIzF0pO1X
        JGFb6a70OOqCRVCTZeBRs8MKFs2/6OPz5s+k3hfpwGzmX9UsEVSQwa3vU3/qInoCxHfwcdNFPWW8V
        o3n5ypU0R7WU6TeLiHqAU3VGXpeel0DzZLy3BAOtlG3oyhmSYwnakz3KA52l9Tf1n9yFGccXek8wW
        VrgOlXBg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oauWk-00EYYR-Eb; Wed, 21 Sep 2022 07:52:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 689AD300202;
        Wed, 21 Sep 2022 09:52:12 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 2101720161C88; Wed, 21 Sep 2022 09:52:12 +0200 (CEST)
Date:   Wed, 21 Sep 2022 09:52:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Nadav Amit <namit@vmware.com>, stable@vger.kernel.org,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH] x86/alternative: fix race in try_get_desc()
Message-ID: <YyrCrN6RwibR505Z@hirez.programming.kicks-ass.net>
References: <20220920224743.3089-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920224743.3089-1-namit@vmware.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 20, 2022 at 10:47:43PM +0000, Nadav Amit wrote:

> Fix this issue with small backportable patch. Instead of trying to make
> RCU-like behavior for bp_desc, just eliminate the unnecessary level of
> indirection of bp_desc, and hold the whole descriptor on the stack.
> Anyhow, there is only a single descriptor at any given moment.

Because of text_mutex; indeed. No idea why I put that thing on the
stack.

I've done a few minor edits to your patch, but it otherwise looks good
to me.

---
Subject: x86/alternative: Fix race in try_get_desc()
From: Nadav Amit <namit@vmware.com>
Date: Tue, 20 Sep 2022 22:47:43 +0000

From: Nadav Amit <namit@vmware.com>

The text poke mechanism claims to have an RCU-like behavior, but it does
not appear that there is any quiescent state to ensure that nobody holds
reference to desc. As a result, the following race appears to be
possible, which can lead to memory corruption.

  CPU0					CPU1
  ----					----
  text_poke_bp_batch()
  -> smp_store_release(&bp_desc, &desc)

  [ notice that desc is on
    the stack			]

					poke_int3_handler()

					[ int3 might be kprobe's
					  so sync events are do not
					  help ]

					-> try_get_desc(descp=&bp_desc)
					   desc = __READ_ONCE(bp_desc)

					   if (!desc) [false, success]
  WRITE_ONCE(bp_desc, NULL);
  atomic_dec_and_test(&desc.refs)

  [ success, desc space on the stack
    is being reused and might have
    non-zero value. ]
					arch_atomic_inc_not_zero(&desc->refs)

					[ might succeed since desc points to
					  stack memory that was freed and might
					  be reused. ]

I encountered some occasional crashes of poke_int3_handler() when
kprobes are set, while accessing desc->vec. The analysis has been done
offline and I did not corroborate the cause of the crashes. Yet, it
seems that this race might be the root cause.

Fix this issue with small backportable patch. Instead of trying to make
RCU-like behavior for bp_desc, just eliminate the unnecessary level of
indirection of bp_desc, and hold the whole descriptor on the stack.
Anyhow, there is only a single descriptor at any given moment.

Fixes: 1f676247f36a4 ("x86/alternatives: Implement a better poke_int3_handler() completion scheme")
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Link: https://lkml.kernel.org/r/20220920224743.3089-1-namit@vmware.com
---
 arch/x86/kernel/alternative.c |   45 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1319,22 +1319,23 @@ struct bp_patching_desc {
 	atomic_t refs;
 };
 
-static struct bp_patching_desc *bp_desc;
+static struct bp_patching_desc bp_desc;
 
 static __always_inline
-struct bp_patching_desc *try_get_desc(struct bp_patching_desc **descp)
+struct bp_patching_desc *try_get_desc(void)
 {
-	/* rcu_dereference */
-	struct bp_patching_desc *desc = __READ_ONCE(*descp);
+	struct bp_patching_desc *desc = &bp_desc;
 
-	if (!desc || !arch_atomic_inc_not_zero(&desc->refs))
+	if (!arch_atomic_inc_not_zero(&desc->refs))
 		return NULL;
 
 	return desc;
 }
 
-static __always_inline void put_desc(struct bp_patching_desc *desc)
+static __always_inline void put_desc(void)
 {
+	struct bp_patching_desc *desc = &bp_desc;
+
 	smp_mb__before_atomic();
 	arch_atomic_dec(&desc->refs);
 }
@@ -1367,15 +1368,15 @@ noinstr int poke_int3_handler(struct pt_
 
 	/*
 	 * Having observed our INT3 instruction, we now must observe
-	 * bp_desc:
+	 * bp_desc with non-zero refcount:
 	 *
-	 *	bp_desc = desc			INT3
+	 *	bp_desc.refs = 1		INT3
 	 *	WMB				RMB
-	 *	write INT3			if (desc)
+	 *	write INT3			if (bp_desc.refs != 0)
 	 */
 	smp_rmb();
 
-	desc = try_get_desc(&bp_desc);
+	desc = try_get_desc();
 	if (!desc)
 		return 0;
 
@@ -1429,7 +1430,7 @@ noinstr int poke_int3_handler(struct pt_
 	ret = 1;
 
 out_put:
-	put_desc(desc);
+	put_desc();
 	return ret;
 }
 
@@ -1460,18 +1461,20 @@ static int tp_vec_nr;
  */
 static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries)
 {
-	struct bp_patching_desc desc = {
-		.vec = tp,
-		.nr_entries = nr_entries,
-		.refs = ATOMIC_INIT(1),
-	};
 	unsigned char int3 = INT3_INSN_OPCODE;
 	unsigned int i;
 	int do_sync;
 
 	lockdep_assert_held(&text_mutex);
 
-	smp_store_release(&bp_desc, &desc); /* rcu_assign_pointer */
+	bp_desc.vec = tp;
+	bp_desc.nr_entries = nr_entries;
+
+	/*
+	 * Corresponds to the implicit memory barrier in try_get_desc() to
+	 * ensure reading a non-zero refcount provides up to date bp_desc data.
+	 */
+	atomic_set_release(&bp_desc.refs, 1);
 
 	/*
 	 * Corresponding read barrier in int3 notifier for making sure the
@@ -1559,12 +1562,10 @@ static void text_poke_bp_batch(struct te
 		text_poke_sync();
 
 	/*
-	 * Remove and synchronize_rcu(), except we have a very primitive
-	 * refcount based completion.
+	 * Remove and wait for refs to be zero.
 	 */
-	WRITE_ONCE(bp_desc, NULL); /* RCU_INIT_POINTER */
-	if (!atomic_dec_and_test(&desc.refs))
-		atomic_cond_read_acquire(&desc.refs, !VAL);
+	if (!atomic_dec_and_test(&bp_desc.refs))
+		atomic_cond_read_acquire(&bp_desc.refs, !VAL);
 }
 
 static void text_poke_loc_init(struct text_poke_loc *tp, void *addr,
