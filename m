Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301F63961B2
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhEaOpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232172AbhEaOmo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:42:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 869AB61C6D;
        Mon, 31 May 2021 13:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469242;
        bh=vBallheY1b18VIHQfS+YpjiByLEsaPPy9KY9zRE8Ha4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AIcSBR+sC0FCWgprUNAeG23uXQo0ZmLw2tEODnEp0YZLSM64y8K8U00/K0AP5XahB
         f1P0RW4JmHZQ0UCFDOTNJc5eMj5upekzdofV0C2UOMHG51zaas8oGo/aOy6Iasn6c2
         SSOvVqNuGh8tFHUzTyYhCrMQC9jbNO31GJVqFVjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dima Chumak <dchumak@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.12 123/296] net/mlx5e: Fix nullptr in add_vlan_push_action()
Date:   Mon, 31 May 2021 15:12:58 +0200
Message-Id: <20210531130708.041772300@linuxfoundation.org>
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
@@ -3430,8 +3430,12 @@ static int add_vlan_push_action(struct m
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
 


