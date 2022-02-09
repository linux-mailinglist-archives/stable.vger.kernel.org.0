Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503114AFC50
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbiBIS5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241309AbiBIS5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:57:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C162FC05CBA1;
        Wed,  9 Feb 2022 10:57:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80BE9B82378;
        Wed,  9 Feb 2022 18:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3554BC340F0;
        Wed,  9 Feb 2022 18:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433020;
        bh=dd6WbKNZ33w+gnV1v1eV3MJ6z2zoizjcLKhUjHLvfUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQiDCe1qqCWHFqU1dPjYVnnW/W3i+GrUj3RPue9FcLU/faBXTtJn4wV95Pj1nHAaF
         2byJTKNnlV1OP6VOAi90WSxpf3q39TZRHh7hqofVaN9J3NZ7ACpz72IKCzJvOowzL/
         Oqwj/PDheFb8K9x1qeAJ77nCwyTGJyFzXf4bida+FyD1uVkzl63K8diLTWI6uxbybH
         +ZX8T0rICSZjXRtd2v/WaxEnKn0BV4nEfgpgnE7BFhJ/2g7GoPD0d7c5cmK86Gl25j
         ww7427ZUiylAzpYM9pNMy2Y6ghuWPYKU4N1ptn7L+0Ue07dYwoICkWrlkUa/N3iPIK
         P+GN7X/yEbnAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15 3/8] KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Date:   Wed,  9 Feb 2022 13:56:48 -0500
Message-Id: <20220209185653.48833-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209185653.48833-1-sashal@kernel.org>
References: <20220209185653.48833-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index ba6f99f584ac3..a7ed30d5647af 100644
--- a/arch/x86/kvm/vmx/evmcs.c
+++ b/arch/x86/kvm/vmx/evmcs.c
@@ -362,6 +362,7 @@ void nested_evmcs_filter_control_msr(u32 msr_index, u64 *pdata)
 	case MSR_IA32_VMX_PROCBASED_CTLS2:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_2NDEXEC;
 		break;
+	case MSR_IA32_VMX_TRUE_PINBASED_CTLS:
 	case MSR_IA32_VMX_PINBASED_CTLS:
 		ctl_high &= ~EVMCS1_UNSUPPORTED_PINCTRL;
 		break;
-- 
2.34.1

