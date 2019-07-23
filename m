Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D832571795
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 13:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731159AbfGWL6N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 07:58:13 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44731 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWL6N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 07:58:13 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AF26D212BF;
        Tue, 23 Jul 2019 07:58:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 07:58:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PVVtx3
        3QUzOF2xOrcLFbC+rFQ1nR3tC0W+kZ8b7oi1E=; b=aDb4bbSxJ42nyWlvnH+bT3
        6fwp5LMCsqnPXjLUvjU4HbaOu83zB9udAtnk6bFbovGFxJJEEbkDwK7z5LHTWJ2G
        FdJFocb6ki89KowDt6QFje7mzQB/M42MCo5KLI7Z0UVZNcdZfnOsR+qYpGov48KN
        7azzZilS51yJgZ9PNcyUgMErtec77Eb6rdFP+k0Y0J9aV8lBjaMuyqzGPGA31Rov
        eNpkdBlr1YFI3Gs/gyQZIvbb4sEQ7kXS/ofUr2x0oCrh1uOmoRjU1W5YgQaj/NHb
        QPcPsigU4w0D1E920SCVr/sk3r5bIKhcuyScEyWduTQtQdV4AqvtOipT7SXN7OJg
        ==
X-ME-Sender: <xms:VPY2XYg5Nj_iRy4gO8MoVpRqxic0zBI4FyYmknasc9XqaqwK4XpBUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpeef
X-ME-Proxy: <xmx:VPY2XY9lHZ-zDNkfAB-33vLmDFTQ9x63A8jCiiL6W3NIL-BiVQfB4g>
    <xmx:VPY2XXTBPOCD_zh86icj9wTGt_MM7PkmhXM_KlxLYDAea0nqa9CzXg>
    <xmx:VPY2XfvzfxMgvfdynwjeeeniifhzsmT2lTQGgAEC72M4u50DhgnWqA>
    <xmx:VPY2XXdNt1aCoNWELqqCI8KAGVPn71aW_-YjPi4jVCe9xkGxt6bilg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 238DA8005B;
        Tue, 23 Jul 2019 07:58:12 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/odp: Fix missed unlock in non-blocking invalidate_start" failed to apply to 5.1-stable tree
To:     jgg@mellanox.com, dledford@redhat.com, leonro@mellanox.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 13:58:02 +0200
Message-ID: <1563883082195169@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7608bf40cf2480057ec0da31456cc428791c32ef Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@mellanox.com>
Date: Tue, 11 Jun 2019 13:09:51 -0300
Subject: [PATCH] RDMA/odp: Fix missed unlock in non-blocking invalidate_start

If invalidate_start returns with EAGAIN then the umem_rwsem needs to be
unlocked as no invalidate_end will be called.

Cc: <stable@vger.kernel.org>
Fixes: ca748c39ea3f ("RDMA/umem: Get rid of per_mm->notifier_count")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Doug Ledford <dledford@redhat.com>

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index 9001cc10770a..eb9939d52818 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -149,6 +149,7 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
 {
 	struct ib_ucontext_per_mm *per_mm =
 		container_of(mn, struct ib_ucontext_per_mm, mn);
+	int rc;
 
 	if (mmu_notifier_range_blockable(range))
 		down_read(&per_mm->umem_rwsem);
@@ -165,11 +166,14 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		return 0;
 	}
 
-	return rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
-					     range->end,
-					     invalidate_range_start_trampoline,
-					     mmu_notifier_range_blockable(range),
-					     NULL);
+	rc = rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
+					   range->end,
+					   invalidate_range_start_trampoline,
+					   mmu_notifier_range_blockable(range),
+					   NULL);
+	if (rc)
+		up_read(&per_mm->umem_rwsem);
+	return rc;
 }
 
 static int invalidate_range_end_trampoline(struct ib_umem_odp *item, u64 start,

