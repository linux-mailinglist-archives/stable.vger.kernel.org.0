Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE1322872A
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 19:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728368AbgGURTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 13:19:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:33363 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbgGURTn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 13:19:43 -0400
IronPort-SDR: NK83jBbBRBvaPCgweqgTTRJuBmuQ8WIGPLEVOhNgcu9z2S1lT1mU6+SQc7zWjPAL7l/f6DWBaK
 aKB8blZE1blQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="149351506"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="149351506"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 10:19:42 -0700
IronPort-SDR: BqgF9hrBfkHCAN1kY138RiDbd7aQA0SOW0mh9dByeLRCVIghw2e+cRDg6ng/tKzeFwM6zhShvq
 yhYMIM8Ad1eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="287992446"
Received: from awvttdev-05.aw.intel.com ([10.228.212.156])
  by orsmga006.jf.intel.com with ESMTP; 21 Jul 2020 10:19:41 -0700
From:   "Michael J. Ruhl" <michael.j.ruhl@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v2] io-mapping: Indicate mapping failure
Date:   Tue, 21 Jul 2020 13:19:36 -0400
Message-Id: <20200721171936.81563-1-michael.j.ruhl@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The !ATOMIC_IOMAP version of io_maping_init_wc will always return
success, even when the ioremap fails.

Since the ATOMIC_IOMAP version returns NULL when the init fails, and
callers check for a NULL return on error this is unexpected.

During a device probe, where the ioremap failed, a crash can look
like this:

BUG: unable to handle page fault for address: 0000000000210000
 #PF: supervisor write access in kernel mode
 #PF: error_code(0x0002) - not-present page
 Oops: 0002 [#1] PREEMPT SMP
 CPU: 0 PID: 177 Comm:
 RIP: 0010:fill_page_dma [i915]
  gen8_ppgtt_create [i915]
  i915_ppgtt_create [i915]
  intel_gt_init [i915]
  i915_gem_init [i915]
  i915_driver_probe [i915]
  pci_device_probe
  really_probe
  driver_probe_device

The remap failure occurred much earlier in the probe.  If it had
been propagated, the driver would have exited with an error.

Return NULL on ioremap failure.

Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata about the io-mapping")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
---
v2: reflect review comments
---
 include/linux/io-mapping.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index 0beaa3eba155..5641e06cbcf7 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -118,7 +118,7 @@ io_mapping_init_wc(struct io_mapping *iomap,
 	iomap->prot = pgprot_noncached(PAGE_KERNEL);
 #endif
 
-	return iomap;
+	return iomap->iomem ? iomap : NULL;
 }
 
 static inline void
-- 
2.21.0

