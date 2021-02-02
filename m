Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BD730C8AF
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 18:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbhBBR52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 12:57:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:48170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233612AbhBBOId (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:08:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C09F6502E;
        Tue,  2 Feb 2021 13:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273828;
        bh=bKbMna5GuS4eLGTnZRrVFBvIizzKzHKr+gzPRS1GmlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ducwJN87oRoN+gVJJ2Yte6QhFfJB1XlBOJvl83p5HP+Kv/W3foZyS9wMgRW3LDzC1
         eU6sU7z1xjEto87ITKB1rW2WElqshoYtFmEjKLLO0IHTu3ZxGYcpzzCF7M0cDiVAdP
         IrvrJcpkdcQb05iIU28WYguH+C05+rd9y45dttL8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <like.xu@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 4.9 16/32] KVM: x86/pmu: Fix HW_REF_CPU_CYCLES event pseudo-encoding in intel_arch_events[]
Date:   Tue,  2 Feb 2021 14:38:39 +0100
Message-Id: <20210202132942.660234162@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
References: <20210202132942.035179752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <like.xu@linux.intel.com>

commit 98dd2f108e448988d91e296173e773b06fb978b8 upstream.

The HW_REF_CPU_CYCLES event on the fixed counter 2 is pseudo-encoded as
0x0300 in the intel_perfmon_event_map[]. Correct its usage.

Fixes: 62079d8a4312 ("KVM: PMU: add proper support for fixed counter 2")
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Message-Id: <20201230081916.63417-1-like.xu@linux.intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/pmu_intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/pmu_intel.c
+++ b/arch/x86/kvm/pmu_intel.c
@@ -29,7 +29,7 @@ static struct kvm_event_hw_type_mapping
 	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
 	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
 	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
-	[7] = { 0x00, 0x30, PERF_COUNT_HW_REF_CPU_CYCLES },
+	[7] = { 0x00, 0x03, PERF_COUNT_HW_REF_CPU_CYCLES },
 };
 
 /* mapping between fixed pmc index and intel_arch_events array */


