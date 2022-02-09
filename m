Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5AB4AFC6A
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbiBIS66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241397AbiBIS50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:57:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2873C050CFA;
        Wed,  9 Feb 2022 10:57:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5DA2CB8238C;
        Wed,  9 Feb 2022 18:57:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB4CC340E7;
        Wed,  9 Feb 2022 18:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433042;
        bh=o/sKIMrGLrAkYp8Q+KzdWoLa4OteYk6nG3L46DZRWxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiYgbOwIATjxhzgXClZddYE+2HuhSgTexjNdAvKGgpZY4h8R5kz0iSfiJ10ZTE+t9
         o36ixpuCj/gyZXhoe9IynP95ZFkxTElksdGqi0aWMTqPQd7Bo/hsEy7C0+DEKXgxgO
         ENU1Kr7gow4BLNT4YjCeZ4peQyNYXQVWNb228Vkg6SbMIAl37UnoXrZNucmCINpWlq
         SfLEaxrMNe/b4wzlQW+gjmyai1tyk1IY83gfgjUxmeQSYnCot73bRXFn2teU9LPttP
         53JQbiFmg5/Nfh0BhQ3m9ZpvVnObMUoW4QACY42lPf0S1uwHD8UJAJnWW+g6yuuqXm
         xYMAbccc0/uYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 3/6] KVM: nVMX: Also filter MSR_IA32_VMX_TRUE_PINBASED_CTLS when eVMCS
Date:   Wed,  9 Feb 2022 13:57:10 -0500
Message-Id: <20220209185714.48936-3-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220209185714.48936-1-sashal@kernel.org>
References: <20220209185714.48936-1-sashal@kernel.org>
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
index c0d6fee9225fe..5b68034ec5f9c 100644
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

