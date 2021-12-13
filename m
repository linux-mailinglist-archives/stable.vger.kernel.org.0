Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFEF2472959
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbhLMKUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242033AbhLMKSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:18:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3E8C0497F9;
        Mon, 13 Dec 2021 01:56:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7C24CE0E6F;
        Mon, 13 Dec 2021 09:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E60C34601;
        Mon, 13 Dec 2021 09:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389384;
        bh=D98Uz3WcAk1GhEV5TNn28KW03wEc0wzpn584VrHiP/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDHl2AUlyHvCGEQbRu6Jfaa4aiZPfz5dHDwCwslzFtW2axRkOd8U4CC4x6L+2jC/3
         mUnUBIPGPOoWEyWkqPGFNojA5TB0sETsjr0F8CzlMsks/AUVb3hwN/tkHc7f9gY/YP
         GGnxL66W035G4o4vxBK497BVVVg16kR8+ByV2szI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 081/171] perf intel-pt: Fix missing instruction events with q option
Date:   Mon, 13 Dec 2021 10:29:56 +0100
Message-Id: <20211213092947.787180383@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2682,6 +2682,8 @@ static int intel_pt_scan_for_psb(struct
 /* Hop mode: Ignore TNT, do not walk code, but get ip from FUPs and TIPs */
 static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, int *err)
 {
+	*err = 0;
+
 	/* Leap from PSB to PSB, getting ip from FUP within PSB+ */
 	if (decoder->leap && !decoder->in_psb && decoder->packet.type != INTEL_PT_PSB) {
 		*err = intel_pt_scan_for_psb(decoder);
@@ -2722,18 +2724,21 @@ static int intel_pt_hop_trace(struct int
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
 


