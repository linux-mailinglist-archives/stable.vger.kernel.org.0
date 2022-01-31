Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39024A44D6
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377241AbiAaLdC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378685AbiAaL25 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:28:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B244BC02C3EE;
        Mon, 31 Jan 2022 03:17:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5056F60B98;
        Mon, 31 Jan 2022 11:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148E6C340E8;
        Mon, 31 Jan 2022 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627864;
        bh=2RMF7AsfJSmyy2o2Abh6kXZeNWBMz1Kcbl0O/Pmfk30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jic/XKo+FjPn1Ppat777aKbCsVQ/A9dPIKFI9QC15KVWiKa6JJr9fHClL7lPolND2
         FiIqUF0LuJnJUdu9FV7SSgHLQiXN4aaGCMTqSHIe+OPZmgJR5AL6fpHj2qV5ppAN6m
         soUYx7QFl1MEfPAqeKoW+Mc3Fs0DDMAmL/JXrWyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.16 049/200] KVM: SVM: Never reject emulation due to SMAP errata for !SEV guests
Date:   Mon, 31 Jan 2022 11:55:12 +0100
Message-Id: <20220131105235.216738651@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 55467fcd55b89c622e62b4afe60ac0eb2fae91f2 upstream.

Always signal that emulation is possible for !SEV guests regardless of
whether or not the CPU provided a valid instruction byte stream.  KVM can
read all guest state (memory and registers) for !SEV guests, i.e. can
fetch the code stream from memory even if the CPU failed to do so because
of the SMAP errata.

Fixes: 05d5a4863525 ("KVM: SVM: Workaround errata#1096 (insn_len maybe zero on SMAP violation)")
Cc: stable@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Message-Id: <20220120010719.711476-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4464,8 +4464,13 @@ static bool svm_can_emulate_instruction(
 	bool smep, smap, is_user;
 	unsigned long cr4;
 
+	/* Emulation is always possible when KVM has access to all guest state. */
+	if (!sev_guest(vcpu->kvm))
+		return true;
+
 	/*
-	 * When the guest is an SEV-ES guest, emulation is not possible.
+	 * Emulation is impossible for SEV-ES guests as KVM doesn't have access
+	 * to guest register state.
 	 */
 	if (sev_es_guest(vcpu->kvm))
 		return false;
@@ -4518,9 +4523,6 @@ static bool svm_can_emulate_instruction(
 	smap = cr4 & X86_CR4_SMAP;
 	is_user = svm_get_cpl(vcpu) == 3;
 	if (smap && (!smep || is_user)) {
-		if (!sev_guest(vcpu->kvm))
-			return true;
-
 		pr_err_ratelimited("KVM: SEV Guest triggered AMD Erratum 1096\n");
 		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
 	}


