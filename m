Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65087420F34
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237659AbhJDNcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237735AbhJDNaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:30:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1315361B3E;
        Mon,  4 Oct 2021 13:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353220;
        bh=a4zoJc5uapeK376WmBaJPS7Dvv8GZptPeFqhDydmTFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmHhHmDr6ouJIQq4pG2gOi5Lbdpl94PVLcYdH2BGF0UqIoooBSP9TE8ief8s6V6D5
         0OuHrAsWe4cyjpvo1UmD0+Vjm9d0TCFwIiRowDCvVTYe0ePitGbhYrI9YjHUhNuTmW
         Sjm1IKt/80/Kaz0ZJB7kNhqbbZOJ+dcGSz0qa80o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 025/172] perf iostat: Fix Segmentation fault from NULL struct perf_counts_values *
Date:   Mon,  4 Oct 2021 14:51:15 +0200
Message-Id: <20211004125045.781798191@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

[ Upstream commit 4da8b121884d84476f3d50d46a471471af1aa9df ]

If the 'perf iostat' user specifies two or more iio_root_ports and also
specifies the cpu(s) by -C which is not *connected to all* the above iio
ports, the iostat_print_metric() will run into trouble:

For example:

  $ perf iostat list
  S0-uncore_iio_0<0000:16>
  S1-uncore_iio_0<0000:97> # <--- CPU 1 is located in the socket S0

  $ perf iostat 0000:16,0000:97 -C 1 -- ls
  port 	Inbound Read(MB)	Inbound Write(MB)	Outbound Read(MB)	Outbound
  Write(MB) ../perf-iostat: line 12: 104418 Segmentation fault
  (core dumped) perf stat --iostat$DELIMITER$*

The core-dump stack says, in the above corner case, the returned
(struct perf_counts_values *) count will be NULL, and the caller
iostat_print_metric() apparently doesn't not handle this case.

  433	struct perf_counts_values *count = perf_counts(evsel->counts, die, 0);
  434
  435	if (count->run && count->ena) {
  (gdb) p count
  $1 = (struct perf_counts_values *) 0x0

The deeper reason is that there are actually no statistics from the user
specified pair "iostat 0000:X, -C (disconnected) Y ", but let's fix it with
minimum cost by adding a NULL check in the user space.

Fixes: f9ed693e8bc0e7de ("perf stat: Enable iostat mode for x86 platforms")
Signed-off-by: Like Xu <likexu@tencent.com>
Cc: Alexander Antonov <alexander.antonov@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20210927081115.39568-2-likexu@tencent.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/x86/util/iostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/iostat.c b/tools/perf/arch/x86/util/iostat.c
index eeafe97b8105..792cd75ade33 100644
--- a/tools/perf/arch/x86/util/iostat.c
+++ b/tools/perf/arch/x86/util/iostat.c
@@ -432,7 +432,7 @@ void iostat_print_metric(struct perf_stat_config *config, struct evsel *evsel,
 	u8 die = ((struct iio_root_port *)evsel->priv)->die;
 	struct perf_counts_values *count = perf_counts(evsel->counts, die, 0);
 
-	if (count->run && count->ena) {
+	if (count && count->run && count->ena) {
 		if (evsel->prev_raw_counts && !out->force_header) {
 			struct perf_counts_values *prev_count =
 				perf_counts(evsel->prev_raw_counts, die, 0);
-- 
2.33.0



