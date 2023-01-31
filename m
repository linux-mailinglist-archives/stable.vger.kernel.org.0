Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11F683072
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 16:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbjAaPCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 10:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232469AbjAaPBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 10:01:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0DA253B08;
        Tue, 31 Jan 2023 07:00:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F3E06156A;
        Tue, 31 Jan 2023 15:00:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF00C433EF;
        Tue, 31 Jan 2023 15:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675177239;
        bh=xl5CdGc9FXmafuFWPGYkGctlj1wt/31j2ZBGedgp7gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kKepbLTAHoPG39PDnPhmzeBgk00TYPAnf2zj4goIlgrCXYGBz+TIQTwWmu6fB+IW7
         qJ+z02pzYj3Kp+3wtkgA1+fRM8rlYv6qz+oxeWMQQg3R2+uCJpVsa+RI98iLnrndiG
         /XvavmzNEbZhg9XhTpF787e+9Pu+0F5a1d4lcRTa6tJvmL22/91amjXT30k/PAajtt
         QNiNJomYDn4ljq0okvti1oA/ZWJh1ZMxeumeLQFZ1i7uQZo0+PZn5fxsAN2fdCvKpW
         yr/7VcPivhP+9cIsQw9JeNW/Fv0Zv65/IrEFvqkgQi9xCtUUGUYM7yhA0OFqTCv+mo
         HOpfYsq6d1L9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kan Liang <kan.liang@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, peterz@infradead.org,
        mingo@redhat.com, acme@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/12] perf/x86/intel: Add Emerald Rapids
Date:   Tue, 31 Jan 2023 10:00:22 -0500
Message-Id: <20230131150030.1250104-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230131150030.1250104-1-sashal@kernel.org>
References: <20230131150030.1250104-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 6795e558e9cc6123c24e2100a2ebe88e58a792bc ]

From core PMU's perspective, Emerald Rapids is the same as the Sapphire
Rapids. The only difference is the event list, which will be
supported in the perf tool later.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20230106160449.3566477-1-kan.liang@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index f36fda2672e0..b70e1522a27a 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -6109,6 +6109,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case INTEL_FAM6_SAPPHIRERAPIDS_X:
+	case INTEL_FAM6_EMERALDRAPIDS_X:
 		pmem = true;
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, spr_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-- 
2.39.0

