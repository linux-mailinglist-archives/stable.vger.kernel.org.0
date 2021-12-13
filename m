Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFF54730D7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240219AbhLMPqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:46:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:12921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240222AbhLMPqA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410360; x=1670946360;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=+EEpVmDPF69W5e5Pv/a5I5AysunaXBdwFZO2zwcfbLI=;
  b=JeOnJC17M6mKZZ6S4OlUiF+KITuGm8epGACeekoh0qcwJNlKquCsc3yu
   rQt7Idm1A+0LMl384d85tvVTMkWYhmVaxeXok919yhlu1ofoVycWSVNra
   UKIGJo7CZOY4mGr/ckdcIFFcuoy88ljQ3fo+M+lYwexKKni4s1V5Sdw2r
   ouOdx0yQNbX/t9hCSoRrxoLgXI+QE6vcTLtYJF98IITy4+654gG13yYrS
   ukGp1itBHtmav9AY8de+mxxxRsKI3fWpQi3xMDrQ7gtywhfr7l5ONW15K
   ogcRm2oUrCXxCE36KTQS9YD5T4zxqbgkJLxF0N/ZcOrgjXkePL27QIrdQ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982256"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982256"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:46:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890522"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:59 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 8/8] perf intel-pt: Fix error timestamp setting on the decoder error path
Date:   Mon, 13 Dec 2021 17:45:48 +0200
Message-Id: <20211213154548.122728-9-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6665b8e4836caa8023cbc7e53733acd234969c8c upstream.

An error timestamp shows the last known timestamp for the queue, but this
is not updated on the error path. Fix by setting it.

Fixes: f4aa081949e7b6 ("perf tools: Add Intel PT decoder")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-8-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index e5aaf1337be9..5163d2ffea70 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2271,6 +2271,7 @@ static int intel_pt_run_decoder(struct intel_pt_queue *ptq, u64 *timestamp)
 				ptq->sync_switch = false;
 				intel_pt_next_tid(pt, ptq);
 			}
+			ptq->timestamp = state->est_timestamp;
 			if (pt->synth_opts.errors) {
 				err = intel_ptq_synth_error(ptq, state);
 				if (err)
-- 
2.25.1

