Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F2762804A
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiKNNEo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiKNNEm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:04:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51C02A24C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:04:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3E5E6117E
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:04:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0ACAC433D7;
        Mon, 14 Nov 2022 13:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431079;
        bh=VWoPcngRA0ErmYdDOII9ukfQbykBsnABRsNdnLe51OA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsmcOPxQcRFjRtFoBAMAlRKsq/iN9W5USCuzGu+c6R4/OGC1ieghS+Fke7zX7gWV+
         wkYzK4ruvqI50jjLMKxMlQ3nw32x94bbGnvXxF1c5I3e0v8vSGViDjj+yyHMtKsgt3
         SUmqElOHXDSfCIBHcl0xO/PeGozKu5zt/Byb2Fv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jianbo Liu <jianbol@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 092/190] net/mlx5e: TC, Fix wrong rejection of packet-per-second policing
Date:   Mon, 14 Nov 2022 13:45:16 +0100
Message-Id: <20221114124502.729152266@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 9e06430841363a1d2932d546fdce1cc5edb3c2a0 ]

In the bellow commit, we added support for PPS policing without
removing the check which block offload of such cases.
Fix it by removing this check.

Fixes: a8d52b024d6d ("net/mlx5e: TC, Support offloading police action")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a687f047e3ae..229c14b1af00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4739,12 +4739,6 @@ int mlx5e_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.rate_pkt_ps) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "QoS offload not support packets per second");
-		return -EOPNOTSUPP;
-	}
-
 	return 0;
 }
 
-- 
2.35.1



