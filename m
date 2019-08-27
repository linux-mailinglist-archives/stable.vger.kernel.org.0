Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7C919E0B0
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbfH0IEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730668AbfH0IEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:04:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0E42206BA;
        Tue, 27 Aug 2019 08:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893072;
        bh=hNum6xY1ZxdFXvz+d1ludW6VEn5ALBpiGz7sSOzKs3s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jFNBns9uZKA5Kgppjdze725rl9cp5N8GEewZgZCbo4bFicrxmNcLWP1yNPwYGEj3p
         Y5C61Tojgzx1mYu8fBQicLT0EIvB0DWF7fbcsZxXOsuF2245zevEOzMHjroScUHTNb
         ir5berFvKvvLPiztZLrone+cgvs52OuYIEiv+eLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, He Zhe <zhe.he@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 104/162] perf cpumap: Fix writing to illegal memory in handling cpumap mask
Date:   Tue, 27 Aug 2019 09:50:32 +0200
Message-Id: <20190827072741.914554536@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5f5e25f1c7933a6e1673515c0b1d5acd82fea1ed ]

cpu_map__snprint_mask() would write to illegal memory pointed by
zalloc(0) when there is only one cpu.

This patch fixes the calculation and adds sanity check against the input
parameters.

Signed-off-by: He Zhe <zhe.he@windriver.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Fixes: 4400ac8a9a90 ("perf cpumap: Introduce cpu_map__snprint_mask()")
Link: http://lkml.kernel.org/r/1564734592-15624-2-git-send-email-zhe.he@windriver.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 0b599229bc7e9..0aba5b39c21ef 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -701,7 +701,10 @@ size_t cpu_map__snprint_mask(struct cpu_map *map, char *buf, size_t size)
 	unsigned char *bitmap;
 	int last_cpu = cpu_map__cpu(map, map->nr - 1);
 
-	bitmap = zalloc((last_cpu + 7) / 8);
+	if (buf == NULL)
+		return 0;
+
+	bitmap = zalloc(last_cpu / 8 + 1);
 	if (bitmap == NULL) {
 		buf[0] = '\0';
 		return 0;
-- 
2.20.1



