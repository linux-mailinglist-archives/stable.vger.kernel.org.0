Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99EF541EB0
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380483AbiFGWdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380754AbiFGWcS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:32:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E843B27C242;
        Tue,  7 Jun 2022 12:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 841A460C7F;
        Tue,  7 Jun 2022 19:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D09C385A2;
        Tue,  7 Jun 2022 19:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629918;
        bh=kckRoG9lqxpsZdaB+tTCcD/6R4thHI69wGhEV+seiP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shFPALc9ki2O7J5NGgmy9SH5awGrK5cO7Gu9rSpDiaGaOJrIrLQLfKva7xJ0B8HD6
         zrjV8HB4i8sqp2BBFvmBCxQKfS5EWuFIkYNTTpky7r2XKLmF2xGnVyb4pkietkxzfL
         TCclz8Ju9Ea/BB32ElpLPk1f6z3SNzjD2QTylMO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhengjun Xing <zhengjun.xing@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        peterz@infradead.org, adrian.hunter@intel.com,
        alexander.shishkin@intel.com, acme@kernel.org, ak@linux.intel.com,
        jolsa@redhat.com, mingo@redhat.com,
        linux-perf-users@vger.kernel.org
Subject: [PATCH 5.18 865/879] perf evlist: Extend arch_evsel__must_be_in_group to support hybrid systems
Date:   Tue,  7 Jun 2022 19:06:23 +0200
Message-Id: <20220607165027.960918556@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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

commit e69a5c010246ca6a87c4e6f13d0a291954bdece8 upstream.

For the hybrid system, the "slots" event changes to "cpu_core/slots/", need
extend API arch_evsel__must_be_in_group() to support hybrid systems.

In the origin code, for hybrid system event "cpu_core/slots/", the output
of the API arch_evsel__must_be_in_group() is "false" (in fact,it should be
"true"). Currently only one API evsel__remove_from_group() calls it. In
evsel__remove_from_group(), it adds the second condition to check, so the
output of evsel__remove_from_group() still is correct. That's the reason
why there isn't an instant error. I'd like to fix the issue found in API
arch_evsel__must_be_in_group() in case someone else using the function in
the other place.

Fixes: d98079c05b5a ("perf evlist: Keep topdown counters in weak group")
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20220601152544.1842447-1-zhengjun.xing@linux.intel.com
Cc: peterz@infradead.org
Cc: adrian.hunter@intel.com
Cc: alexander.shishkin@intel.com
Cc: acme@kernel.org
Cc: ak@linux.intel.com
Cc: jolsa@redhat.com
Cc: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/x86/util/evsel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/arch/x86/util/evsel.c
+++ b/tools/perf/arch/x86/util/evsel.c
@@ -38,6 +38,6 @@ bool arch_evsel__must_be_in_group(const
 		return false;
 
 	return evsel->name &&
-		(!strcasecmp(evsel->name, "slots") ||
+		(strcasestr(evsel->name, "slots") ||
 		 strcasestr(evsel->name, "topdown"));
 }


