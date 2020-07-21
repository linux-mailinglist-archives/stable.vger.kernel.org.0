Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13992283E4
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 17:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUPeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 11:34:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:43740 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbgGUPeo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 11:34:44 -0400
IronPort-SDR: E3VfYQOM1AzrdHNmHnoTtvXetjiIMwNoKZqRC21gg1p+EwBp1nuWWEyRCZ8T9mxYjUBDBJi5PB
 hvW3ijZVLkRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="168297491"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="168297491"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 08:34:43 -0700
IronPort-SDR: wHglbF5x5PyjdIyWNZNfB5iI89F+BqEcfsL60nl0itNDur3qx0ej+FYMGwWFrWKzCYEL0EDZ9c
 ZCEL9eopH6xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="271747921"
Received: from awvttdev-05.aw.intel.com ([10.228.212.156])
  by fmsmga008.fm.intel.com with ESMTP; 21 Jul 2020 08:34:43 -0700
From:   "Michael J. Ruhl" <michael.j.ruhl@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH v1] io-mapping: Indicate mapping failure
Date:   Tue, 21 Jul 2020 11:34:26 -0400
Message-Id: <20200721153426.81239-2-michael.j.ruhl@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200721153426.81239-1-michael.j.ruhl@intel.com>
References: <20200721153426.81239-1-michael.j.ruhl@intel.com>
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

Return NULL on ioremap failure.

Fixes: cafaf14a5d8f ("io-mapping: Always create a struct to hold metadata about the io-mapping"
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@vger.kernel.org
Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
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

