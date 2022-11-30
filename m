Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD063DD71
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiK3S1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiK3S1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:27:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C812E692
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:27:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA93BB81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE25C433C1;
        Wed, 30 Nov 2022 18:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832830;
        bh=bo47dcqfnvY8c+vhOvHvDfgNZrE5+EvDdyJ1RrYo9Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kc0zJQ3+OSifk259UuZ2otur0HDkGv8vRtP7BfWf+EhB+AMYLgnk0AEIE/2+X3mNI
         7oUyF+GvynpfUWSU+ui+6NI65OL1WwTgVO2/MFQQxJLbv52A7QrTXz4ylSo7OPTG23
         BhXQUhiSOc4pmVtwGAuTEIoRB3Q4jQuPyL6zbKRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Jian <liujian56@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 056/162] net: ethernet: mtk_eth_soc: fix error handling in mtk_open()
Date:   Wed, 30 Nov 2022 19:22:17 +0100
Message-Id: <20221130180530.027288958@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit f70074140524c59a0935947b06dd6cb6e1ea642d ]

If mtk_start_dma() fails, invoke phylink_disconnect_phy() to perform
cleanup. phylink_disconnect_phy() contains the put_device action. If
phylink_disconnect_phy is not performed, the Kref of netdev will leak.

Fixes: b8fc9f30821e ("net: ethernet: mediatek: Add basic PHYLINK support")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20221117111356.161547-1-liujian56@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c7aff89141e1..217dc67c48fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2299,7 +2299,10 @@ static int mtk_open(struct net_device *dev)
 		int err = mtk_start_dma(eth);
 
 		if (err)
+		if (err) {
+			phylink_disconnect_phy(mac->phylink);
 			return err;
+		}
 
 		mtk_gdm_config(eth, MTK_GDMA_TO_PDMA);
 
-- 
2.35.1



