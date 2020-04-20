Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84CB1B0C26
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 15:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgDTMkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 08:40:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727024AbgDTMkS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Apr 2020 08:40:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29E4D2070B;
        Mon, 20 Apr 2020 12:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587386417;
        bh=lU55WaZbyj1wMvqSbLf0bL3kHvkYaGv5VaeW43GHrJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1p7oSNlgXFUR9nRJorjfxs+T270SfEOPCa2N8JdiP7a1gFITm5/X3j2tAZpzoaFle
         MHMpV3a/4MDjpyLKHkdGgVqv1gmGXgTEi/ncTXXn2PJKYBVB26OQwq9y9Vimip36B5
         osHXsRaIa+68fNWj0vWaxB4oxAblDG0TYE7McX/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.5 15/65] net/mlx5e: Fix nest_level for vlan pop action
Date:   Mon, 20 Apr 2020 14:38:19 +0200
Message-Id: <20200420121509.586805644@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420121505.909671922@linuxfoundation.org>
References: <20200420121505.909671922@linuxfoundation.org>
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
@@ -3221,12 +3221,13 @@ static int add_vlan_pop_action(struct ml
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


