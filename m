Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20609627E8E
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237302AbiKNMtK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbiKNMtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:49:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54612C33
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:49:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18367B80EBC
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB91C433D6;
        Mon, 14 Nov 2022 12:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430145;
        bh=ei3L86viY3UfThmwEgFKy+SeDBl/VJlYXTuP34Fh/yY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dbAYbQldBuyIk16Y4vOWBw9fDRS+hBF7vUVXKICIm8sEzJiWN73m0j+bwR9p/kV6S
         t2Zifw2JPH0UMeE+rq8jHqoI6cHv5mqdw0uJyNo2UEzd6ql0f8sug3eJzRuzWculkd
         zLG3HN96vBFN78oqxE96WICKLSK080LfkjKVAwMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <atenart@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 13/95] macsec: delete new rxsc when offload fails
Date:   Mon, 14 Nov 2022 13:45:07 +0100
Message-Id: <20221114124443.060614972@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
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

[ Upstream commit 93a30947821c203d08865c4e17ea181c9668ce52 ]

Currently we get an inconsistent state:
 - netlink returns the error to userspace
 - the RXSC is installed but not offloaded

Then the device could get confused when we try to add an RXSA, because
the RXSC isn't supposed to exist.

Fixes: 3cf3227a21d1 ("net: macsec: hardware offloading infrastructure")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 70c5905a916b..65e0af28c950 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1867,7 +1867,6 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
-	bool was_active;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1895,7 +1894,6 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(rx_sc);
 	}
 
-	was_active = rx_sc->active;
 	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
 		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
 
@@ -1922,7 +1920,8 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 
 cleanup:
-	rx_sc->active = was_active;
+	del_rx_sc(secy, sci);
+	free_rx_sc(rx_sc);
 	rtnl_unlock();
 	return ret;
 }
-- 
2.35.1



