Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9101F3D9942
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhG1XIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG1XIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 19:08:31 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D0BC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:08:28 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t3so2500622plg.9
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PK3KGe/b0JiwOuG3baDGQG3ZW3CXH43QMgAUQpLPOng=;
        b=cTw0IAXemTeOnFWZbjZ55izyKOMkyY8h3y1qyuBghLntsBovog36KUvq26astDbn0F
         dEWbND/eN0cPD8M3y7gDbZPdnZeNZgRo5xwXKWQPcyjS10rv89Q+yT39Mr+u7XYQ/Wcg
         dpG0JsmOo7dRLJIWZkzkxiKvO4DpJZW7ZZFnM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PK3KGe/b0JiwOuG3baDGQG3ZW3CXH43QMgAUQpLPOng=;
        b=aoyrMpvGvPxe+PVMd3Vl6/UjMJCTj6JJSVmeu2xJS+tG91AXM1konutFF+Plp8YbUc
         xPK410hIavMbhyQQFLayMlAqIvMI7qUNkwe8/evGAGGrL2IYoB2p0/5ZatFduMqJh+u3
         Ct2GoEz51L+1RzAjO9kNIRbOGhELx0RfZgMfklknnthxTk1TWkZVqtvqRo8szmLICxdL
         RtGsPZbVEazwfpuTxp7ojd7zY1QwOBKB1/o6xO77aUNW9UPuwPzXGPcg4cyZ5kV4RpGJ
         HSgvXU2LCU5S55/f99mARbk+rX9igs/rp06cgHfiDaC5kP29ohgxKZfKKtgND1q/fYLy
         c0nA==
X-Gm-Message-State: AOAM530XsXQ6KG0gDTk003yNyCoJFWyt/vDTHl5kqhWOoeLT+Xlm7wkA
        d5Mt1UOLDkuW61NzVTkUAGdH5xh8zECYtg==
X-Google-Smtp-Source: ABdhPJzFrqTyYyn8nJlbjH1rxFfw6rAC3k2lK57ym6cFG+bUq4MQnPqIKbS7061X5p66iixeB272/w==
X-Received: by 2002:a63:117:: with SMTP id 23mr1142521pgb.63.1627513708327;
        Wed, 28 Jul 2021 16:08:28 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:c9bb:c781:1aae:7a70])
        by smtp.googlemail.com with ESMTPSA id a13sm1040689pgt.58.2021.07.28.16.08.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:08:27 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com, pbonzini@redhat.com
Subject: [linux-4.19.y] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Wed, 28 Jul 2021 16:08:24 -0700
Message-Id: <20210728230824.1762363-1-zsm@chromium.org>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit b97f074583736c42fb36f2da1164e28c73758912 upstream.

A page fault can be queued while vCPU is in real paged mode on AMD, and
AMD manual asks the user to always intercept it
(otherwise result is undefined).
The resulting VM exit, does have an error code.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20210225154135.405125-2-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
---
Backport Note:
* Syzkaller triggered a WARNING with the following stacktrace:
 WARNING: CPU: 3 PID: 3489 at arch/x86/kvm/x86.c:8097 kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
 Kernel panic - not syncing: panic_on_warn set ...

 CPU: 3 PID: 3489 Comm: poc Not tainted 4.19.199-00120-ga89b48fe9308 #5
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Call Trace:
  dump_stack+0x11b/0x19a
  panic+0x188/0x2f1
  ? __warn_printk+0xee/0xee
  ? __probe_kernel_read+0xad/0xc8
  ? kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
  ? kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
  __warn+0xe9/0x12a
  ? kvm_arch_vcpu_ioctl_run+0x42b/0x33d7
  report_bug+0x93/0xdd
  fixup_bug+0x28/0x4b
  do_error_trap+0xd1/0x1f5
  ? fixup_bug+0x4b/0x4b
  ? tick_nohz_tick_stopped+0x2e/0x39
  ? __irq_work_queue_local+0x50/0x96
  ? preempt_count_sub+0xf/0xbf
  ? lockdep_hardirqs_off+0x10c/0x115
  ? error_entry+0x72/0xd0
  ? trace_hardirqs_off_caller+0x56/0x116
  ? trace_hardirqs_off_thunk+0x1a/0x1c
  invalid_op+0x14/0x20
 RIP: 0010:kvm_arch_vcpu_ioctl_run+0x42b/0x33d7

* This commit is present in linux-5.13.y.

* Conflict arises as the following commit is is not present in
linux-5.10.y and older.
- b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")

* Tests run: syzkaller reproducer, Chrome OS tryjobs

 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43fb4e296d8d..9cfc669b4a24 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -416,8 +416,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -7114,6 +7112,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+       if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
+               vcpu->arch.exception.error_code = false;
+       kvm_x86_ops->queue_exception(vcpu);
+}
+
 static int inject_pending_event(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -7121,7 +7126,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected)
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	/*
 	 * Do not inject an NMI or interrupt if there is a pending
 	 * exception.  Exceptions and interrupts are recognized at
@@ -7175,7 +7180,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 			kvm_update_dr7(vcpu);
 		}
 
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	}
 
 	/* Don't consider new event if we re-injected an event */
-- 
2.32.0.432.gabb21c7263-goog

