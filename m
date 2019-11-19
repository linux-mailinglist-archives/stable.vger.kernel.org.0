Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA651017C1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbfKSFjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:39:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729934AbfKSFjn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:39:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7292F218BA;
        Tue, 19 Nov 2019 05:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141983;
        bh=isimNGV8EFFjgRGHPfCqxbiGejExCGEYIzUjW3Qx7LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nN2W9AfG2QtYKndHW5+LUO8dWln75PAoY7fH6lX28ylcAZPeS2KAm6UP9ZTJhZ/7y
         rkkWkaO5lfFspatJV/Jjfeh3uuJyLkFgSnd8D6KTglWQn/6X/NKkBRLcZ7rHI/eNxH
         mBmfFSFGiMcO6n+JkS2DFdYkukHl9vq7cS+H1WaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 346/422] coresight: perf: Fix per cpu path management
Date:   Tue, 19 Nov 2019 06:19:03 +0100
Message-Id: <20191119051421.434014178@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0f5e03e4df22c..4b53d55788a07 100644
--- a/drivers/hwtracing/coresight/coresight-etm-perf.c
+++ b/drivers/hwtracing/coresight/coresight-etm-perf.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/perf_event.h>
+#include <linux/percpu-defs.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
@@ -33,7 +34,7 @@ struct etm_event_data {
 	struct work_struct work;
 	cpumask_t mask;
 	void *snk_config;
-	struct list_head **path;
+	struct list_head * __percpu *path;
 };
 
 static DEFINE_PER_CPU(struct perf_output_handle, ctx_handle);
@@ -61,6 +62,18 @@ static const struct attribute_group *etm_pmu_attr_groups[] = {
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
@@ -120,23 +133,26 @@ static void free_event_data(struct work_struct *work)
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
 
@@ -147,7 +163,6 @@ static void *alloc_event_data(int cpu)
 
 	/* Make sure nothing disappears under us */
 	get_online_cpus();
-	size = num_online_cpus();
 
 	mask = &event_data->mask;
 	if (cpu != -1)
@@ -164,8 +179,8 @@ static void *alloc_event_data(int cpu)
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
@@ -213,6 +228,7 @@ static void *etm_setup_aux(struct perf_event *event, void **pages,
 
 	/* Setup the path for each CPU in a trace session */
 	for_each_cpu(cpu, mask) {
+		struct list_head *path;
 		struct coresight_device *csdev;
 
 		csdev = per_cpu(csdev_src, cpu);
@@ -224,9 +240,11 @@ static void *etm_setup_aux(struct perf_event *event, void **pages,
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
@@ -255,6 +273,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 	struct etm_event_data *event_data;
 	struct perf_output_handle *handle = this_cpu_ptr(&ctx_handle);
 	struct coresight_device *sink, *csdev = per_cpu(csdev_src, cpu);
+	struct list_head *path;
 
 	if (!csdev)
 		goto fail;
@@ -267,8 +286,9 @@ static void etm_event_start(struct perf_event *event, int flags)
 	if (!event_data)
 		goto fail;
 
+	path = etm_event_cpu_path(event_data, cpu);
 	/* We need a sink, no need to continue without one */
-	sink = coresight_get_sink(event_data->path[cpu]);
+	sink = coresight_get_sink(path);
 	if (WARN_ON_ONCE(!sink || !sink_ops(sink)->set_buffer))
 		goto fail_end_stop;
 
@@ -278,7 +298,7 @@ static void etm_event_start(struct perf_event *event, int flags)
 		goto fail_end_stop;
 
 	/* Nothing will happen without a path */
-	if (coresight_enable_path(event_data->path[cpu], CS_MODE_PERF))
+	if (coresight_enable_path(path, CS_MODE_PERF))
 		goto fail_end_stop;
 
 	/* Tell the perf core the event is alive */
@@ -306,6 +326,7 @@ static void etm_event_stop(struct perf_event *event, int mode)
 	struct coresight_device *sink, *csdev = per_cpu(csdev_src, cpu);
 	struct perf_output_handle *handle = this_cpu_ptr(&ctx_handle);
 	struct etm_event_data *event_data = perf_get_aux(handle);
+	struct list_head *path;
 
 	if (event->hw.state == PERF_HES_STOPPED)
 		return;
@@ -313,7 +334,11 @@ static void etm_event_stop(struct perf_event *event, int mode)
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
 
@@ -344,7 +369,7 @@ static void etm_event_stop(struct perf_event *event, int mode)
 	}
 
 	/* Disabling the path make its elements available to other sessions */
-	coresight_disable_path(event_data->path[cpu]);
+	coresight_disable_path(path);
 }
 
 static int etm_event_add(struct perf_event *event, int mode)
-- 
2.20.1



