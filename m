Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18959532C50
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 16:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiEXOec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 10:34:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbiEXOea (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 10:34:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69B5D6B7D2
        for <stable@vger.kernel.org>; Tue, 24 May 2022 07:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653402868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IATTeiwvknjib2mrV8AsShseYTokKOCsuZyH3XiozGg=;
        b=DBUJ9oJ26+/FUdoNmc+ifahWN/422WpXCUjLMzl84EgzqPB7V2wpyWS1xFAe+X63KS6fbN
        rX5+Rdvlyo6I8jZeCqxItNxaSXQVxVLRyCgymEpANg2MkBAL+R2nalaRLgrWV5TbTrvJ0g
        4O5Zoba497L93x/dwZp+7TUzov41Qto=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-NrBM45JvN8msUeNP_0rhTg-1; Tue, 24 May 2022 10:34:25 -0400
X-MC-Unique: NrBM45JvN8msUeNP_0rhTg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96EA63C10236;
        Tue, 24 May 2022 14:34:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 723F82026D07;
        Tue, 24 May 2022 14:34:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] x86, kvm: use correct GFP flags for preemption disabled
Date:   Tue, 24 May 2022 10:34:24 -0400
Message-Id: <20220524143424.6790-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 35b3c5836703..1a3658f7e6d9 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -209,7 +209,7 @@ void kvm_async_pf_task_wake(u32 token)
 		 */
 		if (!dummy) {
 			raw_spin_unlock(&b->lock);
-			dummy = kzalloc(sizeof(*dummy), GFP_KERNEL);
+			dummy = kzalloc(sizeof(*dummy), GFP_ATOMIC);
 
 			/*
 			 * Continue looping on allocation failure, eventually
-- 
2.31.1

