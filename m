Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2042358CE40
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 21:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244185AbiHHTD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 15:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244194AbiHHTD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 15:03:58 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8859EDEC5
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 12:03:55 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l9so5373993ilq.1
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 12:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=uPXo6qTNTanbnXMgeNkm7mqY+PRHfhhWTf2LLd9dBGo=;
        b=fL8zWtJ40YYEiU8xUV8fGQXlYZd3COcRaVg8AoK5d2REczY1ibyrGaD5Vvcor+EMt9
         44I37z+Pp95R/DcELT9QzTQbdBwRXwpmcEv1hFLDmk2zBqjUELBV1+hGQ5hmFYkj8EI1
         xN0z/ZpGXa+5RJ7QmJdZJFPk/DHP2IvpU5uwR3Yzvw/sUkDTVVYORVBx7msTWwFJmL7H
         q7b6Z2/mbTvafj/bzJoTHEDH5LayxN40Ai5cXQ/eebVWhPg5gkomYu+RlT7ime4q8TL9
         pCQ4553tCee0+4FSyoilhT6HOCFj4D/qUTiCj0Mtzwhx4y2nLeikyhcCr2WhXz42Rt2Z
         SAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=uPXo6qTNTanbnXMgeNkm7mqY+PRHfhhWTf2LLd9dBGo=;
        b=8DEQnLI+N7fUvX4zbbeee7TflwjcaKK6tQsTZbOSFFAvx0fVuGOEpDXYeRBm0aP8E3
         +uR5WBxUo1pc8i53sn2EHxkTUa6HiWvXO8b2B+mAhW5OjS5BrRhu29g1uS3s/OT8kB7g
         wBu15TcjFDU728o4UjghRneD93ot1nIslS+wmqkglp+02V8vfLiTqspRk4gRo2RSFQdW
         jMFOE0bEd8cDg1qakaji/7VCIVFQQ2GPE5sA0LP6Urrq3vh8Iw3f/gpk9rnL9h4pIp/a
         Qzjqb5eZU5fJc7ylIEvNCvkHbyhNc3UB2WIAmM5FfB7OptF3kg6LZOQfVNcr1H+EGb5D
         hrDw==
X-Gm-Message-State: ACgBeo2NmP6z22Yb8C7BeHiGML7ESYeXxNcxpQiyODzQL1ljENwWBN96
        YIZtcZNZemsedCwzlmDCK6cV1Q==
X-Google-Smtp-Source: AA6agR6t8PAM+RurjIJq/5LqVZMz//Am+umv6GaTspbBDNq23SjeL3YGJU7Mja906481JiJYGKSsfQ==
X-Received: by 2002:a05:6e02:152d:b0:2e0:d364:edcc with SMTP id i13-20020a056e02152d00b002e0d364edccmr4143152ilu.228.1659985435179;
        Mon, 08 Aug 2022 12:03:55 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id q10-20020a02b04a000000b0033f4a1114a6sm5505073jah.178.2022.08.08.12.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 12:03:54 -0700 (PDT)
From:   Coleman Dietsch <dietschc@csp.edu>
To:     dietschc@csp.edu
Cc:     stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Date:   Mon,  8 Aug 2022 14:02:12 -0500
Message-Id: <20220808190211.323827-3-dietschc@csp.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808190211.323827-1-dietschc@csp.edu>
References: <20220808190211.323827-1-dietschc@csp.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/kvm/xen.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 6e554041e862..280cb5dc7341 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -707,26 +707,25 @@ int kvm_xen_vcpu_set_attr(struct kvm_vcpu *vcpu, struct kvm_xen_vcpu_attr *data)
 		break;
 
 	case KVM_XEN_VCPU_ATTR_TYPE_TIMER:
-		if (data->u.timer.port) {
-			if (data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
-				r = -EINVAL;
-				break;
-			}
-			vcpu->arch.xen.timer_virq = data->u.timer.port;
-
-			if (!vcpu->arch.xen.timer.function)
-				kvm_xen_init_timer(vcpu);
-
-			/* Restart the timer if it's set */
-			if (data->u.timer.expires_ns)
-				kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
-						    data->u.timer.expires_ns -
-						    get_kvmclock_ns(vcpu->kvm));
-		} else if (kvm_xen_timer_enabled(vcpu)) {
-			kvm_xen_stop_timer(vcpu);
-			vcpu->arch.xen.timer_virq = 0;
+		if (data->u.timer.port &&
+		    data->u.timer.priority != KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL) {
+			r = -EINVAL;
+			break;
 		}
 
+		if (!vcpu->arch.xen.timer.function)
+			kvm_xen_init_timer(vcpu);
+
+		/* Stop the timer (if it's running) before changing the vector */
+		kvm_xen_stop_timer(vcpu);
+		vcpu->arch.xen.timer_virq = data->u.timer.port;
+
+		/* Start the timer if the new value has a valid vector+expiry. */
+		if (data->u.timer.port && data->u.timer.expires_ns)
+			kvm_xen_start_timer(vcpu, data->u.timer.expires_ns,
+					    data->u.timer.expires_ns -
+					    get_kvmclock_ns(vcpu->kvm));
+
 		r = 0;
 		break;
 
-- 
2.34.1

