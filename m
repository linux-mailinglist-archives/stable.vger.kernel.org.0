Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8B7475F07
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343665AbhLOR0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343672AbhLORZV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:25:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CEEC0698C5;
        Wed, 15 Dec 2021 09:25:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44795B8202B;
        Wed, 15 Dec 2021 17:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E170C36AE2;
        Wed, 15 Dec 2021 17:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589113;
        bh=lY58zCJaNfQ3ES7Jy6v+wdk9jJ5VOZ+EsXN8Z4hsOnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TxnIxxnx8M7iNxsSlOjTEw9CgoZ6qEG8VUS4VUJZwTQ/4sIFm3no9AdN3utN3I9I
         P+gCozabEokRBd3FEt/8Qjx9T5zVyE06INyC92mIUxkFLArOhaMwKDFNP2+Y0/inC2
         OR2sDVv1yJXsztA/83BsPjgaIzGQ47Ia4VD/uC5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 24/33] perf intel-pt: Fix intel_pt_fup_event() assumptions about setting state type
Date:   Wed, 15 Dec 2021 18:21:22 +0100
Message-Id: <20211215172025.599224706@linuxfoundation.org>
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
[Adrian: Backport to v5.10]
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/intel-pt-decoder/intel-pt-decoder.c |   32 ++++++++------------
 1 file changed, 13 insertions(+), 19 deletions(-)

--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -1114,61 +1114,55 @@ out_no_progress:
 
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


