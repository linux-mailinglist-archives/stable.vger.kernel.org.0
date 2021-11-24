Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079C545C281
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244824AbhKXN3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:57670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350640AbhKXN1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:27:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7F8561BA1;
        Wed, 24 Nov 2021 12:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758236;
        bh=1fqUQicOj+Ghb+8xStnz1O2G6mG9oDB090J+hxHsS4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5p0MbQ3or8DBC9SsLzhGDKHH/0n+k67+yhYJ4UfkPYBL0EKExbnFdvcFgD6fPCZc
         xCaAdDyvUshLExdrqPAdV25Q8Z+bLz8mM8bTcZZFUpj1CTkTiI5iSKglYzvt6pOpXV
         Iz9y6q7VENYVr7S2duK8EpQAfyLfxPPYrl11w4Qs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 073/100] perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server
Date:   Wed, 24 Nov 2021 12:58:29 +0100
Message-Id: <20211124115657.220528466@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115654.849735859@linuxfoundation.org>
References: <20211124115654.849735859@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Antonov <alexander.antonov@linux.intel.com>

[ Upstream commit e324234e0aa881b7841c7c713306403e12b069ff ]

According Uncore Reference Manual: any of the CHA events may be filtered
by Thread/Core-ID by using tid modifier in CHA Filter 0 Register.
Update skx_cha_hw_config() to follow Uncore Guide.

Fixes: cd34cd97b7b4 ("perf/x86/intel/uncore: Add Skylake server uncore support")
Signed-off-by: Alexander Antonov <alexander.antonov@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20211115090334.3789-2-alexander.antonov@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 9096a1693942d..b2cc97f7c2a5c 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3479,6 +3479,9 @@ static int skx_cha_hw_config(struct intel_uncore_box *box, struct perf_event *ev
 	struct hw_perf_event_extra *reg1 = &event->hw.extra_reg;
 	struct extra_reg *er;
 	int idx = 0;
+	/* Any of the CHA events may be filtered by Thread/Core-ID.*/
+	if (event->hw.config & SNBEP_CBO_PMON_CTL_TID_EN)
+		idx = SKX_CHA_MSR_PMON_BOX_FILTER_TID;
 
 	for (er = skx_uncore_cha_extra_regs; er->msr; er++) {
 		if (er->event != (event->hw.config & er->config_mask))
-- 
2.33.0



