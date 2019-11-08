Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 766BBF560A
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391264AbfKHTG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:06:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391253AbfKHTGZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:06:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 806B3215EA;
        Fri,  8 Nov 2019 19:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239985;
        bh=7skNHl2lfzqMuJ/ZX/CMowiYnncczK5DRh0cTKlhqvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cs90nfejaDocEGG1MFpbxc9YU2cFocnJ5A/map8siuJYZgdVq+uCaYvBtRQXJ62Fe
         u731h3CeQ7KCoEPjKnHvGBII/zAP/CqtP7dZtayWK1xEUPEn7FfzjbloMl+j330Gb8
         SkO++oj4g88U2EgZv4up0E68Xi177uB4cKpEAWiI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Feilong Lin <linfeilong@huawei.com>,
        Hu Shiyuan <hushiyuan@huawei.com>,
        Igor Lubashev <ilubashe@akamai.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 049/140] perf tools: Fix resource leak of closedir() on the error paths
Date:   Fri,  8 Nov 2019 19:49:37 +0100
Message-Id: <20191108174908.479126672@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 6080728ff8e9c9116e52e6f840152356ac2fea56 ]

Both build_mem_topology() and rm_rf_depth_pat() have resource leaks of
closedir() on the error paths.

Fix this by calling closedir() before function returns.

Fixes: e2091cedd51b ("perf tools: Add MEM_TOPOLOGY feature to perf data file")
Fixes: cdb6b0235f17 ("perf tools: Add pattern name checking to rm_rf")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: Igor Lubashev <ilubashe@akamai.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Link: http://lore.kernel.org/lkml/cd5f7cd2-b80d-6add-20a1-32f4f43e0744@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 4 +++-
 tools/perf/util/util.c   | 6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e95a2a26c40a8..277cdf1fc5ac8 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1282,8 +1282,10 @@ static int build_mem_topology(struct memory_node *nodes, u64 size, u64 *cntp)
 			continue;
 
 		if (WARN_ONCE(cnt >= size,
-			      "failed to write MEM_TOPOLOGY, way too many nodes\n"))
+			"failed to write MEM_TOPOLOGY, way too many nodes\n")) {
+			closedir(dir);
 			return -1;
+		}
 
 		ret = memory_node__read(&nodes[cnt++], idx);
 	}
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index a61535cf1bca2..d0930c38e147e 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -176,8 +176,10 @@ static int rm_rf_depth_pat(const char *path, int depth, const char **pat)
 		if (!strcmp(d->d_name, ".") || !strcmp(d->d_name, ".."))
 			continue;
 
-		if (!match_pat(d->d_name, pat))
-			return -2;
+		if (!match_pat(d->d_name, pat)) {
+			ret =  -2;
+			break;
+		}
 
 		scnprintf(namebuf, sizeof(namebuf), "%s/%s",
 			  path, d->d_name);
-- 
2.20.1



