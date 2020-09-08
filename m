Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D514D261D16
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbgIHTbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731012AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0B27241A7;
        Tue,  8 Sep 2020 15:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579546;
        bh=/CmNhgqxZ+7MyzWgmRTnoJ1IsBiQQimdXO1C8uYuIbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHEf+EnRp5wwbO0V361Hjc3RDvIznJLQMLKuHBW+0x6n5iwEoD23RMLY8vmAxGNWr
         y81ZM3dznFuZoXI2v0cAKRo50v1E3IPZtj5MluTkbNUdo8abievTq4npmfDDB47NLa
         jhZOUimSzRJMlvoCDh2+CiP0CD54Po7QoQ+71Nvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vineet Gupta <vgupta@synopsys.com>
Subject: [PATCH 5.8 123/186] ARC: perf: dont bail setup if pct irq missing in device-tree
Date:   Tue,  8 Sep 2020 17:24:25 +0200
Message-Id: <20200908152247.597184161@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineet Gupta <vgupta@synopsys.com>

commit feb92d7d3813456c11dce215b3421801a78a8986 upstream.

Current code inadventely bails if hardware supports sampling/overflow
interrupts, but the irq is missing from device tree.

|
| # perf stat -e cycles,instructions,major-faults,minor-faults ../hackbench
| Running with 10 groups 400 process
| Time: 0.921
|
| Performance counter stats for '../hackbench':
|
|   <not supported>      cycles
|   <not supported>      instructions
|                 0      major-faults
|              8679      minor-faults

This need not be as we can still do simple counting based perf stat.
This unborks perf on HSDK-4xD

Cc: <stable@vger.kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arc/kernel/perf_event.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -562,7 +562,7 @@ static int arc_pmu_device_probe(struct p
 {
 	struct arc_reg_pct_build pct_bcr;
 	struct arc_reg_cc_build cc_bcr;
-	int i, has_interrupts;
+	int i, has_interrupts, irq;
 	int counter_size;	/* in bits */
 
 	union cc_name {
@@ -637,13 +637,7 @@ static int arc_pmu_device_probe(struct p
 		.attr_groups	= arc_pmu->attr_groups,
 	};
 
-	if (has_interrupts) {
-		int irq = platform_get_irq(pdev, 0);
-
-		if (irq < 0) {
-			pr_err("Cannot get IRQ number for the platform\n");
-			return -ENODEV;
-		}
+	if (has_interrupts && (irq = platform_get_irq(pdev, 0) >= 0)) {
 
 		arc_pmu->irq = irq;
 
@@ -652,9 +646,9 @@ static int arc_pmu_device_probe(struct p
 				   this_cpu_ptr(&arc_pmu_cpu));
 
 		on_each_cpu(arc_cpu_pmu_irq_init, &irq, 1);
-
-	} else
+	} else {
 		arc_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+	}
 
 	/*
 	 * perf parser doesn't really like '-' symbol in events name, so let's


