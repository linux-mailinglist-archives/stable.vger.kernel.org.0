Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98662BA546
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408131AbfIVSz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:57682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408119AbfIVSz5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:55:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 032E82184D;
        Sun, 22 Sep 2019 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178557;
        bh=B05maExQbhzmRz3QtW0v5BieCGz5HdQQOqgZortZCcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vv1dGigcj2DPR6weTZuGmKm6drNBKsscQtyrU+Ww6Qzalfs6KMWlKWRa0mtsUMnZo
         fYJKlUU1TIqadS1jBsDq5XbI4ES23Xtn6RFdap1JipwHpuz6Wv+64qdd/FgjtDOGAY
         btiq0EoEMroHO8PKoqTW8oUUvuRM388vGFDveEU4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gerald BAEZA <gerald.baeza@st.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 072/128] libperf: Fix alignment trap with xyarray contents in 'perf stat'
Date:   Sun, 22 Sep 2019 14:53:22 -0400
Message-Id: <20190922185418.2158-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gerald BAEZA <gerald.baeza@st.com>

[ Upstream commit d9c5c083416500e95da098c01be092b937def7fa ]

Following the patch 'perf stat: Fix --no-scale', an alignment trap
happens in process_counter_values() on ARMv7 platforms due to the
attempt to copy non 64 bits aligned double words (pointed by 'count')
via a NEON vectored instruction ('vld1' with 64 bits alignment
constraint).

This patch sets a 64 bits alignment constraint on 'contents[]' field in
'struct xyarray' since the 'count' pointer used above points to such a
structure.

Signed-off-by: Gerald Baeza <gerald.baeza@st.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1566464769-16374-1-git-send-email-gerald.baeza@st.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/xyarray.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/xyarray.h b/tools/perf/util/xyarray.h
index 7ffe562e7ae7f..2627b038b6f2a 100644
--- a/tools/perf/util/xyarray.h
+++ b/tools/perf/util/xyarray.h
@@ -2,6 +2,7 @@
 #ifndef _PERF_XYARRAY_H_
 #define _PERF_XYARRAY_H_ 1
 
+#include <linux/compiler.h>
 #include <sys/types.h>
 
 struct xyarray {
@@ -10,7 +11,7 @@ struct xyarray {
 	size_t entries;
 	size_t max_x;
 	size_t max_y;
-	char contents[];
+	char contents[] __aligned(8);
 };
 
 struct xyarray *xyarray__new(int xlen, int ylen, size_t entry_size);
-- 
2.20.1

