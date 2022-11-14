Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCA2628066
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbiKNNFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237782AbiKNNFj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:05:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0812A427
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:05:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F67AB80EB9
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6107AC433D6;
        Mon, 14 Nov 2022 13:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668431135;
        bh=IB/nByl93+PVUpIaGd79q/0d8oBSyrmkJyiTxeZTh+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6kXveYCu5CfFgX9tJ6EF0ghEyMuNkHbAmcdkBFIdtcXpoJ6denW1fiIzcdYCIkDV
         PwQj1fGbHQDoWX3mgAH0TmHNuILClEuCeyyL9HwTOujWBietP1slsU+wx167QHvz5J
         whP7uoosrFA9tLlojKyWjw6ol2+vjqhOklLZTTCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 114/190] eth: sp7021: drop free_netdev() from spl2sw_init_netdev()
Date:   Mon, 14 Nov 2022 13:45:38 +0100
Message-Id: <20221114124503.686398965@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit de91b3197d15172407608b2c357aab7ac1451e2b ]

It's not necessary to free netdev allocated with devm_alloc_etherdev()
and using free_netdev() leads to double free.

Fixes: fd3040b9394c ("net: ethernet: Add driver for Sunplus SP7021")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20221109150116.2988194-1-weiyongjun@huaweicloud.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sunplus/spl2sw_driver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sunplus/spl2sw_driver.c b/drivers/net/ethernet/sunplus/spl2sw_driver.c
index 61d1d07dc070..d6f1fef4ff3a 100644
--- a/drivers/net/ethernet/sunplus/spl2sw_driver.c
+++ b/drivers/net/ethernet/sunplus/spl2sw_driver.c
@@ -286,7 +286,6 @@ static u32 spl2sw_init_netdev(struct platform_device *pdev, u8 *mac_addr,
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register net device \"%s\"!\n",
 			ndev->name);
-		free_netdev(ndev);
 		*r_ndev = NULL;
 		return ret;
 	}
-- 
2.35.1



