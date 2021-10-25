Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6D043A314
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236800AbhJYT4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239001AbhJYTx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1C1A6115C;
        Mon, 25 Oct 2021 19:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191099;
        bh=Nd41AlNRRDX+vpmy08L5K1D8lYLZRjspNAArwUd00nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2wQKpnlqNfWEw406z1BCTPQUU6mNoZlL5s6gC4zhSRPSaP/dZlfJdPOCYhR+3jen
         4prpTjqmvhaJWCvXVM7Gh6uRXiJCv3b6SFV2O0xpWx2LFw2ckYHSYyvenWv/SUVTpS
         7L3Y85oAr14wupDOp6/o7ZEOJX0GV6mcNxkGkNaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shunsuke Nakamura <nakamura.shun@fujitsu.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 144/169] libperf test evsel: Fix build error on !x86 architectures
Date:   Mon, 25 Oct 2021 21:15:25 +0200
Message-Id: <20211025191035.818355041@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



