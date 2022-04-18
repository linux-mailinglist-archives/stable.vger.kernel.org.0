Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8774505318
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238164AbiDRMzn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240197AbiDRMzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:55:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548C72314E;
        Mon, 18 Apr 2022 05:35:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2F1DCE10A1;
        Mon, 18 Apr 2022 12:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93900C385A1;
        Mon, 18 Apr 2022 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285350;
        bh=3bXJTGa4nB+rHVKUU1SwJK0AvYctaHMhW1vyeWrlHhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKW1QqGXkvMK2znhZQGp06CbzpjScO4BiZNOBqf7gfFom+59AI/6YzXLflqywlFoK
         WlYrROs54+Izb3mfKaQv00SC3lPcjbflXf2LvKi6s0rnEyM5G6/74bz4Li5BTDf9Xz
         OJGhxMAESrKv1UOh5872o5Mjg0pg1CvtvzFkKzuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Michael Larabel <Michael@MichaelLarabel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Subject: [PATCH 5.15 181/189] cpufreq: intel_pstate: ITMT support for overclocked system
Date:   Mon, 18 Apr 2022 14:13:21 +0200
Message-Id: <20220418121208.290534383@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 03c83982a0278207709143ba78c5a470179febee upstream.

On systems with overclocking enabled, CPPC Highest Performance can be
hard coded to 0xff. In this case even if we have cores with different
highest performance, ITMT can't be enabled as the current implementation
depends on CPPC Highest Performance.

On such systems we can use MSR_HWP_CAPABILITIES maximum performance field
when CPPC.Highest Performance is 0xff.

Due to legacy reasons, we can't solely depend on MSR_HWP_CAPABILITIES as
in some older systems CPPC Highest Performance is the only way to identify
different performing cores.

Reported-by: Michael Larabel <Michael@MichaelLarabel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Tested-by: Michael Larabel <Michael@MichaelLarabel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/intel_pstate.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -335,6 +335,8 @@ static void intel_pstste_sched_itmt_work
 
 static DECLARE_WORK(sched_itmt_work, intel_pstste_sched_itmt_work_fn);
 
+#define CPPC_MAX_PERF	U8_MAX
+
 static void intel_pstate_set_itmt_prio(int cpu)
 {
 	struct cppc_perf_caps cppc_perf;
@@ -346,6 +348,14 @@ static void intel_pstate_set_itmt_prio(i
 		return;
 
 	/*
+	 * On some systems with overclocking enabled, CPPC.highest_perf is hardcoded to 0xff.
+	 * In this case we can't use CPPC.highest_perf to enable ITMT.
+	 * In this case we can look at MSR_HWP_CAPABILITIES bits [8:0] to decide.
+	 */
+	if (cppc_perf.highest_perf == CPPC_MAX_PERF)
+		cppc_perf.highest_perf = HWP_HIGHEST_PERF(READ_ONCE(all_cpu_data[cpu]->hwp_cap_cached));
+
+	/*
 	 * The priorities can be set regardless of whether or not
 	 * sched_set_itmt_support(true) has been called and it is valid to
 	 * update them at any time after it has been called.


