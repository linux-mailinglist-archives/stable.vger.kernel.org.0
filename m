Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19750594462
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbiHOV5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349880AbiHOVzR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:55:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F79D61B1C;
        Mon, 15 Aug 2022 12:33:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A442A60EF0;
        Mon, 15 Aug 2022 19:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900C4C433C1;
        Mon, 15 Aug 2022 19:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592021;
        bh=Q2dgt9Sdu7oI8QD/EPZKBrUp1mnjKjtEBYvU2xvNhAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5njc038uZx9BrfTWLELMDp0cSQdetU/5SehvaRauwvJC1m+z7ZHZGGqxJyDxhWFf
         PChtFRxpocIul5qjTy2TdBj3LLsDl50xZr8n9Ia7qMuKG0uq9DxnsM1cx0UJKsoLBI
         HG4IBp9SFvTIgSX/AlOieX9+r6GTcFNWgZR8dZSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com,
        Coleman Dietsch <dietschc@csp.edu>,
        Sean Christopherson <seanjc@google.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0045/1157] KVM: x86/xen: Stop Xen timer before changing IRQ
Date:   Mon, 15 Aug 2022 19:50:01 +0200
Message-Id: <20220815180441.248083880@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coleman Dietsch <dietschc@csp.edu>

commit c036899136355758dcd88878145036ab4d9c1f26 upstream.

Stop Xen timer (if it's running) prior to changing the IRQ vector and
potentially (re)starting the timer. Changing the IRQ vector while the
timer is still running can result in KVM injecting a garbage event, e.g.
vm_xen_inject_timer_irqs() could see a non-zero xen.timer_pending from
a previous timer but inject the new xen.timer_virq.

Fixes: 536395260582 ("KVM: x86/xen: handle PV timers oneshot mode")
Cc: stable@vger.kernel.org
Link: https://syzkaller.appspot.com/bug?id=8234a9dfd3aafbf092cc5a7cd9842e3ebc45fc42
Reported-by: syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Signed-off-by: Coleman Dietsch <dietschc@csp.edu>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Acked-by: David Woodhouse <dwmw@amazon.co.uk>
Message-Id: <20220808190607.323899-3-dietschc@csp.edu>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/xen.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -707,25 +707,24 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcp
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
-		if (data->u.timer.port) {
-			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
-				r = -EINVAL;
-				break;
-			}
-			vcpu->arch.xen.timer_virq = data->u.timer.port;
+		if (data->u.timer.port &&
+		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
+			r = -EINVAL;
+			break;
+		}
 
-			if (!vcpu->arch.xen.timer.function)
-				kvm_xen_init_timer(vcpu);
+		if (!vcpu->arch.xen.timer.function)
+			kvm_xen_init_timer(vcpu);
 
-			/* Restart the timer if it's set */
-			if (data->u.timer.expires_ns)
-				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
-						    data->u.timer.expires_ns -
-						    get_kvmclock_ns(vcpu->kvm));
-		} else if (kvm_xen_timer_enabled(vcpu)) {
-			kvm_xen_stop_timer(vcpu);
-			vcpu->arch.xen.timer_virq = 0;
-		}
+		/* Stop the timer (if it's running) before changing the vector */
+		kvm_xen_stop_timer(vcpu);
+		vcpu->arch.xen.timer_virq = data->u.timer.port;
+
+		/* Start the timer if the new value has a valid vector+expiry. */
+		if (data->u.timer.port && data->u.timer.expires_ns)
+			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
+					    data->u.timer.expires_ns -
+					    get_kvmclock_ns(vcpu->kvm));
 
 		r = 0;
 		break;


