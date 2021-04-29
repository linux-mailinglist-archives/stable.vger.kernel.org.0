Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A0636EAE8
	for <lists+stable@lfdr.de>; Thu, 29 Apr 2021 14:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhD2MyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Apr 2021 08:54:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:11855 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234525AbhD2MyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Apr 2021 08:54:15 -0400
IronPort-SDR: 0hwqmv5Hi/0vCIlos3YlnFLNj6Yojgn1QF6c015l/FhZ+cKD7/7fsFW/hx2I5COhstg46fTgSo
 MCYl4VgWfMwA==
X-IronPort-AV: E=McAfee;i="6200,9189,9969"; a="197095517"
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="197095517"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2021 05:53:28 -0700
IronPort-SDR: thExY5aU6hQgRe8YyBeSi1f7Z1iT70remflRSPWIgCnsDbJ0X9W2a5x5fmgOSvHbah5qNrxBXA
 nfmsNyuiXoKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,259,1613462400"; 
   d="scan'208";a="526931258"
Received: from otc-lr-04.jf.intel.com ([10.54.39.41])
  by fmsmga001.fm.intel.com with ESMTP; 29 Apr 2021 05:53:28 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, yao.jin@linux.intel.com,
        Kan Liang <kan.liang@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel/uncore: Fix M2M event umask for Ice Lake server
Date:   Thu, 29 Apr 2021 05:45:28 -0700
Message-Id: <1619700328-142999-1-git-send-email-kan.liang@linux.intel.com>
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

