Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 258874F4317
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 23:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383289AbiDEMZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345071AbiDEKki (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:40:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5416E2DAA9;
        Tue,  5 Apr 2022 03:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E9461425;
        Tue,  5 Apr 2022 10:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C20C385A0;
        Tue,  5 Apr 2022 10:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649154347;
        bh=g0TljGLO1IzFHta7Q9gIR9X96djpoWB7T6QSJAJD6jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alwI5WbJ7QDqBGpuLSvRbcViYqBgLaBPbf6dvr8sIkwJdAiUqxpgrAAHX8sOaBaOa
         aWERUPWvA0hdJ4AJOVJgppypa1H1nOiJSRx+cOSOLPkbc7M/uzdtRSlU8pmk803ykx
         lEaILzePDSVw/Mcu4RJKyAh7LZ9mpfuMJAfgf0vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 547/599] wireguard: socket: ignore v6 endpoints when ipv6 is disabled
Date:   Tue,  5 Apr 2022 09:34:01 +0200
Message-Id: <20220405070315.119252507@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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


