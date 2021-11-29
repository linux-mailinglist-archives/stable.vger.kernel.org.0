Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFA14625FD
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhK2Wpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:45:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbhK2WpC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:45:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAD1C19AC32;
        Mon, 29 Nov 2021 10:36:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 520D4CE13D8;
        Mon, 29 Nov 2021 18:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34A9C53FAD;
        Mon, 29 Nov 2021 18:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210962;
        bh=Z6W085lk+nzxVBhFeFPEK+XNSYKmNBG+pyKotXVALqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yD7adxxR+jBDUAOMXexf3MZB5Dkdu2n/mU5nHs8XCWiykjExu+/pvMnID/KsntEwP
         v0jq27VlAGr0rrVp6hi9zfUt1UUfNhNn24We1mQacYgnjvpqTsrS58vYqg1t4jEY+r
         SDJRAUNDLyvuLio8pr0O3HeZCcf9znGjXJ9CZB+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 054/179] cpufreq: intel_pstate: Fix active mode offline/online EPP handling
Date:   Mon, 29 Nov 2021 19:17:28 +0100
Message-Id: <20211129181720.749130076@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit ed38eb49d101e829ae0f8c0a0d3bf5cb6bcbc6b2 upstream.

After commit 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and
->online callbacks") the EPP value set by the "performance" scaling
algorithm in the active mode is not restored after an offline/online
cycle which replaces it with the saved EPP value coming from user
space.

Address this issue by forcing intel_pstate_hwp_set() to set a new
EPP value when it runs first time after online.

Fixes: 4adcf2e5829f ("cpufreq: intel_pstate: Add ->offline and ->online callbacks")
Link: https://lore.kernel.org/linux-pm/adc7132c8655bd4d1c8b6129578e931a14fe1db2.camel@linux.intel.com/
Reported-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -999,6 +999,12 @@ static void intel_pstate_hwp_offline(str
 		 */
 		value &= ~GENMASK_ULL(31, 24);
 		value |= HWP_ENERGY_PERF_PREFERENCE(cpu->epp_cached);
+		/*
+		 * However, make sure that EPP will be set to "performance" when
+		 * the CPU is brought back online again and the "performance"
+		 * scaling algorithm is still in effect.
+		 */
+		cpu->epp_policy = CPUFREQ_POLICY_UNKNOWN;
 	}
 
 	/*


