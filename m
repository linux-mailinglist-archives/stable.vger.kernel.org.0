Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB7C4730D3
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240236AbhLMPp4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:56 -0500
Received: from mga14.intel.com ([192.55.52.115]:12921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240226AbhLMPpz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410355; x=1670946355;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=AR2d9M7/hjvdv0ufo7Y0Bix0XKMFDq2DpiwMiMiYO2o=;
  b=gxs6/Kv5VGvcmlkrS9UWtIl4eH4WeYMGui5ZDxW9EGK8YexEcZfHNXs+
   arSzzIbVaMV6nKCnQ2lBKE36f777518Ld20Co4uCi3yw9T+iWb7yGNv3c
   e3dYUSgp8LEMEZgsts71KZuqg16/xy4eYZRVMd1DXAV00qu6e9eMUGqU0
   F61bZ2uu3fkw5EMALH2a4T0bq+wjPlmRDSGtfAq3k71zBw+528whiy0Ku
   3T1z7tbSxMsfaD8iVRCzTYACl7h/KZVpYBPON3p/KUfIzPlnZQUjOpJVE
   3DGSmYUC7zztCPvX9MPNUQy0Z6YSYGzlHzxg+jAOEobBtIACErjljUUCa
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982231"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982231"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890495"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:54 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 4/8] perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type
Date:   Mon, 13 Dec 2021 17:45:44 +0200
Message-Id: <20211213154548.122728-5-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4c761d805bb2d2ead1b9baaba75496152b394c80 upstream.

intel_pt_fup_event() assumes it can overwrite the state type if there has
been an FUP event, but this is an unnecessary and unexpected constraint on
callers.

Fix by touching only the state type flags that are affected by an FUP
event.

Fixes: a472e65fc490a ("perf intel-pt: Add decoder support for ptwrite and power event packets")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 .../util/intel-pt-decoder/intel-pt-decoder.c  | 32 ++++++++-----------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index 83e54333f03c..dac06c5f5c30 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1114,61 +1114,55 @@ static int intel_pt_walk_insn(struct intel_pt_decoder *decoder,
 
 static bool intel_pt_fup_event(struct intel_pt_decoder *decoder)
 {
+	enum intel_pt_sample_type type = decoder->state.type;
 	bool ret = false;
 
+	decoder->state.type &= ~INTEL_PT_BRANCH;
+
 	if (decoder->set_fup_tx_flags) {
 		decoder->set_fup_tx_flags = false;
 		decoder->tx_flags = decoder->fup_tx_flags;
-		decoder->state.type = INTEL_PT_TRANSACTION;
+		decoder->state.type |= INTEL_PT_TRANSACTION;
 		if (decoder->fup_tx_flags & INTEL_PT_ABORT_TX)
 			decoder->state.type |= INTEL_PT_BRANCH;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.flags = decoder->fup_tx_flags;
-		return true;
+		ret = true;
 	}
 	if (decoder->set_fup_ptw) {
 		decoder->set_fup_ptw = false;
-		decoder->state.type = INTEL_PT_PTW;
+		decoder->state.type |= INTEL_PT_PTW;
 		decoder->state.flags |= INTEL_PT_FUP_IP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.ptw_payload = decoder->fup_ptw_payload;
-		return true;
+		ret = true;
 	}
 	if (decoder->set_fup_mwait) {
 		decoder->set_fup_mwait = false;
-		decoder->state.type = INTEL_PT_MWAIT_OP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
+		decoder->state.type |= INTEL_PT_MWAIT_OP;
 		decoder->state.mwait_payload = decoder->fup_mwait_payload;
 		ret = true;
 	}
 	if (decoder->set_fup_pwre) {
 		decoder->set_fup_pwre = false;
 		decoder->state.type |= INTEL_PT_PWR_ENTRY;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.pwre_payload = decoder->fup_pwre_payload;
 		ret = true;
 	}
 	if (decoder->set_fup_exstop) {
 		decoder->set_fup_exstop = false;
 		decoder->state.type |= INTEL_PT_EX_STOP;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
 		decoder->state.flags |= INTEL_PT_FUP_IP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		ret = true;
 	}
 	if (decoder->set_fup_bep) {
 		decoder->set_fup_bep = false;
 		decoder->state.type |= INTEL_PT_BLK_ITEMS;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
+		ret = true;
+	}
+	if (ret) {
 		decoder->state.from_ip = decoder->ip;
 		decoder->state.to_ip = 0;
-		ret = true;
+	} else {
+		decoder->state.type = type;
 	}
 	return ret;
 }
-- 
2.25.1

