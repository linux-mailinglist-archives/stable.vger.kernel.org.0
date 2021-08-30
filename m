Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BDD3FB530
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237125AbhH3MCK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:02:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236972AbhH3MBm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6361C60232;
        Mon, 30 Aug 2021 12:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324849;
        bh=3kytqInYdaIIpA3k8cdBnOFVmrir0kc23ypTP2INWoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0N8dnBzgx3jWATwoghfGWsmkXbCZzfeDTgK7UbOMzH/v7Q8fvBfERI6atbz9zyNY
         8thUASrbz5uqHU3hNoQoD+30Ze8dbth8KV4k83afd+N7wV3ZDRmCEP3rctLOCmf7mM
         M4GfD6R7C3Nm3NXhZktFeZziCC3vT3CxcFgXlFVJf5g/m8JQIZG+L9062hTsZ8cDvH
         bNgUQ5Ib7ReU3stPKHGB7J9blcI7OTCqUBXfZfhEIcV2UuKEOVcsOfRTPNFis4J8To
         8d/pjJg+Rb4su4KKEAkJl1KfZdvTdbBzqWKQWyXFk66ivAvlp/g809vBcfg38NGc6E
         BN2OWWMb2OyLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 4/7] perf/x86/intel/pt: Fix mask of num_address_ranges
Date:   Mon, 30 Aug 2021 08:00:40 -0400
Message-Id: <20210830120043.1018096-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120043.1018096-1-sashal@kernel.org>
References: <20210830120043.1018096-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

[ Upstream commit c53c6b7409f4cd9e542991b53d597fbe2751d7db ]

Per SDM, bit 2:0 of CPUID(0x14,1).EAX[2:0] reports the number of
configurable address ranges for filtering, not bit 1:0.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lkml.kernel.org/r/20210824040622.4081502-1-xiaoyao.li@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 0661227d935c..990ca9614b23 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -69,7 +69,7 @@ static struct pt_cap_desc {
 	PT_CAP(topa_multiple_entries,	0, CPUID_ECX, BIT(1)),
 	PT_CAP(single_range_output,	0, CPUID_ECX, BIT(2)),
 	PT_CAP(payloads_lip,		0, CPUID_ECX, BIT(31)),
-	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x3),
+	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x7),
 	PT_CAP(mtc_periods,		1, CPUID_EAX, 0xffff0000),
 	PT_CAP(cycle_thresholds,	1, CPUID_EBX, 0xffff),
 	PT_CAP(psb_periods,		1, CPUID_EBX, 0xffff0000),
-- 
2.30.2

