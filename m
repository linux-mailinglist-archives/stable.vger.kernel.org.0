Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1531D2E3C68
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436871AbgL1OCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436864AbgL1OC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8427B2063A;
        Mon, 28 Dec 2020 14:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164133;
        bh=LWlCUf+9Df1l7rhGlqZvJjun2Bx0SfnfJ9nh7LUzpuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C+s84KabQg7eHNJK7jGd02Nmy6hCAmXfAY0v8J+JWTLwOMlcm0qAa/L0378Xav40p
         3Q1UrU+nvZNV2ioR0sXpISDU9zCxbHBg+2zCRzpgoVxz++uFlSKhIzgkLghy0/WxBK
         KqC7KgQV/g/NWexLpcb7dJfsQK/Sby+LOu2WyGug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/717] perf test: Use generic event for expand_libpfm_events()
Date:   Mon, 28 Dec 2020 13:40:43 +0100
Message-Id: <20201228125023.146839946@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 9b0a7836359443227c9af101f7aea8412e739458 ]

I found that the UNHALTED_CORE_CYCLES event is only available in the
Intel machines and it makes other vendors/archs fail on the test.  As
libpfm4 can parse the generic events like cycles, let's use them.

Fixes: 40b74c30ffb9 ("perf test: Add expand cgroup event test")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20201027072855.655449-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/expand-cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/expand-cgroup.c b/tools/perf/tests/expand-cgroup.c
index d5771e4d094f8..4c59f3ae438fc 100644
--- a/tools/perf/tests/expand-cgroup.c
+++ b/tools/perf/tests/expand-cgroup.c
@@ -145,7 +145,7 @@ static int expand_libpfm_events(void)
 	int ret;
 	struct evlist *evlist;
 	struct rblist metric_events;
-	const char event_str[] = "UNHALTED_CORE_CYCLES";
+	const char event_str[] = "CYCLES";
 	struct option opt = {
 		.value = &evlist,
 	};
-- 
2.27.0



