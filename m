Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16E67F74B
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730724AbfD3Lrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:47:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730718AbfD3Lrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:47:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87A6621670;
        Tue, 30 Apr 2019 11:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624852;
        bh=ExXeJ7BjNTIM/A1dS+t+eN88uZoNCjptju94/gQvngM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OwRMnKtKwCQ27nkpzh7twLWHIV0XLv8YcxO2fErs/VBm1JBWNYdJywbter8g9xd99
         j1cdN6GK9t80tuT7SvVmUeuahOqSUNwQnu+C1AaByaVfvetTPqbNxshVnSVjaQeASJ
         eE5f9cgiI2VUtvhzyJgxXsBjKl4IWP966weMYkm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 098/100] net/mlx5e: Fix use-after-free after xdp_return_frame
Date:   Tue, 30 Apr 2019 13:39:07 +0200
Message-Id: <20190430113613.462883814@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 12fc512f5741443a03adde2ead20724da8ad550a ]

xdp_return_frame releases the frame. It leads to releasing the page, so
it's not allowed to access xdpi.xdpf->len after that, because xdpi.xdpf
is at xdp->data_hard_start after convert_to_xdp_frame. This patch moves
the memory access to precede the return of the frame.

Fixes: 58b99ee3e3ebe ("net/mlx5e: Add support for XDP_REDIRECT in device-out side")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -227,9 +227,9 @@ bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq
 			sqcc++;
 
 			if (is_redirect) {
-				xdp_return_frame(xdpi->xdpf);
 				dma_unmap_single(sq->pdev, xdpi->dma_addr,
 						 xdpi->xdpf->len, DMA_TO_DEVICE);
+				xdp_return_frame(xdpi->xdpf);
 			} else {
 				/* Recycle RX page */
 				mlx5e_page_release(rq, &xdpi->di, true);
@@ -263,9 +263,9 @@ void mlx5e_free_xdpsq_descs(struct mlx5e
 		sq->cc++;
 
 		if (is_redirect) {
-			xdp_return_frame(xdpi->xdpf);
 			dma_unmap_single(sq->pdev, xdpi->dma_addr,
 					 xdpi->xdpf->len, DMA_TO_DEVICE);
+			xdp_return_frame(xdpi->xdpf);
 		} else {
 			/* Recycle RX page */
 			mlx5e_page_release(rq, &xdpi->di, false);


