Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD0B4B4A66
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348278AbiBNKfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:35:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348267AbiBNKel (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:34:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABDAD61;
        Mon, 14 Feb 2022 02:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 808E0B80DCD;
        Mon, 14 Feb 2022 10:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F21EC340E9;
        Mon, 14 Feb 2022 10:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832880;
        bh=5oRXJ9iYbP6bvP3H+2211ccCJikkhXoMnaErPQRQCtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNm7BAxBDKJVrF68571OKyZTsCFusJBn+XmZhrzTOlLcEaU1EAcQbXzjC/lNlkakN
         7NbxcgF/Pr0WpYzSwiPMqdOMpwax12I7iYtUwPZdDl6k5SnfySQqeWhtF2dsdfcD+z
         i/6y71vybYvYltWzp9MI/4GZMK9uT57fgpN+K67A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 155/203] dpaa2-eth: unregister the netdev before disconnecting from the PHY
Date:   Mon, 14 Feb 2022 10:26:39 +0100
Message-Id: <20220214092515.514862032@linuxfoundation.org>
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
index 8e643567abce2..70c8dd6cf3508 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4523,12 +4523,12 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
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
 	dpaa2_eth_dl_free(priv);
-- 
2.34.1



