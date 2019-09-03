Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AFBA72A5
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfICSkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:40:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59455 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfICSkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:40:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A4A9F21E97;
        Tue,  3 Sep 2019 14:40:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:40:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fd9bxz
        8l0aDF2TjZUPL3SibRMTSV3drDmQlO/MK9s8U=; b=SwspiDI1AgrhUZdlfKUBMV
        RSg3wV2sXVqv5xT4NyswTKpXwIbjsKMVwJcHzXNmKdmjRPpcoqbumx7Ep//TMzNH
        Rlm/INsuYQidYUmOOGt8AeOUm/cUcACbA5DufNK4EZUylG589QmmBJy5XIgrChk2
        Shffmg+BPY/McxA0dr6bsfCZ37fAN7OZD43BVgAQbl2eVd+DGTpiMCaFb4FEcOeW
        0OprNWz6twBiY16dm5ZfdZVPutqUuQbVdhRnAU4QTOZovZnAZWT4+4pHmNaSl4zi
        PsnvzFQIRiTBStt0xXjOG9D9udeojsYLrloJ+3UyNKmmuKHDuHd+CQ3bTXfn3gdQ
        ==
X-ME-Sender: <xms:r7NuXQ_ROOv5L9cR73iUmrOgQCF05cGMPPKfiNFYTvpDUoR5C21PzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:r7NuXaXc5zIenacTLh5AqCTCa760OXXi3sZEBTraxZoG99UAZCUr7Q>
    <xmx:r7NuXUvaAh9NKJ5grtYWZ3M69nPPUgU7W2ffiMLGf5Ibi7brnVOOug>
    <xmx:r7NuXY-rccO0xkSA6SQR93-xLZzit4Zkk__N1ajlHlDF0hIvXZMI4g>
    <xmx:r7NuXRrOpBAQnQv2vcYauu1xPLam_h9j5Gj-sQoe0zj2phU_IZxVSw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3C5098005A;
        Tue,  3 Sep 2019 14:40:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is" failed to apply to 4.9-stable tree
To:     guoheyi@huawei.com, maz@kernel.org, will@kernel.org,
        yuzenghui@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:40:38 +0200
Message-ID: <156753603884206@kroah.com>
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

From d4a8061a7c5f7c27a2dc002ee4cb89b3e6637e44 Mon Sep 17 00:00:00 2001
From: Heyi Guo <guoheyi@huawei.com>
Date: Tue, 27 Aug 2019 12:26:50 +0100
Subject: [PATCH] KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is
 long

If the ap_list is longer than 256 entries, merge_final() in list_sort()
will call the comparison callback with the same element twice, causing
a deadlock in vgic_irq_cmp().

Fix it by returning early when irqa == irqb.

Cc: stable@vger.kernel.org # 4.7+
Fixes: 8e4447457965 ("KVM: arm/arm64: vgic-new: Add IRQ sorting")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Heyi Guo <guoheyi@huawei.com>
[maz: massaged commit log and patch, added Fixes and Cc-stable]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 04786c8ec77e..ca5e6c6866a4 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -254,6 +254,13 @@ static int vgic_irq_cmp(void *priv, struct list_head *a, struct list_head *b)
 	bool penda, pendb;
 	int ret;
 
+	/*
+	 * list_sort may call this function with the same element when
+	 * the list is fairly long.
+	 */
+	if (unlikely(irqa == irqb))
+		return 0;
+
 	raw_spin_lock(&irqa->irq_lock);
 	raw_spin_lock_nested(&irqb->irq_lock, SINGLE_DEPTH_NESTING);
 

