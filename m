Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0864E4C734F
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238009AbiB1Re3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:34:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238634AbiB1Rdl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:33:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFBF91AF7;
        Mon, 28 Feb 2022 09:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5F6612FA;
        Mon, 28 Feb 2022 17:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A292C340F5;
        Mon, 28 Feb 2022 17:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069424;
        bh=P9+8LyoE7wfKYtVa8BQKxcGYP08SrbQhU1GkxwKfPiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRiy8wbSNxOjtjV39dOCkaiy+GL0vCh/c22KoSnjQuLbQ0CnZIUbSPCT1NyJNm/CD
         1FrqISLSXx0bvlTRgaZFnEm75LNBQs7MuibTs7x4psEls2aH+Gd4WJUSWDvycwSRf0
         5GZOlZCILCQ3S+DHY55tMo+99E1LGPU5ZTynNhoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexei Budankov <abudankov@huawei.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 15/53] perf data: Fix double free in perf_session__delete()
Date:   Mon, 28 Feb 2022 18:24:13 +0100
Message-Id: <20220228172249.441146466@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>

commit 69560e366fc4d5fca7bebb0e44edbfafc8bcaf05 upstream.

When perf_data__create_dir() fails, it calls close_dir(), but
perf_session__delete() also calls close_dir() and since dir.version and
dir.nr were initialized by perf_data__create_dir(), a double free occurs.

This patch moves the initialization of dir.version and dir.nr after
successful initialization of dir.files, that prevents double freeing.
This behavior is already implemented in perf_data__open_dir().

Fixes: 145520631130bd64 ("perf data: Add perf_data__(create_dir|close_dir) functions")
Signed-off-by: Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Antonov <alexander.antonov@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexei Budankov <abudankov@huawei.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220218152341.5197-2-alexey.v.bayduraev@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/data.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -44,10 +44,6 @@ int perf_data__create_dir(struct perf_da
 	if (!files)
 		return -ENOMEM;
 
-	data->dir.version = PERF_DIR_VERSION;
-	data->dir.files   = files;
-	data->dir.nr      = nr;
-
 	for (i = 0; i < nr; i++) {
 		struct perf_data_file *file = &files[i];
 
@@ -62,6 +58,9 @@ int perf_data__create_dir(struct perf_da
 		file->fd = ret;
 	}
 
+	data->dir.version = PERF_DIR_VERSION;
+	data->dir.files   = files;
+	data->dir.nr      = nr;
 	return 0;
 
 out_err:


