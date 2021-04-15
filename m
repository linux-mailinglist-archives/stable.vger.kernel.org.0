Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095B0360D90
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhDOPDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235283AbhDOPAn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AEC861413;
        Thu, 15 Apr 2021 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498612;
        bh=JYbPFh3lp5ERhDKix2I+37lp8fwHCqgN1JP4dPScbT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U7o1iFvhLPmZOM0xcnRbmlG5m2bpsgWay6nb4VidE4E/txzGvYWMaaOQHa36U8iTi
         2Wh1OEPuc5eYIvfgoLtw55XeLGLjO1EBYqG2HuBdrY/aVJC3yGNfx6HAg0wkjhEw6k
         N/X9zyjdUKm6GSmTs5EppQYSVdlrzO2k54BMF2sQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexey Budankov <alexey.budankov@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 5.4 16/18] perf tools: Use %zd for size_t printf formats on 32-bit
Date:   Thu, 15 Apr 2021 16:48:09 +0200
Message-Id: <20210415144413.558004725@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 20befbb1080307e70c7893ef9840d32e3ef8ac45 upstream.

A couple of trivial fixes for using %zd for size_t in the code
supporting the ZSTD compression library.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexey Budankov <alexey.budankov@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200820212501.24421-1-chris@chris-wilson.co.uk
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/session.c |    2 +-
 tools/perf/util/zstd.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -88,7 +88,7 @@ static int perf_session__process_compres
 		session->decomp_last = decomp;
 	}
 
-	pr_debug("decomp (B): %ld to %ld\n", src_size, decomp_size);
+	pr_debug("decomp (B): %zd to %zd\n", src_size, decomp_size);
 
 	return 0;
 }
--- a/tools/perf/util/zstd.c
+++ b/tools/perf/util/zstd.c
@@ -99,7 +99,7 @@ size_t zstd_decompress_stream(struct zst
 	while (input.pos < input.size) {
 		ret = ZSTD_decompressStream(data->dstream, &output, &input);
 		if (ZSTD_isError(ret)) {
-			pr_err("failed to decompress (B): %ld -> %ld, dst_size %ld : %s\n",
+			pr_err("failed to decompress (B): %zd -> %zd, dst_size %zd : %s\n",
 			       src_size, output.size, dst_size, ZSTD_getErrorName(ret));
 			break;
 		}


