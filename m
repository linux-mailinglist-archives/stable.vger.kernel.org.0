Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2018536AE2D
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhDZHlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:49252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232617AbhDZHjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E4DC613DE;
        Mon, 26 Apr 2021 07:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422708;
        bh=fopELUJT+NkfhV1e4h5AI7uAGQ2bR6OSpfAXGFu+biY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAo1/B2qGaaoN/1pOSgiVo8fsVEdCL2hM6qYprPB3y9ST1Hh6rpFLpxk97h8vI7Uq
         cZIG9KeZT5dZQFKdimpn+fwjcGBSgnqIA9kFyVuQb4bdqxD3wm3pK/kGO7HEA5ZZ9q
         QuhqGziYGwJOPqw7jpgfrqkN8LJc0cKQ+6EEFm8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Peter Shier <pshier@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 07/20] perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]
Date:   Mon, 26 Apr 2021 09:29:58 +0200
Message-Id: <20210426072816.919608891@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
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
index 90760393a964..9cb3266e148d 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3999,7 +3999,7 @@ static const struct x86_cpu_desc isolation_ucodes[] = {
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



