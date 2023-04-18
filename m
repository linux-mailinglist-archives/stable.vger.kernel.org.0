Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BACB6E6277
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbjDRMcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjDRMcs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:32:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F200AC150
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:32:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 343C0631B4
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C62C433D2;
        Tue, 18 Apr 2023 12:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821145;
        bh=d9nuNP5kEAoRRye1rk/4dX7muzbbp/uvS1B0wdP70N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euLyumidZouzF3qbsm1sRmm1Bd/uW2XXoIeHb3FKGUV7l6s9I46dl3WgGYzivLEHD
         38ErHMBTSs1I77Jdmx/8FP18jaxpjEiEV0y5pC8yi3QnVWdtNKmufo1tWESWBVg48u
         e2h+y28hKT7cH2RW7ELn55mXLZe2phN0GxIOfW/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corinna Vinschen <vinschen@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/124] net: stmmac: fix up RX flow hash indirection table when setting channels
Date:   Tue, 18 Apr 2023 14:20:35 +0200
Message-Id: <20230418120310.245730730@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corinna Vinschen <vinschen@redhat.com>

[ Upstream commit 218c597325f4faf7b7a6049233a30d7842b5b2dc ]

stmmac_reinit_queues() fails to fix up the RX hash.  Even if the number
of channels gets restricted, the output of `ethtool -x' indicates that
all RX queues are used:

  $ ethtool -l enp0s29f2
  Channel parameters for enp0s29f2:
  Pre-set maximums:
  RX:		8
  TX:		8
  Other:		n/a
  Combined:	n/a
  Current hardware settings:
  RX:		8
  TX:		8
  Other:		n/a
  Combined:	n/a
  $ ethtool -x enp0s29f2
  RX flow hash indirection table for enp0s29f2 with 8 RX ring(s):
      0:      0     1     2     3     4     5     6     7
      8:      0     1     2     3     4     5     6     7
  [...]
  $ ethtool -L enp0s29f2 rx 3
  $ ethtool -x enp0s29f2
  RX flow hash indirection table for enp0s29f2 with 3 RX ring(s):
      0:      0     1     2     3     4     5     6     7
      8:      0     1     2     3     4     5     6     7
  [...]

Fix this by setting the indirection table according to the number
of specified queues.  The result is now as expected:

  $ ethtool -L enp0s29f2 rx 3
  $ ethtool -x enp0s29f2
  RX flow hash indirection table for enp0s29f2 with 3 RX ring(s):
      0:      0     1     2     0     1     2     0     1
      8:      2     0     1     2     0     1     2     0
  [...]

Tested on Intel Elkhart Lake.

Fixes: 0366f7e06a6b ("net: stmmac: add ethtool support for get/set channels")
Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
Link: https://lore.kernel.org/r/20230403121120.489138-1-vinschen@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 04c59102a2863..de66406c50572 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4940,7 +4940,7 @@ static void stmmac_napi_del(struct net_device *dev)
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	int ret = 0;
+	int ret = 0, i;
 
 	if (netif_running(dev))
 		stmmac_release(dev);
@@ -4949,6 +4949,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	priv->plat->rx_queues_to_use = rx_cnt;
 	priv->plat->tx_queues_to_use = tx_cnt;
+	if (!netif_is_rxfh_configured(dev))
+		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
+									rx_cnt);
 
 	stmmac_napi_add(dev);
 
-- 
2.39.2



