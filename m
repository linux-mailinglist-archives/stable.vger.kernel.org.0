Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FB42E1E33
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 16:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgLWPeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 10:34:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728264AbgLWPeA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Dec 2020 10:34:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5019F23359;
        Wed, 23 Dec 2020 15:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608737577;
        bh=qrSCJ4ABI+TtwQhR1J3g+DK6JBfJxLoqz1ZQ6N9mA7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQTfr7VtWk9MNw8q2RthzJ6CHgrg+SiwVKp+/UAaDrpt+s+T/2gbMImCx/DgoKt+5
         GW7SF6JkMaYZSyD3i3zvSgkGwbaS53ddnby3pPe+YJU60YCidtJ+PkYji3l6xvQLZv
         59rv4wz/mlTgfHwTZ8I8hXjgqFaJfjoY6LaatlZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 5.10 15/40] coresight: tmc-etf: Fix NULL ptr dereference in tmc_enable_etf_sink_perf()
Date:   Wed, 23 Dec 2020 16:33:16 +0100
Message-Id: <20201223150516.292233870@linuxfoundation.org>
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

commit 868663dd5d69fef05bfb004f91da5c30e9b93461 upstream.

There was a report of NULL pointer dereference in ETF enable
path for perf CS mode with PID monitoring. It is almost 100%
reproducible when the process to monitor is something very
active such as chrome and with ETF as the sink and not ETR.
Currently in a bid to find the pid, the owner is dereferenced
via task_pid_nr() call in tmc_enable_etf_sink_perf() and with
owner being NULL, we get a NULL pointer dereference.

Looking at the ETR and other places in the kernel, ETF and the
ETB are the only places trying to dereference the task(owner)
in tmc_enable_etf_sink_perf() which is also called from the
sched_in path as in the call trace. Owner(task) is NULL even
in the case of ETR in tmc_enable_etr_sink_perf(), but since we
cache the PID in alloc_buffer() callback and it is done as part
of etm_setup_aux() when allocating buffer for ETR sink, we never
dereference this NULL pointer and we are safe. So lets do the
same thing with ETF and cache the PID to which the cs_buffer
belongs in tmc_alloc_etf_buffer() as done for ETR. This will
also remove the unnecessary function calls(task_pid_nr()) since
we are caching the PID.

Easily reproducible running below:

 perf record -e cs_etm/@tmc_etf0/ -N -p <pid>

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000548
Mem abort info:
  ESR = 0x96000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
Data abort info:
  ISV = 0, ISS = 0x00000006
  CM = 0, WnR = 0
<snip>...
Call trace:
 tmc_enable_etf_sink+0xe4/0x280
 coresight_enable_path+0x168/0x1fc
 etm_event_start+0x8c/0xf8
 etm_event_add+0x38/0x54
 event_sched_in+0x194/0x2ac
 group_sched_in+0x54/0x12c
 flexible_sched_in+0xd8/0x120
 visit_groups_merge+0x100/0x16c
 ctx_flexible_sched_in+0x50/0x74
 ctx_sched_in+0xa4/0xa8
 perf_event_sched_in+0x60/0x6c
 perf_event_context_sched_in+0x98/0xe0
 __perf_event_task_sched_in+0x5c/0xd8
 finish_task_switch+0x184/0x1cc
 schedule_tail+0x20/0xec
 ret_from_fork+0x4/0x18

Fixes: 880af782c6e8 ("coresight: tmc-etf: Add support for CPU-wide trace scenarios")
Cc: stable@vger.kernel.org
Signed-off-by: Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201127175256.1092685-10-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwtracing/coresight/coresight-priv.h    |    2 ++
 drivers/hwtracing/coresight/coresight-tmc-etf.c |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-priv.h
+++ b/drivers/hwtracing/coresight/coresight-priv.h
@@ -87,6 +87,7 @@ enum cs_mode {
  * struct cs_buffer - keep track of a recording session' specifics
  * @cur:	index of the current buffer
  * @nr_pages:	max number of pages granted to us
+ * @pid:	PID this cs_buffer belongs to
  * @offset:	offset within the current buffer
  * @data_size:	how much we collected in this run
  * @snapshot:	is this run in snapshot mode
@@ -95,6 +96,7 @@ enum cs_mode {
 struct cs_buffers {
 	unsigned int		cur;
 	unsigned int		nr_pages;
+	pid_t			pid;
 	unsigned long		offset;
 	local_t			data_size;
 	bool			snapshot;
--- a/drivers/hwtracing/coresight/coresight-tmc-etf.c
+++ b/drivers/hwtracing/coresight/coresight-tmc-etf.c
@@ -227,6 +227,7 @@ static int tmc_enable_etf_sink_perf(stru
 	unsigned long flags;
 	struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
 	struct perf_output_handle *handle = data;
+	struct cs_buffers *buf = etm_perf_sink_config(handle);
 
 	spin_lock_irqsave(&drvdata->spinlock, flags);
 	do {
@@ -243,7 +244,7 @@ static int tmc_enable_etf_sink_perf(stru
 		}
 
 		/* Get a handle on the pid of the process to monitor */
-		pid = task_pid_nr(handle->event->owner);
+		pid = buf->pid;
 
 		if (drvdata->pid != -1 && drvdata->pid != pid) {
 			ret = -EBUSY;
@@ -399,6 +400,7 @@ static void *tmc_alloc_etf_buffer(struct
 	if (!buf)
 		return NULL;
 
+	buf->pid = task_pid_nr(event->owner);
 	buf->snapshot = overwrite;
 	buf->nr_pages = nr_pages;
 	buf->data_pages = pages;


