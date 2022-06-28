Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766E855E160
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243589AbiF1CUo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243527AbiF1CU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:20:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACCB2495F;
        Mon, 27 Jun 2022 19:19:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4234617D9;
        Tue, 28 Jun 2022 02:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFA6C385A5;
        Tue, 28 Jun 2022 02:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656382798;
        bh=2RvOCUttCJce1i+gUQTcZb/oD0fI5ZPODIDnk1o4vqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyOhvOAWeIaAov3IDVAkbO3rn7BbIAXhpaaQuOQR9twRVHTar0ORj3Mm9XZESAIp9
         n+xuo5V3ZjR76Y2HTxgCJYpuS8hSQMUFz3FXP+kIkeS74pw0XBAoiNnc1wnVqm+Lae
         4VS0BZPSRsk/Xrqw/+zGyzfCMYIZXM8yIbgkQON0ACrKaD9QuiT7C5xullwWXAB/HI
         olx/6+u5XPV9NLMKW2SGZrxwD361dUAqaEvmR+qyH6u/M1mwkpm0C73RoSW+A3Pb5U
         tBubsHDZLA2qkye6UFDRHBE3jh7xEn3UzAXDj1j8kA8xrHta538EjSdEYm0MR9sO/k
         y+4relQhZeDrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>, Kajol Jain <kjain@linux.ibm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Herring <robh@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>, acme@kernel.org,
        linux-perf-users@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 26/53] libperf evsel: Open shouldn't leak fd on failure
Date:   Mon, 27 Jun 2022 22:18:12 -0400
Message-Id: <20220628021839.594423-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628021839.594423-1-sashal@kernel.org>
References: <20220628021839.594423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

[ Upstream commit 94725994cfd768b9ee1bd06f15c252694b1e9b89 ]

If perf_event_open() fails the fd is opened but it is only freed by
closing (not by delete).

Typically when an open fails you don't call close and so this results in
a memory leak. To avoid this, add a close when open fails.

Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-By: Kajol Jain <kjain@linux.ibm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: https://lore.kernel.org/r/20220609052355.1300162-2-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/evsel.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/tools/lib/perf/evsel.c b/tools/lib/perf/evsel.c
index 210ea7c06ce8..acf8a215dca3 100644
--- a/tools/lib/perf/evsel.c
+++ b/tools/lib/perf/evsel.c
@@ -149,23 +149,30 @@ int perf_evsel__open(struct perf_evsel *evsel, struct perf_cpu_map *cpus,
 			int fd, group_fd, *evsel_fd;
 
 			evsel_fd = FD(evsel, idx, thread);
-			if (evsel_fd == NULL)
-				return -EINVAL;
+			if (evsel_fd == NULL) {
+				err = -EINVAL;
+				goto out;
+			}
 
 			err = get_group_fd(evsel, idx, thread, &group_fd);
 			if (err < 0)
-				return err;
+				goto out;
 
 			fd = sys_perf_event_open(&evsel->attr,
 						 threads->map[thread].pid,
 						 cpu, group_fd, 0);
 
-			if (fd < 0)
-				return -errno;
+			if (fd < 0) {
+				err = -errno;
+				goto out;
+			}
 
 			*evsel_fd = fd;
 		}
 	}
+out:
+	if (err)
+		perf_evsel__close(evsel);
 
 	return err;
 }
-- 
2.35.1

