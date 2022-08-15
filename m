Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 843E7593807
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbiHOTXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243891AbiHOTVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13B43D5BD;
        Mon, 15 Aug 2022 11:40:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02746611B9;
        Mon, 15 Aug 2022 18:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A554C433D7;
        Mon, 15 Aug 2022 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588832;
        bh=QZTpeShZqGomUhO9hz65Uhh5sjEr5H4rDMz0+UZAq88=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5/6W4AttMb90ruu57Ar4Ot0LtrpWM0q5RuI76rS2izJ3ffoRbRUrRUXWfWaSxHmN
         HdPytH5C+BwNZ2C9O5NcuVvktwWvXR4RSG7gAx8Skpd/ZuSmYrLEuRp/vFLwyapuRe
         oTCoBp+0JxRBkOc7423zuwpCQiVwc125phb0rUuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Peng Fan <peng.fan@nxp.com>, Georgi Djakov <djakov@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/779] interconnect: imx: fix max_node_id
Date:   Mon, 15 Aug 2022 20:02:21 +0200
Message-Id: <20220815180358.518025334@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index c770951a909c..aabd9edf2ef7 100644
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



