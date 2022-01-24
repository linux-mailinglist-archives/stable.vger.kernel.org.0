Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2636498B45
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346321AbiAXTMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345122AbiAXTJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:09:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E948C08C5C5;
        Mon, 24 Jan 2022 11:02:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF5E8B8119D;
        Mon, 24 Jan 2022 19:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1933BC340E5;
        Mon, 24 Jan 2022 19:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050926;
        bh=aDFoXBfXTkfoNdAUutnNPz0dvkoSMcKTMdxDWksInsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q6e4S11eXMhSJCVmeaL4dOJIAAQf+7vvXJQZ4/EQCXTxvCZVTM9LWWZyHh0fENWqD
         /CXwRqw2rrTGfxCFsO/aV91cA6q7xz23a1pW6TJmduy7b/4ZJAJ+DfCslK4bO8QR47
         5RZzFxA4QCkBiy1VDDs3foHhsI/AHC6g/8GPnoTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 157/157] KVM: do not allow mapping valid but non-reference-counted pages
Date:   Mon, 24 Jan 2022 19:44:07 +0100
Message-Id: <20220124183937.735989252@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183932.787526760@linuxfoundation.org>
References: <20220124183932.787526760@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 virt/kvm/kvm_main.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1513,6 +1513,13 @@ static bool vma_is_valid(struct vm_area_
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
@@ -1562,13 +1569,21 @@ static int hva_to_pfn_remapped(struct vm
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


