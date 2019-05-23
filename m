Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58BD428824
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389965AbfEWTWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390457AbfEWTW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:22:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73A43206BA;
        Thu, 23 May 2019 19:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639346;
        bh=bKs5VgwY2UPSlE56fRRjQSE74HLtE6QYQqPNJaat+zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfCGG482b89jW2oVSegbOSLqt0iNdILHyjDT2o+A+LKx6XX5lDPCkAFJ30/wZCma+
         cOlWJ15DWdaUZ6twrHEJ4B3VK3RIMBPodiF2HY0omyO37rZL/BIvpyDdPKXckTE6mc
         UznQ/QrRZVEcVy3KxFAoXrnlQTdmpHjtm/446gO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.0 071/139] perf intel-pt: Fix improved sample timestamp
Date:   Thu, 23 May 2019 21:05:59 +0200
Message-Id: <20190523181730.057077359@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181720.120897565@linuxfoundation.org>
References: <20190523181720.120897565@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 61b6e08dc8e3ea80b7485c9b3f875ddd45c8466b upstream.

The decoder uses its current timestamp in samples. Usually that is a
timestamp that has already passed, but in some cases it is a timestamp
for a branch that the decoder is walking towards, and consequently
hasn't reached.

The intel_pt_sample_time() function decides which is which, but was not
handling TNT packets exactly correctly.

In the case of TNT, the timestamp applies to the first branch, so the
decoder must first walk to that branch.

That means intel_pt_sample_time() should return true for TNT, and this
patch makes that change. However, if the first branch is a non-taken
branch (i.e. a 'N'), then intel_pt_sample_time() needs to return false
for subsequent taken branches in the same TNT packet.

To handle that, introduce a new state INTEL_PT_STATE_TNT_CONT to
distinguish the cases.

Note that commit 3f04d98e972b5 ("perf intel-pt: Improve sample
timestamp") was also a stable fix and appears, for example, in v4.4
stable tree as commit a4ebb58fd124 ("perf intel-pt: Improve sample
timestamp").

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v4.4+
Fixes: 3f04d98e972b5 ("perf intel-pt: Improve sample timestamp")
Link: http://lkml.kernel.org/r/20190510124143.27054-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -58,6 +58,7 @@ enum intel_pt_pkt_state {
 	INTEL_PT_STATE_NO_IP,
 	INTEL_PT_STATE_ERR_RESYNC,
 	INTEL_PT_STATE_IN_SYNC,
+	INTEL_PT_STATE_TNT_CONT,
 	INTEL_PT_STATE_TNT,
 	INTEL_PT_STATE_TIP,
 	INTEL_PT_STATE_TIP_PGD,
@@ -72,8 +73,9 @@ static inline bool intel_pt_sample_time(
 	case INTEL_PT_STATE_NO_IP:
 	case INTEL_PT_STATE_ERR_RESYNC:
 	case INTEL_PT_STATE_IN_SYNC:
-	case INTEL_PT_STATE_TNT:
+	case INTEL_PT_STATE_TNT_CONT:
 		return true;
+	case INTEL_PT_STATE_TNT:
 	case INTEL_PT_STATE_TIP:
 	case INTEL_PT_STATE_TIP_PGD:
 	case INTEL_PT_STATE_FUP:
@@ -1261,7 +1263,9 @@ static int intel_pt_walk_tnt(struct inte
 				return -ENOENT;
 			}
 			decoder->tnt.count -= 1;
-			if (!decoder->tnt.count)
+			if (decoder->tnt.count)
+				decoder->pkt_state = INTEL_PT_STATE_TNT_CONT;
+			else
 				decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 			decoder->tnt.payload <<= 1;
 			decoder->state.from_ip = decoder->ip;
@@ -1292,7 +1296,9 @@ static int intel_pt_walk_tnt(struct inte
 
 		if (intel_pt_insn.branch == INTEL_PT_BR_CONDITIONAL) {
 			decoder->tnt.count -= 1;
-			if (!decoder->tnt.count)
+			if (decoder->tnt.count)
+				decoder->pkt_state = INTEL_PT_STATE_TNT_CONT;
+			else
 				decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 			if (decoder->tnt.payload & BIT63) {
 				decoder->tnt.payload <<= 1;
@@ -2372,6 +2378,7 @@ const struct intel_pt_state *intel_pt_de
 			err = intel_pt_walk_trace(decoder);
 			break;
 		case INTEL_PT_STATE_TNT:
+		case INTEL_PT_STATE_TNT_CONT:
 			err = intel_pt_walk_tnt(decoder);
 			if (err == -EAGAIN)
 				err = intel_pt_walk_trace(decoder);


