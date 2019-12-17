Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8795A123709
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 21:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbfLQUQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 15:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbfLQUQn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 15:16:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D3B421775;
        Tue, 17 Dec 2019 20:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576613803;
        bh=FfnKSyZoMFlkOL6GydMHuUSODldEug/qdjcyseevXTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lRMeS4YPPHUGYYoqImv8r3YiCgcd0vdkh6WHcqFSVKJ2QcN4WCaO5dcudbaEHGpHJ
         yHk06ohy3Fk6x+jMzoPBl7kZymN91V28FnqC+D1tXljZrOkIOdVY26i+Q8F7Lvvdl5
         dvoDsSC2o2RmtpzWj/+E9SMyIRH5N68t+ryaz47k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.3 13/25] net/mlx5e: Query global pause state before setting prio2buffer
Date:   Tue, 17 Dec 2019 21:16:12 +0100
Message-Id: <20191217200908.692563588@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217200903.179327435@linuxfoundation.org>
References: <20191217200903.179327435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

[ Upstream commit 73e6551699a32fac703ceea09214d6580edcf2d5 ]

When the user changes prio2buffer mapping while global pause is
enabled, mlx5 driver incorrectly sets all active buffers
(buffer that has at least one priority mapped) to lossy.

Solution:
If global pause is enabled, set all the active buffers to lossless
in prio2buffer command.
Also, add error message when buffer size is not enough to meet
xoff threshold.

Fixes: 0696d60853d5 ("net/mlx5e: Receive buffer configuration")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c |   27 +++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -155,8 +155,11 @@ static int update_xoff_threshold(struct
 		}
 
 		if (port_buffer->buffer[i].size <
-		    (xoff + max_mtu + (1 << MLX5E_BUFFER_CELL_SHIFT)))
+		    (xoff + max_mtu + (1 << MLX5E_BUFFER_CELL_SHIFT))) {
+			pr_err("buffer_size[%d]=%d is not enough for lossless buffer\n",
+			       i, port_buffer->buffer[i].size);
 			return -ENOMEM;
+		}
 
 		port_buffer->buffer[i].xoff = port_buffer->buffer[i].size - xoff;
 		port_buffer->buffer[i].xon  =
@@ -232,6 +235,26 @@ static int update_buffer_lossy(unsigned
 	return 0;
 }
 
+static int fill_pfc_en(struct mlx5_core_dev *mdev, u8 *pfc_en)
+{
+	u32 g_rx_pause, g_tx_pause;
+	int err;
+
+	err = mlx5_query_port_pause(mdev, &g_rx_pause, &g_tx_pause);
+	if (err)
+		return err;
+
+	/* If global pause enabled, set all active buffers to lossless.
+	 * Otherwise, check PFC setting.
+	 */
+	if (g_rx_pause || g_tx_pause)
+		*pfc_en = 0xff;
+	else
+		err = mlx5_query_port_pfc(mdev, pfc_en, NULL);
+
+	return err;
+}
+
 #define MINIMUM_MAX_MTU 9216
 int mlx5e_port_manual_buffer_config(struct mlx5e_priv *priv,
 				    u32 change, unsigned int mtu,
@@ -277,7 +300,7 @@ int mlx5e_port_manual_buffer_config(stru
 
 	if (change & MLX5E_PORT_BUFFER_PRIO2BUFFER) {
 		update_prio2buffer = true;
-		err = mlx5_query_port_pfc(priv->mdev, &curr_pfc_en, NULL);
+		err = fill_pfc_en(priv->mdev, &curr_pfc_en);
 		if (err)
 			return err;
 


