Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47C0471A4E
	for <lists+stable@lfdr.de>; Sun, 12 Dec 2021 14:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbhLLNIY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Dec 2021 08:08:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34354 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhLLNIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Dec 2021 08:08:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6966B80CA9
        for <stable@vger.kernel.org>; Sun, 12 Dec 2021 13:08:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31846C341C5;
        Sun, 12 Dec 2021 13:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639314501;
        bh=gKj2tnCw7FhSzSIIDoJJGgfXch1nqC5o6YIliUw3geE=;
        h=Subject:To:Cc:From:Date:From;
        b=ZJL3N4Tl4zWeE1YozGf/zqoeIKwlzeOiqQQ2fd/uHQGUSUj9CDA9esEAmNFSkvmPL
         hJT2H7nXEZ3J8KD0nOObwHJ76Oon/hDIwj+iaAek9YmmR8YfB2HHhT9VWkfPORPt7Z
         rg9Lpnfozme9hKhSGbj3HNenXgtsDVXu4CGSclaU=
Subject: FAILED: patch "[PATCH] perf intel-pt: Fix some PGE (packet generation enable/control" failed to apply to 5.10-stable tree
To:     adrian.hunter@intel.com, acme@redhat.com, jolsa@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 12 Dec 2021 14:08:18 +0100
Message-ID: <163931449854127@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 057ae59f5a1d924511beb1b09f395bdb316cfd03 Mon Sep 17 00:00:00 2001
From: Adrian Hunter <adrian.hunter@intel.com>
Date: Fri, 10 Dec 2021 18:22:57 +0200
Subject: [PATCH] perf intel-pt: Fix some PGE (packet generation enable/control
 flow packets) usage

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

diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index 5f83937bf8f3..6f6f163161a9 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2678,6 +2678,7 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 		return HOP_IGNORE;
 
 	case INTEL_PT_TIP_PGD:
+		decoder->pge = false;
 		if (!decoder->packet.count) {
 			intel_pt_set_nr(decoder);
 			return HOP_IGNORE;
@@ -2707,7 +2708,7 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 		intel_pt_set_ip(decoder);
 		if (intel_pt_fup_event(decoder))
 			return HOP_RETURN;
-		if (!decoder->branch_enable)
+		if (!decoder->branch_enable || !decoder->pge)
 			*no_tip = true;
 		if (*no_tip) {
 			decoder->state.type = INTEL_PT_INSTRUCTION;
@@ -2897,7 +2898,7 @@ static bool intel_pt_psb_with_fup(struct intel_pt_decoder *decoder, int *err)
 {
 	struct intel_pt_psb_info data = { .fup = false };
 
-	if (!decoder->branch_enable || !decoder->pge)
+	if (!decoder->branch_enable)
 		return false;
 
 	intel_pt_pkt_lookahead(decoder, intel_pt_psb_lookahead_cb, &data);
@@ -2999,7 +3000,7 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 				break;
 			}
 			intel_pt_set_last_ip(decoder);
-			if (!decoder->branch_enable) {
+			if (!decoder->branch_enable || !decoder->pge) {
 				decoder->ip = decoder->last_ip;
 				if (intel_pt_fup_event(decoder))
 					return 0;

