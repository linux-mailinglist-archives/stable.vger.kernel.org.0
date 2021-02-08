Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34597313796
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhBHP2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:35678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233797AbhBHPW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:22:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD2EF64F11;
        Mon,  8 Feb 2021 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797237;
        bh=UPqCNFt81M+uL5CRzgyQmTxC/b2UFzwF3FwFu4xd8po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6ZcBn0nZMiww86v5tNQHwfdbG0zHozjM1UqNXFB00eFmXpuhwJKQMXx0IXqNftWK
         +eU38lPOqFITDVqWS56usPszGiMDBX4Dl6S/7d84QrKYGM9/UGABAiLq6ftyoCEZtW
         dqpO/mSUpT70XLl5/OGimYFOiaIKCzMOIUeaDn2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@nvidia.com>,
        Colin Ian King <colin.king@canonical.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/120] net/mlx5: Fix function calculation for page trees
Date:   Mon,  8 Feb 2021 16:00:27 +0100
Message-Id: <20210208145820.015736246@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit ed5e83a3c02948dad9dc4e68fb4e535baa5da630 ]

The function calculation always results in a value of 0. This works
generally, but when the release all pages feature is enabled it will
result in crashes.

Fixes: 0aa128475d33 ("net/mlx5: Maintain separate page trees for ECPF and PF functions")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index a3e0c71831928..a44a2bad5bbb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -76,7 +76,7 @@ enum {
 
 static u32 get_function(u16 func_id, bool ec_function)
 {
-	return func_id & (ec_function << 16);
+	return (u32)func_id | (ec_function << 16);
 }
 
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
-- 
2.27.0



