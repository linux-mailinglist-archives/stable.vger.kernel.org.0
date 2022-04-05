Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A19D4F3AB0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381630AbiDELql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354188AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253865131F;
        Tue,  5 Apr 2022 02:58:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C91616D7;
        Tue,  5 Apr 2022 09:58:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38A8C385A2;
        Tue,  5 Apr 2022 09:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152691;
        bh=g0TljGLO1IzFHta7Q9gIR9X96djpoWB7T6QSJAJD6jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TMOZf39o2TfTy1/x1WGDWlZkVM3u+8I0QHdPLpUtROXtGA14GYWDupw7UT/MUFZRV
         p6q5BsKuYu9+MFfzTy1NjfclfrEuYnuAeukCIW8h3KcYCYRDFNzAyPZTbXnrFYwOZ0
         NWZ0FEl7Lcuv2NKPTP4+6oKH1HbpWd8SHoWNWiNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 830/913] wireguard: socket: ignore v6 endpoints when ipv6 is disabled
Date:   Tue,  5 Apr 2022 09:31:32 +0200
Message-Id: <20220405070404.709931823@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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


