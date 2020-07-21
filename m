Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7322281BE
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgGUORN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 10:17:13 -0400
Received: from mga04.intel.com ([192.55.52.120]:29078 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgGUORN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Jul 2020 10:17:13 -0400
IronPort-SDR: Psbhnp0O3tlXXDxnsreZNhifxxbYrVK5qEj2zLFKVcqXs/NYGooxAR9LIKGlfHHiMXnU8FOZHz
 L5TsFxW0Dn6Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="147632826"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="147632826"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 07:17:04 -0700
IronPort-SDR: kUGuur520vYHG+MsEvUzPNTsy0P8FILd150pEgw4W2aUP/1TtgNEEq2xqkMVXbXHtjI4yDZJ/f
 VnIqoj7BHqUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="432011539"
Received: from awvttdev-05.aw.intel.com ([10.228.212.156])
  by orsmga004.jf.intel.com with ESMTP; 21 Jul 2020 07:17:03 -0700
From:   "Michael J. Ruhl" <michael.j.ruhl@intel.com>
To:     dri-devel@lists.freedesktop.org
Cc:     "Michael J. Ruhl" <michael.j.ruhl@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Subject: [PATCH] io-mapping: Indicate mapping failure
Date:   Tue, 21 Jul 2020 10:16:41 -0400
Message-Id: <20200721141641.81112-2-michael.j.ruhl@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200721141641.81112-1-michael.j.ruhl@intel.com>
References: <20200721141641.81112-1-michael.j.ruhl@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sometimes it is good to know when your mapping failed.

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

