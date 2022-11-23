Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE7163585D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiKWJ42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:56:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiKWJzB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:55:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B0F5F92
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:50:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 93296619EB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36B8C433C1;
        Wed, 23 Nov 2022 09:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197045;
        bh=rbHOnH0bDQ0tV63PvzNhoB75RHapbYfhoW1bD24vfYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qR/nZfcN6SLaoLvUkWhtOg/MhNMizQ8mnMWYMLErLFA+4ejqvD5Fac3pa3UFw8F17
         u/JNjCpQmHCVG5uYTRg6+RRAZjfNvGse93D2o1FD103Z9CZJTGPNX8VE6H31kCUYlb
         whVD1OEepW0S1Kdqv1QNGKNycNywrJuQZRHhhcaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Jian <liujian56@huawei.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 183/314] net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()
Date:   Wed, 23 Nov 2022 09:50:28 +0100
Message-Id: <20221123084633.857629597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index e461f4764066..e23d8734d4e4 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1427,7 +1427,7 @@ static int ag71xx_open(struct net_device *ndev)
 	if (ret) {
 		netif_err(ag, link, ndev, "phylink_of_phy_connect filed with err: %i\n",
 			  ret);
-		goto err;
+		return ret;
 	}
 
 	max_frame_len = ag71xx_max_frame_len(ndev->mtu);
@@ -1448,6 +1448,7 @@ static int ag71xx_open(struct net_device *ndev)
 
 err:
 	ag71xx_rings_cleanup(ag);
+	phylink_disconnect_phy(ag->phylink);
 	return ret;
 }
 
-- 
2.35.1



