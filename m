Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D18548E92
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355385AbiFMLe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354487AbiFMLcw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:32:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9738FDF73;
        Mon, 13 Jun 2022 03:47:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0BB26125C;
        Mon, 13 Jun 2022 10:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77C9C34114;
        Mon, 13 Jun 2022 10:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117243;
        bh=p9LAIdd8z0hn26BqqnEUtXo7j+0h6wN8DowSzt00xtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hqz5DN0c0JmFCbzfMX/AIXHDbx94DTGxvTf6zOV3bgqm1r6zwoGgyLOKo64SPYgu/
         c9u+wKkj5mEqZL45DTz/4ToMuypJKtTWIKWdT0NSWsMhTL5GvzylyI/uana2QFIMCY
         w4NdgPS9rmEgDsGBuqFA2RjZvwei0WuWsT6Olg5w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 331/411] net/mlx5e: Update netdev features after changing XDP state
Date:   Mon, 13 Jun 2022 12:10:04 +0200
Message-Id: <20220613094938.650118465@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit f6279f113ad593971999c877eb69dc3d36a75894 ]

Some features (LRO, HW GRO) conflict with XDP. If there is an attempt to
enable such features while XDP is active, they will be set to `off
[requested on]`. In order to activate these features after XDP is turned
off, the driver needs to call netdev_update_features(). This commit adds
this missing call after XDP state changes.

Fixes: cf6e34c8c22f ("net/mlx5e: Properly block LRO when XDP is enabled")
Fixes: b0617e7b3500 ("net/mlx5e: Properly block HW GRO when XDP is enabled")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 73291051808f..35630b538c82 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4638,6 +4638,11 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 
 unlock:
 	mutex_unlock(&priv->state_lock);
+
+	/* Need to fix some features. */
+	if (!err)
+		netdev_update_features(netdev);
+
 	return err;
 }
 
-- 
2.35.1



