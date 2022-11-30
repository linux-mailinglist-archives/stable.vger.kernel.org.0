Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4339D63DD7D
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiK3S17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiK3S1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:27:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C650183BD
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:27:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98DA4B81CA1
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D84C433C1;
        Wed, 30 Nov 2022 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832864;
        bh=SHXrhErI6eq/dc4MK59Yby9nQ3rHS8Qvx4tHtkUO1gU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JXiBRRsZzwUph5skMrNCpXakYrQZGXr24n++KY0zA2gwEsEtCj0WiFGNm4P3UfrCs
         Q2hSqtLbMZes0oGEcmjVgw2kbzcH4/O6zkY6qUc3ndc2F95eNkh/yk5u6ibiefMzmA
         w0cugaRjwAq2iOTRd/xBn29pj4500YwOhxeK5jqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Moshe Shemesh <moshe@nvidia.com>,
        Feras Daoud <ferasda@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/162] net/mlx5: Fix FW tracer timestamp calculation
Date:   Wed, 30 Nov 2022 19:22:28 +0100
Message-Id: <20221130180530.321742432@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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
index e8a4adccd2b2..f800e1ca5ba6 100644
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



