Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2941C161B5A
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbgBQTOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:14:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53807 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgBQTOn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:14:43 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 78CDA21B2F;
        Mon, 17 Feb 2020 14:14:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZqQQel
        g1XVDJu+p45f5D+9EfT9b/SsJHqqRh3pmAeGQ=; b=yRytWni+JSO/aO37B7c9ea
        ctuXY4u9POgmjGJoeZFv2xu6ZfE0naJUw/mmon8pCsXqNTPdrklKWx6HCFvQwQHV
        9omXnJxoac/+COYz6LOCoqlO5iKOLE/KMhokxhUYPR2x3GYdvXg3Ht1wdfUiFHS+
        q7l1yB7KaZRnomftGq0X90tEhOXVPJu231d4bFUnvLg62NsJC65mw2lxOl2e8gGu
        zSIhmwJaJKsuTQDnedDP/l5rwp2mKicCdKhorMaIafGEOaRUA9f9hsGI8SLUQbWt
        jCP0Qh3pTSbs3GytPYAN6AyLYj/RNW9BysO7bvZ2KJLfhWLC6EOXVCd44el+mJIg
        ==
X-ME-Sender: <xms:IuZKXsiE6ScYLEjXmi6lM5F0UKgysan2Hj2TuQpoepsN1vpxasmjMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpeefne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:IuZKXtIKGM_V3fmfpjusLaWbFT6KBB-4iLq8hSXp1VNW_POtxnUWWA>
    <xmx:IuZKXjlVJqYj-jfvMsZxaLWHa04R7s1UYUYmxzj2ZPffq-R-Oe99lg>
    <xmx:IuZKXtP92X_RqhnZwdsL4oWlLFwuiY5uxDt5CG_Suw-2d5M4B9tTiQ>
    <xmx:IuZKXiGQOan46c_HxP8VCsm3kr4z32LHHCdcGXaUvdVL7xtQTFJRiA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1B1E83060BE4;
        Mon, 17 Feb 2020 14:14:42 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:14:32 +0100
Message-ID: <1581966872253108@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f6ab0107a4942dbf9a5cf0cca3f37e184870a360 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Fri, 7 Feb 2020 09:37:42 -0800
Subject: [PATCH] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level
 paging

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

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4e1ef0473663..e4c8a4cbf407 100644
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

