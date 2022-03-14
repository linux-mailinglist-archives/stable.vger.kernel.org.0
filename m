Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1BF4D8263
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240433AbiCNMDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240724AbiCNMD2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:03:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A564B43F;
        Mon, 14 Mar 2022 05:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C27E56112C;
        Mon, 14 Mar 2022 12:00:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16DAC340E9;
        Mon, 14 Mar 2022 12:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259245;
        bh=PammZmf/887fjlSTjafG/i4SUvHeL/WS/ItbAgnkW5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SG7gS522zobwPncwwcrX6kvhT2540nbDn2eoiaYcACHeeRchnQADjAM+UBJpNSyh7
         xoqUQUkUHjwTy1Fy6RFjh31viLc4hSTandFFcWBb+JzYnjfVCYmJUGP26nw5GTs3L9
         HzNTsc3+WBmQpQtg11iQnL4mSJaXssEOjmFCMbf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 33/71] gianfar: ethtool: Fix refcount leak in gfar_get_ts_info
Date:   Mon, 14 Mar 2022 12:53:26 +0100
Message-Id: <20220314112738.859903699@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 2ac5b58e645c66932438bb021cb5b52097ce70b0 ]

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20220310015313.14938-1-linmq006@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index cc7d4f93da54..799a1486f586 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1456,6 +1456,7 @@ static int gfar_get_ts_info(struct net_device *dev,
 	ptp_node = of_find_compatible_node(NULL, NULL, "fsl,etsec-ptp");
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
 		if (ptp_dev)
 			ptp = platform_get_drvdata(ptp_dev);
 	}
-- 
2.34.1



