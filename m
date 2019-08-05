Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 340A1811AE
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfHEFgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:36:44 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52551 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEFgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:36:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8034120963;
        Mon,  5 Aug 2019 01:36:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:36:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SIcfm3
        S8USn4HZqPD2P+t0f777BtEP+IO58JWFkyXHw=; b=Ih0nCPCUtjk1ZekCCQ4bBX
        ciX+MH1sqRa+tllLzr4XScJDErCGqCuNkTVQrxwjVCBH+uk1ZLeIkAwdUoWBD6IF
        YED6R+GVWQTas/5MXJeQr1rxXlm+ADMb8bR+tqViczNRV1QtYulTasNDIonAWKJz
        JlIbhHFI5Ir5wz9WDsDfcrg3i9/PvcLBOoAP5LEKtVyddcx1gzdjFfNtTYAH8OlC
        SRqvjHiQTD064OVF9a3K9LTYJLHSzeSz6SSyBl1Vt6kJWqBcVvEtuGyKvVTUGezv
        gaV6H/UIMHfnrHKfjO9gIClR2mKn5whxx24S5OAx4dTaMrzQM2w70VCCg6uKNXFg
        ==
X-ME-Sender: <xms:a8BHXddIyNmAxH2qUXRaI9rmNb_DK3IfsRgDWnYlePRX5IOEpNeT2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpeeg
X-ME-Proxy: <xmx:a8BHXc2M-4dOG0RIKHTAluXQUawT1YI_WrdK6fEQsH1f6aXvllvx8g>
    <xmx:a8BHXVPLiB39_svQyPueiwOJloGWIPhb4gx73EgrAtVoKxuOHyE5tw>
    <xmx:a8BHXfd7Zpz5E-DvHpBRTWES-Mfu7ZviEVlxRAnMHT2_WrJBNBFlaA>
    <xmx:a8BHXYJDrMzwB5h8YFnNgHpLVlx4G4b2QZqT_aJrsZqL1nWV8b76rg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 03902380088;
        Mon,  5 Aug 2019 01:36:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] IB/mlx5: Fix clean_mr() to work in the expected order" failed to apply to 4.14-stable tree
To:     yishaih@mellanox.com, artemyko@mellanox.com, jgg@mellanox.com,
        leonro@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:36:41 +0200
Message-ID: <1564983401234220@kroah.com>
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

