Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEFF5497F0
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381127AbiFMOUQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382071AbiFMOQg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:16:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E662DD6E;
        Mon, 13 Jun 2022 04:43:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9714B80E2C;
        Mon, 13 Jun 2022 11:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3DCC34114;
        Mon, 13 Jun 2022 11:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120585;
        bh=kspaQPGbJV1NlakBjIX0v3JHztnswdilDVjBlWSPEtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kK+XbWUV0bjzE+mpBvkPEGNnuUyWFzJqk2icJOJAMF1WwJvP0uDrkbxsJe54+XYDo
         tz0kRBOKoSAn+MlU/bJ1WUPD8lTthzWj34aQ5Vr2FoDMEKf5HC5FtsP52PBIU42EZ7
         6xTUMCCFo9m2gFg58m9W5TwnoOhMZ9MWYtnqiGu8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 085/298] net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks
Date:   Mon, 13 Jun 2022 12:09:39 +0200
Message-Id: <20220613094927.526020927@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 5dd89d2fc438457811cbbec07999ce0d80051ff5 ]

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not need anymore.
am65_cpsw_init_cpts() and am65_cpsw_nuss_probe() don't release
the refcount in error case.
Add missing of_node_put() to avoid refcount leak.

Fixes: b1f66a5bee07 ("net: ethernet: ti: am65-cpsw-nuss: enable packet timestamping support")
Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8251d7eb001b..eda91336c9f6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1802,6 +1802,7 @@ static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
 	if (IS_ERR(cpts)) {
 		int ret = PTR_ERR(cpts);
 
+		of_node_put(node);
 		if (ret == -EOPNOTSUPP) {
 			dev_info(dev, "cpts disabled\n");
 			return 0;
@@ -2669,9 +2670,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (!node)
 		return -ENOENT;
 	common->port_num = of_get_child_count(node);
+	of_node_put(node);
 	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
 		return -ENOENT;
-	of_node_put(node);
 
 	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
-- 
2.35.1



