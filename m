Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C5D496883
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 01:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbiAVANq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jan 2022 19:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiAVANp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jan 2022 19:13:45 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6ADC06173D
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 16:13:45 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w12-20020a17090a528c00b001b276aa3aabso14999667pjh.0
        for <stable@vger.kernel.org>; Fri, 21 Jan 2022 16:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IXTMdXv8lFf4FOkEhwBgmSX3gJaS9QGnq6wiUqWC7ik=;
        b=Z7KcFb4RDbFQGTVywLff8/IPX3ONqQ1krFZY1nAiPEDGWDIXs+6KjifdFMtoYTAFra
         U3PkbqscOPnNbSyM7FTojLUgQcje6KBs6lpLGy9lraSPj904CZq+w/vWvPxswjs9PJzu
         6Ln6RwwIrB22FoOeb2VxWMEAfWTFsr25iUVI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IXTMdXv8lFf4FOkEhwBgmSX3gJaS9QGnq6wiUqWC7ik=;
        b=dPBiX7nApjTOYQ8wDYZZConwd/d9TMPXFLX3MLtZtkSFF+DVVV0U3waoqYiXe43yh/
         kOeXGnK0y9csDDUMNHJcOeuR+R6QbyDy6agZCaRHE12W1GAcIjvodRj520KBoNJgdB1K
         kC2NYIVZMWEgItdBugun2Vg3dhUEtTrXMnmbB+9iDgwk1HguZ+SpFTyVFiIRqkGsKfaw
         3sUv+z9nHvH1vrxiJ9cv1pheyonvljuKeYjM4T7A2UrneBh9oFi9+an1YoPa4FNlkEjD
         Vws9rPfrfImCokknzkqlthsKlXG/rGzksB/0J93erqwOEwBLHQ3BdXt13/gmss5nCYro
         3j+g==
X-Gm-Message-State: AOAM530my64lvsZ4pDfI0tWj2E+JhJ77hZ8YzLkR3KilVMKT0545TMMU
        AbzcrCOsu9wKQ76gitLyMRKZBXfel2o2jQ==
X-Google-Smtp-Source: ABdhPJzRJQXVuUCrD7VANcU+1dl4A3fS0FL9JRD2nbR2AVNLlTErZ6ZOhwaR+qeugLKnYMGFZAr4zQ==
X-Received: by 2002:a17:90a:4a82:: with SMTP id f2mr2945291pjh.127.1642810424955;
        Fri, 21 Jan 2022 16:13:44 -0800 (PST)
Received: from localhost ([2620:15c:202:201:7f3c:22b1:29ba:4ce6])
        by smtp.gmail.com with UTF8SMTPSA id c13sm8396103pfv.58.2022.01.21.16.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 16:13:44 -0800 (PST)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     bleung@chromium.org, groeck@chromium.org
Cc:     linux-kernel@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>, stable@vger.kernel.org
Subject: [PATCH v2] platform: chrome: Split trace include file
Date:   Fri, 21 Jan 2022 16:13:01 -0800
Message-Id: <20220122001301.640337-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

cros_ec_trace.h defined 5 tracing events, 2 for cros_ec_proto and
3 for cros_ec_sensorhub_ring.
These 2 files are in different kernel modules, the traces are defined
twice in the kernel which leads to problem enabling only some traces.

Move sensorhub traces from cros_ec_trace.h to cros_ec_sensorhub_trace.h
and enable them only in cros_ec_sensorhub kernel module.

Check we can now enable any single traces: without this patch,
we can only enable all sensorhub traces or none.

Fixes: d453ceb65 ("platform/chrome: sensorhub: Add trace events for sample")

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Cc: stable@vger.kernel.org
---
Changes since v1: CC to stable, define the bug scope.

 drivers/platform/chrome/Makefile              |   3 +-
 .../platform/chrome/cros_ec_sensorhub_ring.c  |   3 +-
 .../platform/chrome/cros_ec_sensorhub_trace.h | 123 ++++++++++++++++++
 drivers/platform/chrome/cros_ec_trace.h       |  95 --------------
 4 files changed, 127 insertions(+), 97 deletions(-)
 create mode 100644 drivers/platform/chrome/cros_ec_sensorhub_trace.h

diff --git a/drivers/platform/chrome/Makefile b/drivers/platform/chrome/Makefile
index f901d2e43166c3..88cbc434c06b22 100644
--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -2,6 +2,7 @@
 
 # tell define_trace.h where to find the cros ec trace header
 CFLAGS_cros_ec_trace.o:=		-I$(src)
+CFLAGS_cros_ec_sensorhub_ring.o:=	-I$(src)
 
 obj-$(CONFIG_CHROMEOS_LAPTOP)		+= chromeos_laptop.o
 obj-$(CONFIG_CHROMEOS_PSTORE)		+= chromeos_pstore.o
@@ -20,7 +21,7 @@ obj-$(CONFIG_CROS_EC_CHARDEV)		+= cros_ec_chardev.o
 obj-$(CONFIG_CROS_EC_LIGHTBAR)		+= cros_ec_lightbar.o
 obj-$(CONFIG_CROS_EC_VBC)		+= cros_ec_vbc.o
 obj-$(CONFIG_CROS_EC_DEBUGFS)		+= cros_ec_debugfs.o
-cros-ec-sensorhub-objs			:= cros_ec_sensorhub.o cros_ec_sensorhub_ring.o cros_ec_trace.o
+cros-ec-sensorhub-objs			:= cros_ec_sensorhub.o cros_ec_sensorhub_ring.o
 obj-$(CONFIG_CROS_EC_SENSORHUB)		+= cros-ec-sensorhub.o
 obj-$(CONFIG_CROS_EC_SYSFS)		+= cros_ec_sysfs.o
 obj-$(CONFIG_CROS_USBPD_LOGGER)		+= cros_usbpd_logger.o
diff --git a/drivers/platform/chrome/cros_ec_sensorhub_ring.c b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
index 98e37080f76091..71948dade0e2ae 100644
--- a/drivers/platform/chrome/cros_ec_sensorhub_ring.c
+++ b/drivers/platform/chrome/cros_ec_sensorhub_ring.c
@@ -17,7 +17,8 @@
 #include <linux/sort.h>
 #include <linux/slab.h>
 
-#include "cros_ec_trace.h"
+#define CREATE_TRACE_POINTS
+#include "cros_ec_sensorhub_trace.h"
 
 /* Precision of fixed point for the m values from the filter */
 #define M_PRECISION BIT(23)
diff --git a/drivers/platform/chrome/cros_ec_sensorhub_trace.h b/drivers/platform/chrome/cros_ec_sensorhub_trace.h
new file mode 100644
index 00000000000000..57d9b478596927
--- /dev/null
+++ b/drivers/platform/chrome/cros_ec_sensorhub_trace.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Trace events for the ChromeOS Sensorhub kernel module
+ *
+ * Copyright 2021 Google LLC.
+ */
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM cros_ec
+
+#if !defined(_CROS_EC_SENSORHUB_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define _CROS_EC_SENSORHUB_TRACE_H_
+
+#include <linux/types.h>
+#include <linux/platform_data/cros_ec_sensorhub.h>
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(cros_ec_sensorhub_timestamp,
+	    TP_PROTO(u32 ec_sample_timestamp, u32 ec_fifo_timestamp, s64 fifo_timestamp,
+		     s64 current_timestamp, s64 current_time),
+	TP_ARGS(ec_sample_timestamp, ec_fifo_timestamp, fifo_timestamp, current_timestamp,
+		current_time),
+	TP_STRUCT__entry(
+		__field(u32, ec_sample_timestamp)
+		__field(u32, ec_fifo_timestamp)
+		__field(s64, fifo_timestamp)
+		__field(s64, current_timestamp)
+		__field(s64, current_time)
+		__field(s64, delta)
+	),
+	TP_fast_assign(
+		__entry->ec_sample_timestamp = ec_sample_timestamp;
+		__entry->ec_fifo_timestamp = ec_fifo_timestamp;
+		__entry->fifo_timestamp = fifo_timestamp;
+		__entry->current_timestamp = current_timestamp;
+		__entry->current_time = current_time;
+		__entry->delta = current_timestamp - current_time;
+	),
+	TP_printk("ec_ts: %9u, ec_fifo_ts: %9u, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
+		  __entry->ec_sample_timestamp,
+		__entry->ec_fifo_timestamp,
+		__entry->fifo_timestamp,
+		__entry->current_timestamp,
+		__entry->current_time,
+		__entry->delta
+	)
+);
+
+TRACE_EVENT(cros_ec_sensorhub_data,
+	    TP_PROTO(u32 ec_sensor_num, u32 ec_fifo_timestamp, s64 fifo_timestamp,
+		     s64 current_timestamp, s64 current_time),
+	TP_ARGS(ec_sensor_num, ec_fifo_timestamp, fifo_timestamp, current_timestamp, current_time),
+	TP_STRUCT__entry(
+		__field(u32, ec_sensor_num)
+		__field(u32, ec_fifo_timestamp)
+		__field(s64, fifo_timestamp)
+		__field(s64, current_timestamp)
+		__field(s64, current_time)
+		__field(s64, delta)
+	),
+	TP_fast_assign(
+		__entry->ec_sensor_num = ec_sensor_num;
+		__entry->ec_fifo_timestamp = ec_fifo_timestamp;
+		__entry->fifo_timestamp = fifo_timestamp;
+		__entry->current_timestamp = current_timestamp;
+		__entry->current_time = current_time;
+		__entry->delta = current_timestamp - current_time;
+	),
+	TP_printk("ec_num: %4u, ec_fifo_ts: %9u, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
+		  __entry->ec_sensor_num,
+		__entry->ec_fifo_timestamp,
+		__entry->fifo_timestamp,
+		__entry->current_timestamp,
+		__entry->current_time,
+		__entry->delta
+	)
+);
+
+TRACE_EVENT(cros_ec_sensorhub_filter,
+	    TP_PROTO(struct cros_ec_sensors_ts_filter_state *state, s64 dx, s64 dy),
+	TP_ARGS(state, dx, dy),
+	TP_STRUCT__entry(
+		__field(s64, dx)
+		__field(s64, dy)
+		__field(s64, median_m)
+		__field(s64, median_error)
+		__field(s64, history_len)
+		__field(s64, x)
+		__field(s64, y)
+	),
+	TP_fast_assign(
+		__entry->dx = dx;
+		__entry->dy = dy;
+		__entry->median_m = state->median_m;
+		__entry->median_error = state->median_error;
+		__entry->history_len = state->history_len;
+		__entry->x = state->x_offset;
+		__entry->y = state->y_offset;
+	),
+	TP_printk("dx: %12lld. dy: %12lld median_m: %12lld median_error: %12lld len: %lld x: %12lld y: %12lld",
+		  __entry->dx,
+		__entry->dy,
+		__entry->median_m,
+		__entry->median_error,
+		__entry->history_len,
+		__entry->x,
+		__entry->y
+	)
+);
+
+
+#endif /* _CROS_EC_SENSORHUB_TRACE_H_ */
+
+/* this part must be outside header guard */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE cros_ec_sensorhub_trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/platform/chrome/cros_ec_trace.h b/drivers/platform/chrome/cros_ec_trace.h
index 7e7cfc98657a4a..9bb5cd2c98b8b4 100644
--- a/drivers/platform/chrome/cros_ec_trace.h
+++ b/drivers/platform/chrome/cros_ec_trace.h
@@ -15,7 +15,6 @@
 #include <linux/types.h>
 #include <linux/platform_data/cros_ec_commands.h>
 #include <linux/platform_data/cros_ec_proto.h>
-#include <linux/platform_data/cros_ec_sensorhub.h>
 
 #include <linux/tracepoint.h>
 
@@ -71,100 +70,6 @@ TRACE_EVENT(cros_ec_request_done,
 		  __entry->retval)
 );
 
-TRACE_EVENT(cros_ec_sensorhub_timestamp,
-	    TP_PROTO(u32 ec_sample_timestamp, u32 ec_fifo_timestamp, s64 fifo_timestamp,
-		     s64 current_timestamp, s64 current_time),
-	TP_ARGS(ec_sample_timestamp, ec_fifo_timestamp, fifo_timestamp, current_timestamp,
-		current_time),
-	TP_STRUCT__entry(
-		__field(u32, ec_sample_timestamp)
-		__field(u32, ec_fifo_timestamp)
-		__field(s64, fifo_timestamp)
-		__field(s64, current_timestamp)
-		__field(s64, current_time)
-		__field(s64, delta)
-	),
-	TP_fast_assign(
-		__entry->ec_sample_timestamp = ec_sample_timestamp;
-		__entry->ec_fifo_timestamp = ec_fifo_timestamp;
-		__entry->fifo_timestamp = fifo_timestamp;
-		__entry->current_timestamp = current_timestamp;
-		__entry->current_time = current_time;
-		__entry->delta = current_timestamp - current_time;
-	),
-	TP_printk("ec_ts: %9u, ec_fifo_ts: %9u, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
-		  __entry->ec_sample_timestamp,
-		__entry->ec_fifo_timestamp,
-		__entry->fifo_timestamp,
-		__entry->current_timestamp,
-		__entry->current_time,
-		__entry->delta
-	)
-);
-
-TRACE_EVENT(cros_ec_sensorhub_data,
-	    TP_PROTO(u32 ec_sensor_num, u32 ec_fifo_timestamp, s64 fifo_timestamp,
-		     s64 current_timestamp, s64 current_time),
-	TP_ARGS(ec_sensor_num, ec_fifo_timestamp, fifo_timestamp, current_timestamp, current_time),
-	TP_STRUCT__entry(
-		__field(u32, ec_sensor_num)
-		__field(u32, ec_fifo_timestamp)
-		__field(s64, fifo_timestamp)
-		__field(s64, current_timestamp)
-		__field(s64, current_time)
-		__field(s64, delta)
-	),
-	TP_fast_assign(
-		__entry->ec_sensor_num = ec_sensor_num;
-		__entry->ec_fifo_timestamp = ec_fifo_timestamp;
-		__entry->fifo_timestamp = fifo_timestamp;
-		__entry->current_timestamp = current_timestamp;
-		__entry->current_time = current_time;
-		__entry->delta = current_timestamp - current_time;
-	),
-	TP_printk("ec_num: %4u, ec_fifo_ts: %9u, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
-		  __entry->ec_sensor_num,
-		__entry->ec_fifo_timestamp,
-		__entry->fifo_timestamp,
-		__entry->current_timestamp,
-		__entry->current_time,
-		__entry->delta
-	)
-);
-
-TRACE_EVENT(cros_ec_sensorhub_filter,
-	    TP_PROTO(struct cros_ec_sensors_ts_filter_state *state, s64 dx, s64 dy),
-	TP_ARGS(state, dx, dy),
-	TP_STRUCT__entry(
-		__field(s64, dx)
-		__field(s64, dy)
-		__field(s64, median_m)
-		__field(s64, median_error)
-		__field(s64, history_len)
-		__field(s64, x)
-		__field(s64, y)
-	),
-	TP_fast_assign(
-		__entry->dx = dx;
-		__entry->dy = dy;
-		__entry->median_m = state->median_m;
-		__entry->median_error = state->median_error;
-		__entry->history_len = state->history_len;
-		__entry->x = state->x_offset;
-		__entry->y = state->y_offset;
-	),
-	TP_printk("dx: %12lld. dy: %12lld median_m: %12lld median_error: %12lld len: %lld x: %12lld y: %12lld",
-		  __entry->dx,
-		__entry->dy,
-		__entry->median_m,
-		__entry->median_error,
-		__entry->history_len,
-		__entry->x,
-		__entry->y
-	)
-);
-
-
 #endif /* _CROS_EC_TRACE_H_ */
 
 /* this part must be outside header guard */
-- 
2.35.0.rc0.227.g00780c9af4-goog

