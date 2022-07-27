Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258C8582ED3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiG0RR4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231937AbiG0RRN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:17:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EED4BCA;
        Wed, 27 Jul 2022 09:43:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C51B821C5;
        Wed, 27 Jul 2022 16:43:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94C3C433D7;
        Wed, 27 Jul 2022 16:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940197;
        bh=reqS1FC7SNHKb5oM0t/Ti65oP22ffR5nY0X7/alNUK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gvOevyWHlkigzhZXUQCNVBU8qm+Y2kRnR3HSNnr26IWG7llpescgjpI0uYt5KnzJp
         F2Q8wx8HZ4DeHDu9zyK+eq68zhI4P5VdLFCVtKYLIQkdjfhpzuNY9MPoEhd1plUwcZ
         ql+NQjozZNIAHYqxoYSTIGmTnq2yBhy5BM2efJ7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/201] net: stmmac: remove redunctant disable xPCS EEE call
Date:   Wed, 27 Jul 2022 18:10:12 +0200
Message-Id: <20220727161032.236526995@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wong Vee Khee <vee.khee.wong@linux.intel.com>

[ Upstream commit da791bac104a3169b05b54270afe75daacba4641 ]

Disable is done in stmmac_init_eee() on the event of MAC link down.
Since setting enable/disable EEE via ethtool will eventually trigger
a MAC down, removing this redunctant call in stmmac_ethtool.c to avoid
calling xpcs_config_eee() twice.

Fixes: d4aeaed80b0e ("net: stmmac: trigger PCS EEE to turn off on link down")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
Link: https://lore.kernel.org/r/20220715122402.1017470-1-vee.khee.wong@linux.intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 8f563b446d5c..dc31501fec8f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -800,14 +800,6 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 		netdev_warn(priv->dev,
 			    "Setting EEE tx-lpi is not supported\n");
 
-	if (priv->hw->xpcs) {
-		ret = xpcs_config_eee(priv->hw->xpcs,
-				      priv->plat->mult_fact_100ns,
-				      edata->eee_enabled);
-		if (ret)
-			return ret;
-	}
-
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
 
-- 
2.35.1



