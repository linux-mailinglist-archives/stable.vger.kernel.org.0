Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2093D2904
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233691AbhGVQA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231411AbhGVQAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:00:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 688C861369;
        Thu, 22 Jul 2021 16:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972035;
        bh=OPmfSImN3GeoofV9ku3PvjGrjb8tYoUbuQozntxuDNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWEzff5Hxq16AaHgk+CxzaP3Ppwg0yqR4zsJvOmDU+2M3GGfcZfqM9KmiiS8BVJsP
         FELrV2ScFlLv2xVz2vXN2sdEp1h+UZNGDzzuJG+be8gz1/gaHROOys1kgOQzQqE34o
         CVyFyZ2F0nVRSdEHhCfE8YXrM5JP6uy3tV4PazUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wang Nan <wangnan0@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 123/125] perf test bpf: Free obj_buf
Date:   Thu, 22 Jul 2021 18:31:54 +0200
Message-Id: <20210722155628.796007172@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155624.672583740@linuxfoundation.org>
References: <20210722155624.672583740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

commit 937654ce497fb6e977a8c52baee5f7d9616302d9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/tests/bpf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/tests/bpf.c
+++ b/tools/perf/tests/bpf.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <errno.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <sys/epoll.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -283,6 +284,7 @@ static int __test__bpf(int idx)
 	}
 
 out:
+	free(obj_buf);
 	bpf__clear();
 	return ret;
 }


