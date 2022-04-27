Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57BB511D71
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241033AbiD0P6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 11:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240897AbiD0P6P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 11:58:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDB7712EF;
        Wed, 27 Apr 2022 08:54:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32032B8288A;
        Wed, 27 Apr 2022 15:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE40C385A9;
        Wed, 27 Apr 2022 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651074876;
        bh=u5R2NEE5dxIq9yDn+X6t+uU7aAhLsijujCU70CcrrLA=;
        h=From:To:Cc:Subject:Date:From;
        b=TpGzXJbLRb+pn0Ocq3ZJF60vQ1RT0q28WNZCuud2pKn/++9lBZAVLQI8o7ETWo/e/
         wwz/bBk5FOFoRiNf6IzDTDuS1FyBXj3buS5ghXl+BXtq/M7hv9bXbERvBXnSZMeF6h
         mIarqi37q9qOFHFfzclYope1CAMU4Skn04NkVD5y+S3FRR2A0epVl0P/wlidu5ZsWx
         knZFaCBGZvqUgGGv78giHLohMIBqb4FW3sj7lCfuB4uop3MkRuFtASgo2sZJeOeObA
         N4zvXAX2PHQlsdevZ345vUNm5+DQrCixHCr8IXATec09pZsGaFGkUY3sdMATThEZaH
         i+8l7obk3krvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: [PATCH MANUALSEL 5.10 1/4] x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume
Date:   Wed, 27 Apr 2022 11:54:32 -0400
Message-Id: <20220427155435.19554-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

[ Upstream commit 0361bdfddca20c8855ea3bdbbbc9c999912b10ff ]

MSR_KVM_POLL_CONTROL is cleared on reset, thus reverting guests to
host-side polling after suspend/resume.  Non-bootstrap CPUs are
restored correctly by the haltpoll driver because they are hot-unplugged
during suspend and hot-plugged during resume; however, the BSP
is not hotpluggable and remains in host-sde polling mode after
the guest resume.  The makes the guest pay for the cost of vmexits
every time the guest enters idle.

Fix it by recording BSP's haltpoll state and resuming it during guest
resume.

Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Message-Id: <1650267752-46796-1-git-send-email-wanpengli@tencent.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/kvm.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 18e952fed021..6c3d38b5a8ad 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -66,6 +66,7 @@ static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __align
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
 static int has_steal_clock = 0;
 
+static int has_guest_poll = 0;
 /*
  * No need for any "IO delay" on KVM
  */
@@ -624,14 +625,26 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 
 static int kvm_suspend(void)
 {
+	u64 val = 0;
+
 	kvm_guest_cpu_offline(false);
 
+#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
+	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL))
+		rdmsrl(MSR_KVM_POLL_CONTROL, val);
+	has_guest_poll = !(val & 1);
+#endif
 	return 0;
 }
 
 static void kvm_resume(void)
 {
 	kvm_cpu_online(raw_smp_processor_id());
+
+#ifdef CONFIG_ARCH_CPUIDLE_HALTPOLL
+	if (kvm_para_has_feature(KVM_FEATURE_POLL_CONTROL) && has_guest_poll)
+		wrmsrl(MSR_KVM_POLL_CONTROL, 0);
+#endif
 }
 
 static struct syscore_ops kvm_syscore_ops = {
-- 
2.35.1

