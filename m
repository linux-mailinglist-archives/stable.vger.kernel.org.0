Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A913FB576
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237418AbhH3MDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:49384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236843AbhH3MB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Aug 2021 08:01:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FA3761156;
        Mon, 30 Aug 2021 12:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630324826;
        bh=eNN5EXQyt5NYdF4AJTV+MGkspv1HLaw9fe4Y2KyXb4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QUSebiwvx8GAtVov3hrouF3ZD+p8+gdz4MdF6tYz8MNOk1TXU5MJvG/FgQ7p7ebWM
         S4DL+s5+xBEoGfWG5/gDr9yY9tRI9RZHfHOE/ekqo6zI9QyRErEfu2o0kmzP0HlF+E
         aFGYBGjI4guQ/kEOhOr8W8cl562i8CVRkn7EthMdnpxWBego+0guTN4kWpEzDkHgm9
         XKQHddpn9V2MHw+TS/Ln+xaK8+lndmsJ37JnOevnujxqCYxqhwD9qZyMhrg9hcsoR1
         oa4VG2kel4H1xXX/iixA7dhK3n3lFShFeFR2Axh0Cl+GekFZdP2iJ4+QIs1Jl719so
         uKele3+OKfS0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/10] perf/x86/intel/pt: Fix mask of num_address_ranges
Date:   Mon, 30 Aug 2021 08:00:13 -0400
Message-Id: <20210830120018.1017841-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210830120018.1017841-1-sashal@kernel.org>
References: <20210830120018.1017841-1-sashal@kernel.org>
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
index 05e43d0f430b..da289a44d511 100644
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

