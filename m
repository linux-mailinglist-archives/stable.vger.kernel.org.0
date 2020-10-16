Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D12290171
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 11:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394603AbgJPJOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 05:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405227AbgJPJJ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 05:09:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3CAE20848;
        Fri, 16 Oct 2020 09:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602839396;
        bh=iKOWJVoDIZXni3KU+ogQlI6gzZv2/OUlWaXlqGHnH6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h1HtOArXTLvGf+NNhl0f+adXTKn81X8t+WJImZfYV+07lBAhcBze7Ssa6n93D7K/b
         4Ol4nrClPMYTgHei+qKNQLQexe1TekfZ2f7QDIXub9PrPQJFb29r84S0AKSFMl2BN6
         +mvdRHdHITiVwOSnPmhdiT/Yr5gGC1TLeF4vfrhI=
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
Subject: [PATCH 5.4 01/22] perf cs-etm: Move definition of traceid_list global variable from header file
Date:   Fri, 16 Oct 2020 11:07:29 +0200
Message-Id: <20201016090437.378628931@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016090437.308349327@linuxfoundation.org>
References: <20201016090437.308349327@linuxfoundation.org>
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
@@ -94,6 +94,9 @@ struct cs_etm_queue {
 	struct cs_etm_traceid_queue **traceid_queues;
 };
 
+/* RB tree for quick conversion between traceID and metadata pointers */
+static struct intlist *traceid_list;
+
 static int cs_etm__update_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_queues(struct cs_etm_auxtrace *etm);
 static int cs_etm__process_timeless_queues(struct cs_etm_auxtrace *etm,
--- a/tools/perf/util/cs-etm.h
+++ b/tools/perf/util/cs-etm.h
@@ -114,9 +114,6 @@ enum cs_etm_isa {
 	CS_ETM_ISA_T32,
 };
 
-/* RB tree for quick conversion between traceID and metadata pointers */
-struct intlist *traceid_list;
-
 struct cs_etm_queue;
 
 struct cs_etm_packet {


