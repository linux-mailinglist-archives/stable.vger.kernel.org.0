Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815BD4F3937
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377724AbiDELaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352745AbiDEKFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:05:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45974BBE31;
        Tue,  5 Apr 2022 02:53:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2854AB81B13;
        Tue,  5 Apr 2022 09:53:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEBAC385A2;
        Tue,  5 Apr 2022 09:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152422;
        bh=tTRgRGkVhs4MQfo1x1AjnjCGjBN5nYhl1z3dsRALaTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O2e9IrvfhCdQqaowO+qnU2S1/3Y5vu4AHaE3CGYMjwTS8Y08wVs/cscrkJikURyvQ
         Vq18RikC6kKRFwOZqfCEy7pmr9yumz/CH1yfoixR/t2gbETbiQ8K2pK/XFpyt7doB9
         /awonEX42JmwSLLNv97p2rCKle9W6Xk85id4AoUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 770/913] KVM: x86: Reinitialize context if host userspace toggles EFER.LME
Date:   Tue,  5 Apr 2022 09:30:32 +0200
Message-Id: <20220405070402.913373835@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Paolo Bonzini <pbonzini@redhat.com>

commit d6174299365ddbbf491620c0b8c5ca1a6ef2eea5 upstream.

While the guest runs, EFER.LME cannot change unless CR0.PG is clear, and
therefore EFER.NX is the only bit that can affect the MMU role.  However,
set_efer accepts a host-initiated change to EFER.LME even with CR0.PG=1.
In that case, the MMU has to be reset.

Fixes: 11988499e62b ("KVM: x86: Skip EFER vs. guest CPUID checks for host-initiated writes")
Cc: stable@vger.kernel.org
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/mmu.h |    1 +
 arch/x86/kvm/x86.c |    3 +--
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -49,6 +49,7 @@
 			       X86_CR4_LA57)
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
+#define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
 
 static __always_inline u64 rsvd_bits(int s, int e)
 {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1605,8 +1605,7 @@ static int set_efer(struct kvm_vcpu *vcp
 		return r;
 	}
 
-	/* Update reserved bits */
-	if ((efer ^ old_efer) & EFER_NX)
+	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
 
 	return 0;


