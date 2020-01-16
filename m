Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C9C13FE2D
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404257AbgAPXdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:33:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:42976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404265AbgAPXdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8FAD2072B;
        Thu, 16 Jan 2020 23:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217581;
        bh=W/AYGNgHhxfRocLz7iGKh4VGh933dB2nNyMu2XMx3BQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uINE3jZ7JqengX8zB2LgDs6Pnm1k6NXxo2sLFi7DMsWgeUamJcmwFRcdelTMKndo1
         g1ncGeN3a4cAlb9EglWCH37NIxKnuGvK0zmB8Rzk3SSyCR6e8IeTRa3goAjsHcrm7f
         c56LakMPtpBeSd5Nr82Y6b5MEnY7UBrzYOENpMNU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 4.14 30/71] RDMA/mlx5: Return proper error value
Date:   Fri, 17 Jan 2020 00:18:28 +0100
Message-Id: <20200116231713.877667167@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

commit 546d30099ed204792083f043cd7e016de86016a3 upstream.

Returned value from mlx5_mr_cache_alloc() is checked to be error or real
pointer. Return proper error code instead of NULL which is not checked
later.

Fixes: 81713d3788d2 ("IB/mlx5: Add implicit MR support")
Link: https://lore.kernel.org/r/20191029055721.7192-1-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/mr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -460,7 +460,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(s
 
 	if (entry < 0 || entry >= MAX_MR_CACHE_ENTRIES) {
 		mlx5_ib_err(dev, "cache entry %d is out of range\n", entry);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	ent = &cache->ent[entry];


