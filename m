Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BAE373A90
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232954AbhEEML3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233643AbhEEMKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF3E2613E9;
        Wed,  5 May 2021 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216550;
        bh=yetJWZI/4SeKAzlNurgrNqGisuj0/ptJ3O0xha7tzzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TIQotM2OVecQIV94y1jSfgzLLeuMFBm7l0NUJ9J/6GcgrRxduBOXKmWPM2+MF8xj1
         ZmsB5543ZfsS1of/c7jVvJgqoiOSOLcN9kRo6mgG/2W0udHvZ424pD+8O92L41jiqr
         avhYcFw9ruta/hMWXV5b7ZBwHJImr2UIjgAM7Tn8=
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
Subject: [PATCH 5.11 09/31] perf data: Fix error return code in perf_data__create_dir()
Date:   Wed,  5 May 2021 14:05:58 +0200
Message-Id: <20210505112326.975755673@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112326.672439569@linuxfoundation.org>
References: <20210505112326.672439569@linuxfoundation.org>
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



