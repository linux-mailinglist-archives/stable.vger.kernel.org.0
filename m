Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C123A1A9D8C
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409171AbgDOLpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409159AbgDOLpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:45:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 221A12137B;
        Wed, 15 Apr 2020 11:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951119;
        bh=QGF7u/cPWJ5PqpDZ6tAaNUUCujAeJ37DZ/ssCQQWpJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+XukrLuF765rL0RYQEBs4E330R1bB4qVpML/KUcklzRwCIDTj/HWyoIiyjqDaBYt
         pwvvGaJg4iKoCYlX4LIJCeT0KWqj3ZcXvbLEys4DPxB3eMo7C55kAJye9sqTaLrqFJ
         5S33S7ADpkRpFfQDsEi/nPEdHZzwjs2rJF7vSeHE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 33/84] s390/cpum_sf: Fix wrong page count in error message
Date:   Wed, 15 Apr 2020 07:43:50 -0400
Message-Id: <20200415114442.14166-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114442.14166-1-sashal@kernel.org>
References: <20200415114442.14166-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 4141b6a5e9f171325effc36a22eb92bf961e7a5c ]

When perf record -e SF_CYCLES_BASIC_DIAG runs with very high
frequency, the samples arrive faster than the perf process can
save them to file. Eventually, for longer running processes, this
leads to the siutation where the trace buffers allocated by perf
slowly fills up. At one point the auxiliary trace buffer is full
and  the CPU Measurement sampling facility is turned off. Furthermore
a warning is printed to the kernel log buffer:

cpum_sf: The AUX buffer with 0 pages for the diagnostic-sampling
	mode is full

The number of allocated pages for the auxiliary trace buffer is shown
as zero pages. That is wrong.

Fix this by saving the number of allocated pages before entering the
work loop in the interrupt handler. When the interrupt handler processes
the samples, it may detect the buffer full condition and stop sampling,
reducing the buffer size to zero.
Print the correct value in the error message:

cpum_sf: The AUX buffer with 256 pages for the diagnostic-sampling
	mode is full

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index fdb8083e7870c..229e1e2f8253a 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1589,6 +1589,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 	perf_aux_output_end(handle, size);
 	num_sdb = aux->sfb.num_sdb;
 
+	num_sdb = aux->sfb.num_sdb;
 	while (!done) {
 		/* Get an output handle */
 		aux = perf_aux_output_begin(handle, cpuhw->event);
-- 
2.20.1

