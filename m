Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A323345557E
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 08:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243484AbhKRHaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 02:30:24 -0500
Received: from mga04.intel.com ([192.55.52.120]:13004 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243448AbhKRHaW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Nov 2021 02:30:22 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="232853645"
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="232853645"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 23:27:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,243,1631602800"; 
   d="scan'208";a="473056553"
Received: from zxingrtx.sh.intel.com ([10.239.159.110])
  by orsmga002.jf.intel.com with ESMTP; 17 Nov 2021 23:27:10 -0800
From:   zhengjun.xing@linux.intel.com
To:     zhengjun.xing@intel.com
Cc:     zhengjun.xing@linux.intel.com,
        Adrian Hunter <adrian.hunter@intel.com>, stable@vger.kernel.org
Subject: [PATCH v2] perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX
Date:   Thu, 18 Nov 2021 23:24:38 +0800
Message-Id: <20211118152438.329322-1-zhengjun.xing@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhengjun Xing <zhengjun.xing@linux.intel.com>

The user recently report a perf issue in the ICX platform, when test by
perf event “uncore_imc_x/cas_count_write”,the write bandwidth is always
very small (only 0.38MB/s), it is caused by the wrong "umask" for the
"cas_count_write" event. When double-checking, find "cas_count_read"
also is wrong.

The public document for ICX uncore:

https://www.intel.com/content/www/us/en/develop/download/3rd-gen-intel-xeon-processor-scalable-uncore-pm.html

On page 142, Table 2-143, defines Unit Masks for CAS_COUNT:
RD b00001111
WR b00110000

So Corrected both "cas_count_read" and "cas_count_write" for ICX.

Old settings:
 hswep_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03")
 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c")

New settings:
 snr_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x0f")
	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x30"),

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/uncore_snbep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 5ddc0f30db6f..a6fd8eb410a9 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5468,7 +5468,7 @@ static struct intel_uncore_type icx_uncore_imc = {
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNR_IMC_MMIO_PMON_FIXED_CTR,
 	.fixed_ctl	= SNR_IMC_MMIO_PMON_FIXED_CTL,
-	.event_descs	= hswep_uncore_imc_events,
+	.event_descs	= snr_uncore_imc_events,
 	.perf_ctr	= SNR_IMC_MMIO_PMON_CTR0,
 	.event_ctl	= SNR_IMC_MMIO_PMON_CTL0,
 	.event_mask	= SNBEP_PMON_RAW_EVENT_MASK,
-- 
2.25.1

