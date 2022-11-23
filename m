Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8CCF63593F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiKWKIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237040AbiKWKHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:07:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBD4271B
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E249B81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2397C433D6;
        Wed, 23 Nov 2022 09:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197458;
        bh=rxD+kNMxCUOMAYgE0xEan8kZoKIajeVAmFMKv1OXqlo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QdxvnedWArkObKkwTF6QB2Bm6ev8cYfqqISOMbDei+ufFRQpQhcBUplfEFGbqiNN+
         sG1ZwZ7Q3sRR7iycikRJ7JW804NmelUDZDNpvv6HUZ9cTkc2vFkfJBpx0LzRJxTT4g
         dLD2x2valxbX5QMAcLSQR68TbHO+ofqdCH1jZ+cI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.0 298/314] macvlan: enforce a consistent minimal mtu
Date:   Wed, 23 Nov 2022 09:52:23 +0100
Message-Id: <20221123084639.046672896@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit b64085b00044bdf3cd1c9825e9ef5b2e0feae91a upstream.

macvlan should enforce a minimal mtu of 68, even at link creation.

This patch avoids the current behavior (which could lead to crashes
in ipv6 stack if the link is brought up)

$ ip link add macvlan1 link eno1 mtu 8 type macvlan  # This should fail !
$ ip link sh dev macvlan1
5: macvlan1@eno1: <BROADCAST,MULTICAST> mtu 8 qdisc noop
    state DOWN mode DEFAULT group default qlen 1000
    link/ether 02:47:6c:24:74:82 brd ff:ff:ff:ff:ff:ff
$ ip link set macvlan1 mtu 67
Error: mtu less than device minimum.
$ ip link set macvlan1 mtu 68
$ ip link set macvlan1 mtu 8
Error: mtu less than device minimum.

Fixes: 91572088e3fd ("net: use core MTU range checking in core net infra")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1192,7 +1192,7 @@ void macvlan_common_setup(struct net_dev
 {
 	ether_setup(dev);
 
-	dev->min_mtu		= 0;
+	/* ether_setup() has set dev->min_mtu to ETH_MIN_MTU. */
 	dev->max_mtu		= ETH_MAX_MTU;
 	dev->priv_flags	       &= ~IFF_TX_SKB_SHARING;
 	netif_keep_dst(dev);


