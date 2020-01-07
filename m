Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29DB133247
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729750AbgAGVIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:08:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729590AbgAGVIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:08:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A72A22077B;
        Tue,  7 Jan 2020 21:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431333;
        bh=UcHpKJl6PsKK6e+oSbmbpIDx26PxKKmsRzq5pfrhOXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=boN8Kim9OmoSBRlLAEsc21r4ZaaPf/HwPR68OYt8V2mxB1fuMdL0TE9dtPCSe6MAW
         uCsnlXaZwI6NcD8ypKUzWBJbK+MnIbJ0khG8sNuEDjRN3LMJVebhU5OaWQFGKiBmRl
         Rg1v+xSVN9Ceqsj1JqGnaVmWre27OmfjAq1YcYhc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 14/74] s390/cpum_sf: Adjust sampling interval to avoid hitting sample limits
Date:   Tue,  7 Jan 2020 21:54:39 +0100
Message-Id: <20200107205145.640285828@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 45304085b6ee..95c047bf4a12 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1306,6 +1306,22 @@ static void hw_perf_event_update(struct perf_event *event, int flush_all)
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



