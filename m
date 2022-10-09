Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F89D5F8E28
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiJIUyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiJIUxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE66B2C678;
        Sun,  9 Oct 2022 13:52:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DF9C60C98;
        Sun,  9 Oct 2022 20:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B833C433B5;
        Sun,  9 Oct 2022 20:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348754;
        bh=tHfN6BYz8GUisA7mlINoGmfs1MGickeA/p1BahPBHXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBER0LMbXEaUP9+nS5c0dx8+y6yM0XUWD/RjF+CC8C7PWgxg1QfmcWAI+VR8MYeTV
         M2v76+xSRtOEU9xE1slFR6DnM/pK2P6wtAekW5KXrU1vC5GCg/msjHEg6Ggnr4fZHG
         Vrrf+N+QE5p3yTgI7IT4CO61251Jmb2ZCjk+9AGVVBkgVGqLcRmDfXJAgcVoRo6ZY1
         CQJXzEiPAA5ePJSVy656aR0XHRWgTbX/uMhJrVRZZNtwoD/LLfHBrj5czcnVovBOuS
         JOZm4tINkTJSJOjzK0Vbr30jklw0y+2UGrOrObxKInsSUwu4rq+kXvsznlNTKmdqa/
         WVnEfUJgq/yzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Perry Yuan <Perry.Yuan@amd.com>, Huang Rui <ray.huang@amd.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Su Jinzhou <jinzhou.su@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 04/16] cpufreq: amd_pstate: fix wrong lowest perf fetch
Date:   Sun,  9 Oct 2022 16:52:13 -0400
Message-Id: <20221009205226.1202133-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205226.1202133-1-sashal@kernel.org>
References: <20221009205226.1202133-1-sashal@kernel.org>
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

From: Perry Yuan <Perry.Yuan@amd.com>

[ Upstream commit b185c5053c65b7704ead4537e4d4d9b33dc398dc ]

Fix the wrong lowest perf value reading which is used for new
des_perf calculation by governor requested, the incorrect min_perf will
get incorrect des_perf to be set , that will cause the system frequency
changing unexpectedly.

Reviewed-by: Huang Rui <ray.huang@amd.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Perry Yuan <Perry.Yuan@amd.com>
Signed-off-by: Su Jinzhou <jinzhou.su@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 9ac75c1cde9c..dd0eeb8589a1 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -312,7 +312,7 @@ static int amd_pstate_target(struct cpufreq_policy *policy,
 		return -ENODEV;
 
 	cap_perf = READ_ONCE(cpudata->highest_perf);
-	min_perf = READ_ONCE(cpudata->lowest_nonlinear_perf);
+	min_perf = READ_ONCE(cpudata->lowest_perf);
 	max_perf = cap_perf;
 
 	freqs.old = policy->cur;
-- 
2.35.1

