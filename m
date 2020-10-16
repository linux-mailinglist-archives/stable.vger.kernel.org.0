Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D971C290134
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405570AbgJPJJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395000AbgJPJJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A67721D81;
        Fri, 16 Oct 2020 09:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839340;
        bh=mproNZnamBATcM+ig0bwVL7EvJ1odgRY9i9o4w8Hy9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3Bm/q3AEijC2Lr/DP4ktYoDbiJY5MzMOHpxjRfEy8/gZfYZdHY7pNVJ2mkVsaq9l
         iZwxZ8fdFCiPbN8Duuh4yh95idNP1IifD0A4o7n6b5+MSMrp7mUShWo9Q7cD7VcUDl
         fjdwD2rT2qk4MuZZxGoNkHDrHSNKE6cL3EQ6nyA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Backlund <tmb@mageia.org>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Suzuki Poulouse <suzuki.poulose@arm.com>,
        Tor Jeremiassen <tor@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Barker <pbarker@konsulko.com>
Subject: [PATCH 4.19 01/21] perf cs-etm: Move definition of traceid_list global variable from header file
Date:   Fri, 16 Oct 2020 11:07:20 +0200
Message-Id: <20201016090437.378858243@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.301376476@linuxfoundation.org>
References: <20201016090437.301376476@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

commit 168200b6d6ea0cb5765943ec5da5b8149701f36a upstream.

The variable 'traceid_list' is defined in the header file cs-etm.h,
if multiple C files include cs-etm.h the compiler might complaint for
multiple definition of 'traceid_list'.

To fix multiple definition error, move the definition of 'traceid_list'
into cs-etm.c.

Fixes: cd8bfd8c973e ("perf tools: Add processing of coresight metadata")
Reported-by: Thomas Backlund <tmb@mageia.org>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: Mike Leach <mike.leach@linaro.org>
Tested-by: Thomas Backlund <tmb@mageia.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suzuki Poulouse <suzuki.poulose@arm.com>
Cc: Tor Jeremiassen <tor@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Link: http://lore.kernel.org/lkml/20200505133642.4756-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Barker <pbarker@konsulko.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/cs-etm.c |    3 +++
 tools/perf/util/cs-etm.h |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -87,6 +87,9 @@ struct cs_etm_queue {
 	struct cs_etm_packet *packet;
 };
 
+/* RB tree for quick conversion between traceID and metadata pointers */
+static struct intlist *traceid_list;
+
 static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
 					   pid_t tid, u64 time_);
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -53,9 +53,6 @@ enum {
 	CS_ETMV4_PRIV_MAX,
 };
 
-/* RB tree for quick conversion between traceID and CPUs */
-struct intlist *traceid_list;
-
 #define KiB(x) ((x) * 1024)
 #define MiB(x) ((x) * 1024 * 1024)
 


