Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 822556D47DE
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbjDCOXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233188AbjDCOXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:23:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D179D2BEF9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78A58B81BE9
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4251C433D2;
        Mon,  3 Apr 2023 14:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531821;
        bh=5Z7NymPlpCGnxIiKA3Cz+AMjk1s3O14e58VOiWWDP6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rm95yBEEOYK+7RXhjwjOVWrfySYJ58d4W69a6J3kY2J0cG8SEiWnr4OXffv2DFqwC
         2SX53d4HOj9cZ2EZEM6H7CSSNVuoxsFu7p8R6hQw4upQWTXhlHfoh/aLlvPaXIJX5A
         jNHf9QeAmg3VHuQP8kVskon2qNxwg9IXPPG+1WeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Lai Jiangshan <jiangshanlai@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/173] KVM: KVM: Use cpumask_available() to check for NULL cpumask when kicking vCPUs
Date:   Mon,  3 Apr 2023 16:07:04 +0200
Message-Id: <20230403140414.535389524@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 0bbc2ca8515f9cdf11df84ccb63dc7c44bc3d8f4 ]

Check for a NULL cpumask_var_t when kicking multiple vCPUs via
cpumask_available(), which performs a !NULL check if and only if cpumasks
are configured to be allocated off-stack.  This is a meaningless
optimization, e.g. avoids a TEST+Jcc and TEST+CMOV on x86, but more
importantly helps document that the NULL check is necessary even though
all callers pass in a local variable.

No functional change intended.

Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210827092516.1027264-3-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 2b0128127373 ("KVM: Register /dev/kvm as the _very_ last thing during initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b5134f3046483..f379398b43d59 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -248,9 +248,13 @@ static void ack_flush(void *_completed)
 {
 }
 
-static inline bool kvm_kick_many_cpus(const struct cpumask *cpus, bool wait)
+static inline bool kvm_kick_many_cpus(cpumask_var_t tmp, bool wait)
 {
-	if (unlikely(!cpus))
+	const struct cpumask *cpus;
+
+	if (likely(cpumask_available(tmp)))
+		cpus = tmp;
+	else
 		cpus = cpu_online_mask;
 
 	if (cpumask_empty(cpus))
@@ -280,6 +284,14 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		if (!(req & KVM_REQUEST_NO_WAKEUP) && kvm_vcpu_wake_up(vcpu))
 			continue;
 
+		/*
+		 * tmp can be "unavailable" if cpumasks are allocated off stack
+		 * as allocation of the mask is deliberately not fatal and is
+		 * handled by falling back to kicking all online CPUs.
+		 */
+		if (!cpumask_available(tmp))
+			continue;
+
 		/*
 		 * Note, the vCPU could get migrated to a different pCPU at any
 		 * point after kvm_request_needs_ipi(), which could result in
@@ -291,7 +303,7 @@ bool kvm_make_vcpus_request_mask(struct kvm *kvm, unsigned int req,
 		 * were reading SPTEs _before_ any changes were finalized.  See
 		 * kvm_vcpu_kick() for more details on handling requests.
 		 */
-		if (tmp != NULL && kvm_request_needs_ipi(vcpu, req)) {
+		if (kvm_request_needs_ipi(vcpu, req)) {
 			cpu = READ_ONCE(vcpu->cpu);
 			if (cpu != -1 && cpu != me)
 				__cpumask_set_cpu(cpu, tmp);
-- 
2.39.2



