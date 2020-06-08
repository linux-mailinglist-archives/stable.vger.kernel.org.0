Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0051F195C
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 14:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729867AbgFHMys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 08:54:48 -0400
Received: from mga07.intel.com ([134.134.136.100]:24195 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729850AbgFHMyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 08:54:36 -0400
IronPort-SDR: snJx6xfWjuoPNWsFzf7tHGIShaueZ2tltCofjzLLzm6y+UgjCNosoFSPv0oY+OjV/rYGKSuug6
 Od+7CZt2ATFg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 05:54:35 -0700
IronPort-SDR: 1b8quhAFTc0jTTKs/rYqChdSLNXYuK3WRXwZzr9Psx945UHNW9hL4q5aATK7R5VRm2CTBOEsrw
 gwZgyTA08fxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,487,1583222400"; 
   d="scan'208";a="270496420"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga003.jf.intel.com with ESMTP; 08 Jun 2020 05:54:31 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id B8D1D25A; Mon,  8 Jun 2020 15:54:30 +0300 (EEST)
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Dan Williams <dan.j.williams@intel.com>,
        Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, stable@vger.kernel.org
Subject: [PATCHv2 2/2] x86/boot/KASLR: Fix boot with some memory above MAXMEM
Date:   Mon,  8 Jun 2020 15:54:24 +0300
Message-Id: <20200608125424.70198-3-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.27.0.rc2
In-Reply-To: <20200608125424.70198-1-kirill.shutemov@linux.intel.com>
References: <20200608125424.70198-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

A 5-level paging capable machine can have memory above 46-bit in the
physical address space. This memory is only addressable in the 5-level
paging mode: we don't have enough virtual address space to create direct
mapping for such memory in the 4-level paging mode

Teach KASLR to avoid memory regions above MAXMEM or truncate the region
if the end is above MAXMEM.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Dave Hansen <dave.hansen@intel.com>
Cc: stable@vger.kernel.org # v4.14
---
 arch/x86/boot/compressed/kaslr.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index d7408af55738..99db18eeb40e 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -695,7 +695,18 @@ static bool process_mem_region(struct mem_vector *region,
 			       unsigned long long minimum,
 			       unsigned long long image_size)
 {
+	unsigned long long end;
 	int i;
+
+	/* Cannot access memory region above MAXMEM: skip it. */
+	if (region->start >= MAXMEM)
+		return 0;
+
+	/* Truncate the region if the end is above MAXMEM */
+	end = region->start + region->size;
+	end = min_t(unsigned long long, end, MAXMEM - 1);
+	region->size = end - region->start;
+
 	/*
 	 * If no immovable memory found, or MEMORY_HOTREMOVE disabled,
 	 * use @region directly.
-- 
2.26.2

