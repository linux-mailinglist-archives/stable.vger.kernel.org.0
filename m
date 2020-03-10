Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5AF117FCBD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbgCJNAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:00:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbgCJNAK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:00:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8E4524693;
        Tue, 10 Mar 2020 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845210;
        bh=EHNki9bHxweFzOgJkJJEZ+SL42Ct+SmSQmOaBVzZRsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=httYH4C1YLoNjYJaYP7HYIb7I8b1MaU0ECLNdGjFAsn5yP01gQzfgDLH27jVev3BL
         Ct6Z3nieo3r5A8ckY6UilNYOMfQb9ARTiF76hJB+jV9TACdUHUa0YOgX4nZP68s/Yw
         AZiV5S8khdFpuTlz0YL31lnR4xoBU5P1Rob9+FV8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wei Li <liwei391@huawei.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.5 101/189] perf cs-etm: Fix endless record after being terminated
Date:   Tue, 10 Mar 2020 13:38:58 +0100
Message-Id: <20200310123649.912355590@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123639.608886314@linuxfoundation.org>
References: <20200310123639.608886314@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

commit c9f2833cb472cf9e0a49b7bcdc210a96017a7bfd upstream.

In __cmd_record(), when receiving SIGINT(ctrl + c), a 'done' flag will
be set and the event list will be disabled by evlist__disable() once.

While in auxtrace_record.read_finish(), the related events will be
enabled again, if they are continuous, the recording seems to be
endless.

If the cs_etm event is disabled, we don't enable it again here.

Note: This patch is NOT tested since i don't have such a machine with
coresight feature, but the code seems buggy same as arm-spe and
intel-pt.

Tester notes:

Thanks for looping, Adrian.  Applied this patch and tested with
CoreSight on juno board, it works well.

Signed-off-by: Wei Li <liwei391@huawei.com>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: stable@vger.kernel.org # 5.4+
Link: http://lore.kernel.org/lkml/20200214132654.20395-4-adrian.hunter@intel.com
[ahunter: removed redundant 'else' after 'return']
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/arch/arm/util/cs-etm.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/perf/arch/arm/util/cs-etm.c
+++ b/tools/perf/arch/arm/util/cs-etm.c
@@ -865,9 +865,12 @@ static int cs_etm_read_finish(struct aux
 	struct evsel *evsel;
 
 	evlist__for_each_entry(ptr->evlist, evsel) {
-		if (evsel->core.attr.type == ptr->cs_etm_pmu->type)
+		if (evsel->core.attr.type == ptr->cs_etm_pmu->type) {
+			if (evsel->disabled)
+				return 0;
 			return perf_evlist__enable_event_idx(ptr->evlist,
 							     evsel, idx);
+		}
 	}
 
 	return -EINVAL;


