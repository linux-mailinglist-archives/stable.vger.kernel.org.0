Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421C81F282
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbfEOLL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbfEOLL2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5D2A2168B;
        Wed, 15 May 2019 11:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918687;
        bh=L5efsXyWbGWe11uTyaShAqVCdeuPOgEDJwqmXQ0SoCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3B+OJQsxg5N0VHSdoDonZhxKktAx5AzqFZYnT/8uboKJaPZYkKjON2pJ72TNMijK
         zw1/c/Lido34uIEUjU8NPZr2LQfNkLXQo15RjkX39H92xSrhUH9/lZtuT6fMHNhCYZ
         Ig5dhRJaxIzUb2TyU/joFGJ5k8YC+RGDnuJ9JQn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 227/266] kvm: x86: Report STIBP on GET_SUPPORTED_CPUID
Date:   Wed, 15 May 2019 12:55:34 +0200
Message-Id: <20190515090730.680064304@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

commit d7b09c827a6cf291f66637a36f46928dd1423184 upstream.

Months ago, we have added code to allow direct access to MSR_IA32_SPEC_CTRL
to the guest, which makes STIBP available to guests.  This was implemented
by commits d28b387fb74d ("KVM/VMX: Allow direct access to
MSR_IA32_SPEC_CTRL") and b2ac58f90540 ("KVM/SVM: Allow direct access to
MSR_IA32_SPEC_CTRL").

However, we never updated GET_SUPPORTED_CPUID to let userspace know that
STIBP can be enabled in CPUID.  Fix that by updating
kvm_cpuid_8000_0008_ebx_x86_features and kvm_cpuid_7_0_edx_x86_features.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -344,7 +344,7 @@ static inline int __do_cpuid_ent(struct
 	/* cpuid 0x80000008.ebx */
 	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
 		F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
-		F(AMD_SSB_NO);
+		F(AMD_SSB_NO) | F(AMD_STIBP);
 
 	/* cpuid 0xC0000001.edx */
 	const u32 kvm_supported_word5_x86_features =
@@ -365,7 +365,8 @@ static inline int __do_cpuid_ent(struct
 
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
-		F(SPEC_CTRL) | F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES);
+		F(SPEC_CTRL) | F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) |
+		F(INTEL_STIBP);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();


