Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A126A36AE54
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhDZHnk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233490AbhDZHlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:41:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C294E61369;
        Mon, 26 Apr 2021 07:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422759;
        bh=KVuSzgEWL8yOaClH1gfHCtSceNgJivoQJwjpO7bOolE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICO8mrDzhTDuznEuT2WukxnuTewscXwj1c1oTtzI5H/hhrgtTVR8pSeJxigv7yIcX
         SM/nr2iDCTo5/0LEWbW68NA336D6Q6eDtoOZxM/WNd0EDlwDKKG2zPjeHIlHueCMv1
         0LzT6+BSydTA4OJU+Fp5CdDa45pbnaxCKJtqx/mk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/36] perf map: Fix error return code in maps__clone()
Date:   Mon, 26 Apr 2021 09:29:59 +0200
Message-Id: <20210426072819.370357445@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072818.777662399@linuxfoundation.org>
References: <20210426072818.777662399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit c6f87141254d16e281e4b4431af7316895207b8f ]

Although 'err' has been initialized to -ENOMEM, but it will be reassigned
by the "err = unwind__prepare_access(...)" statement in the for loop. So
that, the value of 'err' is unknown when map__clone() failed.

Fixes: 6c502584438bda63 ("perf unwind: Call unwind__prepare_access for forked thread")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: zhen lei <thunder.leizhen@huawei.com>
Link: http://lore.kernel.org/lkml/20210415092744.3793-1-thunder.leizhen@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/map.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index e2537d5acab0..f4d44f75ba15 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -836,15 +836,18 @@ out:
 int maps__clone(struct thread *thread, struct maps *parent)
 {
 	struct maps *maps = thread->maps;
-	int err = -ENOMEM;
+	int err;
 	struct map *map;
 
 	down_read(&parent->lock);
 
 	maps__for_each_entry(parent, map) {
 		struct map *new = map__clone(map);
-		if (new == NULL)
+
+		if (new == NULL) {
+			err = -ENOMEM;
 			goto out_unlock;
+		}
 
 		err = unwind__prepare_access(maps, new, NULL);
 		if (err)
-- 
2.30.2



