Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D8D472954
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237022AbhLMKTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244574AbhLMKRL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:17:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A814C0497E4;
        Mon, 13 Dec 2021 01:56:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C762FCE0E82;
        Mon, 13 Dec 2021 09:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7539AC34600;
        Mon, 13 Dec 2021 09:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389367;
        bh=X7Qbl3Ji09JcxPVfblBas3GxuLgEJqpjYGpgA11SWaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsAGH4zjBw7G1l1Quam5Aj1VEvYqbzMslywG3+TrogdkyOBoXMnaJQ5ld8ApszNAp
         SvNhr/u+OfEvES2XycB26X3mzGoETAaGVVFGvxjg9NB1cRvmA65zdCoVwSNVN6J71A
         2sfzhivWJ4iqIpgIuM/SYCbDo8kLQXGcEk/YdH4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 076/171] perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage
Date:   Mon, 13 Dec 2021 10:29:51 +0100
Message-Id: <20211213092947.632630474@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -2677,6 +2677,7 @@ static int intel_pt_hop_trace(struct int
 		return HOP_IGNORE;
 
 	case INTEL_PT_TIP_PGD:
+		decoder->pge = false;
 		if (!decoder->packet.count) {
 			intel_pt_set_nr(decoder);
 			return HOP_IGNORE;
@@ -2706,7 +2707,7 @@ static int intel_pt_hop_trace(struct int
 		intel_pt_set_ip(decoder);
 		if (intel_pt_fup_event(decoder))
 			return HOP_RETURN;
-		if (!decoder->branch_enable)
+		if (!decoder->branch_enable || !decoder->pge)
 			*no_tip = true;
 		if (*no_tip) {
 			decoder->state.type = INTEL_PT_INSTRUCTION;
@@ -2896,7 +2897,7 @@ static bool intel_pt_psb_with_fup(struct
 {
 	struct intel_pt_psb_info data = { .fup = false };
 
-	if (!decoder->branch_enable || !decoder->pge)
+	if (!decoder->branch_enable)
 		return false;
 
 	intel_pt_pkt_lookahead(decoder, intel_pt_psb_lookahead_cb, &data);
@@ -2998,7 +2999,7 @@ next:
 				break;
 			}
 			intel_pt_set_last_ip(decoder);
-			if (!decoder->branch_enable) {
+			if (!decoder->branch_enable || !decoder->pge) {
 				decoder->ip = decoder->last_ip;
 				if (intel_pt_fup_event(decoder))
 					return 0;


