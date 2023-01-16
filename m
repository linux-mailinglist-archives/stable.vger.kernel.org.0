Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B407866C928
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjAPQqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:46:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbjAPQqA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:46:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52041DB80
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:33:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62B006105A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C256C433F0;
        Mon, 16 Jan 2023 16:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886835;
        bh=JdSCoMMrjIqGKT0LpQELer+ffb1siJMjsmAxRVfATfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGPHmqXoWsYtKmqdp8gGDwI6i88LrpOUS2DfQiCeZAjLz+R524LnAI6QWI1G2KUgH
         NqVpzzz62had4oZdvVVar7jGmLtJYo9Pkb5D5vslsHLv+dIJATpB2LHIXDc2/uwnRq
         q+peXbttxk+QteLqMrmK/UU+rspumwbDXDEdTtbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Aaron Lewis <aaronlewis@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 551/658] KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1
Date:   Mon, 16 Jan 2023 16:50:39 +0100
Message-Id: <20230116154934.733798917@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 31de69f4eea77b28a9724b3fa55aae104fc91fc7 ]

Set ENABLE_USR_WAIT_PAUSE in KVM's supported VMX MSR configuration if the
feature is supported in hardware and enabled in KVM's base, non-nested
configuration, i.e. expose ENABLE_USR_WAIT_PAUSE to L1 if it's supported.
This fixes a bug where saving/restoring, i.e. migrating, a vCPU will fail
if WAITPKG (the associated CPUID feature) is enabled for the vCPU, and
obviously allows L1 to enable the feature for L2.

KVM already effectively exposes ENABLE_USR_WAIT_PAUSE to L1 by stuffing
the allowed-1 control ina vCPU's virtual MSR_IA32_VMX_PROCBASED_CTLS2 when
updating secondary controls in response to KVM_SET_CPUID(2), but (a) that
depends on flawed code (KVM shouldn't touch VMX MSRs in response to CPUID
updates) and (b) runs afoul of vmx_restore_control_msr()'s restriction
that the guest value must be a strict subset of the supported host value.

Although no past commit explicitly enabled nested support for WAITPKG,
doing so is safe and functionally correct from an architectural
perspective as no additional KVM support is needed to virtualize TPAUSE,
UMONITOR, and UMWAIT for L2 relative to L1, and KVM already forwards
VM-Exits to L1 as necessary (commit bf653b78f960, "KVM: vmx: Introduce
handle_unexpected_vmexit and handle WAITPKG vmexit").

Note, KVM always keeps the hosts MSR_IA32_UMWAIT_CONTROL resident in
hardware, i.e. always runs both L1 and L2 with the host's power management
settings for TPAUSE and UMWAIT.  See commit bf09fb6cba4f ("KVM: VMX: Stop
context switching MSR_IA32_UMWAIT_CONTROL") for more details.

Fixes: e69e72faa3a0 ("KVM: x86: Add support for user wait instructions")
Cc: stable@vger.kernel.org
Reported-by: Aaron Lewis <aaronlewis@google.com>
Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-Id: <20221213062306.667649-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1dd693d18395..00f3336194a9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5916,7 +5916,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
 		SECONDARY_EXEC_RDRAND_EXITING |
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
-		SECONDARY_EXEC_XSAVES;
+		SECONDARY_EXEC_XSAVES |
+		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
-- 
2.35.1



