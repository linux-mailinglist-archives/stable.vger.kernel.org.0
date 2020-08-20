Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD4724B2F9
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgHTJjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726923AbgHTJjm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:39:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3C07C20724;
        Thu, 20 Aug 2020 09:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916381;
        bh=kCwqB6Ovaix4fstCjpwfhLC6Ms9iQESqD6AeWDno2wU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDm63S0ciSxkmJaGmjdoClPR6GZJo/2ILuVCujIjHQqBq3IrrAQ2R28l+00JmKzCe
         mOcj5yed24Ep5+iAyLDKEkbKKEBluumBimUlT0HxqnaysK3VyTQyiCwbcHJhwPGGO2
         wxDUaIDD6+2Y7LShRGjqwqQ5cBVKbv7ZZZmW47Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.7 091/204] perf intel-pt: Fix FUP packet state
Date:   Thu, 20 Aug 2020 11:19:48 +0200
Message-Id: <20200820091610.879027405@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
@@ -1164,6 +1164,7 @@ static int intel_pt_walk_fup(struct inte
 			return 0;
 		if (err == -EAGAIN ||
 		    intel_pt_fup_with_nlip(decoder, &intel_pt_insn, ip, err)) {
+			decoder->pkt_state = INTEL_PT_STATE_IN_SYNC;
 			if (intel_pt_fup_event(decoder))
 				return 0;
 			return -EAGAIN;
@@ -1942,17 +1943,13 @@ next:
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
@@ -2599,15 +2596,11 @@ const struct intel_pt_state *intel_pt_de
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


