Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B1E1674D7
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387744AbgBUIRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:17:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:55510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387739AbgBUIRv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:17:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B66B524689;
        Fri, 21 Feb 2020 08:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273071;
        bh=F672RVWkMDEt8vi7MVek29Hb5puoF4NyMi6GODJWWfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t3KIBNccsHlAOlWes9lcwlfWPD9IWo6cgNtbldxJfIRxVL5wUo418xJBlU7EzfiE7
         8Q4qgF078+dHvtNN45o+XqFKyPJkVnPMzzqTPyuUztBvkYQn7wnjKWVL4sT6I5G/GF
         nmO7KnliYsDlDeBFaOVUtvVXitxDRoYJBulXqD88=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/191] KVM: nVMX: Use correct root level for nested EPT shadow page tables
Date:   Fri, 21 Feb 2020 08:39:42 +0100
Message-Id: <20200221072252.173149129@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
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
index 2660c01eadaeb..aead984d89ad6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -5302,6 +5302,9 @@ static void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 
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



