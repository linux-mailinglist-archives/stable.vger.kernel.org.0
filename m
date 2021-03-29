Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE33634CA22
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234260AbhC2IfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232837AbhC2Idy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA7E86192E;
        Mon, 29 Mar 2021 08:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006833;
        bh=X4jxj4osBs/QZmbAd/FvVnI8F08fQ2rj8K/5hr0eOtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPpKTxXY5Atqy9LZ4IeQIs+HgyNVbQyJygwUH7bSH/B+nz8S+8LDD76y6sdqhqmuk
         gmR8eocjWpcL1cdqBnpFfg/LDHbnizJZEsys+dGagHKf/HlhvhOkk3Za/65wTbAvaP
         VpNpS8uW2/b/0tu/MxOGBuojUnDWz9dmN64ZiYqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 115/254] net/mlx5e: Set PTP channel pointer explicitly to NULL
Date:   Mon, 29 Mar 2021 09:57:11 +0200
Message-Id: <20210329075637.002469581@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 1c2cdf0b603a3b0c763288ad92e9f3f1555925cf ]

When closing the PTP channel, set its pointer explicitly to NULL. PTP
channel is opened on demand, the code verify the pointer validity before
access. Nullify it when closing the PTP channel to avoid unexpected
behavior.

Fixes: 145e5637d941 ("net/mlx5e: Add TX PTP port object support")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e479cce3e2b1..3248741af440 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2443,8 +2443,10 @@ void mlx5e_close_channels(struct mlx5e_channels *chs)
 {
 	int i;
 
-	if (chs->port_ptp)
+	if (chs->port_ptp) {
 		mlx5e_port_ptp_close(chs->port_ptp);
+		chs->port_ptp = NULL;
+	}
 
 	for (i = 0; i < chs->num; i++)
 		mlx5e_close_channel(chs->c[i]);
-- 
2.30.1



