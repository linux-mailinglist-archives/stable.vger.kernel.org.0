Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3B6CB512
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 05:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbjC1Dr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 23:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbjC1Drz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 23:47:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3240171F
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 20:47:53 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5458201ab8cso108036157b3.23
        for <stable@vger.kernel.org>; Mon, 27 Mar 2023 20:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679975273;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1fqM/5aXH/kUnbZst5pUEbiSYW0bWjK1pNRwkxjpC7o=;
        b=nfCnu/maO6m2fyb3UGY0EV4VvPIVgxyIDQ/Stccb7oTK9UzBRlILkW1RfXa23+PKcN
         qYph1cHZhVwtJQVjyjX5AiHiZG2LNrP/kgjF+q72dnTLENdLoFLRnPM+/828+yOlspDu
         D7bBvHGgr5xJdj62d1FEz86SaPUbgQuCRyYVGXRq9Hv6o0mYwKddsYwz5tXL8JvGC0GJ
         9NIfZuaKeHLTxx0ECdd9xmpQlLeQCgeOod9bO1QtPJcreidiA02sWmrTeDhlSAEuYRUr
         mw51jWIWU5lOU5qbfEDSvHmTbwMbakc607pjjpKmIQRkErApsqAH/WXdOyAR4h0huxpl
         fl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679975273;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1fqM/5aXH/kUnbZst5pUEbiSYW0bWjK1pNRwkxjpC7o=;
        b=XFzstZAf6hbuDRpJt3e8PkT9M0Sos24zpv94c8Ff3pp2N18p/ObCq86TUDfNvoQXV6
         INFNWb9BOGfY/vkQd3+ez0/LrV3wrPG8L+mU3o1LA4Zp1LJgfac/XANLoBlQYA6nmzLV
         XWkhVYWESlUruxBqZ/Y92vueg5l0VdPcIkXDcnYEun8ONXpbMrrj3K4H24BQ/15HFOBI
         SsgQvZxhwXfzk9FrCExQgamsHnFQpm6k4/BHwsidGsSJng9Sr6aq6xg296GTnvCBlZvB
         c/1qaE3c8Lz4gWoiSedjLHcFxgSd0aILeq2Kr0XkD+FXn/5tTf9g3XcuifoSYw0W0Jwl
         Wdgg==
X-Gm-Message-State: AAQBX9f+OO1yKXrt+kkclQyEWRsHgeswRS3vmDi/KrM53eqbtEcvF8HN
        vn1afjiXM3Z70X19K3f15jFljGmmJqo=
X-Google-Smtp-Source: AKy350YDNIIl35Z1hSKIAvRkO/mVLdZdmZFktwv0iTKmYyy8goNSt9y0gXZFbDnhlOzfQwDo+Wp3YEuawvY=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a05:6902:1181:b0:b6c:2224:8a77 with SMTP id
 m1-20020a056902118100b00b6c22248a77mr9016560ybu.1.1679975273052; Mon, 27 Mar
 2023 20:47:53 -0700 (PDT)
Date:   Mon, 27 Mar 2023 20:47:25 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328034725.2051499-1-reijiw@google.com>
Subject: [PATCH v1] KVM: arm64: PMU: Restore the guest's EL0 event counting
 after migration
From:   Reiji Watanabe <reijiw@google.com>
To:     Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        Will Deacon <will@kernel.org>,
        Reiji Watanabe <reijiw@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, with VHE, KVM enables the EL0 event counting for the
guest on vcpu_load() or KVM enables it as a part of the PMU
register emulation process, when needed.  However, in the migration
case (with VHE), the same handling is lacking.  So, enable it on the
first KVM_RUN with VHE (after the migration) when needed.

Fixes: d0c94c49792c ("KVM: arm64: Restore PMU configuration on first run")
Cc: stable@vger.kernel.org
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 1 +
 arch/arm64/kvm/sys_regs.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index c243b10f3e15..5eca0cdd961d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -558,6 +558,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
+	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b2c161120be..34688918c811 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -794,7 +794,6 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		kvm_pmu_handle_pmcr(vcpu, val);
-		kvm_vcpu_pmu_restore_guest(vcpu);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0)
-- 
2.40.0.348.gf938b09366-goog

