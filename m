Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7174B47F6
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245614AbiBNJw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:52:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343971AbiBNJv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:51:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CE56580C;
        Mon, 14 Feb 2022 01:42:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21AF961172;
        Mon, 14 Feb 2022 09:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC93C340E9;
        Mon, 14 Feb 2022 09:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831742;
        bh=veH/rM47JN9wSPQuqR4WOFq5vn7iCDGrjKB+dEHAJG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik1WgBk1w0+9jL0Tq229MyrBG/g3CeZoUs6NsFyUIR+9y85sO8Tm+rNhxHF3sO7Hb
         DwPcSSqeRSwk0n1hiEdNRCcE2g5XX4WGnWSwNR/0hsqNamMsAgt2exhST5b0jYYybV
         av+210+HCGhx218aStjqO+CTZiOB0HX4ymA8Yf7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/116] dpaa2-eth: unregister the netdev before disconnecting from the PHY
Date:   Mon, 14 Feb 2022 10:26:21 +0100
Message-Id: <20220214092501.598954427@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092458.668376521@linuxfoundation.org>
References: <20220214092458.668376521@linuxfoundation.org>
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

From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>

[ Upstream commit 9ccc6e0c8959a019bb40f6b18704b142c04b19a8 ]

The netdev should be unregistered before we are disconnecting from the
MAC/PHY so that the dev_close callback is called and the PHY and the
phylink workqueues are actually stopped before we are disconnecting and
destroying the phylink instance.

Fixes: 719479230893 ("dpaa2-eth: add MAC/PHY support through phylink")
Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index f06d88c471d0f..f917bc9c87969 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4405,12 +4405,12 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 #ifdef CONFIG_DEBUG_FS
 	dpaa2_dbg_remove(priv);
 #endif
+
+	unregister_netdev(net_dev);
 	rtnl_lock();
 	dpaa2_eth_disconnect_mac(priv);
 	rtnl_unlock();
 
-	unregister_netdev(net_dev);
-
 	dpaa2_eth_dl_port_del(priv);
 	dpaa2_eth_dl_traps_unregister(priv);
 	dpaa2_eth_dl_unregister(priv);
-- 
2.34.1



