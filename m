Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71C9395E59
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhEaN5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231843AbhEaNzb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3323461438;
        Mon, 31 May 2021 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468059;
        bh=QNIFF73Sw1QWHUeB332tv0d14bDPDTq2zZcpI4cWW+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J8cTEpTkoN3MJLOUki+cypTmjKY8TONOxHONN5XYKShweJYUkFSWCq6n4XF1gQ/C8
         s4pMGq9+xNsTEYUYu6sYlivLUu91OwQ/kO3ekkw1n2dNBcKvE7+efi6pSt1KaHcwPs
         GUK3Tuv6rl5HlQgEzUtIrv17BEF7ZXk/i8BEU3Ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 101/252] net/mlx5e: Fix nullptr in add_vlan_push_action()
Date:   Mon, 31 May 2021 15:12:46 +0200
Message-Id: <20210531130701.428616818@linuxfoundation.org>
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

From: Dima Chumak <dchumak@nvidia.com>

commit dca59f4a791960ec73fa15803faa0abe0f92ece2 upstream.

The result of dev_get_by_index_rcu() is not checked for NULL and then
gets dereferenced immediately.

Also, the RCU lock must be held by the caller of dev_get_by_index_rcu(),
which isn't satisfied by the call stack.

Fix by handling nullptr return value when iflink device is not found.
Add RCU locking around dev_get_by_index_rcu() to avoid possible adverse
effects while iterating over the net_device's hlist.

It is safe not to increment reference count of the net_device pointer in
case of a successful lookup, because it's already handled by VLAN code
during VLAN device registration (see register_vlan_dev and
netdev_upper_dev_link).

Fixes: 278748a95aa3 ("net/mlx5e: Offload TC e-switch rules with egress VLAN device")
Addresses-Coverity: ("Dereference null return value")
Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4025,8 +4025,12 @@ static int add_vlan_push_action(struct m
 	if (err)
 		return err;
 
-	*out_dev = dev_get_by_index_rcu(dev_net(vlan_dev),
-					dev_get_iflink(vlan_dev));
+	rcu_read_lock();
+	*out_dev = dev_get_by_index_rcu(dev_net(vlan_dev), dev_get_iflink(vlan_dev));
+	rcu_read_unlock();
+	if (!*out_dev)
+		return -ENODEV;
+
 	if (is_vlan_dev(*out_dev))
 		err = add_vlan_push_action(priv, attr, out_dev, action);
 


