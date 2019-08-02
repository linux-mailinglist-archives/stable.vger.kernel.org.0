Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AA77F49C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404722AbfHBJbl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:31:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404701AbfHBJbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:31:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D664D21783;
        Fri,  2 Aug 2019 09:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738300;
        bh=EGq9TCZEoJrQDvJeAATuthGaRngDdhyVKAPjo5n3gWM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=isFDxq8ycLYVduXA49UF3ZecnIk9gIPQ+0nXI8aK1HmhxlbEEHPffudg1nvkHut6k
         jN5XxnMyrL0XFlZUqLSryz4yW65lsFw5BLrqICzD33fOb3sY3NTKGQaiO0zrJ4QAx+
         oBJuTihDjvFHYWgXYKcbclpcAJTZWpS76O71Fs1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 033/158] perf evsel: Make perf_evsel__name() accept a NULL argument
Date:   Fri,  2 Aug 2019 11:27:34 +0200
Message-Id: <20190802092210.515232601@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fdbdd7e8580eac9bdafa532746c865644d125e34 ]

In which case it simply returns "unknown", like when it can't figure out
the evsel->name value.

This makes this code more robust and fixes a problem in 'perf trace'
where a NULL evsel was being passed to a routine that only used the
evsel for printing its name when a invalid syscall id was passed.

Reported-by: Leo Yan <leo.yan@linaro.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lkml.kernel.org/n/tip-f30ztaasku3z935cn3ak3h53@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 97fde9275f42..a8507fee654b 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -491,6 +491,9 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 {
 	char bf[128];
 
+	if (!evsel)
+		goto out_unknown;
+
 	if (evsel->name)
 		return evsel->name;
 
@@ -527,7 +530,10 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 
 	evsel->name = strdup(bf);
 
-	return evsel->name ?: "unknown";
+	if (evsel->name)
+		return evsel->name;
+out_unknown:
+	return "unknown";
 }
 
 const char *perf_evsel__group_name(struct perf_evsel *evsel)
-- 
2.20.1



