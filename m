Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837862063C1
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393174AbgFWVK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389684AbgFWUdY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:33:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B00FA206C3;
        Tue, 23 Jun 2020 20:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944404;
        bh=4Xicm35odI0DIe2upMQXW0PefIjA4OgLuPkTJlGjGRo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=moHj+cRb8A/C3sAcGYA6Mgqa9U1i4alefucsWkM85PGSeaPiyOvkzP+hYVz3/dG1d
         WYNSMes1r8LGqJaEb08+EZrNrlOreCSjiwxm+jiYh/ERSNmYVAkfDUfd2OnS9Lu7WY
         II4hRv5F5RsNLZ+BAIxyfgwRTxZvx2F4hu+etljE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hongbo Yao <yaohongbo@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Wei Li <liwei391@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/314] perf stat: Fix NULL pointer dereference
Date:   Tue, 23 Jun 2020 21:57:39 +0200
Message-Id: <20200623195351.567147685@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongbo Yao <yaohongbo@huawei.com>

[ Upstream commit c0c652fc705de75f4ba52e93053acc1ed3933e74 ]

If config->aggr_map is NULL and config->aggr_get_id is not NULL,
the function print_aggr() will still calling arrg_update_shadow(),
which can result in accessing the invalid pointer.

Fixes: 088519f318be ("perf stat: Move the display functions to stat-display.c")
Signed-off-by: Hongbo Yao <yaohongbo@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wei Li <liwei391@huawei.com>
Link: https://lore.kernel.org/lkml/20200608163625.GC3073@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/stat-display.c b/tools/perf/util/stat-display.c
index ed3b0ac2f7850..373e399e57d28 100644
--- a/tools/perf/util/stat-display.c
+++ b/tools/perf/util/stat-display.c
@@ -661,7 +661,7 @@ static void print_aggr(struct perf_stat_config *config,
 	int s;
 	bool first;
 
-	if (!(config->aggr_map || config->aggr_get_id))
+	if (!config->aggr_map || !config->aggr_get_id)
 		return;
 
 	aggr_update_shadow(config, evlist);
@@ -1140,7 +1140,7 @@ static void print_percore(struct perf_stat_config *config,
 	int s;
 	bool first = true;
 
-	if (!(config->aggr_map || config->aggr_get_id))
+	if (!config->aggr_map || !config->aggr_get_id)
 		return;
 
 	for (s = 0; s < config->aggr_map->nr; s++) {
-- 
2.25.1



