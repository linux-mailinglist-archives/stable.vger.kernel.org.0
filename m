Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72242F40BE
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392307AbhAMAnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 19:43:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:46322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391968AbhALXu1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 18:50:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD03123139;
        Tue, 12 Jan 2021 23:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1610495365;
        bh=b+3gkIN/yT6h9cR5rTkrcLipzEFh8B9c3SsIlge72q0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wRQnWKIh+9FT9rqI5HZ8+bqtylRzHs8Hpedgany/k0hfSFyjJ8fX2JITJ68syr6RS
         O7EJPP3CN1sz2FOpWbJGQjqLaRDFUl1CTVe7hixiOO+1IkEv/WoARNF4mwexXMArOA
         qxyqH+zIVSVhGtNQequli/oT46ZjQon2aBmGoK5U=
Date:   Tue, 12 Jan 2021 15:49:24 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 07/10] mm/hugetlb: fix potential missing huge page
 size info
Message-ID: <20210112234924.NrJbRP05o%akpm@linux-foundation.org>
In-Reply-To: <20210112154839.abeb6e57de79480059fd9b0e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix potential missing huge page size info

The huge page size is encoded for VM_FAULT_HWPOISON errors only.  So if we
return VM_FAULT_HWPOISON, huge page size would just be ignored.

Link: https://lkml.kernel.org/r/20210107123449.38481-1-linmiaohe@huawei.com
Fixes: aa50d3a7aa81 ("Encode huge page size for VM_FAULT_HWPOISON errors")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-potential-missing-huge-page-size-info
+++ a/mm/hugetlb.c
@@ -4371,7 +4371,7 @@ retry:
 		 * So we need to block hugepage fault by PG_hwpoison bit check.
 		 */
 		if (unlikely(PageHWPoison(page))) {
-			ret = VM_FAULT_HWPOISON |
+			ret = VM_FAULT_HWPOISON_LARGE |
 				VM_FAULT_SET_HINDEX(hstate_index(h));
 			goto backout_unlocked;
 		}
_
