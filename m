Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7D85F8DFC
	for <lists+stable@lfdr.de>; Sun,  9 Oct 2022 22:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiJIUwU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Oct 2022 16:52:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJIUvz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Oct 2022 16:51:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D482C133;
        Sun,  9 Oct 2022 13:51:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26489B80DC4;
        Sun,  9 Oct 2022 20:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C42C433D6;
        Sun,  9 Oct 2022 20:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665348707;
        bh=tHfN6BYz8GUisA7mlINoGmfs1MGickeA/p1BahPBHXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=djVj1LbAndX7Jr6NqxP+LA7yNOGuYDCK14iT5nA4v65V8I/9U53q8OvAzg7SNsxhO
         PUjSR28q9NlVA9gT5E0ZAr0nhh/TNcS7cX50s54JHU2At7+gNluVU5zZgZjRDwrr8/
         TUuHIG7U6CWExdX/hGDOi9yxmKVz3Zfm5grh22i9mFpNFLRot5DKazATTGmiBr7oof
         vQnqY8lVzGkq4RUPkxGT4sgHMdU/VnxTxTQqO4S4zvAytuNLSaeYaMaJXKd3DwM8gc
         UvyEyMXz5Y/kVYB0CRo4SPeGDGP2VJ68nU6818b7Y7kOiWZYKzS7cUt55ZZP82X30q
         SPswJ3WLIXVtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Perry Yuan <Perry.Yuan@amd.com>, Huang Rui <ray.huang@amd.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Su Jinzhou <jinzhou.su@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 06/18] cpufreq: amd_pstate: fix wrong lowest perf fetch
Date:   Sun,  9 Oct 2022 16:51:23 -0400
Message-Id: <20221009205136.1201774-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009205136.1201774-1-sashal@kernel.org>
References: <20221009205136.1201774-1-sashal@kernel.org>
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

