Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559A563571E
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238062AbiKWJiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237991AbiKWJhi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:37:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF6ED2F8
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:35:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AC2BB81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64953C433C1;
        Wed, 23 Nov 2022 09:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196141;
        bh=n/RV/cAZxCqMVbhNjgokIf+BQo30eFY4xz9Ml7UwoMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GOldNvBJ8Clcgg3tQJI7DSfnh3t3rY81uWtHnOYx04SjC7+NuV+cV5OMIkMHDBsef
         WqNnP6xC1evtDODbWCVXm/cCcyXY9atfkDkSYOG+WK5R33xHQxZyjOGrEbo/dNV1Hb
         c4HuQVwuePTBZ1awQBfnNlvoVNT43IwxHeZ4ZD50=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Jian <liujian56@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/181] net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()
Date:   Wed, 23 Nov 2022 09:51:03 +0100
Message-Id: <20221123084606.650704135@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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

[ Upstream commit c9b895c6878bdb6789dc1d7af60fd10f4a9f1937 ]

If ag71xx_hw_enable() fails, call phylink_disconnect_phy() to clean up.
And if phylink_of_phy_connect() fails, nothing needs to be done.
Compile tested only.

Fixes: 892e09153fa3 ("net: ag71xx: port to phylink")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20221114095549.40342-1-liujian56@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/atheros/ag71xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 416a5c99db5a..7295244b78d0 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1480,7 +1480,7 @@ static int ag71xx_open(struct net_device *ndev)
 	if (ret) {
 		netif_err(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
 			  ret);
-		goto err;
+		return ret;
 	}
 
 	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
@@ -1501,6 +1501,7 @@ static int ag71xx_open(struct net_device *ndev)
 
 err:
 	ag71xx_rings_cleanup(ag);
+	phylink_disconnect_phy(ag->phylink);
 	return ret;
 }
 
-- 
2.35.1



