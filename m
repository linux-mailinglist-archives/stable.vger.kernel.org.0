Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB616B4693
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbjCJOoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbjCJOn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:43:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1F83CE03
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5490A618B8
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539BDC4339E;
        Fri, 10 Mar 2023 14:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459434;
        bh=/uLh5JCPaFJEiMu2CegRwFYRyq97e2nzRST4xRDA6ig=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CsUlfx9RL5P/0fQkR2mJj8iOYBAAAENG8pLePQI5Q7lvyGqic3jFGrkaKO5tmpXYI
         1WDyQsBi/G1zZIDRlfGPRgyoCNpz+2ttfDIpb0BfwGrUTq+5rPx8Dqppwg23tbehRn
         lMyqrWirvPLGDzQWkGb8yKXhjRjeuoEJUUVpzrlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Winter <winter@winter.cafe>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.4 353/357] tcp: Fix listen() regression in 5.4.229.
Date:   Fri, 10 Mar 2023 14:40:42 +0100
Message-Id: <20230310133750.241708234@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
@@ -932,6 +932,7 @@ int inet_csk_listen_start(struct sock *s
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	inet_sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);


