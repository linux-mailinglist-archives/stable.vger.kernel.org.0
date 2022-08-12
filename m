Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64AB4591300
	for <lists+stable@lfdr.de>; Fri, 12 Aug 2022 17:33:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiHLPdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Aug 2022 11:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiHLPcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Aug 2022 11:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CDBB7C2
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 08:32:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B1CD60918
        for <stable@vger.kernel.org>; Fri, 12 Aug 2022 15:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82088C433C1;
        Fri, 12 Aug 2022 15:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660318370;
        bh=1dsS+2VApFnKAqlEXtKTFEjk5a7F2w+MPSpiMVCPlkI=;
        h=Subject:To:Cc:From:Date:From;
        b=WMzrCs8fpstitdtftO6u3Y9iRqQMwHa+21ykj8q4BkOjiOKDQK1ihOYk4AvM64lt0
         neUlv/YGjtBlICg5P1DPkdZUmI/T0kfL6a8eY7LjKUw92yrttbyoWCgzYidCRmYHZb
         5hapnnv4OyEufFVmAybX1Ntkf0JdnDRG7D4IoeMQ=
Subject: FAILED: patch "[PATCH] KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if" failed to apply to 5.18-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 12 Aug 2022 17:32:41 +0200
Message-ID: <1660318361227219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.18-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 93255bf92939d948bc86d81c6bb70bb0fecc5db1 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Fri, 22 Jul 2022 22:44:06 +0000
Subject: [PATCH] KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if
 there's no vPMU

Mark all MSR_CORE_PERF_GLOBAL_CTRL and MSR_CORE_PERF_GLOBAL_OVF_CTRL bits
as reserved if there is no guest vPMU.  The nVMX VM-Entry consistency
checks do not check for a valid vPMU prior to consuming the masks via
kvm_valid_perf_global_ctrl(), i.e. may incorrectly allow a non-zero mask
to be loaded via VM-Enter or VM-Exit (well, attempted to be loaded, the
actual MSR load will be rejected by intel_is_valid_msr()).

Fixes: f5132b01386b ("KVM: Expose a version 2 architectural PMU to a guests")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220722224409.1336532-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4bc098fbec31..6e355c5d2f40 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -527,6 +527,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
+	pmu->global_ctrl_mask = ~0ull;
+	pmu->global_ovf_ctrl_mask = ~0ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 	pmu->pebs_enable_mask = ~0ull;
 	pmu->pebs_data_cfg_mask = ~0ull;

