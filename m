Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344DC4D3667
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbiCIRAQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236303AbiCIQ7v (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:59:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B8B1AF8CF;
        Wed,  9 Mar 2022 08:47:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3535E61847;
        Wed,  9 Mar 2022 16:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5668C340E8;
        Wed,  9 Mar 2022 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844426;
        bh=SA2QB8kqGSNFVpyd+5r6V1cJR1KQQcp7Q4UfP4/NaJY=;
        h=From:To:Cc:Subject:Date:From;
        b=Qew2Q24dUVs/ll/gR0bGsQGrl4a9l1DoEgDL57d8y0kT/ZrHlGtR0b8wqSffF9Qf+
         E+wU/GkAQSH1b9tEdF/WcYYBjPypYhTNdfOr3ps7xyMqKT3Qj1LiAP6m5yP6srg/oO
         EyecjWCEHi703THN2XXxClhYfIIWjDQElbjGStlbbECfpQ0ZkaA+bl/CQWMlsmxbHH
         aDcLDjiFgyBTMDXDCVLkQbL9rlJf0oY00kEULG2WXimQ6JNWCrh3E1Cd+HyCYlygWb
         Wn0pSUuDpH0dfaXlOpxsUYrTSEMByRByRODnIeL4dtoi/Vwio+hjDKlBMGwsKB1qKe
         49c6Q0SmYyk6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.4] KVM: x86: Yield to IPI target vCPU only if it is busy
Date:   Wed,  9 Mar 2022 11:46:55 -0500
Message-Id: <20220309164655.138121-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 9ee83635d872812f3920209c606c6ea9e412ffcc ]

When sending a call-function IPI-many to vCPUs, yield to the
IPI target vCPU which is marked as preempted.

but when emulating HLT, an idling vCPU will be voluntarily
scheduled out and mark as preempted from the guest kernel
perspective. yielding to idle vCPU is pointless and increase
unnecessary vmexit, maybe miss the true preempted vCPU

so yield to IPI target vCPU only if vCPU is busy and preempted

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Message-Id: <1644380201-29423-1-git-send-email-lirongqing@baidu.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 6ff2c7cac4c4..77e4d875a468 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -543,7 +543,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 
 	/* Make sure other vCPUs get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
-		if (vcpu_is_preempted(cpu)) {
+		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
 			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
 			break;
 		}
-- 
2.34.1

