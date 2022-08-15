Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B95593C9A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344510AbiHOTvy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345447AbiHOTvM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:51:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E0B73920;
        Mon, 15 Aug 2022 11:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EAB260C0B;
        Mon, 15 Aug 2022 18:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C782C433D7;
        Mon, 15 Aug 2022 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589406;
        bh=8XzudxK/GSx4m9rQfdc62GIvbtc4ybw1doK19hUJQ7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UEji6HJ04i5hCnlTUfexXbGMQ2b/3Je23muWXSlyGNiAP3cyh4KJgZ7wdGJxMW0Ar
         XL4LWYOA1mN4vQA2+faIzNsrl7alMY/XSiwLzECoWLOm5hFD8DiT2F/4kaRiEVACe8
         cg7xHZ39AOYpl+GjC18QEupdGyV6yb3e7qcvYLzg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 709/779] KVM: x86: Signal #GP, not -EPERM, on bad WRMSR(MCi_CTL/STATUS)
Date:   Mon, 15 Aug 2022 20:05:53 +0200
Message-Id: <20220815180407.739335099@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit 2368048bf5c2ec4b604ac3431564071e89a0bc71 ]

Return '1', not '-1', when handling an illegal WRMSR to a MCi_CTL or
MCi_STATUS MSR.  The behavior of "all zeros' or "all ones" for CTL MSRs
is architectural, as is the "only zeros" behavior for STATUS MSRs.  I.e.
the intent is to inject a #GP, not exit to userspace due to an unhandled
emulation case.  Returning '-1' gets interpreted as -EPERM up the stack
and effecitvely kills the guest.

Fixes: 890ca9aefa78 ("KVM: Add MCE support")
Fixes: 9ffd986c6e4e ("KVM: X86: #GP when guest attempts to write MCi_STATUS register w/o 0")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Link: https://lore.kernel.org/r/20220512222716.4112548-2-seanjc@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dac2892d095c..f5b7a05530eb 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3109,13 +3109,13 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			 */
 			if ((offset & 0x3) == 0 &&
 			    data != 0 && (data | (1 << 10) | 1) != ~(u64)0)
-				return -1;
+				return 1;
 
 			/* MCi_STATUS */
 			if (!msr_info->host_initiated &&
 			    (offset & 0x3) == 1 && data != 0) {
 				if (!can_set_mci_status(vcpu))
-					return -1;
+					return 1;
 			}
 
 			vcpu->arch.mce_banks[offset] = data;
-- 
2.35.1



