Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A7B3D6037
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhGZPVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:35406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237162AbhGZPVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2CE461006;
        Mon, 26 Jul 2021 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315307;
        bh=jn2mMWfY5G40uT7+YOHI/miXvPHU74a6Qr5XFzZvixo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy62XCc1DYpyEV0olwUVUm+y2WWbQ+CIWbLVFztZCId9nf/cwsbh1Cg9PMGcazmMO
         +J0KO5bLUgD3U8RX/uEG97DFKX6pcTUatKPGJryL+wrp/wGcA6UTUzs0MYQxiU+pn+
         dyN5Dc0FHgMkmXU/TonZnSpdJSd8QLvc3c+V8tUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/167] perf data: Close all files in close_dir()
Date:   Mon, 26 Jul 2021 17:37:59 +0200
Message-Id: <20210726153840.934763669@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit d4b3eedce151e63932ce4a00f1d0baa340a8b907 ]

When using 'perf report' in directory mode, the first file is not closed
on exit, causing a memory leak.

The problem is caused by the iterating variable never reaching 0.

Fixes: 145520631130bd64 ("perf data: Add perf_data__(create_dir|close_dir) functions")
Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>
Link: http://lore.kernel.org/lkml/20210716141122.858082-1-rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 5d97b3e45fbb..bcb494dc816a 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -20,7 +20,7 @@
 
 static void close_dir(struct perf_data_file *files, int nr)
 {
-	while (--nr >= 1) {
+	while (--nr >= 0) {
 		close(files[nr].fd);
 		zfree(&files[nr].path);
 	}
-- 
2.30.2



