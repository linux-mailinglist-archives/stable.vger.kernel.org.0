Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE44B48FC
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 10:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfIQIQe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 04:16:34 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40142 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfIQIQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 04:16:34 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so1178444pll.7;
        Tue, 17 Sep 2019 01:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lZpOV5nkYn4l+QDXD4wMM0QQ6pVGsg20H5ZmBWn5rFY=;
        b=XMfUu4ybyUbjaSQkc+G9xwv+FR7+SYPvEL9Au1fqvVxr5h+D75ZPor60PYddm3kRFN
         Nl17VEv+RnGNOjmQGn2murgOaEzjIqEAPfvyQIwJLfb7UKfl75QEET7wnkAsxhXl5reZ
         0dcBq4BSZBzBOm5xAZkv4cPm+qZBbc3G2f0zm/g4NCObOOIZTXCeHOaTXEkdY2twPdKb
         gagOsiBm0jYDskJ59NLZDdbeq/ZzDedazC90wFT+oFEHxo8V0cj3zwm7jD4GYXChgCB3
         flHvSawC/l/Qv9DvXaRm0Prx4z/qvrA5CZwTO3amxCGo/fekS2MpplfH1kyQAo2HL0g+
         YeHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lZpOV5nkYn4l+QDXD4wMM0QQ6pVGsg20H5ZmBWn5rFY=;
        b=ccy85uHNQ/ZSrKqkJKMCGBj22fUjnqHUiT7Rz9SEqDtN3EZJEpBfBM58dmNMkp8YKF
         a10ATPiRQ5hU6juW6pAqBjTdNrtEzTysagWwd6eL3pySN/Qh9Bf8ADoFWMvcpAYhsH2E
         gEmBt4bpCq4ymVJH5vt5PBoQwRboHMBu6/XrZ99OAB8oxlN1okPvh+9jp8WJPkxIy9PA
         svjUmAFrVyinz6eKKMbX53BB1lu81ubimKP78BCTLSaRBHs4tO5IaENkvRiDDDoB2Srw
         pJrSokpGuTnIkRq3oYweePdwTLoUoyBzDpBItXGos0cR2F4VO9UvjXdhFNuPH8kjCVkG
         zY8Q==
X-Gm-Message-State: APjAAAXARhfHbawggQW+8foBaVNlf/5ZYu3GntSipnffpR0QU+66+jbR
        IhX7xaOzKxWEFhgm7SHrnXQY577p
X-Google-Smtp-Source: APXvYqzNMalAy4NbEJMNfObcCqA9c0UoX5pztAHwrAbtwPMPP4mPFTKD26DkYq65IQVyqtWa82QGOQ==
X-Received: by 2002:a17:902:8546:: with SMTP id d6mr2429121plo.170.1568708193274;
        Tue, 17 Sep 2019 01:16:33 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j10sm1924142pfh.137.2019.09.17.01.16.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 17 Sep 2019 01:16:32 -0700 (PDT)
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
Subject: [PATCH 1/3] KVM: Fix coalesced mmio ring buffer out-of-bounds access
Date:   Tue, 17 Sep 2019 16:16:24 +0800
Message-Id: <1568708186-20260-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Reported by syzkaller:

	#PF: supervisor write access in kernel mode
	#PF: error_code(0x0002) - not-present page
	PGD 403c01067 P4D 403c01067 PUD 0
	Oops: 0002 [#1] SMP PTI
	CPU: 1 PID: 12564 Comm: a.out Tainted: G           OE     5.3.0-rc4+ #4
	RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]
	Call Trace:
	 __kvm_io_bus_write+0x91/0xe0 [kvm]
	 kvm_io_bus_write+0x79/0xf0 [kvm]
	 write_mmio+0xae/0x170 [kvm]
	 emulator_read_write_onepage+0x252/0x430 [kvm]
	 emulator_read_write+0xcd/0x180 [kvm]
	 emulator_write_emulated+0x15/0x20 [kvm]
	 segmented_write+0x59/0x80 [kvm]
	 writeback+0x113/0x250 [kvm]
	 x86_emulate_insn+0x78c/0xd80 [kvm]
	 x86_emulate_instruction+0x386/0x7c0 [kvm]
	 kvm_mmu_page_fault+0xf9/0x9e0 [kvm]
	 handle_ept_violation+0x10a/0x220 [kvm_intel]
	 vmx_handle_exit+0xbe/0x6b0 [kvm_intel]
	 vcpu_enter_guest+0x4dc/0x18d0 [kvm]
	 kvm_arch_vcpu_ioctl_run+0x407/0x660 [kvm]
	 kvm_vcpu_ioctl+0x3ad/0x690 [kvm]
	 do_vfs_ioctl+0xa2/0x690
	 ksys_ioctl+0x6d/0x80
	 __x64_sys_ioctl+0x1a/0x20
	 do_syscall_64+0x74/0x720
	 entry_SYSCALL_64_after_hwframe+0x49/0xbe
	RIP: 0010:coalesced_mmio_write+0xcc/0x130 [kvm]

Both the coalesced_mmio ring buffer indexs ring->first and ring->last are 
bigger than KVM_COALESCED_MMIO_MAX from the testcase, array out-of-bounds 
access triggers by ring->coalesced_mmio[ring->last].phys_addr = addr; 
assignment. This patch fixes it by mod indexs by KVM_COALESCED_MMIO_MAX.

syzkaller source: https://syzkaller.appspot.com/x/repro.c?x=134b2826a00000

Reported-by: syzbot+983c866c3dd6efa3662a@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 virt/kvm/coalesced_mmio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 5294abb..cff1ec9 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -73,6 +73,8 @@ static int coalesced_mmio_write(struct kvm_vcpu *vcpu,
 
 	spin_lock(&dev->kvm->ring_lock);
 
+	ring->first = ring->first % KVM_COALESCED_MMIO_MAX;
+	ring->last = ring->last % KVM_COALESCED_MMIO_MAX;
 	if (!coalesced_mmio_has_room(dev)) {
 		spin_unlock(&dev->kvm->ring_lock);
 		return -EOPNOTSUPP;
-- 
2.7.4

