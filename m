Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 364241631E3
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgBRUDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgBRUDV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA15B21D56;
        Tue, 18 Feb 2020 20:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056200;
        bh=wodGM8W2lZ3V+l7YnowsX037qcTzS6mHOEXUUECqf9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uDicv9P0OzMcv6VLhZvnXkDkR2PyFYlbvOQUN6h0tAkZXmdBuEhjqq8LJKEwrtRrJ
         Kk0WiRyVcR05q19yzxZzcLjK09PkZ5jMILglyXFjqZ1K5PvTufxKS0aOk/xqNi26qB
         LvGftjOYyV5010oT9Mf7sEtc2upIafqwmc3WrNac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.5 36/80] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging
Date:   Tue, 18 Feb 2020 20:54:57 +0100
Message-Id: <20200218190435.889374913@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit f6ab0107a4942dbf9a5cf0cca3f37e184870a360 upstream.

Define PT_MAX_FULL_LEVELS as PT64_ROOT_MAX_LEVEL, i.e. 5, to fix shadow
paging for 5-level guest page tables.  PT_MAX_FULL_LEVELS is used to
size the arrays that track guest pages table information, i.e. using a
"max levels" of 4 causes KVM to access garbage beyond the end of an
array when querying state for level 5 entries.  E.g. FNAME(gpte_changed)
will read garbage and most likely return %true for a level 5 entry,
soft-hanging the guest because FNAME(fetch) will restart the guest
instead of creating SPTEs because it thinks the guest PTE has changed.

Note, KVM doesn't yet support 5-level nested EPT, so PT_MAX_FULL_LEVELS
gets to stay "4" for the PTTYPE_EPT case.

Fixes: 855feb673640 ("KVM: MMU: Add 5 level EPT & Shadow page table support.")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/mmu/paging_tmpl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -33,7 +33,7 @@
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
 	#ifdef CONFIG_X86_64
-	#define PT_MAX_FULL_LEVELS 4
+	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 	#define CMPXCHG cmpxchg
 	#else
 	#define CMPXCHG cmpxchg64


