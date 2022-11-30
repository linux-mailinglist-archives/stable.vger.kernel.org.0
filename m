Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46CB63DE77
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiK3ShN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbiK3ShL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:37:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728EF920AC
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:37:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0656A61D6F
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0F6C433D6;
        Wed, 30 Nov 2022 18:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833429;
        bh=78XJGHDv7KLllPet28GeiRaQCHE0Fwngo6jJ0EcF79Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4nM4XxOhspt7FIYcQ5zQILymaPcC2nyg11YsHEG7T2pXqDE1QuZTIK3nE1oLnkfT
         d6OVFwu6KSYdPVTVAXuXd7IhOl/Fj+NFK7fO9u0OBPzeo3a/JfU2Tftyjmr7NuteO5
         MZZ83GU0R8tlxZrGKTv/I2cWWG2Eu7j0azp2d/eE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moshe Shemesh <moshe@nvidia.com>,
        Feras Daoud <ferasda@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/206] net/mlx5: Fix FW tracer timestamp calculation
Date:   Wed, 30 Nov 2022 19:22:34 +0100
Message-Id: <20221130180535.642013542@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

[ Upstream commit 61db3d7b99a367416e489ccf764cc5f9b00d62a1 ]

Fix a bug in calculation of FW tracer timestamp. Decreasing one in the
calculation should effect only bits 52_7 and not effect bits 6_0 of the
timestamp, otherwise bits 6_0 are always set in this calculation.

Fixes: 70dd6fdb8987 ("net/mlx5: FW tracer, parse traces and kernel tracing support")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Feras Daoud <ferasda@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index ea46152816f9..326e0b170e36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -638,7 +638,7 @@ static void mlx5_tracer_handle_timestamp_trace(struct mlx5_fw_tracer *tracer,
 			trace_timestamp = (timestamp_event.timestamp & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 		else
-			trace_timestamp = ((timestamp_event.timestamp & MASK_52_7) - 1) |
+			trace_timestamp = ((timestamp_event.timestamp - 1) & MASK_52_7) |
 					  (str_frmt->timestamp & MASK_6_0);
 
 		mlx5_tracer_print_trace(str_frmt, dev, trace_timestamp);
-- 
2.35.1



