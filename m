Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E216626EBCE
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgIRCHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727898AbgIRCHO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21C70238A1;
        Fri, 18 Sep 2020 02:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394834;
        bh=0VjeOJK4j5SEWqSkyC1NhqnZM/CZJA2MV+hP8yYojdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lq5gOtMXPeNLhoXAL/46TkSoa7+lsTmOiggyggh534PqeF5M8pzgU/yP16mTYlAaz
         9/i6u0u754u3nU6CdvYg3wYOTVpxTAmtndj8f7+9kwmcjRWjkbBKMtwFInnB8RkK0+
         LCH6LYyrBGOPuj1lbROQ/cN6hcDyf5U4awz64wfc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xie XiuQi <xiexiuqi@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hongbo Yao <yaohongbo@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Li Bin <huawei.libin@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 295/330] perf util: Fix memory leak of prefix_if_not_in
Date:   Thu, 17 Sep 2020 22:00:35 -0400
Message-Id: <20200918020110.2063155-295-sashal@kernel.org>
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

From: Xie XiuQi <xiexiuqi@huawei.com>

[ Upstream commit 07e9a6f538cbeecaf5c55b6f2991416f873cdcbd ]

Need to free "str" before return when asprintf() failed to avoid memory
leak.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Hongbo Yao <yaohongbo@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Li Bin <huawei.libin@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/20200521133218.30150-4-liwei391@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 43d1d410854a3..4027906fd3e38 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2788,7 +2788,7 @@ static char *prefix_if_not_in(const char *pre, char *str)
 		return str;
 
 	if (asprintf(&n, "%s,%s", pre, str) < 0)
-		return NULL;
+		n = NULL;
 
 	free(str);
 	return n;
-- 
2.25.1

