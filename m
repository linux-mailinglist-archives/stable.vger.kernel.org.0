Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9537C4C7643
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiB1SB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236090AbiB1R7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:59:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A8797B8B;
        Mon, 28 Feb 2022 09:45:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4912F60909;
        Mon, 28 Feb 2022 17:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54363C340E7;
        Mon, 28 Feb 2022 17:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070333;
        bh=c30t/Dk9JK7KOcbWf0gckfSxe0d3L1gHkuwldWpRfh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KpPdfM/ZpCjDqro10RYUUMpB3ex9Oj5Op/JlsSoSfyLHmN6Hlnmb5h1xIB9qb2vNz
         I95KRyTdQ9ivLb7TgM3K6Zz14cEMkcHa+3KSygdDJ0eJshJkwm2J6rql/lcWN9i4dS
         b6Qs6Hr2U6fMgQeNQjXLd/UDqqgHAlhrXuk6WvAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.16 071/164] net/mlx5e: TC, Reject rules with forward and drop actions
Date:   Mon, 28 Feb 2022 18:23:53 +0100
Message-Id: <20220228172406.534556586@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

commit 3d65492a86d4e6675734646929759138a023d914 upstream.

Such rules are redundant but allowed and passed to the driver.
The driver does not support offloading such rules so return an error.

Fixes: 03a9d11e6eeb ("net/mlx5e: Add TC drop and mirred/redirect action parsing for SRIOV offloads")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3427,6 +3427,12 @@ actions_match_supported(struct mlx5e_pri
 		return false;
 	}
 
+	if (!(~actions &
+	      (MLX5_FLOW_CONTEXT_ACTION_FWD_DEST | MLX5_FLOW_CONTEXT_ACTION_DROP))) {
+		NL_SET_ERR_MSG_MOD(extack, "Rule cannot support forward+drop action");
+		return false;
+	}
+
 	if (actions & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
 	    actions & MLX5_FLOW_CONTEXT_ACTION_DROP) {
 		NL_SET_ERR_MSG_MOD(extack, "Drop with modify header action is not supported");


