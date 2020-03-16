Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77039186B9F
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 14:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbgCPNAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 09:00:02 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43219 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730896AbgCPNAB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 09:00:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DF0F95C0324;
        Mon, 16 Mar 2020 09:00:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 09:00:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=x6ZblU
        6RRbMTWRNbj+9Nl7cxao7BXlma9fIpkcNf8gQ=; b=QrF/MkvgdzHBEzivS8Bn2T
        xG+FInqvMRd2ZpUQC+EeplpZDv3QcFB3MMCwp9JsS0aAGIBcbqC7fjplVGQMS1v8
        CGF+9sb5DZYAuyUzB+iZ8wnEm3zolcT2vRlwr+to5i9uP5lt8bvdQjN20erqiTZq
        9Sf4vQdZz4odphw/H0EhZsfokdbLy0MVTrRCh+C+UgHxDsss1kXxyBMXg6OrmUYB
        JStglV2yutXsE+3H8DnLMw87VkwhT0AhM9AtDhNp4oO54vZDMViXJZ1DLwL27Rw4
        eEd8/xdxBEQcO83L1lU+d+H+TRYWDLLtgeYQUFhcvIJvjlzSuDJAdX4vDEr3BkKg
        ==
X-ME-Sender: <xms:UHhvXiuM-lnN4JICR5XDPAXVFgt_VQmaqucQwDVA7D2Vy3Bz93Op3A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:UHhvXk8zLmXHkHQi4YOnK0Q2WZ9088Lpi35tCVHFxAtUhcqHWccJ6Q>
    <xmx:UHhvXgbGXgNaioBpip--5cwdgRtMPwRMem-71blwfVclixzFwvgdNg>
    <xmx:UHhvXioCQx6tYwDZoKiMZJ1pJobZaBYqxtvneSdB8d6cEVy8A1NfHQ>
    <xmx:UHhvXql_C976-NW1bZAj_OPSO09i3Nwjv7fjpCuG4ETJlsJLvY65DA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67D423061CB6;
        Mon, 16 Mar 2020 09:00:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] perf/amd/uncore: Replace manual sampling check with" failed to apply to 4.14-stable tree
To:     kim.phillips@amd.com, bp@suse.de, peterz@infradead.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Mar 2020 13:59:49 +0100
Message-ID: <158436358923148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f967140dfb7442e2db0868b03b961f9c59418a1b Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@amd.com>
Date: Wed, 11 Mar 2020 14:13:21 -0500
Subject: [PATCH] perf/amd/uncore: Replace manual sampling check with
 CAP_NO_INTERRUPT flag

Enable the sampling check in kernel/events/core.c::perf_event_open(),
which returns the more appropriate -EOPNOTSUPP.

BEFORE:

  $ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
  Error:
  The sys_perf_event_open() syscall returned with 22 (Invalid argument) for event (l3_request_g1.caching_l3_cache_accesses).
  /bin/dmesg | grep -i perf may provide additional information.

With nothing relevant in dmesg.

AFTER:

  $ sudo perf record -a -e instructions,l3_request_g1.caching_l3_cache_accesses true
  Error:
  l3_request_g1.caching_l3_cache_accesses: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'

Fixes: c43ca5091a37 ("perf/x86/amd: Add support for AMD NB and L2I "uncore" counters")
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200311191323.13124-1-kim.phillips@amd.com

diff --git a/arch/x86/events/amd/uncore.c b/arch/x86/events/amd/uncore.c
index a6ea07f2aa84..4d867a752f0e 100644
--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -190,15 +190,12 @@ static int amd_uncore_event_init(struct perf_event *event)
 
 	/*
 	 * NB and Last level cache counters (MSRs) are shared across all cores
-	 * that share the same NB / Last level cache. Interrupts can be directed
-	 * to a single target core, however, event counts generated by processes
-	 * running on other cores cannot be masked out. So we do not support
-	 * sampling and per-thread events.
+	 * that share the same NB / Last level cache.  On family 16h and below,
+	 * Interrupts can be directed to a single target core, however, event
+	 * counts generated by processes running on other cores cannot be masked
+	 * out. So we do not support sampling and per-thread events via
+	 * CAP_NO_INTERRUPT, and we do not enable counter overflow interrupts:
 	 */
-	if (is_sampling_event(event) || event->attach_state & PERF_ATTACH_TASK)
-		return -EINVAL;
-
-	/* and we do not enable counter overflow interrupts */
 	hwc->config = event->attr.config & AMD64_RAW_EVENT_MASK_NB;
 	hwc->idx = -1;
 
@@ -306,7 +303,7 @@ static struct pmu amd_nb_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct pmu amd_llc_pmu = {
@@ -317,7 +314,7 @@ static struct pmu amd_llc_pmu = {
 	.start		= amd_uncore_start,
 	.stop		= amd_uncore_stop,
 	.read		= amd_uncore_read,
-	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE,
+	.capabilities	= PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)

