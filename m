Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88FE93C4B13
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbhGLGza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240468AbhGLGxz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:53:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5964E61132;
        Mon, 12 Jul 2021 06:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072664;
        bh=DpnsFo1fJOdU/+vDl7CWEJqYMAoi5zUg+uU01kTWEAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v+0QgC+bSvA1kYjflcb2ygAWjzGMIucPKW8xhaEo9FaOnlEhrl+IwnzOtJ6g7NWup
         Fyqw1FefMdst1vCKSN79fikUVB3mBw2T1haJTkV+taERIo0CYHeUrOlC+h5a57fCn3
         CWT4LaSEhuI4jGbItYDUo3ob/EvTPEilFOn5fhSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 566/593] mm/hugetlb: use helper huge_page_order and pages_per_huge_page
Date:   Mon, 12 Jul 2021 08:12:06 +0200
Message-Id: <20210712060957.055904365@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit c78a7f3639932c48b4e1d329fc80fd26aa1a2fa3 ]

Since commit a5516438959d ("hugetlb: modular state for hugetlb page
size"), we can use huge_page_order to access hstate->order and
pages_per_huge_page to fetch the pages per huge page.  But
gather_bootmem_prealloc() forgot to use it.

Link: https://lkml.kernel.org/r/20210114114435.40075-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d4f89c2f9544..991b5cd40267 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2500,7 +2500,7 @@ static void __init gather_bootmem_prealloc(void)
 		struct hstate *h = m->hstate;
 
 		WARN_ON(page_count(page) != 1);
-		prep_compound_huge_page(page, h->order);
+		prep_compound_huge_page(page, huge_page_order(h));
 		WARN_ON(PageReserved(page));
 		prep_new_huge_page(h, page, page_to_nid(page));
 		put_page(page); /* free it into the hugepage allocator */
@@ -2512,7 +2512,7 @@ static void __init gather_bootmem_prealloc(void)
 		 * side-effects, like CommitLimit going negative.
 		 */
 		if (hstate_is_gigantic(h))
-			adjust_managed_page_count(page, 1 << h->order);
+			adjust_managed_page_count(page, pages_per_huge_page(h));
 		cond_resched();
 	}
 }
-- 
2.30.2



