Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C677549089
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355967AbiFMMK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359452AbiFMMJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:09:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10F152E64;
        Mon, 13 Jun 2022 04:00:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B334B80D31;
        Mon, 13 Jun 2022 11:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62652C34114;
        Mon, 13 Jun 2022 11:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118041;
        bh=rPe07Deot0v6PeT7/7ZX4/Bgr3ydWwdA5qx2jX6RFQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWzWobkbZwtBfwqOKAeWiD2LWItUwhFqBBW07rshGVkd65iAZpbh2QoBn/Qek6b/w
         Ttdae5yHhK4Vyg5L+w1UeBSBzMtS4ClPewfBYiXFe+mW+w9RWPH2qL6ace5k6JB2sr
         2HaD7/PJZCppKpIgukQyev+b0mcz8r51wYPdYVVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 222/287] net/mlx5e: Update netdev features after changing XDP state
Date:   Mon, 13 Jun 2022 12:10:46 +0200
Message-Id: <20220613094930.590311847@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
index 75872aef44d0..6ecb92f55e97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4327,6 +4327,11 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 
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



