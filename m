Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F31136D637
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 13:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhD1LMn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 07:12:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239671AbhD1LMi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 07:12:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12ACA61434;
        Wed, 28 Apr 2021 11:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619608313;
        bh=MRevBN2xh5xxjB2iqX4P6X5KJEVH66ROP2JYUgDKy6Y=;
        h=From:To:Cc:Subject:Date:From;
        b=l5YGHcv54cOtUj703nMw26qRsllbdMEx4AR0CyBPsDsisP8XRnrUEWI8oYPOaW/+9
         hhIHQPYrG+B9MBlzu8Dt+FMMgKNAs5kHy9BN5j5Bky5fo9etgRsBN53ml+wCJHAhYL
         V0JLYcwCWabBvgSVe5dGgAmOc8g6v8/LF/P7BnK3+GyQ+fZccdd6Ifx0JmxPpW4ObF
         cR/gVNOeYltc0adlpGveIduRX0L7TO0d/9KWXQdmTioE62gpi1yRkIaj9KQzavXYcj
         svix5q3YC4aMnhuFFt1v5GhMiG7HGxFjalfayKswNeybhujbar4Yf5Kps4RGWw0D+m
         LESBCo0ldFxxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 1/2] perf data: Fix error return code in perf_data__create_dir()
Date:   Wed, 28 Apr 2021 07:11:49 -0400
Message-Id: <20210428111150.1343388-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit f2211881e737cade55e0ee07cf6a26d91a35a6fe ]

Although 'ret' has been initialized to -1, but it will be reassigned by
the "ret = open(...)" statement in the for loop. So that, the value of
'ret' is unknown when asprintf() failed.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210415083417.3740-1-thunder.leizhen@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 88fba2ba549f..7534455ffc6a 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -35,7 +35,7 @@ void perf_data__close_dir(struct perf_data *data)
 int perf_data__create_dir(struct perf_data *data, int nr)
 {
 	struct perf_data_file *files = NULL;
-	int i, ret = -1;
+	int i, ret;
 
 	if (WARN_ON(!data->is_dir))
 		return -EINVAL;
@@ -51,7 +51,8 @@ int perf_data__create_dir(struct perf_data *data, int nr)
 	for (i = 0; i < nr; i++) {
 		struct perf_data_file *file = &files[i];
 
-		if (asprintf(&file->path, "%s/data.%d", data->path, i) < 0)
+		ret = asprintf(&file->path, "%s/data.%d", data->path, i);
+		if (ret < 0)
 			goto out_err;
 
 		ret = open(file->path, O_RDWR|O_CREAT|O_TRUNC, S_IRUSR|S_IWUSR);
-- 
2.30.2

