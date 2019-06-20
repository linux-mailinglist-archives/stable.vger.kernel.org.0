Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21FF94D787
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfFTSTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:19:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfFTSOn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCEDE205F4;
        Thu, 20 Jun 2019 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054482;
        bh=SNhhTNTNJjo7lSzoUKnyQTkQF6RVht3rNB5TOKxyCyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFNdLLql6jGRtJfj1H1r8My7AYgvAAFCuYH4L4YJNleY8UsMZMXxJ3k/QU4twkynd
         k03kgWDAeCTE9O1Vd+5DgL+jOUyI29XxDqKvemW6zVoRnSIZGQzDR0W9QWJaVW5hK0
         u7MgOeCHqBPXWP8gUV8QwprqtOw4KI4myeNrorYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.1 16/98] net/mlx5: Avoid reloading already removed devices
Date:   Thu, 20 Jun 2019 19:56:43 +0200
Message-Id: <20190620174350.025778024@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

Prior to reloading a device we must first verify that it was not already
removed. Otherwise, the attempt to remove the device will do nothing, and
in that case we will end up proceeding with adding an new device that no
one was expecting to remove, leaving behind used resources such as EQs that
causes a failure to destroy comp EQs and syndrome (0x30f433).

Fix that by making sure that we try to remove and add a device (based on a
protocol) only if the device is already added.

Fixes: c5447c70594b ("net/mlx5: E-Switch, Reload IB interface when switching devlink modes")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -248,11 +248,32 @@ void mlx5_unregister_interface(struct ml
 }
 EXPORT_SYMBOL(mlx5_unregister_interface);
 
+/* Must be called with intf_mutex held */
+static bool mlx5_has_added_dev_by_protocol(struct mlx5_core_dev *mdev, int protocol)
+{
+	struct mlx5_device_context *dev_ctx;
+	struct mlx5_interface *intf;
+	bool found = false;
+
+	list_for_each_entry(intf, &intf_list, list) {
+		if (intf->protocol == protocol) {
+			dev_ctx = mlx5_get_device(intf, &mdev->priv);
+			if (dev_ctx && test_bit(MLX5_INTERFACE_ADDED, &dev_ctx->state))
+				found = true;
+			break;
+		}
+	}
+
+	return found;
+}
+
 void mlx5_reload_interface(struct mlx5_core_dev *mdev, int protocol)
 {
 	mutex_lock(&mlx5_intf_mutex);
-	mlx5_remove_dev_by_protocol(mdev, protocol);
-	mlx5_add_dev_by_protocol(mdev, protocol);
+	if (mlx5_has_added_dev_by_protocol(mdev, protocol)) {
+		mlx5_remove_dev_by_protocol(mdev, protocol);
+		mlx5_add_dev_by_protocol(mdev, protocol);
+	}
 	mutex_unlock(&mlx5_intf_mutex);
 }
 


