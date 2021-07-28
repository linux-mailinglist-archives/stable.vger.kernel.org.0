Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C123D993A
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhG1XHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG1XHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 19:07:10 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55742C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:07:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q2so4572995plr.11
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdkOLQ68EpoqR18l1Zw/b54LhUyQpBvKVhl23dIi6RY=;
        b=QJ1cDxlnQzfyZ9Lco8Z1JJTggR7F2FyXOqyZRWcPa1FLwhCiJE+13MpKe8ym1eftMx
         k2FmcmlqXYAKfZCSDlXXzFzhSgKNTodv1SBbBAoUYx7MFzuw7gnPMJ9tK6repyoQk95R
         +29PvXuIyaBQtT/Y78+fbq0Y1f9SS88pmTu24=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gdkOLQ68EpoqR18l1Zw/b54LhUyQpBvKVhl23dIi6RY=;
        b=p1R0L6U9VzDbPLqSw44ebSDb2gL5vb/hLRyD61OgYA2HkWKly0JbtMaY/edoGtbHfM
         60gtcUXDzGgtlEu4ULG/0cBI6WsOWGc8I2NMVcKivQ/tPK3/o2jM4vmnJuOwVIOzgmFW
         +/EiHBFByMvIQg5FM54TgyX0WFeq+tYqP95UOvPm2HWmbcVUm4+BCWPax3Ldqvyst8Qx
         If+B59Y4smd8XK6HqpOgNcT6fVGhiXgAo7sODPepF/C9LlA49AbNYZsYhTHTwiWUcV3u
         7bsqzZx9ciKNp9/EqUE4pUkUGNbtBqMopto7qDmeWbpEvzN3+yXQS77AchmNpppWg9GK
         2xxw==
X-Gm-Message-State: AOAM5320vnmvjDhxFptZHZbXY/Vq3b8GHLtNFe02mOLwb8V7Ct1vtumh
        AznKVNhjii+wtpu2Pxpju/8lNK6aoCmaog==
X-Google-Smtp-Source: ABdhPJx2hSYhgu1jJSBlnQrE8aJhiLzefoLig7lXxYG9S0gJadKdxpfFpTVXWxar8oQGyB9joYJJHA==
X-Received: by 2002:a17:902:8ec9:b029:12b:a69d:4146 with SMTP id x9-20020a1709028ec9b029012ba69d4146mr1931102plo.32.1627513626550;
        Wed, 28 Jul 2021 16:07:06 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:c9bb:c781:1aae:7a70])
        by smtp.googlemail.com with ESMTPSA id r4sm807038pjo.46.2021.07.28.16.07.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:07:05 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        mlevitsk@redhat.com, pbonzini@redhat.com
Subject: [linux-5.10.y] KVM: x86: determine if an exception has an error code only when injecting it.
Date:   Wed, 28 Jul 2021 16:07:00 -0700
Message-Id: <20210728230700.1762131-1-zsm@chromium.org>
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
 WARNING: CPU: 3 PID: 3402 at arch/x86/kvm/x86.c:9387 kvm_arch_vcpu_ioctl_run+0x35b/0x21b0
 Modules linked in:
 CPU: 3 PID: 3402 Comm: poc Not tainted 5.10.54-00289-g08277b9dde63 #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
 RIP: 0010:kvm_arch_vcpu_ioctl_run+0x35b/0x21b0
 Code: 8d bd 50 0e 00 00 e8 1f 22 38 00 48 83 bd 50 0e 00 00 00 75 15 48 8d bd 00 02 00 00 e8 1c 21 38 00 83 bd 00 02 00 00 00 74 02 <0f> 0b 48 8b 04 24 48 8d 78 01 e8 98 1f 38 00 48 8b 04 24 80 78 01
 RSP: 0018:ffff888009bcfc10 EFLAGS: 00010202
 RAX: 1ffff110010e9000 RBX: ffff888007cd7400 RCX: ffffffff8105f65a
 RDX: 0000000000000003 RSI: dffffc0000000000 RDI: ffff888008748200
 RBP: ffff888008748000 R08: 0000000000000004 R09: ffffffff84ac9963
 R10: 0000000000000000 R11: ffffffff81040a0b R12: ffff888008748000
 R13: ffff888008748100 R14: 1ffff11001379fae R15: ffff8880075c8000
 FS:  00007d6063ce7700(0000) GS:ffff88806d380000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000059fbd456d2c8 CR3: 000000000c6ed002 CR4: 0000000000372ee0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 Call Trace:
  ? put_pid+0x60/0x72
  ? kvm_arch_vcpu_runnable+0x1ca/0x1ca
  ? rcu_read_lock_held_common+0x3c/0x3c
  ? slab_free_freelist_hook+0xcf/0x123
  ? kmem_cache_free+0x17d/0x1f9
  kvm_vcpu_ioctl+0x256/0x6e1
  ? kvm_free_memslots+0xa8/0xa8
  ? rcu_read_lock_held_common+0x3c/0x3c
  ? do_vfs_ioctl+0x6b0/0x8a6
  ? ioctl_file_clone+0xb4/0xb4
  ? selinux_file_ioctl+0x1f9/0x2da
  ? selinux_file_mprotect+0x1d9/0x1d9
  ? rcu_read_lock_held+0x73/0x9f
  vfs_ioctl+0x46/0x5a
  __do_sys_ioctl+0x63/0x86
  ? __x64_sys_ioctl+0x2a/0x3c
  do_syscall_64+0x2d/0x3a
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x44dd39

* This commit is present in linux-5.13.y.

* Conflict arises as the following commit is is not present in
linux-5.10.y and older.
- b3646477d458 ("KVM: x86: use static calls to reduce kvm_x86_ops overhead")

* Tests run: syzkaller reproducer

 arch/x86/kvm/x86.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 800914e9e12b..3ad6f77ea1c4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -541,8 +541,6 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 	if (!vcpu->arch.exception.pending && !vcpu->arch.exception.injected) {
 	queue:
-		if (has_error && !is_protmode(vcpu))
-			has_error = false;
 		if (reinject) {
 			/*
 			 * On vmentry, vcpu->arch.exception.pending is only
@@ -8265,6 +8263,13 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.update_cr8_intercept(vcpu, tpr, max_irr);
 }
 
+static void kvm_inject_exception(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
+		vcpu->arch.exception.error_code = false;
+	kvm_x86_ops.queue_exception(vcpu);
+}
+
 static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 {
 	int r;
@@ -8273,7 +8278,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected) {
-		kvm_x86_ops.queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
 	/*
@@ -8336,7 +8341,7 @@ static void inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit
 			}
 		}
 
-		kvm_x86_ops.queue_exception(vcpu);
+		kvm_inject_exception(vcpu);
 		can_inject = false;
 	}
 
-- 
2.32.0.432.gabb21c7263-goog

