Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 799D0D24C6
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390005AbfJJIuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390003AbfJJIuj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:50:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BB6B21D71;
        Thu, 10 Oct 2019 08:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697438;
        bh=H1cMqpA/ZSD3lQumDg4TmgstWNDbbRWCv7t6+fzf990=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0u9CpzU8j2UN9NGz4EsNkzUwsnYtGp3S8qQFve87YBBHiIMrVfUzNtxncXMmlqVf
         kcv7H7DIIq46L3msFd6zi8Xqcnc6OHrO0uXZZ4WIvDRBu5C7h3ShFu9Z5OXuYShzh9
         WV8ziPmo6ocRymTA+X5uRzdwiAeOxOjIIITWUe/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@cloud.ionos.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.14 07/61] KVM: nVMX: handle page fault in vmread fix
Date:   Thu, 10 Oct 2019 10:36:32 +0200
Message-Id: <20191010083453.935844488@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083449.500442342@linuxfoundation.org>
References: <20191010083449.500442342@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@cloud.ionos.com>

During backport f7eea636c3d5 ("KVM: nVMX: handle page fault in vmread"),
there was a mistake the exception reference should be passed to function
kvm_write_guest_virt_system, instead of NULL, other wise, we will get
NULL pointer deref, eg

kvm-unit-test triggered a NULL pointer deref below:
[  948.518437] kvm [24114]: vcpu0, guest rIP: 0x407ef9 kvm_set_msr_common: MSR_IA32_DEBUGCTLMSR 0x3, nop
[  949.106464] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[  949.106707] PGD 0 P4D 0
[  949.106872] Oops: 0002 [#1] SMP
[  949.107038] CPU: 2 PID: 24126 Comm: qemu-2.7 Not tainted 4.19.77-pserver #4.19.77-1+feature+daily+update+20191005.1625+a4168bb~deb9
[  949.107283] Hardware name: Dell Inc. Precision Tower 3620/09WH54, BIOS 2.7.3 01/31/2018
[  949.107549] RIP: 0010:kvm_write_guest_virt_system+0x12/0x40 [kvm]
[  949.107719] Code: c0 5d 41 5c 41 5d 41 5e 83 f8 03 41 0f 94 c0 41 c1 e0 02 e9 b0 ed ff ff 0f 1f 44 00 00 48 89 f0 c6 87 59 56 00 00 01 48 89 d6 <49> c7 00 00 00 00 00 89 ca 49 c7 40 08 00 00 00 00 49 c7 40 10 00
[  949.108044] RSP: 0018:ffffb31b0a953cb0 EFLAGS: 00010202
[  949.108216] RAX: 000000000046b4d8 RBX: ffff9e9f415b0000 RCX: 0000000000000008
[  949.108389] RDX: ffffb31b0a953cc0 RSI: ffffb31b0a953cc0 RDI: ffff9e9f415b0000
[  949.108562] RBP: 00000000d2e14928 R08: 0000000000000000 R09: 0000000000000000
[  949.108733] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffffc8
[  949.108907] R13: 0000000000000002 R14: ffff9e9f4f26f2e8 R15: 0000000000000000
[  949.109079] FS:  00007eff8694c700(0000) GS:ffff9e9f51a80000(0000) knlGS:0000000031415928
[  949.109318] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  949.109495] CR2: 0000000000000000 CR3: 00000003be53b002 CR4: 00000000003626e0
[  949.109671] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  949.109845] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  949.110017] Call Trace:
[  949.110186]  handle_vmread+0x22b/0x2f0 [kvm_intel]
[  949.110356]  ? vmexit_fill_RSB+0xc/0x30 [kvm_intel]
[  949.110549]  kvm_arch_vcpu_ioctl_run+0xa98/0x1b30 [kvm]
[  949.110725]  ? kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[  949.110901]  kvm_vcpu_ioctl+0x388/0x5d0 [kvm]
[  949.111072]  do_vfs_ioctl+0xa2/0x620

Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8026,7 +8026,7 @@ static int handle_vmread(struct kvm_vcpu
 		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
 		if (kvm_write_guest_virt_system(vcpu, gva, &field_value,
 						(is_long_mode(vcpu) ? 8 : 4),
-						NULL))
+						&e))
 			kvm_inject_page_fault(vcpu, &e);
 	}
 


