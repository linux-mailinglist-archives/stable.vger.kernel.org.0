Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6904F2DB6
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237649AbiDEIm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241002AbiDEIcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EF09AC92E;
        Tue,  5 Apr 2022 01:25:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26557B81B13;
        Tue,  5 Apr 2022 08:25:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89904C385A1;
        Tue,  5 Apr 2022 08:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147143;
        bh=g0TljGLO1IzFHta7Q9gIR9X96djpoWB7T6QSJAJD6jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQZWKxwpgVeApD7bUBYXQGPZEPecE9E9Z/fVaqJfuxfwFH8o0lQsIEAc3yf0z8h2y
         zpLirG/6lBZxMpzcsMvELuIZWmyygkVcWAgO2+7xyPgAWDO7i7KO9IPuBc+kWaes4z
         kNFh7TMktJu1CJE8UXiuS6yxrWug3riyybvLe3C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 1018/1126] wireguard: socket: ignore v6 endpoints when ipv6 is disabled
Date:   Tue,  5 Apr 2022 09:29:25 +0200
Message-Id: <20220405070437.366893770@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 77fc73ac89be96ec8f39e8efa53885caa7cb3645 upstream.

The previous commit fixed a memory leak on the send path in the event
that IPv6 is disabled at compile time, but how did a packet even arrive
there to begin with? It turns out we have previously allowed IPv6
endpoints even when IPv6 support is disabled at compile time. This is
awkward and inconsistent. Instead, let's just ignore all things IPv6,
the same way we do other malformed endpoints, in the case where IPv6 is
disabled.

Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/socket.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireguard/socket.c
+++ b/drivers/net/wireguard/socket.c
@@ -242,7 +242,7 @@ int wg_socket_endpoint_from_skb(struct e
 		endpoint->addr4.sin_addr.s_addr = ip_hdr(skb)->saddr;
 		endpoint->src4.s_addr = ip_hdr(skb)->daddr;
 		endpoint->src_if4 = skb->skb_iif;
-	} else if (skb->protocol == htons(ETH_P_IPV6)) {
+	} else if (IS_ENABLED(CONFIG_IPV6) && skb->protocol == htons(ETH_P_IPV6)) {
 		endpoint->addr6.sin6_family = AF_INET6;
 		endpoint->addr6.sin6_port = udp_hdr(skb)->source;
 		endpoint->addr6.sin6_addr = ipv6_hdr(skb)->saddr;
@@ -285,7 +285,7 @@ void wg_socket_set_peer_endpoint(struct
 		peer->endpoint.addr4 = endpoint->addr4;
 		peer->endpoint.src4 = endpoint->src4;
 		peer->endpoint.src_if4 = endpoint->src_if4;
-	} else if (endpoint->addr.sa_family == AF_INET6) {
+	} else if (IS_ENABLED(CONFIG_IPV6) && endpoint->addr.sa_family == AF_INET6) {
 		peer->endpoint.addr6 = endpoint->addr6;
 		peer->endpoint.src6 = endpoint->src6;
 	} else {


