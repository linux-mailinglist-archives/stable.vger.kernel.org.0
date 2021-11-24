Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF0845C3DA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348115AbhKXNo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:44:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:35812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350666AbhKXNlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:41:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB08463267;
        Wed, 24 Nov 2021 12:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758674;
        bh=OrJbV9ePKqEHBMmKkGn+YhUCQT/PHCaWlFHYkLlyn1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g63qoVqrdA5/lfA90TxSCZ16mvpKPZnSJgYK7CXLE4taNQuX1LieaVKCAbs0T8Lwc
         YP56NT8yH3MaFcMdXlwn6GqDrlAYMLN/e85qsPJCm0I7DwQjSsqbfW65JGDXwXs2Mc
         oQSRTGrDAH4k8QxqjzYohKEmRcqS4ZVXQ6Pr7wwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/154] perf/x86/intel/uncore: Fix filter_tid mask for CHA events on Skylake Server
Date:   Wed, 24 Nov 2021 12:58:31 +0100
Message-Id: <20211124115706.003680111@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
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
index c01b51d1cbdff..229884f4134cb 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3545,6 +3545,9 @@ static int skx_cha_hw_config(struct intel_uncore_box *box, struct perf_event *ev
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



