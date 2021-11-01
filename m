Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312924418C7
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhKAJvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhKAJtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:49:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D75961248;
        Mon,  1 Nov 2021 09:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759101;
        bh=NAYc6uc1l/6P8riSp+J18HJLVF2AIA/qvqHP6MRkaZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zgGjhtOJRBV/QLGk2LRCEEzO5srNBtRiV6GoUmQyOK1lahxaR0Dhbio9Xo4CTd051
         7Oycg/QkSwykFKGTGZgyTRuq3ZCn5pX5plovewbLua+zhiQ6nseTyFGFmVXjAHBMhy
         +cirsxiQvCGY6FGUikhx+CENhvMbzB8oEa2Lg758=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Mario <jmario@redhat.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 116/125] perf script: Fix PERF_SAMPLE_WEIGHT_STRUCT support
Date:   Mon,  1 Nov 2021 10:18:09 +0100
Message-Id: <20211101082555.017159732@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 27730c8cd60d1574d8337276e7a9d7d2ca92e0d1 ]

-F weight in perf script is broken.

  # ./perf mem record
  # ./perf script -F weight
  Samples for 'dummy:HG' event do not have WEIGHT attribute set. Cannot
print 'weight' field.

The sample type, PERF_SAMPLE_WEIGHT_STRUCT, is an alternative of the
PERF_SAMPLE_WEIGHT sample type. They share the same space, weight. The
lower 32 bits are exactly the same for both sample type. The higher 32
bits may be different for different architecture. For a new kernel on
x86, the PERF_SAMPLE_WEIGHT_STRUCT is used. For an old kernel or other
ARCHs, the PERF_SAMPLE_WEIGHT is used.

With -F weight, current perf script will only check the input string
"weight" with the PERF_SAMPLE_WEIGHT sample type. Because the commit
ea8d0ed6eae3 ("perf tools: Support PERF_SAMPLE_WEIGHT_STRUCT") didn't
update the PERF_SAMPLE_WEIGHT_STRUCT sample type for perf script. For a
new kernel on x86, the check fails.

Use PERF_SAMPLE_WEIGHT_TYPE, which supports both sample types, to
replace PERF_SAMPLE_WEIGHT

Fixes: ea8d0ed6eae37b01 ("perf tools: Support PERF_SAMPLE_WEIGHT_STRUCT")
Reported-by: Joe Mario <jmario@redhat.com>
Reviewed-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Joe Mario <jmario@redhat.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Joe Mario <jmario@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Link: https://lore.kernel.org/r/1632929894-102778-1-git-send-email-kan.liang@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 064da7f3618d..52ff827ca799 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -469,7 +469,7 @@ static int evsel__check_attr(struct evsel *evsel, struct perf_session *session)
 		return -EINVAL;
 
 	if (PRINT_FIELD(WEIGHT) &&
-	    evsel__check_stype(evsel, PERF_SAMPLE_WEIGHT, "WEIGHT", PERF_OUTPUT_WEIGHT))
+	    evsel__check_stype(evsel, PERF_SAMPLE_WEIGHT_TYPE, "WEIGHT", PERF_OUTPUT_WEIGHT))
 		return -EINVAL;
 
 	if (PRINT_FIELD(SYM) &&
-- 
2.33.0



