Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 453CC53CFBB
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345772AbiFCR4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345991AbiFCRzd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:55:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A094C544DD;
        Fri,  3 Jun 2022 10:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37037B8241D;
        Fri,  3 Jun 2022 17:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF26C385A9;
        Fri,  3 Jun 2022 17:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278789;
        bh=27qRdN9GYw3QvnqkwODMdfeM7nT6M1uBHq5TeeLhpEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1izVUyi7WTSDqGYIMa/jFlAXyb6yVcCpaKg3xG75ADQAPBXqmeu0Xetoq4vzobDji
         HfzrPCrXgq77vNGKy9MOkvM4tQekGK3m3SX1CwKTKlytwelE8xTbFZ2MluuDV0e1ak
         oi5rv/ub9vhrK98GHWLEHqYtsuMUA/gIsZhl713A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 28/75] x86/kvm: Alloc dummy async #PF token outside of raw spinlock
Date:   Fri,  3 Jun 2022 19:43:12 +0200
Message-Id: <20220603173822.547360069@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit 0547758a6de3cc71a0cfdd031a3621a30db6a68b upstream.

Drop the raw spinlock in kvm_async_pf_task_wake() before allocating the
the dummy async #PF token, the allocator is preemptible on PREEMPT_RT
kernels and must not be called from truly atomic contexts.

Opportunistically document why it's ok to loop on allocation failure,
i.e. why the function won't get stuck in an infinite loop.

Reported-by: Yajun Deng <yajun.deng@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvm.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -191,7 +191,7 @@ void kvm_async_pf_task_wake(u32 token)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
-	struct kvm_task_sleep_node *n;
+	struct kvm_task_sleep_node *n, *dummy = NULL;
 
 	if (token == ~0) {
 		apf_task_wake_all();
@@ -203,28 +203,41 @@ again:
 	n = _find_apf_task(b, token);
 	if (!n) {
 		/*
-		 * async PF was not yet handled.
-		 * Add dummy entry for the token.
+		 * Async #PF not yet handled, add a dummy entry for the token.
+		 * Allocating the token must be down outside of the raw lock
+		 * as the allocator is preemptible on PREEMPT_RT kernels.
 		 */
-		n = kzalloc(sizeof(*n), GFP_ATOMIC);
-		if (!n) {
+		if (!dummy) {
+			raw_spin_unlock(&b->lock);
+			dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
+
 			/*
-			 * Allocation failed! Busy wait while other cpu
-			 * handles async PF.
+			 * Continue looping on allocation failure, eventually
+			 * the async #PF will be handled and allocating a new
+			 * node will be unnecessary.
+			 */
+			if (!dummy)
+				cpu_relax();
+
+			/*
+			 * Recheck for async #PF completion before enqueueing
+			 * the dummy token to avoid duplicate list entries.
 			 */
-			raw_spin_unlock(&b->lock);
-			cpu_relax();
 			goto again;
 		}
-		n->token = token;
-		n->cpu = smp_processor_id();
-		init_swait_queue_head(&n->wq);
-		hlist_add_head(&n->link, &b->list);
+		dummy->token = token;
+		dummy->cpu = smp_processor_id();
+		init_swait_queue_head(&dummy->wq);
+		hlist_add_head(&dummy->link, &b->list);
+		dummy = NULL;
 	} else {
 		apf_task_wake_one(n);
 	}
 	raw_spin_unlock(&b->lock);
-	return;
+
+	/* A dummy token might be allocated and ultimately not used.  */
+	if (dummy)
+		kfree(dummy);
 }
 EXPORT_SYMBOL_GPL(kvm_async_pf_task_wake);
 


