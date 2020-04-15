Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEAE71AA1A8
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 14:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898195AbgDOMoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 08:44:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897504AbgDOLnW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 07:43:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7740621556;
        Wed, 15 Apr 2020 11:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586951002;
        bh=/MSJmPAyZnt2p/ksWE5EYT8hkqDPx+HOjkdSGbwIEJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXAdu/SzV8My89ezotGEyMZzT9LYV21C4q1r+v148giQYJHToiHfApHWjfk3Uv6vu
         vA7sUg2QXaGiKZrSvp3WmUkufxqqXhtktPhIJkFleG8heUMgvXOLnyJao3W8fF0tkM
         30eqOEd5fOI8NqpHho8yh7+voh+GWZmaD2nPlDFw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Richter <tmricht@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 047/106] s390/cpum_sf: Fix wrong page count in error message
Date:   Wed, 15 Apr 2020 07:41:27 -0400
Message-Id: <20200415114226.13103-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
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
index 77d93c534284d..af11f3e1e8588 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1581,6 +1581,7 @@ static void hw_collect_aux(struct cpu_hw_sf *cpuhw)
 	perf_aux_output_end(handle, size);
 	num_sdb = aux->sfb.num_sdb;
 
+	num_sdb = aux->sfb.num_sdb;
 	while (!done) {
 		/* Get an output handle */
 		aux = perf_aux_output_begin(handle, cpuhw->event);
-- 
2.20.1

