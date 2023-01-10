Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2698C664B23
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbjAJSjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbjAJSiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:38:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFFD919C04
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:33:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 927ECB818E0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:33:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4D4C433F0;
        Tue, 10 Jan 2023 18:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375621;
        bh=NUWbpgOyZQpQaOjxCGZOQUYD9m2a/zVpPuU8XztvRHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=spvULVfHBlpKGTQ7YX0BhNM6XIOuslcpQAfK4qUxbmy5wCzR9aEB7OWFuAgLOXnCA
         dJ7ozkgGrJrS1Q6e7Ywc/zlpbbb1tPnS+mmDgHYxLJkL/rt9qXW8dkymUk9YMHgt9S
         lV3gpCFCpoTNB98s7eD7jhHR1rPvEI+/3wMaGJYM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Adrian Hunter <adrian.hunter@intel.com>,
        Miaoqian Lin <linmq006@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 249/290] perf tools: Fix resources leak in perf_data__open_dir()
Date:   Tue, 10 Jan 2023 19:05:41 +0100
Message-Id: <20230110180040.599840425@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0a6564ebd953c4590663c9a3c99a3ea9920ade6f ]

In perf_data__open_dir(), opendir() opens the directory stream.  Add
missing closedir() to release it after use.

Fixes: eb6176709b235b96 ("perf data: Add perf_data__open_dir_data function")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Alexey Bayduraev <alexey.v.bayduraev@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221229090903.1402395-1-linmq006@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 15a4547d608e..090a76be522b 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -127,6 +127,7 @@ int perf_data__open_dir(struct perf_data *data)
 		file->size = st.st_size;
 	}
 
+	closedir(dir);
 	if (!files)
 		return -EINVAL;
 
@@ -135,6 +136,7 @@ int perf_data__open_dir(struct perf_data *data)
 	return 0;
 
 out_err:
+	closedir(dir);
 	close_dir(files, nr);
 	return ret;
 }
-- 
2.35.1



