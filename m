Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF7C226C40
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgGTPij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:38:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729208AbgGTPih (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:38:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DEC222CB2;
        Mon, 20 Jul 2020 15:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259517;
        bh=A0tEhcTZK2ORrISXVGP2mEpOtJHxZqgNwJBdE8A2b7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oM1TnI8fB8qE/u0S6pO9wHLuzEGXioLapjzUwVF0Kk7l8XJO40iOFP21ZgzvHzXOH
         pmbF75wCHOPBMQEOxrWhQxuqupYRgKYlh0+JVm4Q+3RpNTjC+0rffXx4UbFpTAIcG3
         22To+n8JOdAziZBN8HGmbYZIggi4Yyx0Y4hiXfk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jin Yao <yao.jin@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.4 35/58] perf stat: Zero all the ena and run array slot stats for interval mode
Date:   Mon, 20 Jul 2020 17:36:51 +0200
Message-Id: <20200720152748.948731592@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152747.127988571@linuxfoundation.org>
References: <20200720152747.127988571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jin Yao <yao.jin@linux.intel.com>

commit 0e0bf1ea1147fcf74eab19c2d3c853cc3740a72f upstream.

As the code comments in perf_stat_process_counter() say, we calculate
counter's data every interval, and the display code shows ps->res_stats
avg value. We need to zero the stats for interval mode.

But the current code only zeros the res_stats[0], it doesn't zero the
res_stats[1] and res_stats[2], which are for ena and run of counter.

This patch zeros the whole res_stats[] for interval mode.

Fixes: 51fd2df1e882 ("perf stat: Fix interval output values")
Signed-off-by: Jin Yao <yao.jin@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jin Yao <yao.jin@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200409070755.17261-1-yao.jin@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/stat.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/tools/perf/util/stat.c
+++ b/tools/perf/util/stat.c
@@ -318,8 +318,10 @@ int perf_stat_process_counter(struct per
 	 * interval mode, otherwise overall avg running
 	 * averages will be shown for each interval.
 	 */
-	if (config->interval)
-		init_stats(ps->res_stats);
+	if (config->interval) {
+		for (i = 0; i < 3; i++)
+			init_stats(&ps->res_stats[i]);
+	}
 
 	if (counter->per_pkg)
 		zero_per_pkg(counter);


