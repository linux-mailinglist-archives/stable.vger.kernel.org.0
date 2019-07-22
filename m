Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD8806F871
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 06:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfGVE01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 00:26:27 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39602 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfGVE01 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 00:26:27 -0400
Received: by mail-pf1-f194.google.com with SMTP id f17so12744246pfn.6;
        Sun, 21 Jul 2019 21:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/GECkMX2BvgmJ+stDaMKbwKqcE9+Rsp9237P1eJja/Q=;
        b=VEONqYJkW8skLU3QWUv/3Q2eWK9Ld5CPEKr4dV3WS4mTTVaZqg8cdn4IraDoSirj/g
         HjENpWKixV96QUX/ifWxWiRajyg0xIiOzNNmLvUDWYNK6pqonkqSu9MMCVIZtUetDbnu
         Ot1SzJyKlBOino4/UVtlwfrsnKxWe9khy0R0tPCBiyA1/oiOnMQwzmk6QaFEOOFLQ0y9
         P+bnQ3kACtLZmfjLeGL5WsblFrnPCNwICOIgsPEo7L35VhK9E1pY/51NPyk2lv72+xJH
         m0S+SuxBLEnH7yVWWHOXz0SSmXsiY4RtB97GFeGwq0/D0JiD7ak2BmrtktHpk8tVP/zx
         NnBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/GECkMX2BvgmJ+stDaMKbwKqcE9+Rsp9237P1eJja/Q=;
        b=PeINbTcpIjjtIiTsVK7hq0v5NYrW6sjz4HSiQOT4UIDIr/dPchgWki5sVEeSsKz7EH
         s+PgEYRwpJl2ov6osFr7iaAq/X/OYwOCymH5XsF2F2fsFe88C1Z8+zbBT3ztMvOb3wZW
         dmOEb70Jf+gQNJ5b1FVF6Aj/BReTf6kK2bt+T/sDRuaUscisGxV90z4im/XPsSQ/fKGw
         3PizTGwFk+eUvANYsnD9wNyWcMizJZKBdWO1XfPCQSazkXSqj7m0vDfV12l6QWWaLA1L
         VAH7N27UrBaWew39+0ARSKWkZAeEB4lYaDPXgDhMGbZ59sbzL0exOR8MlP9fimHoTEzT
         +/Zg==
X-Gm-Message-State: APjAAAUYPzf+ysMihtmJnX/usFvHFACNgvaWwwATLTcXkrfjrcukyDk3
        ZYieg+1Z6PPQHV7g4IOBmM6omC9Thy0=
X-Google-Smtp-Source: APXvYqz4tCkRU/CC2Y7DGSppuc7kMSC8+iomq6jRFSbYdXF9P+JPt8Ilyh/dRC0sUwlxX8fzTuFZcg==
X-Received: by 2002:a63:460c:: with SMTP id t12mr69057416pga.69.1563769586567;
        Sun, 21 Jul 2019 21:26:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id r9sm17108217pjq.3.2019.07.21.21.26.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 21 Jul 2019 21:26:26 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Lambertz <mail@thomaslambertz.de>,
        anthony <antdev66@gmail.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] KVM: X86: Fix fpu state crash in kvm guest
Date:   Mon, 22 Jul 2019 12:26:20 +0800
Message-Id: <1563769581-20293-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The idea before commit 240c35a37 was that we have the following FPU states:

               userspace (QEMU)             guest
---------------------------------------------------------------------------
               processor                    vcpu->arch.guest_fpu
>>> KVM_RUN: kvm_load_guest_fpu
               vcpu->arch.user_fpu          processor
>>> preempt out
               vcpu->arch.user_fpu          current->thread.fpu
>>> preempt in
               vcpu->arch.user_fpu          processor
>>> back to userspace
>>> kvm_put_guest_fpu
               processor                    vcpu->arch.guest_fpu
---------------------------------------------------------------------------

With the new lazy model we want to get the state back to the processor 
when schedule in from current->thread.fpu.

Reported-by: Thomas Lambertz <mail@thomaslambertz.de>
Reported-by: anthony <antdev66@gmail.com>
Tested-by: anthony <antdev66@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Thomas Lambertz <mail@thomaslambertz.de>
Cc: anthony <antdev66@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 5f409e20b (x86/fpu: Defer FPU state load until return to userspace)
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cf2afdf..bdcd250 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3306,6 +3306,10 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
 
+	fpregs_assert_state_consistent();
+	if (test_thread_flag(TIF_NEED_FPU_LOAD))
+		switch_fpu_return();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
@@ -7990,9 +7994,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	trace_kvm_entry(vcpu->vcpu_id);
 	guest_enter_irqoff();
 
-	fpregs_assert_state_consistent();
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		switch_fpu_return();
+	WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD));
 
 	if (unlikely(vcpu->arch.switch_db_regs)) {
 		set_debugreg(0, 7);
-- 
2.7.4

