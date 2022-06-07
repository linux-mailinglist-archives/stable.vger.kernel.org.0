Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA2D541CBC
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378918AbiFGWES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382420AbiFGWDS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:03:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B53251490;
        Tue,  7 Jun 2022 12:15:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0FC26192F;
        Tue,  7 Jun 2022 19:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFF0C385A5;
        Tue,  7 Jun 2022 19:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629310;
        bh=sCJm4CNUlpdZlq5/wMf959urXU8A7uAOb5KzcBc5zkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nywHgOj+4dFNOV2S0ovv+5wbUJRAy1veWKhAQucolCRAom5qo6jh5pzQSirdV/g6R
         sv7rb95SqJ7a8640hjAytXy//A18iaRXZTWlC4ctAN7l9bKjDtRmZhTYeioFnVjy6x
         J8SOKnoz3Lfzs5YthgQAPMQWRB+r/edD84T0GCF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vaibhav Jain <vaibhav@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 646/879] powerpc/papr_scm: Fix leaking nvdimm_events_map elements
Date:   Tue,  7 Jun 2022 19:02:44 +0200
Message-Id: <20220607165021.598341332@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vaibhav Jain <vaibhav@linux.ibm.com>

[ Upstream commit 0e0946e22f3665d27325d389ff45ade6e93f3678 ]

Right now 'char *' elements allocated for individual 'stat_id' in
'papr_scm_priv.nvdimm_events_map[]' during papr_scm_pmu_check_events(), get
leaked in papr_scm_remove() and papr_scm_pmu_register(),
papr_scm_pmu_check_events() error paths.

Also individual 'stat_id' arent NULL terminated 'char *' instead they are fixed
8-byte sized identifiers. However papr_scm_pmu_register() assumes it to be a
NULL terminated 'char *' and at other places it assumes it to be a
'papr_scm_perf_stat.stat_id' sized string which is 8-byes in size.

Fix this by allocating the memory for papr_scm_priv.nvdimm_events_map to also
include space for 'stat_id' entries. This is possible since number of available
events/stat_ids are known upfront. This saves some memory and one extra level of
indirection from 'nvdimm_events_map' to 'stat_id'. Also rest of the code
can continue to call 'kfree(papr_scm_priv.nvdimm_events_map)' without needing to
iterate over the array and free up individual elements.

Fixes: 4c08d4bbc089 ("powerpc/papr_scm: Add perf interface support")
Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220511082637.646714-1-vaibhav@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/papr_scm.c | 54 ++++++++++-------------
 1 file changed, 24 insertions(+), 30 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/papr_scm.c b/arch/powerpc/platforms/pseries/papr_scm.c
index 39962c905542..181b855b3050 100644
--- a/arch/powerpc/platforms/pseries/papr_scm.c
+++ b/arch/powerpc/platforms/pseries/papr_scm.c
@@ -125,8 +125,8 @@ struct papr_scm_priv {
 	/* The bits which needs to be overridden */
 	u64 health_bitmap_inject_mask;
 
-	 /* array to have event_code and stat_id mappings */
-	char **nvdimm_events_map;
+	/* array to have event_code and stat_id mappings */
+	u8 *nvdimm_events_map;
 };
 
 static int papr_scm_pmem_flush(struct nd_region *nd_region,
@@ -370,7 +370,7 @@ static int papr_scm_pmu_get_value(struct perf_event *event, struct device *dev,
 
 	stat = &stats->scm_statistic[0];
 	memcpy(&stat->stat_id,
-	       p->nvdimm_events_map[event->attr.config],
+	       &p->nvdimm_events_map[event->attr.config * sizeof(stat->stat_id)],
 		sizeof(stat->stat_id));
 	stat->stat_val = 0;
 
@@ -462,14 +462,13 @@ static int papr_scm_pmu_check_events(struct papr_scm_priv *p, struct nvdimm_pmu
 {
 	struct papr_scm_perf_stat *stat;
 	struct papr_scm_perf_stats *stats;
-	int index, rc, count;
 	u32 available_events;
-
-	if (!p->stat_buffer_len)
-		return -ENOENT;
+	int index, rc = 0;
 
 	available_events = (p->stat_buffer_len  - sizeof(struct papr_scm_perf_stats))
 			/ sizeof(struct papr_scm_perf_stat);
+	if (available_events == 0)
+		return -EOPNOTSUPP;
 
 	/* Allocate the buffer for phyp where stats are written */
 	stats = kzalloc(p->stat_buffer_len, GFP_KERNEL);
@@ -478,35 +477,30 @@ static int papr_scm_pmu_check_events(struct papr_scm_priv *p, struct nvdimm_pmu
 		return rc;
 	}
 
-	/* Allocate memory to nvdimm_event_map */
-	p->nvdimm_events_map = kcalloc(available_events, sizeof(char *), GFP_KERNEL);
-	if (!p->nvdimm_events_map) {
-		rc = -ENOMEM;
-		goto out_stats;
-	}
-
 	/* Called to get list of events supported */
 	rc = drc_pmem_query_stats(p, stats, 0);
 	if (rc)
-		goto out_nvdimm_events_map;
-
-	for (index = 0, stat = stats->scm_statistic, count = 0;
-		     index < available_events; index++, ++stat) {
-		p->nvdimm_events_map[count] = kmemdup_nul(stat->stat_id, 8, GFP_KERNEL);
-		if (!p->nvdimm_events_map[count]) {
-			rc = -ENOMEM;
-			goto out_nvdimm_events_map;
-		}
+		goto out;
 
-		count++;
+	/*
+	 * Allocate memory and populate nvdimm_event_map.
+	 * Allocate an extra element for NULL entry
+	 */
+	p->nvdimm_events_map = kcalloc(available_events + 1,
+				       sizeof(stat->stat_id),
+				       GFP_KERNEL);
+	if (!p->nvdimm_events_map) {
+		rc = -ENOMEM;
+		goto out;
 	}
-	p->nvdimm_events_map[count] = NULL;
-	kfree(stats);
-	return 0;
 
-out_nvdimm_events_map:
-	kfree(p->nvdimm_events_map);
-out_stats:
+	/* Copy all stat_ids to event map */
+	for (index = 0, stat = stats->scm_statistic;
+	     index < available_events; index++, ++stat) {
+		memcpy(&p->nvdimm_events_map[index * sizeof(stat->stat_id)],
+		       &stat->stat_id, sizeof(stat->stat_id));
+	}
+out:
 	kfree(stats);
 	return rc;
 }
-- 
2.35.1



