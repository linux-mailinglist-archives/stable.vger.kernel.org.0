Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85261CAA09
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389527AbfJCQSi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:45268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388735AbfJCQSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:18:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB977222C2;
        Thu,  3 Oct 2019 16:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119517;
        bh=B05maExQbhzmRz3QtW0v5BieCGz5HdQQOqgZortZCcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dj4W24CIeZ8v+fBwOUYUcpJgZV1BxZIf6tgPKqVsEa+LQCqeCctR5bkJk7hp/2gIf
         42Q6E/+HF/v/lkdreunrzlJy7oRD3xj0nbu6y4xYdmqVYA4QUaCyzfy1xhUtlkLvxp
         xbe1v1tRaQKug79o0gMgMbmdTAXryxu2h/cmVKtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gerald Baeza <gerald.baeza@st.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/211] libperf: Fix alignment trap with xyarray contents in perf stat
Date:   Thu,  3 Oct 2019 17:52:40 +0200
Message-Id: <20191003154508.450639124@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



