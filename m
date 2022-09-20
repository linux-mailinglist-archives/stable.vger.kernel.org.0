Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80315BF075
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 00:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiITWpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Sep 2022 18:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiITWpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Sep 2022 18:45:22 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0334B0D1;
        Tue, 20 Sep 2022 15:45:21 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id w10so2981571pll.11;
        Tue, 20 Sep 2022 15:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Tg/AVsJjM4BQaOAFmZtyZph+a2NDWNsSd26JaLIUV6s=;
        b=e+4xFQ9VtKkeKiUV5Fi9LQ9G/FHPIrfhsYjxaPDm+oIF/Xqfgz9O+4MbKtLPACrM9Y
         OxCaEOr6niAug6lequ5LrYPKGmQamg/Aus2zwQZi5OTovUuFx6dh0bAlBPhdCQcb/ZEL
         MnlkhVMIwUomhL3+hzrn/HztgT3u4E0C2GDZu6tYTaIztFh4QdSFuHuViFe0aUjVxMLQ
         hJEG7oY2ODslxL4BgqEU3hKyS9kUwluN8eNmPx9lSg08Ql1A5hItuXw9mLLDg93wNoDM
         /qSx744zd13nUtEvbLXHjW880Ql7XItu/s8vhECuVMBLv0RHqvT+Nln7wDR/3Sam7hhC
         ikLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Tg/AVsJjM4BQaOAFmZtyZph+a2NDWNsSd26JaLIUV6s=;
        b=Dz3lgQ9cyZw286evrLtC+86H5FL0F9bJOKMPl5PwusUR4gsfrFn1JDC/irCGDnyYxO
         NATFklT9TCfgQ2PXSVwsIewvk8pcs5KCB8uIxt6BHAIYHf/nn04CTq6jS1J/NiqOBiNE
         OUOvzSmM7joT+S1dq2m05THHA64xfMYqtaol3j2RFUVNJ/lS4kpPaI3DUWvxCESp9BAq
         UojFbprbdS1gaFA4CPbwgRhZTiL8sGGZNBMkUWm41LDic3AUXngVdBy00C0ll5/6UfmV
         zD8Jv9Nb9Q4YncOXe6VdnZOfbuwJEkKVttCSYHSOtP2lqWxZoM4uWkn9M/PtPDJYmXcz
         hv3Q==
X-Gm-Message-State: ACrzQf3WA3zpB7rb3rQG+yDrZedglcvS+K/5aNhrQi9NP9zl0cO4VUuC
        bNMlGo4XV+bQU9i+El6FtWY=
X-Google-Smtp-Source: AMsMyM7fR5I5ve7AWHImzEFiONuAaGuVByDjdwbsuFF4kdNBwZK3R6DUduGawxzvpQtnPp4c6/O3Pg==
X-Received: by 2002:a17:902:f7d2:b0:176:ca6b:eadb with SMTP id h18-20020a170902f7d200b00176ca6beadbmr1775618plw.173.1663713920646;
        Tue, 20 Sep 2022 15:45:20 -0700 (PDT)
Received: from sc2-hs2-b1628.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id w3-20020aa79543000000b0052e6c058bccsm449613pfq.61.2022.09.20.15.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 15:45:20 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Nadav Amit <namit@vmware.com>, stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH] x86/alternative: fix race in try_get_desc()
Date:   Tue, 20 Sep 2022 22:47:43 +0000
Message-Id: <20220920224743.3089-1-namit@vmware.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 1f676247f36a4 ("x86/alternatives: Implement a better poke_int3_handler() completion scheme"
Cc: stable@vger.kernel.org
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 arch/x86/kernel/alternative.c | 42 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 62f6b8b7c4a5..4265c9426374 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1319,18 +1319,15 @@ struct bp_patching_desc {
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
-
-	if (!desc || !arch_atomic_inc_not_zero(&desc->refs))
+	if (!arch_atomic_inc_not_zero(&bp_desc.refs))
 		return NULL;
 
-	return desc;
+	return &bp_desc;
 }
 
 static __always_inline void put_desc(struct bp_patching_desc *desc)
@@ -1367,15 +1364,15 @@ noinstr int poke_int3_handler(struct pt_regs *regs)
 
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
 
@@ -1460,18 +1457,21 @@ static int tp_vec_nr;
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
+	smp_wmb();
+	atomic_set(&bp_desc.refs, 1);
 
 	/*
 	 * Corresponding read barrier in int3 notifier for making sure the
@@ -1559,12 +1559,10 @@ static void text_poke_bp_batch(struct text_poke_loc *tp, unsigned int nr_entries
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
-- 
2.34.1

