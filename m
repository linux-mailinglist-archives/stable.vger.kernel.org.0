Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DD2540513
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345840AbiFGRVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345746AbiFGRU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:20:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0F41059D8;
        Tue,  7 Jun 2022 10:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B21E16009B;
        Tue,  7 Jun 2022 17:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB682C36B02;
        Tue,  7 Jun 2022 17:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622445;
        bh=Bkhb4rW4Fm9ts+xqlLpF0mtthv9kANdaPO//zit9f0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cEEko9lLmCnsJ6v+BepOwo4XfZK69ilz9Ina2vR9kmWxsoyEP4jHXi1UtI1w2tbo1
         DuT/Ld7z95G77BtzKgIMyHtix6tikypIIX/J2bvIXOIUCxLt9kF+nXBcm0RFfXANfB
         AEThEpulj5OYhUFpZ/1UVSgUeI3en49jnfqwphTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jianghaoran <jianghaoran@kylinos.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/452] ipv6: Dont send rs packets to the interface of ARPHRD_TUNNEL
Date:   Tue,  7 Jun 2022 18:58:37 +0200
Message-Id: <20220607164910.336194841@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: jianghaoran <jianghaoran@kylinos.cn>

[ Upstream commit b52e1cce31ca721e937d517411179f9196ee6135 ]

ARPHRD_TUNNEL interface can't process rs packets
and will generate TX errors

ex:
ip tunnel add ethn mode ipip local 192.168.1.1 remote 192.168.1.2
ifconfig ethn x.x.x.x

ethn: flags=209<UP,POINTOPOINT,RUNNING,NOARP>  mtu 1480
	inet x.x.x.x  netmask 255.255.255.255  destination x.x.x.x
	inet6 fe80::5efe:ac1e:3cdb  prefixlen 64  scopeid 0x20<link>
	tunnel   txqueuelen 1000  (IPIP Tunnel)
	RX packets 0  bytes 0 (0.0 B)
	RX errors 0  dropped 0  overruns 0  frame 0
	TX packets 0  bytes 0 (0.0 B)
	TX errors 3  dropped 0 overruns 0  carrier 0  collisions 0

Signed-off-by: jianghaoran <jianghaoran@kylinos.cn>
Link: https://lore.kernel.org/r/20220429053802.246681-1-jianghaoran@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4584bb50960b..0562fb321959 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4200,7 +4200,8 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
 	send_rs = send_mld &&
 		  ipv6_accept_ra(ifp->idev) &&
 		  ifp->idev->cnf.rtr_solicits != 0 &&
-		  (dev->flags&IFF_LOOPBACK) == 0;
+		  (dev->flags & IFF_LOOPBACK) == 0 &&
+		  (dev->type != ARPHRD_TUNNEL);
 	read_unlock_bh(&ifp->idev->lock);
 
 	/* While dad is in progress mld report's source address is in6_addrany.
-- 
2.35.1



