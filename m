Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DB866491B
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239121AbjAJSSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239175AbjAJSRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:17:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7858CDE82
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:15:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 135BE6183C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:15:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CD2C433EF;
        Tue, 10 Jan 2023 18:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374548;
        bh=dgBuJ/wNFAepbRyhDsrrdjQVSLl/ASi5irr8hnsThJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oos+QUiYXJ6O0KzNL1USRrNPV3zYRaxWSTtWOkwQ2Lt4UHPIZMwtUyBNo1R9RQQJX
         rzeZ3rZPZQXgdcNuXlXusYl3pkoSt31nNG0o2dUANOFsHgsaB5H5Cigo2/8BYI8/PK
         GFA0Ii7te72pzpAg56pF39R0LCxvjlXioFeifRYQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/159] net/mlx5: Fix io_eq_size and event_eq_size params validation
Date:   Tue, 10 Jan 2023 19:03:21 +0100
Message-Id: <20230110180019.991643682@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 44aee8ea15ac205490a41b00cbafcccbf9f7f82b ]

io_eq_size and event_eq_size params are of param type
DEVLINK_PARAM_TYPE_U32. But, the validation callback is addressing them
as DEVLINK_PARAM_TYPE_U16.

This cause mismatch in validation in big-endian systems, in which
values in range were rejected while 268500991 was accepted.
Fix it by checking the U32 value in the validation callback.

Fixes: 0844fa5f7b89 ("net/mlx5: Let user configure io_eq_size param")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 66c6a7017695..9e4e8d551884 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -563,7 +563,7 @@ static int mlx5_devlink_eq_depth_validate(struct devlink *devlink, u32 id,
 					  union devlink_param_value val,
 					  struct netlink_ext_ack *extack)
 {
-	return (val.vu16 >= 64 && val.vu16 <= 4096) ? 0 : -EINVAL;
+	return (val.vu32 >= 64 && val.vu32 <= 4096) ? 0 : -EINVAL;
 }
 
 static const struct devlink_param mlx5_devlink_params[] = {
-- 
2.35.1



