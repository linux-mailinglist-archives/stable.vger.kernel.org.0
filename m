Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D1F1331BB
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgAGVDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:03:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:45734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728929AbgAGVDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:03:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EEB92077B;
        Tue,  7 Jan 2020 21:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431012;
        bh=RQwPlijfxf7jo2do6WvjL3xxdq2kbHIzLdvt0P3xetg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L34ZGhJ5OV0gWPeXG8qWk91hrqh6M4MvL5+E8Tt/GqxxENesz7ikoWCgrO50nSMsW
         dgeRFASLiItw9wKJbmvMnlB6Um5Ptt8ZzgxRkKKxnQHEIXMRgsvX1IB7aRB+Mm1hqy
         /az0Sq3wd2zRodavFYfRETZFTCYqo1GMcOVClGdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 189/191] hsr: fix error handling routine in hsr_dev_finalize()
Date:   Tue,  7 Jan 2020 21:55:09 +0100
Message-Id: <20200107205343.102463024@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 1d19e2d53e8ed9e4c98fc95e0067492cda7288b0 ]

hsr_dev_finalize() is called to create new hsr interface.
There are some wrong error handling codes.

1. wrong checking return value of debugfs_create_{dir/file}.
These function doesn't return NULL. If error occurs in there,
it returns error pointer.
So, it should check error pointer instead of NULL.

2. It doesn't unregister interface if it fails to setup hsr interface.
If it fails to initialize hsr interface after register_netdevice(),
it should call unregister_netdevice().

3. Ignore failure of creation of debugfs
If creating of debugfs dir and file is failed, creating hsr interface
will be failed. But debugfs doesn't affect actual logic of hsr module.
So, ignoring this is more correct and this behavior is more general.

Fixes: c5a759117210 ("net/hsr: Use list_head (and rcu) instead of array for slave devices.")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_debugfs.c | 15 +++++++--------
 net/hsr/hsr_device.c  | 19 ++++++++++---------
 net/hsr/hsr_main.h    | 11 ++++-------
 3 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/net/hsr/hsr_debugfs.c b/net/hsr/hsr_debugfs.c
index 6135706f03d5..6618a9d8e58e 100644
--- a/net/hsr/hsr_debugfs.c
+++ b/net/hsr/hsr_debugfs.c
@@ -77,15 +77,14 @@ static const struct file_operations hsr_fops = {
  * When debugfs is configured this routine sets up the node_table file per
  * hsr device for dumping the node_table entries
  */
-int hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
+void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 {
-	int rc = -1;
 	struct dentry *de = NULL;
 
 	de = debugfs_create_dir(hsr_dev->name, NULL);
-	if (!de) {
+	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr debugfs root\n");
-		return rc;
+		return;
 	}
 
 	priv->node_tbl_root = de;
@@ -93,13 +92,13 @@ int hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev)
 	de = debugfs_create_file("node_table", S_IFREG | 0444,
 				 priv->node_tbl_root, priv,
 				 &hsr_fops);
-	if (!de) {
+	if (IS_ERR(de)) {
 		pr_err("Cannot create hsr node_table directory\n");
-		return rc;
+		debugfs_remove(priv->node_tbl_root);
+		priv->node_tbl_root = NULL;
+		return;
 	}
 	priv->node_tbl_file = de;
-
-	return 0;
 }
 
 /* hsr_debugfs_term - Tear down debugfs intrastructure
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index b01e1bae4ddc..e73549075a03 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -477,30 +477,31 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 
 	res = hsr_add_port(hsr, hsr_dev, HSR_PT_MASTER);
 	if (res)
-		goto err_add_port;
+		goto err_add_master;
 
 	res = register_netdevice(hsr_dev);
 	if (res)
-		goto fail;
+		goto err_unregister;
 
 	res = hsr_add_port(hsr, slave[0], HSR_PT_SLAVE_A);
 	if (res)
-		goto fail;
+		goto err_add_slaves;
+
 	res = hsr_add_port(hsr, slave[1], HSR_PT_SLAVE_B);
 	if (res)
-		goto fail;
+		goto err_add_slaves;
 
+	hsr_debugfs_init(hsr, hsr_dev);
 	mod_timer(&hsr->prune_timer, jiffies + msecs_to_jiffies(PRUNE_PERIOD));
-	res = hsr_debugfs_init(hsr, hsr_dev);
-	if (res)
-		goto fail;
 
 	return 0;
 
-fail:
+err_add_slaves:
+	unregister_netdevice(hsr_dev);
+err_unregister:
 	list_for_each_entry_safe(port, tmp, &hsr->ports, port_list)
 		hsr_del_port(port);
-err_add_port:
+err_add_master:
 	hsr_del_self_node(&hsr->self_node_db);
 
 	return res;
diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
index 96fac696a1e1..acab9c353a49 100644
--- a/net/hsr/hsr_main.h
+++ b/net/hsr/hsr_main.h
@@ -184,15 +184,12 @@ static inline u16 hsr_get_skb_sequence_nr(struct sk_buff *skb)
 }
 
 #if IS_ENABLED(CONFIG_DEBUG_FS)
-int hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
+void hsr_debugfs_init(struct hsr_priv *priv, struct net_device *hsr_dev);
 void hsr_debugfs_term(struct hsr_priv *priv);
 #else
-static inline int hsr_debugfs_init(struct hsr_priv *priv,
-				   struct net_device *hsr_dev)
-{
-	return 0;
-}
-
+static inline void hsr_debugfs_init(struct hsr_priv *priv,
+				    struct net_device *hsr_dev)
+{}
 static inline void hsr_debugfs_term(struct hsr_priv *priv)
 {}
 #endif
-- 
2.20.1



