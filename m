Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C174C95A9
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237782AbiCAUPk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237706AbiCAUPc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:15:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B69E75624;
        Tue,  1 Mar 2022 12:14:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AE446170C;
        Tue,  1 Mar 2022 20:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE0EC340EE;
        Tue,  1 Mar 2022 20:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165687;
        bh=TUKvDE7Yn53C+D24wIJTRkOEGDhyfiTrS45tDJ3cE4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYhIAU4bIMG9G26zapqFpMmhl+LyHqPoC1RTqJaCS8PGjFLoLvEA8AGXc9II6v9DP
         qek59k5T/2l+5SeAqcOKgwSMOtjO+pZZu0FIod0zWvJmPegKrjaSzWS8bINjvuatAP
         ZKLp3c29V3hgf8C5G3J+vTNbiEYWy8TQ+/hdubXCM5hdXecnFLhD8xHuhjP6Rj64um
         O+a1RjpPTlnggVDZuV9QZ5Jdew0EW4tNDFBd0Pdu/INfwh1Fav9EKIQakKkjYuKFwK
         bxszO2OBhSu1wvcG1qyHNyWXklfO+SIfeOqxJxg6Htez8noODqA919FW6VuM7KHhc7
         9wWZkqn0bq6KA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 12/28] x86/kvm: Don't use pv tlb/ipi/sched_yield if on 1 vCPU
Date:   Tue,  1 Mar 2022 15:13:17 -0500
Message-Id: <20220301201344.18191-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
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
index 59abbdad7729c..ff3db164e52cb 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -462,19 +462,22 @@ static bool pv_tlb_flush_supported(void)
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

