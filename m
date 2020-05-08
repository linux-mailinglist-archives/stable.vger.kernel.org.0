Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6C41CAB93
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729236AbgEHMox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:44:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729231AbgEHMox (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:44:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 214A42495A;
        Fri,  8 May 2020 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941892;
        bh=MB83QPSoL95EKBr0vIg9VrJK1pmMrqaJQJgm4nuvmbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MzH4NHzQq/WWz/dWMLyULqAJrC+tXHSpLXQ47G3q1k+UYZv+KY2X/BnraWvW4y3/L
         PPz71465tyZBUYkS6biW0NWdosN6VNg7yL4CrWbNyRCRX/oqbwq0QIJBTUr2zj4hC6
         6Ck+mKkyXAZTQq7pVvcFTXfs0StoyYlRBcqhn0Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Heib <kamalh@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 214/312] net/mlx4_en: Fix the return value of a failure in VLAN VID add/kill
Date:   Fri,  8 May 2020 14:33:25 +0200
Message-Id: <20200508123139.481256551@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalh@mellanox.com>

commit 93c098af09455ea7bdc6f0f6b08f6ac14fa06cf4 upstream.

Modify mlx4_en_vlan_rx_[add/kill]_vid to return error value in case of
failure.

Fixes: 8e586137e6b6 ('net: make vlan ndo_vlan_rx_[add/kill]_vid return error value')
Signed-off-by: Kamal Heib <kamalh@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -424,14 +424,18 @@ static int mlx4_en_vlan_rx_add_vid(struc
 	mutex_lock(&mdev->state_lock);
 	if (mdev->device_up && priv->port_up) {
 		err = mlx4_SET_VLAN_FLTR(mdev->dev, priv);
-		if (err)
+		if (err) {
 			en_err(priv, "Failed configuring VLAN filter\n");
+			goto out;
+		}
 	}
-	if (mlx4_register_vlan(mdev->dev, priv->port, vid, &idx))
-		en_dbg(HW, priv, "failed adding vlan %d\n", vid);
-	mutex_unlock(&mdev->state_lock);
+	err = mlx4_register_vlan(mdev->dev, priv->port, vid, &idx);
+	if (err)
+		en_dbg(HW, priv, "Failed adding vlan %d\n", vid);
 
-	return 0;
+out:
+	mutex_unlock(&mdev->state_lock);
+	return err;
 }
 
 static int mlx4_en_vlan_rx_kill_vid(struct net_device *dev,
@@ -439,7 +443,7 @@ static int mlx4_en_vlan_rx_kill_vid(stru
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
-	int err;
+	int err = 0;
 
 	en_dbg(HW, priv, "Killing VID:%d\n", vid);
 
@@ -456,7 +460,7 @@ static int mlx4_en_vlan_rx_kill_vid(stru
 	}
 	mutex_unlock(&mdev->state_lock);
 
-	return 0;
+	return err;
 }
 
 static void mlx4_en_u64_to_mac(unsigned char dst_mac[ETH_ALEN + 2], u64 src_mac)


