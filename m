Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB8A411553
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 15:14:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239242AbhITNPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 09:15:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31147 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239211AbhITNPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 09:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632143647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3D9PiBQJVXq8NLq+x3Q7qfcJGriH26GrYH+svjSDasY=;
        b=cBOga9eBpPIa3BAqtck/3HOCWgMYfTJ6h+SgboKLmZQH35rdOvqQRfLAvn45X++I9UVTkS
        hvPT3VND3xIoRaIrsmkmMPHQa61QYngHC7XU0CXJaAXLK6KeX2Sv5XrUitoWybDLneJVhy
        DZQDcnT0YvBAd67YylN0jPJ/1Xi19zk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-M8EYXhJDO0uHEAeuqzbzdw-1; Mon, 20 Sep 2021 09:14:05 -0400
X-MC-Unique: M8EYXhJDO0uHEAeuqzbzdw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FA018E5041;
        Mon, 20 Sep 2021 13:14:04 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.39.194.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0A3F5D9D5;
        Mon, 20 Sep 2021 13:14:02 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        David Hildenbrand <david@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 5.4 STABLE] s390/pci_mmio: fully validate the VMA before calling follow_pte()
Date:   Mon, 20 Sep 2021 15:14:01 +0200
Message-Id: <20210920131401.9043-1-david@redhat.com>
In-Reply-To: <163212811314091@kroah.com>
References: <163212811314091@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit a8b92b8c1eac8d655a97b1e90f4d83c25d9b9a18 upstream.

Note: We don't have vma_lookup() in the 5.4-stable tree, so perform the VMA
check manually.

We should not walk/touch page tables outside of VMA boundaries when
holding only the mmap sem in read mode. Evil user space can modify the
VMA layout just before this function runs and e.g., trigger races with
page table removal code since commit dd2283f2605e ("mm: mmap: zap pages
with read mmap_sem in munmap").

find_vma() does not check if the address is >= the VMA start address;
use vma_lookup() instead.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Fixes: dd2283f2605e ("mm: mmap: zap pages with read mmap_sem in munmap")
Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/pci/pci_mmio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
index 020a2c514d96..921f0fc12f1f 100644
--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -128,7 +128,7 @@ static long get_pfn(unsigned long user_addr, unsigned long access,
 	down_read(&current->mm->mmap_sem);
 	ret = -EINVAL;
 	vma = find_vma(current->mm, user_addr);
-	if (!vma)
+	if (!vma || user_addr < vma->vm_start)
 		goto out;
 	ret = -EACCES;
 	if (!(vma->vm_flags & access))
-- 
2.31.1

