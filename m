Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57F227C7D5
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730779AbgI2Lni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730480AbgI2LnG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:43:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E5ED20702;
        Tue, 29 Sep 2020 11:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379784;
        bh=0VjeOJK4j5SEWqSkyC1NhqnZM/CZJA2MV+hP8yYojdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEByX0KfpGl9LVrA4/5i9neB4TJWrc2lCQ7CqXuNCS97nlWNl7iPa48FuNL5cai1j
         2q0C9zHq0Siof+yvKQJVGYq8swsyPG+zvcdvLpcMDHQNsqjmUU91ANpe/uJXX1SMSn
         C9mbEbVGG8nUB0Dy93Oz0gXDtEvwQmH90aGDaGy8=
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
Subject: [PATCH 5.4 286/388] perf util: Fix memory leak of prefix_if_not_in
Date:   Tue, 29 Sep 2020 13:00:17 +0200
Message-Id: <20200929110024.301774923@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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



