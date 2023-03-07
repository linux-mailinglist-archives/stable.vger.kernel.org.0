Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DFC6AF448
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbjCGTPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbjCGTP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:15:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB151CB67E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:58:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E60FB819D5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8439C433EF;
        Tue,  7 Mar 2023 18:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215533;
        bh=8JQU8LNEFpMQJ1WSOgEziPkRzsIz1u5m0y+h+fDwbPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rx8jPwX9sTWqscA98sE4eFkf9UfBUHMORhzFmYx17tcy5MnSNiX/ejZtn/M1SxCNe
         qg8qp06/VhcYVtk2XeO4b+WB5nclICNNTt4bEKIV0cNVDTgAfCoLgktfTXEL6lcgR1
         p7Ld58LyY5nR7PUv513FKAVpB9Naq0QfTjsWkdp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        James Clark <james.clark@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Leo Yan <leo.yan@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 261/567] perf inject: Use perf_data__read() for auxtrace
Date:   Tue,  7 Mar 2023 17:59:57 +0100
Message-Id: <20230307165917.218396816@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 1746212daeba95e9ae1639227dc0c3591d41deeb ]

In copy_bytes(), it reads the data from the (input) fd and writes it to
the output file.  But it does with the read(2) unconditionally which
caused a problem of mixing buffered vs unbuffered I/O together.

You can see the problem when using pipes.

  $ perf record -e intel_pt// -o- true | perf inject -b > /dev/null
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.000 MB - ]
  0x45c0 [0x30]: failed to process type: 71

It should use perf_data__read() to honor the 'use_stdio' setting.

Fixes: 601366678c93618f ("perf data: Allow to use stdio functions for pipe mode")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20230131023350.1903992-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-inject.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 50c2e6892b3e9..f15c146e00548 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -142,14 +142,14 @@ static int perf_event__repipe_event_update(struct perf_tool *tool,
 
 #ifdef HAVE_AUXTRACE_SUPPORT
 
-static int copy_bytes(struct perf_inject *inject, int fd, off_t size)
+static int copy_bytes(struct perf_inject *inject, struct perf_data *data, off_t size)
 {
 	char buf[4096];
 	ssize_t ssz;
 	int ret;
 
 	while (size > 0) {
-		ssz = read(fd, buf, min(size, (off_t)sizeof(buf)));
+		ssz = perf_data__read(data, buf, min(size, (off_t)sizeof(buf)));
 		if (ssz < 0)
 			return -errno;
 		ret = output_bytes(inject, buf, ssz);
@@ -187,7 +187,7 @@ static s64 perf_event__repipe_auxtrace(struct perf_session *session,
 		ret = output_bytes(inject, event, event->header.size);
 		if (ret < 0)
 			return ret;
-		ret = copy_bytes(inject, perf_data__fd(session->data),
+		ret = copy_bytes(inject, session->data,
 				 event->auxtrace.size);
 	} else {
 		ret = output_bytes(inject, event,
-- 
2.39.2



