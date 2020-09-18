Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF6B26F34B
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgIRDFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 23:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgIRCEV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:04:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 054652311D;
        Fri, 18 Sep 2020 02:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394661;
        bh=0bEKGFe7oIvtAHae9iu607OloDUiTjaguDn3Gph6ZMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6p3bz5GdPrM7QcqIxPNRqkRNX5D45FjJ7E35ZCD1ZDsqCr1Gqos/ijs89ZLiYLok
         fep7T+AdP7gb/jnr8CgHPaF2v92b7XkcGtpEaRCBWclZbtTZ6vQEuEfRQFcF1dP0Ki
         FrZwsFPYkGhQFv0sACvnsAgeKo2eT0CFP51mTkuU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     John Garry <john.garry@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
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
Subject: [PATCH AUTOSEL 5.4 156/330] perf jevents: Fix leak of mapfile memory
Date:   Thu, 17 Sep 2020 21:58:16 -0400
Message-Id: <20200918020110.2063155-156-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index d36ae65ae3330..f4a0d72246cb7 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -1068,10 +1068,9 @@ static int process_one_file(const char *fpath, const struct stat *sb,
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
@@ -1142,7 +1141,8 @@ int main(int argc, char *argv[])
 		/* Make build fail */
 		fclose(eventsfp);
 		free_arch_std_events();
-		return 1;
+		ret = 1;
+		goto out_free_mapfile;
 	} else if (rc) {
 		goto empty_map;
 	}
@@ -1160,14 +1160,17 @@ int main(int argc, char *argv[])
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

