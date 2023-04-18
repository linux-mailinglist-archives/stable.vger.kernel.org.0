Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164BB6E647B
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbjDRMtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjDRMtc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:49:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDD33C24
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:49:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FB13633F0
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532F8C4339B;
        Tue, 18 Apr 2023 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681822169;
        bh=Bqo7UGfd2wKcituUJQ0KjPmUD2UvxAEVtyw5L1GElVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfum9jNdT5rJAk5iemLOfR1+xNronD95ajZT9IpMP/i9VhWbNQdVPwfqa/VKbrUBm
         2EFUC8++rUxLJVeeSa1dRe9MR/bhn/9ShjbZB+h5GxeMYXpxiAffTlRa4DeAdOvXV2
         LoydyvPkojvYyigTRJX1sutvOH/o9MtQ2hFzoqGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Fuad Tabba <tabba@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 049/139] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to protected VMs
Date:   Tue, 18 Apr 2023 14:21:54 +0200
Message-Id: <20230418120315.542014389@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
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

From: Fuad Tabba <tabba@google.com>

[ Upstream commit e81625218bf7986ba1351a98c43d346b15601d26 ]

The existing pKVM code attempts to advertise CSV2/3 using values
initialized to 0, but never set. To advertise CSV2/3 to protected
guests, pass the CSV2/3 values to hyp when initializing hyp's
view of guests' ID_AA64PFR0_EL1.

Similar to non-protected KVM, these are system-wide, rather than
per cpu, for simplicity.

Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System Registers")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://lore.kernel.org/r/20230404152321.413064-1-tabba@google.com
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/arm.c                          | 26 ++++++++++++++++++-
 .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 -----
 3 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9c5573bc46145..e57f8ae093875 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1877,9 +1877,33 @@ static int do_pkvm_init(u32 hyp_va_bits)
 	return ret;
 }
 
+static u64 get_hyp_id_aa64pfr0_el1(void)
+{
+	/*
+	 * Track whether the system isn't affected by spectre/meltdown in the
+	 * hypervisor's view of id_aa64pfr0_el1, used for protected VMs.
+	 * Although this is per-CPU, we make it global for simplicity, e.g., not
+	 * to have to worry about vcpu migration.
+	 *
+	 * Unlike for non-protected VMs, userspace cannot override this for
+	 * protected VMs.
+	 */
+	u64 val = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+
+	val &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
+		 ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
+
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
+			  arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED);
+	val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
+			  arm64_get_meltdown_state() == SPECTRE_UNAFFECTED);
+
+	return val;
+}
+
 static void kvm_hyp_init_symbols(void)
 {
-	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
+	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 07edfc7524c94..37440e1dda930 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -33,11 +33,14 @@
  * Allow for protected VMs:
  * - Floating-point and Advanced SIMD
  * - Data Independent Timing
+ * - Spectre/Meltdown Mitigation
  */
 #define PVM_ID_AA64PFR0_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_FP) | \
 	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AdvSIMD) | \
-	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_DIT) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) | \
+	ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3) \
 	)
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 0f9ac25afdf40..3d5121ee39777 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -84,19 +84,12 @@ static u64 get_restricted_features_unsigned(u64 sys_reg_val,
 
 static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 {
-	const struct kvm *kvm = (const struct kvm *)kern_hyp_va(vcpu->kvm);
 	u64 set_mask = 0;
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
 	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
-	/* Spectre and Meltdown mitigation in KVM */
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
-			       (u64)kvm->arch.pfr0_csv2);
-	set_mask |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
-			       (u64)kvm->arch.pfr0_csv3);
-
 	return (id_aa64pfr0_el1_sys_val & allow_mask) | set_mask;
 }
 
-- 
2.39.2



