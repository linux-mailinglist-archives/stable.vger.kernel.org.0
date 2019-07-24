Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF4A73A9A
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403900AbfGXTwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404060AbfGXTv7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:51:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1361E214AF;
        Wed, 24 Jul 2019 19:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997918;
        bh=OeIkqK8Y0XklASlo+vRxyTqQThrrZsRCUX3HADXzfXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PGxJzui+XC2BDK5PEQeBKRVKtHbxmmeEdyqkYvssn9V8K1YjDMTVnU1EomOSzbmWl
         RzIogLGTqg0PokduVwNkCUptCuP/rwfZwO9klnRtjOXn8DjOvqOgit3M/2oBrhCZDX
         XMmvjc2ktle7IeRK3TZ10x6QVDWNAv8UvGYmRLJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 188/371] perf stat: Make metric event lookup more robust
Date:   Wed, 24 Jul 2019 21:19:00 +0200
Message-Id: <20190724191739.165855459@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



