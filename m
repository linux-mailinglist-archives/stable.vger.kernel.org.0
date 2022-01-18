Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398DF492A7F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235778AbiARQKj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:10:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41302 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243397AbiARQJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:09:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6AF0FCE1A33;
        Tue, 18 Jan 2022 16:09:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108A7C00446;
        Tue, 18 Jan 2022 16:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522163;
        bh=aGmo8phtXGKjYkogyfosEDhdfyzWaPgWcxlOHzEJ7as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dx50tyC/huWJbs31Pzba5Naw2xri+HUWR49bf4I4UzkRHHoppcQ7PO6czv1uNGK4Q
         UF2Ekicf59slHsf/lYhYrreNvS2VeQ7Ij4vvWjmNeoO7m9gn7uhT/Gf4zk9Eneq0GO
         tDJgIeV74hhIapJaXNT3l3ej8L7gBWW815NLuT78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Wang <wei.w.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 20/28] KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all
Date:   Tue, 18 Jan 2022 17:06:06 +0100
Message-Id: <20220118160452.549838012@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160451.879092022@linuxfoundation.org>
References: <20220118160451.879092022@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <wei.w.wang@intel.com>

commit 9fb12fe5b93b94b9e607509ba461e17f4cc6a264 upstream.

The fixed counter 3 is used for the Topdown metrics, which hasn't been
enabled for KVM guests. Userspace accessing to it will fail as it's not
included in get_fixed_pmc(). This breaks KVM selftests on ICX+ machines,
which have this counter.

To reproduce it on ICX+ machines, ./state_test reports:
==== Test Assertion Failure ====
lib/x86_64/processor.c:1078: r == nmsrs
pid=4564 tid=4564 - Argument list too long
1  0x000000000040b1b9: vcpu_save_state at processor.c:1077
2  0x0000000000402478: main at state_test.c:209 (discriminator 6)
3  0x00007fbe21ed5f92: ?? ??:0
4  0x000000000040264d: _start at ??:?
 Unexpected result from KVM_GET_MSRS, r: 17 (failed MSR was 0x30c)

With this patch, it works well.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
Message-Id: <20211217124934.32893-1-wei.w.wang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Fixes: e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1323,7 +1323,7 @@ static const u32 msrs_to_save_all[] = {
 	MSR_IA32_UMWAIT_CONTROL,
 
 	MSR_ARCH_PERFMON_FIXED_CTR0, MSR_ARCH_PERFMON_FIXED_CTR1,
-	MSR_ARCH_PERFMON_FIXED_CTR0 + 2, MSR_ARCH_PERFMON_FIXED_CTR0 + 3,
+	MSR_ARCH_PERFMON_FIXED_CTR0 + 2,
 	MSR_CORE_PERF_FIXED_CTR_CTRL, MSR_CORE_PERF_GLOBAL_STATUS,
 	MSR_CORE_PERF_GLOBAL_CTRL, MSR_CORE_PERF_GLOBAL_OVF_CTRL,
 	MSR_ARCH_PERFMON_PERFCTR0, MSR_ARCH_PERFMON_PERFCTR1,


