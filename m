Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3586581FC
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiL1Qcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiL1QcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C571AA05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:28:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43765CE1372
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:28:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2343C433D2;
        Wed, 28 Dec 2022 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244927;
        bh=uYcjfxC+EUWYd+tu5aC8lOXvRXpPqqNzU6mUpcQAXD8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATQUYYT/w9t2ia7yvpLKUyOaeWK7v8UM51Q9lk+G7b+y6wtV2yZtXR3Q8YSFhSFxq
         uX/1aWJ9FdyDTpfTHBQjSTUJZPBfsi/uzAWgLmJM+creVvKs267iNqSvhmkUBH1A0o
         m0tg9mVPCpm+a4k/9n48kk2o8dOZc59WjvWnMZXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, James Clark <james.clark@arm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0763/1146] perf tools: Fix "kernel lock contention analysis" test by not printing warnings in quiet mode
Date:   Wed, 28 Dec 2022 15:38:22 +0100
Message-Id: <20221228144350.871240876@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Clark <james.clark@arm.com>

[ Upstream commit 65319890c32db29fb56b41f84265a2c7029943f4 ]

Especially when CONFIG_LOCKDEP and other debug configs are enabled,
Perf can print the following warning when running the "kernel lock
contention analysis" test:

  Warning:
  Processed 1378918 events and lost 4 chunks!

  Check IO/CPU overload!

  Warning:
  Processed 4593325 samples and lost 70.00%!

The test already supplies -q to run in quiet mode, so extend quiet mode
to perf_stdio__warning() and also ui__warning() for consistency.

This fixes the following failure due to the extra lines counted:

  perf test "lock cont" -vvv

  82: kernel lock contention analysis test                            :
  --- start ---
  test child forked, pid 3125
  Testing perf lock record and perf lock contention
  [Fail] Recorded result count is not 1: 9
  test child finished with -1
  ---- end ----
  kernel lock contention analysis test: FAILED!

Fixes: ec685de25b6718f8 ("perf test: Add kernel lock contention test")
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221018094137.783081-2-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/util.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/ui/util.c b/tools/perf/ui/util.c
index 689b27c34246..1d38ddf01b60 100644
--- a/tools/perf/ui/util.c
+++ b/tools/perf/ui/util.c
@@ -15,6 +15,9 @@ static int perf_stdio__error(const char *format, va_list args)
 
 static int perf_stdio__warning(const char *format, va_list args)
 {
+	if (quiet)
+		return 0;
+
 	fprintf(stderr, "Warning:\n");
 	vfprintf(stderr, format, args);
 	return 0;
@@ -45,6 +48,8 @@ int ui__warning(const char *format, ...)
 {
 	int ret;
 	va_list args;
+	if (quiet)
+		return 0;
 
 	va_start(args, format);
 	ret = perf_eops->warning(format, args);
-- 
2.35.1



