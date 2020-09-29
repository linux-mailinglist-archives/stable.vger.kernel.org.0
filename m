Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837E627C7EF
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbgI2L5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbgI2LnC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0B50206F7;
        Tue, 29 Sep 2020 11:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379782;
        bh=RuOcHj6Pq7vRFqIp9YPlvoYdwRZ5RcdJnj7QOiZtsFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uwEXnbJFA+JoUByeXOEdXwj7d4hoCTPMETdvL49WvTVwrtDS/wU+pC8WrbGCoU6nT
         U0RuT/LsTsNO6ynFoHMrSevHbTR1XLLc4Ijz7hBkJPuCBx+w6boSpDKrmX64DsQa8d
         vinSwaQComWaZAdECSG4KhEpCjpUgl2lYruMJlcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 285/388] perf stat: Fix duration_time value for higher intervals
Date:   Tue, 29 Sep 2020 13:00:16 +0200
Message-Id: <20200929110024.253062136@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit ea9eb1f456a08c18feb485894185f7a4e31cc8a4 ]

Joakim reported wrong duration_time value for interval bigger
than 4000 [1].

The problem is in the interval value we pass to update_stats
function, which is typed as 'unsigned int' and overflows when
we get over 2^32 (happens between intervals 4000 and 5000).

Retyping the passed value to unsigned long long.

[1] https://www.spinics.net/lists/linux-perf-users/msg11777.html

Fixes: b90f1333ef08 ("perf stat: Update walltime_nsecs_stats in interval mode")
Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200518131445.3745083-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 468fc49420ce1..ac2feddc75fdd 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -351,7 +351,7 @@ static void process_interval(void)
 	}
 
 	init_stats(&walltime_nsecs_stats);
-	update_stats(&walltime_nsecs_stats, stat_config.interval * 1000000);
+	update_stats(&walltime_nsecs_stats, stat_config.interval * 1000000ULL);
 	print_counters(&rs, 0, NULL);
 }
 
-- 
2.25.1



