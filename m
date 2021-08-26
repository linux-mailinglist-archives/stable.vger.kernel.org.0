Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E553F8B25
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 17:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbhHZPgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 11:36:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:41889 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232350AbhHZPgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 11:36:49 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="303345468"
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="303345468"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 08:36:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,353,1620716400"; 
   d="scan'208";a="426824678"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2021 08:36:00 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     eranian@google.com, ak@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH 1/7] perf/x86/intel/uncore: Support extra IMC channel on Ice Lake server
Date:   Thu, 26 Aug 2021 08:32:37 -0700
Message-Id: <1629991963-102621-2-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1629991963-102621-1-git-send-email-kan.liang@linux.intel.com>
References: <1629991963-102621-1-git-send-email-kan.liang@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

There are three channels on a Ice Lake server, but only two channels
will ever be active. Current perf only enables two channels.

Support the extra IMC channel, which may be activated on some Ice Lake
machines. For a non-activated channel, the SW can still access it. The
write will be ignored by the HW. 0 is always returned for the reading.

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---

The patch is a RESEND patch. The original post can be found at

https://lore.kernel.org/lkml/1625766302-18875-1-git-send-email-kan.liang@linux.intel.com

 arch/x86/events/intel/uncore_snbep.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/antler/uncore_snbep.c
index 9a178a9..72a4181 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -452,7 +452,7 @@
 #define ICX_M3UPI_PCI_PMON_BOX_CTL		0xa0
 
 /* ICX IMC */
-#define ICX_NUMBER_IMC_CHN			2
+#define ICX_NUMBER_IMC_CHN			3
 #define ICX_IMC_MEM_STRIDE			0x4
 
 /* SPR */
@@ -5458,7 +5458,7 @@ static struct intel_uncore_ops icx_uncore_mmio_ops = {
 static struct intel_uncore_type icx_uncore_imc = {
 	.name		= "imc",
 	.num_counters   = 4,
-	.num_boxes	= 8,
+	.num_boxes	= 12,
 	.perf_ctr_bits	= 48,
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
-- 
2.7.4

