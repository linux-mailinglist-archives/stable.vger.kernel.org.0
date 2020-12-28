Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660872E4322
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392441AbgL1Pdm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407420AbgL1NyS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:54:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25C822072C;
        Mon, 28 Dec 2020 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163642;
        bh=Vspq1NyWK5U2pSRKCUGnocBPT87eBJsEI+Tiu+wYztg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qve5cvE51mPKPwZv0xEuaaKmv/KnnhiDJpl6Jy/MefiXyQOsLp8QWIVS2MljjrBcU
         527fCIrxu1syteMxqzSAZG74wnud7DE/zCRUt881pB13+mpp30Bym4V2dN0g/tZoUQ
         mdEKG+Wi/KeNyQ6vszXuBGJxSL3tvrUrpXU//DEU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.4 357/453] perf/x86/intel: Fix rtm_abort_event encoding on Ice Lake
Date:   Mon, 28 Dec 2020 13:49:53 +0100
Message-Id: <20201228124954.386748663@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

commit 46b72e1bf4fc571da0c29c6fb3e5b2a2107a4c26 upstream.

According to the event list from icelake_core_v1.09.json, the encoding
of the RTM_RETIRED.ABORTED event on Ice Lake should be,
    "EventCode": "0xc9",
    "UMask": "0x04",
    "EventName": "RTM_RETIRED.ABORTED",

Correct the wrong encoding.

Fixes: 6017608936c1 ("perf/x86/intel: Add Icelake support")
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20201125213720.15692-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/events/intel/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -5058,7 +5058,7 @@ __init int intel_pmu_init(void)
 		extra_skl_attr = skl_format_attr;
 		mem_attr = icl_events_attrs;
 		tsx_attr = icl_tsx_events_attrs;
-		x86_pmu.rtm_abort_event = X86_CONFIG(.event=0xca, .umask=0x02);
+		x86_pmu.rtm_abort_event = X86_CONFIG(.event=0xc9, .umask=0x04);
 		x86_pmu.lbr_pt_coexist = true;
 		intel_pmu_pebs_data_source_skl(pmem);
 		pr_cont("Icelake events, ");


