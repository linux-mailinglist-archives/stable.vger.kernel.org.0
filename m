Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6CC35BCB0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbhDLIof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:44:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237661AbhDLIoU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:44:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8E261244;
        Mon, 12 Apr 2021 08:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217042;
        bh=6Ci7Yg7vFhqG70ys7gz2jVnFj6AIsXHZyVYzXPTLMZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HpnjJq0BP4R+ui0JT+te10T7cr2PAViEt6eO78hlLn5rRqhbx7bUnCZB1k+KM2UpR
         dZIvLd7C2D3NaxUXpxA587qt/GihF3UmfhSHBZIPsw5hXmDsCS2HIGAMg+llpdeE/C
         zBVTgyv9XhS6359WWbbOHA5vPJoMsXcu637hsqeo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/66] net/mlx5: Fix PBMC register mapping
Date:   Mon, 12 Apr 2021 10:40:55 +0200
Message-Id: <20210412083959.708166730@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 534b1204ca4694db1093b15cf3e79a99fcb6a6da ]

Add reserved mapping to cover all the register in order to avoid setting
arbitrary values to newer FW which implements the reserved fields.

Fixes: 50b4a3c23646 ("net/mlx5: PPTB and PBMC register firmware command support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mlx5/mlx5_ifc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b8cd93240287..5f711b2983db 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -8929,7 +8929,7 @@ struct mlx5_ifc_pbmc_reg_bits {
 
 	struct mlx5_ifc_bufferx_reg_bits buffer[10];
 
-	u8         reserved_at_2e0[0x40];
+	u8         reserved_at_2e0[0x80];
 };
 
 struct mlx5_ifc_qtct_reg_bits {
-- 
2.30.2



