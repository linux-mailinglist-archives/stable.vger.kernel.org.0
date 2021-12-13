Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9289E4730D1
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240235AbhLMPpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:54 -0500
Received: from mga14.intel.com ([192.55.52.115]:12917 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240246AbhLMPpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410353; x=1670946353;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=g1sw2Vyst524qZ8RlP6BWDxXtdXnGbgx9IS4n5LgQZY=;
  b=LnGlzQZPYjnrYQLM5fi4sITnm0c4BElzCJF0UhyvdaD8Tj/bOEzPhZdF
   /VdLWdBqcRxd/iEcRNwzmD5ZF1DPIy/+LHb2qvee6dOrqX9wRjI/ogtAw
   ZfUsWpsTtowWdOEQy3Wt7JCUBrbtgv58LzKmXDT78p3fw51fpldEdCl6y
   o4EtUX7w1d0DLSFjb3G0Jba2xA12nWorKh4Gt4C1B14I8o8i4nFFu2g0A
   0qShGCUMfUweF9HtsKwZshQ1coyieF0HK2MsQ4BmTlU4RdsLcG7w3UFXs
   XSLpDP8e595U99R0GMeZBC3tUN0SqhQ77tHdMbhGnnDE7UxrsTNoCFGiE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982222"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982222"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890487"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:51 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 2/8] perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage
Date:   Mon, 13 Dec 2021 17:45:42 +0200
Message-Id: <20211213154548.122728-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 057ae59f5a1d924511beb1b09f395bdb316cfd03 upstream.

Packet generation enable (PGE) refers to whether control flow (COFI)
packets are being produced.

PGE may be false even when branch-tracing is enabled, due to being
out-of-context, or outside a filter address range.  Fix some missing PGE
usage.

Fixes: 7c1b16ba0e26e6 ("perf intel-pt: Add support for decoding FUP/TIP only")
Fixes: 839598176b0554 ("perf intel-pt: Allow decoding with branch tracing disabled")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index e6029d4c096f..a49122002768 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1949,6 +1949,7 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 		return HOP_IGNORE;
 
 	case INTEL_PT_TIP_PGD:
+		decoder->pge = false;
 		if (!decoder->packet.count)
 			return HOP_IGNORE;
 		intel_pt_set_ip(decoder);
@@ -1972,7 +1973,7 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 		intel_pt_set_ip(decoder);
 		if (intel_pt_fup_event(decoder))
 			return HOP_RETURN;
-		if (!decoder->branch_enable)
+		if (!decoder->branch_enable || !decoder->pge)
 			*no_tip = true;
 		if (*no_tip) {
 			decoder->state.type = INTEL_PT_INSTRUCTION;
@@ -2124,7 +2125,7 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 				break;
 			}
 			intel_pt_set_last_ip(decoder);
-			if (!decoder->branch_enable) {
+			if (!decoder->branch_enable || !decoder->pge) {
 				decoder->ip = decoder->last_ip;
 				if (intel_pt_fup_event(decoder))
 					return 0;
-- 
2.25.1

