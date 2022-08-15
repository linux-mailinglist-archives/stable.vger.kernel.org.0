Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5007A594A5B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351873AbiHOX76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355295AbiHOX6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:58:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE3C164420;
        Mon, 15 Aug 2022 13:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 41C94B80EB1;
        Mon, 15 Aug 2022 20:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DED2C433C1;
        Mon, 15 Aug 2022 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594808;
        bh=WJJZjSRsNAmFjH1N2BZiZSDeHE3N2TcBII3rUzJ6/LA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRMz+9nmz/s75Xfwg7XeGHiIv9qD9w9ZOOU1bh9aJ4awTNnY5mORWmGvElg3X9J4M
         1bM30SI4mn0rrR17pJlCkO+tBrWQFWrQRwzD1sAVYbJr8+Ump2RitVaXuMD4PzPcaS
         wC0z6wUEM5yLg7GdAwHlyFid5iMtppgsKyDd/wjs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Dickman <maord@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0548/1157] net/mlx5e: TC, Fix post_act to not match on in_port metadata
Date:   Mon, 15 Aug 2022 19:58:24 +0200
Message-Id: <20220815180501.568814195@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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



