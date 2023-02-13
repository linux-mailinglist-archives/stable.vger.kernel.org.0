Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D005694979
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjBMO7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:59:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbjBMO7E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:59:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1201C7F4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:58:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 013F5B81253
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:58:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C69C433EF;
        Mon, 13 Feb 2023 14:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300323;
        bh=FYdATPFYyXkXjKZUeAiVabpQqjD5VP+ULkSDxK8BU0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VaRZI6cZwkJxpaBFLjB5VNVHYcVuxHMsRWb4J9heUil6+axyg6E8EYU4SFDMO559S
         rvnKiZfpGbsBuecgEYKd2ZRETofYQSQq5zf+c5QAb0KBwvJ4b1i1gbWjxIWQHNnRF1
         eU2af7DM0/+9zfb89rmvnRuUnj/RN/ENkoncSpLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/67] net/mlx5: fw_tracer, Clear load bit when freeing string DBs buffers
Date:   Mon, 13 Feb 2023 15:49:16 +0100
Message-Id: <20230213144734.060397081@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit db561fed6b8fa3878e74d5df6512a4a38152b63e ]

Whenever the driver is reading the string DBs into buffers, the driver
is setting the load bit, but the driver never clears this bit.
As a result, in case load bit is on and the driver query the device for
new string DBs, the driver won't read again the string DBs.
Fix it by clearing the load bit when query the device for new string
DBs.

Fixes: 2d69356752ff ("net/mlx5: Add support for fw live patch event")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 326e0b170e363..265f4ae835ce5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -64,6 +64,7 @@ static int mlx5_query_mtrc_caps(struct mlx5_fw_tracer *tracer)
 			MLX5_GET(mtrc_cap, out, num_string_trace);
 	tracer->str_db.num_string_db = MLX5_GET(mtrc_cap, out, num_string_db);
 	tracer->owner = !!MLX5_GET(mtrc_cap, out, trace_owner);
+	tracer->str_db.loaded = false;
 
 	for (i = 0; i < tracer->str_db.num_string_db; i++) {
 		mtrc_cap_sp = MLX5_ADDR_OF(mtrc_cap, out, string_db_param[i]);
-- 
2.39.0



