Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA26E20DB99
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732229AbgF2UHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:07:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732940AbgF2TaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05A9F2529C;
        Mon, 29 Jun 2020 15:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445007;
        bh=AeMcQSG+c20dRntDA37Y3rtMXa4PxryEiS5ifGR7NqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YWui+6+ut3l1J7XdUEiHYMH4HK+0xbV3WR7l5Ft1LUMrID0gk89B1xw9UGX689yg4
         3hg+qWokeksCeJ87xv+mRW2PhmJWl/TdNO9q6D6zDv2Q1GdbnEO6TW/mMA2TP2JPbK
         4N0GUL6CaGJD+2TWraPRKTXx6+jfmoPBR1aVPKjY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.19 108/131] KVM: X86: Fix MSR range of APIC registers in X2APIC mode
Date:   Mon, 29 Jun 2020 11:34:39 -0400
Message-Id: <20200629153502.2494656-109-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629153502.2494656-1-sashal@kernel.org>
References: <20200629153502.2494656-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.131-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.131-rc1
X-KernelTest-Deadline: 2020-07-01T15:34+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit bf10bd0be53282183f374af23577b18b5fbf7801 upstream.

Only MSR address range 0x800 through 0x8ff is architecturally reserved
and dedicated for accessing APIC registers in x2APIC mode.

Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Message-Id: <20200616073307.16440-1-xiaoyao.li@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 50d59ad34619c..0aa5c4134b90e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2499,7 +2499,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		return kvm_mtrr_set_msr(vcpu, msr, data);
 	case MSR_IA32_APICBASE:
 		return kvm_set_apic_base(vcpu, msr_info);
-	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_write(vcpu, msr, data);
 	case MSR_IA32_TSCDEADLINE:
 		kvm_set_lapic_tscdeadline_msr(vcpu, data);
@@ -2797,7 +2797,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_APICBASE:
 		msr_info->data = kvm_get_apic_base(vcpu);
 		break;
-	case APIC_BASE_MSR ... APIC_BASE_MSR + 0x3ff:
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
 		return kvm_x2apic_msr_read(vcpu, msr_info->index, &msr_info->data);
 		break;
 	case MSR_IA32_TSCDEADLINE:
-- 
2.25.1

