Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1864664862
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238915AbjAJSLY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbjAJSKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454B7FCC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:08:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5C1B6184D
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:08:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC468C433D2;
        Tue, 10 Jan 2023 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374115;
        bh=qGfCCd/8wpbo1xWc30SX752hg09IkbV39/p14pGm0zw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSnWJdt7Ww04BSztd9lhPMam0Zk9OsP3H2l96p8wDkNlQBWDQ5cn3ipjPKb1EbtdF
         IZzUeeTy8wwTMewMx+4v1oimEAO+RAVZGCZukT8rfzHOdsAnoI5uvLbYQfTSBqscMY
         y0kBGXhEQCsw9gWBOFzfrbP4noUUSG/GD0lP6bAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 051/148] net/mlx5: Add forgotten cleanup calls into mlx5_init_once() error path
Date:   Tue, 10 Jan 2023 19:02:35 +0100
Message-Id: <20230110180018.836551505@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
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
index ac178796e484..dcc1e1b404e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1017,6 +1017,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
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



