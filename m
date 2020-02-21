Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B97A1166C84
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 02:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgBUBxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 20:53:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729615AbgBUBxa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 20:53:30 -0500
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3A032465D;
        Fri, 21 Feb 2020 01:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582250009;
        bh=fo0THK1z/yjiZXHFrqk6tMtI3Yzb0ph+fdkBDFOfWyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl/b/nAhEqvFosnh445GA2DJanuwBPZcRXwS81NRCdKByEr2P+OV8FosxXSElGd8y
         q5ZpiPKLfUJRF3+A/1hPOhVKSOcYYX4Qc4f/A4PcuT48lz+ApD5EVBOEpxNGGIkXrC
         EPh5qJ2L+yEGxjvG0D1RQEzeoU3Ryd5vr7e0AMMs=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Wei Li <liwei391@huawei.com>, Jiri Olsa <jolsa@redhat.com>,
        Tan Xiaojun <tanxiaojun@huawei.com>, stable@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/8] perf intel-pt: Fix endless record after being terminated
Date:   Thu, 20 Feb 2020 22:53:05 -0300
Message-Id: <20200221015310.16914-4-acme@kernel.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221015310.16914-1-acme@kernel.org>
References: <20200221015310.16914-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Li <liwei391@huawei.com>

In __cmd_record(), when receiving SIGINT(ctrl + c), a 'done' flag will
be set and the event list will be disabled by evlist__disable() once.

While in auxtrace_record.read_finish(), the related events will be
enabled again, if they are continuous, the recording seems to be endless.

If the intel_pt event is disabled, we don't enable it again here.

Before the patch:

  huawei@huawei-2288H-V5:~/linux-5.5-rc4/tools/perf$ ./perf record -e \
  intel_pt//u -p 46803
  ^C^C^C^C^C^C

After the patch:

  huawei@huawei-2288H-V5:~/linux-5.5-rc4/tools/perf$ ./perf record -e \
  intel_pt//u -p 48591
  ^C[ perf record: Woken up 0 times to write data ]
  Warning:
  AUX data lost 504 times out of 4816!

  [ perf record: Captured and wrote 2024.405 MB perf.data ]

Signed-off-by: Wei Li <liwei391@huawei.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Tan Xiaojun <tanxiaojun@huawei.com>
Cc: stable@vger.kernel.org # 5.4+
Link: http://lore.kernel.org/lkml/20200214132654.20395-2-adrian.hunter@intel.com
[ ahunter: removed redundant 'else' after 'return' ]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/x86/util/intel-pt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/arch/x86/util/intel-pt.c b/tools/perf/arch/x86/util/intel-pt.c
index 20df442fdf36..be07d6886256 100644
--- a/tools/perf/arch/x86/util/intel-pt.c
+++ b/tools/perf/arch/x86/util/intel-pt.c
@@ -1173,9 +1173,12 @@ static int intel_pt_read_finish(struct auxtrace_record *itr, int idx)
 	struct evsel *evsel;
 
 	evlist__for_each_entry(ptr->evlist, evsel) {
-		if (evsel->core.attr.type == ptr->intel_pt_pmu->type)
+		if (evsel->core.attr.type == ptr->intel_pt_pmu->type) {
+			if (evsel->disabled)
+				return 0;
 			return perf_evlist__enable_event_idx(ptr->evlist, evsel,
 							     idx);
+		}
 	}
 	return -EINVAL;
 }
-- 
2.21.1

