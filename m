Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2523A4BDD19
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348383AbiBUJ13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:27:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349054AbiBUJYu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:24:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A539694;
        Mon, 21 Feb 2022 01:10:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DCA26097C;
        Mon, 21 Feb 2022 09:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5725BC340E9;
        Mon, 21 Feb 2022 09:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434628;
        bh=06AEE+dTILRtwDY8oQbRofaIwu30iB9WUEgyuAH6rvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=admmjWX/ssQoqz+uoIMyxR4wFmQJwqOHmnhzo8b3Wv7YiiGWIMU4q5cbvdDoZX7Q+
         XGnjsYfsOLaXg9tAenriKZTE5NORKm2bq1gUxHjkUFAWu+s7d3fBhhuqTMEFasbAza
         kA3Zci7V02gpmFtAWE/4PF0NziYpl2J1XNS/K9KY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/196] net: sparx5: do not refer to skb after passing it on
Date:   Mon, 21 Feb 2022 09:47:59 +0100
Message-Id: <20220221084932.504706572@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Steen Hegelund <steen.hegelund@microchip.com>

[ Upstream commit 81eb8b0b18789e647e65579303529fd52d861cc2 ]

Do not try to use any SKB fields after the packet has been passed up in the
receive stack.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Link: https://lore.kernel.org/r/20220202083039.3774851-1-steen.hegelund@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index dc7e5ea6ec158..148d431fcde42 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -145,9 +145,9 @@ static void sparx5_xtr_grp(struct sparx5 *sparx5, u8 grp, bool byte_swap)
 	skb_put(skb, byte_cnt - ETH_FCS_LEN);
 	eth_skb_pad(skb);
 	skb->protocol = eth_type_trans(skb, netdev);
-	netif_rx(skb);
 	netdev->stats.rx_bytes += skb->len;
 	netdev->stats.rx_packets++;
+	netif_rx(skb);
 }
 
 static int sparx5_inject(struct sparx5 *sparx5,
-- 
2.34.1



