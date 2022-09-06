Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690935AEDCF
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241900AbiIFObO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242035AbiIFOaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:30:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C9A9353D;
        Tue,  6 Sep 2022 06:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EDA3B818D7;
        Tue,  6 Sep 2022 13:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE96DC433D6;
        Tue,  6 Sep 2022 13:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471940;
        bh=p1KE7ryH9kD39E2fThC43eQc1l66oFtKBUl+vW2Q3Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DnqPqlMX8dMv2quocypUoBa/pQp1sJWUaDC/nRrzCTZpQsTWW7gEnWRsZYj5HZdmD
         3fZYcDjQzZERpSCWcFqAWRjHHBcNG5/JDwqABLfXfQ+CMs0GeoyKEicPVeDM6acFN9
         KqGhF5ZCSNKyck0jEmtafQN4joSnaJMPX+k3CuTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 091/155] powerpc/papr_scm: Fix nvdimm event mappings
Date:   Tue,  6 Sep 2022 15:30:39 +0200
Message-Id: <20220906132833.291395767@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 9b1ac04698a4bfec146322502cdcd9904c1777fa ]

Commit 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support")
added performance monitoring support for papr-scm nvdimm devices via
perf interface. Commit also added an array in papr_scm_priv
structure called "nvdimm_events_map", which got filled based on the
result of H_SCM_PERFORMANCE_STATS hcall.

Currently there is an assumption that the order of events in the
stats buffer, returned by the hypervisor is same. And order also
happens to matches with the events specified in nvdimm driver code.
But this assumption is not documented in Power Architecture
Platform Requirements (PAPR) document. Although the order
of events happens to be same on current generation od system, but
it might not be true in future generation systems. Fix the issue, by
adding a static mapping for nvdimm events to corresponding stat-id,
and removing the dynamic map from papr_scm_priv structure. Also
remove the function papr_scm_pmu_check_events from papr_scm.c file,
as we no longer need to copy stat-ids dynamically.

Fixes: 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support")
Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220804074852.55157-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 88 +++++++----------------
 1 file changed, 27 insertions(+), 61 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 82cae08976bcd..16bac4e0d7a21 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -124,9 +124,6 @@ struct papr_scm_priv {
 
 	/* The bits which needs to be overridden */
 	u64 health_bitmap_inject_mask;
-
-	/* array to have event_code and stat_id mappings */
-	u8 *nvdimm_events_map;
 };
 
 static int papr_scm_pmem_flush(struct nd_region *nd_region,
@@ -350,6 +347,25 @@ static ssize_t drc_pmem_query_stats(struct papr_scm_priv *p,
 #ifdef CONFIG_PERF_EVENTS
 #define to_nvdimm_pmu(_pmu)	container_of(_pmu, struct nvdimm_pmu, pmu)
 
+static const char * const nvdimm_events_map[] = {
+	[1] = "CtlResCt",
+	[2] = "CtlResTm",
+	[3] = "PonSecs ",
+	[4] = "MemLife ",
+	[5] = "CritRscU",
+	[6] = "HostLCnt",
+	[7] = "HostSCnt",
+	[8] = "HostSDur",
+	[9] = "HostLDur",
+	[10] = "MedRCnt ",
+	[11] = "MedWCnt ",
+	[12] = "MedRDur ",
+	[13] = "MedWDur ",
+	[14] = "CchRHCnt",
+	[15] = "CchWHCnt",
+	[16] = "FastWCnt",
+};
+
 static int papr_scm_pmu_get_value(struct perf_event *event, struct device *dev, u64 *count)
 {
 	struct papr_scm_perf_stat *stat;
@@ -357,11 +373,15 @@ static int papr_scm_pmu_get_value(struct perf_event *event, struct device *dev,
 	struct papr_scm_priv *p = (struct papr_scm_priv *)dev->driver_data;
 	int rc, size;
 
+	/* Invalid eventcode */
+	if (event->attr.config == 0 || event->attr.config >= ARRAY_SIZE(nvdimm_events_map))
+		return -EINVAL;
+
 	/* Allocate request buffer enough to hold single performance stat */
 	size = sizeof(struct papr_scm_perf_stats) +
 		sizeof(struct papr_scm_perf_stat);
 
-	if (!p || !p->nvdimm_events_map)
+	if (!p)
 		return -EINVAL;
 
 	stats = kzalloc(size, GFP_KERNEL);
@@ -370,7 +390,7 @@ static int papr_scm_pmu_get_value(struct perf_event *event, struct device *dev,
 
 	stat = &stats->scm_statistic[0];
 	memcpy(&stat->stat_id,
-	       &p->nvdimm_events_map[event->attr.config * sizeof(stat->stat_id)],
+	       nvdimm_events_map[event->attr.config],
 		sizeof(stat->stat_id));
 	stat->stat_val = 0;
 
@@ -458,56 +478,6 @@ static void papr_scm_pmu_del(struct perf_event *event, int flags)
 	papr_scm_pmu_read(event);
 }
 
-static int papr_scm_pmu_check_events(struct papr_scm_priv *p, struct nvdimm_pmu *nd_pmu)
-{
-	struct papr_scm_perf_stat *stat;
-	struct papr_scm_perf_stats *stats;
-	u32 available_events;
-	int index, rc = 0;
-
-	if (!p->stat_buffer_len)
-		return -ENOENT;
-
-	available_events = (p->stat_buffer_len  - sizeof(struct papr_scm_perf_stats))
-			/ sizeof(struct papr_scm_perf_stat);
-	if (available_events == 0)
-		return -EOPNOTSUPP;
-
-	/* Allocate the buffer for phyp where stats are written */
-	stats = kzalloc(p->stat_buffer_len, GFP_KERNEL);
-	if (!stats) {
-		rc = -ENOMEM;
-		return rc;
-	}
-
-	/* Called to get list of events supported */
-	rc = drc_pmem_query_stats(p, stats, 0);
-	if (rc)
-		goto out;
-
-	/*
-	 * Allocate memory and populate nvdimm_event_map.
-	 * Allocate an extra element for NULL entry
-	 */
-	p->nvdimm_events_map = kcalloc(available_events + 1,
-				       sizeof(stat->stat_id),
-				       GFP_KERNEL);
-	if (!p->nvdimm_events_map) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	/* Copy all stat_ids to event map */
-	for (index = 0, stat = stats->scm_statistic;
-	     index < available_events; index++, ++stat) {
-		memcpy(&p->nvdimm_events_map[index * sizeof(stat->stat_id)],
-		       &stat->stat_id, sizeof(stat->stat_id));
-	}
-out:
-	kfree(stats);
-	return rc;
-}
-
 static void papr_scm_pmu_register(struct papr_scm_priv *p)
 {
 	struct nvdimm_pmu *nd_pmu;
@@ -519,8 +489,7 @@ static void papr_scm_pmu_register(struct papr_scm_priv *p)
 		goto pmu_err_print;
 	}
 
-	rc = papr_scm_pmu_check_events(p, nd_pmu);
-	if (rc)
+	if (!p->stat_buffer_len)
 		goto pmu_check_events_err;
 
 	nd_pmu->pmu.task_ctx_nr = perf_invalid_context;
@@ -539,7 +508,7 @@ static void papr_scm_pmu_register(struct papr_scm_priv *p)
 
 	rc = register_nvdimm_pmu(nd_pmu, p->pdev);
 	if (rc)
-		goto pmu_register_err;
+		goto pmu_check_events_err;
 
 	/*
 	 * Set archdata.priv value to nvdimm_pmu structure, to handle the
@@ -548,8 +517,6 @@ static void papr_scm_pmu_register(struct papr_scm_priv *p)
 	p->pdev->archdata.priv = nd_pmu;
 	return;
 
-pmu_register_err:
-	kfree(p->nvdimm_events_map);
 pmu_check_events_err:
 	kfree(nd_pmu);
 pmu_err_print:
@@ -1560,7 +1527,6 @@ static int papr_scm_remove(struct platform_device *pdev)
 		unregister_nvdimm_pmu(pdev->archdata.priv);
 
 	pdev->archdata.priv = NULL;
-	kfree(p->nvdimm_events_map);
 	kfree(p->bus_desc.provider_name);
 	kfree(p);
 
-- 
2.35.1



