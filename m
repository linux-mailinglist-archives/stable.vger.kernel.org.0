Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1525A4A6E
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbiH2Lh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232877AbiH2LhN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:37:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A77575CC5;
        Mon, 29 Aug 2022 04:21:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49C036119E;
        Mon, 29 Aug 2022 11:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12405C433C1;
        Mon, 29 Aug 2022 11:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771939;
        bh=GFQv9vkR482Mkq74XKiTv2cwC/MfcG8EE0eFatIffww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IEBJB+AX/9s7y5/avodcBExsmrtrPiNO2aQ6kB+Nia6BpsCu5XY9uGruTD9b4x+5D
         fFuowpbm8QRqDTQTdiZN6sEU9tu2vRoG+VQZDIlkHBJQodJzBgMQDPdjBk/mpI5XFd
         rSxUIQKf+s7PABwOMh9SBGWKGhv8MNqqMGAMeKys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5.19 146/158] perf stat: Clear evsel->reset_group for each stat run
Date:   Mon, 29 Aug 2022 12:59:56 +0200
Message-Id: <20220829105815.221622515@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit bf515f024e4c0ca46a1b08c4f31860c01781d8a5 upstream.

If a weak group is broken then the reset_group flag remains set for
the next run. Having reset_group set means the counter isn't created
and ultimately a segfault.

A simple reproduction of this is:

  # perf stat -r2 -e '{cycles,cycles,cycles,cycles,cycles,cycles,cycles,cycles,cycles,cycles}:W

which will be added as a test in the next patch.

Fixes: 4804e0111662d7d8 ("perf stat: Use affinity for opening events")
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20220822213352.75721-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-stat.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -826,6 +826,7 @@ static int __run_perf_stat(int argc, con
 	}
 
 	evlist__for_each_entry(evsel_list, counter) {
+		counter->reset_group = false;
 		if (bpf_counter__load(counter, &target))
 			return -1;
 		if (!evsel__is_bpf(counter))


