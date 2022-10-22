Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2BE608912
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJVIbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiJVI2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:28:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056BE2E1B94;
        Sat, 22 Oct 2022 01:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EFD360ADC;
        Sat, 22 Oct 2022 07:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08541C433D6;
        Sat, 22 Oct 2022 07:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425567;
        bh=GYMheR2uDf5Pu2mG9xm6Hst+j27aQrPCPR8epawv2K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v8mH59dz/vwuh9670EI9hy5RsbWgYInYBkOtKkfvhnduSG+lRSUXwR2D11tat9mqA
         DCEXxAHQBfXf7Vk5Hm7n79uxbddBMLYoRBGX1ku+gZLyTtN87sNoPZP5tyEKuvlw79
         CMn7p7FGy08M5jKIsySe9A+rDxOmgnQi4RAjLlAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Perry Yuan <Perry.Yuan@amd.com>,
        Su Jinzhou <jinzhou.su@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 543/717] cpufreq: amd_pstate: fix wrong lowest perf fetch
Date:   Sat, 22 Oct 2022 09:27:02 +0200
Message-Id: <20221022072522.360550037@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 365f3ad166a7..d63a28c5f95a 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -322,7 +322,7 @@ static int amd_pstate_target(struct cpufreq_policy *policy,
 		return -ENODEV;
 
 	cap_perf = READ_ONCE(cpudata->highest_perf);
-	min_perf = READ_ONCE(cpudata->lowest_nonlinear_perf);
+	min_perf = READ_ONCE(cpudata->lowest_perf);
 	max_perf = cap_perf;
 
 	freqs.old = policy->cur;
-- 
2.35.1



