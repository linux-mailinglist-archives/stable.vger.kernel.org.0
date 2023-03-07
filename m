Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD6206AEF6D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjCGSXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbjCGSXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6195076BA
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:17:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19353B819C5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:17:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF60C433EF;
        Tue,  7 Mar 2023 18:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213073;
        bh=zXvqU6FIbEeTx/ihMnNNWWP34AeqqWOeJw814cGkHnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rM982VCBKB27sn/7iuvkU1nLd8/YM5hdf0MB22aEPDOtcWjaS+qH4jEGAId9if1uo
         ZhLGrB48sJxCi0SzmWSKkUG8Y4XJwQhbZR+74D0K/JCmwH8AaF7XpurXa6O/Fl7pt8
         aFBVfRwAMkBGh5QdviNK1LamDqZ9wAwpsJXc8+uo=
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
Subject: [PATCH 6.1 390/885] perf inject: Use perf_data__read() for auxtrace
Date:   Tue,  7 Mar 2023 17:55:24 +0100
Message-Id: <20230307170019.314222737@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index e254f18986f7c..e2ce5f294cbd4 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -215,14 +215,14 @@ static int perf_event__repipe_event_update(struct perf_tool *tool,
 
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
@@ -260,7 +260,7 @@ static s64 perf_event__repipe_auxtrace(struct perf_session *session,
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



