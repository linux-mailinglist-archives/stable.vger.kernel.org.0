Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067392E3E0B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439204AbgL1OXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:56518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502204AbgL1OVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7041C229C5;
        Mon, 28 Dec 2020 14:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165222;
        bh=2M+Vy12sDbH78IIVup0knMteF/n3Wto5NcX6m56tYRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eSQUU0ImqqDtrBZ6WOIJQhVxm5HxnpkDqvEP3KPXrRyzWYcoLdMhmA8LdeO+9U1R6
         0zB4pI6QE1c1pkIV7swI7ETZHiNuZk8yDN/iJhrFpbuV2sm5dMp8A0FP7zgETWBhbT
         4cKuh7X21+7/e3t7sTQf7oeW2w+rnnrX/UNKt3Lc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Mina Almasry <almasrymina@google.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 456/717] hugetlb: fix an error code in hugetlb_reserve_pages()
Date:   Mon, 28 Dec 2020 13:47:34 +0100
Message-Id: <20201228125042.816491874@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 7fc2513aa237e2ce239ab54d7b04d1d79b317110 ]

Preserve the error code from region_add() instead of returning success.

Link: https://lkml.kernel.org/r/X9NGZWnZl5/Mt99R@mwanda
Fixes: 0db9d74ed884 ("hugetlb: disable region_add file_region coalescing")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/hugetlb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d029d938d26d6..3b38ea958e954 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5115,6 +5115,7 @@ int hugetlb_reserve_pages(struct inode *inode,
 
 		if (unlikely(add < 0)) {
 			hugetlb_acct_memory(h, -gbl_reserve);
+			ret = add;
 			goto out_put_pages;
 		} else if (unlikely(chg > add)) {
 			/*
-- 
2.27.0



