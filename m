Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4945B68CD3
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731173AbfGONyI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:54:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731710AbfGONyI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:54:08 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 941BE2083D;
        Mon, 15 Jul 2019 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198847;
        bh=mSBn9lkg/YU7uvkSnA6Q231i2Hl8tCfpjefingHG2pI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=piFbSbnuZ+uGelNn8HhCZhQwRfR9rTsr1z9HMp8gZALeAiN9/1KjRG0MAQoMH7YRv
         B5TgiAOsl1lTqDOwJfYpPffzgum7v4/B3/upwkj9FMmylssR0c9cvOw6XB4OxF412L
         WaGdUQf2hh5qFi6vPRme9WOEMAWZMaESDfNurMqU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Leo Yan <leo.yan@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 118/249] perf evsel: Make perf_evsel__name() accept a NULL argument
Date:   Mon, 15 Jul 2019 09:44:43 -0400
Message-Id: <20190715134655.4076-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
index 4a5947625c5c..2c46f9aa416c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -589,6 +589,9 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 {
 	char bf[128];
 
+	if (!evsel)
+		goto out_unknown;
+
 	if (evsel->name)
 		return evsel->name;
 
@@ -628,7 +631,10 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 
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

