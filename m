Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7734F30B1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245418AbiDEIzk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238734AbiDEIa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:30:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99BCE0B0;
        Tue,  5 Apr 2022 01:22:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8138FB81BAF;
        Tue,  5 Apr 2022 08:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E015BC385A0;
        Tue,  5 Apr 2022 08:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146963;
        bh=ppawhTxMMMVcV1N7BeWGj9uOleWrybjfaO/20N1Ey08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DolGDmwQtqbe9xtqg9ruOr/7ZhWzWjhnZ4UdJvgbx5dXI1fXfPIlt28Ohxu9Vpd5t
         FJHQx/EnfNfYm56Zs1LuIAUtDA+fBSKPJGxl1oarWtm8c3pu5szpbVwsMaYJM3UwKo
         QBZWZbLCDYQBuxHWrJ5zFXDWrd9xP5JnAIVxSLew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 0951/1126] KVM: x86: Reinitialize context if host userspace toggles EFER.LME
Date:   Tue,  5 Apr 2022 09:28:18 +0200
Message-Id: <20220405070435.418687174@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -48,6 +48,7 @@
 			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
+#define KVM_MMU_EFER_ROLE_BITS (EFER_LME | EFER_NX)
 
 static __always_inline u64 rsvd_bits(int s, int e)
 {
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1656,8 +1656,7 @@ static int set_efer(struct kvm_vcpu *vcp
 		return r;
 	}
 
-	/* Update reserved bits */
-	if ((efer ^ old_efer) & EFER_NX)
+	if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
 		kvm_mmu_reset_context(vcpu);
 
 	return 0;


