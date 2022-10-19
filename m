Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4479603DC5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiJSJGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbiJSJF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161209F760;
        Wed, 19 Oct 2022 01:59:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C4D661824;
        Wed, 19 Oct 2022 08:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F8FC433B5;
        Wed, 19 Oct 2022 08:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169242;
        bh=1uVmc6hJkhsVlg30rXcmh4sw1hCaTQ5SkWgcWSh8PLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4+76MFUHESST6hc2jYxiMwVGbUVAVDySqVEEIbCtuyzpMeU176PqfzyrFPp/5z14
         0PFqKm/PVg2ENRpYApeAbHWGYdH+C74HpO903rf5sCiXUqlTr/gqNsfEB1Ytgy1LFw
         bwGtc2SLkFlMU3xWMipTQchpUP8VC8g645lv3bks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xuewen Yan <xuewen.yan@unisoc.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 207/862] thermal: cpufreq_cooling: Check the policy first in cpufreq_cooling_register()
Date:   Wed, 19 Oct 2022 10:24:54 +0200
Message-Id: <20221019083259.160174548@linuxfoundation.org>
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

From: Xuewen Yan <xuewen.yan@unisoc.com>

[ Upstream commit cff895277c8558221ba180aefe26799dcb4eec86 ]

Since the policy needs to be accessed first when obtaining cpu devices,
first check whether the policy is legal before this.

Fixes: 5130802ddbb1 ("thermal: cpu_cooling: Switch to QoS requests for freq limits")
Signed-off-by: Xuewen Yan <xuewen.yan@unisoc.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/cpufreq_cooling.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/thermal/cpufreq_cooling.c b/drivers/thermal/cpufreq_cooling.c
index b76293cc989c..7838b6e2dba5 100644
--- a/drivers/thermal/cpufreq_cooling.c
+++ b/drivers/thermal/cpufreq_cooling.c
@@ -501,17 +501,17 @@ __cpufreq_cooling_register(struct device_node *np,
 	struct thermal_cooling_device_ops *cooling_ops;
 	char *name;
 
+	if (IS_ERR_OR_NULL(policy)) {
+		pr_err("%s: cpufreq policy isn't valid: %p\n", __func__, policy);
+		return ERR_PTR(-EINVAL);
+	}
+
 	dev = get_cpu_device(policy->cpu);
 	if (unlikely(!dev)) {
 		pr_warn("No cpu device for cpu %d\n", policy->cpu);
 		return ERR_PTR(-ENODEV);
 	}
 
-	if (IS_ERR_OR_NULL(policy)) {
-		pr_err("%s: cpufreq policy isn't valid: %p\n", __func__, policy);
-		return ERR_PTR(-EINVAL);
-	}
-
 	i = cpufreq_table_count_valid_entries(policy);
 	if (!i) {
 		pr_debug("%s: CPUFreq table not found or has no valid entries\n",
-- 
2.35.1



