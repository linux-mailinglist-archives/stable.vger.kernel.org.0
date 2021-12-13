Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E2E4730D2
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbhLMPpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:45:55 -0500
Received: from mga14.intel.com ([192.55.52.115]:12921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240236AbhLMPpy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 10:45:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639410354; x=1670946354;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=FUbqqVPtb08Lb3KFOAe+I4WZMjTeEkF9NuBY6CX0x6s=;
  b=k54M/yTiCp0g66tCH41HyYyyQYmM2YDE34r+2oMO+G5DKwu1RgZn5w7i
   e+gdXJKESZlv03rlO0X/Xg0N0pCaYmFdn+LPDR0PW2eEEXPSHIJ1PKy/f
   JH8uv1XBuCO1f5HymzTGysRO+R5LkeNJ2vHOpX4RDFmk0orngy9ZE3YvY
   mNMjR21H5lXco0P0eTy3J9cHDQnEtvc3XNsGedwHINAQYDPix9TXLyeXJ
   ghMfZsQ88O4L32oj76Btp48lQ8SLELCSJwYJO8fUBtN2C0OKz+0sTJncc
   cC/KOc1B2UQLo2pZu+wJpQtK3ncnCmad4VbB2GL9OQQrIXYu70cp9TYY8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="238982227"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="238982227"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:45:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="660890492"
Received: from ahunter-desktop.fi.intel.com ([10.237.72.76])
  by fmsmga001.fm.intel.com with ESMTP; 13 Dec 2021 07:45:53 -0800
From:   Adrian Hunter <adrian.hunter@intel.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 3/8] perf intel-pt: Fix sync state when a PSB (synchronization) packet is found
Date:   Mon, 13 Dec 2021 17:45:43 +0200
Message-Id: <20211213154548.122728-4-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211213154548.122728-1-adrian.hunter@intel.com>
References: <20211213154548.122728-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit ad106a26aef3a95ac7ca88d033b431661ba346ce upstream.

When syncing, it may be that branch packet generation is not enabled at
that point, in which case there will not immediately be a control-flow
packet, so some packets before a control flow packet turns up, get
ignored.  However, the decoder is in sync as soon as a PSB is found, so
the state should be set accordingly.

Fixes: f4aa081949e7b6 ("perf tools: Add Intel PT decoder")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index a49122002768..83e54333f03c 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2733,7 +2733,7 @@ static int intel_pt_sync(struct intel_pt_decoder *decoder)
 		return err;
 
 	decoder->have_last_ip = true;
-	decoder->pkt_state = INTEL_PT_STATE_NO_IP;
+	decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 
 	err = intel_pt_walk_psb(decoder);
 	if (err)
-- 
2.25.1

