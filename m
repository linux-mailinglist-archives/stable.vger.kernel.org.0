Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E450B163164
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgBRUAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:00:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728228AbgBRUAC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:00:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A872F20659;
        Tue, 18 Feb 2020 20:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056002;
        bh=0jem6XZ66gE+dB+u/Ocyu8cRj6OtJjD6/+Lb9cXcejI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kg7SFLSXQe6HBoeXWXahGLoCjtivhA7yFUAELrg+dE8wLl7u0KEfg143dMPCAFLT+
         vEzuOjkWx9EB+6iSB13/fcaG8jCt4e0mG/CmNohHu/nPPjJavSUw08yYg528e1T8D3
         9QQoC6ejhxB+ODRUt30FnD+BehiEeZ1oXeKX0jFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 64/66] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level paging
Date:   Tue, 18 Feb 2020 20:55:31 +0100
Message-Id: <20200218190434.149508774@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190428.035153861@linuxfoundation.org>
References: <20200218190428.035153861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit f6ab0107a4942dbf9a5cf0cca3f37e184870a360 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/paging_tmpl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index c1d7b866a03fa..4e3f137ffa8c8 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -33,7 +33,7 @@
 	#define PT_GUEST_ACCESSED_SHIFT PT_ACCESSED_SHIFT
 	#define PT_HAVE_ACCESSED_DIRTY(mmu) true
 	#ifdef CONFIG_X86_64
-	#define PT_MAX_FULL_LEVELS 4
+	#define PT_MAX_FULL_LEVELS PT64_ROOT_MAX_LEVEL
 	#define CMPXCHG cmpxchg
 	#else
 	#define CMPXCHG cmpxchg64
-- 
2.20.1



