Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98B6D119475
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbfLJVPy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:15:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729318AbfLJVN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:13:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50EA62464B;
        Tue, 10 Dec 2019 21:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012407;
        bh=OrsNlArhUDbQLwujqWNdMGO0JZWksw/TTZw6A13GCz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=otvMs7YQcX/KWYcSgtHnMt9d0RFGGGYX8/K68D3eJkQRg6T0GEiK/TMFhQrryAoz+
         IupzKOItLadOk1abA899gf3uirKN6rJq/Y3Tt0s+E+XKG78gLFdAqN2JsC26zCPmB1
         gmxi6Jjd4JhoFH3w3cYm+E48RiaGlgRIUTIN6/mM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 325/350] s390/cpumf: Adjust registration of s390 PMU device drivers
Date:   Tue, 10 Dec 2019 16:07:10 -0500
Message-Id: <20191210210735.9077-286-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 6a82e23f45fe0aa821e7a935e39d0acb20c275c0 ]

Linux-next commit titled "perf/core: Optimize perf_init_event()"
changed the semantics of PMU device driver registration.
It was done to speed up the lookup/handling of PMU device driver
specific events. It also enforces that only one PMU device
driver will be registered of type PERF_EVENT_RAW.

This change added these line in function perf_pmu_register():

  ...
  +       ret = idr_alloc(&pmu_idr, pmu, max, 0, GFP_KERNEL);
  +       if (ret < 0)
                goto free_pdc;
  +
  +       WARN_ON(type >= 0 && ret != type);

The warn_on generates a message. We have 3 PMU device drivers,
each registered as type PERF_TYPE_RAW.
The cf_diag device driver (arch/s390/kernel/perf_cpumf_cf_diag.c)
always hits the WARN_ON because it is the second PMU device driver
(after sampling device driver arch/s390/kernel/perf_cpumf_sf.c)
which is registered as type 4 (PERF_TYPE_RAW).
So when the sampling device driver is registered, ret has value 4.
When cf_diag device driver is registered with type 4,
ret has value of 5 and WARN_ON fires.

Adjust the PMU device drivers for s390 to support the new
semantics required by perf_pmu_register().

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_cf.c      | 21 ++++++++++-----------
 arch/s390/kernel/perf_cpum_cf_diag.c | 10 +++++-----
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 48d48b6187c0d..0eb1d1cc53a88 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -199,7 +199,7 @@ static const int cpumf_generic_events_user[] = {
 	[PERF_COUNT_HW_BUS_CYCLES]	    = -1,
 };
 
-static int __hw_perf_event_init(struct perf_event *event)
+static int __hw_perf_event_init(struct perf_event *event, unsigned int type)
 {
 	struct perf_event_attr *attr = &event->attr;
 	struct hw_perf_event *hwc = &event->hw;
@@ -207,7 +207,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	int err = 0;
 	u64 ev;
 
-	switch (attr->type) {
+	switch (type) {
 	case PERF_TYPE_RAW:
 		/* Raw events are used to access counters directly,
 		 * hence do not permit excludes */
@@ -294,17 +294,16 @@ static int __hw_perf_event_init(struct perf_event *event)
 
 static int cpumf_pmu_event_init(struct perf_event *event)
 {
+	unsigned int type = event->attr.type;
 	int err;
 
-	switch (event->attr.type) {
-	case PERF_TYPE_HARDWARE:
-	case PERF_TYPE_HW_CACHE:
-	case PERF_TYPE_RAW:
-		err = __hw_perf_event_init(event);
-		break;
-	default:
+	if (type == PERF_TYPE_HARDWARE || type == PERF_TYPE_RAW)
+		err = __hw_perf_event_init(event, type);
+	else if (event->pmu->type == type)
+		/* Registered as unknown PMU */
+		err = __hw_perf_event_init(event, PERF_TYPE_RAW);
+	else
 		return -ENOENT;
-	}
 
 	if (unlikely(err) && event->destroy)
 		event->destroy(event);
@@ -553,7 +552,7 @@ static int __init cpumf_pmu_init(void)
 		return -ENODEV;
 
 	cpumf_pmu.attr_groups = cpumf_cf_event_group();
-	rc = perf_pmu_register(&cpumf_pmu, "cpum_cf", PERF_TYPE_RAW);
+	rc = perf_pmu_register(&cpumf_pmu, "cpum_cf", -1);
 	if (rc)
 		pr_err("Registering the cpum_cf PMU failed with rc=%i\n", rc);
 	return rc;
diff --git a/arch/s390/kernel/perf_cpum_cf_diag.c b/arch/s390/kernel/perf_cpum_cf_diag.c
index 2654e348801a1..e949ab832ed75 100644
--- a/arch/s390/kernel/perf_cpum_cf_diag.c
+++ b/arch/s390/kernel/perf_cpum_cf_diag.c
@@ -243,13 +243,13 @@ static int cf_diag_event_init(struct perf_event *event)
 	int err = -ENOENT;
 
 	debug_sprintf_event(cf_diag_dbg, 5,
-			    "%s event %p cpu %d config %#llx "
+			    "%s event %p cpu %d config %#llx type:%u "
 			    "sample_type %#llx cf_diag_events %d\n", __func__,
-			    event, event->cpu, attr->config, attr->sample_type,
-			    atomic_read(&cf_diag_events));
+			    event, event->cpu, attr->config, event->pmu->type,
+			    attr->sample_type, atomic_read(&cf_diag_events));
 
 	if (event->attr.config != PERF_EVENT_CPUM_CF_DIAG ||
-	    event->attr.type != PERF_TYPE_RAW)
+	    event->attr.type != event->pmu->type)
 		goto out;
 
 	/* Raw events are used to access counters directly,
@@ -693,7 +693,7 @@ static int __init cf_diag_init(void)
 	}
 	debug_register_view(cf_diag_dbg, &debug_sprintf_view);
 
-	rc = perf_pmu_register(&cf_diag, "cpum_cf_diag", PERF_TYPE_RAW);
+	rc = perf_pmu_register(&cf_diag, "cpum_cf_diag", -1);
 	if (rc) {
 		debug_unregister_view(cf_diag_dbg, &debug_sprintf_view);
 		debug_unregister(cf_diag_dbg);
-- 
2.20.1

