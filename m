Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8965F8E67
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiJIU5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiJIUzw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:55:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F762ED76;
        Sun,  9 Oct 2022 13:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 878B660C85;
        Sun,  9 Oct 2022 20:53:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F36C433D6;
        Sun,  9 Oct 2022 20:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348802;
        bh=792Gi43czhTMgXV+w5HjgkYeuTlyibvTb6CJLgn7Xyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=efd/1cFQDtrV9YJ+qRbemo+Wnpduhpic+x2/hOxTdvn8vxL9+pog+HZdoOq5Azol9
         wK5S30Vh6eLwcNhInjJS6QtkP8K4bWDgKhWAqEt5fwSdMDmGv+BZ4lRP0W6XdQv5TO
         zAlIW3FCTX1PH2T7zVwlISWJP2PSnsK7uScX6Ro+lVILGVSj3k1EMkBlUBWB1dSiYw
         i776jtcTcLO/4/alcZc3A2orM2w5nWdqAtCpoXGg9pcH7vQhiIIQA9vgQbURuEnKeB
         OovdN16zyZJ8vmFHNRHRWfejDsucHe5yGUntOxbfzhEQTa5TyM9mDZI+rJhREaAY8K
         iVcCf0GNJHvUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Doug Smythies <dsmythies@telus.net>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        srinivas.pandruvada@linux.intel.com, lenb@kernel.org,
        rafael@kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/15] cpufreq: intel_pstate: Add Tigerlake support in no-HWP mode
Date:   Sun,  9 Oct 2022 16:53:00 -0400
Message-Id: <20221009205308.1202627-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205308.1202627-1-sashal@kernel.org>
References: <20221009205308.1202627-1-sashal@kernel.org>
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
index 8a2c6b58b652..c57229c108a7 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -2257,6 +2257,7 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	X86_MATCH(SKYLAKE_X,		core_funcs),
 	X86_MATCH(COMETLAKE,		core_funcs),
 	X86_MATCH(ICELAKE_X,		core_funcs),
+	X86_MATCH(TIGERLAKE,		core_funcs),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_pstate_cpu_ids);
-- 
2.35.1

