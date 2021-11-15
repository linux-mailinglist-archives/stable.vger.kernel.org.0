Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E0245237A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352534AbhKPB0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:26:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:35156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243462AbhKOTCt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5FDD563356;
        Mon, 15 Nov 2021 18:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000089;
        bh=UkKDnI/2sD2BhxshoTIRAMHl11HvhuvGnrps7NsJGCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6wSsHJqzh4ImkfXhiWT0PrkfVI6OcYQkNIROd4zwNmFvj4LylzMWVvdofgPEppRE
         haZH1VzIKAcg/u/RPmsYvBxCCy+80FxsESL8IvboDlLMGhsajWpIllaF7JgxW+dWYT
         nyNDK45ZhM+Np3qNy0V6C9EUFbpdn98eaQF5UIKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 501/849] s390/uv: fully validate the VMA before calling follow_page()
Date:   Mon, 15 Nov 2021 17:59:44 +0100
Message-Id: <20211115165437.228216417@linuxfoundation.org>
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

[ Upstream commit 46c22ffd2772201662350bc7b94b9ea9d3ee5ac2 ]

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap").

find_vma() does not check if the address is >= the VMA start address;
use vma_lookup() instead.

Fixes: 214d9bbcd3a6 ("s390/mm: provide memory management functions for protected KVM guests")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Link: https://lore.kernel.org/r/20210909162248.14969-6-david@redhat.com
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/uv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index aeb0a15bcbb71..193205fb27774 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -227,7 +227,7 @@ again:
 	uaddr = __gmap_translate(gmap, gaddr);
 	if (IS_ERR_VALUE(uaddr))
 		goto out;
-	vma = find_vma(gmap->mm, uaddr);
+	vma = vma_lookup(gmap->mm, uaddr);
 	if (!vma)
 		goto out;
 	/*
-- 
2.33.0



