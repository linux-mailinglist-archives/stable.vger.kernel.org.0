Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37F82472739
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbhLMJ7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42552 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238253AbhLMJ4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:56:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8C69B80E0B;
        Mon, 13 Dec 2021 09:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6C8C34602;
        Mon, 13 Dec 2021 09:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389375;
        bh=M+1Rc5sJ3BOtysrc1i6I3r4oOlfDqi3KbDChLa3HcUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X5uf26pTgjmOcrCfMow1NdTJVce+OOpDRq8pEQ7PBw4mS49yNX2lqptSahsidq9AJ
         MkZ0ITj4DvH19PjxuZbrgCZtkFKHOprR8qtTvtfYjlCxbmSjROb2U2IJ9Tc+64RHVq
         9PQhOOCiQYje3Kuy7pHE8Y8/QpckmhZW15qLoK/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 078/171] perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type
Date:   Mon, 13 Dec 2021 10:29:53 +0100
Message-Id: <20211213092947.693912232@linuxfoundation.org>
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

commit 4c761d805bb2d2ead1b9baaba75496152b394c80 upstream.

intel_pt_fup_event() assumes it can overwrite the state type if there has
been an FUP event, but this is an unnecessary and unexpected constraint on
callers.

Fix by touching only the state type flags that are affected by an FUP
event.

Fixes: a472e65fc490a ("perf intel-pt: Add decoder support for ptwrite and power event packets")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v5.15+
Link: https://lore.kernel.org/r/20211210162303.2288710-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   32 ++++++++------------
 1 file changed, 13 insertions(+), 19 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1204,61 +1204,55 @@ out_no_progress:
 
 static bool intel_pt_fup_event(struct intel_pt_decoder *decoder)
 {
+	enum intel_pt_sample_type type = decoder->state.type;
 	bool ret = false;
 
+	decoder->state.type &= ~INTEL_PT_BRANCH;
+
 	if (decoder->set_fup_tx_flags) {
 		decoder->set_fup_tx_flags = false;
 		decoder->tx_flags = decoder->fup_tx_flags;
-		decoder->state.type = INTEL_PT_TRANSACTION;
+		decoder->state.type |= INTEL_PT_TRANSACTION;
 		if (decoder->fup_tx_flags & INTEL_PT_ABORT_TX)
 			decoder->state.type |= INTEL_PT_BRANCH;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.flags = decoder->fup_tx_flags;
-		return true;
+		ret = true;
 	}
 	if (decoder->set_fup_ptw) {
 		decoder->set_fup_ptw = false;
-		decoder->state.type = INTEL_PT_PTW;
+		decoder->state.type |= INTEL_PT_PTW;
 		decoder->state.flags |= INTEL_PT_FUP_IP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.ptw_payload = decoder->fup_ptw_payload;
-		return true;
+		ret = true;
 	}
 	if (decoder->set_fup_mwait) {
 		decoder->set_fup_mwait = false;
-		decoder->state.type = INTEL_PT_MWAIT_OP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
+		decoder->state.type |= INTEL_PT_MWAIT_OP;
 		decoder->state.mwait_payload = decoder->fup_mwait_payload;
 		ret = true;
 	}
 	if (decoder->set_fup_pwre) {
 		decoder->set_fup_pwre = false;
 		decoder->state.type |= INTEL_PT_PWR_ENTRY;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		decoder->state.pwre_payload = decoder->fup_pwre_payload;
 		ret = true;
 	}
 	if (decoder->set_fup_exstop) {
 		decoder->set_fup_exstop = false;
 		decoder->state.type |= INTEL_PT_EX_STOP;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
 		decoder->state.flags |= INTEL_PT_FUP_IP;
-		decoder->state.from_ip = decoder->ip;
-		decoder->state.to_ip = 0;
 		ret = true;
 	}
 	if (decoder->set_fup_bep) {
 		decoder->set_fup_bep = false;
 		decoder->state.type |= INTEL_PT_BLK_ITEMS;
-		decoder->state.type &= ~INTEL_PT_BRANCH;
+		ret = true;
+	}
+	if (ret) {
 		decoder->state.from_ip = decoder->ip;
 		decoder->state.to_ip = 0;
-		ret = true;
+	} else {
+		decoder->state.type = type;
 	}
 	return ret;
 }


