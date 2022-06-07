Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24C254122D
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357172AbiFGTo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357228AbiFGTl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:41:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41CC15906B;
        Tue,  7 Jun 2022 11:14:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45E416062B;
        Tue,  7 Jun 2022 18:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551E2C385A2;
        Tue,  7 Jun 2022 18:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625697;
        bh=/1LaJeVU6Fz+nhVwdbzpAGAmcRb6UJPPoWBB3XrQNrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9Fvt+P4v0OYguRPdAo1qnlFlEnSrSLzKBIr61mOQCNDnrD6FnEQfjN4s5y3lGCjn
         rNVjsoZ+yLf6PbY+O6lpG0npDGmvXnjp7H4mAt/14/aoeyGwb0dnz3rSgl+sTkAJVo
         ja671EHnP52cR3Mq0Ac0sdGyzMwHUouy9VszB9mA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, jianghaoran <jianghaoran@kylinos.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 110/772] ipv6: Dont send rs packets to the interface of ARPHRD_TUNNEL
Date:   Tue,  7 Jun 2022 18:55:02 +0200
Message-Id: <20220607164952.290417358@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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
index 0a9e03465001..5ec289e0f2ac 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4221,7 +4221,8 @@ static void addrconf_dad_completed(struct inet6_ifaddr *ifp, bool bump_id,
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



