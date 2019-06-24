Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767D450877
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730409AbfFXKRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:17:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730957AbfFXKRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:17:24 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BAA1205C9;
        Mon, 24 Jun 2019 10:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561371443;
        bh=joX4oBxgWRfbTYhg0szXbGlMdRkBFd2o4j+rCTRn/x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xawQ68yENsmVl3rZNFD96qhvJV6X9rsrDEQFxn2ZaNKullWoQC/635w7HMAm6rSzX
         TyCkaJr2uKC7piN0MttcMXEIeJbNgtn6DXg+c6Q2ZcEsDm9ayr7KkhLlssNV8X+Fy4
         2kkQC1Op3dyBfCSfggmHn5J4Nkm3OOeSQL386eTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Palecek <jpalecek@web.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.1 104/121] KVM: x86/mmu: Allocate PAE root array when using SVMs 32-bit NPT
Date:   Mon, 24 Jun 2019 17:57:16 +0800
Message-Id: <20190624092326.022031366@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092320.652599624@linuxfoundation.org>
References: <20190624092320.652599624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit b6b80c78af838bef17501416d5d383fedab0010a upstream.

SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
is enabled, i.e. the PAE root array needs to be allocated.

Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
Cc: stable@vger.kernel.org
Reported-by: Jiri Palecek <jpalecek@web.de>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5591,14 +5591,18 @@ static int alloc_mmu_pages(struct kvm_vc
 	struct page *page;
 	int i;
 
-	if (tdp_enabled)
-		return 0;
-
 	/*
-	 * When emulating 32-bit mode, cr3 is only 32 bits even on x86_64.
-	 * Therefore we need to allocate shadow page tables in the first
-	 * 4GB of memory, which happens to fit the DMA32 zone.
+	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
+	 * while the PDP table is a per-vCPU construct that's allocated at MMU
+	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
+	 * x86_64.  Therefore we need to allocate the PDP table in the first
+	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
+	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
+	 * skip allocating the PDP table.
 	 */
+	if (tdp_enabled && kvm_x86_ops->get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
+		return 0;
+
 	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
 	if (!page)
 		return -ENOMEM;


