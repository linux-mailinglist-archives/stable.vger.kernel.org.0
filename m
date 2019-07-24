Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A64E273969
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389704AbfGXTj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388525AbfGXTj4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:39:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893A620665;
        Wed, 24 Jul 2019 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997196;
        bh=wLasL/pUJqvVePSzj70gWRxbCi16JyQ7xzLGqc936FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IIcAgPZgY+RYwCqTTTb6WHz3gDXg64pcDb3/SMS4qgPk1K2aWEcfIevgc7FKAz89c
         DtnhNEhp8BAqok8+RltdaFHBFxRkzSqRi7qYik826jFu+WI2clriHp2PvJ45oRBtK6
         ZiAFoe3QZ729c9WGC9poFpZLf9U3d0wUxAjhkZfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Gary Hook <Gary.Hook@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Liska <mliska@suse.cz>,
        Namhyung Kim <namhyung@kernel.org>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.2 355/413] perf/x86/amd/uncore: Do not set ThreadMask and SliceMask for non-L3 PMCs
Date:   Wed, 24 Jul 2019 21:20:46 +0200
Message-Id: <20190724191801.113101726@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 16f4641166b10e199f0d7b68c2c5f004fef0bda3 upstream.

The following commit:

  d7cbbe49a930 ("perf/x86/amd/uncore: Set ThreadMask and SliceMask for L3 Cache perf events")

enables L3 PMC events for all threads and slices by writing 1's in
'ChL3PmcCfg' (L3 PMC PERF_CTL) register fields.

Those bitfields overlap with high order event select bits in the Data
Fabric PMC control register, however.

So when a user requests raw Data Fabric events (-e amd_df/event=0xYYY/),
the two highest order bits get inadvertently set, changing the counter
select to events that don't exist, and for which no counts are read.

This patch changes the logic to write the L3 masks only when dealing
with L3 PMC counters.

AMD Family 16h and below Northbridge (NB) counters were not affected.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Gary Hook <Gary.Hook@amd.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Liska <mliska@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Pu Wen <puwen@hygon.cn>
Cc: Stephane Eranian <eranian@google.com>
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Fixes: d7cbbe49a930 ("perf/x86/amd/uncore: Set ThreadMask and SliceMask for L3 Cache perf events")
Link: https://lkml.kernel.org/r/20190628215906.4276-1-kim.phillips@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/amd/uncore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/amd/uncore.c
+++ b/arch/x86/events/amd/uncore.c
@@ -206,7 +206,7 @@ static int amd_uncore_event_init(struct
 	 * SliceMask and ThreadMask need to be set for certain L3 events in
 	 * Family 17h. For other events, the two fields do not affect the count.
 	 */
-	if (l3_mask)
+	if (l3_mask && is_llc_event(event))
 		hwc->config |= (AMD64_L3_SLICE_MASK | AMD64_L3_THREAD_MASK);
 
 	if (event->cpu < 0)


