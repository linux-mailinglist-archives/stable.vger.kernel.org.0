Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E96494FDFA
	for <lists+stable@lfdr.de>; Sun, 23 Jun 2019 22:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfFWU2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jun 2019 16:28:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43787 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726290AbfFWU2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jun 2019 16:28:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 97334220DD;
        Sun, 23 Jun 2019 16:28:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 23 Jun 2019 16:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=6567Kk
        jUVwWUhrF9HXCHF1p2zPPzFQG/nlRmacM4bso=; b=Wexyliu/NfP1ygLu7gmuJk
        g/LT0GosHrwV34AGJ5YttgwynrGGiYlCuGmJGlvpukmkyHyGqESb2Vjwt9mtJqCS
        6SQLZv8+XvmHpc82Fd/6jwBHgOpzfNcsd+L6uoqn+s++WtYViBpKODUnefKJvopj
        V9w32kOKWh0BleUmI9Dmpa19Vm2Sy85Y5vYN4vIhoE3oSGGRMMMcDUWxaq8VsKZx
        dIGJqEoy2oiMZISKoJvWIjK5KdDGywJsAcuyqCdn8NYbQeFrmA92OiRJA5NwHUg5
        wkm8ses+21RAKlnB9xCmQT01kkOz5Lng7U/iZ0xZbE6wYmQwLBPAtCus2jeRcQ6g
        ==
X-ME-Sender: <xms:1uAPXQ5OtQSrXCz4JL7HQ7lavp__MY-GKfXx9moPz4HRYmiJYXgKOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtgdduheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppedujedvrddutdegrddvgeekrdeggeenucfrrghrrghmpehmrghilhhfrh
    homhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepvd
X-ME-Proxy: <xmx:1uAPXehyfJf06V97TxPKNS6WJuQGeb6uHRTbE72JLbvgfgfGsmPlEg>
    <xmx:1uAPXbNKFFwJZDp-L8Wb0wboY2zKP6kw3W3qFa1bUZLdNlH4qKOzBw>
    <xmx:1uAPXY9WYwFj4CG6BWwUZEBa1mAK7isz7b69Xfd60_0FHyd0j6iI2Q>
    <xmx:1uAPXXx81wW5ZDCzgWiYJCJ6QlaFJg89Oc0MooMtDBh2PJd7_Q5vGg>
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7E979380079;
        Sun, 23 Jun 2019 16:28:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, jpalecek@web.de,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jun 2019 22:27:50 +0200
Message-ID: <1561321670157164@kroah.com>
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

From b6b80c78af838bef17501416d5d383fedab0010a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Thu, 13 Jun 2019 10:22:23 -0700
Subject: [PATCH] KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit
 NPT

SVM's Nested Page Tables (NPT) reuses x86 paging for the host-controlled
page walk.  For 32-bit KVM, this means PAE paging is used even when TDP
is enabled, i.e. the PAE root array needs to be allocated.

Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
Cc: stable@vger.kernel.org
Reported-by: Jiri Palecek <jpalecek@web.de>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 1e9ba81accba..d3c3d5e5ffd4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -5602,14 +5602,18 @@ static int alloc_mmu_pages(struct kvm_vcpu *vcpu)
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

