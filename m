Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0B371F1C2
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfEOLSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:18:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbfEOLSN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:18:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A63320843;
        Wed, 15 May 2019 11:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919093;
        bh=spzag9FA6PtrQsdcN8fGfgMmi8VIW4MnEbnxTDAdelg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MwoIbVhAFPE+K53+aLOyfj6SzY6pCGDVy/C8NUp0h01a4uxf4y9dO1gEqGNKxbyVZ
         B0354WmdST8dabgCIfVS+rDPWH+A5q+FX7YKfV4Kv+4FJHmws+JIuzAPB0I7RCOEvV
         Av615Ecnf/94cd97sFQx3VmRQgJ5Nv4hXBILqBIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 065/115] mm: introduce mm_[p4d|pud|pmd]_folded
Date:   Wed, 15 May 2019 12:55:45 +0200
Message-Id: <20190515090704.245581808@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1071fc5779d9846fec56a4ff6089ab08cac1ab72 ]

Add three architecture overrideable functions to test if the
p4d, pud, or pmd layer of a page table is folded or not.

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 include/asm-generic/pgtable.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index f00421dfacbd0..0c21014a38f23 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -1081,4 +1081,20 @@ static inline bool arch_has_pfn_modify_check(void)
 #endif
 #endif
 
+/*
+ * On some architectures it depends on the mm if the p4d/pud or pmd
+ * layer of the page table hierarchy is folded or not.
+ */
+#ifndef mm_p4d_folded
+#define mm_p4d_folded(mm)	__is_defined(__PAGETABLE_P4D_FOLDED)
+#endif
+
+#ifndef mm_pud_folded
+#define mm_pud_folded(mm)	__is_defined(__PAGETABLE_PUD_FOLDED)
+#endif
+
+#ifndef mm_pmd_folded
+#define mm_pmd_folded(mm)	__is_defined(__PAGETABLE_PMD_FOLDED)
+#endif
+
 #endif /* _ASM_GENERIC_PGTABLE_H */
-- 
2.20.1



