Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74A645AEA8A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbiIFNva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239892AbiIFNuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:50:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66EE22125F;
        Tue,  6 Sep 2022 06:39:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3BEE1CE178C;
        Tue,  6 Sep 2022 13:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9D6C433C1;
        Tue,  6 Sep 2022 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471544;
        bh=DNJ7qeQmbocPCd0eGUdOBkKQYubjOrEPCuQvRZKGUrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYwQiRMA1H1HSs3MPTncXbH52sXJ1VHV9gZphve+J0aMpIMti/StVa6HStNgzxHCi
         3jNUKHacv7pkX+4f1sLwO0hPdQuyHAiVP4BLDmJAGvVk8oaQhEUMHq0Uh7zKPGtDnv
         MGuJu6Yil6KQmiFCny19wBldGTWiENn/K8v/9mlQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vipin Sharma <vipinsh@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/107] KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES
Date:   Tue,  6 Sep 2022 15:30:42 +0200
Message-Id: <20220906132824.405904848@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 0204750bd4c6ccc2fb7417618477f10373b33f56 ]

KVM should not claim to virtualize unknown IA32_ARCH_CAPABILITIES
bits. When kvm_get_arch_capabilities() was originally written, there
were only a few bits defined in this MSR, and KVM could virtualize all
of them. However, over the years, several bits have been defined that
KVM cannot just blindly pass through to the guest without additional
work (such as virtualizing an MSR promised by the
IA32_ARCH_CAPABILITES feature bit).

Define a mask of supported IA32_ARCH_CAPABILITIES bits, and mask off
any other bits that are set in the hardware MSR.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Fixes: 5b76a3cff011 ("KVM: VMX: Tell the nested hypervisor to skip L1D flush on vmentry")
Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Vipin Sharma <vipinsh@google.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Message-Id: <20220830174947.2182144-1-jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f5b7a05530eb0..9109e5589b421 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1465,12 +1465,32 @@ static const u32 msr_based_features_all[] = {
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
 static unsigned int num_msr_based_features;
 
+/*
+ * Some IA32_ARCH_CAPABILITIES bits have dependencies on MSRs that KVM
+ * does not yet virtualize. These include:
+ *   10 - MISC_PACKAGE_CTRLS
+ *   11 - ENERGY_FILTERING_CTL
+ *   12 - DOITM
+ *   18 - FB_CLEAR_CTRL
+ *   21 - XAPIC_DISABLE_STATUS
+ *   23 - OVERCLOCKING_STATUS
+ */
+
+#define KVM_SUPPORTED_ARCH_CAP \
+	(ARCH_CAP_RDCL_NO | ARCH_CAP_IBRS_ALL | ARCH_CAP_RSBA | \
+	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
+	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
+	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
+	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
+
 static u64 kvm_get_arch_capabilities(void)
 {
 	u64 data = 0;
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
+		data &= KVM_SUPPORTED_ARCH_CAP;
+	}
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
@@ -1518,9 +1538,6 @@ static u64 kvm_get_arch_capabilities(void)
 		 */
 	}
 
-	/* Guests don't need to know "Fill buffer clear control" exists */
-	data &= ~ARCH_CAP_FB_CLEAR_CTRL;
-
 	return data;
 }
 
-- 
2.35.1



