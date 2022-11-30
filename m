Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67E763DFCE
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiK3Suk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbiK3Sud (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99B49D83A
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76A5261D84
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874BEC433C1;
        Wed, 30 Nov 2022 18:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834231;
        bh=G5BNTwF674l+IZbN/9mH7YmgwJu3d8ZWMmuVd7Cd+aU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRpy7SOoG88yy1tzgjL3RMWFNoru83eBXECKpCj2kJvvexmdFw1tXfbm1pdS/jRdq
         3oj0hABZ5jJ8lxYnaySceaPSY1q/ximIs19y8eiEP8BFACZfBwUprH9YKGkgpNyz05
         qr0vvPShR0NlRNFSqTpVbwnEow3BDVPSXhVOfvVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Huang Rui <ray.huang@amd.com>,
        "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
        Wyes Karny <wyes.karny@amd.com>,
        Perry Yuan <Perry.Yuan@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.0 178/289] cpufreq: amd-pstate: cpufreq: amd-pstate: reset MSR_AMD_PERF_CTL register at init
Date:   Wed, 30 Nov 2022 19:22:43 +0100
Message-Id: <20221130180548.164273836@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wyes Karny <wyes.karny@amd.com>

commit 919f4557696939625085435ebde09a539de2349c upstream.

MSR_AMD_PERF_CTL is guaranteed to be 0 on a cold boot. However, on a
kexec boot, for instance, it may have a non-zero value (if the cpu was
in a non-P0 Pstate).  In such cases, the cores with non-P0 Pstates at
boot will never be pushed to P0, let alone boost frequencies.

Kexec is a common workflow for reboot on Linux and this creates a
regression in performance. Fix it by explicitly setting the
MSR_AMD_PERF_CTL to 0 during amd_pstate driver init.

Cc: All applicable <stable@vger.kernel.org>
Acked-by: Huang Rui <ray.huang@amd.com>
Reviewed-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Tested-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Wyes Karny <wyes.karny@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cpufreq/amd-pstate.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -483,12 +483,22 @@ static void amd_pstate_boost_init(struct
 	amd_pstate_driver.boost_enabled = true;
 }
 
+static void amd_perf_ctl_reset(unsigned int cpu)
+{
+	wrmsrl_on_cpu(cpu, MSR_AMD_PERF_CTL, 0);
+}
+
 static int amd_pstate_cpu_init(struct cpufreq_policy *policy)
 {
 	int min_freq, max_freq, nominal_freq, lowest_nonlinear_freq, ret;
 	struct device *dev;
 	struct amd_cpudata *cpudata;
 
+	/*
+	 * Resetting PERF_CTL_MSR will put the CPU in P0 frequency,
+	 * which is ideal for initialization process.
+	 */
+	amd_perf_ctl_reset(policy->cpu);
 	dev = get_cpu_device(policy->cpu);
 	if (!dev)
 		return -ENODEV;


