Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC97C475F0F
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbhLOR13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:27:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343861AbhLOR0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86401C07E5C1;
        Wed, 15 Dec 2021 09:25:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51A94B82047;
        Wed, 15 Dec 2021 17:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A64C36AE0;
        Wed, 15 Dec 2021 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589141;
        bh=0ovH+hXSGBAbQI4s0PnxEuc5eM6VSTgDxobveFB4+nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T66zZImQ8JbRSlDpMGr4qqKkreFYaXBc304ogOcvCD9NSYst0SB8EyUoaDFwnDS2h
         5QVewFKKB7VspytUjeeu3brCDtvi8tHZAwXXK6zWErbjD97exm1NftDR7l1mT1MDiI
         EGSaHqlwElmxV1AZwEHCP1H8Fozao+b+r3jPDZeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 27/33] perf intel-pt: Fix missing instruction events with q option
Date:   Wed, 15 Dec 2021 18:21:25 +0100
Message-Id: <20211215172025.709112854@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1954,6 +1954,8 @@ static int intel_pt_scan_for_psb(struct
 /* Hop mode: Ignore TNT, do not walk code, but get ip from FUPs and TIPs */
 static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, int *err)
 {
+	*err = 0;
+
 	/* Leap from PSB to PSB, getting ip from FUP within PSB+ */
 	if (decoder->leap && !decoder->in_psb && decoder->packet.type != INTEL_PT_PSB) {
 		*err = intel_pt_scan_for_psb(decoder);
@@ -1988,18 +1990,21 @@ static int intel_pt_hop_trace(struct int
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
 


