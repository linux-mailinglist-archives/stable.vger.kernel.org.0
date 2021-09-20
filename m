Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4405F41263F
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387201AbhITS4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1384542AbhITSsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:48:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0849F6336E;
        Mon, 20 Sep 2021 17:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159237;
        bh=x7rPBipq78G9aI//ptbkYNECguRYHYeDLrRDC8NK408=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Lpt/KZk6Vp37y3oYNB2revlVP08cPpfOHxgsQ8A2Vu179mu5TVZ/PM4Jz0hU1U2L
         ePPUysgw/s3yMPSr/wMn6G9382iow86sQbW/YD5BUKEm987mBQLXNCi42Xy++RFKc5
         FAD/Gji0stlBzg50OHp0PupACVDUI9T3TksrYeGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 140/168] perf config: Fix caching and memory leak in perf_home_perfconfig()
Date:   Mon, 20 Sep 2021 18:44:38 +0200
Message-Id: <20210920163926.257664516@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@kernel.org>

[ Upstream commit 261f491133aecb943ccfdc3b3794e2d775607a87 ]

Acaict, perf_home_perfconfig() is supposed to cache the result of
home_perfconfig, which returns the default location of perfconfig for
the user, given the HOME environment variable.

However, the current implementation calls home_perfconfig every time
perf_home_perfconfig() is called (so no caching is actually performed),
replacing the previous pointer, thus also causing a memory leak.

This patch adds a check of whether either config or failed is set and,
in that case, directly returns config without calling home_perfconfig at
each invocation.

Fixes: f5f03e19ce14fc31 ("perf config: Add perf_home_perfconfig function")
Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jin Yao <yao.jin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <song@kernel.org>
Link: http://lore.kernel.org/lkml/20210820130817.740536-1-rickyman7@gmail.com
[ Removed needless double check for the 'failed' variable ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/config.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 63d472b336de..4fb5e90d7a57 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -581,7 +581,10 @@ const char *perf_home_perfconfig(void)
 	static const char *config;
 	static bool failed;
 
-	config = failed ? NULL : home_perfconfig();
+	if (failed || config)
+		return config;
+
+	config = home_perfconfig();
 	if (!config)
 		failed = true;
 
-- 
2.30.2



