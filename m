Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D868529B420
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783531AbgJ0O6X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:58:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1783516AbgJ0O6U (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:58:20 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21E6820715;
        Tue, 27 Oct 2020 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810699;
        bh=JuPxfT0FCxBqV3KtPMO2Sa4dyRvIAFOP3/in2Zo+aOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qy8NSeQI9sVngGV2PxoZR7hD2T2b8l5AC/iTi2PFjLtCW6Zj8a30b8ZoXsfH4+qEO
         7H1HHj4PLOmVw1RI/FzH0VEelPh50OU5PxI/5GG7bsft1o7hcyOMkN67h1OrbplGCG
         1UTlu0XkoEsuoJCwSkYVfy7w0f48ER2CXbK9prWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 232/633] coresight: etm4x: Ensure default perf settings filter user/kernel
Date:   Tue, 27 Oct 2020 14:49:35 +0100
Message-Id: <20201027135533.564927023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Leach <mike.leach@linaro.org>

[ Upstream commit 096dcfb9cd6fefa7c03884b50c247593dc5f7dd3 ]

Moving from using an address filter to trace the default "all addresses"
range to no filtering to acheive the same result, has caused the perf
filtering of kernel/user address spaces from not working unless an
explicit address filter was used.

This is due to the original code using a side-effect of the address
filtering rather than setting the global TRCVICTLR exception level
filtering.

The use of the mode sysfs file is also similarly affected.

A helper function is added to fix both instances.

Fixes: ae2041510d5d ("coresight: etmv4: Update default filter and initialisation")
Reported-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20200916191737.4001561-8-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x.c | 32 +++++++++++++------
 drivers/hwtracing/coresight/coresight-etm4x.h |  3 ++
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x.c b/drivers/hwtracing/coresight/coresight-etm4x.c
index a970bd17edf8d..7a247273b7e0a 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x.c
@@ -52,6 +52,7 @@ static struct etmv4_drvdata *etmdrvdata[NR_CPUS];
 static void etm4_set_default_config(struct etmv4_config *config);
 static int etm4_set_event_filters(struct etmv4_drvdata *drvdata,
 				  struct perf_event *event);
+static u64 etm4_get_access_type(struct etmv4_config *config);
 
 static enum cpuhp_state hp_online;
 
@@ -779,6 +780,22 @@ static void etm4_init_arch_data(void *info)
 	CS_LOCK(drvdata->base);
 }
 
+/* Set ELx trace filter access in the TRCVICTLR register */
+static void etm4_set_victlr_access(struct etmv4_config *config)
+{
+	u64 access_type;
+
+	config->vinst_ctrl &= ~(ETM_EXLEVEL_S_VICTLR_MASK | ETM_EXLEVEL_NS_VICTLR_MASK);
+
+	/*
+	 * TRCVICTLR::EXLEVEL_NS:EXLEVELS: Set kernel / user filtering
+	 * bits in vinst_ctrl, same bit pattern as TRCACATRn values returned by
+	 * etm4_get_access_type() but with a relative shift in this register.
+	 */
+	access_type = etm4_get_access_type(config) << ETM_EXLEVEL_LSHIFT_TRCVICTLR;
+	config->vinst_ctrl |= (u32)access_type;
+}
+
 static void etm4_set_default_config(struct etmv4_config *config)
 {
 	/* disable all events tracing */
@@ -796,6 +813,9 @@ static void etm4_set_default_config(struct etmv4_config *config)
 
 	/* TRCVICTLR::EVENT = 0x01, select the always on logic */
 	config->vinst_ctrl = BIT(0);
+
+	/* TRCVICTLR::EXLEVEL_NS:EXLEVELS: Set kernel / user filtering */
+	etm4_set_victlr_access(config);
 }
 
 static u64 etm4_get_ns_access_type(struct etmv4_config *config)
@@ -1060,7 +1080,7 @@ static int etm4_set_event_filters(struct etmv4_drvdata *drvdata,
 
 void etm4_config_trace_mode(struct etmv4_config *config)
 {
-	u32 addr_acc, mode;
+	u32 mode;
 
 	mode = config->mode;
 	mode &= (ETM_MODE_EXCL_KERN | ETM_MODE_EXCL_USER);
@@ -1072,15 +1092,7 @@ void etm4_config_trace_mode(struct etmv4_config *config)
 	if (!(mode & ETM_MODE_EXCL_KERN) && !(mode & ETM_MODE_EXCL_USER))
 		return;
 
-	addr_acc = config->addr_acc[ETM_DEFAULT_ADDR_COMP];
-	/* clear default config */
-	addr_acc &= ~(ETM_EXLEVEL_NS_APP | ETM_EXLEVEL_NS_OS |
-		      ETM_EXLEVEL_NS_HYP);
-
-	addr_acc |= etm4_get_ns_access_type(config);
-
-	config->addr_acc[ETM_DEFAULT_ADDR_COMP] = addr_acc;
-	config->addr_acc[ETM_DEFAULT_ADDR_COMP + 1] = addr_acc;
+	etm4_set_victlr_access(config);
 }
 
 static int etm4_online_cpu(unsigned int cpu)
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 47729e04aac72..ab38f9afd821a 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -192,6 +192,9 @@
 #define ETM_EXLEVEL_NS_HYP		BIT(14)
 #define ETM_EXLEVEL_NS_NA		BIT(15)
 
+/* access level control in TRCVICTLR - same bits as TRCACATRn but shifted */
+#define ETM_EXLEVEL_LSHIFT_TRCVICTLR	8
+
 /* secure / non secure masks - TRCVICTLR, IDR3 */
 #define ETM_EXLEVEL_S_VICTLR_MASK	GENMASK(19, 16)
 /* NS MON (EL3) mode never implemented */
-- 
2.25.1



