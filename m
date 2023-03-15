Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83B66BB2F2
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbjCOMk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjCOMkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F85A1FF3
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 872B761D78
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2DEC433EF;
        Wed, 15 Mar 2023 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883913;
        bh=MvlwO+kpLZ3PLjCXt/aB6elSh1+UHr037w3YIsIEYhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HnlTobPTbcdChe501hZwUYStv+qNL+YhVPkdk3bh3FnmvrwCRIIu7C3tK2ExZ4PT9
         PWmJ8MuWd8GhzqPHnmSiwKHgPu5xN1glXWv5aNA4Xez6E1hTlh46F7lUwtuRfKbrWV
         Ss2y4bpbgInXvUzNgolJitgaXmbIUUAsvhZezds4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.2 007/141] perf inject: Fix --buildid-all not to eat up MMAP2
Date:   Wed, 15 Mar 2023 13:11:50 +0100
Message-Id: <20230315115740.182871410@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
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

commit ce9f1c05d2edfa6cdf2c1a510495d333e11810a8 upstream.

When MMAP2 has the PERF_RECORD_MISC_MMAP_BUILD_ID flag, it means the
record already has the build-id info.  So it marks the DSO as hit, to
skip if the same DSO is not processed if it happens to miss the build-id
later.

But it missed to copy the MMAP2 record itself so it'd fail to symbolize
samples for those regions.

For example, the following generates 249 MMAP2 events.

  $ perf record --buildid-mmap -o- true | perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.8%)

Adding perf inject should not change the number of events like this

  $ perf record --buildid-mmap -o- true | perf inject -b | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.5%)

But when --buildid-all is used, it eats most of the MMAP2 events.

  $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:          1  ( 2.5%)

With this patch, it shows the original number now.

  $ perf record --buildid-mmap -o- true | perf inject -b --buildid-all | \
  > perf report --stat -i- | grep MMAP2
           MMAP2 events:        249  (86.5%)

Committer testing:

Before:

  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (36.2%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (36.2%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b --buildid-all | perf report --stat -i- | grep MMAP2
           MMAP2 events:          2  ( 1.9%)
  $

After:

  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (29.3%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (34.3%)
  $ perf record --buildid-mmap -o- perf stat --null sleep 1 2> /dev/null | perf inject -b --buildid-all | perf report --stat -i- | grep MMAP2
           MMAP2 events:         58  (38.4%)
  $

Fixes: f7fc0d1c915a74ff ("perf inject: Do not inject BUILD_ID record if MMAP2 has it")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230223070155.54251-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-inject.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -538,6 +538,7 @@ static int perf_event__repipe_buildid_mm
 			dso->hit = 1;
 		}
 		dso__put(dso);
+		perf_event__repipe(tool, event, sample, machine);
 		return 0;
 	}
 


