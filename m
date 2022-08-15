Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5065943FA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348443AbiHOWaH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349546AbiHOW0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:26:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D091272F7;
        Mon, 15 Aug 2022 12:44:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7629CB80EAD;
        Mon, 15 Aug 2022 19:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFD9C433D7;
        Mon, 15 Aug 2022 19:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592680;
        bh=kJiAJLBI1zI4upGRqmYNzAq/cmr+YVYjwMY4ik5mLsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=msf7ebpSh+ffhLZQZr2U1t6CoY9OYXTUQYdCW+U0jxzfHceJ7+Av1AlG/k1u45tuo
         beHguJRKqiY6Hjhd52m2GweuRQ+jyLQFFlQ5E125MMZPXAOlYLxsy2BgOC6/eDd1Oj
         pEoVXY4sqPELt3OQatVNx6i412fP9o/XHsVN852k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0797/1095] KVM: nVMX: Set UMIP bit CR4_FIXED1 MSR when emulating UMIP
Date:   Mon, 15 Aug 2022 20:03:16 +0200
Message-Id: <20220815180502.226505304@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

[ Upstream commit a910b5ab6b250a88fff1866bf708642d83317466 ]

Make UMIP an "allowed-1" bit CR4_FIXED1 MSR when KVM is emulating UMIP.
KVM emulates UMIP for both L1 and L2, and so should enumerate that L2 is
allowed to have CR4.UMIP=1.  Not setting the bit doesn't immediately
break nVMX, as KVM does set/clear the bit in CR4_FIXED1 in response to a
guest CPUID update, i.e. KVM will correctly (dis)allow nested VM-Entry
based on whether or not UMIP is exposed to L1.  That said, KVM should
enumerate the bit as being allowed from time zero, e.g. userspace will
see the wrong value if the MSR is read before CPUID is written.

Fixes: 0367f205a3b7 ("KVM: vmx: add support for emulating UMIP")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220607213604.3346000-12-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c632df13ada2..aa287302f991 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6790,6 +6790,9 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 	rdmsrl(MSR_IA32_VMX_CR0_FIXED1, msrs->cr0_fixed1);
 	rdmsrl(MSR_IA32_VMX_CR4_FIXED1, msrs->cr4_fixed1);
 
+	if (vmx_umip_emulated())
+		msrs->cr4_fixed1 |= X86_CR4_UMIP;
+
 	msrs->vmcs_enum = nested_vmx_calc_vmcs_enum_msr();
 }
 
-- 
2.35.1



