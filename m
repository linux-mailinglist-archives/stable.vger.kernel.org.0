Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071DC5491DE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344335AbiFMKu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348582AbiFMKt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:49:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6827C2E0AA;
        Mon, 13 Jun 2022 03:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E99FCB80E95;
        Mon, 13 Jun 2022 10:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF8EC34114;
        Mon, 13 Jun 2022 10:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116020;
        bh=jF8jZSlmfxE9qd0ZzdwmSA2Q2KJaePP+dIHkpy2PxbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eexn0QnwuCYVlSiy8YNwCvVdJ8ygPpL9eydaBs10gfeS6U1i4QozJ9LYD94W3u+PZ
         c4Y446mAbo/zbAmaCHQ1u/UiU7luGoTtGhl+DJvmdI/2UkVHaXerxJSzivWMRB3sv6
         ConypoEiq3j1rF4ttJVLAvj27syE3jcfX65ZivUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/218] perf jevents: Fix event syntax error caused by ExtSel
Date:   Mon, 13 Jun 2022 12:09:19 +0200
Message-Id: <20220613094923.616066466@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

[ Upstream commit f4df0dbbe62ee8e4405a57b27ccd54393971c773 ]

In the origin code, when "ExtSel" is 1, the eventcode will change to
"eventcode |= 1 << 21”. For event “UNC_Q_RxL_CREDITS_CONSUMED_VN0.DRS",
its "ExtSel" is "1", its eventcode will change from 0x1E to 0x20001E,
but in fact the eventcode should <=0x1FF, so this will cause the parse
fail:

  # perf stat -e "UNC_Q_RxL_CREDITS_CONSUMED_VN0.DRS" -a sleep 0.1
  event syntax error: '.._RxL_CREDITS_CONSUMED_VN0.DRS'
                                    \___ value too big for format, maximum is 511

On the perf kernel side, the kernel assumes the valid bits are continuous.
It will adjust the 0x100 (bit 8 for perf tool) to bit 21 in HW.

DEFINE_UNCORE_FORMAT_ATTR(event_ext, event, "config:0-7,21");

So the perf tool follows the kernel side and just set bit8 other than bit21.

Fixes: fedb2b518239cbc0 ("perf jevents: Add support for parsing uncore json files")
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220525140410.1706851-1-zhengjun.xing@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index 8e487b2a37a6..dcfbbade657e 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -428,7 +428,7 @@ int json_events(const char *fn,
 			} else if (json_streq(map, field, "ExtSel")) {
 				char *code = NULL;
 				addfield(map, &code, "", "", val);
-				eventcode |= strtoul(code, NULL, 0) << 21;
+				eventcode |= strtoul(code, NULL, 0) << 8;
 				free(code);
 			} else if (json_streq(map, field, "EventName")) {
 				addfield(map, &name, "", "", val);
-- 
2.35.1



