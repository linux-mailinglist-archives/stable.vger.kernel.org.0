Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C50323A6C9
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgHCMyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726610AbgHCMXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:23:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73E7220738;
        Mon,  3 Aug 2020 12:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457412;
        bh=soTYc1QE3Dv28sQn4ZvbPIO2zXj0JHGiazOciM5OGV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IY9bA/Mx0dM4QlhStAkdkB0PmGinIyFYjz+N3DnxJS1tgQwrwqnJAk7IvfFVV6K/C
         fKFJHX5ookXJoTu6y2JzcjBmkNfHElb1aW+XUZt4u1uf6FhDdbNk83rbnADHbQjNXs
         GcEkC0zp/Qwjd6AAxhJ5JxBZvrWDYEPVT3ila4U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 056/120] net/mlx5e: Fix error path of device attach
Date:   Mon,  3 Aug 2020 14:18:34 +0200
Message-Id: <20200803121905.524095852@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 5cd39b6e9a420329a9a408894be7ba8aa7dd755e ]

On failure to attach the netdev, fix the rollback by re-setting the
device's state back to MLX5E_STATE_DESTROYING.

Failing to attach doesn't stop statistics polling via .ndo_get_stats64.
In this case, although the device is not attached, it falsely continues
to query the firmware for counters. Setting the device's state back to
MLX5E_STATE_DESTROYING prevents the firmware counters query.

Fixes: 26e59d8077a3 ("net/mlx5e: Implement mlx5e interface attach/detach callbacks")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bc54913c58618..5f8c69ea82539 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5395,6 +5395,8 @@ err_cleanup_tx:
 	profile->cleanup_tx(priv);
 
 out:
+	set_bit(MLX5E_STATE_DESTROYING, &priv->state);
+	cancel_work_sync(&priv->update_stats_work);
 	return err;
 }
 
-- 
2.25.1



