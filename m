Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E1F53D038
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 20:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346375AbiFCSBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 14:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346478AbiFCSAV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 14:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677A658E65;
        Fri,  3 Jun 2022 10:56:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 182FBB82419;
        Fri,  3 Jun 2022 17:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80237C385A9;
        Fri,  3 Jun 2022 17:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278990;
        bh=+eAbAqVQE5DVCKFhG3e268Ipd7JndauGDdwdIiUaX2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nPamqwUuNS9UOIalxowFi83gBfQxE+VLDSXkLvmo38Fu0QDldtbKtkVxQ59PkS73m
         T7tElu/KpD5LyHAD2777pWFbMG22O0cLlTFds+Ua/YyNcuwFufV2yAZecY/gQUsnGz
         VcP6YQGs2XFMUX9vNhr2eZ9EFlDnqVnwAZ36VXgQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.18 18/67] x86, kvm: use correct GFP flags for preemption disabled
Date:   Fri,  3 Jun 2022 19:43:19 +0200
Message-Id: <20220603173821.254695331@linuxfoundation.org>
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit baec4f5a018fe2d708fc1022330dba04b38b5fe3 upstream.

Commit ddd7ed842627 ("x86/kvm: Alloc dummy async #PF token outside of
raw spinlock") leads to the following Smatch static checker warning:

	arch/x86/kernel/kvm.c:212 kvm_async_pf_task_wake()
	warn: sleeping in atomic context

arch/x86/kernel/kvm.c
    202         raw_spin_lock(&b->lock);
    203         n = _find_apf_task(b, token);
    204         if (!n) {
    205                 /*
    206                  * Async #PF not yet handled, add a dummy entry for the token.
    207                  * Allocating the token must be down outside of the raw lock
    208                  * as the allocator is preemptible on PREEMPT_RT kernels.
    209                  */
    210                 if (!dummy) {
    211                         raw_spin_unlock(&b->lock);
--> 212                         dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
                                                                ^^^^^^^^^^
Smatch thinks the caller has preempt disabled.  The `smdb.py preempt
kvm_async_pf_task_wake` output call tree is:

sysvec_kvm_asyncpf_interrupt() <- disables preempt
-> __sysvec_kvm_asyncpf_interrupt()
   -> kvm_async_pf_task_wake()

The caller is this:

arch/x86/kernel/kvm.c
   290        DEFINE_IDTENTRY_SYSVEC(sysvec_kvm_asyncpf_interrupt)
   291        {
   292                struct pt_regs *old_regs = set_irq_regs(regs);
   293                u32 token;
   294
   295                ack_APIC_irq();
   296
   297                inc_irq_stat(irq_hv_callback_count);
   298
   299                if (__this_cpu_read(apf_reason.enabled)) {
   300                        token = __this_cpu_read(apf_reason.token);
   301                        kvm_async_pf_task_wake(token);
   302                        __this_cpu_write(apf_reason.token, 0);
   303                        wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
   304                }
   305
   306                set_irq_regs(old_regs);
   307        }

The DEFINE_IDTENTRY_SYSVEC() is a wrapper that calls this function
from the call_on_irqstack_cond().  It's inside the call_on_irqstack_cond()
where preempt is disabled (unless it's already disabled).  The
irq_enter/exit_rcu() functions disable/enable preempt.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -209,7 +209,7 @@ again:
 		 */
 		if (!dummy) {
 			raw_spin_unlock(&b->lock);
-			dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
+			dummy = kzalloc(sizeof(*dummy), GFP_ATOMIC);
 
 			/*
 			 * Continue looping on allocation failure, eventually


