Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90AA44C9617
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237862AbiCAUSl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:18:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbiCAUSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:18:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7EC5FFA;
        Tue,  1 Mar 2022 12:17:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B1E8CE1E66;
        Tue,  1 Mar 2022 20:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AABC36AE3;
        Tue,  1 Mar 2022 20:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165837;
        bh=CUyZj62DQefLTzMMGF+hDyJGKchgnq4fyRxIIaIvKME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cwGh1T204qLbleTSwVpI2LAxI7MkNc1BllnV5Q2WOUiZFNg2j3JiDhYJGur5XGb8k
         F9k7WKMGEjpqeFPmZ/mofDQRAn2qQi3l0XRMnO3vjDtCkLTxsFphBl7amNawJr3wsa
         eG5clj2K3RfcrhSm7RtIoUGlyHLfsAHa16LOhogs2NGwZLOROudWP7n7Qk/elYgqyr
         zmmBoGdGSQLPMBUuaAJUR9wuj1cSv7iDWf5nEQYBV5jwIcCAc2l5plE9ZBz5CD/Wac
         haGcx3xLLfHP5LYjVIovyDvx4wqUcyvGS15d3q5Ey/TPzybFCCVXLqSjduXOLtFBC+
         ipD12+qno2GrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 10/23] x86/kvm: Don't use pv tlb/ipi/sched_yield if on 1 vCPU
Date:   Tue,  1 Mar 2022 15:16:09 -0500
Message-Id: <20220301201629.18547-10-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit ec756e40e271866f951d77c5e923d8deb6002b15 ]

Inspired by commit 3553ae5690a (x86/kvm: Don't use pvqspinlock code if
only 1 vCPU), on a VM with only 1 vCPU, there is no need to enable
pv tlb/ipi/sched_yield and we can save the memory for __pv_cpu_mask.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1645171838-2855-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index b656456c3a944..811c7aaf23aac 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -457,19 +457,22 @@ static bool pv_tlb_flush_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+		(num_possible_cpus() != 1));
 }
 
 static bool pv_ipi_supported(void)
 {
-	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
+	return (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI) &&
+	       (num_possible_cpus() != 1));
 }
 
 static bool pv_sched_yield_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+	    (num_possible_cpus() != 1));
 }
 
 #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)
-- 
2.34.1

