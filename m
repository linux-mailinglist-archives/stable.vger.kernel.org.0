Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D79D31379C
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbhBHP2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:28:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233805AbhBHPWk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:22:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CB6264F14;
        Mon,  8 Feb 2021 15:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797243;
        bh=8QIcW8Y4hwePRXMByCKTs9+X5M//JabLGU8P20oDLLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hSNTe9sEQSg7beE2Vr8lA7skAiOf8dt8SqBZtM2xIiuYvSf4j9UGPSZYNEuG2creG
         47kGIM3F9pJqPzWVWUM15LM0RL2Rmb8Nf0Fh1BdQDmqlImLoJUaIe4vrrZDLkGORWB
         pGkxeuS1Kew6daFTXQe9xLTm98FfC2q244kpLHHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 042/120] net/mlx5e: Update max_opened_tc also when channels are closed
Date:   Mon,  8 Feb 2021 16:00:29 +0100
Message-Id: <20210208145820.095162436@linuxfoundation.org>
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

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 5a2ba25a55c4dc0f143567c99aede768b6628ebd ]

max_opened_tc is used for stats, so that potentially non-zero stats
won't disappear when num_tc decreases. However, mlx5e_setup_tc_mqprio
fails to update it in the flow where channels are closed.

This commit fixes it. The new value of priv->channels.params.num_tc is
always checked on exit. In case of errors it will just be the old value,
and in case of success it will be the updated value.

Fixes: 05909babce53 ("net/mlx5e: Avoid reset netdev stats on configuration changes")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c9b5d7f29911e..42848db8f8dd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3593,12 +3593,10 @@ static int mlx5e_setup_tc_mqprio(struct mlx5e_priv *priv,
 
 	err = mlx5e_safe_switch_channels(priv, &new_channels,
 					 mlx5e_num_channels_changed_ctx, NULL);
-	if (err)
-		goto out;
 
-	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
-				    new_channels.params.num_tc);
 out:
+	priv->max_opened_tc = max_t(u8, priv->max_opened_tc,
+				    priv->channels.params.num_tc);
 	mutex_unlock(&priv->state_lock);
 	return err;
 }
-- 
2.27.0



