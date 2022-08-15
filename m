Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9818F594283
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244311AbiHOVvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:51:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350285AbiHOVu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:50:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D83DEB7D;
        Mon, 15 Aug 2022 12:32:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 967A6B80FD3;
        Mon, 15 Aug 2022 19:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3291C433D6;
        Mon, 15 Aug 2022 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591942;
        bh=RIXvlqtErnqUU+6Rz5r6bqonG4MImcLLPCMCxhVxYak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gVudz0XcvtFdoKs2UH7LtgyjxoH0EgXd3/6idn3t+GtQ54+yrdBrrweaeppHs6fst
         MbrRMn67yowA0kzbt8n09eb9qkGrmGxzW4WF2yReN4H/jMQbYsnKFTPdmtGODTr1RH
         I4LHmlGa2qEUEgU+qtwMipmLLleBM/HEv68/3YQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.19 0034/1157] KVM: nVMX: Account for KVM reserved CR4 bits in consistency checks
Date:   Mon, 15 Aug 2022 19:49:50 +0200
Message-Id: <20220815180440.799547938@linuxfoundation.org>
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

commit ca58f3aa53d165afe4ab74c755bc2f6d168617ac upstream.

Check that the guest (L2) and host (L1) CR4 values that would be loaded
by nested VM-Enter and VM-Exit respectively are valid with respect to
KVM's (L0 host) allowed CR4 bits.  Failure to check KVM reserved bits
would allow L1 to load an illegal CR4 (or trigger hardware VM-Fail or
failed VM-Entry) by massaging guest CPUID to allow features that are not
supported by KVM.  Amusingly, KVM itself is an accomplice in its doom, as
KVM adjusts L1's MSR_IA32_VMX_CR4_FIXED1 to allow L1 to enable bits for
L2 based on L1's CPUID model.

Note, although nested_{guest,host}_cr4_valid() are _currently_ used if
and only if the vCPU is post-VMXON (nested.vmxon == true), that may not
be true in the future, e.g. emulating VMXON has a bug where it doesn't
check the allowed/required CR0/CR4 bits.

Cc: stable@vger.kernel.org
Fixes: 3899152ccbf4 ("KVM: nVMX: fix checks on CR{0,4} during virtual VMX operation")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220607213604.3346000-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/nested.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -281,7 +281,8 @@ static inline bool nested_cr4_valid(stru
 	u64 fixed0 = to_vmx(vcpu)->nested.msrs.cr4_fixed0;
 	u64 fixed1 = to_vmx(vcpu)->nested.msrs.cr4_fixed1;
 
-	return fixed_bits_valid(val, fixed0, fixed1);
+	return fixed_bits_valid(val, fixed0, fixed1) &&
+	       __kvm_is_valid_cr4(vcpu, val);
 }
 
 /* No difference in the restrictions on guest and host CR4 in VMX operation. */


