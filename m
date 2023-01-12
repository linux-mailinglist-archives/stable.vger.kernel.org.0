Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD49667812
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbjALOwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239975AbjALOvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:51:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E2DE1DF36
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:38:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFA696203C
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0135C433D2;
        Thu, 12 Jan 2023 14:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534316;
        bh=VjdDhPQFIvo+axHdl5RC5WogErHVnOHyhlT3CHHOTrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oR7tjzIe3+hQ3Pgcuk5DiDyeWf0hYJ0mfbFxMmplh0ub6V1bIwjCi21bM2kDogAui
         UZfxmno14N/QfrZ4nXlOEDcQ/hfJr3J+DPActEt1pUwCZbCwqI9G/Bhc40/wD3CCHm
         aN9pD+9fxWYeGFFn0VTAeLoDPUOpwSwU79HufVAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 737/783] net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path
Date:   Thu, 12 Jan 2023 14:57:33 +0100
Message-Id: <20230112135558.517430927@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 2a35b2c2e6a252eda2134aae6a756861d9299531 ]

There are two cleanup calls missing in mlx5_init_once() error path.
Add them making the error path flow to be the same as
mlx5_cleanup_once().

Fixes: 52ec462eca9b ("net/mlx5: Add reserved-gids support")
Fixes: 7c39afb394c7 ("net/mlx5: PTP code migration to driver core section")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8246b6285d5a..29bc1df28aeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -906,6 +906,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 err_tables_cleanup:
 	mlx5_geneve_destroy(dev->geneve);
 	mlx5_vxlan_destroy(dev->vxlan);
+	mlx5_cleanup_clock(dev);
+	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_fw_reset_cleanup(dev);
 err_events_cleanup:
-- 
2.35.1



