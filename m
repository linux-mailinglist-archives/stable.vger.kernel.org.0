Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294B5171E10
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388642AbgB0OMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729744AbgB0OMO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 952BA24690;
        Thu, 27 Feb 2020 14:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812734;
        bh=cMSeSs9L1apspwsTCjyLr96T/Czmj2HnGxFqNKSBkyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGYQSoSb86LUKdtEt8pzhjAhBklAvJCr+LAj07DU9NapdRco6ZKB26mXKrlKJoxnE
         iG0I3YpG/FuTiLB9ipvF59tT2Fhz3gMFAm4N8tEmLiEJhXcFEn6AezHm2CRZGoK1XC
         1YOrUPmmck4NizORZI6eLCkuJlnRnfrCNs2z+79o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huy Nguyen <huyn@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 131/135] net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa
Date:   Thu, 27 Feb 2020 14:37:51 +0100
Message-Id: <20200227132248.736682625@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

commit 3d9c5e023a0dbf3e117bb416cfefd9405bf5af0c upstream.

rtnl_bridge_getlink is protected by rcu lock, so mlx5_eswitch_get_vepa
cannot take mutex lock. Two possible issues can happen:
1. User at the same time change vepa mode via RTM_SETLINK command.
2. User at the same time change the switchdev mode via devlink netlink
interface.

Case 1 cannot happen because rtnl executes one message in order.
Case 2 can happen but we do not expect user to change the switchdev mode
when changing vepa. Even if a user does it, so he will read a value
which is no longer valid.

Fixes: 8da202b24913 ("net/mlx5: E-Switch, Add support for VEPA in legacy mode.")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c |   14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2319,25 +2319,17 @@ out:
 
 int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting)
 {
-	int err = 0;
-
 	if (!esw)
 		return -EOPNOTSUPP;
 
 	if (!ESW_ALLOWED(esw))
 		return -EPERM;
 
-	mutex_lock(&esw->state_lock);
-	if (esw->mode != MLX5_ESWITCH_LEGACY) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
+	if (esw->mode != MLX5_ESWITCH_LEGACY)
+		return -EOPNOTSUPP;
 
 	*setting = esw->fdb_table.legacy.vepa_uplink_rule ? 1 : 0;
-
-out:
-	mutex_unlock(&esw->state_lock);
-	return err;
+	return 0;
 }
 
 int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,


