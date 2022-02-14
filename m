Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231B64B4AFA
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346449AbiBNK1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346512AbiBNKZE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:25:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED596D1A3;
        Mon, 14 Feb 2022 01:56:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A6FD61460;
        Mon, 14 Feb 2022 09:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4937C340E9;
        Mon, 14 Feb 2022 09:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832613;
        bh=nFogxA/LDVBd0MRKb6HyR9kxQCK/ufUVnj0yDYGaXbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q9T86zntJaKgn8caN61DUEyMdkjCmXJAlCH5nSRPQgpy1sUgH3TMYfr7kFBOUCSSI
         ZolYuK/olD+nEj8NVxWcLQXsVcq2HnvZf2WwYDEuaem213KFugHKuh/NEH0PGKWRyj
         dgTtETxFF4RBPdJTl3apxrHzMzN34X5U8Rc6TvAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 069/203] KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Date:   Mon, 14 Feb 2022 10:25:13 +0100
Message-Id: <20220214092512.613921612@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

[ Upstream commit f80ae0ef089a09e8c18da43a382c3caac9a424a7 ]

Similar to MSR_IA32_VMX_EXIT_CTLS/MSR_IA32_VMX_TRUE_EXIT_CTLS,
MSR_IA32_VMX_ENTRY_CTLS/MSR_IA32_VMX_TRUE_ENTRY_CTLS pair,
MSR_IA32_VMX_TRUE_PINBASED_CTLS needs to be filtered the same way
MSR_IA32_VMX_PINBASED_CTLS is currently filtered as guests may solely rely
on 'true' MSR data.

Note, none of the currently existing Windows/Hyper-V versions are known
to stumble upon the unfiltered MSR_IA32_VMX_TRUE_PINBASED_CTLS, the change
is aimed at making the filtering future proof.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220112170134.1904308-2-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/evmcs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/evmcs.c b/arch/x86/kvm/vmx/evmcs.c
index 09fac0ddac8bd..87e3dc10edf40 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -361,6 +361,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
 		break;
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 		break;
-- 
2.34.1



