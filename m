Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD985395E56
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231695AbhEaN5X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:57:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:59926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231985AbhEaNzX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8B8161922;
        Mon, 31 May 2021 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468054;
        bh=LsoKiz0LgUvPdMrttrhSxXoUXHbqGH7qU/UCtULSC+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIjswZTpKJNp13pwS0f6Rjlhy5SGFktXYTmHTyyBSzHuIlHoiBlkyMFUaZk0FRzbu
         I0Dgv/FXen8cMMIFzHPi4EhiIHYS+xDICRscS80jGTMvDX+UcWAi2W0+9M+wEtXUg9
         paHqLl6zw6HuYaJ4vh+WEw7+ES3LiTAh7EEiTlrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 099/252] net/mlx5e: Fix error path of updating netdev queues
Date:   Mon, 31 May 2021 15:12:44 +0200
Message-Id: <20210531130701.350912511@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

commit 5e7923acbd86d0ff29269688d8a9c47ad091dd46 upstream.

Avoid division by zero in the error flow. In the driver TC number can be
either 1 or 8. When TC count is set to 1, driver zero netdev->num_tc.
Hence, need to convert it back from 0 to 1 in the error flow.

Fixes: fa3748775b92 ("net/mlx5e: Handle errors from netif_set_real_num_{tx,rx}_queues")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2920,7 +2920,7 @@ static int mlx5e_update_netdev_queues(st
 	int err;
 
 	old_num_txqs = netdev->real_num_tx_queues;
-	old_ntc = netdev->num_tc;
+	old_ntc = netdev->num_tc ? : 1;
 
 	nch = priv->channels.params.num_channels;
 	ntc = priv->channels.params.num_tc;


