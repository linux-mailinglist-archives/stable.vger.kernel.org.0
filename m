Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C765112C81C
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732039AbfL2RvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:51:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732036AbfL2RvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:51:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 719C120718;
        Sun, 29 Dec 2019 17:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641868;
        bh=6tmKNxe1Z0TJnllgOhiQFzUf3ZvWsAfo8hOMfW09zGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IfO09VrkdJdGz3rNyVBlF/qZkmUuq0izIoY/iChXM7Zdowr1PGl0zx20MtD5HJU9b
         2B8I/LMoi09VXNtErIP2GfgKL5xvYdvVJs+nk6m9R5aoyuiwnhIUfezKNz2tGl6/3K
         3h7YjrDrF5S8xI+g4tApF1JyRRrZWB6e7jKL7YT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Feilong Lin <linfeilong@huawei.com>,
        Hu Shiyuan <hushiyuan@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Luke Mujica <lukemujica@google.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 246/434] perf jevents: Fix resource leak in process_mapfile() and main()
Date:   Sun, 29 Dec 2019 18:24:59 +0100
Message-Id: <20191229172718.225620020@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

[ Upstream commit 1785fbb73896dbd9d27a406f0d73047df42db710 ]

There are memory leaks and file descriptor resource leaks in
process_mapfile() and main().

Fix this by adding free(), fclose() and free_arch_std_events() on the
error paths.

Fixes: 80eeb67fe577 ("perf jevents: Program to convert JSON file")
Fixes: 3f056b66647b ("perf jevents: Make build fail on JSON parse error")
Fixes: e9d32c1bf0cd ("perf vendor events: Add support for arch standard events")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Hu Shiyuan <hushiyuan@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: John Garry <john.garry@huawei.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Luke Mujica <lukemujica@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Link: http://lore.kernel.org/lkml/d7907042-ec9c-2bef-25b4-810e14602f89@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index e2837260ca4d..99e3fd04a5cb 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -758,6 +758,7 @@ static int process_mapfile(FILE *outfp, char *fpath)
 	char *line, *p;
 	int line_num;
 	char *tblname;
+	int ret = 0;
 
 	pr_info("%s: Processing mapfile %s\n", prog, fpath);
 
@@ -769,6 +770,7 @@ static int process_mapfile(FILE *outfp, char *fpath)
 	if (!mapfp) {
 		pr_info("%s: Error %s opening %s\n", prog, strerror(errno),
 				fpath);
+		free(line);
 		return -1;
 	}
 
@@ -795,7 +797,8 @@ static int process_mapfile(FILE *outfp, char *fpath)
 			/* TODO Deal with lines longer than 16K */
 			pr_info("%s: Mapfile %s: line %d too long, aborting\n",
 					prog, fpath, line_num);
-			return -1;
+			ret = -1;
+			goto out;
 		}
 		line[strlen(line)-1] = '\0';
 
@@ -825,7 +828,9 @@ static int process_mapfile(FILE *outfp, char *fpath)
 
 out:
 	print_mapping_table_suffix(outfp);
-	return 0;
+	fclose(mapfp);
+	free(line);
+	return ret;
 }
 
 /*
@@ -1122,6 +1127,7 @@ int main(int argc, char *argv[])
 		goto empty_map;
 	} else if (rc < 0) {
 		/* Make build fail */
+		fclose(eventsfp);
 		free_arch_std_events();
 		return 1;
 	} else if (rc) {
@@ -1134,6 +1140,7 @@ int main(int argc, char *argv[])
 		goto empty_map;
 	} else if (rc < 0) {
 		/* Make build fail */
+		fclose(eventsfp);
 		free_arch_std_events();
 		return 1;
 	} else if (rc) {
@@ -1151,6 +1158,8 @@ int main(int argc, char *argv[])
 	if (process_mapfile(eventsfp, mapfile)) {
 		pr_info("%s: Error processing mapfile %s\n", prog, mapfile);
 		/* Make build fail */
+		fclose(eventsfp);
+		free_arch_std_events();
 		return 1;
 	}
 
-- 
2.20.1



