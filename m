Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60440475F03
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245677AbhLOR0h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:26:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42410 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245596AbhLORZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC1BFB8202A;
        Wed, 15 Dec 2021 17:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FEFC36AE0;
        Wed, 15 Dec 2021 17:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589107;
        bh=CHSSIJqlJ9HAafhsYLM5PD7RElinICbrYQk+VkpXLX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQSKr8PCEAUP/ulqFVCF6bzukEC5fDN5u0i8Xz6UN6okEMkEPGdxR/TqCarrjhE57
         LIeDZavdT3/IKmPcZ5X+gvy9WwgY9lpA0QWcMlbkS72MmV6paUQ+xw55BAGrec+QRh
         j3ZpA8fGAA9r7VnSZ/DbzD572JGCGaD4lOZo9oic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 22/33] perf intel-pt: Fix some PGE (packet generation enable/control flow packets) usage
Date:   Wed, 15 Dec 2021 18:21:20 +0100
Message-Id: <20211215172025.532614710@linuxfoundation.org>
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
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1949,6 +1949,7 @@ static int intel_pt_hop_trace(struct int
 		return HOP_IGNORE;
 
 	case INTEL_PT_TIP_PGD:
+		decoder->pge = false;
 		if (!decoder->packet.count)
 			return HOP_IGNORE;
 		intel_pt_set_ip(decoder);
@@ -1972,7 +1973,7 @@ static int intel_pt_hop_trace(struct int
 		intel_pt_set_ip(decoder);
 		if (intel_pt_fup_event(decoder))
 			return HOP_RETURN;
-		if (!decoder->branch_enable)
+		if (!decoder->branch_enable || !decoder->pge)
 			*no_tip = true;
 		if (*no_tip) {
 			decoder->state.type = INTEL_PT_INSTRUCTION;
@@ -2124,7 +2125,7 @@ next:
 				break;
 			}
 			intel_pt_set_last_ip(decoder);
-			if (!decoder->branch_enable) {
+			if (!decoder->branch_enable || !decoder->pge) {
 				decoder->ip = decoder->last_ip;
 				if (intel_pt_fup_event(decoder))
 					return 0;


