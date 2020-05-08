Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 233221CAEFE
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEHNNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:13:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728740AbgEHMsM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13723221F7;
        Fri,  8 May 2020 12:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942091;
        bh=q/kmPP6Ir4VfmUIesUjXrG4U/OMe+JwNA/OYDHF2O+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KZ+bVTDM+oE1Tzo4t79GpQ9VDSc+/54e3RKe0KJSeN4VKaz166MHlZvNveDzawRUP
         YRSJihFXbVxi6nDWarJvQnh52PhZjnJIR+fGdwzNvPDUJynqin9ilXgez5iCDC08Zj
         2DKffR2GcIxZ02UR7CsoKbG8leTqbKZ36u66zgm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 293/312] ovs/vxlan: fix rtnl notifications on iface deletion
Date:   Fri,  8 May 2020 14:34:44 +0200
Message-Id: <20200508123144.977180322@linuxfoundation.org>
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

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit cf5da330bbdd0c06b05c525a3d1d58ccd82c87a6 upstream.

The function vxlan_dev_create() (only used by ovs) never calls
rtnl_configure_link(). The consequence is that dev->rtnl_link_state is
never set to RTNL_LINK_INITIALIZED.
During the deletion phase, the function rollback_registered_many() sends
a RTM_DELLINK only if dev->rtnl_link_state is set to RTNL_LINK_INITIALIZED.

Note that the function vxlan_dev_create() is moved after the rtnl stuff so
that vxlan_dellink() can be called in this function.

Fixes: dcc38c033b32 ("openvswitch: Re-add CONFIG_OPENVSWITCH_VXLAN")
CC: Thomas Graf <tgraf@suug.ch>
CC: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/vxlan.c |   58 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 34 insertions(+), 24 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2927,30 +2927,6 @@ static int vxlan_dev_configure(struct ne
 	return 0;
 }
 
-struct net_device *vxlan_dev_create(struct net *net, const char *name,
-				    u8 name_assign_type, struct vxlan_config *conf)
-{
-	struct nlattr *tb[IFLA_MAX+1];
-	struct net_device *dev;
-	int err;
-
-	memset(&tb, 0, sizeof(tb));
-
-	dev = rtnl_create_link(net, name, name_assign_type,
-			       &vxlan_link_ops, tb);
-	if (IS_ERR(dev))
-		return dev;
-
-	err = vxlan_dev_configure(net, dev, conf);
-	if (err < 0) {
-		free_netdev(dev);
-		return ERR_PTR(err);
-	}
-
-	return dev;
-}
-EXPORT_SYMBOL_GPL(vxlan_dev_create);
-
 static int vxlan_newlink(struct net *src_net, struct net_device *dev,
 			 struct nlattr *tb[], struct nlattr *data[])
 {
@@ -3218,6 +3194,40 @@ static struct rtnl_link_ops vxlan_link_o
 	.get_link_net	= vxlan_get_link_net,
 };
 
+struct net_device *vxlan_dev_create(struct net *net, const char *name,
+				    u8 name_assign_type,
+				    struct vxlan_config *conf)
+{
+	struct nlattr *tb[IFLA_MAX + 1];
+	struct net_device *dev;
+	int err;
+
+	memset(&tb, 0, sizeof(tb));
+
+	dev = rtnl_create_link(net, name, name_assign_type,
+			       &vxlan_link_ops, tb);
+	if (IS_ERR(dev))
+		return dev;
+
+	err = vxlan_dev_configure(net, dev, conf);
+	if (err < 0) {
+		free_netdev(dev);
+		return ERR_PTR(err);
+	}
+
+	err = rtnl_configure_link(dev, NULL);
+	if (err < 0) {
+		LIST_HEAD(list_kill);
+
+		vxlan_dellink(dev, &list_kill);
+		unregister_netdevice_many(&list_kill);
+		return ERR_PTR(err);
+	}
+
+	return dev;
+}
+EXPORT_SYMBOL_GPL(vxlan_dev_create);
+
 static void vxlan_handle_lowerdev_unregister(struct vxlan_net *vn,
 					     struct net_device *dev)
 {


