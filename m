Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6E02E1E38
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgLWPeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:44872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728349AbgLWPeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05ACB23371;
        Wed, 23 Dec 2020 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737584;
        bh=xU/1gEQBhMmzFwy+0MDHIawUXv4l2c99tIP6CZHlV/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ki3QfHMXs+8ea1QYFKFdF34JQ6if7hnJUSico0Jvbwx+gjfi6pgiwU128P0PXTyPc
         j65nQbD1yBUv7im4fq1NoFbLTo+RgPIgj4Z7lQQHlx9lx63s2UDJdni8J1Sf9R+jq7
         F1pL36sBxmZ4ocK4neEVotMgBDphDcYRlcTUY74Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 18/40] coresight: etb10: Fix possible NULL ptr dereference in etb_enable_perf()
Date:   Wed, 23 Dec 2020 16:33:19 +0100
Message-Id: <20201223150516.429637132@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223150515.553836647@linuxfoundation.org>
References: <20201223150515.553836647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>

commit 22b2beaa7f166f550424cbb3b988aeaa7ef0425a upstream.

There was a report of NULL pointer dereference in ETF enable
path for perf CS mode with PID monitoring. It is almost 100%
reproducible when the process to monitor is something very
active such as chrome and with ETF as the sink, not ETR.

But code path shows that ETB has a similar path as ETF, so
there could be possible NULL pointer dereference crash in
ETB as well. Currently in a bid to find the pid, the owner
is dereferenced via task_pid_nr() call in etb_enable_perf()
and with owner being NULL, we can get a NULL pointer
dereference, so have a similar fix as ETF where we cache PID
in alloc_buffer() callback which is called as the part of
etm_setup_aux().

Fixes: 75d7dbd38824 ("coresight: etb10: Add support for CPU-wide trace scenarios")
Cc: stable@vger.kernel.org
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-11-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-etb10.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-etb10.c
+++ b/drivers/hwtracing/coresight/coresight-etb10.c
@@ -176,6 +176,7 @@ static int etb_enable_perf(struct coresi
 	unsigned long flags;
 	struct etb_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
 	struct perf_output_handle *handle = data;
+	struct cs_buffers *buf = etm_perf_sink_config(handle);
 
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 
@@ -186,7 +187,7 @@ static int etb_enable_perf(struct coresi
 	}
 
 	/* Get a handle on the pid of the process to monitor */
-	pid = task_pid_nr(handle->event->owner);
+	pid = buf->pid;
 
 	if (drvdata->pid != -1 && drvdata->pid != pid) {
 		ret = -EBUSY;
@@ -383,6 +384,7 @@ static void *etb_alloc_buffer(struct cor
 	if (!buf)
 		return NULL;
 
+	buf->pid = task_pid_nr(event->owner);
 	buf->snapshot = overwrite;
 	buf->nr_pages = nr_pages;
 	buf->data_pages = pages;


