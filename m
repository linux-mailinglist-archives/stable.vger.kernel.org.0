Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D63627EF5
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbiKNMxy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:53:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237479AbiKNMxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:53:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CBFF022
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:53:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71E6ECE0FF1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4C3C433D6;
        Mon, 14 Nov 2022 12:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430428;
        bh=r4idgQItW6FPqd7ST8B++GYN/c5iv36dcNwNzs4usYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vX140FIPcMXjbJWrGsNNKi/V/orjmycSiBtm4X0EpZZW6NWzxhgw3YvE8xyhJJxuJ
         VsUCqC8OG15JZw/PmzHMMXIlqxKD6j6yK/DeWGSWDV7xurUy1BknfVf5SUf8Hj8DkX
         Q2+bBxs7ZJIgomi/OHyStsnsVH4XtW4j4jSNrpaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <atenart@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/131] macsec: fix secy->n_rx_sc accounting
Date:   Mon, 14 Nov 2022 13:44:54 +0100
Message-Id: <20221114124449.748398733@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 73a4b31c9d11f98ae3bc5286d5382930adb0e9c7 ]

secy->n_rx_sc is supposed to be the number of _active_ rxsc's within a
secy. This is then used by macsec_send_sci to help decide if we should
add the SCI to the header or not.

This logic is currently broken when we create a new RXSC and turn it
off at creation, as create_rx_sc always sets ->active to true (and
immediately uses that to increment n_rx_sc), and only later
macsec_add_rxsc sets rx_sc->active.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3a38266ba105..328f6a172b84 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1386,7 +1386,8 @@ static struct macsec_rx_sc *del_rx_sc(struct macsec_secy *secy, sci_t sci)
 	return NULL;
 }
 
-static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
+static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci,
+					 bool active)
 {
 	struct macsec_rx_sc *rx_sc;
 	struct macsec_dev *macsec;
@@ -1410,7 +1411,7 @@ static struct macsec_rx_sc *create_rx_sc(struct net_device *dev, sci_t sci)
 	}
 
 	rx_sc->sci = sci;
-	rx_sc->active = true;
+	rx_sc->active = active;
 	refcount_set(&rx_sc->refcnt, 1);
 
 	secy = &macsec_priv(dev)->secy;
@@ -1863,6 +1864,7 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
+	bool active = true;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1884,15 +1886,15 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	secy = &macsec_priv(dev)->secy;
 	sci = nla_get_sci(tb_rxsc[MACSEC_RXSC_ATTR_SCI]);
 
-	rx_sc = create_rx_sc(dev, sci);
+	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
+		active = nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
+
+	rx_sc = create_rx_sc(dev, sci, active);
 	if (IS_ERR(rx_sc)) {
 		rtnl_unlock();
 		return PTR_ERR(rx_sc);
 	}
 
-	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
-		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
-
 	if (macsec_is_offloaded(netdev_priv(dev))) {
 		const struct macsec_ops *ops;
 		struct macsec_context ctx;
-- 
2.35.1



