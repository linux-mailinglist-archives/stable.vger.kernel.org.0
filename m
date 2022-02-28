Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5D264C7585
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:55:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbiB1RzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240385AbiB1RyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:54:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D26986E4;
        Mon, 28 Feb 2022 09:42:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19E37CE17CF;
        Mon, 28 Feb 2022 17:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149D6C340F3;
        Mon, 28 Feb 2022 17:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070121;
        bh=yWl87/l7rBweT9FrX1/+y+EbyeKeQI8YJ+qt6HRWL+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ebwm/SPlxfTOi0IegWqZXEzbuZgSKRXxl90o0D0F+CBR2lEXxZp1oVGoWkhGXq7LN
         n9eq+4aUE2Ri1jiVw7fQZbZDH+suZJclCvsLXc88v13QOtz0y2ALYNBHtSi0z1dXn+
         JC/KWBI2uM1q/7yW73A2GzH9Ig0lsewntlBtDxLU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maher Sanalla <msanalla@nvidia.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.15 084/139] net/mlx5: Update log_max_qp value to be 17 at most
Date:   Mon, 28 Feb 2022 18:24:18 +0100
Message-Id: <20220228172356.515559050@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

commit 7f839965b2d77e1926ad08b23c51d60988f10a99 upstream.

Currently, log_max_qp value is dependent on what FW reports as its max capability.
In reality, due to a bug, some FWs report a value greater than 17, even though they
don't support log_max_qp > 17.

This FW issue led the driver to exhaust memory on startup.
Thus, log_max_qp value is set to be no more than 17 regardless
of what FW reports, as it was before the cited commit.

Fixes: f79a609ea6bf ("net/mlx5: Update log_max_qp value to FW max capability")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -516,7 +516,7 @@ static int handle_hca_cap(struct mlx5_co
 
 	/* Check log_max_qp from HCA caps to set in current profile */
 	if (prof->log_max_qp == LOG_MAX_SUPPORTED_QPS) {
-		prof->log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
+		prof->log_max_qp = min_t(u8, 17, MLX5_CAP_GEN_MAX(dev, log_max_qp));
 	} else if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
 			       prof->log_max_qp,


