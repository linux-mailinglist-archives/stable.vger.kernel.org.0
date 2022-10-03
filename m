Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0384B5F2A4C
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbiJCHfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbiJCHe1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:34:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E82F52DFA;
        Mon,  3 Oct 2022 00:22:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 646DE60FB1;
        Mon,  3 Oct 2022 07:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7FEC433C1;
        Mon,  3 Oct 2022 07:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781593;
        bh=CcH2+5JFR4arTN14uAOW6GMbpSYm3V+PJ+UNMQhMOaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LssQyxtNBPY80V2RHBYJ2XuLgUjRUH6p2z9dqOV9HDJxH8efAUcAC8CIaf3MCgWZ+
         0jGFDUsLXSPKG3qH810HqY25L2rLMdZtTdQEshnuttjjWC4hcVHPq6Ut/zFTJWcH7p
         VToaR1FvTnkmu/LtBFsuKShhGg+hoyvgtm3cyonQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Wu <wupeng58@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/83] net/mlxbf_gige: Fix an IS_ERR() vs NULL bug in mlxbf_gige_mdio_probe
Date:   Mon,  3 Oct 2022 09:11:24 +0200
Message-Id: <20221003070723.482132748@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070721.971297651@linuxfoundation.org>
References: <20221003070721.971297651@linuxfoundation.org>
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
index caa4380ada13..5819584345ab 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_mdio.c
@@ -244,8 +244,8 @@ int mlxbf_gige_mdio_probe(struct platform_device *pdev, struct mlxbf_gige *priv)
 	}
 
 	priv->clk_io = devm_ioremap(dev, res->start, resource_size(res));
-	if (IS_ERR(priv->clk_io))
-		return PTR_ERR(priv->clk_io);
+	if (!priv->clk_io)
+		return -ENOMEM;
 
 	mlxbf_gige_mdio_cfg(priv);
 
-- 
2.35.1



