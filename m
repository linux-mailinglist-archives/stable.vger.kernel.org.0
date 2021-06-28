Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959EA3B6039
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 16:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233509AbhF1OWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 10:22:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233360AbhF1OWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Jun 2021 10:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 622A361C85;
        Mon, 28 Jun 2021 14:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624889971;
        bh=28MqFK9ZR2biYJTwRTGET7oweFewTLLKfnJZe7WOuyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOJLZG/wqH3RkuOHtcFkTO9WL4V7eOE3A8u85ut+B5EQy4kFbkDZ8b9UdOHqNwLYz
         XXpInd4H/eAlQZ6s7nsJT8XrXUfZQCyzh0KPc6S0UnU0e4OvZJS/HFEAvlQl8VO4Of
         +7iAwQt7Fnw9ABYrMZZH5GxgKwlyYFienp/dxy09BURnfd2Ry6T1pqTjNFHYLfrarI
         LUor2hmd2a9x6iEXrpGF3s2/l+Iosfat+AXHcymr2SvVVdGn5c1Yg8bO5y3D0MgCt0
         35V2ao4Vg2C8in5YVqIWxdW77TXkPU4FIl5T6yh3dU6sSrEFGRhgLNHzF/H0AKKcfs
         1Cm64ia0/bdjA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.12 073/110] KVM: do not allow mapping valid but non-reference-counted pages
Date:   Mon, 28 Jun 2021 10:17:51 -0400
Message-Id: <20210628141828.31757-74-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210628141828.31757-1-sashal@kernel.org>
References: <20210628141828.31757-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.14-rc1
X-KernelTest-Deadline: 2021-06-30T14:18+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit f8be156be163a052a067306417cd0ff679068c97 upstream.

It's possible to create a region which maps valid but non-refcounted
pages (e.g., tail pages of non-compound higher order allocations). These
host pages can then be returned by gfn_to_page, gfn_to_pfn, etc., family
of APIs, which take a reference to the page, which takes it from 0 to 1.
When the reference is dropped, this will free the page incorrectly.

Fix this by only taking a reference on valid pages if it was non-zero,
which indicates it is participating in normal refcounting (and can be
released with put_page).

This addresses CVE-2021-22543.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5cabc6c748db..4cce5735271e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1919,6 +1919,13 @@ static bool vma_is_valid(struct vm_area_struct *vma, bool write_fault)
 	return true;
 }
 
+static int kvm_try_get_pfn(kvm_pfn_t pfn)
+{
+	if (kvm_is_reserved_pfn(pfn))
+		return 1;
+	return get_page_unless_zero(pfn_to_page(pfn));
+}
+
 static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       unsigned long addr, bool *async,
 			       bool write_fault, bool *writable,
@@ -1968,13 +1975,21 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 	 * Whoever called remap_pfn_range is also going to call e.g.
 	 * unmap_mapping_range before the underlying pages are freed,
 	 * causing a call to our MMU notifier.
+	 *
+	 * Certain IO or PFNMAP mappings can be backed with valid
+	 * struct pages, but be allocated without refcounting e.g.,
+	 * tail pages of non-compound higher order allocations, which
+	 * would then underflow the refcount when the caller does the
+	 * required put_page. Don't allow those pages here.
 	 */ 
-	kvm_get_pfn(pfn);
+	if (!kvm_try_get_pfn(pfn))
+		r = -EFAULT;
 
 out:
 	pte_unmap_unlock(ptep, ptl);
 	*p_pfn = pfn;
-	return 0;
+
+	return r;
 }
 
 /*
-- 
2.30.2

