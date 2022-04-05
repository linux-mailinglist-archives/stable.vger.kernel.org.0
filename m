Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803E14F38CF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377233AbiDEL23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349770AbiDEJvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:51:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869D8186EE;
        Tue,  5 Apr 2022 02:49:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 163D6615E3;
        Tue,  5 Apr 2022 09:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27828C385A2;
        Tue,  5 Apr 2022 09:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152161;
        bh=7YUnPeYxarf7zslWpL73PYpMwLDUnxnQZtWx1wJq5pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sj+hbsOKAl5ULzyawmXlNOuLNlcQPvNQM4jx/Xd5MLJpxxHfwz5rkQgxtaDyxqNj1
         SKUt9Lx4RJNQcoQxhliQgQ1JaMrePK/3Au232hZF4lAu48hW4XrPp2YOADb9Ok37eV
         N7isNp5upyPHfWB3qId05oMmp+8sMXa8+N4expzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 660/913] net: enetc: report software timestamping via SO_TIMESTAMPING
Date:   Tue,  5 Apr 2022 09:28:42 +0200
Message-Id: <20220405070359.621564833@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit feb13dcb1818b775fbd9191f797be67cd605f03e ]

Let user space properly determine that the enetc driver provides
software timestamps.

Fixes: 4caefbce06d1 ("enetc: add software timestamping")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://lore.kernel.org/r/20220324161210.4122281-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 910b9f722504..d62c188c8748 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -672,7 +672,10 @@ static int enetc_get_ts_info(struct net_device *ndev,
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
-				SOF_TIMESTAMPING_RAW_HARDWARE;
+				SOF_TIMESTAMPING_RAW_HARDWARE |
+				SOF_TIMESTAMPING_TX_SOFTWARE |
+				SOF_TIMESTAMPING_RX_SOFTWARE |
+				SOF_TIMESTAMPING_SOFTWARE;
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
 			 (1 << HWTSTAMP_TX_ON) |
-- 
2.34.1



