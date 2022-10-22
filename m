Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D8B6089F7
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiJVIpr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbiJVIoL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:44:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475612C6E9E;
        Sat, 22 Oct 2022 01:07:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58F8460BAA;
        Sat, 22 Oct 2022 08:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65443C433C1;
        Sat, 22 Oct 2022 08:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426035;
        bh=6HicgzDugBOerZVbAxSgXH2xBFYBrHxtY5zu4BuDnVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDLegif66pSGgV2jHhObzgJK3qKtEitiHmKkb93hYOStGi9AYG8MrNdACG8MOREYw
         1aZby/F13hgLAYcg9bFsxesHwaxayrwEMyPykrOhLUR8Fc+vZ842ef4seIim772nLH
         qRVZViJgx7LAkA7zGM4+PAL0I92H1hmDrPvEen8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.19 698/717] perf intel-pt: Fix system_wide dummy event for hybrid
Date:   Sat, 22 Oct 2022 09:29:37 +0200
Message-Id: <20221022072529.333384768@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 6cef7dab3e2e5cb23a13569c3880c0532326748c upstream.

User space tasks can migrate between CPUs, so when tracing selected CPUs,
system-wide sideband is still needed, however evlist->core.has_user_cpus
is not set in the hybrid case, so check the target cpu_list instead.

Fixes: 7d189cadbeebc778 ("perf intel-pt: Track sideband system-wide when needed")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221012082259.22394-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/x86/util/intel-pt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -871,7 +871,7 @@ static int intel_pt_recording_options(st
 		 * User space tasks can migrate between CPUs, so when tracing
 		 * selected CPUs, sideband for all CPUs is still needed.
 		 */
-		need_system_wide_tracking = evlist->core.has_user_cpus &&
+		need_system_wide_tracking = opts->target.cpu_list &&
 					    !intel_pt_evsel->core.attr.exclude_user;
 
 		tracking_evsel = evlist__add_aux_dummy(evlist, need_system_wide_tracking);


