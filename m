Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29B24FD892
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237909AbiDLHbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353550AbiDLHZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:25:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F5C26100;
        Tue, 12 Apr 2022 00:01:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28E4CB81B35;
        Tue, 12 Apr 2022 07:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97799C385A6;
        Tue, 12 Apr 2022 07:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746880;
        bh=kUn2qAPqnhLi5OlFTb3kcm5yBG9tINbEWnBPKsnb0Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvD1R0xsGOFMGzCzY9MqOWkVKx8EclApREnhBeWbeZc5D/qLG36d+5Ojuybt7lmlA
         kFEAiTOpZb9d8+TKvNkrihCFPeXEBLFKu1BMdhpFEJudACwP0B5ngeWZBNHTeEWxAh
         cwX8h8eNu3f8jVMNR6knDVS/kAyfsMR4emxyFN4M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 123/285] opp: Expose of-nodes name in debugfs
Date:   Tue, 12 Apr 2022 08:29:40 +0200
Message-Id: <20220412062947.215634701@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 021dbecabc93b1610b5db989d52a94e0c6671136 ]

It is difficult to find which OPPs are active at the moment, specially
if there are multiple OPPs with same frequency available in the device
tree (controlled by supported hardware feature).

Expose name of the DT node to find out the exact OPP.

While at it, also expose level field.

Reported-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/debugfs.c | 5 +++++
 drivers/opp/opp.h     | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index 596c185b5dda..b5f2f9f39392 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -10,6 +10,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/init.h>
 #include <linux/limits.h>
 #include <linux/slab.h>
@@ -131,9 +132,13 @@ void opp_debug_create_one(struct dev_pm_opp *opp, struct opp_table *opp_table)
 	debugfs_create_bool("suspend", S_IRUGO, d, &opp->suspend);
 	debugfs_create_u32("performance_state", S_IRUGO, d, &opp->pstate);
 	debugfs_create_ulong("rate_hz", S_IRUGO, d, &opp->rate);
+	debugfs_create_u32("level", S_IRUGO, d, &opp->level);
 	debugfs_create_ulong("clock_latency_ns", S_IRUGO, d,
 			     &opp->clock_latency_ns);
 
+	opp->of_name = of_node_full_name(opp->np);
+	debugfs_create_str("of_name", S_IRUGO, d, (char **)&opp->of_name);
+
 	opp_debug_create_supplies(opp, opp_table, d);
 	opp_debug_create_bw(opp, opp_table, d);
 
diff --git a/drivers/opp/opp.h b/drivers/opp/opp.h
index 407c3bfe51d9..45e3a55239a1 100644
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -96,6 +96,7 @@ struct dev_pm_opp {
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dentry;
+	const char *of_name;
 #endif
 };
 
-- 
2.35.1



