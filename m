Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD31812C801
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731707AbfL2Rt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:34054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731436AbfL2Rt5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:49:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2723206A4;
        Sun, 29 Dec 2019 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641797;
        bh=HrMe3ZXnXErzjDN33eld/efIaO1w3g7H5ALJT7FOOQg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNIUe3AZOEN1wqkqQdJwMmR/ZaXXMbYpO5MQQ16vb6X+ZGbZ4hOb63HRFY3WCmOr6
         OIfEZ1A3EBsgBrHHzjp/AnxLKWcHzJGvXg+IXM6PSKxS0u09Wvr+uHg4Udv6py3Fjg
         an1Vjva30ctG4nwKQTKYQHK9ZjllUIRkE3KZAGQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 215/434] net/mlx5e: Verify that rule has at least one fwd/drop action
Date:   Sun, 29 Dec 2019 18:24:28 +0100
Message-Id: <20191229172716.113297722@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

[ Upstream commit ae2741e2b6ce2bf1b656b1152c4ef147ff35b096 ]

Currently, mlx5 tc layer doesn't verify that rule has at least one forward
or drop action which leads to following firmware syndrome when user tries
to offload such action:

[ 1824.860501] mlx5_core 0000:81:00.0: mlx5_cmd_check:753:(pid 29458): SET_FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x144b7a)

Add check at the end of parse_tc_fdb_actions() that verifies that resulting
attribute has action fwd or drop flag set.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c2c7f214a56a..814a4ba4e7fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3443,6 +3443,12 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 	}
 
+	if (!(attr->action &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG(extack, "Rule must have at least one forward/drop action");
+		return -EOPNOTSUPP;
+	}
+
 	if (attr->split_count > 0 && !mlx5_esw_has_fwd_fdb(priv->mdev)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "current firmware doesn't support split rule for port mirroring");
-- 
2.20.1



