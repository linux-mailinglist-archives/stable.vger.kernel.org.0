Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46D005491A8
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352389AbiFMLQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352520AbiFMLN6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A5EC36147;
        Mon, 13 Jun 2022 03:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 739C260AE6;
        Mon, 13 Jun 2022 10:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2FFC34114;
        Mon, 13 Jun 2022 10:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116582;
        bh=+8d59Nn15/3gU6el53Zi4ltJZJL+mqLOk3LEiAzZsgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z8ggk4J0+w5tqs20eKxdtjvOsxG7/JVEqI/EA/yTRbbaAdUsBM8nZrwGJSVJuOI9b
         UdEbiLaKSslATVL2NuyHnJqCNv2hVHiAPmpDC6OZS3ghl5ySRJFkpkFe0AB9FMmhAY
         2yfCrpSrdO4lSeJF+pe0/tuEPgaSCDwSxafL0Q1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Jihong <yangjihong1@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/411] perf tools: Add missing headers needed by util/data.h
Date:   Mon, 13 Jun 2022 12:06:25 +0200
Message-Id: <20220613094932.030888042@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Jihong <yangjihong1@huawei.com>

[ Upstream commit 4d27cf1d9de5becfa4d1efb2ea54dba1b9fc962a ]

'struct perf_data' in util/data.h uses the "u64" data type, which is
defined in "linux/types.h".

If we only include util/data.h, the following compilation error occurs:

  util/data.h:38:3: error: unknown type name ‘u64’
     u64    version;
     ^~~

Solution: include "linux/types.h." to add the needed type definitions.

Fixes: 258031c017c353e8 ("perf header: Add DIR_FORMAT feature to describe directory data")
Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220429090539.212448-1-yangjihong1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/data.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 259868a39019..252d99071249 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -3,6 +3,7 @@
 #define __PERF_DATA_H
 
 #include <stdbool.h>
+#include <linux/types.h>
 
 enum perf_data_mode {
 	PERF_DATA_MODE_WRITE,
-- 
2.35.1



