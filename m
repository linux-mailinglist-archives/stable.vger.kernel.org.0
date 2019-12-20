Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DCD127D09
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfLTOcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:32:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727954AbfLTOa5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:30:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A30324688;
        Fri, 20 Dec 2019 14:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852255;
        bh=N+Syp+tVyTTkC0OGDVGX2p0ifcK2GAKTQ4CCcKjbYwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lgO++ViMdW8P/OcWx8ORU1dP+XluKL5A6IM1JsKABjbDhft5oz2zx2o5msIm4DUqJ
         JY0yYwcixgoSL4aJYApf5H2+y9F1a4xGFF13w1C6ztlxKX4MlFpfJM70fRUsZAdE9n
         FaW57F2j/J5KmdLZWs/8/zGt3pMXIP80hsCC8wf0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 46/52] s390/cpum_sf: Avoid SBD overflow condition in irq handler
Date:   Fri, 20 Dec 2019 09:29:48 -0500
Message-Id: <20191220142954.9500-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220142954.9500-1-sashal@kernel.org>
References: <20191220142954.9500-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 0539ad0b22877225095d8adef0c376f52cc23834 ]

The s390 CPU Measurement sampling facility has an overflow condition
which fires when all entries in a SBD are used.
The measurement alert interrupt is triggered and reads out all samples
in this SDB. It then tests the successor SDB, if this SBD is not full,
the interrupt handler does not read any samples at all from this SDB
The design waits for the hardware to fill this SBD and then trigger
another meassurement alert interrupt.

This scheme works nicely until
an perf_event_overflow() function call discards the sample due to
a too high sampling rate.
The interrupt handler has logic to read out a partially filled SDB
when the perf event overflow condition in linux common code is met.
This causes the CPUM sampling measurement hardware and the PMU
device driver to operate on the same SBD's trailer entry.
This should not happen.

This can be seen here using this trace:
   cpumsf_pmu_add: tear:0xb5286000
   hw_perf_event_update: sdbt 0xb5286000 full 1 over 0 flush_all:0
   hw_perf_event_update: sdbt 0xb5286008 full 0 over 0 flush_all:0
        above shows 1. interrupt
   hw_perf_event_update: sdbt 0xb5286008 full 1 over 0 flush_all:0
   hw_perf_event_update: sdbt 0xb5286008 full 0 over 0 flush_all:0
        above shows 2. interrupt
	... this goes on fine until...
   hw_perf_event_update: sdbt 0xb5286068 full 1 over 0 flush_all:0
   perf_push_sample1: overflow
      one or more samples read from the IRQ handler are rejected by
      perf_event_overflow() and the IRQ handler advances to the next SDB
      and modifies the trailer entry of a partially filled SDB.
   hw_perf_event_update: sdbt 0xb5286070 full 0 over 0 flush_all:1
      timestamp: 14:32:52.519953

Next time the IRQ handler is called for this SDB the trailer entry shows
an overflow count of 19 missed entries.
   hw_perf_event_update: sdbt 0xb5286070 full 1 over 19 flush_all:1
      timestamp: 14:32:52.970058

Remove access to a follow on SDB when event overflow happened.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 8c384e6ea36ac..8ad406f7264a4 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1300,12 +1300,6 @@ static void hw_perf_event_update(struct perf_event *event, int flush_all)
 		 */
 		if (flush_all && done)
 			break;
-
-		/* If an event overflow happened, discard samples by
-		 * processing any remaining sample-data-blocks.
-		 */
-		if (event_overflow)
-			flush_all = 1;
 	}
 
 	/* Account sample overflows in the event hardware structure */
-- 
2.20.1

