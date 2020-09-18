Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC0C26F008
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728636AbgIRCkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:40:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbgIRCLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:11:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30BB1238E6;
        Fri, 18 Sep 2020 02:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600395105;
        bh=hmulrnIkEYI8JDSnMLlamNVyn1HLJuvqeL0H9PVOlVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GKau1jnNv7dyitQK7++vEizED1s3vNSxH8NXi/0BZs9rJXkewRRW7Y0Zlz1asVraK
         lA6sf6I/AIMoXpxqq6ULF9m3uj5eiRHTshr1vBPbRx7QyY3GJYmCuPqxSHZnB2uqrn
         DKGmIzf4vEfG6ja59NdQBKZ3pU3l+Fps+i6+D8jg=
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
Subject: [PATCH AUTOSEL 4.19 182/206] perf util: Fix memory leak of prefix_if_not_in
Date:   Thu, 17 Sep 2020 22:07:38 -0400
Message-Id: <20200918020802.2065198-182-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020802.2065198-1-sashal@kernel.org>
References: <20200918020802.2065198-1-sashal@kernel.org>
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
index 46daa22b86e3b..85ff4f68adc00 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2690,7 +2690,7 @@ static char *prefix_if_not_in(const char *pre, char *str)
 		return str;
 
 	if (asprintf(&n, "%s,%s", pre, str) < 0)
-		return NULL;
+		n = NULL;
 
 	free(str);
 	return n;
-- 
2.25.1

