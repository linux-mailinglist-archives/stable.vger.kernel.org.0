Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C270613FD03
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390741AbgAPXU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:20:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389828AbgAPXU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:20:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 255372072B;
        Thu, 16 Jan 2020 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216855;
        bh=ryz0DtnBmWyMSdOhEb/SPsuUY2pi76zfMQQNJdVssdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vqtwex6ERBIWMChA5VA+53H2RzvgyaYIk61/tn3D5i4eynoGyZicSIu8HyRwEItX+
         gKjlaOlnjTB3mn8ToULGLj1A9oP7adFXHo7itcd76QEpEBVkQEDodV5TMB/0e8k4Up
         a3zlpPKTZNV6dmg7Zgk8JsTjjJ8LXyVQNEBzpO+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 031/203] hsr: rename debugfs file when interface name is changed
Date:   Fri, 17 Jan 2020 00:15:48 +0100
Message-Id: <20200116231747.003937873@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit 4c2d5e33dcd3a6333a7895be3b542ff3d373177c upstream.

hsr interface has own debugfs file, which name is same with interface name.
So, interface name is changed, debugfs file name should be changed too.

Fixes: fc4ecaeebd26 ("net: hsr: add debugfs support for display node list")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/hsr/hsr_debugfs.c |   13 +++++++++++++
 net/hsr/hsr_main.c    |    3 +++
 net/hsr/hsr_main.h    |    4 ++++
 3 files changed, 20 insertions(+)

--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -65,6 +65,19 @@ hsr_node_table_open(struct inode *inode,
 	return single_open(filp, hsr_node_table_show, inode->i_private);
 }
 
+void hsr_debugfs_rename(struct net_device *dev)
+{
+	struct hsr_priv *priv = netdev_priv(dev);
+	struct dentry *d;
+
+	d = debugfs_rename(hsr_debugfs_root_dir, priv->node_tbl_root,
+			   hsr_debugfs_root_dir, dev->name);
+	if (IS_ERR(d))
+		netdev_warn(dev, "failed to rename\n");
+	else
+		priv->node_tbl_root = d;
+}
+
 static const struct file_operations hsr_fops = {
 	.open	= hsr_node_table_open,
 	.read	= seq_read,
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -45,6 +45,9 @@ static int hsr_netdev_notify(struct noti
 	case NETDEV_CHANGE:	/* Link (carrier) state changes */
 		hsr_check_carrier_and_operstate(hsr);
 		break;
+	case NETDEV_CHANGENAME:
+		hsr_debugfs_rename(dev);
+		break;
 	case NETDEV_CHANGEADDR:
 		if (port->type == HSR_PT_MASTER) {
 			/* This should not happen since there's no
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -185,11 +185,15 @@ static inline u16 hsr_get_skb_sequence_n
 }
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
+void hsr_debugfs_rename(struct net_device *dev);
 void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
 void hsr_debugfs_term(struct hsr_priv *priv);
 void hsr_debugfs_create_root(void);
 void hsr_debugfs_remove_root(void);
 #else
+static inline void void hsr_debugfs_rename(struct net_device *dev)
+{
+}
 static inline void hsr_debugfs_init(struct hsr_priv *priv,
 				    struct net_device *hsr_dev)
 {}


