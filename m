Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F2E47DF2B
	for <lists+stable@lfdr.de>; Thu, 23 Dec 2021 07:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhLWGwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Dec 2021 01:52:01 -0500
Received: from mga05.intel.com ([192.55.52.43]:51973 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232658AbhLWGwB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 Dec 2021 01:52:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640242321; x=1671778321;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ETlPicAg5K5TzwnAcel8FfoloJM1jW6cl1eerFKA0cY=;
  b=ACMqpc/M4uzXFo+YUnptQop1FgVELVkVyz50+PhT1ehi2RHFpBW/CFT0
   eB2VodYuSia4EH0NeOEuwpE52eqWntNejW07LwQ2EvqPsj7MGvrNJGqxG
   0gG29g0NyesVmZIOYHjqzfFiQGN/DdgDSqUNKHradHM8g+meC9sHMx3cM
   HrmZFEspdf+nmuGBZH8WHWJyGFyWRW6voFKuSsofJtIaq896+9lcJbf+X
   xsf1+C5fZ0t1vO3NnU4Ph97svNAax36ENPxytJCk16fTuoBs+PSvX0wwX
   Zz+X0D5HXEEPdtEK5TaFnQjDkkoLxmtzyY8iiQtGiqBKrgA2IxqtNNpi1
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="327078023"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="327078023"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 22:52:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="664497944"
Received: from zxingrtx.sh.intel.com ([10.239.159.110])
  by fmsmga001.fm.intel.com with ESMTP; 22 Dec 2021 22:51:58 -0800
From:   zhengjun.xing@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     adrian.hunter@intel.com, alexander.shishkin@intel.com,
        ak@linux.intel.com, kan.liang@linux.intel.com,
        zhengjun.xing@linux.intel.com, stable@vger.kernel.org
Subject: [PATCH v4] perf/x86/intel/uncore: Fix CAS_COUNT_WRITE issue for ICX
Date:   Thu, 23 Dec 2021 22:48:26 +0800
Message-Id: <20211223144826.841267-1-zhengjun.xing@linux.intel.com>
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

3rd Gen Intel® Xeon® Processor Scalable Family, Codename Ice Lake,Uncore
Performance Monitoring Reference Manual, Revision 1.00, May 2021

On 2.4.7, it defines Unit Masks for CAS_COUNT:
RD b00001111
WR b00110000

So corrected both "cas_count_read" and "cas_count_write" for ICX.

Old settings:
 hswep_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x03")
 	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x0c")

New settings:
 snr_uncore_imc_events
	INTEL_UNCORE_EVENT_DESC(cas_count_read,  "event=0x04,umask=0x0f")
	INTEL_UNCORE_EVENT_DESC(cas_count_write, "event=0x04,umask=0x30")

Fixes: 2b3b76b5ec67 ("perf/x86/intel/uncore: Add Ice Lake server uncore support")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Zhengjun Xing <zhengjun.xing@linux.intel.com>
Cc: stable@vger.kernel.org
---
Change log:
  
  v4:
    * update commit log as Kan's suggestion

  v3:
    * Add change log

  v2:
    * Add stable tag

 arch/x86/events/intel/uncore_snbep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index 3660f698fb2a..ed869443efb2 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -5482,7 +5482,7 @@ static struct intel_uncore_type icx_uncore_imc = {
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

