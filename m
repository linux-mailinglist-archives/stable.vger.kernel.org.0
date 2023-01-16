Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B6366C501
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjAPQAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjAPQA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:00:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74C1234F9
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 287C9B81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82EBEC433EF;
        Mon, 16 Jan 2023 16:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884824;
        bh=qOzE2rdgDEjww2U45Lpa/1Y9HN4a1OLAOf7LIffXDmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T5Mg+o5I78zMkpPXYyoWXwDK8EPxOhR3EFQqJiPRY32kQDNEP7Pyz9W/+GUceV9CI
         N5u22qkBzetss9PWzsTxGgFkNVAgFXg/W3kWOgTrd9+NMs1MTk0ybBdGNZz1YYPgGw
         y4eQF0MRFjlcvnuYn398f4r/DoyAYKW547QTu7GI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Roy Novich <royno@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/183] net/mlx5e: Verify dev is present for fix features ndo
Date:   Mon, 16 Jan 2023 16:51:16 +0100
Message-Id: <20230116154809.785183168@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Roy Novich <royno@nvidia.com>

[ Upstream commit ab4b01bfdaa69492fb36484026b0a0f0af02d75a ]

The native NIC port net device instance is being used as Uplink
representor.  While changing profiles private resources are not
available, fix features ndo does not check if the netdev is present.
Add driver protection to verify private resources are ready.

Fixes: 7a9fb35e8c3a ("net/mlx5e: Do not reload ethernet ports when changing eswitch mode")
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 951ede433813..4dc149ef618c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4071,6 +4071,9 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 	struct mlx5e_vlan_table *vlan;
 	struct mlx5e_params *params;
 
+	if (!netif_device_present(netdev))
+		return features;
+
 	vlan = mlx5e_fs_get_vlan(priv->fs);
 	mutex_lock(&priv->state_lock);
 	params = &priv->channels.params;
-- 
2.35.1



