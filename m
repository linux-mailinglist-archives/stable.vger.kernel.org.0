Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C7636AE9B
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbhDZHpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233874AbhDZHoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF5AC613D8;
        Mon, 26 Apr 2021 07:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422856;
        bh=7z7J0e3qaGw1Fybts+UZVQWo48sV0GLCy1N5XAZq1eQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=McLb6J9pC96m40S4a6Mej2uxlMdN6owu7QBQdsiQubzB5Jk5C3p0ZNQ9svpv8ZDwG
         DwkrdSo1v/jvzhEplruSZKcisJ0q9f+xBDjw94SqQDWcyUmTtS66ZpEpTahw1IAP2A
         MOlfad128iun8bkOSLnsdC6N3B/nzZfwyqzdk6Gw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Peter Shier <pshier@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 19/41] perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]
Date:   Mon, 26 Apr 2021 09:30:06 +0200
Message-Id: <20210426072820.334857645@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jim Mattson <jmattson@google.com>

[ Upstream commit 4b2f1e59229b9da319d358828cdfa4ddbc140769 ]

The only stepping of Broadwell Xeon parts is stepping 1. Fix the
relevant isolation_ucodes[] entry, which previously enumerated
stepping 2.

Although the original commit was characterized as an optimization, it
is also a workaround for a correctness issue.

If a PMI arrives between kvm's call to perf_guest_get_msrs() and the
subsequent VM-entry, a stale value for the IA32_PEBS_ENABLE MSR may be
restored at the next VM-exit. This is because, unbeknownst to kvm, PMI
throttling may clear bits in the IA32_PEBS_ENABLE MSR. CPUs with "PEBS
isolation" don't suffer from this issue, because perf_guest_get_msrs()
doesn't report the IA32_PEBS_ENABLE value.

Fixes: 9b545c04abd4f ("perf/x86/kvm: Avoid unnecessary work in guest filtering")
Signed-off-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Peter Shier <pshier@google.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Link: https://lkml.kernel.org/r/20210422001834.1748319-1-jmattson@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index bfd42e0853ed..6c88f245b33a 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -4400,7 +4400,7 @@ static const struct x86_cpu_desc isolation_ucodes[] = {
 	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_D,		 3, 0x07000009),
 	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_D,		 4, 0x0f000009),
 	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_D,		 5, 0x0e000002),
-	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_X,		 2, 0x0b000014),
+	INTEL_CPU_DESC(INTEL_FAM6_BROADWELL_X,		 1, 0x0b000014),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 3, 0x00000021),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 4, 0x00000000),
 	INTEL_CPU_DESC(INTEL_FAM6_SKYLAKE_X,		 5, 0x00000000),
-- 
2.30.2



