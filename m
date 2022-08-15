Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8251E594295
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349939AbiHOVwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350530AbiHOVvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:51:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE7C106F9C;
        Mon, 15 Aug 2022 12:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4D03B80EAD;
        Mon, 15 Aug 2022 19:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4D8C433D6;
        Mon, 15 Aug 2022 19:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591976;
        bh=ydOSK1Hk0GTmHTcy6hWBPyLZP1ki0L2m1F1ee9yKE8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaS2zQCmBPFsosTLDAYZIvsTO2qG8M91OyshRuDXxyAmKvjjyqlJTtHmYV9tivHCR
         ZOoY/lbJe2RFxTPqOzmOtyaA+WVyw8ZGGQ7MuNwUXJ/UQIPMgbSJPOC49DKzDYWhEe
         IiA41ppL3Wae+dD9z/J/EXdCN1ZubEPanA5M147I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0039/1157] KVM: SVM: Disable SEV-ES support if MMIO caching is disable
Date:   Mon, 15 Aug 2022 19:49:55 +0200
Message-Id: <20220815180440.997426890@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 0c29397ac1fdd64ae59941a477511a05e61a4754 upstream.

Disable SEV-ES if MMIO caching is disabled as SEV-ES relies on MMIO SPTEs
generating #NPF(RSVD), which are reflected by the CPU into the guest as
a #VC.  With SEV-ES, the untrusted host, a.k.a. KVM, doesn't have access
to the guest instruction stream or register state and so can't directly
emulate in response to a #NPF on an emulated MMIO GPA.  Disabling MMIO
caching means guest accesses to emulated MMIO ranges cause #NPF(!PRESENT),
and those flavors of #NPF cause automatic VM-Exits, not #VC.

Adjust KVM's MMIO masks to account for the C-bit location prior to doing
SEV(-ES) setup, and document that dependency between adjusting the MMIO
SPTE mask and SEV(-ES) setup.

Fixes: b09763da4dd8 ("KVM: x86/mmu: Add module param to disable MMIO caching (for testing)")
Reported-by: Michael Roth <michael.roth@amd.com>
Tested-by: Michael Roth <michael.roth@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220803224957.1285926-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.h      |    2 ++
 arch/x86/kvm/mmu/spte.c |    1 +
 arch/x86/kvm/mmu/spte.h |    2 --
 arch/x86/kvm/svm/sev.c  |   10 ++++++++++
 arch/x86/kvm/svm/svm.c  |    9 ++++++---
 5 files changed, 19 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -11,6 +11,8 @@
 #define PT32_PT_BITS 10
 #define PT32_ENT_PER_PAGE (1 << PT32_PT_BITS)
 
+extern bool __read_mostly enable_mmio_caching;
+
 #define PT_WRITABLE_SHIFT 1
 #define PT_USER_SHIFT 2
 
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -21,6 +21,7 @@
 
 bool __read_mostly enable_mmio_caching = true;
 module_param_named(mmio_caching, enable_mmio_caching, bool, 0444);
+EXPORT_SYMBOL_GPL(enable_mmio_caching);
 
 u64 __read_mostly shadow_host_writable_mask;
 u64 __read_mostly shadow_mmu_writable_mask;
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -5,8 +5,6 @@
 
 #include "mmu_internal.h"
 
-extern bool __read_mostly enable_mmio_caching;
-
 /*
  * A MMU present SPTE is backed by actual memory and may or may not be present
  * in hardware.  E.g. MMIO SPTEs are not considered present.  Use bit 11, as it
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -22,6 +22,7 @@
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
 
+#include "mmu.h"
 #include "x86.h"
 #include "svm.h"
 #include "svm_ops.h"
@@ -2221,6 +2222,15 @@ void __init sev_hardware_setup(void)
 	if (!sev_es_enabled)
 		goto out;
 
+	/*
+	 * SEV-ES requires MMIO caching as KVM doesn't have access to the guest
+	 * instruction stream, i.e. can't emulate in response to a #NPF and
+	 * instead relies on #NPF(RSVD) being reflected into the guest as #VC
+	 * (the guest can then do a #VMGEXIT to request MMIO emulation).
+	 */
+	if (!enable_mmio_caching)
+		goto out;
+
 	/* Does the CPU support SEV-ES? */
 	if (!boot_cpu_has(X86_FEATURE_SEV_ES))
 		goto out;
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4897,13 +4897,16 @@ static __init int svm_hardware_setup(voi
 	/* Setup shadow_me_value and shadow_me_mask */
 	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
 
-	/* Note, SEV setup consumes npt_enabled. */
+	svm_adjust_mmio_mask();
+
+	/*
+	 * Note, SEV setup consumes npt_enabled and enable_mmio_caching (which
+	 * may be modified by svm_adjust_mmio_mask()).
+	 */
 	sev_hardware_setup();
 
 	svm_hv_hardware_setup();
 
-	svm_adjust_mmio_mask();
-
 	for_each_possible_cpu(cpu) {
 		r = svm_cpu_init(cpu);
 		if (r)


