Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC89435710
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 02:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbhJUAYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 20:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231660AbhJUAXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 20:23:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 095AE611CC;
        Thu, 21 Oct 2021 00:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634775700;
        bh=Nd41AlNRRDX+vpmy08L5K1D8lYLZRjspNAArwUd00nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHAHyl0Eh6HaeiuvA8k6QFW3ZasPVDb6dxbnkjURTV92nVD3bLjzwjs0q5NcZ3ZkW
         D3HYoeu2Hdjpitb25je7QMmfrCsGgfPi6jS4tXRtuEr8qGHtNaip3jyd7bZXqG6uS/
         Fm+1xhimt4SsLA843WeEoDeTtdrOyfqPgc29Wmw3vJnONVimhxnuV0CLoJRGEAd2wo
         8FLnGOwGBl6wkWD4n2G3C5nY12vvmlRhYlIXwkGBFoNmAuMtkv9B5RX1Alf0B0rIAL
         GQ8drrIpyXB6aojrYAdHdm938G8n1yIkQ8AE28E1SpRWrInUEG8clsIrbd5k6Gp7rd
         XppgXdLQOoGpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shunsuke Nakamura <nakamura.shun@fujitsu.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, acme@kernel.org,
        irogers@google.com, robh@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 22/26] libperf test evsel: Fix build error on !x86 architectures
Date:   Wed, 20 Oct 2021 20:20:19 -0400
Message-Id: <20211021002023.1128949-22-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211021002023.1128949-1-sashal@kernel.org>
References: <20211021002023.1128949-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shunsuke Nakamura <nakamura.shun@fujitsu.com>

[ Upstream commit f304c8d949f9adc2ef51304b63e49d5ea1c2d288 ]

In test_stat_user_read, following build error occurs except i386 and
x86_64 architectures:

tests/test-evsel.c:129:31: error: variable 'pc' set but not used [-Werror=unused-but-set-variable]
  struct perf_event_mmap_page *pc;

Fix build error.

Signed-off-by: Shunsuke Nakamura <nakamura.shun@fujitsu.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20211006095703.477826-1-nakamura.shun@fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/tests/test-evsel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/perf/tests/test-evsel.c b/tools/lib/perf/tests/test-evsel.c
index a184e4861627..9abd4c0bf6db 100644
--- a/tools/lib/perf/tests/test-evsel.c
+++ b/tools/lib/perf/tests/test-evsel.c
@@ -148,6 +148,7 @@ static int test_stat_user_read(int event)
 	__T("failed to mmap evsel", err == 0);
 
 	pc = perf_evsel__mmap_base(evsel, 0, 0);
+	__T("failed to get mmapped address", pc);
 
 #if defined(__i386__) || defined(__x86_64__)
 	__T("userspace counter access not supported", pc->cap_user_rdpmc);
-- 
2.33.0

