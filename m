Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FF3469F21
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391430AbhLFPpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390543AbhLFPma (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:42:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8DFC0698D4;
        Mon,  6 Dec 2021 07:28:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 827B3B81116;
        Mon,  6 Dec 2021 15:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E56C34902;
        Mon,  6 Dec 2021 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804487;
        bh=96yIe4GIZ3JcXOCSey31u2M+MGmqJRBIdthTgp/tzxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hh2xo+nMTZWRRc+4C1h0gIEhH048tiGjq3QBs3QY5dWbAjAl8VRCkY+qBluthaLmh
         q5LvdwPpfM+MplvjMfLzp7tZMcNZGM6IEZIoNEygwQbTXC7hGSwTwLGVp0vMqzP4Jc
         pz33yEpaS7JjUcQl9hkCshGQoSSqSeSWFkzBQJds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/207] net/mlx5: E-switch, Respect BW share of the new group
Date:   Mon,  6 Dec 2021 15:56:58 +0100
Message-Id: <20211206145615.941996709@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

[ Upstream commit 1e59b32e45e47c8ea5455182286ba010bfa87813 ]

To enable transmit schduler on vport FW require non-zero configuration
for vport's TSAR. If vport added to the group which has configured BW
share value and TX rate values of the vport are zero, then scheduler
wouldn't be enabled on this vport.
Fix that by calling BW normalization if BW share of the new group is
configured.

Fixes: 0fe132eac38c ("net/mlx5: E-switch, Allow to add vports to rate groups")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index c6cc67cb4f6ad..4501e3d737f80 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -423,7 +423,7 @@ static int esw_qos_vport_update_group(struct mlx5_eswitch *esw,
 		return err;
 
 	/* Recalculate bw share weights of old and new groups */
-	if (vport->qos.bw_share) {
+	if (vport->qos.bw_share || new_group->bw_share) {
 		esw_qos_normalize_vports_min_rate(esw, curr_group, extack);
 		esw_qos_normalize_vports_min_rate(esw, new_group, extack);
 	}
-- 
2.33.0



