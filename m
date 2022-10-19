Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4829B604273
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbiJSLDS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:03:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbiJSLC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:02:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17BA171CCF;
        Wed, 19 Oct 2022 03:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AF86B8249D;
        Wed, 19 Oct 2022 09:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9DF5C433D6;
        Wed, 19 Oct 2022 09:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170470;
        bh=GYMheR2uDf5Pu2mG9xm6Hst+j27aQrPCPR8epawv2K8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZpVM1VASNxlV9WB3gSaYFs9If9Leo8Kd1EVovpCa4Lkp5mTH4QQEB7yA8oLbX/oD
         gBm25XdOmRkS/3mtNUx75wM8rpFch+5su6fQ9jEDpZT1NdOW9mW8EYS+vDZEjw+Fh/
         545m5uzeI7CKXhdzgOlb31iH2U6HlhoQf1mKVJ24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huang Rui <ray.huang@amd.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Perry Yuan <Perry.Yuan@amd.com>,
        Su Jinzhou <jinzhou.su@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 666/862] cpufreq: amd_pstate: fix wrong lowest perf fetch
Date:   Wed, 19 Oct 2022 10:32:33 +0200
Message-Id: <20221019083319.391323874@linuxfoundation.org>
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



