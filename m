Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84F105A4A63
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbiH2Lhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:37:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbiH2LhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:37:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073D27F0AF;
        Mon, 29 Aug 2022 04:21:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03BD5B80F9C;
        Mon, 29 Aug 2022 11:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557AAC433D6;
        Mon, 29 Aug 2022 11:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771642;
        bh=WsrrEYl6BCNkHwhC3FbLb44ylZ8NV6zRuGxlu10Lnx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JtDLc+75F4c+IluIZSxw7hBs6kH2T8lwS7hI49/9tRB1UujVGzJ63qCp12UKd3TQY
         6ofe8qnBOmRBBxVMyw26KDwxCEnLLb2bbALLYFmUcHczmBOEN4r/bBybCrsDCeqtaz
         Hlz5qLQR7NMqE3D5jW8BIWI9EZHlZ3TJwjFh6vHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 5.15 131/136] perf/x86/intel/uncore: Fix broken read_counter() for SNB IMC PMU
Date:   Mon, 29 Aug 2022 12:59:58 +0200
Message-Id: <20220829105810.074888714@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

commit 11745ecfe8fea4b4a4c322967a7605d2ecbd5080 upstream.

Existing code was generating bogus counts for the SNB IMC bandwidth counters:

$ perf stat -a -I 1000 -e uncore_imc/data_reads/,uncore_imc/data_writes/
     1.000327813           1,024.03 MiB  uncore_imc/data_reads/
     1.000327813              20.73 MiB  uncore_imc/data_writes/
     2.000580153         261,120.00 MiB  uncore_imc/data_reads/
     2.000580153              23.28 MiB  uncore_imc/data_writes/

The problem was introduced by commit:
  07ce734dd8ad ("perf/x86/intel/uncore: Clean up client IMC")

Where the read_counter callback was replace to point to the generic
uncore_mmio_read_counter() function.

The SNB IMC counters are freerunnig 32-bit counters laid out contiguously in
MMIO. But uncore_mmio_read_counter() is using a readq() call to read from
MMIO therefore reading 64-bit from MMIO. Although this is okay for the
uncore_perf_event_update() function because it is shifting the value based
on the actual counter width to compute a delta, it is not okay for the
uncore_pmu_event_start() which is simply reading the counter  and therefore
priming the event->prev_count with a bogus value which is responsible for
causing bogus deltas in the perf stat command above.

The fix is to reintroduce the custom callback for read_counter for the SNB
IMC PMU and use readl() instead of readq(). With the change the output of
perf stat is back to normal:
$ perf stat -a -I 1000 -e uncore_imc/data_reads/,uncore_imc/data_writes/
     1.000120987             296.94 MiB  uncore_imc/data_reads/
     1.000120987             138.42 MiB  uncore_imc/data_writes/
     2.000403144             175.91 MiB  uncore_imc/data_reads/
     2.000403144              68.50 MiB  uncore_imc/data_writes/

Fixes: 07ce734dd8ad ("perf/x86/intel/uncore: Clean up client IMC")
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20220803160031.1379788-1-eranian@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snb.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -788,6 +788,22 @@ int snb_pci2phy_map_init(int devid)
 	return 0;
 }
 
+static u64 snb_uncore_imc_read_counter(struct intel_uncore_box *box, struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	/*
+	 * SNB IMC counters are 32-bit and are laid out back to back
+	 * in MMIO space. Therefore we must use a 32-bit accessor function
+	 * using readq() from uncore_mmio_read_counter() causes problems
+	 * because it is reading 64-bit at a time. This is okay for the
+	 * uncore_perf_event_update() function because it drops the upper
+	 * 32-bits but not okay for plain uncore_read_counter() as invoked
+	 * in uncore_pmu_event_start().
+	 */
+	return (u64)readl(box->io_addr + hwc->event_base);
+}
+
 static struct pmu snb_uncore_imc_pmu = {
 	.task_ctx_nr	= perf_invalid_context,
 	.event_init	= snb_uncore_imc_event_init,
@@ -807,7 +823,7 @@ static struct intel_uncore_ops snb_uncor
 	.disable_event	= snb_uncore_imc_disable_event,
 	.enable_event	= snb_uncore_imc_enable_event,
 	.hw_config	= snb_uncore_imc_hw_config,
-	.read_counter	= uncore_mmio_read_counter,
+	.read_counter	= snb_uncore_imc_read_counter,
 };
 
 static struct intel_uncore_type snb_uncore_imc = {


