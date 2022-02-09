Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6004AFC6E
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 19:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241369AbiBIS6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 13:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241599AbiBIS50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 13:57:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB510C050CEB;
        Wed,  9 Feb 2022 10:57:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61DDAB82385;
        Wed,  9 Feb 2022 18:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB947C340EE;
        Wed,  9 Feb 2022 18:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644433040;
        bh=WxH1Jvs2nKiTr7Ngr070ShsLHsw6r7eBxqgxaRmGV10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8CnZEdBkQ5NkO0f3IEWvxZ+9Cx6bzaiJwjwtQSYEOfytK4Dkucg5xs1cZyNY/T9/
         q1Lr4l4p4vKSTCIDfX41rfuc7JsXCNgz0A6OLr+2k7F4QINIrMYLFWJPvzGRG7xKBA
         I3sH8O6d6jZ9/nKhAIxPKslp1EARgU1okqVWQpnzAYHmsnbZ4WScOvIs9ujwTIgSpa
         uJn81dCuuUURCjdSP60iFkQpOKCjWzOfERqU7pVaxmV4rmO92d4jwmVeUZKWNrIv4o
         9EPeBZ/xIvm+lvJXIPuuE54IS0uNqOvm0rpqFmzhwpO9Q0QzXyN7HNaYOZPgIJVCAY
         Bz+p6z8PlTuOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 2/6] KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER
Date:   Wed,  9 Feb 2022 13:57:09 -0500
Message-Id: <20220209185714.48936-2-sashal@kernel.org>
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
index bd41d9462355f..011929a638230 100644
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

