Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D857138344F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242138AbhEQPHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242844AbhEQPEz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:04:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98AD7613DC;
        Mon, 17 May 2021 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261713;
        bh=ByS9iXcALeI+brcLf3XX7Xkj2GlzN6sNrjz7FtWpHB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zU2kvrVfDL5wp1jLagoKIOgvA7jzVGjwuGb9YNzhmx6AIDQm2Q7UKs8dNpCjkHgri
         5SwxDCuu2F2PEh76ycLh/e+3LPoAyyTu5nYKxnBVJqz3vH8KB/QR7FcLclmYfRpvrT
         OLoDuVBMaqP0cbunt6XT5RUgLAjqjbLm0XcBNo2Q=
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
Subject: [PATCH 5.4 080/141] khugepaged: fix wrong result value for trace_mm_collapse_huge_page_isolate()
Date:   Mon, 17 May 2021 16:02:12 +0200
Message-Id: <20210517140245.476454981@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140242.729269392@linuxfoundation.org>
References: <20210517140242.729269392@linuxfoundation.org>
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
index f0d7e6483ba3..3c2326568193 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -628,17 +628,17 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced++;
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
 	release_pte_pages(pte, _pte);
 	trace_mm_collapse_huge_page_isolate(page, none_or_zero,
-- 
2.30.2



