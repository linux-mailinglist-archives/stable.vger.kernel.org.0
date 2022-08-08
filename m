Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB3758CE4C
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 21:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244231AbiHHTGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 15:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244223AbiHHTGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 15:06:40 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C743E1F
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 12:06:39 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q124so7888445iod.3
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 12:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csp-edu.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=uPXo6qTNTanbnXMgeNkm7mqY+PRHfhhWTf2LLd9dBGo=;
        b=H4KzTYgNBlxoPeb/e0rP3AvidLHz6PPSSwBXGXIZ9j4s0sGC1E9Ws14T+f2fVVJV7T
         qVq3wawMz+jNDS8J+hLv028q6pFE/4IMimwcbO51WBMmuvZb6UOmYMuCNEMo2/eTgkap
         F95O0mxB1nqPcGsu263N0xzvReL1Kae+kVTjvKCy3uPlY/qdRopwolHK2jyADUs/lpaI
         uNOJhgc8Gg1qqUz5PnaC3T+a3hJjE3OaPUHlguB8vXPF0dCW5hx1E+I/9WvnD8fwuetG
         k2r8Ku1/Rig/oi6d6Fg5GpjXvDacO4EJRpO2+NEgm+3LDYrBdTgbjhb0sSXI11935FmY
         mmag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=uPXo6qTNTanbnXMgeNkm7mqY+PRHfhhWTf2LLd9dBGo=;
        b=2y/CTi8JPADrdwyeYxirIdkILS4OrWpzGFf0wNL5UzN6+PkmMMjA9HtCY3e7zd+pjb
         NedbkTDrWg309ttLcEK6T24P/Yc4spouzpHzkT8Js5Wo17giYIchHFY0eykIuvVXNgnM
         TqJF62dmNwfAKMFxWvjZpvZU0Oo25cY102+PiJOd1bcoBGXZi9EzWlLGzXykKlave2Lt
         T7pqjFi7gQ/PC8i5vdMaJcGP/hL7uGJ+jMwdNP4XZfpCnlQdWDfSdDpezRJPd7NmtxO7
         29aiHLi1Mkcb9LNJjKhrIQb05Fp/dFPdxOLyulfA+RmzKXwltx/XJdDXmZMswDYl8P/A
         y/lw==
X-Gm-Message-State: ACgBeo3KaWf/z9FcZP7kkG9sCR1aOnWXV2qVqek7x2DQAebdxqJfEjCK
        6M3jebfb2+SqoPludYInIOzKqg==
X-Google-Smtp-Source: AA6agR5v8DdlJpjjKMmnyxH00/6twNDvMMlSUi7EF0m/OpuY/fudEGo0kbPzrTu1a05jSdQNAVVc+Q==
X-Received: by 2002:a05:6602:13d5:b0:67c:9149:fe0f with SMTP id o21-20020a05660213d500b0067c9149fe0fmr8404219iov.114.1659985598998;
        Mon, 08 Aug 2022 12:06:38 -0700 (PDT)
Received: from kernel-dev-1 (75-168-113-69.mpls.qwest.net. [75.168.113.69])
        by smtp.gmail.com with ESMTPSA id q7-20020a05663810c700b003428c908a12sm5479715jad.32.2022.08.08.12.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 12:06:38 -0700 (PDT)
From:   Coleman Dietsch <dietschc@csp.edu>
To:     kvm@vger.kernel.org
Cc:     Coleman Dietsch <dietschc@csp.edu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
Subject: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Date:   Mon,  8 Aug 2022 14:06:07 -0500
Message-Id: <20220808190607.323899-3-dietschc@csp.edu>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220808190607.323899-2-dietschc@csp.edu>
References: <20220808190607.323899-2-dietschc@csp.edu>
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

