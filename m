Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048184B4BCE
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344142AbiBNKCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:02:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345366AbiBNKBg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:01:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA9714082;
        Mon, 14 Feb 2022 01:47:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8FA861238;
        Mon, 14 Feb 2022 09:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD5BCC340E9;
        Mon, 14 Feb 2022 09:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832066;
        bh=LLJn431NWz2Op/hN3e1rQHFby3XMCjd85OUZKwq7C3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VQmlTFk72crs9Ppmm6+AQfCBiHlML5q7NWz7cYjfWnHpQarP474CzE8TGC7260ipy
         NV6vur5nuX66eGDoK+ltOnaiRVgEUXMaqNuBf2c1BZBd3Kz1l3notdvLO3b/qhJqXP
         ewXeFqy+OttL7tZ2Ze60AllC/iOzlkLroWBpA1G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/172] KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Date:   Mon, 14 Feb 2022 10:25:19 +0100
Message-Id: <20220214092508.503747049@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
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

[ Upstream commit 7a601e2cf61558dfd534a9ecaad09f5853ad8204 ]

Enlightened VMCS v1 doesn't have VMX_PREEMPTION_TIMER_VALUE field,
PIN_BASED_VMX_PREEMPTION_TIMER is also filtered out already so it makes
sense to filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER too.

Note, none of the currently existing Windows/Hyper-V versions are known
to enable 'save VMX-preemption timer value' when eVMCS is in use, the
change is aimed at making the filtering future proof.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220112170134.1904308-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/evmcs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/evmcs.h b/arch/x86/kvm/vmx/evmcs.h
index 152ab0aa82cf6..b43976e4b9636 100644
--- a/arch/x86/kvm/vmx/evmcs.h
+++ b/arch/x86/kvm/vmx/evmcs.h
@@ -59,7 +59,9 @@ DECLARE_STATIC_KEY_FALSE(enable_evmcs);
 	 SECONDARY_EXEC_SHADOW_VMCS |					\
 	 SECONDARY_EXEC_TSC_SCALING |					\
 	 SECONDARY_EXEC_PAUSE_LOOP_EXITING)
-#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL (VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
+#define EVMCS1_UNSUPPORTED_VMEXIT_CTRL					\
+	(VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL |				\
+	 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER)
 #define EVMCS1_UNSUPPORTED_VMENTRY_CTRL (VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)
 #define EVMCS1_UNSUPPORTED_VMFUNC (VMX_VMFUNC_EPTP_SWITCHING)
 
-- 
2.34.1



