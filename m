Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6101CE0A0
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 18:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729895AbgEKQhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 12:37:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:63012 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbgEKQhK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 12:37:10 -0400
IronPort-SDR: bDuYwScvSgGwSR+ZuHGMyD44IqqdR1Xb2A0Z27lgwTJnzzGCnnHZ4vJzuwOUfuUBW1G3W0bTJd
 2ZZlk5NxTecQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2020 09:37:09 -0700
IronPort-SDR: sijoHt790+vCFbYL/z9FT3+IdRi7j0VEWF/XF8sCzvQZdM7rtakA6tUCpB/BM08D5J7XD2euE8
 037/dj0eI2kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,380,1583222400"; 
   d="scan'208";a="279837019"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 11 May 2020 09:37:07 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 7A70E16B; Mon, 11 May 2020 19:37:06 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     "Hansen, Dave" <dave.hansen@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Cc:     dave.hansen@linux.intel.com,
        linux-drivers-review@eclists.intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] x86/mm: Fix boot with some memory above MAXMEM
Date:   Mon, 11 May 2020 19:37:06 +0300
Message-Id: <20200511163706.41619-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A 5-level paging capable machine can have memory above 46-bit in the
physical address space. This memory is only addressable in the 5-level
paging mode: we don't have enough virtual address space to create direct
mapping for such memory in the 4-level paging mode.

Currently, we fail boot completely: NULL pointer dereference in
subsection_map_init().

Skip creating a memblock for such memory instead and notify user that
some memory is not addressable.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: stable@vger.kernel.org # v4.14
---

Tested with a hacked QEMU: https://gist.github.com/kiryl/d45eb54110944ff95e544972d8bdac1d

---
 arch/x86/kernel/e820.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c5399e80c59c..022fe1de8940 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1307,7 +1307,14 @@ void __init e820__memblock_setup(void)
 		if (entry->type != E820_TYPE_RAM && entry->type != E820_TYPE_RESERVED_KERN)
 			continue;
 
-		memblock_add(entry->addr, entry->size);
+		if (entry->addr >= MAXMEM || end >= MAXMEM)
+			pr_err_once("Some physical memory is not addressable in the paging mode.\n");
+
+		if (entry->addr >= MAXMEM)
+			continue;
+
+		end = min_t(u64, end, MAXMEM - 1);
+		memblock_add(entry->addr, end - entry->addr);
 	}
 
 	/* Throw away partial pages: */
-- 
2.26.2

