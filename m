Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCFB27CBAA
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732336AbgI2M3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:29:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728970AbgI2LaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:30:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6B2523AF8;
        Tue, 29 Sep 2020 11:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378678;
        bh=FeQYqQsSHPvxwXa7ydySBEf414GHhGDONhhCCY6olSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HwOmnNANi7sq1rURo4pkIYSn1N1inII691oponZUaa7uNBId3/vAQ1j02LdbVJlrQ
         geTwc66+8DSepvKl/WFOhd1GQ116ccOP8JQL+6mhpgyGqcOXmwXmW4g1S23slEmof/
         Rfd1ecBu+f7ntg7iSXFIhLDAR8cvHYYzlokXkDl0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        John Garry <john.garry@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        James Clark <james.clark@arm.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>, linuxarm@huawei.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/245] perf jevents: Fix leak of mapfile memory
Date:   Tue, 29 Sep 2020 12:59:10 +0200
Message-Id: <20200929105951.816051008@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit 3f5777fbaf04c58d940526a22a2e0c813c837936 ]

The memory for global pointer is never freed during normal program
execution, so let's do that in the main function exit as a good
programming practice.

A stray blank line is also removed.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: James Clark <james.clark@arm.com>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: linuxarm@huawei.com
Link: http://lore.kernel.org/lkml/1583406486-154841-2-git-send-email-john.garry@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index c17e594041712..6631970f96832 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -1064,10 +1064,9 @@ static int process_one_file(const char *fpath, const struct stat *sb,
  */
 int main(int argc, char *argv[])
 {
-	int rc;
+	int rc, ret = 0;
 	int maxfds;
 	char ldirname[PATH_MAX];
-
 	const char *arch;
 	const char *output_file;
 	const char *start_dirname;
@@ -1138,7 +1137,8 @@ int main(int argc, char *argv[])
 		/* Make build fail */
 		fclose(eventsfp);
 		free_arch_std_events();
-		return 1;
+		ret = 1;
+		goto out_free_mapfile;
 	} else if (rc) {
 		goto empty_map;
 	}
@@ -1156,14 +1156,17 @@ int main(int argc, char *argv[])
 		/* Make build fail */
 		fclose(eventsfp);
 		free_arch_std_events();
-		return 1;
+		ret = 1;
 	}
 
-	return 0;
+
+	goto out_free_mapfile;
 
 empty_map:
 	fclose(eventsfp);
 	create_empty_mapping(output_file);
 	free_arch_std_events();
-	return 0;
+out_free_mapfile:
+	free(mapfile);
+	return ret;
 }
-- 
2.25.1



