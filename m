Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC5F949A4B7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369583AbiAYACN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458150AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B51BC01D7FF;
        Mon, 24 Jan 2022 13:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2846E61305;
        Mon, 24 Jan 2022 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D5CC340E4;
        Mon, 24 Jan 2022 21:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059962;
        bh=vV8dMG+wgDd6ixe70t0hx35EAlauBYI8+Djh336oDOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qMH8R9DYc4y8bIFCcdIeYFeHgBwmLMry5PmBmQl97k/VoQPaEOWg6MoDU7GEHIe4H
         psnYfLp8CXdQ0a7VcMVBbHzNWsqWOoxjvmCHdv2ozj8AJp3LQHWJB3VFK+zuXuZZRB
         17gV8rRJVy2y4ZwTJqZ0RHdVFBlT0f/VvYMMvpNk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0792/1039] KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with flat code seg
Date:   Mon, 24 Jan 2022 19:43:01 +0100
Message-Id: <20220124184151.922433858@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 5e854864ee4384736f27a986633bae21731a4e4e ]

Truncate the new EIP to a 32-bit value when handling EMULTYPE_SKIP as the
decode phase does not truncate _eip.  Wrapping the 32-bit boundary is
legal if and only if CS is a flat code segment, but that check is
implicitly handled in the form of limit checks in the decode phase.

Opportunstically prepare for a future fix by storing the result of any
truncation in "eip" instead of "_eip".

Fixes: 1957aa63be53 ("KVM: VMX: Handle single-step #DB for EMULTYPE_SKIP on EPT misconfig")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <093eabb1eab2965201c9b018373baf26ff256d85.1635842679.git.houwenlong93@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb87f43cdc78c..5d5a8e75edcb7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8134,7 +8134,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * updating interruptibility state and injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
-		kvm_rip_write(vcpu, ctxt->_eip);
+		if (ctxt->mode != X86EMUL_MODE_PROT64)
+			ctxt->eip = (u32)ctxt->_eip;
+		else
+			ctxt->eip = ctxt->_eip;
+
+		kvm_rip_write(vcpu, ctxt->eip);
 		if (ctxt->eflags & X86_EFLAGS_RF)
 			kvm_set_rflags(vcpu, ctxt->eflags & ~X86_EFLAGS_RF);
 		return 1;
-- 
2.34.1



