Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0479446BB68
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 13:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhLGMjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 07:39:31 -0500
Received: from mga03.intel.com ([134.134.136.65]:38649 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236437AbhLGMja (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Dec 2021 07:39:30 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237507403"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237507403"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 04:36:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="563498915"
Received: from srpawnik.iind.intel.com ([10.223.107.57])
  by fmsmga008.fm.intel.com with ESMTP; 07 Dec 2021 04:35:57 -0800
From:   Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
To:     srinivas.pandruvada@linux.intel.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, rui.zhang@intel.com, amitk@kernel.org,
        linux-pm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        sumeet.r.pawnikar@intel.com
Subject: [PATCH] thermal/drivers/int340x: fix: update VCoRefLow MMIO bit offset for read
Date:   Tue,  7 Dec 2021 18:05:39 +0530
Message-Id: <20211207123539.17346-1-sumeet.r.pawnikar@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As part of RFIM validation, found that the register definition VCoRefLow
of the CPU FIVR registers are different. Current implementation reads it
from MMIO offset 0x5A18 and bit offset [12:14]. But the actual correct
register definition is from bit offset [11:13]. Updated to the correct
bit offset.

Fixes: 473be51142ad ("thermal: int340x: processor_thermal: Add RFIM driver")
Signed-off-by: Sumeet Pawnikar <sumeet.r.pawnikar@intel.com>
Cc: stable@vger.kernel.org # 5.14+
---
 drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
index b25b54d4bac1..e693ec8234fb 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_rfim.c
@@ -29,7 +29,7 @@ static const char * const fivr_strings[] = {
 };
 
 static const struct mmio_reg tgl_fivr_mmio_regs[] = {
-	{ 0, 0x5A18, 3, 0x7, 12}, /* vco_ref_code_lo */
+	{ 0, 0x5A18, 3, 0x7, 11}, /* vco_ref_code_lo */
 	{ 0, 0x5A18, 8, 0xFF, 16}, /* vco_ref_code_hi */
 	{ 0, 0x5A08, 8, 0xFF, 0}, /* spread_spectrum_pct */
 	{ 0, 0x5A08, 1, 0x1, 8}, /* spread_spectrum_clk_enable */
-- 
2.17.1

