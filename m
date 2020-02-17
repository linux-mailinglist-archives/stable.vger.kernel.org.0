Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5A1B161B59
	for <lists+stable@lfdr.de>; Mon, 17 Feb 2020 20:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729593AbgBQTOf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Feb 2020 14:14:35 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49937 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728467AbgBQTOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Feb 2020 14:14:35 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C9F07210D8;
        Mon, 17 Feb 2020 14:14:33 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 17 Feb 2020 14:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jvu+KE
        i0aJOYKwvhjEUbe5n33S8MM0h4fSOQXiJ57PM=; b=w5+KWcyi8hCPP6leTHZFbB
        1R5vFUBftx6t9berioxgu/Ye34LyMYg2pffTqmd78AbiZLlqR2flvTZLS4lR52z7
        VvBUp+terBmQD5p/BInTgDDV8K2hpncuA+VuRyf2ROcvlwJENdcjalodVnvfwdYc
        1cyAlay5j70fpQRKmh8hFXxWMYWWEXUTf6S0vYkUhHXJ9mL+f6Ot//hONh2dXxyN
        XWxE1sORo9GzFEyXZTLaWqlr+wm8RZsrk2pGpU4rKPqrt8TVdIrrSRwT0hxsc1Ry
        hJVCWMAdsBv82k47Durk9EvZt8V1YZiLIEp9xHNYIxAAzlJrfCqVcKMuW04V2TSg
        ==
X-ME-Sender: <xms:GeZKXlmOSi9RSUXFt5ZJkzMiY5LXXdBMBrRN4zFRH5rTRuGpeiMANw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrjeeigdduvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedvne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:GeZKXqKsOLHca6YWO5gv2iXi5BLrepRSCWFvV3iQfvJaLPOk_L-Zyw>
    <xmx:GeZKXoDM2AFjKq0MqRC2Czx1y5GCu7TK884Gk0GL-KIO5Ag68MY2EA>
    <xmx:GeZKXtIy0rLhg9ShpMjEOWyckdrFZc8NPy7nHLOBI7IMMYZ9ch7cdQ>
    <xmx:GeZKXsahLTpcZNNi5HVPXHFjEHyuCw2pfcO2hgz1frRaH0ylCwd5uA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 46A26328005E;
        Mon, 17 Feb 2020 14:14:33 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Fix struct guest_walker arrays for 5-level" failed to apply to 5.4-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 Feb 2020 20:14:31 +0100
Message-ID: <1581966871164161@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

