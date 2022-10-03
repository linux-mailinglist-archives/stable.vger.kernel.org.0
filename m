Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED05F299B
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJCHW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiJCHVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:21:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4C7248EC;
        Mon,  3 Oct 2022 00:16:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86C25B80E6C;
        Mon,  3 Oct 2022 07:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88CCC433D6;
        Mon,  3 Oct 2022 07:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781373;
        bh=41Tuw7nhCIGbtroJKi9dP0cAM8JSkWdQwzKeupAZ33M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBhEX4IC5k1mPFwNorWM9kq+D/Afrh+nzN0gMPh2GaAWD6EZ5RMGV0PAcQHdlFpJQ
         jNGcqjb/d4gxvU4RnBvUU3FhfCxiCe/sS2BNWmAXzagiMnGMRtJoQkCe2Xfzo9O+5Q
         FcXQnERaFNPlCEgYKHjUJpQMw3Hj4sfGPDAGH1ew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 097/101] perf tests record: Fail the test if the errs counter is not zero
Date:   Mon,  3 Oct 2022 09:11:33 +0200
Message-Id: <20221003070726.844526673@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 25c5e67cdf744cbb93fd06647611d3036218debe ]

We were just checking for the 'err' variable, when we should really see
if there was some of the many checked errors that don't stop the test
right away.

Detected with clang 15.0.0:

  44    75.23 fedora:37       : FAIL clang version 15.0.0 (Fedora 15.0.0-2.fc37)

    tests/perf-record.c:68:16: error: variable 'errs' set but not used [-Werror,-Wunused-but-set-variable]
            int err = -1, errs = 0, i, wakeups = 0;
                          ^
    1 error generated.

The patch introducing this 'perf test' entry had that check:

  +       return (err < 0 || errs > 0) ? -1 : 0;

But at some point we lost that:

  -	  return (err < 0 || errs > 0) ? -1 : 0;
  +	  if (err == -EACCES)
  +               return TEST_SKIP;
  +	  if (err < 0)
  +               return TEST_FAIL;
  +	  return TEST_OK

Put it back.

Fixes: 2cf88f4614c996e5 ("perf test: Use skip in PERF_RECORD_*")
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/YzR0n5QhsH9VyYB0@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/perf-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 6a001fcfed68..4952abe716f3 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -332,7 +332,7 @@ static int test__PERF_RECORD(struct test_suite *test __maybe_unused, int subtest
 out:
 	if (err == -EACCES)
 		return TEST_SKIP;
-	if (err < 0)
+	if (err < 0 || errs != 0)
 		return TEST_FAIL;
 	return TEST_OK;
 }
-- 
2.35.1



