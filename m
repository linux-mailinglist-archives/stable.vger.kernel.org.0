Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68545521ADA
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 16:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242329AbiEJOD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243915AbiEJOAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9322DE58A;
        Tue, 10 May 2022 06:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41BD7617E4;
        Tue, 10 May 2022 13:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4311DC385C6;
        Tue, 10 May 2022 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189999;
        bh=X0ixFeNEvURfQKTkFaXnL+ELjrFBVzXxY/dWtVPiXhY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xOe/q7B3Z55x7d9z0HdaOt7suPOx0BE5FIuOvzwgbLk5N8SEAYykXGZplkFqEBzT5
         xDU41GnfUQBi//Ng53TWJUa22YYHAi4q2wCugjjHdBpQqj+hLch/5EvzqLxulM8xLV
         D2G6Y37kWc/Doc96MQLY8Oju+VWYZ4VQvfeSf2l0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-afs@lists.infradead.org
Subject: [PATCH 5.17 097/140] rxrpc: Enable IPv6 checksums on transport socket
Date:   Tue, 10 May 2022 15:08:07 +0200
Message-Id: <20220510130744.380429390@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 39cb9faa5d46d0d0694f4b594ef905f517600c8e upstream.

AF_RXRPC doesn't currently enable IPv6 UDP Tx checksums on the transport
socket it opens and the checksums in the packets it generates end up 0.

It probably should also enable IPv6 UDP Rx checksums and IPv4 UDP
checksums.  The latter only seem to be applied if the socket family is
AF_INET and don't seem to apply if it's AF_INET6.  IPv4 packets from an
IPv6 socket seem to have checksums anyway.

What seems to have happened is that the inet_inv_convert_csum() call didn't
get converted to the appropriate udp_port_cfg parameters - and
udp_sock_create() disables checksums unless explicitly told not too.

Fix this by enabling the three udp_port_cfg checksum options.

Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: Vadim Fedorenko <vfedorenko@novek.ru>
cc: David S. Miller <davem@davemloft.net>
cc: linux-afs@lists.infradead.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/local_object.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -117,6 +117,7 @@ static int rxrpc_open_socket(struct rxrp
 	       local, srx->transport_type, srx->transport.family);
 
 	udp_conf.family = srx->transport.family;
+	udp_conf.use_udp_checksums = true;
 	if (udp_conf.family == AF_INET) {
 		udp_conf.local_ip = srx->transport.sin.sin_addr;
 		udp_conf.local_udp_port = srx->transport.sin.sin_port;
@@ -124,6 +125,8 @@ static int rxrpc_open_socket(struct rxrp
 	} else {
 		udp_conf.local_ip6 = srx->transport.sin6.sin6_addr;
 		udp_conf.local_udp_port = srx->transport.sin6.sin6_port;
+		udp_conf.use_udp6_tx_checksums = true;
+		udp_conf.use_udp6_rx_checksums = true;
 #endif
 	}
 	ret = udp_sock_create(net, &udp_conf, &local->socket);


