Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 147063832A6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240906AbhEQOuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:50:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239301AbhEQOsC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BBCC261973;
        Mon, 17 May 2021 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261334;
        bh=qWnEuDp7tInVLGa7lowuhueGdRtSWa778KG1J/vM9ns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLURY65LdWtXuHX8x3Awy/LJdtNFftoCliShUI9vY4amIG8rXa6QZMGhAg+0er3vw
         uQhzkc3GOnF4v2ramzDA4pd+x62PZx5u0iA/PswWOa350YbgHCwcBOaHrWucAL+CdM
         ds1aBiT8kHn9KnnfnvxY5Xyw1nJBJbVG0lXE7EOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 009/289] cpufreq: intel_pstate: Use HWP if enabled by platform firmware
Date:   Mon, 17 May 2021 15:58:54 +0200
Message-Id: <20210517140305.489057408@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit e5af36b2adb858e982d78d41d7363d05d951a19a upstream.

It turns out that there are systems where HWP is enabled during
initialization by the platform firmware (BIOS), but HWP EPP support
is not advertised.

After commit 7aa1031223bc ("cpufreq: intel_pstate: Avoid enabling HWP
if EPP is not supported") intel_pstate refuses to use HWP on those
systems, but the fallback PERF_CTL interface does not work on them
either because of enabled HWP, and once enabled, HWP cannot be
disabled.  Consequently, the users of those systems cannot control
CPU performance scaling.

Address this issue by making intel_pstate use HWP unconditionally if
it is enabled already when the driver starts.

Fixes: 7aa1031223bc ("cpufreq: intel_pstate: Avoid enabling HWP if EPP is not supported")
Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -3019,6 +3019,14 @@ static const struct x86_cpu_id hwp_suppo
 	{}
 };
 
+static bool intel_pstate_hwp_is_enabled(void)
+{
+	u64 value;
+
+	rdmsrl(MSR_PM_ENABLE, value);
+	return !!(value & 0x1);
+}
+
 static int __init intel_pstate_init(void)
 {
 	const struct x86_cpu_id *id;
@@ -3037,8 +3045,12 @@ static int __init intel_pstate_init(void
 		 * Avoid enabling HWP for processors without EPP support,
 		 * because that means incomplete HWP implementation which is a
 		 * corner case and supporting it is generally problematic.
+		 *
+		 * If HWP is enabled already, though, there is no choice but to
+		 * deal with it.
 		 */
-		if (!no_hwp && boot_cpu_has(X86_FEATURE_HWP_EPP)) {
+		if ((!no_hwp && boot_cpu_has(X86_FEATURE_HWP_EPP)) ||
+		    intel_pstate_hwp_is_enabled()) {
 			hwp_active++;
 			hwp_mode_bdw = id->driver_data;
 			intel_pstate.attr = hwp_cpufreq_attrs;


