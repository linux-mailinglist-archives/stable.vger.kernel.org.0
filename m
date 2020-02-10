Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED08157B11
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgBJN1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:27:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:56418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbgBJMgg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:36 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F5C420842;
        Mon, 10 Feb 2020 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338196;
        bh=/ocYtFeRgXGdhjT9Gmz1o6pvlBph2d9r3E5q0wTzIqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=II8tko/4EBZrO6aANAHBL7Csc08DlEafN8h6XBxTNzBEHUbLjs9B53KFqVGRRW3vw
         4w4Z4uv5DqmxR2nXrSR8aTdOC48A7Phu6eI33wQvjjS1jV1sXWLjBlQt9FPngKKsQH
         X4fYb0guLnh5pn65JSTdqakHZPcICmMFc9KPELF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.19 172/195] net/mlx5: IPsec, fix memory leak at mlx5_fpga_ipsec_delete_sa_ctx
Date:   Mon, 10 Feb 2020 04:33:50 -0800
Message-Id: <20200210122322.038274844@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
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
@@ -848,6 +848,7 @@ void mlx5_fpga_ipsec_delete_sa_ctx(void
 	mutex_lock(&fpga_xfrm->lock);
 	if (!--fpga_xfrm->num_rules) {
 		mlx5_fpga_ipsec_release_sa_ctx(fpga_xfrm->sa_ctx);
+		kfree(fpga_xfrm->sa_ctx);
 		fpga_xfrm->sa_ctx = NULL;
 	}
 	mutex_unlock(&fpga_xfrm->lock);


