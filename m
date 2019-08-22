Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF93B99D06
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404994AbfHVRjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:39:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404157AbfHVRYT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:24:19 -0400
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CC421743;
        Thu, 22 Aug 2019 17:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566494658;
        bh=xBv82axvaCm0znDv9PDHNDmC3AahI4PGfwOwV27pXjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5fguV837QvzUjYTcsgAPeo3wS04SzJMkobZFevpKR/tL2J9lXrVqQaoCUOEPZZFT
         xH+8CZaYfqk9HOtc4+IbwpGOdD0a3zYEWypSFvIoEcHcw/6/x1m/Qzmxd/CD9JinLn
         u/xtgIDY6B6MH7leJIw4eX9HA/Ge2hOkhX3x64q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 4.9 100/103] net/mlx5e: Only support tx/rx pause setting for port owner
Date:   Thu, 22 Aug 2019 10:19:28 -0700
Message-Id: <20190822171733.191929634@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190822171728.445189830@linuxfoundation.org>
References: <20190822171728.445189830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

[ Upstream commit 466df6eb4a9e813b3cfc674363316450c57a89c5 ]

Only support changing tx/rx pause frame setting if the net device
is the vport group manager.

Fixes: 3c2d18ef22df ("net/mlx5e: Support ethtool get/set_pauseparam")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1149,6 +1149,9 @@ static int mlx5e_set_pauseparam(struct n
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
+	if (!MLX5_CAP_GEN(mdev, vport_group_manager))
+		return -EOPNOTSUPP;
+
 	if (pauseparam->autoneg)
 		return -EINVAL;
 


