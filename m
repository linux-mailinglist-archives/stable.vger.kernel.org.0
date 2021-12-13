Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6598E4730D5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240239AbhLMPp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:58 -0500
Received: from mga14.intel.com ([192.55.52.115]:12921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240209AbhLMPp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410357; x=1670946357;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=wjHPsTKc7Spu6gcYw2ACQhgxfygWGuiguXZkjN32f4E=;
  b=jE3t1qhW2o2VN16UR6JiFKqH1W2nVHMD40XKNerlfwl3FfNPkeFOOGSi
   C7DJbNkKG3xeonafBNomoUKdWKyXW5htXw0KB82R+QR6a5jiLziRg7Yjy
   LEyjwwhYqklCCFeDNUcVeM+hNlI+cAxamt6TZIQMwOp/fxPt93VZG8fFi
   Az9z+NRox9oB28IPNpysFW+xwr4Lf6aCbbT1gl08bt+QZqIbgKAHcaqVp
   PqGKMQx791tS2df+0R/KnH0EoaN1Iml/xjWORfNLFgrmQy0zABW1U9ZB5
   0uDUx18ZHLCk7fRG36+Vw1cqJf0u86k2p8utKXgcQTWwoCmPr/7gaVPmA
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982247"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982247"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890508"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:56 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 6/8] perf intel-pt: Fix next 'err' value, walking trace
Date:   Mon, 13 Dec 2021 17:45:46 +0200
Message-Id: <20211213154548.122728-7-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a32e6c5da599dbf49e60622a4dfb5b9b40ece029 upstream.

Code after label 'next:' in intel_pt_walk_trace() assumes 'err' is zero,
but it may not be, if arrived at via a 'goto'. Ensure it is zero.

Fixes: 7c1b16ba0e26e6 ("perf intel-pt: Add support for decoding FUP/TIP only")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-6-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index 27a3c3eb48da..aaae2ef36f5d 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2068,6 +2068,7 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 		if (err)
 			return err;
 next:
+		err = 0;
 		if (decoder->cyc_threshold) {
 			if (decoder->sample_cyc && last_packet_type != INTEL_PT_CYC)
 				decoder->sample_cyc = false;
-- 
2.25.1

