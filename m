Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F09939619E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhEaOnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:43:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233927AbhEaOlj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:41:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEBA46187E;
        Mon, 31 May 2021 13:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469235;
        bh=Qo4AIO8J4uPJItib0fKeMxOvEoxqby2/ZDw1lXjxmDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfhLYNr+zVyWXDrstvX0Oi3Ry72X1dH4q5LinYj8d7fcTcRFUbgVB77NKaLdpwgcz
         gqtErk9hkhVNui+eftIBJZdgyqs7QHRJp1sF6gmA0wI/8vW+2bRVyr/L5IHys+vy+Z
         BZYEXIlNYHFUppL9En/oy54cmpIvscfowGPP+Bdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.12 120/296] net/mlx5e: Fix error path of updating netdev queues
Date:   Mon, 31 May 2021 15:12:55 +0200
Message-Id: <20210531130707.947355601@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
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
@@ -3027,7 +3027,7 @@ static int mlx5e_update_netdev_queues(st
 	int err;
 
 	old_num_txqs = netdev->real_num_tx_queues;
-	old_ntc = netdev->num_tc;
+	old_ntc = netdev->num_tc ? : 1;
 
 	nch = priv->channels.params.num_channels;
 	ntc = priv->channels.params.num_tc;


