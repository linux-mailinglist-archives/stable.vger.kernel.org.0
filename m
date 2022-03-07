Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408FB4CF6EB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbiCGJn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:43:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240558AbiCGJlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A3715A05;
        Mon,  7 Mar 2022 01:37:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61372611D5;
        Mon,  7 Mar 2022 09:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64442C340E9;
        Mon,  7 Mar 2022 09:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645858;
        bh=XC2dYqop3svzaK/jPsZIDCG3s790ZpIO28tWyxJ4SzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ij87L2xmUqrWr+aK6YDXj+UjWhmQN0DPaR7u7tZVkkorwqDT661fiS8ZBuDhn7lKZ
         ww+zC1frWH8ZZ4B16grZp0DtFCopmCIL95dfFXVcJ6jUDYcuuWqihIC2hjRONkf4z9
         Uq30V26sitzJJT4TmXwRVg6UFATr2jjCvwP8x5pU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/262] KVM: x86: Handle 32-bit wrap of EIP for EMULTYPE_SKIP with flat code seg
Date:   Mon,  7 Mar 2022 10:16:43 +0100
Message-Id: <20220307091704.176390443@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 33457b27e220b..6b76486702ded 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7999,7 +7999,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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



