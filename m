Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEA668F90
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388820AbfGOOPS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:15:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389190AbfGOOPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:15:17 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D73F020651;
        Mon, 15 Jul 2019 14:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200116;
        bh=2T8+ByuMN2NdbOvNMHdiLKBNNI5BJwAvDd5WZM9gBQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jh5tI6eE++muHLvQMc8KspwHvqHamFW6om4G/Z0Vd+pJsjdsq0tUD6gZJ+IRtTsH3
         asknu6+aV3mc12lh1Vq8vQztaZVCYCU4VOjUzkkPSQlqxVLJ1UhgizNGFkEld/YrTc
         IROmLPHaQIbzJ0l2yqOgqGUYvGAv2qFK2wKPiNLw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 188/219] perf stat: Make metric event lookup more robust
Date:   Mon, 15 Jul 2019 10:03:09 -0400
Message-Id: <20190715140341.6443-188-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[ Upstream commit 145c407c808352acd625be793396fd4f33c794f8 ]

After setting up metric groups through the event parser, the metricgroup
code looks them up again in the event list.

Make sure we only look up events that haven't been used by some other
metric. The data structures currently cannot handle more than one metric
per event. This avoids problems with multiple events partially
overlapping.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Link: http://lkml.kernel.org/r/20190624193711.35241-2-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/stat-shadow.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/stat-shadow.c b/tools/perf/util/stat-shadow.c
index 83d8094be4fe..e545e2a8ae71 100644
--- a/tools/perf/util/stat-shadow.c
+++ b/tools/perf/util/stat-shadow.c
@@ -303,7 +303,7 @@ static struct perf_evsel *perf_stat__find_event(struct perf_evlist *evsel_list,
 	struct perf_evsel *c2;
 
 	evlist__for_each_entry (evsel_list, c2) {
-		if (!strcasecmp(c2->name, name))
+		if (!strcasecmp(c2->name, name) && !c2->collect_stat)
 			return c2;
 	}
 	return NULL;
@@ -342,7 +342,8 @@ void perf_stat__collect_metric_expr(struct perf_evlist *evsel_list)
 			if (leader) {
 				/* Search in group */
 				for_each_group_member (oc, leader) {
-					if (!strcasecmp(oc->name, metric_names[i])) {
+					if (!strcasecmp(oc->name, metric_names[i]) &&
+						!oc->collect_stat) {
 						found = true;
 						break;
 					}
-- 
2.20.1

