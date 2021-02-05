Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363B63102DB
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 03:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhBECef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 21:34:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230216AbhBECdx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 21:33:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B1564FBE;
        Fri,  5 Feb 2021 02:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1612492381;
        bh=b1DxOcOqwfE5+Jwl+Bfd1Px9tLz4gowrSr/e+e0TsdQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Q9AjBvrANEtR8x74nTbno+zIAGwrRnDCQ9TRa8n+1Ds4hb9TqC0iJgpbSXfzzgNHZ
         9yuhazaXDzVsM0sF+TUmTNXS2h4mnpQP6+84mdBsn+Mpot//0GirEZC2bcE1a8mFDH
         YAgZUT04hJk3i1YbVFaTnqvdtUNxXYIkqGEZq4qw=
Date:   Thu, 04 Feb 2021 18:33:00 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 17/18] mm: hugetlb: fix missing put_page in
 gather_surplus_pages()
Message-ID: <20210205023300.kuRDAAZIZ%akpm@linux-foundation.org>
In-Reply-To: <20210204183135.e123f0d6027529f2cf500cf2@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb: fix missing put_page in gather_surplus_pages()

The VM_BUG_ON_PAGE avoids the generation of any code, even if that
expression has side-effects when !CONFIG_DEBUG_VM.

Link: https://lkml.kernel.org/r/20210126031009.96266-1-songmuchun@bytedance.com
Fixes: e5dfacebe4a4 ("mm/hugetlb.c: just use put_page_testzero() instead of page_count()")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-missing-put_page-in-gather_surplus_pages
+++ a/mm/hugetlb.c
@@ -2047,13 +2047,16 @@ retry:
 
 	/* Free the needed pages to the hugetlb pool */
 	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
+		int zeroed;
+
 		if ((--needed) < 0)
 			break;
 		/*
 		 * This page is now managed by the hugetlb allocator and has
 		 * no users -- drop the buddy allocator's reference.
 		 */
-		VM_BUG_ON_PAGE(!put_page_testzero(page), page);
+		zeroed = put_page_testzero(page);
+		VM_BUG_ON_PAGE(!zeroed, page);
 		enqueue_huge_page(h, page);
 	}
 free:
_
