Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2114730D6
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240223AbhLMPp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:59 -0500
Received: from mga14.intel.com ([192.55.52.115]:12921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240226AbhLMPp7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410359; x=1670946359;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=twytOgL/Kq4CwPhGPgqZ+rHFYFv8qd3XlIBzAA0W3mk=;
  b=fIiW8P1Jel59glKGOpUdQGJ5kKvk2uarhjkqNv8MVPSbHPfC/4fxHiDv
   OC2oqJs7OHpqWSva+Vnixy9qM+PLFrPfID1mXrS5wJGUZ9+CkduBolw69
   UW4eihHl5IoQq7nc8WkK6LDalqTBS57E9q/gP+s1vkIWfSKPLTr8LVOQM
   S1oc4Ek67ctHxFSRaSHjOFBwq6i1N9UsExD6AHSiO6hFAs+RLsvaGYnmV
   tyo4aDVAEYq6tRh0NVSm/C23u8LPRUFc7lW3BakUXYyOmQfQ6JjHBHXV8
   bEvceyCzA6h9RJbUgl7QSIe4xmOf68RsRiNc3xFPzy3PXzC+jA6/aR4wT
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982253"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982253"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890513"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:58 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 7/8] perf intel-pt: Fix missing 'instruction' events with 'q' option
Date:   Mon, 13 Dec 2021 17:45:47 +0200
Message-Id: <20211213154548.122728-8-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a882cc94971093e146ffa1163b140ad956236754 upstream.

FUP packets contain IP information, which makes them also an 'instruction'
event in 'hop' mode i.e. the itrace 'q' option.  That wasn't happening, so
restructure the logic so that FUP events are added along with appropriate
'instruction' and 'branch' events.

Fixes: 7c1b16ba0e26e6 ("perf intel-pt: Add support for decoding FUP/TIP only")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-7-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index aaae2ef36f5d..e4c485f92c02 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1954,6 +1954,8 @@ static int intel_pt_scan_for_psb(struct intel_pt_decoder *decoder);
 /* Hop mode: Ignore TNT, do not walk code, but get ip from FUPs and TIPs */
 static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, int *err)
 {
+	*err = 0;
+
 	/* Leap from PSB to PSB, getting ip from FUP within PSB+ */
 	if (decoder->leap && !decoder->in_psb && decoder->packet.type != INTEL_PT_PSB) {
 		*err = intel_pt_scan_for_psb(decoder);
@@ -1988,18 +1990,21 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 		if (!decoder->packet.count)
 			return HOP_IGNORE;
 		intel_pt_set_ip(decoder);
-		if (intel_pt_fup_event(decoder))
-			return HOP_RETURN;
+		if (decoder->set_fup_mwait || decoder->set_fup_pwre)
+			*no_tip = true;
 		if (!decoder->branch_enable || !decoder->pge)
 			*no_tip = true;
 		if (*no_tip) {
 			decoder->state.type = INTEL_PT_INSTRUCTION;
 			decoder->state.from_ip = decoder->ip;
 			decoder->state.to_ip = 0;
+			intel_pt_fup_event(decoder);
 			return HOP_RETURN;
 		}
+		intel_pt_fup_event(decoder);
+		decoder->state.type |= INTEL_PT_INSTRUCTION | INTEL_PT_BRANCH;
 		*err = intel_pt_walk_fup_tip(decoder);
-		if (!*err)
+		if (!*err && decoder->state.to_ip)
 			decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
 		return HOP_RETURN;
 
-- 
2.25.1

