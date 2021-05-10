Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5483786A9
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhEJLJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233732AbhEJLBt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957A46101A;
        Mon, 10 May 2021 10:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644033;
        bh=5fuRqTcKIiPzxbE9ZPKDhNPvkmZlbtvNlweGkPwV8cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1kyQaC/LTJ9Sqy7+N0+/f8LmvGf9FHhpRJWmU3H+nqIQR47QdgvhZGA0i7zk9CLz
         d2TTeQLlgUkcpLyJBkNmXSVCI7JwtT5sNRcTmL84mQnUFzB3lJjnqOmbep+dR5gp4Y
         0cQlX3iFbrAxh955V1/M+G/0P1ByqRWUouBip3CU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.11 261/342] mlxsw: spectrum_mr: Update egress RIF list before routes action
Date:   Mon, 10 May 2021 12:20:51 +0200
Message-Id: <20210510102018.719559548@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

commit cbaf3f6af9c268caf558c8e7ec52bcb35c5455dd upstream.

Each multicast route that is forwarding packets (as opposed to trapping
them) points to a list of egress router interfaces (RIFs) through which
packets are replicated.

A route's action can transition from trap to forward when a RIF is
created for one of the route's egress virtual interfaces (eVIF). When
this happens, the route's action is first updated and only later the
list of egress RIFs is committed to the device.

This results in the route pointing to an invalid list. In case the list
pointer is out of range (due to uninitialized memory), the device will
complain:

mlxsw_spectrum2 0000:06:00.0: EMAD reg access failed (tid=5733bf490000905c,reg_id=300f(pefa),type=write,status=7(bad parameter))

Fix this by first committing the list of egress RIFs to the device and
only later update the route's action.

Note that a fix is not needed in the reverse function (i.e.,
mlxsw_sp_mr_route_evif_unresolve()), as there the route's action is
first updated and only later the RIF is removed from the list.

Cc: stable@vger.kernel.org
Fixes: c011ec1bbfd6 ("mlxsw: spectrum: Add the multicast routing offloading logic")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20210506072308.3834303-1-idosch@idosch.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c |   30 +++++++++++-----------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -535,6 +535,16 @@ mlxsw_sp_mr_route_evif_resolve(struct ml
 	u16 erif_index = 0;
 	int err;
 
+	/* Add the eRIF */
+	if (mlxsw_sp_mr_vif_valid(rve->mr_vif)) {
+		erif_index = mlxsw_sp_rif_index(rve->mr_vif->rif);
+		err = mr->mr_ops->route_erif_add(mlxsw_sp,
+						 rve->mr_route->route_priv,
+						 erif_index);
+		if (err)
+			return err;
+	}
+
 	/* Update the route action, as the new eVIF can be a tunnel or a pimreg
 	 * device which will require updating the action.
 	 */
@@ -544,17 +554,7 @@ mlxsw_sp_mr_route_evif_resolve(struct ml
 						      rve->mr_route->route_priv,
 						      route_action);
 		if (err)
-			return err;
-	}
-
-	/* Add the eRIF */
-	if (mlxsw_sp_mr_vif_valid(rve->mr_vif)) {
-		erif_index = mlxsw_sp_rif_index(rve->mr_vif->rif);
-		err = mr->mr_ops->route_erif_add(mlxsw_sp,
-						 rve->mr_route->route_priv,
-						 erif_index);
-		if (err)
-			goto err_route_erif_add;
+			goto err_route_action_update;
 	}
 
 	/* Update the minimum MTU */
@@ -572,14 +572,14 @@ mlxsw_sp_mr_route_evif_resolve(struct ml
 	return 0;
 
 err_route_min_mtu_update:
-	if (mlxsw_sp_mr_vif_valid(rve->mr_vif))
-		mr->mr_ops->route_erif_del(mlxsw_sp, rve->mr_route->route_priv,
-					   erif_index);
-err_route_erif_add:
 	if (route_action != rve->mr_route->route_action)
 		mr->mr_ops->route_action_update(mlxsw_sp,
 						rve->mr_route->route_priv,
 						rve->mr_route->route_action);
+err_route_action_update:
+	if (mlxsw_sp_mr_vif_valid(rve->mr_vif))
+		mr->mr_ops->route_erif_del(mlxsw_sp, rve->mr_route->route_priv,
+					   erif_index);
 	return err;
 }
 


