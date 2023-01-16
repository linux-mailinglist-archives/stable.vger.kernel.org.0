Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3DD66C986
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbjAPQuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233944AbjAPQuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:50:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CABE2B0B8
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:36:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F165661057
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1260FC433EF;
        Mon, 16 Jan 2023 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887000;
        bh=a3N2ndFfZbue4zlADQiYKdNJ6g9/maI2tOJxC2YTy34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzXYddW7qOQTN3oL9Ml8FziqWzXobuPB3/bxUQcmxLs9IzUCtVjhz21OCujkilnND
         u+ghBMFEwboCrQnJt9/2/Pr9a2eut3zTazhb+muJz24bEXXElDHyYuz0SDAIp7SvJM
         A27USsRdYW0rwNk9d08xYHocRqujIE+n7XyQxqmI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 641/658] net/mlx5: Fix ptp max frequency adjustment range
Date:   Mon, 16 Jan 2023 16:52:09 +0100
Message-Id: <20230116154938.813488383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit fe91d57277eef8bb4aca05acfa337b4a51d0bba4 ]

.max_adj of ptp_clock_info acts as an absolute value for the amount in ppb
that can be set for a single call of .adjfine. This means that a single
call to .getfine cannot be greater than .max_adj or less than -(.max_adj).
Provides correct value for max frequency adjustment value supported by
devices.

Fixes: 3d8c38af1493 ("net/mlx5e: Add PTP Hardware Clock (PHC) support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index e0b361ff5a97..2c81ec31e0a2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -418,7 +418,7 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "mlx5_ptp",
-	.max_adj	= 100000000,
+	.max_adj	= 50000000,
 	.n_alarm	= 0,
 	.n_ext_ts	= 0,
 	.n_per_out	= 0,
-- 
2.35.1



