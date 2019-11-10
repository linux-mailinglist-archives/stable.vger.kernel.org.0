Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A32DF645D
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 03:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbfKJC7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729379AbfKJC4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DB22245A;
        Sun, 10 Nov 2019 02:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354053;
        bh=pO5pmzQOyp9GLT9o5dmrVktyAYTGz8KB29rC+2x5vqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vw7kENkdDJ7uqXqvoFGcjFrhs1lVAetdLhPAt0GJIFXhQLTZ85NVGnGd2KDhJdwsv
         5G8RuXQoQwG2E06TAbafBrfmdhs8wTUyN6J8aBAkEtOC+5oPnbGkhd3agOKIBMMaLS
         MIyOpYUmaLX2pf5U6nwi/1n215iFWxW7mAAR7JOo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 063/109] coresight: perf: Fix per cpu path management
Date:   Sat,  9 Nov 2019 21:44:55 -0500
Message-Id: <20191110024541.31567-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 5ecabe4a76e8cdb61fa3e24862d9ca240a1c4ddf ]

We create a coresight trace path for each online CPU when
we start the event. We rely on the number of online CPUs
and then go on to allocate an array matching the "number of
online CPUs" for holding the path and then uses normal
CPU id as the index to the array. This is problematic as
we could have some offline CPUs causing us to access beyond
the actual array size (e.g, on a dual SMP system, if CPU0 is
offline, CPU1 could be really accessing beyond the array).
The solution is to switch to per-cpu array for holding the path.

Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hwtracing/coresight/coresight-etm-perf.c  | 55 ++++++++++++++-----
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm-perf.c b/drivers/hwtracing/coresight/coresight-etm-perf.c
index 8a0ad77574e73..99cbf5d5d1c1f 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/perf_event.h>
+#include <linux/percpu-defs.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
@@ -44,7 +45,7 @@ struct etm_event_data {
 	struct work_struct work;
 	cpumask_t mask;
 	void *snk_config;
-	struct list_head **path;
+	struct list_head * __percpu *path;
 };
 
 static DEFINE_PER_CPU(struct perf_output_handle, ctx_handle);
@@ -72,6 +73,18 @@ static const struct attribute_group *etm_pmu_attr_groups[] = {
 	NULL,
 };
 
+static inline struct list_head **
+etm_event_cpu_path_ptr(struct etm_event_data *data, int cpu)
+{
+	return per_cpu_ptr(data->path, cpu);
+}
+
+static inline struct list_head *
+etm_event_cpu_path(struct etm_event_data *data, int cpu)
+{
+	return *etm_event_cpu_path_ptr(data, cpu);
+}
+
 static void etm_event_read(struct perf_event *event) {}
 
 static int etm_addr_filters_alloc(struct perf_event *event)
@@ -131,23 +144,26 @@ static void free_event_data(struct work_struct *work)
 	 */
 	if (event_data->snk_config) {
 		cpu = cpumask_first(mask);
-		sink = coresight_get_sink(event_data->path[cpu]);
+		sink = coresight_get_sink(etm_event_cpu_path(event_data, cpu));
 		if (sink_ops(sink)->free_buffer)
 			sink_ops(sink)->free_buffer(event_data->snk_config);
 	}
 
 	for_each_cpu(cpu, mask) {
-		if (!(IS_ERR_OR_NULL(event_data->path[cpu])))
-			coresight_release_path(event_data->path[cpu]);
+		struct list_head **ppath;
+
+		ppath = etm_event_cpu_path_ptr(event_data, cpu);
+		if (!(IS_ERR_OR_NULL(*ppath)))
+			coresight_release_path(*ppath);
+		*ppath = NULL;
 	}
 
-	kfree(event_data->path);
+	free_percpu(event_data->path);
 	kfree(event_data);
 }
 
 static void *alloc_event_data(int cpu)
 {
-	int size;
 	cpumask_t *mask;
 	struct etm_event_data *event_data;
 
@@ -158,7 +174,6 @@ static void *alloc_event_data(int cpu)
 
 	/* Make sure nothing disappears under us */
 	get_online_cpus();
-	size = num_online_cpus();
 
 	mask = &event_data->mask;
 	if (cpu != -1)
@@ -175,8 +190,8 @@ static void *alloc_event_data(int cpu)
 	 * unused memory when dealing with single CPU trace scenarios is small
 	 * compared to the cost of searching through an optimized array.
 	 */
-	event_data->path = kcalloc(size,
-				   sizeof(struct list_head *), GFP_KERNEL);
+	event_data->path = alloc_percpu(struct list_head *);
+
 	if (!event_data->path) {
 		kfree(event_data);
 		return NULL;
@@ -224,6 +239,7 @@ static void *etm_setup_aux(int event_cpu, void **pages,
 
 	/* Setup the path for each CPU in a trace session */
 	for_each_cpu(cpu, mask) {
+		struct list_head *path;
 		struct coresight_device *csdev;
 
 		csdev = per_cpu(csdev_src, cpu);
@@ -235,9 +251,11 @@ static void *etm_setup_aux(int event_cpu, void **pages,
 		 * list of devices from source to sink that can be
 		 * referenced later when the path is actually needed.
 		 */
-		event_data->path[cpu] = coresight_build_path(csdev, sink);
-		if (IS_ERR(event_data->path[cpu]))
+		path = coresight_build_path(csdev, sink);
+		if (IS_ERR(path))
 			goto err;
+
+		*etm_event_cpu_path_ptr(event_data, cpu) = path;
 	}
 
 	if (!sink_ops(sink)->alloc_buffer)
@@ -266,6 +284,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 	struct etm_event_data *event_data;
 	struct perf_output_handle *handle = this_cpu_ptr(&ctx_handle);
 	struct coresight_device *sink, *csdev = per_cpu(csdev_src, cpu);
+	struct list_head *path;
 
 	if (!csdev)
 		goto fail;
@@ -278,8 +297,9 @@ static void etm_event_start(struct perf_event *event, int flags)
 	if (!event_data)
 		goto fail;
 
+	path = etm_event_cpu_path(event_data, cpu);
 	/* We need a sink, no need to continue without one */
-	sink = coresight_get_sink(event_data->path[cpu]);
+	sink = coresight_get_sink(path);
 	if (WARN_ON_ONCE(!sink || !sink_ops(sink)->set_buffer))
 		goto fail_end_stop;
 
@@ -289,7 +309,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 		goto fail_end_stop;
 
 	/* Nothing will happen without a path */
-	if (coresight_enable_path(event_data->path[cpu], CS_MODE_PERF))
+	if (coresight_enable_path(path, CS_MODE_PERF))
 		goto fail_end_stop;
 
 	/* Tell the perf core the event is alive */
@@ -317,6 +337,7 @@ static void etm_event_stop(struct perf_event *event, int mode)
 	struct coresight_device *sink, *csdev = per_cpu(csdev_src, cpu);
 	struct perf_output_handle *handle = this_cpu_ptr(&ctx_handle);
 	struct etm_event_data *event_data = perf_get_aux(handle);
+	struct list_head *path;
 
 	if (event->hw.state == PERF_HES_STOPPED)
 		return;
@@ -324,7 +345,11 @@ static void etm_event_stop(struct perf_event *event, int mode)
 	if (!csdev)
 		return;
 
-	sink = coresight_get_sink(event_data->path[cpu]);
+	path = etm_event_cpu_path(event_data, cpu);
+	if (!path)
+		return;
+
+	sink = coresight_get_sink(path);
 	if (!sink)
 		return;
 
@@ -355,7 +380,7 @@ static void etm_event_stop(struct perf_event *event, int mode)
 	}
 
 	/* Disabling the path make its elements available to other sessions */
-	coresight_disable_path(event_data->path[cpu]);
+	coresight_disable_path(path);
 }
 
 static int etm_event_add(struct perf_event *event, int mode)
-- 
2.20.1

