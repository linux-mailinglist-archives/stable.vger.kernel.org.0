Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7406E811B0
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbfHEFgz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:36:55 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60723 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFgy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:36:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C55BB21AD0;
        Mon,  5 Aug 2019 01:36:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:36:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=EKLoe7
        A2177h3y1UZ85mYF8kzIVSlDPZjYgZkHOhSr0=; b=M+SsP/yHbD3wiZiPaGX+VE
        Rc2ag0wfFVW5wKKvYmTx972lS+Nqpq65tNsDz1isnKdIPIVVgS1wfncIYLUKVFzw
        bWQcRULhLyS4sy8KFokMFZ1+dq1V+fY15kC44bhRjoFeblqY+NeEqBp4OMIGj1+c
        7FSjTLY+8hScJFffvluOr17poOo9oLliQjTUZCa1NreDXs5ozgtc6DwT0kMi9oBk
        h6ZOfau5hsFv5vNU5hTREeXwvvCtm0i6KWdfJ8cx/6nkT8Mz+Wd5eAZR1D5hd+EL
        Pg5U18zR4zf+P7aJHiOxNzZ3KUaZKr5D3F3sm/Ua2GvvgjTQ7FpFT9mOJer4Rcrg
        ==
X-ME-Sender: <xms:dcBHXfk3Xsnq1OpMUME9cdGL6K1wlKFknSpe1vtsWylZUcd0-NUd7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeh
X-ME-Proxy: <xmx:dcBHXZSsvfR5eApKiG8G9_QCBNayXwTAtky8zCSxqC0oHQPn2hbqYg>
    <xmx:dcBHXTInTthBt4x9NBaqKvKNwD5uAonCbUlF0v7bawD7-8fiATRRcw>
    <xmx:dcBHXf-pT03Z_xgktyoVp1L3vyyxg39I6axlOvQhknCbfzaOFOInpA>
    <xmx:dcBHXWNEONi06SUo8Daj4KZZmt_b0ivlAWcj_40scVRarUQfvr_d3g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41108380083;
        Mon,  5 Aug 2019 01:36:53 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Fix clean_mr() to work in the expected order" failed to apply to 4.9-stable tree
To:     yishaih@mellanox.com, artemyko@mellanox.com, jgg@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:36:42 +0200
Message-ID: <156498340295176@kroah.com>
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

From b9332dad987018745a0c0bb718d12dacfa760489 Mon Sep 17 00:00:00 2001
From: Yishai Hadas <yishaih@mellanox.com>
Date: Tue, 23 Jul 2019 09:57:28 +0300
Subject: [PATCH] IB/mlx5: Fix clean_mr() to work in the expected order

Any dma map underlying the MR should only be freed once the MR is fenced
at the hardware.

As of the above we first destroy the MKEY and just after that can safely
call to dma_unmap_single().

Link: https://lore.kernel.org/r/20190723065733.4899-6-leon@kernel.org
Cc: <stable@vger.kernel.org> # 4.3
Fixes: 8a187ee52b04 ("IB/mlx5: Support the new memory registration API")
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7274a9b9df58..2c77456f359f 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1582,10 +1582,10 @@ static void clean_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 		mr->sig = NULL;
 	}
 
-	mlx5_free_priv_descs(mr);
-
-	if (!allocated_from_cache)
+	if (!allocated_from_cache) {
 		destroy_mkey(dev, mr);
+		mlx5_free_priv_descs(mr);
+	}
 }
 
 static void dereg_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)

