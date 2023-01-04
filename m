Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AD865D50C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 15:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbjADOIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 09:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239454AbjADOH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 09:07:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F92C1CFC7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 06:07:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7537B8133A
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 14:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241D9C433EF;
        Wed,  4 Jan 2023 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672841274;
        bh=V/FUHZ/G00g+7KAsiztLOeEORcPR0qCicUNFG9RoPX0=;
        h=Subject:To:Cc:From:Date:From;
        b=gYzieRaRPskyMvSaVVq36MeHwV8lpOWcIsOKFDccbbG6cgjnT1dftG9V504iiivLX
         x1ou2Jm09cVJYbxRc8FITZKLQgug1Li8LpbBzJdx9Toj4RANjWKgnJawdIhigJUESg
         uuHRQEElAvJX30vtuuGHDQDxrr25QWKqqQnpOFDc=
Subject: FAILED: patch "[PATCH] KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to" failed to apply to 5.10-stable tree
To:     seanjc@google.com, aaronlewis@google.com, jmattson@google.com,
        pbonzini@redhat.com, yu.c.zhang@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 15:07:51 +0100
Message-ID: <16728412715726@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

31de69f4eea7 ("KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to L1")
d041b5ea9335 ("KVM: nVMX: Enable nested TSC scaling")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 31de69f4eea77b28a9724b3fa55aae104fc91fc7 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 13 Dec 2022 06:23:03 +0000
Subject: [PATCH] KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE control to
 L1

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

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f18f3a9f0943..d93c715cda6a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6882,7 +6882,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES |
-		SECONDARY_EXEC_TSC_SCALING;
+		SECONDARY_EXEC_TSC_SCALING |
+		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware

