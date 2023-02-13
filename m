Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 011EC6948F1
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjBMOyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjBMOye (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0757B756
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 646C1B81250
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21AEC433EF;
        Mon, 13 Feb 2023 14:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300070;
        bh=ln9DHkuLmhsCmgpE0v2NJmbIfn3LTMhnb1pD/k823+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nxviegLhZ2KG0MIcnejCTQ4lI6JwubGvcvy664U0xQI8HfXWXrW1IedzLV6XHsaQY
         3VSp/CpxRhJ8TDj+yLtHKZzROXR3Z6kOV5x+zJP2ypC1kk9EkXLqhY7wYaJdDnb3Fj
         5rxkUeqB9xedwTcd+FqtXMBZouHVrAPBMTKcOPsI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/114] net/mlx5: fw_tracer, Zero consumer index when reloading the tracer
Date:   Mon, 13 Feb 2023 15:48:07 +0100
Message-Id: <20230213144744.898175170@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

[ Upstream commit 184e1e4474dbcfebc4dbd1fa823a329978f25506 ]

When tracer is reloaded, the device will log the traces at the
beginning of the log buffer. Also, driver is reading the log buffer in
chunks in accordance to the consumer index.
Hence, zero consumer index when reloading the tracer.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index d82e98a0cdfa7..5b05b884b5fb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -757,6 +757,7 @@ static int mlx5_fw_tracer_set_mtrc_conf(struct mlx5_fw_tracer *tracer)
 	if (err)
 		mlx5_core_warn(dev, "FWTracer: Failed to set tracer configurations %d\n", err);
 
+	tracer->buff.consumer_index = 0;
 	return err;
 }
 
@@ -821,7 +822,6 @@ static void mlx5_fw_tracer_ownership_change(struct work_struct *work)
 	mlx5_core_dbg(tracer->dev, "FWTracer: ownership changed, current=(%d)\n", tracer->owner);
 	if (tracer->owner) {
 		tracer->owner = false;
-		tracer->buff.consumer_index = 0;
 		return;
 	}
 
-- 
2.39.0



