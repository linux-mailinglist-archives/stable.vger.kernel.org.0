Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6E66041B7
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbiJSKru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiJSKqj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:46:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A9511541D;
        Wed, 19 Oct 2022 03:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E5EEB821A3;
        Wed, 19 Oct 2022 08:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C36C433C1;
        Wed, 19 Oct 2022 08:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169245;
        bh=yXakOncocmAMdyM9Kp+4spb4pV7+704OueZkYTIj4p4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIfRvTTzFSQy2dMutRqgGAM3u2zaJsSQI3p6vLgEVzwYhJl82FTpHOYYVicECo748
         6PVzMKcPHda+2Fyd5FDHz/3RXvLwd3x4l3v3cXq1h5qJjYTQy0WJg3qKpB9yTfR1dF
         KME4gSpMaQnMIQBCX1bv+IszxzXbxJDyba7TwoVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Perry Yuan <Perry.Yuan@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 208/862] cpufreq: amd-pstate: Fix initial highest_perf value
Date:   Wed, 19 Oct 2022 10:24:55 +0200
Message-Id: <20221019083259.199144536@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Perry Yuan <Perry.Yuan@amd.com>

[ Upstream commit bedadcfb011fef55273bd686e8893fdd8911dcdb ]

To avoid some new AMD processors use wrong highest perf when amd pstate
driver loaded, this fix will query the highest perf from MSR register
MSR_AMD_CPPC_CAP1 and cppc_acpi interface firstly, then compare with the
highest perf value got by calling amd_get_highest_perf() function.

The lower value will be the correct highest perf we need to use.
Otherwise the CPU max MHz will be incorrect if the
amd_get_highest_perf() did not cover the new process family and model ID.

Like this lscpu info, the max frequency is incorrect.

Vendor ID:               AuthenticAMD
    Socket(s):           1
    Stepping:            2
    CPU max MHz:         5410.0000
    CPU min MHz:         400.0000
    BogoMIPS:            5600.54

Fixes: 3743d55b289c2 (x86, sched: Fix the AMD CPPC maximum performance value on certain AMD Ryzen generations)
Acked-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 9ac75c1cde9c..365f3ad166a7 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -152,6 +152,7 @@ static inline int amd_pstate_enable(bool enable)
 static int pstate_init_perf(struct amd_cpudata *cpudata)
 {
 	u64 cap1;
+	u32 highest_perf;
 
 	int ret = rdmsrl_safe_on_cpu(cpudata->cpu, MSR_AMD_CPPC_CAP1,
 				     &cap1);
@@ -163,7 +164,11 @@ static int pstate_init_perf(struct amd_cpudata *cpudata)
 	 *
 	 * CPPC entry doesn't indicate the highest performance in some ASICs.
 	 */
-	WRITE_ONCE(cpudata->highest_perf, amd_get_highest_perf());
+	highest_perf = amd_get_highest_perf();
+	if (highest_perf > AMD_CPPC_HIGHEST_PERF(cap1))
+		highest_perf = AMD_CPPC_HIGHEST_PERF(cap1);
+
+	WRITE_ONCE(cpudata->highest_perf, highest_perf);
 
 	WRITE_ONCE(cpudata->nominal_perf, AMD_CPPC_NOMINAL_PERF(cap1));
 	WRITE_ONCE(cpudata->lowest_nonlinear_perf, AMD_CPPC_LOWNONLIN_PERF(cap1));
@@ -175,12 +180,17 @@ static int pstate_init_perf(struct amd_cpudata *cpudata)
 static int cppc_init_perf(struct amd_cpudata *cpudata)
 {
 	struct cppc_perf_caps cppc_perf;
+	u32 highest_perf;
 
 	int ret = cppc_get_perf_caps(cpudata->cpu, &cppc_perf);
 	if (ret)
 		return ret;
 
-	WRITE_ONCE(cpudata->highest_perf, amd_get_highest_perf());
+	highest_perf = amd_get_highest_perf();
+	if (highest_perf > cppc_perf.highest_perf)
+		highest_perf = cppc_perf.highest_perf;
+
+	WRITE_ONCE(cpudata->highest_perf, highest_perf);
 
 	WRITE_ONCE(cpudata->nominal_perf, cppc_perf.nominal_perf);
 	WRITE_ONCE(cpudata->lowest_nonlinear_perf,
-- 
2.35.1



