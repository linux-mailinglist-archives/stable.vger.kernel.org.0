Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4F01B0A3A
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 14:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgDTMp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728879AbgDTMp6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:45:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A44E9206DD;
        Mon, 20 Apr 2020 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386758;
        bh=BCsMp6KmgZiVCIqWnfB2eIy61jHp4A1fOmlCIapij5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gM/zodchYYRAtbdcQP0nAvFXatLRF6wBdM0+GHjFTFALtobR+uSN3j3DHbqHME8c+
         IMKJBXc2TwTFTYz0qYmj4uZcVDELlYJZ9jwDsRhQO6iz0F/lghnPU1SYj94PPN6E9M
         eueWckHtNxOTIn2DAwAA16U8x+nWJERtZABSZUvM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.4 15/60] net/mlx5e: Fix nest_level for vlan pop action
Date:   Mon, 20 Apr 2020 14:38:53 +0200
Message-Id: <20200420121505.524678777@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121500.490651540@linuxfoundation.org>
References: <20200420121500.490651540@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

[ Upstream commit 70f478ca085deec4d6c1f187f773f5827ddce7e8 ]

Current value of nest_level, assigned from net_device lower_level value,
does not reflect the actual number of vlan headers, needed to pop.
For ex., if we have untagged ingress traffic sended over vlan devices,
instead of one pop action, driver will perform two pop actions.
To fix that, calculate nest_level as difference between vlan device and
parent device lower_levels.

Fixes: f3b0a18bb6cb ("net: remove unnecessary variables and callback")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Signed-off-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3181,12 +3181,13 @@ static int add_vlan_pop_action(struct ml
 			       struct mlx5_esw_flow_attr *attr,
 			       u32 *action)
 {
-	int nest_level = attr->parse_attr->filter_dev->lower_level;
 	struct flow_action_entry vlan_act = {
 		.id = FLOW_ACTION_VLAN_POP,
 	};
-	int err = 0;
+	int nest_level, err = 0;
 
+	nest_level = attr->parse_attr->filter_dev->lower_level -
+						priv->netdev->lower_level;
 	while (nest_level--) {
 		err = parse_tc_vlan_action(priv, &vlan_act, attr, action);
 		if (err)


