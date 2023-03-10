Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5346B4A24
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbjCJPT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbjCJPSp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:18:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7392312E171
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:09:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54E576187C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:09:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D4BC433EF;
        Fri, 10 Mar 2023 15:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460988;
        bh=qwgSiQi+P2JY9PnHNYVZtOzSuxZMAtqCMIQ8HVYiqYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+LV0c9rwEBFoPRvWWRH79Mwrbf+tO5Sp3AUY90VRrO6lDazd+f3oTAlxVS/0EWLX
         Urv5SUAc6Cl1/R94Cc//psuMh824bSPzaWjygw+gl138H7xDRRgtjvvLOyrUdKmoy2
         kEaxZ+7nT1qwlpOdkz+Ob6RTe4Hny2rVi5ZJSrG8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Winter <winter@winter.cafe>,
        Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.10 519/529] tcp: Fix listen() regression in 5.10.163
Date:   Fri, 10 Mar 2023 14:41:02 +0100
Message-Id: <20230310133828.873199694@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -946,6 +946,7 @@ int inet_csk_listen_start(struct sock *s
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	inet_sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);


