Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E441472957
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhLMKT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241481AbhLMKR4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:17:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45C1C0497F4;
        Mon, 13 Dec 2021 01:56:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F019B80E63;
        Mon, 13 Dec 2021 09:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C329EC34600;
        Mon, 13 Dec 2021 09:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389378;
        bh=7Fl0nG4ZzrhCTDDGPBd/Kju9NJ7czJi7vRS+X5RtIZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1hUAANHDTFE6n1tDvgwLoYFlATX7/B4a1bzfTFd3bs3/5EkeF49B6LAfMRz/jwko
         Kl6LpwTfbVr9Wvq7eAmMAvOLtiL1dWgZ6LgJ1U/UzpPJL7vpSRwYYbVOAm6dYmR3FV
         sSz27J0CoFktmdWUMc4QZaN9b24SXo7tdRubpD0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 079/171] perf intel-pt: Fix state setting when receiving overflow (OVF) packet
Date:   Mon, 13 Dec 2021 10:29:54 +0100
Message-Id: <20211213092947.724015549@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   32 +++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1248,6 +1248,20 @@ static bool intel_pt_fup_event(struct in
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
@@ -1601,7 +1615,16 @@ static int intel_pt_overflow(struct inte
 	intel_pt_clear_tx_flags(decoder);
 	intel_pt_set_nr(decoder);
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
@@ -2956,6 +2979,7 @@ next:
 
 		case INTEL_PT_TIP_PGE: {
 			decoder->pge = true;
+			decoder->overflow = false;
 			intel_pt_mtc_cyc_cnt_pge(decoder);
 			intel_pt_set_nr(decoder);
 			if (decoder->packet.count == 0) {
@@ -3461,10 +3485,10 @@ static int intel_pt_sync_ip(struct intel
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
@@ -3479,7 +3503,6 @@ static int intel_pt_sync_ip(struct intel
 		decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
 	else
 		decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
-	decoder->overflow = false;
 
 	decoder->state.from_ip = 0;
 	decoder->state.to_ip = decoder->ip;
@@ -3698,7 +3721,8 @@ const struct intel_pt_state *intel_pt_de
 
 	if (err) {
 		decoder->state.err = intel_pt_ext_err(err);
-		decoder->state.from_ip = decoder->ip;
+		if (err != -EOVERFLOW)
+			decoder->state.from_ip = decoder->ip;
 		intel_pt_update_sample_time(decoder);
 		decoder->sample_tot_cyc_cnt = decoder->tot_cyc_cnt;
 		intel_pt_set_nr(decoder);


