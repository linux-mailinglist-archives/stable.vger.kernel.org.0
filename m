Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55063593F9E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241164AbiHOVTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343599AbiHOVRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:17:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2145D6270;
        Mon, 15 Aug 2022 12:20:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AA0C6009B;
        Mon, 15 Aug 2022 19:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F55EC433C1;
        Mon, 15 Aug 2022 19:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591223;
        bh=WJJZjSRsNAmFjH1N2BZiZSDeHE3N2TcBII3rUzJ6/LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PxmB5ywAhRSZtWSDU5rkBrZvNi15AY4HzGI9GPXr6OnlKcItFLa9eAoPSK42JSqQn
         F5E4HcYw4O8U2L2U3/lt12/HOIB6p41Ihw2sxqNE400yNh0bv/ZFlr00MV+tHTRLnT
         +6w5M/OXcNwkA/gTMMWtPyDGAO9TfWQGytQSMjXI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0512/1095] net/mlx5e: TC, Fix post_act to not match on in_port metadata
Date:   Mon, 15 Aug 2022 19:58:31 +0200
Message-Id: <20220815180450.703036192@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 903f2194f74bbd289f3170114035d472a36a8ab4 ]

The cited commit changed CT to use multi table actions post act infrastructure instead
of using it own post act infrastructure, this broke decap during VF tunnel offload
(Stack devices) with CT due to wrong match on in_port metadata in the post act table.
This changed only broke VF tunnel offload because it modify the packet in_port metadata
to be VF metadata and it isn't propagate the post act creation.

Fixed by modify post act rules to match only on fte_id and not match on in_port metadata
which isn't needed.

Fixes: a81283263bb0 ("net/mlx5e: Use multi table support for CT and sample actions")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
index dea137dd744b..2b64dd557b5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/post_act.c
@@ -128,6 +128,7 @@ mlx5e_tc_post_act_add(struct mlx5e_post_act *post_act, struct mlx5_flow_attr *at
 	post_attr->inner_match_level = MLX5_MATCH_NONE;
 	post_attr->outer_match_level = MLX5_MATCH_NONE;
 	post_attr->action &= ~MLX5_FLOW_CONTEXT_ACTION_DECAP;
+	post_attr->flags |= MLX5_ATTR_FLAG_NO_IN_PORT;
 
 	handle->ns_type = post_act->ns_type;
 	/* Splits were handled before post action */
-- 
2.35.1



