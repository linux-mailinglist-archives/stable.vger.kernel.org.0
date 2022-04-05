Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 398294F322C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355549AbiDEKUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345924AbiDEJXL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:23:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CFFA6E38;
        Tue,  5 Apr 2022 02:12:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0A46B81A12;
        Tue,  5 Apr 2022 09:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31BFDC385A2;
        Tue,  5 Apr 2022 09:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149948;
        bh=baRRfmdaoZGbu2PPrt5s5Gx/3K/7lVG2bGsxzYUwojA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nXCqFDuBTB8uSV9hizY6cZZZHRdVSUd2icC+ER+Kr8SdFF94kULqTiUb4szaUauk6
         IGkJM0WnX7B1R0Y5JzuZaHGoSNBSgx0qxqU2yvgC2q6miL+JluA07/JWK26joU7qwM
         cCMZiwgS1sNkl5NaS9tSU5VG4pS79J1F36aD9ViE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 5.16 0899/1017] platform: chrome: Split trace include file
Date:   Tue,  5 Apr 2022 09:30:12 +0200
Message-Id: <20220405070420.911912326@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Gwendal Grignou <gwendal@chromium.org>

commit eabd9a3807e17e211690e6c40f1405b427b64c48 upstream.

cros_ec_trace.h defined 5 tracing events, 2 for cros_ec_proto and
3 for cros_ec_sensorhub_ring.
These 2 files are in different kernel modules, the traces are defined
twice in the kernel which leads to problem enabling only some traces.

Move sensorhub traces from cros_ec_trace.h to cros_ec_sensorhub_trace.h
and enable them only in cros_ec_sensorhub kernel module.

Check we can now enable any single traces: without this patch,
we can only enable all sensorhub traces or none.

Fixes: d453ceb6549a ("platform/chrome: sensorhub: Add trace events for sample")

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220122001301.640337-1-gwendal@chromium.org
Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/chrome/Makefile                  |    3 
 drivers/platform/chrome/cros_ec_sensorhub_ring.c  |    3 
 drivers/platform/chrome/cros_ec_sensorhub_trace.h |  123 ++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_trace.h           |   95 ----------------
 4 files changed, 127 insertions(+), 97 deletions(-)
 create mode 100644 drivers/platform/chrome/cros_ec_sensorhub_trace.h

--- a/drivers/platform/chrome/Makefile
+++ b/drivers/platform/chrome/Makefile
@@ -2,6 +2,7 @@
 
 # tell define_trace.h where to find the cros ec trace header
 CFLAGS_cros_ec_trace.o:=		-I$(src)
+CFLAGS_cros_ec_sensorhub_ring.o:=	-I$(src)
 
 obj-$(CONFIG_CHROMEOS_LAPTOP)		+= chromeos_laptop.o
 obj-$(CONFIG_CHROMEOS_PSTORE)		+= chromeos_pstore.o
@@ -20,7 +21,7 @@ obj-$(CONFIG_CROS_EC_CHARDEV)		+= cros_e
 obj-$(CONFIG_CROS_EC_LIGHTBAR)		+= cros_ec_lightbar.o
 obj-$(CONFIG_CROS_EC_VBC)		+= cros_ec_vbc.o
 obj-$(CONFIG_CROS_EC_DEBUGFS)		+= cros_ec_debugfs.o
-cros-ec-sensorhub-objs			:= cros_ec_sensorhub.o cros_ec_sensorhub_ring.o cros_ec_trace.o
+cros-ec-sensorhub-objs			:= cros_ec_sensorhub.o cros_ec_sensorhub_ring.o
 obj-$(CONFIG_CROS_EC_SENSORHUB)		+= cros-ec-sensorhub.o
 obj-$(CONFIG_CROS_EC_SYSFS)		+= cros_ec_sysfs.o
 obj-$(CONFIG_CROS_USBPD_LOGGER)		+= cros_usbpd_logger.o
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


