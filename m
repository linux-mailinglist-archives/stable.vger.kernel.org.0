Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A956DEE0A
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjDLIjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjDLIjY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:39:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA8C76AB
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:38:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC58663000
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6D1C433D2;
        Wed, 12 Apr 2023 08:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288611;
        bh=LBFkbRKE7UvqvL1Ox66o5n/j4Yxn0+6vCZC53yElL68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dQpgsYV1UrlU1F5h4Fsto98p7+yhAEID8eEi+9hAM5dVcilYzjnDWflLDCzeBxA2Y
         7UChkCyNAJVe0yxPPGs83V8JqSqk9XvLSzYCkXyXYjhVcaQBrQ9d1ECnFMCFN34pap
         0HnysVsED5at2qlPw3tLn/N0hi0tUbd2DBr0WkY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Corinna Vinschen <vinschen@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/93] net: stmmac: fix up RX flow hash indirection table when setting channels
Date:   Wed, 12 Apr 2023 10:33:44 +0200
Message-Id: <20230412082824.950894177@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index 728e68971c397..a3bd5396c2f87 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6893,7 +6893,7 @@ static void stmmac_napi_del(struct net_device *dev)
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
-	int ret = 0;
+	int ret = 0, i;
 
 	if (netif_running(dev))
 		stmmac_release(dev);
@@ -6902,6 +6902,10 @@ int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt)
 
 	priv->plat->rx_queues_to_use = rx_cnt;
 	priv->plat->tx_queues_to_use = tx_cnt;
+	if (!netif_is_rxfh_configured(dev))
+		for (i = 0; i < ARRAY_SIZE(priv->rss.table); i++)
+			priv->rss.table[i] = ethtool_rxfh_indir_default(i,
+									rx_cnt);
 
 	stmmac_napi_add(dev);
 
-- 
2.39.2



