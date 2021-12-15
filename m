Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D60475F25
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbhLOR2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343659AbhLOR0o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6A7C07E5E3;
        Wed, 15 Dec 2021 09:26:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F12361A08;
        Wed, 15 Dec 2021 17:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C84C36AE2;
        Wed, 15 Dec 2021 17:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589160;
        bh=PqqQmART0691xGxwedt0tQGrGlD6Xok4ZPFflHKlJJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j0EyjO2CHo5T1O0M/nE82+DDeAO/l2E/5Mjps0X7L0ZdseDxR9OGNREFfNoQJ+ee2
         lunwYEgknAqDUA9S4WcJBh0nOh5LaVL72CGRJoW0RI3fO7ckNvJWDYh62KenPX6UCr
         t7UnmGzzqZfNWD6xSgfZQ5ixnLFR28pA96NjDDs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 25/33] perf intel-pt: Fix state setting when receiving overflow (OVF) packet
Date:   Wed, 15 Dec 2021 18:21:23 +0100
Message-Id: <20211215172025.641797704@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
References: <20211215172024.787958154@linuxfoundation.org>
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
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   32 +++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1158,6 +1158,20 @@ static bool intel_pt_fup_event(struct in
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
@@ -1480,7 +1494,16 @@ static int intel_pt_overflow(struct inte
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
@@ -2083,6 +2106,7 @@ next:
 
 		case INTEL_PT_TIP_PGE: {
 			decoder->pge = true;
+			decoder->overflow = false;
 			intel_pt_mtc_cyc_cnt_pge(decoder);
 			if (decoder->packet.count == 0) {
 				intel_pt_log_at("Skipping zero TIP.PGE",
@@ -2596,10 +2620,10 @@ static int intel_pt_sync_ip(struct intel
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
@@ -2614,7 +2638,6 @@ static int intel_pt_sync_ip(struct intel
 		decoder->pkt_state = INTEL_PT_STATE_RESAMPLE;
 	else
 		decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
-	decoder->overflow = false;
 
 	decoder->state.from_ip = 0;
 	decoder->state.to_ip = decoder->ip;
@@ -2823,7 +2846,8 @@ const struct intel_pt_state *intel_pt_de
 
 	if (err) {
 		decoder->state.err = intel_pt_ext_err(err);
-		decoder->state.from_ip = decoder->ip;
+		if (err != -EOVERFLOW)
+			decoder->state.from_ip = decoder->ip;
 		intel_pt_update_sample_time(decoder);
 		decoder->sample_tot_cyc_cnt = decoder->tot_cyc_cnt;
 	} else {


