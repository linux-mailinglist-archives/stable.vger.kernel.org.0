Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F065657D8D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbiL1PoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbiL1PoW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:44:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917811742F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:44:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B45FB81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:44:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6797C433D2;
        Wed, 28 Dec 2022 15:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242259;
        bh=D5zVVx3KG0r+F5Wi0JmnZKTpYH9XYb/AvqJZ2MnaMTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VeL/OuYVqdscIM8kuvFn98LD96soEuGm691YLvUfAIGWfFWfI8mvvjnk02KfR2C2q
         sOJ1+6blmdyta1WX1DEWZJ3K5lX/RTpVJQTyFxa9h1FA7gXFeuGoB6XnbSAO8EZafJ
         y35tYtY7YrtjzP54Pu4Qn+GvO8dQvKuLpbxiL4t4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kajol Jain <kjain@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 560/731] powerpc/hv-gpci: Fix hv_gpci event list
Date:   Wed, 28 Dec 2022 15:41:07 +0100
Message-Id: <20221228144312.798677074@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 03f7c1d2a49acd30e38789cd809d3300721e9b0e ]

Based on getPerfCountInfo v1.018 documentation, some of the
hv_gpci events were deprecated for platform firmware that
supports counter_info_version 0x8 or above.

Fix the hv_gpci event list by adding a new attribute group
called "hv_gpci_event_attrs_v6" and a "ENABLE_EVENTS_COUNTERINFO_V6"
macro to enable these events for platform firmware
that supports counter_info_version 0x6 or below. And assigning
the hv_gpci event list based on output counter info version
of underlying plaform.

Fixes: 97bf2640184f ("powerpc/perf/hv-gpci: add the remaining gpci requests")
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Reviewed-by: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221130174513.87501-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/hv-gpci-requests.h |  4 ++++
 arch/powerpc/perf/hv-gpci.c          | 33 +++++++++++++++++++++++++++-
 arch/powerpc/perf/hv-gpci.h          |  1 +
 arch/powerpc/perf/req-gen/perf.h     | 20 +++++++++++++++++
 4 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/hv-gpci-requests.h b/arch/powerpc/perf/hv-gpci-requests.h
index 8965b4463d43..5e86371a20c7 100644
--- a/arch/powerpc/perf/hv-gpci-requests.h
+++ b/arch/powerpc/perf/hv-gpci-requests.h
@@ -79,6 +79,7 @@ REQUEST(__field(0,	8,	partition_id)
 )
 #include I(REQUEST_END)
 
+#ifdef ENABLE_EVENTS_COUNTERINFO_V6
 /*
  * Not available for counter_info_version >= 0x8, use
  * run_instruction_cycles_by_partition(0x100) instead.
@@ -92,6 +93,7 @@ REQUEST(__field(0,	8,	partition_id)
 	__count(0x10,	8,	cycles)
 )
 #include I(REQUEST_END)
+#endif
 
 #define REQUEST_NAME system_performance_capabilities
 #define REQUEST_NUM 0x40
@@ -103,6 +105,7 @@ REQUEST(__field(0,	1,	perf_collect_privileged)
 )
 #include I(REQUEST_END)
 
+#ifdef ENABLE_EVENTS_COUNTERINFO_V6
 #define REQUEST_NAME processor_bus_utilization_abc_links
 #define REQUEST_NUM 0x50
 #define REQUEST_IDX_KIND "hw_chip_id=?"
@@ -194,6 +197,7 @@ REQUEST(__field(0,	4,	phys_processor_idx)
 	__count(0x28,	8,	instructions_completed)
 )
 #include I(REQUEST_END)
+#endif
 
 /* Processor_core_power_mode (0x95) skipped, no counters */
 /* Affinity_domain_information_by_virtual_processor (0xA0) skipped,
diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
index c756228a081f..28b770bbc10b 100644
--- a/arch/powerpc/perf/hv-gpci.c
+++ b/arch/powerpc/perf/hv-gpci.c
@@ -72,7 +72,7 @@ static struct attribute_group format_group = {
 
 static struct attribute_group event_group = {
 	.name  = "events",
-	.attrs = hv_gpci_event_attrs,
+	/* .attrs is set in init */
 };
 
 #define HV_CAPS_ATTR(_name, _format)				\
@@ -330,6 +330,7 @@ static int hv_gpci_init(void)
 	int r;
 	unsigned long hret;
 	struct hv_perf_caps caps;
+	struct hv_gpci_request_buffer *arg;
 
 	hv_gpci_assert_offsets_correct();
 
@@ -353,6 +354,36 @@ static int hv_gpci_init(void)
 	/* sampling not supported */
 	h_gpci_pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
 
+	arg = (void *)get_cpu_var(hv_gpci_reqb);
+	memset(arg, 0, HGPCI_REQ_BUFFER_SIZE);
+
+	/*
+	 * hcall H_GET_PERF_COUNTER_INFO populates the output
+	 * counter_info_version value based on the system hypervisor.
+	 * Pass the counter request 0x10 corresponds to request type
+	 * 'Dispatch_timebase_by_processor', to get the supported
+	 * counter_info_version.
+	 */
+	arg->params.counter_request = cpu_to_be32(0x10);
+
+	r = plpar_hcall_norets(H_GET_PERF_COUNTER_INFO,
+			virt_to_phys(arg), HGPCI_REQ_BUFFER_SIZE);
+	if (r) {
+		pr_devel("hcall failed, can't get supported counter_info_version: 0x%x\n", r);
+		arg->params.counter_info_version_out = 0x8;
+	}
+
+	/*
+	 * Use counter_info_version_out value to assign
+	 * required hv-gpci event list.
+	 */
+	if (arg->params.counter_info_version_out >= 0x8)
+		event_group.attrs = hv_gpci_event_attrs;
+	else
+		event_group.attrs = hv_gpci_event_attrs_v6;
+
+	put_cpu_var(hv_gpci_reqb);
+
 	r = perf_pmu_register(&h_gpci_pmu, h_gpci_pmu.name, -1);
 	if (r)
 		return r;
diff --git a/arch/powerpc/perf/hv-gpci.h b/arch/powerpc/perf/hv-gpci.h
index 4d108262bed7..c72020912dea 100644
--- a/arch/powerpc/perf/hv-gpci.h
+++ b/arch/powerpc/perf/hv-gpci.h
@@ -26,6 +26,7 @@ enum {
 #define REQUEST_FILE "../hv-gpci-requests.h"
 #define NAME_LOWER hv_gpci
 #define NAME_UPPER HV_GPCI
+#define ENABLE_EVENTS_COUNTERINFO_V6
 #include "req-gen/perf.h"
 #undef REQUEST_FILE
 #undef NAME_LOWER
diff --git a/arch/powerpc/perf/req-gen/perf.h b/arch/powerpc/perf/req-gen/perf.h
index fa9bc804e67a..6b2a59fefffa 100644
--- a/arch/powerpc/perf/req-gen/perf.h
+++ b/arch/powerpc/perf/req-gen/perf.h
@@ -139,6 +139,26 @@ PMU_EVENT_ATTR_STRING(							\
 #define REQUEST_(r_name, r_value, r_idx_1, r_fields)			\
 	r_fields
 
+/* Generate event list for platforms with counter_info_version 0x6 or below */
+static __maybe_unused struct attribute *hv_gpci_event_attrs_v6[] = {
+#include REQUEST_FILE
+	NULL
+};
+
+/*
+ * Based on getPerfCountInfo v1.018 documentation, some of the hv-gpci
+ * events were deprecated for platform firmware that supports
+ * counter_info_version 0x8 or above.
+ * Those deprecated events are still part of platform firmware that
+ * support counter_info_version 0x6 and below. As per the getPerfCountInfo
+ * v1.018 documentation there is no counter_info_version 0x7.
+ * Undefining macro ENABLE_EVENTS_COUNTERINFO_V6, to disable the addition of
+ * deprecated events in "hv_gpci_event_attrs" attribute group, for platforms
+ * that supports counter_info_version 0x8 or above.
+ */
+#undef ENABLE_EVENTS_COUNTERINFO_V6
+
+/* Generate event list for platforms with counter_info_version 0x8 or above*/
 static __maybe_unused struct attribute *hv_gpci_event_attrs[] = {
 #include REQUEST_FILE
 	NULL
-- 
2.35.1



