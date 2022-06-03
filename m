Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D13953D049
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346275AbiFCSCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346462AbiFCSAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9787058E62;
        Fri,  3 Jun 2022 10:56:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37ADDB82369;
        Fri,  3 Jun 2022 17:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904DFC3411D;
        Fri,  3 Jun 2022 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278988;
        bh=27qRdN9GYw3QvnqkwODMdfeM7nT6M1uBHq5TeeLhpEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hyF6EdNmW3C8Y1keFd14Q/lX747yyvcKwmvDlyo1bpjBnBcWlIDTZKbXIk5sFttTL
         dVN7XpX1T5C30/zqSF7Tk6QasXQfqEBKmoj/9FrcDtjzpwVn0dt3HgEcQ/TfH3vMcg
         GYq8itlex3FxjpprseKHcq6sB6Kbp/mnjp70LZGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 17/67] x86/kvm: Alloc dummy async #PF token outside of raw spinlock
Date:   Fri,  3 Jun 2022 19:43:18 +0200
Message-Id: <20220603173821.226881426@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
References: <20220603173820.731531504@linuxfoundation.org>
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
 


