Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614F8F7CE1
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfKKSuq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728938AbfKKSup (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ECC120674;
        Mon, 11 Nov 2019 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498244;
        bh=SLOivCk1713bYurRj/oTAO4NkgPSRFCVrj6Tjlrqb6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yF+LLEDMUpB7WqEKJyZfxQWySLo1O8hQBJvZ4psmL7h3TgBY0UHHArrfPEuyONdiQ
         EwVUxbkq17OSn6JvBwBq9k6839CSzM8lmTKgHN34F7tCLMDR859rDEfgZnjNx62+4w
         DckqaCWWXEf/WFhXJjA6EqBG5rPPbhq2douxGIYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.3 062/193] cpufreq: intel_pstate: Fix invalid EPB setting
Date:   Mon, 11 Nov 2019 19:27:24 +0100
Message-Id: <20191111181505.577283585@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit c31432fa7f825de0e19838f1ac7746381c509ec4 upstream.

The max value of EPB can only be 0x0F. Attempting to set more than that
triggers an "unchecked MSR access error" warning which happens in
intel_pstate_hwp_force_min_perf() called via cpufreq stop_cpu().

However, it is not even necessary to touch the EPB from intel_pstate,
because it is restored on every CPU online by the intel_epb.c code,
so let that code do the right thing and drop the redundant (and
incorrect) EPB update from intel_pstate.

Fixes: af3b7379e2d70 ("cpufreq: intel_pstate: Force HWP min perf before offline")
Reported-by: Qian Cai <cai@lca.pw>
Cc: 5.2+ <stable@vger.kernel.org> # 5.2+
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
[ rjw: Changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/intel_pstate.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -846,11 +846,9 @@ static void intel_pstate_hwp_force_min_p
 	value |= HWP_MAX_PERF(min_perf);
 	value |= HWP_MIN_PERF(min_perf);
 
-	/* Set EPP/EPB to min */
+	/* Set EPP to min */
 	if (boot_cpu_has(X86_FEATURE_HWP_EPP))
 		value |= HWP_ENERGY_PERF_PREFERENCE(HWP_EPP_POWERSAVE);
-	else
-		intel_pstate_set_epb(cpu, HWP_EPP_BALANCE_POWERSAVE);
 
 	wrmsrl_on_cpu(cpu, MSR_HWP_REQUEST, value);
 }


