Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3D663DFA5
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbiK3StZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbiK3StH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:49:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A3199F67
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:49:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78BA3B81CA8
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:49:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FBBC433C1;
        Wed, 30 Nov 2022 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834142;
        bh=b9+Z4gmbwmch9Sr8pgKO1b6zA82QYs/8fxDBm15Lap8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJ0S5SzYY1kWd8YEN5rB8J2gceyukqnrUqrMcBexFzvXIJ0AZMlVlxk08B8kYdKnd
         RuepYVva0nGYWEZw5wB5BQ4hZhmsT1emr+THv83J2hA/P0dEB7TF3bJA+zGEsVNWhy
         SwmOlKbC34D3ItvkKQ1lTo8fSCF7tpAlyVHJG3Vk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 108/289] net/mlx5: Fix handling of entry refcount when command is not issued to FW
Date:   Wed, 30 Nov 2022 19:21:33 +0100
Message-Id: <20221130180546.588390699@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit aaf2e65cac7f2e1ae729c2fbc849091df9699f96 ]

In case command interface is down, or the command is not allowed, driver
did not increment the entry refcount, but might have decrement as part
of forced completion handling.

Fix that by always increment and decrement the refcount to make it
symmetric for all flows.

Fixes: 50b2412b7e78 ("net/mlx5: Avoid possible free of command entry while timeout comp handler")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reported-by: Jack Wang <jinpu.wang@ionos.com>
Tested-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index df3e284ca5c6..74bd05e5dda2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1005,6 +1005,7 @@ static void cmd_work_handler(struct work_struct *work)
 		cmd_ent_get(ent);
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
+	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* Skip sending command to fw if internal error */
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
 		ent->ret = -ENXIO;
@@ -1012,7 +1013,6 @@ static void cmd_work_handler(struct work_struct *work)
 		return;
 	}
 
-	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* ring doorbell after the descriptor is valid */
 	mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 << ent->idx);
 	wmb();
@@ -1661,8 +1661,8 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				cmd_ent_put(ent); /* timeout work was canceled */
 
 			if (!forced || /* Real FW completion */
-			    pci_channel_offline(dev->pdev) || /* FW is inaccessible */
-			    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
+			     !opcode_allowed(cmd, ent->op))
 				cmd_ent_put(ent);
 
 			ent->ts2 = ktime_get_ns();
-- 
2.35.1



