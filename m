Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460A945B624
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 09:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbhKXIGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 03:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240929AbhKXIGj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 03:06:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AD2960F5B;
        Wed, 24 Nov 2021 08:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637741009;
        bh=EmcwW4TTGZoJeSwgLSQznUFA4oTdFVj7aoAikloNhV0=;
        h=Subject:To:Cc:From:Date:From;
        b=bPrg3K3hdAbgPQdzzjGOi12W17SM4fWsACwzXr9za7v82wTF75w6qm2Mr9mFHb6ei
         j7CMEW+Jh8yggizSPufE16lFQ/0njYsiahar2G4NVpSxKnOEheo0i0wVVzLlwvLrYQ
         CQtPlMN6DVXPRji6rAFyedxtrHKIHC9CLvA9FBSk=
Subject: FAILED: patch "[PATCH] net/mlx5: Set devlink reload feature bit for supported" failed to apply to 5.10-stable tree
To:     leon@kernel.org, kuba@kernel.org, leonro@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Nov 2021 09:03:27 +0100
Message-ID: <1637741007150100@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 96869f193cfd26c2b47db32e4d8bcad50461df7a Mon Sep 17 00:00:00 2001
From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 12 Oct 2021 16:15:25 +0300
Subject: [PATCH] net/mlx5: Set devlink reload feature bit for supported
 devices only

Mulitport slave device doesn't support devlink reload, so instead of
complicating initialization flow with devlink_reload_enable() which
will be removed in next patch, don't set DEVLINK_F_RELOAD feature bit
for such devices.

This fixes an error when reload counters exposed (and equal zero) for
the mode that is not supported at all.

Fixes: d89ddaae1766 ("net/mlx5: Disable devlink reload for multi port slave device")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index fa98b7b95990..a85341a41cd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -796,6 +796,7 @@ static void mlx5_devlink_traps_unregister(struct devlink *devlink)
 
 int mlx5_devlink_register(struct devlink *devlink)
 {
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	int err;
 
 	err = devlink_params_register(devlink, mlx5_devlink_params,
@@ -813,7 +814,9 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
-	devlink_set_features(devlink, DEVLINK_F_RELOAD);
+	if (!mlx5_core_is_mp_slave(dev))
+		devlink_set_features(devlink, DEVLINK_F_RELOAD);
+
 	return 0;
 
 traps_reg_err:

