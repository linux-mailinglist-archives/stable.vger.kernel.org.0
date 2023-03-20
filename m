Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD36C18E5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232949AbjCTP2g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232758AbjCTP2R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:28:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318C1303CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36C26CE12F1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:21:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FF8C433EF;
        Mon, 20 Mar 2023 15:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325660;
        bh=wlYgujtYhF0I8Xy2sRTaw4wOYDBH6fZW3RtnBQQzXwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wPbVGAKMFAtus0n5vb2SyjHqqNuZq8lfTKEv/mLT4l4D/McANh/qJJhegKOoK3csA
         rTrfw+n9nMEqm/dxSf718mxYnbF1JfFV3l/Pdnz3CFW+hwTdT03QStoWFsSYzXevmd
         ZpqSSyTa53wUn2tP5hgobx3KBgGIna3hrGEExEXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 078/211] net/mlx5: Set BREAK_FW_WAIT flag first when removing driver
Date:   Mon, 20 Mar 2023 15:53:33 +0100
Message-Id: <20230320145516.544467283@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 031a163f2c476adcb2c01e27a7d323e66174ac11 ]

Currently, BREAK_FW_WAIT flag is set after syncing with fw_reset.
However, fw_reset can call mlx5_load_one() which is waiting for fw
init bit and BREAK_FW_WAIT flag is intended to stop. e.g.: the driver
might wait on a loop it should exit.
Fix it by setting the flag before syncing with fw_reset.

Fixes: 8324a02c342a ("net/mlx5: Add exit route when waiting for FW")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index bb718003d6f49..f4e0431da55b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1768,11 +1768,11 @@ static void remove_one(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
 
+	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	/* mlx5_drain_fw_reset() is using devlink APIs. Hence, we must drain
 	 * fw_reset before unregistering the devlink.
 	 */
 	mlx5_drain_fw_reset(dev);
-	set_bit(MLX5_BREAK_FW_WAIT, &dev->intf_state);
 	devlink_unregister(devlink);
 	mlx5_sriov_disable(pdev);
 	mlx5_crdump_disable(dev);
-- 
2.39.2



