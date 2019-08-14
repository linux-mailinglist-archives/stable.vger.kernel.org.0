Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1508DA51
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730954AbfHNRNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:13:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbfHNRNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:13:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 151852063F;
        Wed, 14 Aug 2019 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802825;
        bh=Yy44GzBlOhNX+cRH3VDEQOL4SygaJSzEKGBGdEzPOQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cz/oqRzxZNtxykNQyIC0ob4ZhGUymXbQgG5slpVqmA6SIOqMw8Jd5KJumb6Jekdw6
         x9xi7NmLLbZflBY/QODua39qyDrTvTPKZfIU+bkAHnejxbtQ2UTaFL6XZaomHxjpaL
         EzX/9GBh5vmO0RPqz+JxGwZ6g3Otj/7IXU7M8BqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        David Carrillo-Cisneros <davidcc@google.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 40/69] perf tools: Fix proper buffer size for feature processing
Date:   Wed, 14 Aug 2019 19:01:38 +0200
Message-Id: <20190814165748.156633204@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 79b2fe5e756163897175a8f57d66b26cd9befd59 ]

After Song Liu's segfault fix for pipe mode, Arnaldo reported following
error:

  # perf record -o - | perf script
  0x514 [0x1ac]: failed to process type: 80

It's caused by wrong buffer size setup in feature processing, which
makes cpu topology feature fail, because it's using buffer size to
recognize its header version.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: David Carrillo-Cisneros <davidcc@google.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Song Liu <songliubraving@fb.com>
Fixes: e9def1b2e74e ("perf tools: Add feature header record to pipe-mode")
Link: http://lkml.kernel.org/r/20190715140426.32509-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 26437143c9406..c892a28e7b048 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -3081,7 +3081,7 @@ int perf_event__process_feature(struct perf_tool *tool,
 		return 0;
 
 	ff.buf  = (void *)fe->data;
-	ff.size = event->header.size - sizeof(event->header);
+	ff.size = event->header.size - sizeof(*fe);
 	ff.ph = &session->header;
 
 	if (feat_ops[feat].process(&ff, NULL))
-- 
2.20.1



