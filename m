Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534323FB510
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236735AbhH3MBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:01:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:46856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236649AbhH3MAt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8766112F;
        Mon, 30 Aug 2021 11:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324795;
        bh=XTeGxOIsRjhNchLp8E3OiO0GBydqMgFT84tuT1oUj0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQbSIL1hyvMjQNTwylPOqeTf+6V0lmG4c+H6domFW6IZBq20oDdQuNM3+6VQAMZBl
         wfKspbmLCfrLHjRc7KRbPwaZb+7cttSs3g5RMjzSnnjjhxV7vX0hJmrfJ3SWbaYlZ5
         Mo8YMdth7At8HXlVlpF+ZB5JBe7xdinjAVZiJZL/lVFcqJfWbr5ZqVLf3Qm23z0/Kj
         cHB98fvGdzr361FiCE7X+ObpU5ks8ZTzxkAoBZj/7ThcLNRBu/RG/I9N4CENbNZGm4
         Eb2oV5XQ5wOMhFi0qmONfixfZCRMVPzvJSmxDlF8/SOICaeQCtZGlRYgCb7R9LWIiq
         EJyy/lO4jQxOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 09/14] perf/x86/intel/pt: Fix mask of num_address_ranges
Date:   Mon, 30 Aug 2021 07:59:37 -0400
Message-Id: <20210830115942.1017300-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830115942.1017300-1-sashal@kernel.org>
References: <20210830115942.1017300-1-sashal@kernel.org>
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
index 915847655c06..b044577785bb 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -62,7 +62,7 @@ static struct pt_cap_desc {
 	PT_CAP(single_range_output,	0, CPUID_ECX, BIT(2)),
 	PT_CAP(output_subsys,		0, CPUID_ECX, BIT(3)),
 	PT_CAP(payloads_lip,		0, CPUID_ECX, BIT(31)),
-	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x3),
+	PT_CAP(num_address_ranges,	1, CPUID_EAX, 0x7),
 	PT_CAP(mtc_periods,		1, CPUID_EAX, 0xffff0000),
 	PT_CAP(cycle_thresholds,	1, CPUID_EBX, 0xffff),
 	PT_CAP(psb_periods,		1, CPUID_EBX, 0xffff0000),
-- 
2.30.2

