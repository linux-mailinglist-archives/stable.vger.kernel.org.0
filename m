Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72359521B11
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244784AbiEJOIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343567AbiEJOHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:07:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5495D21A961;
        Tue, 10 May 2022 06:41:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325E6615C8;
        Tue, 10 May 2022 13:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC73C385C2;
        Tue, 10 May 2022 13:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190062;
        bh=4jWXUFL4sGPebXcKjYdd9XhHrmSzS5fbyAElvBDd/Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+ztJcQ0RntulvhVHRhaklqmxcgvdEb9+JM93knwopkIjd6dMEk7xOzub3O4wBerc
         /nNGM9K6tmoG7fMhV/e5fdXbS9YfH+rdT3s7+OdRVfVne0gjLb9aspWRIDr0EDJG4L
         Y2WrLa6oFLvEtY35oL27lNe6XY1PVeSf07OG/ZfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 115/140] x86/kvm: Preserve BSP MSR_KVM_POLL_CONTROL across suspend/resume
Date:   Tue, 10 May 2022 15:08:25 +0200
Message-Id: <20220510130744.894269431@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index ed8a13ac4ab2..4c2a158bb6c4 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -69,6 +69,7 @@ static DEFINE_PER_CPU_DECRYPTED(struct kvm_vcpu_pv_apf_data, apf_reason) __align
 DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visible;
 static int has_steal_clock = 0;
 
+static int has_guest_poll = 0;
 /*
  * No need for any "IO delay" on KVM
  */
@@ -706,14 +707,26 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 
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



