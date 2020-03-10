Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C998717F4F6
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 11:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgCJKWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 06:22:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41503 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726164AbgCJKWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 06:22:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A6E521BBA;
        Tue, 10 Mar 2020 06:22:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 10 Mar 2020 06:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ksZBN1
        EO7ahK35awv2AfdxRh9J/+VuPxdig+rjuLeAI=; b=vhusRFh/qSjSI/vR8+DqHk
        YlNIBeUIizgsAyeJYb3WakFpti742RiMAycC5rcRR0lM7ws/mlVeKZldM5mctyO7
        fxnetaQfGT8UAIE2rUtfNTQpFID59lWA/2eHNs/CCQcLDri688wYqoG6xjgOXxa/
        emZ1EaUKhHI5oBd8hBcpoieaqWxz4GW9LF/8oynbenZPzsoepHVf9O/fCWsACgX3
        aSVhv5JVUTsiTVRI09xD15FTOEcPNv3tekG8+Qu4oKptJ7d+SneNLbL1PRYQk9G/
        VLOGQdEZRPF+A8dWmvGMn0H+EZ08zFR8HhTFMmQ7LQMMJlPPAmUcJGOUNm9NMeEA
        ==
X-ME-Sender: <xms:ampnXq1Y8aUxHOgu4M8vlTBBXr3sO2fABBRdXD4lCc4LC46PQp3P4g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddvtddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    ghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ampnXkHwGKZ5MA6Yjwjvoa0QmTrGwnqKG7GE3uvNAr13ybEJNR9stQ>
    <xmx:ampnXn6_Tmjva867swqXVoYzsKhwEEs6WmASmHgKNF0-eYv-sEXz4A>
    <xmx:ampnXqvK2s7yOAKCKtBmDTYpC6AquJMG5b84B8LZ02GXfM9btD1Ugg>
    <xmx:a2pnXscx_xEVAPlOUD4cnYKRvyYvV9vrVPSTAMPSda74ogbZUqDZzQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 777403061363;
        Tue, 10 Mar 2020 06:22:34 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/odp: Ensure the mm is still alive before creating an" failed to apply to 5.4-stable tree
To:     jgg@ziepe.ca, jgg@mellanox.com, leonro@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Mar 2020 11:22:32 +0100
Message-ID: <15838357527073@kroah.com>
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

From a4e63bce1414df7ab6eb82ca9feb8494ce13e554 Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Thu, 27 Feb 2020 13:41:18 +0200
Subject: [PATCH] RDMA/odp: Ensure the mm is still alive before creating an
 implicit child

Registration of a mmu_notifier requires the caller to hold a mmget() on
the mm as registration is not permitted to race with exit_mmap(). There is
a BUG_ON inside the mmu_notifier to guard against this.

Normally creating a umem is done against current which implicitly holds
the mmget(), however an implicit ODP child is created from a pagefault
work queue and is not guaranteed to have a mmget().

Call mmget() around this registration and abort faulting if the MM has
gone to exit_mmap().

Before the patch below the notifier was registered when the implicit ODP
parent was created, so there was no chance to register a notifier outside
of current.

Fixes: c571feca2dc9 ("RDMA/odp: use mmu_notifier_get/put for 'struct ib_ucontext_per_mm'")
Link: https://lore.kernel.org/r/20200227114118.94736-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index b8c657b28380..cd656ad4953b 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -181,14 +181,28 @@ ib_umem_odp_alloc_child(struct ib_umem_odp *root, unsigned long addr,
 	odp_data->page_shift = PAGE_SHIFT;
 	odp_data->notifier.ops = ops;
 
+	/*
+	 * A mmget must be held when registering a notifier, the owming_mm only
+	 * has a mm_grab at this point.
+	 */
+	if (!mmget_not_zero(umem->owning_mm)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+
 	odp_data->tgid = get_pid(root->tgid);
 	ret = ib_init_umem_odp(odp_data, ops);
-	if (ret) {
-		put_pid(odp_data->tgid);
-		kfree(odp_data);
-		return ERR_PTR(ret);
-	}
+	if (ret)
+		goto out_tgid;
+	mmput(umem->owning_mm);
 	return odp_data;
+
+out_tgid:
+	put_pid(odp_data->tgid);
+	mmput(umem->owning_mm);
+out_free:
+	kfree(odp_data);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(ib_umem_odp_alloc_child);
 

