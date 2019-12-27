Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0FC12B855
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfL0Ryx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:54:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbfL0Rm2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 623A124654;
        Fri, 27 Dec 2019 17:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468548;
        bh=jV0Fn+92D1zShlnjiLkLneWO8c8R5+UdB7LDaQECXz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P6dKqBrRRbDkPe8GU2r6UvAK7TMOPCYJw+q4s9nL0IwnUWGW5eXCRpsXuOrGd+zqz
         VHLPmJ7mkAbf05tYl0qqjkSRKpCsTH/y1bypGXyNImZPZXBS6yP7iJ2i7zGIbOHxa3
         m/UFudYQfUsUx0fi1pnjQrRwze7LyNLWtq2S+xX0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Petlan <mpetlan@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 075/187] perf header: Fix false warning when there are no duplicate cache entries
Date:   Fri, 27 Dec 2019 12:39:03 -0500
Message-Id: <20191227174055.4923-75-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit 28707826877f84bce0977845ea529cbdd08e4e8d ]

Before this patch, perf expected that there might be NPROC*4 unique
cache entries at max, however, it also expected that some of them would
be shared and/or of the same size, thus the final number of entries
would be reduced to be lower than NPROC*4. In case the number of entries
hadn't been reduced (was NPROC*4), the warning was printed.

However, some systems might have unusual cache topology, such as the
following two-processor KVM guest:

	cpu  level  shared_cpu_list  size
	  0     1         0           32K
	  0     1         0           64K
	  0     2         0           512K
	  0     3         0           8192K
	  1     1         1           32K
	  1     1         1           64K
	  1     2         1           512K
	  1     3         1           8192K

This KVM guest has 8 (NPROC*4) unique cache entries, which used to make
perf printing the message, although there actually aren't "way too many
cpu caches".

v2: Removing unused argument.

v3: Unifying the way we obtain number of cpus.

v4: Removed '& UINT_MAX' construct which is redundant.

Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
LPU-Reference: 20191208162056.20772-1-mpetlan@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index becc2d109423..d3412f2c0d18 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1089,21 +1089,18 @@ static void cpu_cache_level__fprintf(FILE *out, struct cpu_cache_level *c)
 	fprintf(out, "L%d %-15s %8s [%s]\n", c->level, c->type, c->size, c->map);
 }
 
-static int build_caches(struct cpu_cache_level caches[], u32 size, u32 *cntp)
+#define MAX_CACHE_LVL 4
+
+static int build_caches(struct cpu_cache_level caches[], u32 *cntp)
 {
 	u32 i, cnt = 0;
-	long ncpus;
 	u32 nr, cpu;
 	u16 level;
 
-	ncpus = sysconf(_SC_NPROCESSORS_CONF);
-	if (ncpus < 0)
-		return -1;
-
-	nr = (u32)(ncpus & UINT_MAX);
+	nr = cpu__max_cpu();
 
 	for (cpu = 0; cpu < nr; cpu++) {
-		for (level = 0; level < 10; level++) {
+		for (level = 0; level < MAX_CACHE_LVL; level++) {
 			struct cpu_cache_level c;
 			int err;
 
@@ -1123,18 +1120,12 @@ static int build_caches(struct cpu_cache_level caches[], u32 size, u32 *cntp)
 				caches[cnt++] = c;
 			else
 				cpu_cache_level__free(&c);
-
-			if (WARN_ONCE(cnt == size, "way too many cpu caches.."))
-				goto out;
 		}
 	}
- out:
 	*cntp = cnt;
 	return 0;
 }
 
-#define MAX_CACHE_LVL 4
-
 static int write_cache(struct feat_fd *ff,
 		       struct evlist *evlist __maybe_unused)
 {
@@ -1143,7 +1134,7 @@ static int write_cache(struct feat_fd *ff,
 	u32 cnt = 0, i, version = 1;
 	int ret;
 
-	ret = build_caches(caches, max_caches, &cnt);
+	ret = build_caches(caches, &cnt);
 	if (ret)
 		goto out;
 
-- 
2.20.1

