Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88C1328A72
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239584AbhCASRt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:17:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239049AbhCASJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:09:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9348E65228;
        Mon,  1 Mar 2021 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619538;
        bh=zIg+Qe9TIv0hQEn3iWni0XiBhSiFqPMkzcMRBLatGE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBwNBqyZXj1+7hDP91Y11iPzvZI9Hd3JwkVRFnCOATqtYx2sIVDdz/ide8yUwjaYi
         4+LynMGKdWPnrUyWQKWDaICB/Tqh9suW1pZtCVFT13CK4dbJrdeMd4ca6OeNbV7EB2
         KiDvJSUmNiQJ07eBdWNGE2cT6mvC8Nw2VqIg8ewc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen Wandun <chenwandun@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 460/663] mm/hugetlb: suppress wrong warning info when alloc gigantic page
Date:   Mon,  1 Mar 2021 17:11:48 +0100
Message-Id: <20210301161204.632911509@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
index afe803dbcab1b..37672d8fa5c34 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2517,7 +2517,7 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 		if (hstate_is_gigantic(h)) {
 			if (hugetlb_cma_size) {
 				pr_warn_once("HugeTLB: hugetlb_cma is enabled, skip boot time allocation\n");
-				break;
+				goto free;
 			}
 			if (!alloc_bootmem_huge_page(h))
 				break;
@@ -2535,7 +2535,7 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
 			h->max_huge_pages, buf, i);
 		h->max_huge_pages = i;
 	}
-
+free:
 	kfree(node_alloc_noretry);
 }
 
-- 
2.27.0



