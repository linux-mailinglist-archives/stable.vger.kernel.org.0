Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1BF541355
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354608AbiFGT7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357659AbiFGT6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:58:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0421B8290;
        Tue,  7 Jun 2022 11:24:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE84A61252;
        Tue,  7 Jun 2022 18:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22EAC385A5;
        Tue,  7 Jun 2022 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626254;
        bh=AJpDc4CRCDEYezNwJ7xnI6htH0qAKgCFMdxiiCckPkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oa7ir1re19NByAy9hGda8u0eFczNep+ZPN2Ro04ByrRpAYHGwPsBuGm2E0OcuDyLH
         77E5K59zmDSrMP6BKlOpA2G8lNgDzGq+Zn75nolEdkMeDoM0R32KIzY2zNwGuqjrh/
         YJNJZpP5pJO4Hb/HFX3xgmHtztZ95mzsPxkcTECk=
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
Subject: [PATCH 5.17 313/772] perf tools: Add missing headers needed by util/data.h
Date:   Tue,  7 Jun 2022 18:58:25 +0200
Message-Id: <20220607164958.250902071@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index c9de82af5584..1402d9657ef2 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -4,6 +4,7 @@
 
 #include <stdio.h>
 #include <stdbool.h>
+#include <linux/types.h>
 
 enum perf_data_mode {
 	PERF_DATA_MODE_WRITE,
-- 
2.35.1



