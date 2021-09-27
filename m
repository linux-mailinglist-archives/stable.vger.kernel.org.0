Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC8E419B05
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbhI0RO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:14:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhI0RN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092AD6120D;
        Mon, 27 Sep 2021 17:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762585;
        bh=ZQYohQ45qjgN9TtJnU2VAstagpsYqmT6TLxYt6fdU7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeNMniDMpw91FJA/Xd545V78JN4I16kTpxK/JS9UPo8fcL2XE1DVBRLfHGSxDqxao
         DFbqi0WtIXw/faRutNWgjCadIFgQN3M/O05CrSJWhoJuf5qQxO56NdN4iAqC0D5S24
         4n5j7pzGZCkMny12G/QOeEa4LDPEJUB28AtsEzv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Doug Smythies <dsmythies@telus.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/103] cpufreq: intel_pstate: Override parameters if HWP forced by BIOS
Date:   Mon, 27 Sep 2021 19:02:51 +0200
Message-Id: <20210927170228.498079640@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
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
index 44a5d15a7572..1686705bee7b 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3035,11 +3035,15 @@ static int __init intel_pstate_init(void)
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
@@ -3049,8 +3053,7 @@ static int __init intel_pstate_init(void)
 		 * If HWP is enabled already, though, there is no choice but to
 		 * deal with it.
 		 */
-		if ((!no_hwp && boot_cpu_has(X86_FEATURE_HWP_EPP)) ||
-		    intel_pstate_hwp_is_enabled()) {
+		if ((!no_hwp && boot_cpu_has(X86_FEATURE_HWP_EPP)) || hwp_forced) {
 			hwp_active++;
 			hwp_mode_bdw = id->driver_data;
 			intel_pstate.attr = hwp_cpufreq_attrs;
@@ -3061,7 +3064,11 @@ static int __init intel_pstate_init(void)
 
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
@@ -3138,10 +3145,9 @@ static int __init intel_pstate_setup(char *str)
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



