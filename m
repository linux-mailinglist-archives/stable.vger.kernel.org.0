Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3883D9943
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhG1XIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG1XIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 19:08:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62CDBC061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:08:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id j1so7465132pjv.3
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hDXtnU1yyv0drT5HHp63puN2TyuPqpKCmcgCsRKIlDU=;
        b=ktsQJvy+cl1ehh9w7IYxikhFlvUd+FY2VDQCeTyUYASBY3Vhn8F8zDA3WHgTcfJK5B
         kKlEr8M4+nntHlx0akX/KEEQjQud2Pk2vD5Idb9aAVCxxkKnnsng9OI6cukQ/vZC93pd
         4v0PphWZZ33yAOBf2J7aJnGrUP+H9YS3/mj1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hDXtnU1yyv0drT5HHp63puN2TyuPqpKCmcgCsRKIlDU=;
        b=IZr9BYoKEhLObARjxZtDTqtlA3JqtQAYG1TFgDDmp5BV2PmKIoH4GPqS02MfBc0wbc
         1C8yC3oxc0FfX/KRjc1mFCgnEsED4FohuBxHWbPsvZXFVOEX9kf8K9kCdPz1n/eyiX0P
         jOWFBjX9ASeA4UbtCoPqC5H+5KoMGvIY6cdrBoADtFS3wNkCfKVup/UWk7tfoZOtG6Uh
         oj8EpeV7iR2Ypq/k3DTw5GPEfqG03yFCTNxjk/m38ZSl26DshabcvZ+4H+MFiNhpmvI8
         EzLEYWlf0dNr1zUc5JMDLYbB8WktRPsfMjC/erPd0Gbufgm1S2ZxaR/TkWSZFyYPZRv0
         +G6A==
X-Gm-Message-State: AOAM532YYLEa5brRI6YY7QPedYRy6FlhUoURDYDyg34y3xWcSGElSGTj
        et0eYOMYUR0X4xkK92q5goVYGbDvES3LDA==
X-Google-Smtp-Source: ABdhPJxmB0XicRzfhiR2r710UwE8C1j/0UHuMGb31FKSZuSD+Dd7riWpINwa+neS2s1qNzt7sXpVTg==
X-Received: by 2002:a05:6a00:1c6d:b029:338:322:137d with SMTP id s45-20020a056a001c6db02903380322137dmr2050044pfw.38.1627513716746;
        Wed, 28 Jul 2021 16:08:36 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:c9bb:c781:1aae:7a70])
        by smtp.googlemail.com with ESMTPSA id q7sm804677pjq.36.2021.07.28.16.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:08:36 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com, pbonzini@redhat.com
Subject: [linux-4.14.y] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Wed, 28 Jul 2021 16:08:33 -0700
Message-Id: <20210728230833.1762416-1-zsm@chromium.org>
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
 WARNING: CPU: 3 PID: 3436 at arch/x86/kvm/x86.c:7529 kvm_arch_vcpu_ioctl_run+0x247/0x2dd2
 Kernel panic - not syncing: panic_on_warn set ...

 CPU: 3 PID: 3436 Comm: poc Not tainted 4.14.241-00082-gce4d1565392b #7
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Call Trace:
  dump_stack+0xf8/0x163
  panic+0x15a/0x2c2
  ? unregister_sha256_avx+0x1b/0x1b
  ? kvm_arch_vcpu_ioctl_run+0x247/0x2dd2
  __warn+0xe4/0x117
  ? kvm_arch_vcpu_ioctl_run+0x247/0x2dd2
  report_bug+0x93/0xdd
  fixup_bug+0x28/0x4b
  do_error_trap+0xb6/0x1b2
  ? fixup_bug+0x4b/0x4b
  ? kasan_slab_free+0x141/0x154
  ? kasan_slab_free+0xad/0x154
  ? kmem_cache_free+0x14d/0x301
  ? put_pid+0x57/0x6f
  ? kvm_vcpu_ioctl+0x214/0x73d
  ? vfs_ioctl+0x46/0x5a
  ? trace_hardirqs_off_caller+0x10c/0x115
  ? trace_hardirqs_off_thunk+0x1a/0x1c
  invalid_op+0x1b/0x40
 RIP: 0010:kvm_arch_vcpu_ioctl_run+0x247/0x2dd2

* This commit is present in linux-5.13.y.

* Conflict arises as the following commit is is not present in
linux-5.10.y and older.
- b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")

* Tests run: syzkaller reproducer, Chrome OS tryjobs

 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 37d826acd017..d77caab7ad5e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -400,8 +400,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -6624,13 +6622,20 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
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
 
 	/* try to reinject previous events if any */
 	if (vcpu->arch.exception.injected) {
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 		return 0;
 	}
 
@@ -6675,7 +6680,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 			kvm_update_dr7(vcpu);
 		}
 
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	} else if (vcpu->arch.smi_pending && !is_smm(vcpu)) {
 		vcpu->arch.smi_pending = false;
 		enter_smm(vcpu);
-- 
2.32.0.432.gabb21c7263-goog

