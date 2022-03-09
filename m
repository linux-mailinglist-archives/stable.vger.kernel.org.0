Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1254D3642
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 18:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiCIQ74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237478AbiCIQ7p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:59:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5171D1AE65F;
        Wed,  9 Mar 2022 08:46:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F85561B09;
        Wed,  9 Mar 2022 16:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1140C340E8;
        Wed,  9 Mar 2022 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646844404;
        bh=RPw2yWh5rNNq1N+ffKQC8XwoAmFi1Wm9zd2Ku8G6Yeo=;
        h=From:To:Cc:Subject:Date:From;
        b=SxhUa+vOdm9vFpDxKD+nNg8OLJI7BRyqJgD8S69wQ81f0i8zwj0OBBVpOsULOBe7F
         W8wBhyXYNInGmt7OxFyI6RGzpARbJpzJLxKxlfu8jqz09Di/wNTcrX83IE0DmU77Ra
         FUrICjhQmNeh8RpKPlwhlijsscVemgzkXamgGU/RcProGeMgoHdbUlc9zcm0NoFdBW
         lD1q0dqkl4H878YyESHDwiIw6qEBGP+KZbVzioKrvyhbVUGlJn6FjrwvRdju1aHIDU
         +SM1QWwIN8atXxEgW0oRAbCXPrcKiboYnqieYK8s8OVBLIkj7njxvDZU4FMdeymgO3
         7YCh06CvTdjwQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li RongQing <lirongqing@baidu.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.15] KVM: x86: Yield to IPI target vCPU only if it is busy
Date:   Wed,  9 Mar 2022 11:46:32 -0500
Message-Id: <20220309164632.137995-1-sashal@kernel.org>
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
index b656456c3a94..49f19e572a25 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -565,7 +565,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 
 	/* Make sure other vCPUs get a chance to run if they need to. */
 	for_each_cpu(cpu, mask) {
-		if (vcpu_is_preempted(cpu)) {
+		if (!idle_cpu(cpu) && vcpu_is_preempted(cpu)) {
 			kvm_hypercall1(KVM_HC_SCHED_YIELD, per_cpu(x86_cpu_to_apicid, cpu));
 			break;
 		}
-- 
2.34.1

