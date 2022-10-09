Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01FB5F8E05
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiJIUwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJIUwR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:52:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100E522B02;
        Sun,  9 Oct 2022 13:51:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 609FDB80DC4;
        Sun,  9 Oct 2022 20:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA9BC433B5;
        Sun,  9 Oct 2022 20:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348715;
        bh=PU8iaCs2iWQxeCCZgNEo4F7oo3UpqlSd8bf4uBmxP6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTTMHX7gU32ChNqKpyI9sQmchRAZwuqddxDVBenQ9mAoPxQ1k2DRsflKE/DWJRiET
         /KRlPKFmfk5wG189ctR1pTGqDVElaY4ISu9LVutFdUVbFzEDSsc4TQ+PPVAbSZ6Tjt
         M8g/nvUUeJsarzSeyiThQ/U8kqst6U4nJYmxUjUqqj7M8YWtcHxCn8CpVJW+IiMgBe
         edYvc+6030iPgWGv/uUtwfYLpZOLoszs+24UQPcELll0l6gmbsoQO/FMBL3Q8nuSmZ
         y4fkYY8r1/blakkGF+wdqFFwzrBv0kRtOYm8S496HsG2gFrvgk+7wAxm8Mnx9IynX4
         Odjd28oY+888A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.pandruvada@linux.intel.com, lenb@kernel.org,
        rafael@kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 10/18] cpufreq: intel_pstate: Add Tigerlake support in no-HWP mode
Date:   Sun,  9 Oct 2022 16:51:27 -0400
Message-Id: <20221009205136.1201774-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205136.1201774-1-sashal@kernel.org>
References: <20221009205136.1201774-1-sashal@kernel.org>
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

From: Doug Smythies <dsmythies@telus.net>

[ Upstream commit 71bb5c82aaaea007167f3ba68d3a669c74d7d55d ]

Users may disable HWP in firmware, in which case intel_pstate wouldn't load
unless the CPU model is explicitly supported.

Add TIGERLAKE to the list of CPUs that can register intel_pstate while not
advertising the HWP capability. Without this change, an TIGERLAKE in no-HWP
mode could only use the acpi_cpufreq frequency scaling driver.

See also commits:
d8de7a44e11f: cpufreq: intel_pstate: Add Skylake servers support
fbdc21e9b038: cpufreq: intel_pstate: Add Icelake servers support in no-HWP mode
706c5328851d: cpufreq: intel_pstate: Add Cometlake support in no-HWP mode

Reported by: M. Cargi Ari <cagriari@pm.me>
Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 57cdb3679885..fc3ebeb0bbe5 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2416,6 +2416,7 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	X86_MATCH(SKYLAKE_X,		core_funcs),
 	X86_MATCH(COMETLAKE,		core_funcs),
 	X86_MATCH(ICELAKE_X,		core_funcs),
+	X86_MATCH(TIGERLAKE,		core_funcs),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
2.35.1

