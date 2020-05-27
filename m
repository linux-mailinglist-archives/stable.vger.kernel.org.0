Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81B41E425E
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 14:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgE0Mcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 08:32:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:20409 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728337AbgE0Mcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 May 2020 08:32:43 -0400
IronPort-SDR: iNAQ9D7kTo/e+L8Bo9sbHyfc/RPtFSMS8/2zuhKtPd9aEyc48e3yQe3ebMOQ3LyXXqLXCaNG0a
 kSA/Eqlw3EsA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 05:32:43 -0700
IronPort-SDR: bC8ATACVYor4iaQNqvOb/bXKkpaisVzz0DtscTTSsjjhrpijO3/yplCe9GLymE5Q/NJE39TbmP
 7qAl9KeFHxLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,441,1583222400"; 
   d="scan'208";a="266819405"
Received: from otc-lr-04.jf.intel.com ([10.54.39.143])
  by orsmga003.jf.intel.com with ESMTP; 27 May 2020 05:32:43 -0700
From:   kan.liang@linux.intel.com
To:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc:     ak@linux.intel.com, Kan Liang <kan.liang@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] perf/x86/intel/uncore: Fix oops when counting IMC uncore events on some TGL
Date:   Wed, 27 May 2020 05:30:47 -0700
Message-Id: <1590582647-90675-1-git-send-email-kan.liang@linux.intel.com>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kan Liang <kan.liang@linux.intel.com>

When counting IMC uncore events on some TGL machines, an oops will be
triggered.
  [ 393.101262] BUG: unable to handle page fault for address:
  ffffb45200e15858
  [ 393.101269] #PF: supervisor read access in kernel mode
  [ 393.101271] #PF: error_code(0x0000) - not-present page

Current perf uncore driver still use the IMC MAP SIZE inherited from
SNB, which is 0x6000.
However, the offset of IMC uncore counters for some TGL machines is
larger than 0x6000, e.g. 0xd8a0.

Enlarge the IMC MAP SIZE for TGL to 0xe000.

Fixes: fdb64822443e ("perf/x86: Add Intel Tiger Lake uncore support")
Reported-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Ammy Yi <ammy.yi@intel.com>
Tested-by: Chao Qin <chao.qin@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Cc: stable@vger.kernel.org
---
 arch/x86/events/intel/uncore_snb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index 3de1065..1038e9f 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -1085,6 +1085,7 @@ static struct pci_dev *tgl_uncore_get_mc_dev(void)
 }
 
 #define TGL_UNCORE_MMIO_IMC_MEM_OFFSET		0x10000
+#define TGL_UNCORE_PCI_IMC_MAP_SIZE		0xe000
 
 static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 {
@@ -1112,7 +1113,7 @@ static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
 	addr |= ((resource_size_t)mch_bar << 32);
 #endif
 
-	box->io_addr = ioremap(addr, SNB_UNCORE_PCI_IMC_MAP_SIZE);
+	box->io_addr = ioremap(addr, TGL_UNCORE_PCI_IMC_MAP_SIZE);
 }
 
 static struct intel_uncore_ops tgl_uncore_imc_freerunning_ops = {
-- 
2.7.4

