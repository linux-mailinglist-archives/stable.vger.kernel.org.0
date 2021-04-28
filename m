Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE9736D62B
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 13:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbhD1LMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 07:12:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239250AbhD1LMV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 07:12:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3A496113D;
        Wed, 28 Apr 2021 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619608296;
        bh=yetJWZI/4SeKAzlNurgrNqGisuj0/ptJ3O0xha7tzzA=;
        h=From:To:Cc:Subject:Date:From;
        b=aCuiD/1vr7GFwsx/Wza5z7l0n+i+RLSiY24yE3ESjFFBajc/FsAwDbQtFZtMr3Bvu
         R8NH3HLPX1VbDrWsURFkkLSnrYxac8g0ZL/fAPmzceZDrbsGbA9geV0ju1cH8dQj49
         KjHKtj32nNQDsq82/zydOZIhpWwkTg+yTNpXN1Cu/4khhK/HsKo1OADPXazq4EI231
         rRAl/A+bh4eTMkFCrTyFmUKpWvR8CBJvMCS52e1B6gDMS+SPTTRL17t9urmVTAWr/C
         hV8tPElwn2F19Ib1OcuQJ91Mk+FaZ85uGZ408ZykLEpay/2etTQ6tJFNJhM8hr+Cvz
         NCvYrDWHD+p4g==
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
Subject: [PATCH AUTOSEL 5.11 1/4] perf data: Fix error return code in perf_data__create_dir()
Date:   Wed, 28 Apr 2021 07:11:30 -0400
Message-Id: <20210428111133.1343210-1-sashal@kernel.org>
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
index f29af4fc3d09..8fca4779ae6a 100644
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

