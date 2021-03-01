Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0846C3290E4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242939AbhCAURG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239625AbhCAUGB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:06:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5461E64F35;
        Mon,  1 Mar 2021 17:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621531;
        bh=NiRobg7LEud42Oe4WTKalEPV8tErAbwJtSjaGnhFykQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xEHw+3fsFe2fwqWwfRmfDdT9tA4hFAhBBk0Qu/+Ieq0DwCWaqfHJfRNrA8fSqQ4QZ
         6UuH8QhHnYhtTK2JqiAOdifOGF1skQg2M+EXEjuKtbvlJF/FdfnWd/4wyRaIF4fODL
         czkFoKGy94fpcEP4DbsILpA0KreeQ10y3ojHBzB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Wandun <chenwandun@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 550/775] mm/hugetlb: suppress wrong warning info when alloc gigantic page
Date:   Mon,  1 Mar 2021 17:11:58 +0100
Message-Id: <20210301161228.669320348@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Wandun <chenwandun@huawei.com>

[ Upstream commit 7ecc956551f8a66618f71838c790a9b0b4f9ca10 ]

If hugetlb_cma is enabled, it will skip boot time allocation when
allocating gigantic page, that doesn't means allocation failure, so
suppress this warning info.

Link: https://lkml.kernel.org/r/20210219123909.13130-1-chenwandun@huawei.com
Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Signed-off-by: Chen Wandun <chenwandun@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index bc61eea60e07e..63d15f0a6629f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2520,7 +2520,7 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 		if (hstate_is_gigantic(h)) {
 			if (hugetlb_cma_size) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
-				break;
+				goto free;
 			}
 			if (!alloc_bootmem_huge_page(h))
 				break;
@@ -2538,7 +2538,7 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 			h->max_huge_pages, buf, i);
 		h->max_huge_pages = i;
 	}
-
+free:
 	kfree(node_alloc_noretry);
 }
 
-- 
2.27.0



