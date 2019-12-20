Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77AB8127DA5
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfLTOfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:35:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728207AbfLTOfL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:35:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4E724687;
        Fri, 20 Dec 2019 14:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852510;
        bh=cFAeeerNIHhEbysudvFWLjjl0LULntAll620cNQ4cKc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/3dF5MtFzS7rvS5S5rPJ4aYrGWTk4tIbPaL0klkcbdFPiSxQkr+1HIBVgruqIHlU
         IC7d8psxN7dW13MW/izUxJu6g4qRkswx7EsGfHNhf/fkedbji+JQtTe8/qLifqqQv9
         8rTb7BPRxJFCp/MqQvp/Elgs7cBx/vl5AGuvahKA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 28/34] s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits
Date:   Fri, 20 Dec 2019 09:34:27 -0500
Message-Id: <20191220143433.9922-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 39d4a501a9ef55c57b51e3ef07fc2aeed7f30b3b ]

Function perf_event_ever_overflow() and perf_event_account_interrupt()
are called every time samples are processed by the interrupt handler.
However function perf_event_account_interrupt() has checks to avoid being
flooded with interrupts (more then 1000 samples are received per
task_tick).  Samples are then dropped and a PERF_RECORD_THROTTLED is
added to the perf data. The perf subsystem limit calculation is:

    maximum sample frequency := 100000 --> 1 samples per 10 us
    task_tick = 10ms = 10000us --> 1000 samples per task_tick

The work flow is

measurement_alert() uses SDBT head and each SBDT points to 511
 SDB pages, each with 126 sample entries. After processing 8 SBDs
 and for each valid sample calling:

     perf_event_overflow()
       perf_event_account_interrupts()

there is a considerable amount of samples being dropped, especially when
the sample frequency is very high and near the 100000 limit.

To avoid the high amount of samples being dropped near the end of a
task_tick time frame, increment the sampling interval in case of
dropped events. The CPU Measurement sampling facility on the s390
supports only intervals, specifiing how many CPU cycles have to be
executed before a sample is generated. Increase the interval when the
samples being generated hit the task_tick limit.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index df92c2af99b69..0b09585305521 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1260,6 +1260,22 @@ static void hw_perf_event_update(struct perf_event *event, int flush_all)
 	if (sampl_overflow)
 		OVERFLOW_REG(hwc) = DIV_ROUND_UP(OVERFLOW_REG(hwc) +
 						 sampl_overflow, 1 + num_sdb);
+
+	/* Perf_event_overflow() and perf_event_account_interrupt() limit
+	 * the interrupt rate to an upper limit. Roughly 1000 samples per
+	 * task tick.
+	 * Hitting this limit results in a large number
+	 * of throttled REF_REPORT_THROTTLE entries and the samples
+	 * are dropped.
+	 * Slightly increase the interval to avoid hitting this limit.
+	 */
+	if (event_overflow) {
+		SAMPL_RATE(hwc) += DIV_ROUND_UP(SAMPL_RATE(hwc), 10);
+		debug_sprintf_event(sfdbg, 1, "%s: rate adjustment %ld\n",
+				    __func__,
+				    DIV_ROUND_UP(SAMPL_RATE(hwc), 10));
+	}
+
 	if (sampl_overflow || event_overflow)
 		debug_sprintf_event(sfdbg, 4, "hw_perf_event_update: "
 				    "overflow stats: sample=%llu event=%llu\n",
-- 
2.20.1

