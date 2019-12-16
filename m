Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2E81218EA
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfLPRzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:52310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727791AbfLPRzQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:55:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 461B320663;
        Mon, 16 Dec 2019 17:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518915;
        bh=JuIU6evUP0TJkyze9RRlQ4q5lVJ+JG69SdDkDI2hhDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqz2dlpjFPxbFoHNCzc9YliOCe8ykiwzDtoG99Vsb8R1j0aFxugZyU930dzs0QATd
         klGPYKz9rjdn0xZSZLV8V2/HjcwSERiMgD4Pi3X7luiAfoAH00UkW8YhMENw27Vzim
         ZwqyX+NWhldeN4RV5glFW48F/7SgWRh+8o+tZs9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erez Alfasi <ereza@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/267] net/mlx4_core: Fix return codes of unsupported operations
Date:   Mon, 16 Dec 2019 18:47:08 +0100
Message-Id: <20191216174902.302005230@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

[ Upstream commit 95aac2cdafd8c8298c9b2589c52f44db0d824e0e ]

Functions __set_port_type and mlx4_check_port_params returned
-EINVAL while the proper return code is -EOPNOTSUPP as a
result of an unsupported operation. All drivers should generate
this and all users should check for it when detecting an
unsupported functionality.

Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index c273a3ebb8e8e..12d4b891301b6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -199,7 +199,7 @@ int mlx4_check_port_params(struct mlx4_dev *dev,
 		for (i = 0; i < dev->caps.num_ports - 1; i++) {
 			if (port_type[i] != port_type[i + 1]) {
 				mlx4_err(dev, "Only same port types supported on this HCA, aborting\n");
-				return -EINVAL;
+				return -EOPNOTSUPP;
 			}
 		}
 	}
@@ -208,7 +208,7 @@ int mlx4_check_port_params(struct mlx4_dev *dev,
 		if (!(port_type[i] & dev->caps.supported_type[i+1])) {
 			mlx4_err(dev, "Requested port type for port %d is not supported on this HCA\n",
 				 i + 1);
-			return -EINVAL;
+			return -EOPNOTSUPP;
 		}
 	}
 	return 0;
@@ -1152,8 +1152,7 @@ static int __set_port_type(struct mlx4_port_info *info,
 		mlx4_err(mdev,
 			 "Requested port type for port %d is not supported on this HCA\n",
 			 info->port);
-		err = -EINVAL;
-		goto err_sup;
+		return -EOPNOTSUPP;
 	}
 
 	mlx4_stop_sense(mdev);
@@ -1175,7 +1174,7 @@ static int __set_port_type(struct mlx4_port_info *info,
 		for (i = 1; i <= mdev->caps.num_ports; i++) {
 			if (mdev->caps.possible_type[i] == MLX4_PORT_TYPE_AUTO) {
 				mdev->caps.possible_type[i] = mdev->caps.port_type[i];
-				err = -EINVAL;
+				err = -EOPNOTSUPP;
 			}
 		}
 	}
@@ -1201,7 +1200,7 @@ static int __set_port_type(struct mlx4_port_info *info,
 out:
 	mlx4_start_sense(mdev);
 	mutex_unlock(&priv->port_mutex);
-err_sup:
+
 	return err;
 }
 
-- 
2.20.1



