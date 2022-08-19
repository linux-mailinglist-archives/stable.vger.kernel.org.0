Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7271F59A49B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354068AbiHSQv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:51:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354397AbiHSQuw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:50:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42305F6D;
        Fri, 19 Aug 2022 09:13:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F2782B8281D;
        Fri, 19 Aug 2022 16:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292EDC433D6;
        Fri, 19 Aug 2022 16:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925584;
        bh=dOoWnsvMMVAssrMgIJ0fbTL79FfYAb3Cj9CXtb/C70U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRzOQ3Tjv9v96M5n4WUEQWYQWqCsaVXTbbHGMsECOLs4jCSmNZ0mQs2UoBnzK+kfl
         Zy/e4fZxckBrtpbIXpiP19Sqx+CxUIa9Bik+CchuXMqoIt//puznlSpKF1ZMp1stMn
         qB1Xp6kMdhY8Rwclo3svgARXxoKXJZ2Q4Eijbw8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 508/545] KVM: VMX: Mark all PERF_GLOBAL_(OVF)_CTRL bits reserved if theres no vPMU
Date:   Fri, 19 Aug 2022 17:44:38 +0200
Message-Id: <20220819153852.218541464@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

[ Upstream commit 93255bf92939d948bc86d81c6bb70bb0fecc5db1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/pmu_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index ea5a7056fdfd..e73378b6f10c 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -335,6 +335,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
 	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
+	pmu->global_ctrl_mask = ~0ull;
+	pmu->global_ovf_ctrl_mask = ~0ull;
 	pmu->fixed_ctr_ctrl_mask = ~0ull;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
-- 
2.35.1



