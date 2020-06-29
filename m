Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DEF20E708
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgF2Vwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgF2Sfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32055246EC;
        Mon, 29 Jun 2020 15:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444033;
        bh=Rd/7JZIi1jGJQMAxjhbt+AKP4whl0MEM7/J879v14yo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6rxsKY+0+NRkT+6UUVpkqofqxIdygHN18Uu9OAkgLfiXi6S1vzh55vVaL6XmPEsr
         d8nt/wfHU/XcinXyz81PnJKjgqlVPJNOke1Sp8D6ni9UcBpi59HnGmOYj5/TgYsg7o
         UjnuWqj5a+rJkGr49l7aDX64Tc6EvYyfZnN23cRU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 141/265] Revert "KVM: VMX: Micro-optimize vmexit time when not exposing PMU"
Date:   Mon, 29 Jun 2020 11:16:14 -0400
Message-Id: <20200629151818.2493727-142-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit 49097762fa405cdc16f8f597f6d27c078d4a31e9 ]

Guest crashes are observed on a Cascade Lake system when 'perf top' is
launched on the host, e.g.

 BUG: unable to handle kernel paging request at fffffe0000073038
 PGD 7ffa7067 P4D 7ffa7067 PUD 7ffa6067 PMD 7ffa5067 PTE ffffffffff120
 Oops: 0000 [#1] SMP PTI
 CPU: 1 PID: 1 Comm: systemd Not tainted 4.18.0+ #380
...
 Call Trace:
  serial8250_console_write+0xfe/0x1f0
  call_console_drivers.constprop.0+0x9d/0x120
  console_unlock+0x1ea/0x460

Call traces are different but the crash is imminent. The problem was
blindly bisected to the commit 041bc42ce2d0 ("KVM: VMX: Micro-optimize
vmexit time when not exposing PMU"). It was also confirmed that the
issue goes away if PMU is exposed to the guest.

With some instrumentation of the guest we can see what is being switched
(when we do atomic_switch_perf_msrs()):

 vmx_vcpu_run: switching 2 msrs
 vmx_vcpu_run: switching MSR38f guest: 70000000d host: 70000000f
 vmx_vcpu_run: switching MSR3f1 guest: 0 host: 2

The current guess is that PEBS (MSR_IA32_PEBS_ENABLE, 0x3f1) is to blame.
Regardless of whether PMU is exposed to the guest or not, PEBS needs to
be disabled upon switch.

This reverts commit 041bc42ce2d0efac3b85bbb81dea8c74b81f4ef9.

Reported-by: Maxime Coquelin <maxime.coquelin@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200619094046.654019-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7aa0dfab8bbd..8f59f8c8fd05d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6575,8 +6575,7 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_enter(vmx);
 
-	if (vcpu_to_pmu(vcpu)->version)
-		atomic_switch_perf_msrs(vmx);
+	atomic_switch_perf_msrs(vmx);
 	atomic_switch_umwait_control_msr(vmx);
 
 	if (enable_preemption_timer)
-- 
2.25.1

