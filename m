Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EC430C07C
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbhBBN7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:59:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233159AbhBBN5b (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:57:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED1CD64FEC;
        Tue,  2 Feb 2021 13:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273549;
        bh=8YP2YwpCFgBGOYFrtNLvhwmNyCeJdnTSQVFVtIfDwGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mw/IfXNVgIJZzrZzZfdJwXxVRSNbtkLux8ckKMjxI2OqnitbkA62/v+3eQNHva1B6
         N14Km4GYcpt/Dn23uZrwg2lXQx6+eFqr+7o2Kq0HmVhav8WcAmgZd4N02ANfwGcF9J
         Kjh0soAXnItkbX3oZ1izUa40jvZNHA71jWM/fwIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/142] net/mlx5e: free page before return
Date:   Tue,  2 Feb 2021 14:37:59 +0100
Message-Id: <20210202133002.495565077@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 258ed19f075fbc834fe5d69d8b54983fc11e0d4a ]

Instead of directly return, goto the error handling label to free
allocated page.

Fixes: 5f29458b77d5 ("net/mlx5e: Support dump callback in TX reporter")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
index 69a05da0e3e3d..e03e78a35df00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -275,7 +275,7 @@ int mlx5e_health_rsc_fmsg_dump(struct mlx5e_priv *priv, struct mlx5_rsc_key *key
 
 	err = devlink_fmsg_binary_pair_nest_start(fmsg, "data");
 	if (err)
-		return err;
+		goto free_page;
 
 	cmd = mlx5_rsc_dump_cmd_create(mdev, key);
 	if (IS_ERR(cmd)) {
-- 
2.27.0



