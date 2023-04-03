Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F66D4AEB
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbjDCOvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbjDCOvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:51:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA0C29BED
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:50:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE3A661F8C
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1265CC433D2;
        Mon,  3 Apr 2023 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533425;
        bh=/mwZFqsSLPuMx6rp7yxP+o6Adz8AnAhJEzCDgRZg/0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbMuo2g9TX0rVZFI0JlOhQJWinmP9UQ11Jkh2GdLqW5WPyx1Svs6373Pq+26vGr4g
         qi6gE03JjpuaJ7QPS4hASip98+9FQJIE4rCDbFwrmb5Yy3BpDk4ej0bS3c3UDbOBv9
         d1/d9Q1I+i/SWojoSoJvIs5092apEDYCgiNXA7io=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
        Reiji Watanabe <reijiw@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 6.2 177/187] KVM: arm64: PMU: Dont save PMCR_EL0.{C,P} for the vCPU
Date:   Mon,  3 Apr 2023 16:10:22 +0200
Message-Id: <20230403140422.109636681@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Reiji Watanabe <reijiw@google.com>

commit f6da81f650fa47b61b847488f3938d43f90d093d upstream.

Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
KVM saves the register value, including these bits.
When userspace reads the register using KVM_GET_ONE_REG, KVM returns
the saved register value as it is (the saved value might have these
bits set).  This could result in userspace setting these bits on the
destination during migration.  Consequently, KVM may end up resetting
the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
zero on the first KVM_RUN after migration.

Fix this by not saving those bits when a guest writes 1 to those bits.

Fixes: ab9468340d2b ("arm64: KVM: Add access handler for PMCR register")
Cc: stable@vger.kernel.org
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
Link: https://lore.kernel.org/r/20230313033234.1475987-1-reijiw@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/pmu-emul.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -538,7 +538,8 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu
 	if (!kvm_pmu_is_3p5(vcpu))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
-	__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+	/* The reset bits don't indicate any state, and shouldn't be saved. */
+	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,


