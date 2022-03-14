Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD18B4D8136
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 12:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239413AbiCNLkK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 07:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239451AbiCNLjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 07:39:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC72641318;
        Mon, 14 Mar 2022 04:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC7061189;
        Mon, 14 Mar 2022 11:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A845C340EC;
        Mon, 14 Mar 2022 11:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647257874;
        bh=YCUFzadyaHoFzSjHrge+ZnugCfMoDuKERu5OMjmewMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZ2Ir2SUDBqiY0BGc97h8XuQ+vuWVzUC0dEnIqJ0wodtXw6B3lhuIDsH2b9ibmZ01
         zKUU2ph2Ea0FuUj3uFlqN47Bl799ZBPSq30s88CDUZ1J/3zv10C52JvncKthF6UwdZ
         ERISMV7IM7WalefMsUuw4HLr8cC3Jzn8yEFmE4KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/30] gianfar: ethtool: Fix refcount leak in gfar_get_ts_info
Date:   Mon, 14 Mar 2022 12:34:28 +0100
Message-Id: <20220314112732.080037634@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112731.785042288@linuxfoundation.org>
References: <20220314112731.785042288@linuxfoundation.org>
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
index 395a5266ea30..0cddaaaf48aa 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1528,6 +1528,7 @@ static int gfar_get_ts_info(struct net_device *dev,
 	ptp_node = of_find_compatible_node(NULL, NULL, "fsl,etsec-ptp");
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
 		if (ptp_dev)
 			ptp = platform_get_drvdata(ptp_dev);
 	}
-- 
2.34.1



