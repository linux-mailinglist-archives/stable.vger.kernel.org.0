Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D759E6158AD
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbiKBC4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiKBC4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:56:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0BCA222BA
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:56:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F9FF617BB
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05D6C433D6;
        Wed,  2 Nov 2022 02:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357777;
        bh=ngzuon6WC9BmhDYpJv/vdf+Oxq4FNwcmrJPiqdgSbqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KebM2zDP+W/doJVXETE8JjO2PoK8E5Zxvxn6cEyoAOA8LrRLSGVy5kVZaV2cfTaXk
         aIFBmLz0J7a4j0qjewXsQ4kWmvqWTSQ3dabYdiVrze1G8RQW58Hgw0MYFNTXEyVxWd
         jPk2HFYikG3NBX2AUgVf/ULW8XOLLxmxB5AIfcHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 228/240] net/mlx5: ASO, Create the ASO SQ with the correct timestamp format
Date:   Wed,  2 Nov 2022 03:33:23 +0100
Message-Id: <20221102022116.559534027@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

[ Upstream commit 0f3caaa2c6fbf9f892bd235c9dce9eb551f8d815 ]

mlx5 SQs must select the timestamp format explicitly according to the
active clock mode, select the current active timestamp mode so ASO SQ create
will succeed.

This fixes the following error prints when trying to create ipsec ASO SQ
while the timestamp format is real time mode.

mlx5_cmd_out_err:778:(pid 34874): CREATE_SQ(0x904) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0xd61c0b), err(-22)
mlx5_aso_create_sq:285:(pid 34874): Failed to open aso wq sq, err=-22
mlx5e_ipsec_init:436:(pid 34874): IPSec initialization failed, -22

Fixes: cdd04f4d4d71 ("net/mlx5: Add support to create SQ and CQ for ASO")
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reported-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-7-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
index 21e14507ff5c..7cd9dda53774 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/aso.c
@@ -3,6 +3,7 @@
 
 #include <linux/mlx5/device.h>
 #include <linux/mlx5/transobj.h>
+#include "clock.h"
 #include "aso.h"
 #include "wq.h"
 
@@ -179,6 +180,7 @@ static int create_aso_sq(struct mlx5_core_dev *mdev, int pdn,
 {
 	void *in, *sqc, *wq;
 	int inlen, err;
+	u8 ts_format;
 
 	inlen = MLX5_ST_SZ_BYTES(create_sq_in) +
 		sizeof(u64) * sq->wq_ctrl.buf.npages;
@@ -195,6 +197,11 @@ static int create_aso_sq(struct mlx5_core_dev *mdev, int pdn,
 	MLX5_SET(sqc,  sqc, state, MLX5_SQC_STATE_RST);
 	MLX5_SET(sqc,  sqc, flush_in_error_en, 1);
 
+	ts_format = mlx5_is_real_time_sq(mdev) ?
+			MLX5_TIMESTAMP_FORMAT_REAL_TIME :
+			MLX5_TIMESTAMP_FORMAT_FREE_RUNNING;
+	MLX5_SET(sqc, sqc, ts_format, ts_format);
+
 	MLX5_SET(wq,   wq, wq_type,       MLX5_WQ_TYPE_CYCLIC);
 	MLX5_SET(wq,   wq, uar_page,      mdev->mlx5e_res.hw_objs.bfreg.index);
 	MLX5_SET(wq,   wq, log_wq_pg_sz,  sq->wq_ctrl.buf.page_shift -
-- 
2.35.1



