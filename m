Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DEB395D5A
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhEaNo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhEaNmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CBA261482;
        Mon, 31 May 2021 13:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467713;
        bh=GQydZjDT4wPdUn9WToJFxN5ZGS2Al09Z1XjGbD6BL0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NjQh/oNJ6ysAMGRB354ZLz7UE0Y2DErnkXZhrh7mlxNAoZrcLvPrcbb/wq65GSyq8
         3xYJ35tSW5DidVekLsIYLT5/KWOHFx5I4Kipi5TSLVBmyUFtQeE0ZPu8V/99BYQvvZ
         u5Oqh0lsI9xFC4CBy5a3XVSt4Di7EHghs9t8/x7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 53/79] libertas: register sysfs groups properly
Date:   Mon, 31 May 2021 15:14:38 +0200
Message-Id: <20210531130637.702320665@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 7e79b38fe9a403b065ac5915465f620a8fb3de84 ]

The libertas driver was trying to register sysfs groups "by hand" which
causes them to be created _after_ the device is initialized and
announced to userspace, which causes races and can prevent userspace
tools from seeing the sysfs files correctly.

Fix this up by using the built-in sysfs_groups pointers in struct
net_device which were created for this very reason, fixing the race
condition, and properly allowing for any error that might have occured
to be handled properly.

Cc: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210503115736.2104747-54-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/mesh.c | 28 +++-----------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/mesh.c b/drivers/net/wireless/marvell/libertas/mesh.c
index b0cb16ef8d1d..b313c78e2154 100644
--- a/drivers/net/wireless/marvell/libertas/mesh.c
+++ b/drivers/net/wireless/marvell/libertas/mesh.c
@@ -793,19 +793,6 @@ static const struct attribute_group mesh_ie_group = {
 	.attrs = mesh_ie_attrs,
 };
 
-static void lbs_persist_config_init(struct net_device *dev)
-{
-	int ret;
-	ret = sysfs_create_group(&(dev->dev.kobj), &boot_opts_group);
-	ret = sysfs_create_group(&(dev->dev.kobj), &mesh_ie_group);
-}
-
-static void lbs_persist_config_remove(struct net_device *dev)
-{
-	sysfs_remove_group(&(dev->dev.kobj), &boot_opts_group);
-	sysfs_remove_group(&(dev->dev.kobj), &mesh_ie_group);
-}
-
 
 /***************************************************************************
  * Initializing and starting, stopping mesh
@@ -1005,6 +992,10 @@ static int lbs_add_mesh(struct lbs_private *priv)
 	SET_NETDEV_DEV(priv->mesh_dev, priv->dev->dev.parent);
 
 	mesh_dev->flags |= IFF_BROADCAST | IFF_MULTICAST;
+	mesh_dev->sysfs_groups[0] = &lbs_mesh_attr_group;
+	mesh_dev->sysfs_groups[1] = &boot_opts_group;
+	mesh_dev->sysfs_groups[2] = &mesh_ie_group;
+
 	/* Register virtual mesh interface */
 	ret = register_netdev(mesh_dev);
 	if (ret) {
@@ -1012,19 +1003,10 @@ static int lbs_add_mesh(struct lbs_private *priv)
 		goto err_free_netdev;
 	}
 
-	ret = sysfs_create_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
-	if (ret)
-		goto err_unregister;
-
-	lbs_persist_config_init(mesh_dev);
-
 	/* Everything successful */
 	ret = 0;
 	goto done;
 
-err_unregister:
-	unregister_netdev(mesh_dev);
-
 err_free_netdev:
 	free_netdev(mesh_dev);
 
@@ -1045,8 +1027,6 @@ void lbs_remove_mesh(struct lbs_private *priv)
 
 	netif_stop_queue(mesh_dev);
 	netif_carrier_off(mesh_dev);
-	sysfs_remove_group(&(mesh_dev->dev.kobj), &lbs_mesh_attr_group);
-	lbs_persist_config_remove(mesh_dev);
 	unregister_netdev(mesh_dev);
 	priv->mesh_dev = NULL;
 	kfree(mesh_dev->ieee80211_ptr);
-- 
2.30.2



