Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCE4359A02D
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352392AbiHSQWT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352467AbiHSQVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:21:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38557F7B;
        Fri, 19 Aug 2022 09:02:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C75AA6177D;
        Fri, 19 Aug 2022 16:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E8E5C433C1;
        Fri, 19 Aug 2022 16:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924939;
        bh=8X1dscwIlPsup7vQ7QLBYq58S4MnnMJ73UZ9OiX8JUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SFa/F42hURpkNL/gl3xfbdgozggMJx/WQmVh04fDXIjk80Obx2vKqz/XRogNrKILu
         9bc/+4D5fQikUCItKkU7eWyAll+x0Rwyztv81tJAafl//8k20QD87xatCZa1DYQSkS
         GXcpl1QegwLWnc2GawV53XhfLepujStMqCntbA6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peng Fan <peng.fan@nxp.com>, Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 330/545] interconnect: imx: fix max_node_id
Date:   Fri, 19 Aug 2022 17:41:40 +0200
Message-Id: <20220819153844.143944256@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit bd734481e172b4827af09c9ab06c51d2ab7201e6 ]

max_node_id not equal to the ARRAY_SIZE of node array, need increase 1,
otherwise xlate will fail for the last entry. And rename max_node_id
to num_nodes to reflect the reality.

Fixes: f0d8048525d7d ("interconnect: Add imx core driver")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Link: https://lore.kernel.org/r/20220703091132.1412063-5-peng.fan@oss.nxp.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/imx/imx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/interconnect/imx/imx.c b/drivers/interconnect/imx/imx.c
index e398ebf1dbba..36f870e7b596 100644
--- a/drivers/interconnect/imx/imx.c
+++ b/drivers/interconnect/imx/imx.c
@@ -226,16 +226,16 @@ int imx_icc_register(struct platform_device *pdev,
 	struct device *dev = &pdev->dev;
 	struct icc_onecell_data *data;
 	struct icc_provider *provider;
-	int max_node_id;
+	int num_nodes;
 	int ret;
 
 	/* icc_onecell_data is indexed by node_id, unlike nodes param */
-	max_node_id = get_max_node_id(nodes, nodes_count);
-	data = devm_kzalloc(dev, struct_size(data, nodes, max_node_id),
+	num_nodes = get_max_node_id(nodes, nodes_count) + 1;
+	data = devm_kzalloc(dev, struct_size(data, nodes, num_nodes),
 			    GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-	data->num_nodes = max_node_id;
+	data->num_nodes = num_nodes;
 
 	provider = devm_kzalloc(dev, sizeof(*provider), GFP_KERNEL);
 	if (!provider)
-- 
2.35.1



