Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C599A72A6
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 20:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfICSkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 14:40:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49639 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725883AbfICSkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 14:40:51 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A43A2224E;
        Tue,  3 Sep 2019 14:40:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 14:40:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=k/txwi
        P+zYqXOq3+EznC9uhEATCJzva+59tmC9+sGrw=; b=N7Kdi8PVC5VfWp/Mys6wvH
        Tks27492cIyOKGI29UxzmbSfW0hXtXIuimNHwE94LH+ff0kMHjx33BJJ+JCX7xSy
        j7kFsJN0lOiB38u6GmGRf1swuA2l7rwJSNym9gMaIDFlE/ZqrW+P9XcRLKSZ3Tpa
        VJyrqeGf+TPmT9t3p88TJRW3F8ysu/ZycMF9aZuspx+qRk1NfEVp1xv9I4q36Hb2
        vLrA7uHfBS1kcWpdleP8mPRO03Qf60TFMFgjparaTRcYalA1wbYPQw6C8aaRYNe8
        leX1I3OOPVn4QFeeP3Gb6L6YtdwgAsaWIQ7CSFBdNerzPyFSl9VWhRjVyzDbZ1gA
        ==
X-ME-Sender: <xms:sbNuXZ4aXkeb3B4fFzSJ1lbi3ookLaifK5tK9RfYel3jMPHWvYm2-A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepfe
X-ME-Proxy: <xmx:sbNuXeiZ_naeugjcrj0zJC70BslFOnugCNWtCq1q82xC7gofvG9zMQ>
    <xmx:sbNuXX0G6crn3nxsLVQxg-pM06N_OL2VCHfABFofiTf_OB6sy4ts_A>
    <xmx:sbNuXcr-brJJEBhl9Foi-XkctJ6xeHjKLyVLC6yMnvJlZNky1XgN2w>
    <xmx:sbNuXTqgKM97IFMAkb3wy15VyvLW625nXDqlQvgsjJo9oWWGxbGPjQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A362780063;
        Tue,  3 Sep 2019 14:40:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm/arm64: vgic: Fix potential deadlock when ap_list is" failed to apply to 4.14-stable tree
To:     guoheyi@huawei.com, maz@kernel.org, will@kernel.org,
        yuzenghui@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 20:40:38 +0200
Message-ID: <1567536038225169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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
 

