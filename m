Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1151261CD5
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732168AbgIHT1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731053AbgIHQAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:00:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CC3E2246B;
        Tue,  8 Sep 2020 15:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579374;
        bh=nqdOK5tmPXopAoNXH3rhjLp87objfUIf7GMKu45EsoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AulzTUZHe3FigxWkVmsq7E/t+8VeFyg4Zsc1t8Uzsqlr808YwpqVFszRpHIf16Eyt
         iBqqmwNg/XQH79oc6Xo+2NYJsMCISaV0GZh1UROd43+ZSgFNWprcbQ+LDZh8Yegrp8
         /+YyflYRmQggpUPDYJP0cz6zglkI+bSO0yeTzVhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 052/186] perf sched timehist: Fix use of CPU list with summary option
Date:   Tue,  8 Sep 2020 17:23:14 +0200
Message-Id: <20200908152244.195188556@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

[ Upstream commit a74eaf1605d42391c2357a70e94e5a2c7780fea9 ]

Do not update thread stats or show idle summary unless CPU is in the
list of interest.

Fixes: c30d630d1bcfad8d ("perf sched timehist: Add support for filtering on CPU")
Signed-off-by: David Ahern <dsahern@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Link: http://lore.kernel.org/lkml/20200817170943.1486-1-dsahern@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 459e4229945e4..7b9511e59b434 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -2575,7 +2575,8 @@ static int timehist_sched_change_event(struct perf_tool *tool,
 	}
 
 	if (!sched->idle_hist || thread->tid == 0) {
-		timehist_update_runtime_stats(tr, t, tprev);
+		if (!cpu_list || test_bit(sample->cpu, cpu_bitmap))
+			timehist_update_runtime_stats(tr, t, tprev);
 
 		if (sched->idle_hist) {
 			struct idle_thread_runtime *itr = (void *)tr;
@@ -2848,6 +2849,9 @@ static void timehist_print_summary(struct perf_sched *sched,
 
 	printf("\nIdle stats:\n");
 	for (i = 0; i < idle_max_cpu; ++i) {
+		if (cpu_list && !test_bit(i, cpu_bitmap))
+			continue;
+
 		t = idle_threads[i];
 		if (!t)
 			continue;
-- 
2.25.1



