Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C422C07DA
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730885AbgKWMot (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:44:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:58052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733250AbgKWMom (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:44:42 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021EF20888;
        Mon, 23 Nov 2020 12:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135482;
        bh=uGBC7vls23jkfPMoUIvWhAypORHTOQIQpQFn+tStU6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B9ZgvuzDzDdj9YshoOKA8ZVgaI4VkVsdskoQCkNWqd1sjBCIvG5lswl6J+eV2Q0du
         1xDj53Ll1uqyoY+ZSK4fyLntH4ihUlTn050vK0W9rj4CUznPmtMR6mstI/VElzHyvG
         FncQ4FjZad7dKOGMH3TblZWJswMzDnHSGJPPhtXQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.9 045/252] net/mlx5: Clear bw_share upon VF disable
Date:   Mon, 23 Nov 2020 13:19:55 +0100
Message-Id: <20201123121837.757515706@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

[ Upstream commit 1ce5fc724a26e0b476e42c5d588bdb80caea003b ]

Currently, if user disables VFs with some min and max rates configured,
they are cleared. But QoS data is not cleared and restored upon next VF
enable placing limits on minimal rate for given VF, when user expects
none.

To match cleared vport->info struct with QoS-related min and max rates
upon VF disable, clear vport->qos struct too.

Fixes: 556b9d16d3f5 ("net/mlx5: Clear VF's configuration on disabling SRIOV")
Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1408,6 +1408,7 @@ static void mlx5_eswitch_clear_vf_vports
 	int i;
 
 	mlx5_esw_for_each_vf_vport(esw, i, vport, esw->esw_funcs.num_vfs) {
+		memset(&vport->qos, 0, sizeof(vport->qos));
 		memset(&vport->info, 0, sizeof(vport->info));
 		vport->info.link_state = MLX5_VPORT_ADMIN_STATE_AUTO;
 	}


