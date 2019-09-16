Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2654B3558
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 09:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbfIPHMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 03:12:55 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38644 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfIPHMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 03:12:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id x10so1373716pgi.5;
        Mon, 16 Sep 2019 00:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0RlJ05uTroP58LEheLIV/N0JmFk4uyJbV6/x+X7o6VI=;
        b=khSq9uAQ+4px8pQprdT33SHwhZgIWiE6QQUqn6A1d4BRFQ4fUYWlxSPGffYM4n6t3b
         UO61+6G0TxDA8N2CIe/MqWg5GRELfVfZiwr6LHdo3yRQORIjapdOFylqeIO/WN9l9+ND
         Ok2SQDvWaFXUmUYkDOsurn6olRrcGoJa0O+KR10nzwxI3SzTBCxvl7Tx9zKUyiTg1Q/0
         r17BWqvhAbp/TnW0dfK8GlSSI2AM4xFt23VwJrOTFAtK1jEn8f6QSdGURkmvxwSL91QE
         mcll2iyR8el5VnorIOVh9bznDxdST7Eebso4EWC+nvJc+Gg/kF93WP3u+KHBtr+JEbTD
         /21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0RlJ05uTroP58LEheLIV/N0JmFk4uyJbV6/x+X7o6VI=;
        b=V0h2bCWJvwrWNPcGiEbWVICF0vrCNHF8YIQc51O2ltQSvumvbqKeXQA4Plds26YgSi
         wflS1K+X/pu7SLq+W0coe/YJMmvL2POFQv2SGut+zC0hGjHu1f+e59yKMTqryDVuLo65
         bfikrcldWaDA3BToLa1aFeOX71UdC4K0Kns/v+TjmK7HCdjMTjiBCpCa3TWCBzZ8RRGR
         RjSBiJfAmBFBgmvP0QaLOvnpY8GaJ7TG1LaVk7hQyZLBejz1ll7HG/ZDWq67QiSbZiVz
         hQoPRICfXIA/22WCFgFACU1tMtT0fYgTtY3Zco2NjwRS+IuSKlABgH6xJ4uZQHl5CntG
         SBgQ==
X-Gm-Message-State: APjAAAWMyvQ7d2GW01NJV75yeTc79Pr9hK45zzssMPlNWhVD7KbVgZ1o
        jBhbZ6mpBC+L9UtQ0Emrv4sTGYYJ
X-Google-Smtp-Source: APXvYqyK591X0S54vFzFEbUbk6IDBXuo3c1uMvTcq3UQZ7Dodoxn009XsU9TRj0u8Y3ekjlI7Z+w7Q==
X-Received: by 2002:aa7:8e08:: with SMTP id c8mr64793973pfr.238.1568617974784;
        Mon, 16 Sep 2019 00:12:54 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id r23sm8603061pjo.22.2019.09.16.00.12.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 16 Sep 2019 00:12:54 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, stable@vger.kernel.org
Subject: [PATCH] KVM: X86: Fix warning in handle_desc
Date:   Mon, 16 Sep 2019 15:12:49 +0800
Message-Id: <1568617969-6934-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

	WARNING: CPU: 0 PID: 6544 at /home/kernel/data/kvm/arch/x86/kvm//vmx/vmx.c:4689 handle_desc+0x37/0x40 [kvm_intel]
	CPU: 0 PID: 6544 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
	RIP: 0010:handle_desc+0x37/0x40 [kvm_intel]
	Call Trace:
	 vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
	 vcpu_enter_guest+0x4dc/0x18d0 [kvm]
	 kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
	 kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
	 do_vfs_ioctl+0xa2/0x690
	 ksys_ioctl+0x6d/0x80
	 __x64_sys_ioctl+0x1a/0x20
	 do_syscall_64+0x74/0x720
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe

When CR4.UMIP is set, guest should have UMIP cpuid flag. Current 
kvm set_sregs function doesn't have such check when userspace inputs 
sregs values. SECONDARY_EXEC_DESC is enabled on writes to CR4.UMIP in 
vmx_set_cr4 though guest doesn't have UMIP cpuid flag. The testcast 
triggers handle_desc warning when executing ltr instruction since guest 
architectural CR4 doesn't set UMIP. This patch fixes it by adding check 
for guest UMIP cpuid flag when get sreg inputs from userspace.

Reported-by: syzbot+0f1819555fbdce992df9@syzkaller.appspotmail.com
Fixes: 0367f205a3b7 ("KVM: vmx: add support for emulating UMIP")
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Note: syzbot report link https://lkml.org/lkml/2019/9/11/799

 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f7cfd8e..83288ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8645,6 +8645,10 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 			(sregs->cr4 & X86_CR4_OSXSAVE))
 		return  -EINVAL;
 
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_UMIP) &&
+			(sregs->cr4 & X86_CR4_UMIP))
+		return -EINVAL;
+
 	if ((sregs->efer & EFER_LME) && (sregs->cr0 & X86_CR0_PG)) {
 		/*
 		 * When EFER.LME and CR0.PG are set, the processor is in
-- 
2.7.4

