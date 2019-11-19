Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2D71013DC
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfKSF17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:27:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727840AbfKSF16 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:27:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53852208C3;
        Tue, 19 Nov 2019 05:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141277;
        bh=U9HD4B/xPEJdt+6Ll1JEDtratWwqcI5JSfiG63CzEsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MNxo2IO2Ndg3slQv7WYAgUV8OHANlNLxcqzfAa/khecVht8RXRRte8XxFitA+LxUm
         6MUlUlYxNzVfuxsjp1wbrbSCDRUvu34hPSePNzqOvR3dcjAUYif1YiwqIht8k/A4sk
         2DYhXMF8g321qFAwFUUKkIGHDbxdCgi1Q1kfTN/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moni Shoua <monis@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/422] net/mlx5: Fix atomic_mode enum values
Date:   Tue, 19 Nov 2019 06:15:04 +0100
Message-Id: <20191119051406.101108924@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

[ Upstream commit aa7e80b220f3a543eefbe4b7e2c5d2b73e2e2ef7 ]

The field atomic_mode is 4 bits wide and therefore can hold values
from 0x0 to 0xf. Remove the unnecessary 20 bit shift that made the values
be incorrect. While that, remove unused enum values.

Fixes: 57cda166bbe0 ("net/mlx5: Add DCT command interface")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/driver.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index e8b92dee5a726..ae64fced188d1 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -163,10 +163,7 @@ enum mlx5_dcbx_oper_mode {
 };
 
 enum mlx5_dct_atomic_mode {
-	MLX5_ATOMIC_MODE_DCT_OFF        = 20,
-	MLX5_ATOMIC_MODE_DCT_NONE       = 0 << MLX5_ATOMIC_MODE_DCT_OFF,
-	MLX5_ATOMIC_MODE_DCT_IB_COMP    = 1 << MLX5_ATOMIC_MODE_DCT_OFF,
-	MLX5_ATOMIC_MODE_DCT_CX         = 2 << MLX5_ATOMIC_MODE_DCT_OFF,
+	MLX5_ATOMIC_MODE_DCT_CX         = 2,
 };
 
 enum {
-- 
2.20.1



