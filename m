Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67274730D4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbhLMPp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:12921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240209AbhLMPp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410356; x=1670946356;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=kQeLwyvY+dum17TpF453Rxjklnvp5/4YS/z9NBFMjl4=;
  b=mm9FleNZIzx4oFjqjJJE6jZc2LLdBPWAWrFen8mFPLLY+3mnzNKUTxtD
   6MmnT38WcphPTgaeVRnMqq7jJrHFPsVZK0jgyQYpyjJxE/YbrriQIh6HB
   lszzQUPH3ANWQBIZo4Ze7kDBAXSgJy5ywGKZBDrcM//hKzLW3Rn/wQnIW
   i5QxpgsDVVawHb4dbLjRhnJLhcIdkLDWl+Gb/9fk2GSAtp2H6dyT1CT6u
   pRQThezKNqQuwuxBVy0LuUwdvqEdaJ+L0NfsTD8qjbb1gMHyrfqyQnv2q
   Lvhf97YfzBcldPFKregRa+ktSvenNqsPyqO0L/dBhSJ4UiaGhA9C5c2Lj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982239"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982239"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890499"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:55 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 5/8] perf intel-pt: Fix state setting when receiving overflow (OVF) packet
Date:   Mon, 13 Dec 2021 17:45:45 +0200
Message-Id: <20211213154548.122728-6-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c79ee2b2160909889df67c8801352d3e69d43a1a upstream.

An overflow (OVF packet) is treated as an error because it represents a
loss of trace data, but there is no loss of synchronization, so the packet
state should be INTEL_PT_STATE_IN_SYNC not INTEL_PT_STATE_ERR_RESYNC.

To support that, some additional variables must be reset, and the FUP
packet that may follow OVF is treated as an FUP event.

Fixes: f4aa081949e7b6 ("perf tools: Add Intel PT decoder")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-5-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 .../util/intel-pt-decoder/intel-pt-decoder.c  | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index dac06c5f5c30..27a3c3eb48da 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1158,6 +1158,20 @@ static bool intel_pt_fup_event(struct intel_pt_decoder *decoder)
 		decoder->state.type |= INTEL_PT_BLK_ITEMS;
 		ret = true;
 	}
+	if (decoder->overflow) {
+		decoder->overflow = false;
+		if (!ret && !decoder->pge) {
+			if (decoder->hop) {
+				decoder->state.type = 0;
+				decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
+			}
+			decoder->pge = true;
+			decoder->state.type |= INTEL_PT_BRANCH | INTEL_PT_TRACE_BEGIN;
+			decoder->state.from_ip = 0;
+			decoder->state.to_ip = decoder->ip;
+			return true;
+		}
+	}
 	if (ret) {
 		decoder->state.from_ip = decoder->ip;
 		decoder->state.to_ip = 0;
@@ -1480,7 +1494,16 @@ static int intel_pt_overflow(struct intel_pt_decoder *decoder)
 	intel_pt_log("ERROR: Buffer overflow\n");
 	intel_pt_clear_tx_flags(decoder);
 	decoder->timestamp_insn_cnt = 0;
-	decoder->pkt_state = INTEL_PT_STATE_ERR_RESYNC;
+	decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
+	decoder->state.from_ip = decoder->ip;
+	decoder->ip = 0;
+	decoder->pge = false;
+	decoder->set_fup_tx_flags = false;
+	decoder->set_fup_ptw = false;
+	decoder->set_fup_mwait = false;
+	decoder->set_fup_pwre = false;
+	decoder->set_fup_exstop = false;
+	decoder->set_fup_bep = false;
 	decoder->overflow = true;
 	return -EOVERFLOW;
 }
@@ -2083,6 +2106,7 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 
 		case INTEL_PT_TIP_PGE: {
 			decoder->pge = true;
+			decoder->overflow = false;
 			intel_pt_mtc_cyc_cnt_pge(decoder);
 			if (decoder->packet.count == 0) {
 				intel_pt_log_at("Skipping zero TIP.PGE",
@@ -2596,10 +2620,10 @@ static int intel_pt_sync_ip(struct intel_pt_decoder *decoder)
 	decoder->set_fup_pwre = false;
 	decoder->set_fup_exstop = false;
 	decoder->set_fup_bep = false;
+	decoder->overflow = false;
 
 	if (!decoder->branch_enable) {
 		decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
-		decoder->overflow = false;
 		decoder->state.type = 0; /* Do not have a sample */
 		return 0;
 	}
@@ -2614,7 +2638,6 @@ static int intel_pt_sync_ip(struct intel_pt_decoder *decoder)
 		decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
 	else
 		decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
-	decoder->overflow = false;
 
 	decoder->state.from_ip = 0;
 	decoder->state.to_ip = decoder->ip;
@@ -2823,7 +2846,8 @@ const struct intel_pt_state *intel_pt_decode(struct intel_pt_decoder *decoder)
 
 	if (err) {
 		decoder->state.err = intel_pt_ext_err(err);
-		decoder->state.from_ip = decoder->ip;
+		if (err != -EOVERFLOW)
+			decoder->state.from_ip = decoder->ip;
 		intel_pt_update_sample_time(decoder);
 		decoder->sample_tot_cyc_cnt = decoder->tot_cyc_cnt;
 	} else {
-- 
2.25.1

