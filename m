Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C57135D8AB
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 09:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238410AbhDMHRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 03:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbhDMHRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 03:17:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A62C061574;
        Tue, 13 Apr 2021 00:17:03 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d8so7707747plh.11;
        Tue, 13 Apr 2021 00:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qBn3NeoemY9J5Bkb/rnTcONzq25KY3gcneMyVMKWJh4=;
        b=N6UMgf8jU+Ph1yHrv45fN2UQmjBSexJWoxDczpBiSXMn3vW8WiXgpxdbhONQdgvDuc
         5AD4k+AIC3ZXKMGEdVogNSBv3J+NvTT1e0eiuJ7Vch0MytAFVjhRKrJKKIA8eaJWhA3Z
         OiN63URh3CJ541DhIXcwfA6eBoTEYqWFTP3haYCZX+VIMLODulSv5ZMMn0SnQK427UU/
         yvLbMTDweMgUY8Adt4oW6BwLT7kbRDbOgG/a2Q0Rx9/ILBIq9IWU1N2BCuPs7Wbn93Ox
         SDIfHxtIeVbzsSArXBfEuhV9zPJ24Lzy+AhhN6wd7ek0Vy5Jm57s1Uv2gD5DYeUKTy/E
         MyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qBn3NeoemY9J5Bkb/rnTcONzq25KY3gcneMyVMKWJh4=;
        b=V+qCHvOlSCG/MvOCUvtq0jlfT+8jVaSr/q73CUrarQMD5NxIlVeUNUbW/SZlKnAFEV
         oxbf/rzGYR1o1Jqj2bFs2lVKTm05ulLrNOUTKZcwkWPbUI1Mgi1rmThKs3kaCZYet/Jc
         arshLOd7LCFqk5s0VVQeqAVhOsbFYhMzLaUI+JFFzCahgMAu5NxJqnJR04pKUzFAhndS
         yINKYeMV+P/dPAfAHTcTeu8/AFPvm46kgovewIEg9L/2r4KY5Cy+hjF/Go3RTh94vnPL
         VtbDIRf747iBqjoOORggDuhNe88Iw7AxdlB4U+B5ILVMLv3xipfonj7YY+wAh1TasQkE
         DszA==
X-Gm-Message-State: AOAM533ymMG0dfsV7EYW9DlXiu5ZP9gMjGtB7zbK4xBJE2acfvTl76DA
        eKuzcDX71PuteKL/n+yu4rXVCErINx8=
X-Google-Smtp-Source: ABdhPJxhm0Sy6QK/KoC4cBVp3b45mZd0Y4H+Bx3swufVvcFqxy55E8mXgubHsHQU5bxVVc9qoXY2JA==
X-Received: by 2002:a17:902:ab86:b029:e9:47c1:93de with SMTP id f6-20020a170902ab86b02900e947c193demr30787184plr.69.1618298222449;
        Tue, 13 Apr 2021 00:17:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id i10sm2031088pjm.1.2021.04.13.00.16.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Apr 2021 00:17:01 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>, stable@vger.kernel.org
Subject: [PATCH v2 3/3] x86/kvm: Fix vtime accounting
Date:   Tue, 13 Apr 2021 15:16:09 +0800
Message-Id: <1618298169-3831-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The bugzilla https://bugzilla.kernel.org/show_bug.cgi?id=209831
reported that the guest time remains 0 when running a while true
loop in the guest.

The commit 87fa7f3e98a131 ("x86/kvm: Move context tracking where it
belongs") moves guest_exit_irqoff() close to vmexit breaks the
tick-based time accouting when the ticks that happen after IRQs are
disabled are incorrectly accounted to the host/system time. This is
because we exit the guest state too early.

Keep context tracking around the actual vmentry/exit code, the time 
accounting logic is separated out by preposed patch from 
guest_enter/exit_irqoff(). Keep vtime-based time accounting around 
the actual vmentry/exit code when vtime_accounting_enabled_this_cpu() 
is true, leave PF_VCPU clearing after handle_exit_irqoff() and explicit 
IRQ window for tick-based time accouting.

Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>
Cc: stable@vger.kernel.org#v5.9-rc1+
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/svm/svm.c | 6 ++++--
 arch/x86/kvm/vmx/vmx.c | 6 ++++--
 arch/x86/kvm/x86.c     | 1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 48b396f3..2a4e284 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3726,11 +3726,12 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	 * accordingly.
 	 */
 	instrumentation_begin();
+	vtime_account_guest_enter();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	instrumentation_end();
 
-	guest_enter_irqoff();
+	context_guest_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 
 	if (sev_es_guest(vcpu->kvm)) {
@@ -3758,10 +3759,11 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_guest_exit_irqoff();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
+	__vtime_account_guest_exit();
 	instrumentation_end();
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c05e6e2..23be956 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6613,11 +6613,12 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * accordingly.
 	 */
 	instrumentation_begin();
+	vtime_account_guest_enter();
 	trace_hardirqs_on_prepare();
 	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	instrumentation_end();
 
-	guest_enter_irqoff();
+	context_guest_enter_irqoff();
 	lockdep_hardirqs_on(CALLER_ADDR0);
 
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
@@ -6647,10 +6648,11 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_guest_exit_irqoff();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
+	__vtime_account_guest_exit();
 	instrumentation_end();
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce9a1d2..0d2dd3f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9245,6 +9245,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	++vcpu->stat.exits;
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
+	vcpu_account_guest_exit();
 
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
-- 
2.7.4

