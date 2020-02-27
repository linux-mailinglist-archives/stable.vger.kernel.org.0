Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3222171A9D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgB0Nz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:55700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731961AbgB0NzZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:55:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C4E92084E;
        Thu, 27 Feb 2020 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811725;
        bh=fM24r4pYPze+XKPLBjPB+T+9mHrOuFpi11CAonpsT/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I6tq1iqWg63BQAZKhpXu89f5n8n3YPgVw0dwPWvWkfd/n8/b4GrVY4IdYFKRHR4qE
         TBWJy40+I0qpOFStnCs0jluEGnRIqxoyXNR/uJTDBFsjWOhisLeGPv/RAsygU9S46c
         h7x8dmultwFQNStLPBcgos0wy9kMjVUNac81sThA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 038/237] KVM: nVMX: Use correct root level for nested EPT shadow page tables - again
Date:   Thu, 27 Feb 2020 14:34:12 +0100
Message-Id: <20200227132259.536427431@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
References: <20200227132255.285644406@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 148d735eb55d32848c3379e460ce365f2c1cbe4b ]

Hardcode the EPT page-walk level for L2 to be 4 levels, as KVM's MMU
currently also hardcodes the page walk level for nested EPT to be 4
levels.  The L2 guest is all but guaranteed to soft hang on its first
instruction when L1 is using EPT, as KVM will construct 4-level page
tables and then tell hardware to use 5-level page tables.

Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 809d1b031fd9e..a116548a4ade1 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -4597,6 +4597,9 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
 static int get_ept_level(struct kvm_vcpu *vcpu)
 {
+	/* Nested EPT currently only supports 4-level walks. */
+	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
+		return 4;
 	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
 		return 5;
 	return 4;
-- 
2.20.1



