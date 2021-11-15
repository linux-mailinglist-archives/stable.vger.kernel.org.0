Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26260451151
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243778AbhKOTD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:03:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243421AbhKOTA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:00:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7238163370;
        Mon, 15 Nov 2021 18:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000065;
        bh=y/gSMrKLjlxMnO6k+LUbNgvgew5YhU5qPX3YZMeuBXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qalATZjTlOpo0+3U3ancOKPIkNVCqDD3wjGUhfNj1BIOXffMAfbTojpMTP9GeP/gX
         V/vnBz6QZ3mQkPALvNpfswrS3Ee0HnKYXGbRQqvLLdpFifijcxl1COwSD+4bhQxme2
         ONNCzD87+6gn15hXu6nJu7V2CWj01T+MIwv7MvsY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 497/849] s390/gmap: validate VMA in __gmap_zap()
Date:   Mon, 15 Nov 2021 17:59:40 +0100
Message-Id: <20211115165437.094904886@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

[ Upstream commit 2d8fb8f3914b40e3cc12f8cbb74daefd5245349d ]

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap"). The pure prescence in our guest_to_host
radix tree does not imply that there is a VMA.

Further, we should not allocate page tables (via get_locked_pte()) outside
of VMA boundaries: if evil user space decides to map hugetlbfs to these
ranges, bad things will happen because we suddenly have PTE or PMD page
tables where we shouldn't have them.

Similarly, we have to check if we suddenly find a hugetlbfs VMA, before
calling get_locked_pte().

Note that gmap_discard() is different:
zap_page_range()->unmap_single_vma() makes sure to stay within VMA
boundaries.

Fixes: b31288fa83b2 ("s390/kvm: support collaborative memory management")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Link: https://lore.kernel.org/r/20210909162248.14969-2-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/gmap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 9bb2c7512cd54..b6b56cd4ca644 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -673,6 +673,7 @@ EXPORT_SYMBOL_GPL(gmap_fault);
  */
 void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 {
+	struct vm_area_struct *vma;
 	unsigned long vmaddr;
 	spinlock_t *ptl;
 	pte_t *ptep;
@@ -682,6 +683,11 @@ void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 						   gaddr >> PMD_SHIFT);
 	if (vmaddr) {
 		vmaddr |= gaddr & ~PMD_MASK;
+
+		vma = vma_lookup(gmap->mm, vmaddr);
+		if (!vma || is_vm_hugetlb_page(vma))
+			return;
+
 		/* Get pointer to the page table entry */
 		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
 		if (likely(ptep))
-- 
2.33.0



