Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65556E631C
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjDRMiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjDRMiA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:38:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA0B1CFA8
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A36E26251D
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:37:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CB8C433EF;
        Tue, 18 Apr 2023 12:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821477;
        bh=H6SeAA+z8PDJPGN+ACBCjglYPp1bfSD3Pk45r2OUi8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xTqZYWOHpE2jcgobfoqjJBbhu5ChAJzBX8ExC3xKo4zqVF+Qh1QKtxk0yipP034qe
         15TTVGvUaG9bQYUfDkXo5kIMcfNT7OhC8bsc5tWbw2ZCsP7AXlY/tl7eK3Vu+UMFCJ
         KsZW4KEwdkEUWob7Mz+G/0G7CNiCDcq/OhFm6LFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 5.15 17/91] KVM: arm64: PMU: Restore the guests EL0 event counting after migration
Date:   Tue, 18 Apr 2023 14:21:21 +0200
Message-Id: <20230418120306.177349989@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -554,6 +554,7 @@ void kvm_pmu_software_increment(struct k
 			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
 		}
 	}
+	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 /**
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -702,7 +702,6 @@ static bool access_pmcr(struct kvm_vcpu
 			val |= ARMV8_PMU_PMCR_LC;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
-		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)


