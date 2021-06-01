Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E7397405
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbhFANYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 09:24:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:55365 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233758AbhFANYh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Jun 2021 09:24:37 -0400
IronPort-SDR: 5KRgAcjBQP/pMPsK6xP+ZytWrRvIBkkgXILCaGJokVnkSb653tBp5pQsI3qpL75qQYmSPQV0R4
 pusH6h3N2pwA==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="190898394"
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="190898394"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2021 06:22:55 -0700
IronPort-SDR: zoZrPeCi2RqaKqMQe4XN6qCjPMuv7NY+eqP1ba1oRMp8iUgijhuNjcmdCqRsdl3v8dovdwUeRu
 kCzY7rS9CUCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,240,1616482800"; 
   d="scan'208";a="549058306"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga004.jf.intel.com with ESMTP; 01 Jun 2021 06:22:55 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, yao.jin@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [RESEND PATCH] perf/x86/intel/uncore: Fix M2M event umask for Ice Lake server
Date:   Tue,  1 Jun 2021 06:09:03 -0700
Message-Id: <1622552943-119174-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

Perf tool errors out with the latest event list for the Ice Lake server.

event syntax error: 'unc_m2m_imc_reads.to_pmm'
                           \___ value too big for format, maximum is 255

The same as the Snow Ridge server, the M2M uncore unit in the Ice Lake
server has the unit mask extension field as well.

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Reported-by: Jin Yao <yao.jin@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/uncore_snbep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index acc3c0e5..06c055d 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5106,9 +5106,10 @@ static struct intel_uncore_type icx_uncore_m2m = {
 	.perf_ctr	= SNR_M2M_PCI_PMON_CTR0,
 	.event_ctl	= SNR_M2M_PCI_PMON_CTL0,
 	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
+	.event_mask_ext	= SNR_M2M_PCI_PMON_UMASK_EXT,
 	.box_ctl	= SNR_M2M_PCI_PMON_BOX_CTL,
 	.ops		= &snr_m2m_uncore_pci_ops,
-	.format_group	= &skx_uncore_format_group,
+	.format_group	= &snr_m2m_uncore_format_group,
 };
 
 static struct attribute *icx_upi_uncore_formats_attr[] = {
-- 
2.7.4

