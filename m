Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AE0627FD8
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237681AbiKNNCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237718AbiKNNCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD1E26493
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 866FCCE0FFA
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F43C433B5;
        Mon, 14 Nov 2022 13:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430920;
        bh=5JTIihGnkjUcQT77PjIVpHbz/g5xEhy16HfFCbMDbRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTz2amq4CDWSX5q9A4p5BFKZEwONaTyX3uEjALcFHQ7UeD5+QBbmOqM0uLCaCD0uo
         SeBP6EGVDo6t4tsjnNa5ZTvAgzhFhoy9j/LdmtLbbjmOoPmA6tLQJzX9gL7A5IdTme
         LduH1D5hziEyiyVQGpBvuHzKxKqgpOvbQfJtP1fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <atenart@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 035/190] macsec: delete new rxsc when offload fails
Date:   Mon, 14 Nov 2022 13:44:19 +0100
Message-Id: <20221114124500.316555039@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index c6d271e5687e..3fce89a05312 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1904,7 +1904,6 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 	struct macsec_rx_sc *rx_sc;
 	struct nlattr *tb_rxsc[MACSEC_RXSC_ATTR_MAX + 1];
 	struct macsec_secy *secy;
-	bool was_active;
 	int ret;
 
 	if (!attrs[MACSEC_ATTR_IFINDEX])
@@ -1932,7 +1931,6 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
 		return PTR_ERR(rx_sc);
 	}
 
-	was_active = rx_sc->active;
 	if (tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE])
 		rx_sc->active = !!nla_get_u8(tb_rxsc[MACSEC_RXSC_ATTR_ACTIVE]);
 
@@ -1959,7 +1957,8 @@ static int macsec_add_rxsc(struct sk_buff *skb, struct genl_info *info)
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



