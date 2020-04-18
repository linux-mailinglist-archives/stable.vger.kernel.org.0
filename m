Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0CA61AEB96
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 12:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgDRKMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 06:12:23 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:34291 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725799AbgDRKMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 06:12:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 6C9DA67B;
        Sat, 18 Apr 2020 06:12:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 18 Apr 2020 06:12:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/OOqKD
        vZWVuyMbgXID/JVm4fKpcsn3cS/0Wc5D+fsV0=; b=2PMxeqcbLstCOucoU04flH
        o5I48vgqtVcONxGP8H+w3nXOcKiYIxn08vXb01rAElTcMFelN2SbCVS6jVHql1hD
        ixLYJpEvV2ge1HfINJ6kBFYGO1k8e7IQSwsXPnRpdICEi+YsTpWLY7tXkuGTWNWP
        glHoTp3LKh5PFBAQujUzbFKtyIt9uNXQumbWsfrvpsl9oreWSTvZ2GsaiqBBtc2m
        ot0Su4SgIkUNlZrI72wE+F/rz0BZT37cnSm07ThhK7QilPfPHemPwZxnIgRNc8eV
        MCQ/JDOoN4OPdtILOGwbMB77hclwF7Lk1THInQn2yl+fhNoYQcLd2tb3/qpSTS1g
        ==
X-ME-Sender: <xms:hdKaXqxFNwlVIYaYLLxZZ6Kab5rvxn5Vo46yiU6fh5Aeo0oVfOquCg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeelgddvjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hdKaXin8MqUre2buyU6n9bhkzHkQEEnG2Jgy_2deiNhdoIeyC34xHg>
    <xmx:hdKaXt_VA-PHkRc_vFXXDMHQXvzYUAodbQBb4rTNbxt3e7fwDqP7bw>
    <xmx:hdKaXtoooe8jQWY2FKB5uaWeKRu_XLLQCDqP7dBi_4ESQSleYLCgMw>
    <xmx:htKaXubsCrmGsRq8PH8fWiKT1xaXGHEd-JBZeD1Uw3euJr0kJUzM-NZhaPk>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8A96328005D;
        Sat, 18 Apr 2020 06:12:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] net/mlx5e: Use preactivate hook to set the indirection table" failed to apply to 5.4-stable tree
To:     maximmi@mellanox.com, saeedm@mellanox.com, tariqt@mellanox.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 18 Apr 2020 12:12:11 +0200
Message-ID: <158720473110942@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fe867cac9e1967c553e4ac2aece5fc8675258010 Mon Sep 17 00:00:00 2001
From: Maxim Mikityanskiy <maximmi@mellanox.com>
Date: Mon, 4 Nov 2019 12:02:14 +0200
Subject: [PATCH] net/mlx5e: Use preactivate hook to set the indirection table

mlx5e_ethtool_set_channels updates the indirection table before
switching to the new channels. If the switch fails, the indirection
table is new, but the channels are old, which is wrong. Fix it by using
the preactivate hook of mlx5e_safe_switch_channels to update the
indirection table at the stage when nothing can fail anymore.

As the code that updates the indirection table is now encapsulated into
a new function, use that function in the attach flow when the driver has
to reduce the number of channels, and prepare the code for the next
commit.

Fixes: 85082dba0a ("net/mlx5e: Correctly handle RSS indirection table when changing number of channels")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index bc2c96b34de1..4ddccab02a4b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1043,6 +1043,7 @@ int mlx5e_safe_reopen_channels(struct mlx5e_priv *priv);
 int mlx5e_safe_switch_channels(struct mlx5e_priv *priv,
 			       struct mlx5e_channels *new_chs,
 			       mlx5e_fp_preactivate preactivate);
+int mlx5e_num_channels_changed(struct mlx5e_priv *priv);
 void mlx5e_activate_priv_channels(struct mlx5e_priv *priv);
 void mlx5e_deactivate_priv_channels(struct mlx5e_priv *priv);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 68b520df07e4..ff7f5a931520 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -432,9 +432,7 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		*cur_params = new_channels.params;
-		if (!netif_is_rxfh_configured(priv->netdev))
-			mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-						      MLX5E_INDIR_RQT_SIZE, count);
+		mlx5e_num_channels_changed(priv);
 		goto out;
 	}
 
@@ -442,12 +440,8 @@ int mlx5e_ethtool_set_channels(struct mlx5e_priv *priv,
 	if (arfs_enabled)
 		mlx5e_arfs_disable(priv);
 
-	if (!netif_is_rxfh_configured(priv->netdev))
-		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-					      MLX5E_INDIR_RQT_SIZE, count);
-
 	/* Switch to new channels, set new parameters and close old ones */
-	err = mlx5e_safe_switch_channels(priv, &new_channels, NULL);
+	err = mlx5e_safe_switch_channels(priv, &new_channels, mlx5e_num_channels_changed);
 
 	if (arfs_enabled) {
 		int err2 = mlx5e_arfs_enable(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 152aa5d7df79..bbe8c32fb423 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2880,6 +2880,17 @@ static void mlx5e_update_netdev_queues(struct mlx5e_priv *priv)
 	netif_set_real_num_rx_queues(netdev, num_rxqs);
 }
 
+int mlx5e_num_channels_changed(struct mlx5e_priv *priv)
+{
+	u16 count = priv->channels.params.num_channels;
+
+	if (!netif_is_rxfh_configured(priv->netdev))
+		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
+					      MLX5E_INDIR_RQT_SIZE, count);
+
+	return 0;
+}
+
 static void mlx5e_build_txq_maps(struct mlx5e_priv *priv)
 {
 	int i, ch;
@@ -5288,9 +5299,10 @@ int mlx5e_attach_netdev(struct mlx5e_priv *priv)
 	max_nch = mlx5e_get_max_num_channels(priv->mdev);
 	if (priv->channels.params.num_channels > max_nch) {
 		mlx5_core_warn(priv->mdev, "MLX5E: Reducing number of channels to %d\n", max_nch);
+		/* Reducing the number of channels - RXFH has to be reset. */
+		priv->netdev->priv_flags &= ~IFF_RXFH_CONFIGURED;
 		priv->channels.params.num_channels = max_nch;
-		mlx5e_build_default_indir_rqt(priv->rss_params.indirection_rqt,
-					      MLX5E_INDIR_RQT_SIZE, max_nch);
+		mlx5e_num_channels_changed(priv);
 	}
 
 	err = profile->init_tx(priv);

