Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303D0157916
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729347AbgBJNMZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:12:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:35336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729236AbgBJMiv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:38:51 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DDC721739;
        Mon, 10 Feb 2020 12:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338331;
        bh=uljqPqiCh9mIDUXbcxpDmRov9qBN5mVQOrsz0zc6BT0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uo5x8yjRp2ARKgJVfxzhuqugbHO0eKfqHfZGx9q6EIkyCEbxG5bY9QAiHPUTWtSD5
         hvCb0ovy+9QTm7qp/Y+HAvmdXdBFapVArofNcjE18yBx6T4qKBwV0aGJRpU0gXLdUh
         nPGZifBfw/ze9fbI8Lw0/mlpVuWbkpgZ2HHaZ7h0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 274/309] net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx
Date:   Mon, 10 Feb 2020 04:33:50 -0800
Message-Id: <20200210122432.970121961@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

[ Upstream commit 08db2cf577487f5123aebcc2f913e0b8a2c14b43 ]

SA context is allocated at mlx5_fpga_ipsec_create_sa_ctx,
however the counterpart mlx5_fpga_ipsec_delete_sa_ctx function
nullifies sa_ctx pointer without freeing the memory allocated,
hence the memory leak.

Fix by free SA context when the SA is released.

Fixes: d6c4f0298cec ("net/mlx5: Refactor accel IPSec code")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -850,6 +850,7 @@ void mlx5_fpga_ipsec_delete_sa_ctx(void
 	mutex_lock(&fpga_xfrm->lock);
 	if (!--fpga_xfrm->num_rules) {
 		mlx5_fpga_ipsec_release_sa_ctx(fpga_xfrm->sa_ctx);
+		kfree(fpga_xfrm->sa_ctx);
 		fpga_xfrm->sa_ctx = NULL;
 	}
 	mutex_unlock(&fpga_xfrm->lock);


