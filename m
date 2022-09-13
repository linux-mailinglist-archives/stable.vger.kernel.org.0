Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0B05B70CF
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiIMOZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiIMOYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:24:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07AC567153;
        Tue, 13 Sep 2022 07:16:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E392B614B6;
        Tue, 13 Sep 2022 14:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BB0C433D6;
        Tue, 13 Sep 2022 14:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078474;
        bh=0WUSAHzDPnUJpssAr6xyDkhaDThbrR9BMKnWYqJ6Iw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TDbEt3hGkgU6fWrqVwS7E6Fjuxbv/5fO1hLlMzVfaL/C3V1rNcYPxeop95EJRE8/m
         xECj683wqrwOz4OObk30z6nUsE2XaJILR7Wgbk2zL/iejX999vjLmcPoTmjm8RBDiQ
         nPPNYDt0YLqj4Vz0v/Lt4cmbttNDzCvzBDxYWr9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 153/192] perf dlfilter dlfilter-show-cycles: Fix types for print format
Date:   Tue, 13 Sep 2022 16:04:19 +0200
Message-Id: <20220913140417.647477709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 1706623e940347ad23fdf77910eca4905dc37f91 ]

Avoid compiler warning about format %llu that expects long long unsigned
int but argument has type __u64.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Fixes: c3afd6e50fce824f ("perf dlfilter: Add dlfilter-show-cycles")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20220905074735.4513-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/dlfilters/dlfilter-show-cycles.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/dlfilters/dlfilter-show-cycles.c b/tools/perf/dlfilters/dlfilter-show-cycles.c
index 9eccc97bff82f..6d47298ebe9f6 100644
--- a/tools/perf/dlfilters/dlfilter-show-cycles.c
+++ b/tools/perf/dlfilters/dlfilter-show-cycles.c
@@ -98,9 +98,9 @@ int filter_event_early(void *data, const struct perf_dlfilter_sample *sample, vo
 static void print_vals(__u64 cycles, __u64 delta)
 {
 	if (delta)
-		printf("%10llu %10llu ", cycles, delta);
+		printf("%10llu %10llu ", (unsigned long long)cycles, (unsigned long long)delta);
 	else
-		printf("%10llu %10s ", cycles, "");
+		printf("%10llu %10s ", (unsigned long long)cycles, "");
 }
 
 int filter_event(void *data, const struct perf_dlfilter_sample *sample, void *ctx)
-- 
2.35.1



