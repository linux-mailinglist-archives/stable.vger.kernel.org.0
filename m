Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C9A548DE1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354638AbiFMLjx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355599AbiFMLjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:39:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DCACE28;
        Mon, 13 Jun 2022 03:49:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5C7AB80D3C;
        Mon, 13 Jun 2022 10:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B39C34114;
        Mon, 13 Jun 2022 10:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117347;
        bh=TLbL2JOHLDl1gjc359A7aM0usXN15hlzvEJY4S71kqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njbc3NWPk85N+6vZrHn9uv+I46RplWXi513JJFDlwlMB7sHWPcZM18gZ5gYQfxbNV
         U098ofoiS4AiSQKdSsLza2VxJHV+ng8OcShQMsU/ac9lW7HUSN/carK4WLTliiuyEX
         cKUkiZQfV7II/logbV2yuZoFlRGQLXxO+f4ltXIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feras Daoud <ferasda@nvidia.com>,
        Roy Novich <royno@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 360/411] net/mlx5: Rearm the FW tracer after each tracer event
Date:   Mon, 13 Jun 2022 12:10:33 +0200
Message-Id: <20220613094939.488506919@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

From: Feras Daoud <ferasda@nvidia.com>

[ Upstream commit 8bf94e6414c9481bfa28269022688ab445d0081d ]

The current design does not arm the tracer if traces are available before
the tracer string database is fully loaded, leading to an unfunctional tracer.
This fix will rearm the tracer every time the FW triggers tracer event
regardless of the tracer strings database status.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Signed-off-by: Feras Daoud <ferasda@nvidia.com>
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 97359417c6e7..f8144ce7e476 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -673,6 +673,9 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 	if (!tracer->owner)
 		return;
 
+	if (unlikely(!tracer->str_db.loaded))
+		goto arm;
+
 	block_count = tracer->buff.size / TRACER_BLOCK_SIZE_BYTE;
 	start_offset = tracer->buff.consumer_index * TRACER_BLOCK_SIZE_BYTE;
 
@@ -730,6 +733,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 						      &tmp_trace_block[TRACES_PER_BLOCK - 1]);
 	}
 
+arm:
 	mlx5_fw_tracer_arm(dev);
 }
 
@@ -1084,8 +1088,7 @@ static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void
 			queue_work(tracer->work_queue, &tracer->ownership_change_work);
 		break;
 	case MLX5_TRACER_SUBTYPE_TRACES_AVAILABLE:
-		if (likely(tracer->str_db.loaded))
-			queue_work(tracer->work_queue, &tracer->handle_traces_work);
+		queue_work(tracer->work_queue, &tracer->handle_traces_work);
 		break;
 	default:
 		mlx5_core_dbg(dev, "FWTracer: Event with unrecognized subtype: sub_type %d\n",
-- 
2.35.1



