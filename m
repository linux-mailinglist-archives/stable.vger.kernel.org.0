Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D40563D5E62
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236139AbhGZPHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236297AbhGZPGs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A00B96056C;
        Mon, 26 Jul 2021 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314437;
        bh=W1ixCt+AL8Md78XjnKvuhunJ0SCcOaNB90ZQVrWE08k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hkyvEsKLQ9qPJUAYt+tQfK7m0tCj88aR6GcCWb9UX9ATRMXGLXBBKjq3a3TCEo35z
         2CeDceOM+L8OOdn/SHPdax3gtcA/qL4OeIRfFBcOOknfAOBIyDXxbZGFpqglTl75Tc
         XL3mv8bxg0/Omc0aWeUR3K0cxNHP331gA0gibyVY=
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
Subject: [PATCH 4.14 46/82] perf test bpf: Free obj_buf
Date:   Mon, 26 Jul 2021 17:38:46 +0200
Message-Id: <20210726153829.669282878@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index 34c22cdf4d5d..3fc7fd779c27 100644
--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -1,5 +1,6 @@
 #include <errno.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <sys/epoll.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -275,6 +276,7 @@ static int __test__bpf(int idx)
 	}
 
 out:
+	free(obj_buf);
 	bpf__clear();
 	return ret;
 }
-- 
2.30.2



