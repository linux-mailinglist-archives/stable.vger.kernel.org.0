Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB53962C3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhEaPAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234453AbhEaO7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 321E361413;
        Mon, 31 May 2021 14:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469701;
        bh=HIihrXyinQlGhsl/lM+nxWJxwIl1GrGyXLWn1KBymE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Su9enMj84LaVGT/2Nsr7DcrwVPa9iqj+3NkJtE9ZKFl9MxGraFpxT+WJXR1iiKAuW
         e/x2NFuOdZojK1SDi8La+T7UZJmA3mkbi3pdiUmUdwgFNwlvcWs4z8lQH3VeVGT+2j
         zzYuSZyANVz8zroVxKQqohWRT+H42UOosrAqbnQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 287/296] KVM: X86: hyper-v: Task srcu lock when accessing kvm_memslots()
Date:   Mon, 31 May 2021 15:15:42 +0200
Message-Id: <20210531130713.363862598@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit da6d63a0062a3ee721b84123b83ec093f25759b0 ]

   WARNING: suspicious RCU usage
   5.13.0-rc1 #4 Not tainted
   -----------------------------
   ./include/linux/kvm_host.h:710 suspicious rcu_dereference_check() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
   1 lock held by hyperv_clock/8318:
    #0: ffffb6b8cb05a7d8 (&hv->hv_lock){+.+.}-{3:3}, at: kvm_hv_invalidate_tsc_page+0x3e/0xa0 [kvm]

  stack backtrace:
  CPU: 3 PID: 8318 Comm: hyperv_clock Not tainted 5.13.0-rc1 #4
  Call Trace:
   dump_stack+0x87/0xb7
   lockdep_rcu_suspicious+0xce/0xf0
   kvm_write_guest_page+0x1c1/0x1d0 [kvm]
   kvm_write_guest+0x50/0x90 [kvm]
   kvm_hv_invalidate_tsc_page+0x79/0xa0 [kvm]
   kvm_gen_update_masterclock+0x1d/0x110 [kvm]
   kvm_arch_vm_ioctl+0x2a7/0xc50 [kvm]
   kvm_vm_ioctl+0x123/0x11d0 [kvm]
   __x64_sys_ioctl+0x3ed/0x9d0
   do_syscall_64+0x3d/0x80
   entry_SYSCALL_64_after_hwframe+0x44/0xae

kvm_memslots() will be called by kvm_write_guest(), so we should take the srcu lock.

Fixes: e880c6ea5 (KVM: x86: hyper-v: Prevent using not-yet-updated TSC page by secondary CPUs)
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1621339235-11131-4-git-send-email-wanpengli@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/hyperv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..f00830e5202f 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1172,6 +1172,7 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 {
 	struct kvm_hv *hv = to_kvm_hv(kvm);
 	u64 gfn;
+	int idx;
 
 	if (hv->hv_tsc_page_status == HV_TSC_PAGE_BROKEN ||
 	    hv->hv_tsc_page_status == HV_TSC_PAGE_UNSET ||
@@ -1190,9 +1191,16 @@ void kvm_hv_invalidate_tsc_page(struct kvm *kvm)
 	gfn = hv->hv_tsc_page >> HV_X64_MSR_TSC_REFERENCE_ADDRESS_SHIFT;
 
 	hv->tsc_ref.tsc_sequence = 0;
+
+	/*
+	 * Take the srcu lock as memslots will be accessed to check the gfn
+	 * cache generation against the memslots generation.
+	 */
+	idx = srcu_read_lock(&kvm->srcu);
 	if (kvm_write_guest(kvm, gfn_to_gpa(gfn),
 			    &hv->tsc_ref, sizeof(hv->tsc_ref.tsc_sequence)))
 		hv->hv_tsc_page_status = HV_TSC_PAGE_BROKEN;
+	srcu_read_unlock(&kvm->srcu, idx);
 
 out_unlock:
 	mutex_unlock(&hv->hv_lock);
-- 
2.30.2



