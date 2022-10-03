Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B036B5F29A8
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiJCHXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiJCHWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:22:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C965491E8;
        Mon,  3 Oct 2022 00:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E14BAB80E72;
        Mon,  3 Oct 2022 07:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494D2C433C1;
        Mon,  3 Oct 2022 07:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781316;
        bh=jdFspMelz2PECi8IFmkcgEzHOd+qwcCZ0ciiD/c7lnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjlHZaMSXmjtLmwKcLuK+a2IyZi7NnFEf7V5nWQBgXltFrrY46ToOFJjQS+S+28Il
         y9xMfK26OA2XD2Svn0BR5EK/PkoGPdBSnJd1f/JZLPFHaskoskS/cknrZ+OBZvB4cI
         lWsIOleWC2vh9gRnENHFZShl8wSJ0/PfWdEzWxHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Wu <wupeng58@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 076/101] net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe
Date:   Mon,  3 Oct 2022 09:11:12 +0200
Message-Id: <20221003070726.351598932@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Peng Wu <wupeng58@huawei.com>

[ Upstream commit 4774db8dfc6a2e6649920ebb2fc8e2f062c2080d ]

The devm_ioremap() function returns NULL on error, it doesn't return
error pointers.

Fixes: 3a1a274e933f ("mlxbf_gige: compute MDIO period based on i1clk")
Signed-off-by: Peng Wu <wupeng58@huawei.com>
Link: https://lore.kernel.org/r/20220923023640.116057-1-wupeng58@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
index 4aeb927c3715..aa780b1614a3 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -246,8 +246,8 @@ int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 	}
 
 	priv->clk_io = devm_ioremap(dev, res->start, resource_size(res));
-	if (IS_ERR(priv->clk_io))
-		return PTR_ERR(priv->clk_io);
+	if (!priv->clk_io)
+		return -ENOMEM;
 
 	mlxbf_gige_mdio_cfg(priv);
 
-- 
2.35.1



