Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1763D59A375
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353845AbiHSQou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353720AbiHSQnP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:43:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329DD111C23;
        Fri, 19 Aug 2022 09:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93690B8281A;
        Fri, 19 Aug 2022 16:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB256C433C1;
        Fri, 19 Aug 2022 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925466;
        bh=MeueB1VICeYwOx5V+NEyLArwKuISXywHXupW8fCtY8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lbXGT/kP41TFPA1fXHnT27O00xVJw4nx5kLSvD2uj6BstwISVzZ7ORG9egspt/Id4
         jt/c8PMYAmsPGin2G1AmxbQA1eATc5pJUS824agFLoQsAIuyiLllwzhMg70jY2J+Bc
         2dAcsQc+2KQxDcftUhkxRKqmDXmyBg1rn631Bu6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stas Sergeev <stsp@users.sourceforge.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 499/545] KVM: VMX: Drop guest CPUID check for VMXE in vmx_set_cr4()
Date:   Fri, 19 Aug 2022 17:44:29 +0200
Message-Id: <20220819153851.818824528@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit d3a9e4146a6f79f19430bca3f2a4d6ebaaffe36b ]

Drop vmx_set_cr4()'s somewhat hidden guest_cpuid_has() check on VMXE now
that common x86 handles the check by incorporating VMXE into the CR4
reserved bits, i.e. in cr4_guest_rsvd_bits.  This fixes a bug where KVM
incorrectly rejects KVM_SET_SREGS with CR4.VMXE=1 if it's executed
before KVM_SET_CPUID{,2}.

Fixes: 5e1746d6205d ("KVM: nVMX: Allow setting the VMXE bit in CR4")
Reported-by: Stas Sergeev <stsp@users.sourceforge.net>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20201007014417.29276-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9b520da3f748..1b75847d8a49 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3217,9 +3217,10 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		 * must first be able to turn on cr4.VMXE (see handle_vmon()).
 		 * So basically the check on whether to allow nested VMX
 		 * is here.  We operate under the default treatment of SMM,
-		 * so VMX cannot be enabled under SMM.
+		 * so VMX cannot be enabled under SMM.  Note, guest CPUID is
+		 * intentionally ignored, it's handled by cr4_guest_rsvd_bits.
 		 */
-		if (!nested_vmx_allowed(vcpu) || is_smm(vcpu))
+		if (!nested || is_smm(vcpu))
 			return 1;
 	}
 
-- 
2.35.1



