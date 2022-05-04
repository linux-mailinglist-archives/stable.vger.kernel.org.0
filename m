Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F03251A904
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356550AbiEDRN5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350346AbiEDRLe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:11:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF0E4B43B;
        Wed,  4 May 2022 09:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFC7618E5;
        Wed,  4 May 2022 16:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B1EC385A4;
        Wed,  4 May 2022 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683452;
        bh=pW6duUgE0ONp/fmXIFWRgsBD9Qf0/KQK+IF84k6p0Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b0TQMixklXnV9ZfRYaaGFKuEUNRdaiVVevzDgbG2Kc/7ATWzZwwClY/dw9/Dqxa8w
         QYx6hbqqf03WidKD9Hd3tIIKoEzFq4qrnJQqqskFD3xrMtP+WxPwSs1IOVgakPhR8u
         3ml7jfaSgN6NWjv87956DYkXta2bGbUYnd3/VmLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Li <lipeng321@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 115/225] net: hns3: fix error log of tx/rx tqps stats
Date:   Wed,  4 May 2022 18:45:53 +0200
Message-Id: <20220504153120.819339388@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit 123521b6b260d901937d3fb598ab88d260c857a6 ]

The comments in function hclge_comm_tqps_update_stats is not right,
so fix it.

Fixes: 287db5c40d15 ("net: hns3: create new set of common tqp stats APIs for PF and VF reuse")
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c         | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
index 0c60f41fca8a..f3c9395d8351 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
@@ -75,7 +75,7 @@ int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
 		ret = hclge_comm_cmd_send(hw, &desc, 1);
 		if (ret) {
 			dev_err(&hw->cmq.csq.pdev->dev,
-				"failed to get tqp stat, ret = %d, tx = %u.\n",
+				"failed to get tqp stat, ret = %d, rx = %u.\n",
 				ret, i);
 			return ret;
 		}
@@ -89,7 +89,7 @@ int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
 		ret = hclge_comm_cmd_send(hw, &desc, 1);
 		if (ret) {
 			dev_err(&hw->cmq.csq.pdev->dev,
-				"failed to get tqp stat, ret = %d, rx = %u.\n",
+				"failed to get tqp stat, ret = %d, tx = %u.\n",
 				ret, i);
 			return ret;
 		}
-- 
2.35.1



