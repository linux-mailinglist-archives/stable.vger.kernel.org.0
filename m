Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D65C38A79C
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237359AbhETKkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237720AbhETKil (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:38:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA59D61C79;
        Thu, 20 May 2021 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504497;
        bh=MmVAgyYqHDI2wWDlWO1LQ2t08By/1j+dK10i4ZJa9Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKxJfttG6EQEfsDXzfWdvGi71xxjmheCHzS07M7iYLSICEpMRJpQGBSt157QUSaq2
         pJoyHsfla1PWD3hD3XkuCCUtXMn3I6aoEQHawYV2qkHOX0hX18UGLLjBjWXTeli4Ip
         b/mcLIktu2E+2Mz0ViyOI7sLlYTSbdCRvcfYSrtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        Feilong Lin <linfeilong@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 271/323] mm/hugeltb: handle the error case in hugetlb_fix_reserve_counts()
Date:   Thu, 20 May 2021 11:22:43 +0200
Message-Id: <20210520092129.517462862@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit da56388c4397878a65b74f7fe97760f5aa7d316b ]

A rare out of memory error would prevent removal of the reserve map region
for a page.  hugetlb_fix_reserve_counts() handles this rare case to avoid
dangling with incorrect counts.  Unfortunately, hugepage_subpool_get_pages
and hugetlb_acct_memory could possibly fail too.  We should correctly
handle these cases.

Link: https://lkml.kernel.org/r/20210410072348.20437-5-linmiaohe@huawei.com
Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Feilong Lin <linfeilong@huawei.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0f6959961f9a..777ad49dbd46 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -589,13 +589,20 @@ void hugetlb_fix_reserve_counts(struct inode *inode)
 {
 	struct hugepage_subpool *spool = subpool_inode(inode);
 	long rsv_adjust;
+	bool reserved = false;
 
 	rsv_adjust = hugepage_subpool_get_pages(spool, 1);
-	if (rsv_adjust) {
+	if (rsv_adjust > 0) {
 		struct hstate *h = hstate_inode(inode);
 
-		hugetlb_acct_memory(h, 1);
+		if (!hugetlb_acct_memory(h, 1))
+			reserved = true;
+	} else if (!rsv_adjust) {
+		reserved = true;
 	}
+
+	if (!reserved)
+		pr_warn("hugetlb: Huge Page Reserved count may go negative.\n");
 }
 
 /*
-- 
2.30.2



