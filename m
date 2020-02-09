Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64B86156AAD
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgBINmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:42:23 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:39893 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727514AbgBINmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:42:22 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id BE98421E1C;
        Sun,  9 Feb 2020 08:42:21 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XPb8GJ
        CXV9wV6FUZ59YE57lIV3F+rcqDm6C1vJynVgI=; b=V4SG6g9KgFKYGRiQmaQM5Q
        +4yqqcGFLpe+0BWeO1QZUui5Jw4Lt4iZKqk3CC5qnaIn+o0RG6Wg5pcOgO+CrkFY
        xrk/cdxRqfY3u8gFKvL/UvC5wSa1j2uV7PxTnwKo2WGCzXkxZyiBqfwcQdnutlAF
        +kV7W+ET0t+serbDLPxxd4NuTbyxLpyuZlFSZIMDijo1vfap81u7zyVJXq27TXiP
        BVcagJ6g9Jl6+DhgXJYnHg1zkPl99DvyqfFhrtUyjl+euL3GszIZNtjlLHH+2muO
        2IazjXG1Z2cTMCfJO6AjWuIcno+9jT6SwwvfzESfIMqV/m3KwHibbIzEDh2NFd2g
        ==
X-ME-Sender: <xms:PQxAXrY_vYzqVQjuTqEhMEb6LtrVb2IW-qoqCQ1R8t7L4t2me0Km-Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepheenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PQxAXn6cC1Ar13pE-e4h9Hf_QinlekQg_gKDfDI43IqkMFsRwFeyJw>
    <xmx:PQxAXkSWn1lZALB6Wo_Iv4K2r0psL33J1NUBAayigw2MbKe55Y8JLw>
    <xmx:PQxAXow6lC_DCESKlpIBt6Tvg_0v5DIWT29A0kTfgLKcYGro1vp8uw>
    <xmx:PQxAXrjNRdzvOB-x-I-FO_joWDGe7N6LXMf_QXMBE0aFjuYMTsACFQ>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 884383280062;
        Sun,  9 Feb 2020 08:42:20 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation" failed to apply to 5.4-stable tree
To:     pbonzini@redhat.com, bgardon@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:34:11 +0100
Message-ID: <1581251651184158@kroah.com>
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

From 56871d444bc4d7ea66708775e62e2e0926384dbc Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 18 Jan 2020 20:09:03 +0100
Subject: [PATCH] KVM: x86: fix overlap between SPTE_MMIO_MASK and generation

The SPTE_MMIO_MASK overlaps with the bits used to track MMIO
generation number.  A high enough generation number would overwrite the
SPTE_SPECIAL_MASK region and cause the MMIO SPTE to be misinterpreted.

Likewise, setting bits 52 and 53 would also cause an incorrect generation
number to be read from the PTE, though this was partially mitigated by the
(useless if it weren't for the bug) removal of SPTE_SPECIAL_MASK from
the spte in get_mmio_spte_generation.  Drop that removal, and replace
it with a compile-time assertion.

Fixes: 6eeb4ef049e7 ("KVM: x86: assign two bits to track SPTE kinds")
Reported-by: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 57e4dbddba72..b9052c7ba43d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -418,22 +418,24 @@ static inline bool is_access_track_spte(u64 spte)
  * requires a full MMU zap).  The flag is instead explicitly queried when
  * checking for MMIO spte cache hits.
  */
-#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(18, 0)
+#define MMIO_SPTE_GEN_MASK		GENMASK_ULL(17, 0)
 
 #define MMIO_SPTE_GEN_LOW_START		3
 #define MMIO_SPTE_GEN_LOW_END		11
 #define MMIO_SPTE_GEN_LOW_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_END, \
 						    MMIO_SPTE_GEN_LOW_START)
 
-#define MMIO_SPTE_GEN_HIGH_START	52
-#define MMIO_SPTE_GEN_HIGH_END		61
+#define MMIO_SPTE_GEN_HIGH_START	PT64_SECOND_AVAIL_BITS_SHIFT
+#define MMIO_SPTE_GEN_HIGH_END		62
 #define MMIO_SPTE_GEN_HIGH_MASK		GENMASK_ULL(MMIO_SPTE_GEN_HIGH_END, \
 						    MMIO_SPTE_GEN_HIGH_START)
+
 static u64 generation_mmio_spte_mask(u64 gen)
 {
 	u64 mask;
 
 	WARN_ON(gen & ~MMIO_SPTE_GEN_MASK);
+	BUILD_BUG_ON((MMIO_SPTE_GEN_HIGH_MASK | MMIO_SPTE_GEN_LOW_MASK) & SPTE_SPECIAL_MASK);
 
 	mask = (gen << MMIO_SPTE_GEN_LOW_START) & MMIO_SPTE_GEN_LOW_MASK;
 	mask |= (gen << MMIO_SPTE_GEN_HIGH_START) & MMIO_SPTE_GEN_HIGH_MASK;
@@ -444,8 +446,6 @@ static u64 get_mmio_spte_generation(u64 spte)
 {
 	u64 gen;
 
-	spte &= ~shadow_mmio_mask;
-
 	gen = (spte & MMIO_SPTE_GEN_LOW_MASK) >> MMIO_SPTE_GEN_LOW_START;
 	gen |= (spte & MMIO_SPTE_GEN_HIGH_MASK) >> MMIO_SPTE_GEN_HIGH_START;
 	return gen;

