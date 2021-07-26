Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4833D5D4F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhGZPAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:00:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235328AbhGZPAj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:00:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE4160E08;
        Mon, 26 Jul 2021 15:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314068;
        bh=hVZcNl34ihG6qSxD7uSj62o5JGOb1rUEyfG/az/Np60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X0lIn0IK3dgOOLISRbiPFjAuMWgJCRiq2+9vqAFwJdy1rfg4oET7QkPGQiQQuVdLH
         NT81ij6MjSf926TRakRc0Yk/52V2MholT3Igjei8ENml/hv7WBCOBSjktib5NHx6ZT
         OInTAeqEEoUCXS07KBA36Bu5O7qpniiVV/y2CfEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 21/47] perf test bpf: Free obj_buf
Date:   Mon, 26 Jul 2021 17:38:39 +0200
Message-Id: <20210726153823.647791438@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153822.980271128@linuxfoundation.org>
References: <20210726153822.980271128@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit 937654ce497fb6e977a8c52baee5f7d9616302d9 ]

ASan reports some memory leaks when running:

  # perf test "42: BPF filter"

The first of these leaks is caused by obj_buf never being deallocated in
__test__bpf.

This patch adds the missing free.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: ba1fae431e74bb42 ("perf test: Add 'perf test BPF'")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: http://lore.kernel.org/lkml/60f3ca935fe6672e7e866276ce6264c9e26e4c87.1626343282.git.rickyman7@gmail.com
[ Added missing stdlib.h include ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/bpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/tests/bpf.c b/tools/perf/tests/bpf.c
index 6ebfdee3e2c6..661cca25ae5d 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <stdlib.h>
 #include <sys/epoll.h>
 #include <util/bpf-loader.h>
 #include <util/evlist.h>
@@ -176,6 +177,7 @@ static int __test__bpf(int idx)
 		      bpf_testcase_table[idx].target_func,
 		      bpf_testcase_table[idx].expect_result);
 out:
+	free(obj_buf);
 	bpf__clear();
 	return ret;
 }
-- 
2.30.2



