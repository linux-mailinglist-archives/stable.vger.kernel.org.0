Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DA645C03C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346138AbhKXNFy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:05:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:44406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348102AbhKXND4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:03:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29B6361A6E;
        Wed, 24 Nov 2021 12:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757420;
        bh=8J6bT5pek6VJ12qMbJWWZz0T9BJtoS0aaqlkQLRmvQk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Yomhx709Sn+9fc37WjWjpXmsVdC0uzAGW6rv9y7e8nE/k4TXPyZdSOxm8VYw3LTq
         BCTKz41Etkdw+1syxzExI3ObXTdv1wcUvMvpd1f103ieQ4JvXTaAHHecJ3+vrZ4a89
         LPPlD7nuRJ/iwstX4hhpOA6tnw1uCg7VyHtWGEIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/323] s390/gmap: dont unconditionally call pte_unmap_unlock() in __gmap_zap()
Date:   Wed, 24 Nov 2021 12:55:53 +0100
Message-Id: <20211124115724.438579495@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit b159f94c86b43cf7e73e654bc527255b1f4eafc4 ]

... otherwise we will try unlocking a spinlock that was never locked via a
garbage pointer.

At the time we reach this code path, we usually successfully looked up
a PGSTE already; however, evil user space could have manipulated the VMA
layout in the meantime and triggered removal of the page table.

Fixes: 1e133ab296f3 ("s390/mm: split arch/s390/mm/pgtable.c")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-3-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 7cde0f2f52e14..65ccb9d797270 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -684,9 +684,10 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 		vmaddr |= gaddr & ~PMD_MASK;
 		/* Get pointer to the page table entry */
 		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
-		if (likely(ptep))
+		if (likely(ptep)) {
 			ptep_zap_unused(gmap->mm, vmaddr, ptep, 0);
-		pte_unmap_unlock(ptep, ptl);
+			pte_unmap_unlock(ptep, ptl);
+		}
 	}
 }
 EXPORT_SYMBOL_GPL(__gmap_zap);
-- 
2.33.0



