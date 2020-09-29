Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E89427C412
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgI2LLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:11:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728899AbgI2LKo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:10:44 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6693221E7;
        Tue, 29 Sep 2020 11:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377843;
        bh=z9P05llSOK1BE4OuzBrnxM1RTArEo67X2fzkWvR9Lew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQME6x8LdfrCBgSZH0TlEME5Jv9/fUcJ75vOYCdWVo9ywCHG+eYyvmdXS4K8Fk2ni
         kjzjHB5Xifgwg05GqVoCIdsKQGOaQus25RZJ00xDRkSExoxmSHIUsEEetZm/39nGIf
         wlY+VKDxjvJzxQ5uxK5315j7FKc1782lPLa5AEIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie XiuQi <xiexiuqi@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Hongbo Yao <yaohongbo@huawei.com>,
        Jiri Olsa <jolsa@redhat.com>, Li Bin <huawei.libin@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/121] perf util: Fix memory leak of prefix_if_not_in
Date:   Tue, 29 Sep 2020 13:00:37 +0200
Message-Id: <20200929105934.794999178@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 031e64ce71564..013e3f5102258 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2532,7 +2532,7 @@ static char *prefix_if_not_in(const char *pre, char *str)
 		return str;
 
 	if (asprintf(&n, "%s,%s", pre, str) < 0)
-		return NULL;
+		n = NULL;
 
 	free(str);
 	return n;
-- 
2.25.1



