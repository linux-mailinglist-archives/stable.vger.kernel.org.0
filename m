Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B90B04D369E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbiCIRAG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 12:00:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235812AbiCIQ7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:59:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB9B1AEEE2;
        Wed,  9 Mar 2022 08:47:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2194B61B00;
        Wed,  9 Mar 2022 16:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA1CC340E8;
        Wed,  9 Mar 2022 16:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844414;
        bh=69qB+T3NP2ANEZDijaOTA8FnpGUD5EkLGQds1YqsSj0=;
        h=From:To:Cc:Subject:Date:From;
        b=cSFIlRBfBj9kpZrr1xgOPNCfSEDmBOqCoJOOyd1ndfc60f0gQVKRd0utv8FtpPVdV
         A3Sf2p1ILAEanRqAewUz3+NdD5oPgErv4E9X57OlHsew55xPhSqIDzxeX5J1A/nsuJ
         TPt/BffDIayF9ycdEAadUrBh9E5OrpD+vuWopFofg3QLlWBWsbBZsa+pDwPDN9x/E8
         tneqivubKC7Dd38bdbcShHdyjnULJB0tug5pNNpEwNzjO/sX87ZNeqkTTruULsUFnQ
         p54AJXP9XHILwpPZ9zrUCzOTT5b4Y/yLVSmr6hyc7wVkvfS1nCuzQc5SFP2Pfb8rCr
         wgrZ0U0yA/jOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10] KVM: x86: Yield to IPI target vCPU only if it is busy
Date:   Wed,  9 Mar 2022 11:46:44 -0500
Message-Id: <20220309164645.138079-1-sashal@kernel.org>
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
index 7462b79c39de..8fe6eb5bed3f 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -590,7 +590,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 
 	/* Make sure other vCPUs get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
-		if (vcpu_is_preempted(cpu)) {
+		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
 			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
 			break;
 		}
-- 
2.34.1

