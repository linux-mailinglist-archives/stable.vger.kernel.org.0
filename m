Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4836C18DD
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbjCTP2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbjCTP1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:27:47 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044B737F2A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE5FDCE12DA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19035C4339B;
        Mon, 20 Mar 2023 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325649;
        bh=Y9VJDuw6Pu/7exTlBKzxswDlLOxoUi9Nwz60jblsduE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2J30xbewhsUFUfQATxjTZmDoAPP3+gI3w8ctIdHl6pe/CNVEU84gfuX5b70o3xb/
         NMpQMrFsvwxsKhwzCWxzp/MAvHPI4uBAnCzioAGaCdIYnzPCah10LXJfFqTHpcBlZd
         quGRtZS9IDyzEDyqlLuXjlL0GEtCkjMgopt66iSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 076/211] net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port
Date:   Mon, 20 Mar 2023 15:53:31 +0100
Message-Id: <20230320145516.453307703@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 28d3815a629cbdee660dd1c9de28d77cb3d77917 ]

Rules with mirror actions are split to two FTEs when the actions after the mirror
action contains pedit, vlan push/pop or ct. Forward to ovs internal port adds
implicit header rewrite (pedit) but missing trigger to do split.

Fix by setting split_count when forwarding to ovs internal port which
will trigger split in mirror rules.

Fixes: 27484f7170ed ("net/mlx5e: Offload tc rules that redirect to ovs internal port")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 243d5d7750beb..6a07242b5d5ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4240,6 +4240,7 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 
 	esw_attr->dest_int_port = dest_int_port;
 	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
+	esw_attr->split_count = out_index;
 
 	/* Forward to root fdb for matching against the new source vport */
 	attr->dest_chain = 0;
-- 
2.39.2



