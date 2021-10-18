Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6960B431E9F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbhJRODJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:03:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232741AbhJROBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 408E461A61;
        Mon, 18 Oct 2021 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564554;
        bh=SBsDqRZfaOcdzXzxTekuHZ98esYUKWrpTp/ETu9HS8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNplSEuSSCjjlY1GzzcMJDPOMPQj6DJzJFo+Z0Z4XdlW+27yC/sTAcZlszEyPWmvm
         sWKtd7cyxTnv9Dd22/TCEJGK91afp1wuJ1K/54BEFpxxMek+clvdwgft6TgL1Pg/Mp
         bJr+vzsYmEtpDcCwdMjibM4+qrP/u+mC9Ck/XlMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roopa Prabhu <roopa@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH 5.14 106/151] net/mlx5e: Switchdev representors are not vlan challenged
Date:   Mon, 18 Oct 2021 15:24:45 +0200
Message-Id: <20211018132344.126032957@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

commit b2107cdc43d8601f2cadfba990ae844cc1f44e68 upstream.

Before this patch, mlx5 representors advertised the
NETIF_F_VLAN_CHALLENGED bit, this could lead to missing features when
using reps with vxlan/bridge and maybe other virtual interfaces,
when such interfaces inherit this bit and block vlan usage in their
topology.

Example:
$ip link add dev bridge type bridge
 # add representor interface to the bridge
$ip link set dev pf0hpf master
$ip link add link bridge name vlan10 type vlan id 10 protocol 802.1q
Error: 8021q: VLANs not supported on device.

Reps are perfectly capable of handling vlan traffic, although they don't
implement vlan_{add,kill}_vid ndos, hence, remove
NETIF_F_VLAN_CHALLENGED advertisement.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Reported-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -611,7 +611,6 @@ static void mlx5e_build_rep_netdev(struc
 	netdev->hw_features    |= NETIF_F_RXCSUM;
 
 	netdev->features |= netdev->hw_features;
-	netdev->features |= NETIF_F_VLAN_CHALLENGED;
 	netdev->features |= NETIF_F_NETNS_LOCAL;
 }
 


