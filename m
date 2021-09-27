Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541B6419C7F
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236617AbhI0R3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237039AbhI0R0r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA0F610FC;
        Mon, 27 Sep 2021 17:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763003;
        bh=PW16eeWz8Y5WLarwGuS7EiITTB7r/2mGChyddayo/E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VafAmwMA0COwzlK8vz2XNWDz9CTBGaGR5+iOMWwOVD7hK9o3Yv7x21INi6NpDwh81
         +Rev5eStgMMcR0IY4BXwORrWFLBg2hkQEp/5EuoE1SbOIN1pkrU/EARzoKxAaF6DSb
         Ykv783EwpcazLRSrzS/hYAmTV3UlQ/fV1/RJ/Fpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 124/162] cpufreq: intel_pstate: Override parameters if HWP forced by BIOS
Date:   Mon, 27 Sep 2021 19:02:50 +0200
Message-Id: <20210927170237.731357262@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Doug Smythies <doug.smythies@gmail.com>

[ Upstream commit d9a7e9df731670acdc69e81748941ad338f47fab ]

If HWP has been already been enabled by BIOS, it may be
necessary to override some kernel command line parameters.
Once it has been enabled it requires a reset to be disabled.

Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Doug Smythies <dsmythies@telus.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index bb4549959b11..e7cd3882bda4 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3251,11 +3251,15 @@ static int __init intel_pstate_init(void)
 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
 		return -ENODEV;
 
-	if (no_load)
-		return -ENODEV;
-
 	id = x86_match_cpu(hwp_support_ids);
 	if (id) {
+		bool hwp_forced = intel_pstate_hwp_is_enabled();
+
+		if (hwp_forced)
+			pr_info("HWP enabled by BIOS\n");
+		else if (no_load)
+			return -ENODEV;
+
 		copy_cpu_funcs(&core_funcs);
 		/*
 		 * Avoid enabling HWP for processors without EPP support,
@@ -3265,8 +3269,7 @@ static int __init intel_pstate_init(void)
 		 * If HWP is enabled already, though, there is no choice but to
 		 * deal with it.
 		 */
-		if ((!no_hwp && boot_cpu_has(X86_FEATURE_HWP_EPP)) ||
-		    intel_pstate_hwp_is_enabled()) {
+		if ((!no_hwp && boot_cpu_has(X86_FEATURE_HWP_EPP)) || hwp_forced) {
 			hwp_active++;
 			hwp_mode_bdw = id->driver_data;
 			intel_pstate.attr = hwp_cpufreq_attrs;
@@ -3278,7 +3281,11 @@ static int __init intel_pstate_init(void)
 
 			goto hwp_cpu_matched;
 		}
+		pr_info("HWP not enabled\n");
 	} else {
+		if (no_load)
+			return -ENODEV;
+
 		id = x86_match_cpu(intel_pstate_cpu_ids);
 		if (!id) {
 			pr_info("CPU model not supported\n");
@@ -3357,10 +3364,9 @@ static int __init intel_pstate_setup(char *str)
 	else if (!strcmp(str, "passive"))
 		default_driver = &intel_cpufreq;
 
-	if (!strcmp(str, "no_hwp")) {
-		pr_info("HWP disabled\n");
+	if (!strcmp(str, "no_hwp"))
 		no_hwp = 1;
-	}
+
 	if (!strcmp(str, "force"))
 		force_load = 1;
 	if (!strcmp(str, "hwp_only"))
-- 
2.33.0



