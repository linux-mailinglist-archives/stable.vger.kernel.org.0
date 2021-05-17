Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1F0383589
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbhEQPXD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:52808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243584AbhEQPRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:17:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B07836191A;
        Mon, 17 May 2021 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261996;
        bh=9tedimjvqebY2/nQf8qfexNUQRBqICQvIL6lPheRT3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kyV8DLMwuVt7BrmaXjO3FkMyyqsgQ7Uy2MZHDrSijWORk41fZyOptfDrNhb6In5s+
         RZNzLmP/aE3HDPC1RnfM2iKEqVSL7MtKFOkLQESTkt+U96rwxQbzysuC2LPVYEvWTe
         x3j9cEu3Lvq/uCG0qxSs4+vyiPPN1GQdre4DZgEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ebru Akagunduz <ebru.akagunduz@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 201/329] khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
Date:   Mon, 17 May 2021 16:01:52 +0200
Message-Id: <20210517140308.918899020@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 74e579bf231a337ab3786d59e64bc94f45ca7b3f ]

In writable and !referenced case, the result value should be
SCAN_LACK_REFERENCED_PAGE for trace_mm_collapse_huge_page_isolate()
instead of default 0 (SCAN_FAIL) here.

Link: https://lkml.kernel.org/r/20210306032947.35921-5-linmiaohe@huawei.com
Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 494d3cb0b58a..897b91c5f1d2 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -716,17 +716,17 @@ next:
 		if (pte_write(pteval))
 			writable = true;
 	}
-	if (likely(writable)) {
-		if (likely(referenced)) {
-			result = SCAN_SUCCEED;
-			trace_mm_collapse_huge_page_isolate(page, none_or_zero,
-							    referenced, writable, result);
-			return 1;
-		}
-	} else {
+
+	if (unlikely(!writable)) {
 		result = SCAN_PAGE_RO;
+	} else if (unlikely(!referenced)) {
+		result = SCAN_LACK_REFERENCED_PAGE;
+	} else {
+		result = SCAN_SUCCEED;
+		trace_mm_collapse_huge_page_isolate(page, none_or_zero,
+						    referenced, writable, result);
+		return 1;
 	}
-
 out:
 	release_pte_pages(pte, _pte, compound_pagelist);
 	trace_mm_collapse_huge_page_isolate(page, none_or_zero,
-- 
2.30.2



