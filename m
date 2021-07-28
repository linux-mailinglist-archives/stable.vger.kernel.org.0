Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 996FC3D9941
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232515AbhG1XHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhG1XHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 19:07:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BD1C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:07:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pf12-20020a17090b1d8cb0290175c085e7a5so12607228pjb.0
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=itEn/p0MFKUpZCgXTIQBqdl71YEmU43C0TWOzBsFcZo=;
        b=DJGCcdnRoICMKbnfeCKMgrc1aULD3rLU1Iylz0suZt2QudPtFS77RDSSE5XG79/oUO
         imz8XHD/SzdHw4NlmF1UfO/trzIiwExZkdQFRgl56KcltmZt9fpKe6bld9fdE2+sp6Zy
         oXPggkKmJUXkybkH6O3Uc9+2TML5hoReusR6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=itEn/p0MFKUpZCgXTIQBqdl71YEmU43C0TWOzBsFcZo=;
        b=ktmqmwvDo5CloZtXQHEXwueb4iu2BL2AMYcB+yx/9eGoKXDXeIanLerlGKBMwigpw1
         Cvc8FqUsUxdA0SM81Sqr9bTwIHkW/gd4oaNjkpuYcoRNuajlheUeA5V1TPmIM+Py+JPN
         RpIedxZUUmbP9VX5Tmne/ggFD28PCzTIcIsrk1gzzjDMRWFvMtSFmXC/VyyINubNGiz3
         mpnS2EHoBlV/H1h5+vyKarbebuNqrOfkqiRKOylFvF5xLPYrVLsvKU0rf2Ja1iRMLjAS
         wdILHAjgyruII+ou7WO8USoXTLifoVgkwtb5lOtQpMaFTxLgIdoDjnzPDNrFpKwdNWUt
         B8DQ==
X-Gm-Message-State: AOAM530vcRolNciIl/jorcVya3fyIOsj/prZOgMloswc30DDJihhJ4EE
        kxnkzrdvQqYTMzfyiV3u3NQWY47bKVrRFw==
X-Google-Smtp-Source: ABdhPJyqb9FndQqJuTVDDXX/zUpBoEFeiSkD3X2L6iYit2znE/8RYpvEvcGDbPfT0lMgXdxyO1+pBQ==
X-Received: by 2002:a65:50cb:: with SMTP id s11mr1184712pgp.236.1627513669435;
        Wed, 28 Jul 2021 16:07:49 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:c9bb:c781:1aae:7a70])
        by smtp.googlemail.com with ESMTPSA id j13sm8358114pjl.1.2021.07.28.16.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:07:49 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com, pbonzini@redhat.com
Subject: [linux-5.4.y] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Wed, 28 Jul 2021 16:07:45 -0700
Message-Id: <20210728230745.1762245-1-zsm@chromium.org>
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
 WARNING: CPU: 0 PID: 3594 at arch/x86/kvm/x86.c:8635 kvm_arch_vcpu_ioctl_run+0x338/0x2421
 Kernel panic - not syncing: panic_on_warn set ...
 CPU: 0 PID: 3594 Comm: poc Not tainted 5.4.136-00181-g253dccefb5cb #3
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 Call Trace:
  dump_stack+0x97/0xd3
  panic+0x198/0x388
  ? __warn_printk+0xee/0xee
  ? printk+0xad/0xde
  ? rcu_read_unlock_sched_notrace+0xf/0xf
  ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
  __warn+0xd3/0x113
  ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
  report_bug+0xbf/0x100
  fixup_bug+0x28/0x4b
  do_error_trap+0xe7/0xf7
  ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
  do_invalid_op+0x3a/0x3f
  ? kvm_arch_vcpu_ioctl_run+0x338/0x2421
  invalid_op+0x23/0x30
 RIP: 0010:kvm_arch_vcpu_ioctl_run+0x338/0x2421

* This commit is present in linux-5.13.y.

* Conflict arises as the following commit is is not present in
linux-5.10.y and older.
- b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")

* Tests run: syzkaller reproducer, Chrome OS tryjobs

 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 377157656a8b..5d35b9656b67 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -475,8 +475,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -7592,6 +7590,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
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
@@ -7599,7 +7604,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected)
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	/*
 	 * Do not inject an NMI or interrupt if there is a pending
 	 * exception.  Exceptions and interrupts are recognized at
@@ -7665,7 +7670,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu)
 			}
 		}
 
-		kvm_x86_ops->queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 	}
 
 	/* Don't consider new event if we re-injected an event */
-- 
2.32.0.432.gabb21c7263-goog

