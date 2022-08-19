Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8323659A3C7
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353838AbiHSQqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353966AbiHSQpd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6043512A1D3;
        Fri, 19 Aug 2022 09:11:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6964B82822;
        Fri, 19 Aug 2022 16:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABE5C433D7;
        Fri, 19 Aug 2022 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925472;
        bh=m12qmVYfHBX0x5j74m/PMuBKWQQgC3NVEWHrfsdh0Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10NN1a2uGUES14nB2Rk2kKvB1pQTkZXRX/zq9bt1KEW1fxz5F4NoGw/dS6/Vlk1by
         JdIL4qCDUS92fW0NIPIyBXwN1Pdss0HOQSrYzoSjk+TYb8zGXB/hnLLbGA3Ggeskp+
         XBox7zJs/veQLjnr++FmMoqGHmMqEhpXT1SWrd8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 500/545] KVM: VMX: Drop explicit nested check from vmx_set_cr4()
Date:   Fri, 19 Aug 2022 17:44:30 +0200
Message-Id: <20220819153851.866986742@linuxfoundation.org>
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

[ Upstream commit a447e38a7fadb2e554c3942dda183e55cccd5df0 ]

Drop vmx_set_cr4()'s explicit check on the 'nested' module param now
that common x86 handles the check by incorporating VMXE into the CR4
reserved bits, via kvm_cpu_caps.  X86_FEATURE_VMX is set in kvm_cpu_caps
(by vmx_set_cpu_caps()), if and only if 'nested' is true.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20201007014417.29276-3-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b75847d8a49..154ec5d8cdf5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3211,18 +3211,13 @@ int vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 		}
 	}
 
-	if (cr4 & X86_CR4_VMXE) {
-		/*
-		 * To use VMXON (and later other VMX instructions), a guest
-		 * must first be able to turn on cr4.VMXE (see handle_vmon()).
-		 * So basically the check on whether to allow nested VMX
-		 * is here.  We operate under the default treatment of SMM,
-		 * so VMX cannot be enabled under SMM.  Note, guest CPUID is
-		 * intentionally ignored, it's handled by cr4_guest_rsvd_bits.
-		 */
-		if (!nested || is_smm(vcpu))
-			return 1;
-	}
+	/*
+	 * We operate under the default treatment of SMM, so VMX cannot be
+	 * enabled under SMM.  Note, whether or not VMXE is allowed at all is
+	 * handled by kvm_valid_cr4().
+	 */
+	if ((cr4 & X86_CR4_VMXE) && is_smm(vcpu))
+		return 1;
 
 	if (vmx->nested.vmxon && !nested_cr4_valid(vcpu, cr4))
 		return 1;
-- 
2.35.1



