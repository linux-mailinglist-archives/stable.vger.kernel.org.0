Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690EF4174B6
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345825AbhIXNJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346707AbhIXNHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:07:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F3F260F13;
        Fri, 24 Sep 2021 12:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488219;
        bh=0wLzpZUY+/4ujARyyXQcBrFTOpCAFqrVQsfDUe8Z9+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mYwqWzxhGI97PgJ9mJudwJF+JzgyRzXCWMiOAa25HIu+N1GscYhmJdMQVZvJM8Dc4
         EdgKKKiR6x07QB7FODmLQHdeSayc/drfN2JNdqWwtjF3cdwBQlxdr6Ayb64jPQip7W
         66OduOBjKVo8l55VgTtPtPXVbuYoZXznYFB75oB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Benson Leung <bleung@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/63] platform/chrome: cros_ec_trace: Fix format warnings
Date:   Fri, 24 Sep 2021 14:44:29 +0200
Message-Id: <20210924124335.273049223@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

[ Upstream commit 4665584888ad2175831c972c004115741ec799e9 ]

Fix printf format issues in new tracing events.

Fixes: 814318242687 ("platform/chrome: cros_ec_trace: Add fields to command traces")

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Link: https://lore.kernel.org/r/20210830180050.2077261-1-gwendal@chromium.org
Signed-off-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_trace.h b/drivers/platform/chrome/cros_ec_trace.h
index f50b9f9b8610..7e7cfc98657a 100644
--- a/drivers/platform/chrome/cros_ec_trace.h
+++ b/drivers/platform/chrome/cros_ec_trace.h
@@ -92,7 +92,7 @@ TRACE_EVENT(cros_ec_sensorhub_timestamp,
 		__entry->current_time = current_time;
 		__entry->delta = current_timestamp - current_time;
 	),
-	TP_printk("ec_ts: %12lld, ec_fifo_ts: %12lld, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
+	TP_printk("ec_ts: %9u, ec_fifo_ts: %9u, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
 		  __entry->ec_sample_timestamp,
 		__entry->ec_fifo_timestamp,
 		__entry->fifo_timestamp,
@@ -122,7 +122,7 @@ TRACE_EVENT(cros_ec_sensorhub_data,
 		__entry->current_time = current_time;
 		__entry->delta = current_timestamp - current_time;
 	),
-	TP_printk("ec_num: %4d, ec_fifo_ts: %12lld, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
+	TP_printk("ec_num: %4u, ec_fifo_ts: %9u, fifo_ts: %12lld, curr_ts: %12lld, curr_time: %12lld, delta %12lld",
 		  __entry->ec_sensor_num,
 		__entry->ec_fifo_timestamp,
 		__entry->fifo_timestamp,
@@ -153,7 +153,7 @@ TRACE_EVENT(cros_ec_sensorhub_filter,
 		__entry->x = state->x_offset;
 		__entry->y = state->y_offset;
 	),
-	TP_printk("dx: %12lld. dy: %12lld median_m: %12lld median_error: %12lld len: %d x: %12lld y: %12lld",
+	TP_printk("dx: %12lld. dy: %12lld median_m: %12lld median_error: %12lld len: %lld x: %12lld y: %12lld",
 		  __entry->dx,
 		__entry->dy,
 		__entry->median_m,
-- 
2.33.0



