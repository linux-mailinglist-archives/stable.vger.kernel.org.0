Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 194D94B4995
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348009AbiBNKey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:34:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347820AbiBNKeY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEBAC58;
        Mon, 14 Feb 2022 02:00:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 588E460A53;
        Mon, 14 Feb 2022 10:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344FBC340E9;
        Mon, 14 Feb 2022 10:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832855;
        bh=nyQhR6VxYrmQChXEtTWPCthKdRv7SdJZk83vIwv/vAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZTcImUQ5JMbCuFePv+UhoAvQrLAfe92qh0lHFZ8Klzxf/nW2yurDVXTBMu2T0y3ts
         oIrmzd5DV533hFXHyuVSyfhaZPir3e/IfEVXjkfjgfwvdxTYoj+xz4L0SNUklW4LcV
         OYijzfnQ+MrUbyb4vrFIU/tPXpY31w0oN491aY9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 115/203] net: sparx5: Fix get_stat64 crash in tcpdump
Date:   Mon, 14 Feb 2022 10:25:59 +0100
Message-Id: <20220214092514.165032345@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steen Hegelund <steen.hegelund@microchip.com>

[ Upstream commit ed14fc7a79ab43e9f2cb1fa9c1733fdc133bba30 ]

This problem was found with Sparx5 when the tcpdump tool requests the
do_get_stats64 (sparx5_get_stats64) statistic.

The portstats pointer was incorrectly incremented when fetching priority
based statistics.

Fixes: af4b11022e2d (net: sparx5: add ethtool configuration and statistics support)
Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Link: https://lore.kernel.org/r/20220203102900.528987-1-steen.hegelund@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
index 59783fc46a7b9..10b866e9f7266 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
@@ -1103,7 +1103,7 @@ void sparx5_get_stats64(struct net_device *ndev,
 	stats->tx_carrier_errors = portstats[spx5_stats_tx_csense_cnt];
 	stats->tx_window_errors = portstats[spx5_stats_tx_late_coll_cnt];
 	stats->rx_dropped = portstats[spx5_stats_ana_ac_port_stat_lsb_cnt];
-	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx, ++stats)
+	for (idx = 0; idx < 2 * SPX5_PRIOS; ++idx)
 		stats->rx_dropped += portstats[spx5_stats_green_p0_rx_port_drop
 					       + idx];
 	stats->tx_dropped = portstats[spx5_stats_tx_local_drop];
-- 
2.34.1



