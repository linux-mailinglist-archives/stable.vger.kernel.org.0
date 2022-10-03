Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CD05F291A
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiJCHNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiJCHM5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:12:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BF53A4BC;
        Mon,  3 Oct 2022 00:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 499A6B80E6B;
        Mon,  3 Oct 2022 07:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14EFC433C1;
        Mon,  3 Oct 2022 07:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781159;
        bh=B6Ct1dz8v8oZkert7QrNcltIhwbgLcAbbGDlHJYJWms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgGv9ada1YFbY3te/7DGGkH+c3hOQJf+UYQ5woxWiLAjp2+E5o3WtjshyHALzJZAP
         derHkpX4AtmPdgyKLAAH0+xpZr1N5PJFtbevt4Zz6DUxTM2WbQF1iJYHL+lSpY5G51
         GYuOw/T+GTbVelxUu5SYv+2lPxIxZKB5tLvSrjeA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 003/101] perf record: Fix cpu mask bit setting for mixed mmaps
Date:   Mon,  3 Oct 2022 09:09:59 +0200
Message-Id: <20221003070724.583961037@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit ca76d7d2812b46124291f99c9b50aaf63a936f23 ]

With mixed per-thread and (system-wide) per-cpu maps, the "any cpu" value
 -1 must be skipped when setting CPU mask bits.

Prior to commit cbd7bfc7fd99acdd ("tools/perf: Fix out of bound access
to cpu mask array") the invalid setting went unnoticed, but since then
it causes perf record to fail with an error.

Example:

 Before:

   $ perf record -e intel_pt// --per-thread uname
   Failed to initialize parallel data streaming masks

 After:

   $ perf record -e intel_pt// --per-thread uname
   Linux
   [ perf record: Woken up 1 times to write data ]
   [ perf record: Captured and wrote 0.068 MB perf.data ]

Fixes: ae4f8ae16a078964 ("libperf evlist: Allow mixing per-thread and per-cpu mmaps")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220915122612.81738-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 708880a1c83c..7fbc85c1da81 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -3344,6 +3344,8 @@ static int record__mmap_cpu_mask_init(struct mmap_cpu_mask *mask, struct perf_cp
 		return 0;
 
 	perf_cpu_map__for_each_cpu(cpu, idx, cpus) {
+		if (cpu.cpu == -1)
+			continue;
 		/* Return ENODEV is input cpu is greater than max cpu */
 		if ((unsigned long)cpu.cpu > mask->nbits)
 			return -ENODEV;
-- 
2.35.1



