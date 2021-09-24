Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389AE4174C0
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346676AbhIXNKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346850AbhIXNIM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:08:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8A561501;
        Fri, 24 Sep 2021 12:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488232;
        bh=sCfloG5AdQTwhFh5cexuHdptoHrPbnwu1TRvesdMNlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvmgdwkg0LZTyGV5TVk8rybMp6eG4UGcYrUaFkUiVCIfOn2sxgXxoZxxq7Y7Dj/by
         lYExZ3AiRETYaPdgH45qvnj8+qCJNZhr+UXeDYLFwJFqeFnEbNA176A5uCcVfbmKA1
         Es0vKKsHTCOeQpIgBhN5eGD6jWfgn7s5Tkv19a/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.10 04/63] s390/pci_mmio: fully validate the VMA before calling follow_pte()
Date:   Fri, 24 Sep 2021 14:44:04 +0200
Message-Id: <20210924124334.381661941@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

commit a8b92b8c1eac8d655a97b1e90f4d83c25d9b9a18 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci_mmio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/pci/pci_mmio.c
+++ b/arch/s390/pci/pci_mmio.c
@@ -128,7 +128,7 @@ static long get_pfn(unsigned long user_a
 	mmap_read_lock(current->mm);
 	ret = -EINVAL;
 	vma = find_vma(current->mm, user_addr);
-	if (!vma)
+	if (!vma || user_addr < vma->vm_start)
 		goto out;
 	ret = -EACCES;
 	if (!(vma->vm_flags & access))


