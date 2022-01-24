Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B614C499F53
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381857AbiAXW5T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579217AbiAXWFM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:05:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86CFC04590D;
        Mon, 24 Jan 2022 12:42:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F76DB8122A;
        Mon, 24 Jan 2022 20:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D26C340E5;
        Mon, 24 Jan 2022 20:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056938;
        bh=Py0Utb8K/TKDOXRe9hLUxo0KxcgvtJEQobvTI9y/7YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lR78Kk7arsWpcvrybCtCYStB1AMCmUqLzpTMCKxvvyzyXLW04KszrS0HY9K3pwJrS
         QihQc0hl3UR12Iu9uFt3OybUU5T6nLoDMdZhf5b4VZesTnd6XngR+jfU6swd1/aI3G
         DpfQ2cHyVWjfQxKAN+Wmb0QUv/9WVohlA/egiSyQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 616/846] net/mlx5e: Unblock setting vid 0 for VF in case PF isnt eswitch manager
Date:   Mon, 24 Jan 2022 19:42:13 +0100
Message-Id: <20220124184122.296054536@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 7846665d3504812acaebf920d1141851379a7f37 ]

When using libvirt to passthrough VF to VM it will always set the VF vlan
to 0 even if user didn’t request it, this will cause libvirt to fail to
boot in case the PF isn't eswitch owner.

Example of such case is the DPU host PF which isn't eswitch manager, so
any attempt to passthrough VF of it using libvirt will fail.

Fix it by not returning error in case set VF vlan is called with vid 0.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index df277a6cddc0b..0c4c743ca31e1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -431,7 +431,7 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	int err = 0;
 
 	if (!mlx5_esw_allowed(esw))
-		return -EPERM;
+		return vlan ? -EPERM : 0;
 
 	if (vlan || qos)
 		set_flags = SET_VLAN_STRIP | SET_VLAN_INSERT;
-- 
2.34.1



