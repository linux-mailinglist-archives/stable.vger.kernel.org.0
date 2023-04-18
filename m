Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB7E6E6462
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbjDRMsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbjDRMsl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:48:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95BBF15A13
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77345633E0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5D4C433D2;
        Tue, 18 Apr 2023 12:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822108;
        bh=4noMoL3Rn3mAiu1I8A8tQpGc7vuKqFTSM8ZgM1Oxfa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1UWxw6EHCTV25sbXhQ7XG8o1FlVp63pLfBjGxE5hSOlqmXst0u2DemPgLiJsOobO
         FdvG0KuGxGCsanIwvwIgn/QLMTFzUwYO9MXWidXueq7BD5pkqqwq6oMBswrLLR6nSs
         /mNHofGAwfDCYj2CC3rv1rBipDrh01w4mws4qXSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.2 025/139] KVM: arm64: PMU: Restore the guests EL0 event counting after migration
Date:   Tue, 18 Apr 2023 14:21:30 +0200
Message-Id: <20230418120314.596622309@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

commit f9ea835e99bc8d049bf2a3ec8fa5a7cb4fcade23 upstream.

Currently, with VHE, KVM enables the EL0 event counting for the
guest on vcpu_load() or KVM enables it as a part of the PMU
register emulation process, when needed.  However, in the migration
case (with VHE), the same handling is lacking, as vPMU register
values that were restored by userspace haven't been propagated yet
(the PMU events haven't been created) at the vcpu load-time on the
first KVM_RUN (kvm_vcpu_pmu_restore_guest() called from vcpu_load()
on the first KVM_RUN won't do anything as events_{guest,host} of
kvm_pmu_events are still zero).

So, with VHE, enable the guest's EL0 event counting on the first
KVM_RUN (after the migration) when needed.  More specifically,
have kvm_pmu_handle_pmcr() call kvm_vcpu_pmu_restore_guest()
so that kvm_pmu_handle_pmcr() on the first KVM_RUN can take
care of it.

Fixes: d0c94c49792c ("KVM: arm64: Restore PMU configuration on first run")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Link: https://lore.kernel.org/r/20230329023944.2488484-1-reijiw@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pmu-emul.c |    1 +
 arch/arm64/kvm/sys_regs.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -558,6 +558,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
+	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -703,7 +703,6 @@ static bool access_pmcr(struct kvm_vcpu
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		kvm_pmu_handle_pmcr(vcpu, val);
-		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)


