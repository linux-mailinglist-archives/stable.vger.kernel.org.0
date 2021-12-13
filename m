Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832894726C1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbhLMJyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38280 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbhLMJv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:51:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F8C6B80E16;
        Mon, 13 Dec 2021 09:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508A6C00446;
        Mon, 13 Dec 2021 09:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389114;
        bh=jQN/HNVVbD2WGBmSRc+jLwnRdojvjt56bzQhZG2x9iE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOuYVTm0sElbsq4wiehPDr95l2wRu1I+k56Q6aljZH5JsNM9VvRh39emjsquqExvk
         RVEeM1K9bGx/ytERkevSWgeebCtUn5DclE1iUyxJQSn7DPry7H657NBuVxSXRJEcsG
         2OwI80+Kz4+gP+6hmnxEmHshtOxYyKcTsbe0xOlw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Paul Clarke <pc@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 090/132] perf tools: Fix SMT detection fast read path
Date:   Mon, 13 Dec 2021 10:30:31 +0100
Message-Id: <20211213092942.198374589@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit 4ffbe87e2d5b53bcb0213d8650bbe70bf942de6a upstream.

sysfs__read_int() returns 0 on success, and so the fast read path was
always failing.

Fixes: bb629484d924118e ("perf tools: Simplify checking if SMT is active.")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Clarke <pc@us.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20211124001231.3277836-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/smt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/smt.c
+++ b/tools/perf/util/smt.c
@@ -15,7 +15,7 @@ int smt_on(void)
 	if (cached)
 		return cached_result;
 
-	if (sysfs__read_int("devices/system/cpu/smt/active", &cached_result) > 0)
+	if (sysfs__read_int("devices/system/cpu/smt/active", &cached_result) >= 0)
 		goto done;
 
 	ncpu = sysconf(_SC_NPROCESSORS_CONF);


