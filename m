Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A9822EFE7
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbgG0OUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730946AbgG0OUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:20:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1009B2070A;
        Mon, 27 Jul 2020 14:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595859610;
        bh=wY3gEDid8XRTGPIhPyFJMzXs6oPbE2N5OTb+1bkLyEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EKn9BA2ILj0LeYC8yz1qVhEGlXb/2oFEayGmRSx4SzU1qMGmE2RGkevsqpwpRcjO/
         VPc4u7Ox/hHn1djTwk7UH/6cQUW6uLqs6HByBlScOqglyIZr+cHP/xFZwZtY7YXxbe
         x5QzhrkB94Bl8Vk/J4IWh0F3XqM0a20gWdifcnW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Richter <tmricht@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.7 037/179] s390/cpum_cf,perf: change DFLT_CCERROR counter name
Date:   Mon, 27 Jul 2020 16:03:32 +0200
Message-Id: <20200727134934.478017346@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134932.659499757@linuxfoundation.org>
References: <20200727134932.659499757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

commit 3d3af181d370069861a3be94608464e2ff3682e2 upstream.

Change the counter name DLFT_CCERROR to DLFT_CCFINISH on IBM z15.
This counter counts completed DEFLATE instructions with exit code
0, 1 or 2. Since exit code 0 means success and exit code 1 or 2
indicate errors, change the counter name to avoid confusion.
This counter is incremented each time the DEFLATE instruction
completed regardless if an error was detected or not.

Fixes: d68d5d51dc89 ("s390/cpum_cf: Add new extended counters for IBM z15")
Fixes: e7950166e402 ("perf vendor events s390: Add new deflate counters for IBM z15")
Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/perf_cpum_cf_events.c               |    4 ++--
 tools/perf/pmu-events/arch/s390/cf_z15/extended.json |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/s390/kernel/perf_cpum_cf_events.c
+++ b/arch/s390/kernel/perf_cpum_cf_events.c
@@ -292,7 +292,7 @@ CPUMF_EVENT_ATTR(cf_z15, TX_C_TABORT_SPE
 CPUMF_EVENT_ATTR(cf_z15, DFLT_ACCESS, 0x00f7);
 CPUMF_EVENT_ATTR(cf_z15, DFLT_CYCLES, 0x00fc);
 CPUMF_EVENT_ATTR(cf_z15, DFLT_CC, 0x00108);
-CPUMF_EVENT_ATTR(cf_z15, DFLT_CCERROR, 0x00109);
+CPUMF_EVENT_ATTR(cf_z15, DFLT_CCFINISH, 0x00109);
 CPUMF_EVENT_ATTR(cf_z15, MT_DIAG_CYCLES_ONE_THR_ACTIVE, 0x01c0);
 CPUMF_EVENT_ATTR(cf_z15, MT_DIAG_CYCLES_TWO_THR_ACTIVE, 0x01c1);
 
@@ -629,7 +629,7 @@ static struct attribute *cpumcf_z15_pmu_
 	CPUMF_EVENT_PTR(cf_z15, DFLT_ACCESS),
 	CPUMF_EVENT_PTR(cf_z15, DFLT_CYCLES),
 	CPUMF_EVENT_PTR(cf_z15, DFLT_CC),
-	CPUMF_EVENT_PTR(cf_z15, DFLT_CCERROR),
+	CPUMF_EVENT_PTR(cf_z15, DFLT_CCFINISH),
 	CPUMF_EVENT_PTR(cf_z15, MT_DIAG_CYCLES_ONE_THR_ACTIVE),
 	CPUMF_EVENT_PTR(cf_z15, MT_DIAG_CYCLES_TWO_THR_ACTIVE),
 	NULL,
--- a/tools/perf/pmu-events/arch/s390/cf_z15/extended.json
+++ b/tools/perf/pmu-events/arch/s390/cf_z15/extended.json
@@ -380,7 +380,7 @@
 	{
 		"Unit": "CPU-M-CF",
 		"EventCode": "265",
-		"EventName": "DFLT_CCERROR",
+		"EventName": "DFLT_CCFINISH",
 		"BriefDescription": "Increments by one for every DEFLATE CONVERSION CALL instruction executed that ended in Condition Codes 0, 1 or 2",
 		"PublicDescription": "Increments by one for every DEFLATE CONVERSION CALL instruction executed that ended in Condition Codes 0, 1 or 2"
 	},


