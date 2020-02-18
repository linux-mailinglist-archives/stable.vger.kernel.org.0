Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB761630CB
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 20:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgBRT4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 14:56:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgBRT4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 14:56:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74AA124670;
        Tue, 18 Feb 2020 19:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582055790;
        bh=ALJFu7IESkTZwkNiXtuqDRqI1jrSFS0kIq8FsnmF+ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXz6PI29G8ZYRH61kqnUjau1pmmyECFE5wTKh6Ji8mapKTuveJ02iiG9cEVIz+9E2
         mRvum/OTJqh4Y7hNZX0dL7hmXQWVAoRfd8JcyOQiin+XGdqT2Zbdqu5Idi9K0GnCPR
         H85TXvZaBhcGRea7YUQlZLn2sd5jGkcL1l3V8S9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.19 22/38] KVM: nVMX: Use correct root level for nested EPT shadow page tables
Date:   Tue, 18 Feb 2020 20:55:08 +0100
Message-Id: <20200218190421.315164610@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190418.536430858@linuxfoundation.org>
References: <20200218190418.536430858@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 148d735eb55d32848c3379e460ce365f2c1cbe4b upstream.

Hardcode the EPT page-walk level for L2 to be 4 levels, as KVM's MMU
currently also hardcodes the page walk level for nested EPT to be 4
levels.  The L2 guest is all but guaranteed to soft hang on its first
instruction when L1 is using EPT, as KVM will construct 4-level page
tables and then tell hardware to use 5-level page tables.

Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/vmx/vmx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2968,6 +2968,9 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu,
 
 static int get_ept_level(struct kvm_vcpu *vcpu)
 {
+	/* Nested EPT currently only supports 4-level walks. */
+	if (is_guest_mode(vcpu) && nested_cpu_has_ept(get_vmcs12(vcpu)))
+		return 4;
 	if (cpu_has_vmx_ept_5levels() && (cpuid_maxphyaddr(vcpu) > 48))
 		return 5;
 	return 4;


