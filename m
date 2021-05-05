Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB45D373A4E
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhEEMJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:09:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233520AbhEEMIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:08:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 747C9613BC;
        Wed,  5 May 2021 12:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216462;
        bh=xlnvhdu5Oni/7aSVgRMSR2mdTkG5kMknDXPHQUPUELI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xRLRSk+lmyKFGV/5n5wcbk2tZ3XdF+KXOaf6zo6XxElqbYbf8P36h8DAuRZk1SPgt
         TLq9sA8LhURmsLqdOYynIooeGcWQtgW6GirUPWB0Dm8j6DzVsVV9C0vVjYrZBHL5sm
         kWQhDuN2J0xjF2lZ6Je7tVcexxJkXMRRWO43KR2U=
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
Subject: [PATCH 5.10 08/29] perf data: Fix error return code in perf_data__create_dir()
Date:   Wed,  5 May 2021 14:05:11 +0200
Message-Id: <20210505112326.470107974@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.195493232@linuxfoundation.org>
References: <20210505112326.195493232@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c47aa34fdc0a..5d97b3e45fbb 100644
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



