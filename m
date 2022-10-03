Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381505F299D
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiJCHWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiJCHVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:21:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6254A13F;
        Mon,  3 Oct 2022 00:16:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BFCFB80E78;
        Mon,  3 Oct 2022 07:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F66C433D7;
        Mon,  3 Oct 2022 07:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781381;
        bh=Ah20YAAdjRRhETddEBaRda0TzCdoJ5b74wVSxQ1iYo8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipS9qI915pbQRzU0AhjycwjU/8kb2fRHgGdTB5VveH/Wxe3OiO3sdrAEFsJZQsfvT
         TLSYkhptt3ZegelZ10k0C1LXuCseZCUU4y6rHKIf6GrxQd2OCxyWd876YWfD1JIp3/
         mnScYCrX2J9TArCvm62n871KRoxHmVKFRYK5z1FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>, stable@kernel.org
Subject: [PATCH 5.19 100/101] x86/alternative: Fix race in try_get_desc()
Date:   Mon,  3 Oct 2022 09:11:36 +0200
Message-Id: <20221003070726.915172418@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Nadav Amit <namit@vmware.com>

commit efd608fa7403ba106412b437f873929e2c862e28 upstream.

I encountered some occasional crashes of poke_int3_handler() when
kprobes are set, while accessing desc->vec.

The text poke mechanism claims to have an RCU-like behavior, but it
does not appear that there is any quiescent state to ensure that
nobody holds reference to desc. As a result, the following race
appears to be possible, which can lead to memory corruption.

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

Fix this issue with small backportable patch. Instead of trying to
make RCU-like behavior for bp_desc, just eliminate the unnecessary
level of indirection of bp_desc, and hold the whole descriptor as a
global.  Anyhow, there is only a single descriptor at any given
moment.

Fixes: 1f676247f36a4 ("x86/alternatives: Implement a better poke_int3_handler() completion scheme")
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@kernel.org
Link: https://lkml.kernel.org/r/20220920224743.3089-1-namit@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


