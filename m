Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85B054BE2B9
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347518AbiBUJKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:10:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347910AbiBUJJu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:09:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E38F1C937;
        Mon, 21 Feb 2022 01:02:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDAF060FB6;
        Mon, 21 Feb 2022 09:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F19C340E9;
        Mon, 21 Feb 2022 09:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434132;
        bh=DzmpeJoKaV7iILY+sZu/gI4+52iSEawvhB6YbzA78R0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KtZksYF68xcnsitzudtCKmxyBjxIBVjXgPVMANjU3qmfGW5qW+V82jeV21HisLHnb
         01//wF5WGmo4DelkrCqMO//A7eTWloUw+vGQrztMggk2EUB5y4wHBpvbrWAsAv43kU
         vzusR9V8xLtVffq7xr64ouYrnSxHUJoY7rABq5Ps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Norbert Slusarek <nslusarek@gmx.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 006/121] can: isotp: prevent race between isotp_bind() and isotp_setsockopt()
Date:   Mon, 21 Feb 2022 09:48:18 +0100
Message-Id: <20220221084921.366910498@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084921.147454846@linuxfoundation.org>
References: <20220221084921.147454846@linuxfoundation.org>
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

From: Norbert Slusarek <nslusarek@gmx.net>

commit 2b17c400aeb44daf041627722581ade527bb3c1d upstream.

A race condition was found in isotp_setsockopt() which allows to
change socket options after the socket was bound.
For the specific case of SF_BROADCAST support, this might lead to possible
use-after-free because can_rx_unregister() is not called.

Checking for the flag under the socket lock in isotp_bind() and taking
the lock in isotp_setsockopt() fixes the issue.

Fixes: 921ca574cd38 ("can: isotp: add SF_BROADCAST support for functional addressing")
Link: https://lore.kernel.org/r/trinity-e6ae9efa-9afb-4326-84c0-f3609b9b8168-1620773528307@3c-app-gmx-bs06
Reported-by: Norbert Slusarek <nslusarek@gmx.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1193,16 +1193,13 @@ static int isotp_getname(struct socket *
 	return ISOTP_MIN_NAMELEN;
 }
 
-static int isotp_setsockopt(struct socket *sock, int level, int optname,
+static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 			    sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
 	int ret = 0;
 
-	if (level != SOL_CAN_ISOTP)
-		return -EINVAL;
-
 	if (so->bound)
 		return -EISCONN;
 
@@ -1277,6 +1274,22 @@ static int isotp_setsockopt(struct socke
 	return ret;
 }
 
+static int isotp_setsockopt(struct socket *sock, int level, int optname,
+			    sockptr_t optval, unsigned int optlen)
+
+{
+	struct sock *sk = sock->sk;
+	int ret;
+
+	if (level != SOL_CAN_ISOTP)
+		return -EINVAL;
+
+	lock_sock(sk);
+	ret = isotp_setsockopt_locked(sock, level, optname, optval, optlen);
+	release_sock(sk);
+	return ret;
+}
+
 static int isotp_getsockopt(struct socket *sock, int level, int optname,
 			    char __user *optval, int __user *optlen)
 {


