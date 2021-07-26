Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D563D6173
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhGZPbz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237900AbhGZP32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E34960F9C;
        Mon, 26 Jul 2021 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315784;
        bh=L7JTVkEdQIYlNs6VVT99tMf5FeimLX1yzbm9MRlaZI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=odRvICjogZ7H0Aw/HW3If5iMWMq1Dw0LPsc4f2tar/d2+TKgioj7z3W6EqsHvfqoI
         3vXHLfARQYKt48RP57CAdC4b7GYJddYbdnfM9lZ36rZgVmZ7xC/ict2p4XN04z0pvC
         DtuJPEMU+5tSpsSJ0ebBW4S4iNWVZpqrR1BgWwWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 064/223] perf data: Close all files in close_dir()
Date:   Mon, 26 Jul 2021 17:37:36 +0200
Message-Id: <20210726153848.356257789@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit d4b3eedce151e63932ce4a00f1d0baa340a8b907 ]

When using 'perf report' in directory mode, the first file is not closed
on exit, causing a memory leak.

The problem is caused by the iterating variable never reaching 0.

Fixes: 145520631130bd64 ("perf data: Add perf_data__(create_dir|close_dir) functions")
Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Link: http://lore.kernel.org/lkml/20210716141122.858082-1-rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 8fca4779ae6a..70b91ce35178 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -20,7 +20,7 @@
 
 static void close_dir(struct perf_data_file *files, int nr)
 {
-	while (--nr >= 1) {
+	while (--nr >= 0) {
 		close(files[nr].fd);
 		zfree(&files[nr].path);
 	}
-- 
2.30.2



