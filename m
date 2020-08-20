Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5185124B3F3
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgHTJyf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730136AbgHTJyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:54:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0516B2078D;
        Thu, 20 Aug 2020 09:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917270;
        bh=puvKffSzIc9VgFsOKv/Hz0j402nCyaacHYWMEmCK1R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N80iez1PpQ6PrcJ9/olia2zNr93tyXssHb+r3UtAX4srWPklmXLqvac7rO/G6N94J
         RHDzymRsaW1XZIHXPf/lkUfizrlnebkIaS9EE4V1S6VhKx/Dv3K+6XX6p3PXuAUycd
         HJIO6CcVkbDJApdejh99Oa4lhLmExIZmfJl9Hr5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.19 46/92] perf intel-pt: Fix FUP packet state
Date:   Thu, 20 Aug 2020 11:21:31 +0200
Message-Id: <20200820091540.059971103@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 401136bb084fd021acd9f8c51b52fe0a25e326b2 upstream.

While walking code towards a FUP ip, the packet state is
INTEL_PT_STATE_FUP or INTEL_PT_STATE_FUP_NO_TIP. That was mishandled
resulting in the state becoming INTEL_PT_STATE_IN_SYNC prematurely.  The
result was an occasional lost EXSTOP event.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20200710151104.15137-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   21 ++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1129,6 +1129,7 @@ static int intel_pt_walk_fup(struct inte
 			return 0;
 		if (err == -EAGAIN ||
 		    intel_pt_fup_with_nlip(decoder, &intel_pt_insn, ip, err)) {
+			decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 			if (intel_pt_fup_event(decoder))
 				return 0;
 			return -EAGAIN;
@@ -1780,17 +1781,13 @@ next:
 			}
 			if (decoder->set_fup_mwait)
 				no_tip = true;
+			if (no_tip)
+				decoder->pkt_state = INTEL_PT_STATE_FUP_NO_TIP;
+			else
+				decoder->pkt_state = INTEL_PT_STATE_FUP;
 			err = intel_pt_walk_fup(decoder);
-			if (err != -EAGAIN) {
-				if (err)
-					return err;
-				if (no_tip)
-					decoder->pkt_state =
-						INTEL_PT_STATE_FUP_NO_TIP;
-				else
-					decoder->pkt_state = INTEL_PT_STATE_FUP;
-				return 0;
-			}
+			if (err != -EAGAIN)
+				return err;
 			if (no_tip) {
 				no_tip = false;
 				break;
@@ -2375,15 +2372,11 @@ const struct intel_pt_state *intel_pt_de
 			err = intel_pt_walk_tip(decoder);
 			break;
 		case INTEL_PT_STATE_FUP:
-			decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 			err = intel_pt_walk_fup(decoder);
 			if (err == -EAGAIN)
 				err = intel_pt_walk_fup_tip(decoder);
-			else if (!err)
-				decoder->pkt_state = INTEL_PT_STATE_FUP;
 			break;
 		case INTEL_PT_STATE_FUP_NO_TIP:
-			decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 			err = intel_pt_walk_fup(decoder);
 			if (err == -EAGAIN)
 				err = intel_pt_walk_trace(decoder);


