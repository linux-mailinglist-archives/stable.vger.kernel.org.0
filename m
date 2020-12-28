Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92EE2E4336
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407442AbgL1PeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406836AbgL1NvW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D8542078D;
        Mon, 28 Dec 2020 13:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163442;
        bh=PtsGilMsqqnIUnbF4ZI8utMPFpYi3J+fOF9BQC63OH8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PhCJm/KDaS8g1DuDppPmZKaT4EneM5s0hYNBBmjeOSqRLNIwDaPc+H+EzLz5zRlZX
         NXM1rMiDKp1Bb+C2YXVt0ig0M+QeHNOfJmBI5f32olcSbRJ/NMMtKLCmVMAaG8ZujN
         8XT9QQPN77VGGhGp2MTo3uzRse7XlXS1YCGGAfjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        David Hildenbrand <david@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 288/453] sparc: fix handling of page table constructor failure
Date:   Mon, 28 Dec 2020 13:48:44 +0100
Message-Id: <20201228124951.066117916@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 06517c9a336f4c20f2064611bf4b1e7881a95fe1 ]

The page has just been allocated, so its refcount is 1.  free_unref_page()
is for use on pages which have a zero refcount.  Use __free_page() like
the other implementations of pte_alloc_one().

Link: https://lkml.kernel.org/r/20201125034655.27687-1-willy@infradead.org
Fixes: 1ae9ae5f7df7 ("sparc: handle pgtable_page_ctor() fail")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/mm/init_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index e6d91819da921..28b9ffd85db0b 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2904,7 +2904,7 @@ pgtable_t pte_alloc_one(struct mm_struct *mm)
 	if (!page)
 		return NULL;
 	if (!pgtable_pte_page_ctor(page)) {
-		free_unref_page(page);
+		__free_page(page);
 		return NULL;
 	}
 	return (pte_t *) page_address(page);
-- 
2.27.0



