Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31BA156A8C
	for <lists+stable@lfdr.de>; Sun,  9 Feb 2020 14:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgBINJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Feb 2020 08:09:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40627 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727654AbgBINJj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Feb 2020 08:09:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A99621EA0;
        Sun,  9 Feb 2020 08:09:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 09 Feb 2020 08:09:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RZ5wRb
        lb1C8KMRkfQglXgjPhnOYTHdkLk2NOPL26kFo=; b=nEh0G2l2YXZecjxozdsZ+0
        6U7UtAJpGqh6frWgxCPYybRAVAzyrPIYEKx5X2OmqH/Dc59v1OhU/lzhZV981vs5
        xLw7PiasNFccz0bMrBOEBmKusRZWps2h+PwWS+W1GEkXNc09482AGZKF0c7mmRqr
        A8cg0jmg4CQiVCWWErH7XwNF0MT1vlaHfwGOTwrdnHszW/L9fzpAJTuxgF0bQVCU
        nsl2jM5yfh3tYHsx0pvbak1ij2P9PdyKSMs7ZyDUJfPSlEy9fkHwXLjrKcOvTA7i
        +4YH1zO4D+2OAC63NlREJYqxOIEzuWFcQKdQR9jag6Y09wkmnbbhWZm/w/F6+X4g
        ==
X-ME-Sender: <xms:kgRAXp_pY15e6quOLRrfiBQc1tk7J_kNANWw9KKtF58OmcEhq4uRDg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheelgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepfeekrdelkedrfeejrddufeehnecuvehluhhsthgvrhfuihiivgepvdefne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kgRAXu_T3NCGBqYrbB47zlnxo8zUSim7onhE5IjlsZNcr3BUo0_C3A>
    <xmx:kgRAXsWxYkQMniCRvGcnctNGbzNGuxVhhQyrdadHLY4WRCCpHTbEZQ>
    <xmx:kgRAXrZAkVBcrYjsu7h5mElJjeIG1QmIuCC_LLOBel7sEzyERUquyA>
    <xmx:kgRAXuYVbUc_xmpsL3q0OLOdnzWGJ2zUU4lsHt7FCrEAD_5zcLvnxg>
Received: from localhost (unknown [38.98.37.135])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F12D3280064;
        Sun,  9 Feb 2020 08:09:37 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM" failed to apply to 4.9-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 Feb 2020 13:26:49 +0100
Message-ID: <158125120965113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e30a7d623dccdb3f880fbcad980b0cb589a1da45 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Tue, 7 Jan 2020 16:12:10 -0800
Subject: [PATCH] KVM: x86/mmu: Apply max PA check for MMIO sptes to 32-bit KVM

Remove the bogus 64-bit only condition from the check that disables MMIO
spte optimization when the system supports the max PA, i.e. doesn't have
any reserved PA bits.  32-bit KVM always uses PAE paging for the shadow
MMU, and per Intel's SDM:

  PAE paging translates 32-bit linear addresses to 52-bit physical
  addresses.

The kernel's restrictions on max physical addresses are limits on how
much memory the kernel can reasonably use, not what physical addresses
are supported by hardware.

Fixes: ce88decffd17 ("KVM: MMU: mmio page fault support")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2992ff7b42a7..57e4dbddba72 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6193,7 +6193,7 @@ static void kvm_set_mmio_spte_mask(void)
 	 * If reserved bit is not supported, clear the present bit to disable
 	 * mmio page fault.
 	 */
-	if (IS_ENABLED(CONFIG_X86_64) && shadow_phys_bits == 52)
+	if (shadow_phys_bits == 52)
 		mask &= ~1ull;
 
 	kvm_mmu_set_mmio_spte_mask(mask, mask, ACC_WRITE_MASK | ACC_USER_MASK);

