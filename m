Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3993C6B44B9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbjCJO1m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:27:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbjCJO1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:27:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8008E118BEB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:25:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18BFBB8228E
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686D4C4339B;
        Fri, 10 Mar 2023 14:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458348;
        bh=5RSMj58IJT/ItdlmwTj8qQopCWBus/DFq6NzYPpRenE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2IVSmQB++9Q048QWTiKHXagGCAhBOlIUz0eB110RQPKO8CJx4SNerQzRwnOPP+1p
         aZnuPeHEOHke93LF9/RmLY7EizUdfVDRmw48sL/hEKGHasFg536JqOyXbw1JpDvK7N
         TJp8CeYog74EVu4QLM0v9pDlb2DuwUlPjXqga/3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Winter <winter@winter.cafe>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 4.19 248/252] tcp: Fix listen() regression in 4.19.270
Date:   Fri, 10 Mar 2023 14:40:18 +0100
Message-Id: <20230310133727.106729258@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit fdaf88531cfd17b2a710cceb3141ef6f9085ff40 upstream.

When we backport dadd0dcaa67d ("net/ulp: prevent ULP without clone op from
entering the LISTEN status"), we have accidentally backported a part of
7a7160edf1bf ("net: Return errno in sk->sk_prot->get_port().") and removed
err = -EADDRINUSE in inet_csk_listen_start().

Thus, listen() no longer returns -EADDRINUSE even if ->get_port() failed
as reported in [0].

We set -EADDRINUSE to err just before ->get_port() to fix the regression.

[0]: https://lore.kernel.org/stable/EF8A45D0-768A-4CD5-9A8A-0FA6E610ABF7@winter.cafe/

Reported-by: Winter <winter@winter.cafe>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_connection_sock.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -934,6 +934,7 @@ int inet_csk_listen_start(struct sock *s
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	inet_sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);


