Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379D759D952
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236644AbiHWJmn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352581AbiHWJlf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:41:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5137B7A77C;
        Tue, 23 Aug 2022 01:42:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE7FC61257;
        Tue, 23 Aug 2022 08:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF50C433B5;
        Tue, 23 Aug 2022 08:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244143;
        bh=CmsG51oJ8EzkSt1t67kltCCBkqFOsG2kjKAsW1x6eOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sKts0qEuJLGyv7UIJL5tsTlQwpL5ZphB1hRqPF/a1pJb3W+T85iC63jyFUrrc9F7x
         GeNgB+/kyq3YYJpMaCCW4BZmUjqc19oi/idVOaEVqwxDYsfa0xIK3NKVD4oXiwFXeO
         r4SVtxKJo4FWfA4DPvJ+388DNaJvGmBFnG4lsucE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernard Pidoux <f6bvp@free.fr>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 092/229] net: rose: fix netdev reference changes
Date:   Tue, 23 Aug 2022 10:24:13 +0200
Message-Id: <20220823080057.006498481@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 931027820e4dafabc78aff82af59f8c1c4bd3128 ]

Bernard reported that trying to unload rose module would lead
to infamous messages:

unregistered_netdevice: waiting for rose0 to become free. Usage count = xx

This patch solves the issue, by making sure each socket referring to
a netdevice holds a reference count on it, and properly releases it
in rose_release().

rose_dev_first() is also fixed to take a device reference
before leaving the rcu_read_locked section.

Following patch will add ref_tracker annotations to ease
future bug hunting.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Bernard Pidoux <f6bvp@free.fr>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Bernard Pidoux <f6bvp@free.fr>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c    | 11 +++++++++--
 net/rose/rose_route.c |  2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 6a5c4992cf61..b53468edf35a 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -194,6 +194,7 @@ static void rose_kill_by_device(struct net_device *dev)
 			rose_disconnect(s, ENETUNREACH, ROSE_OUT_OF_ORDER, 0);
 			if (rose->neighbour)
 				rose->neighbour->use--;
+			dev_put(rose->device);
 			rose->device = NULL;
 		}
 	}
@@ -594,6 +595,8 @@ static struct sock *rose_make_new(struct sock *osk)
 	rose->idle	= orose->idle;
 	rose->defer	= orose->defer;
 	rose->device	= orose->device;
+	if (rose->device)
+		dev_hold(rose->device);
 	rose->qbitincl	= orose->qbitincl;
 
 	return sk;
@@ -647,6 +650,7 @@ static int rose_release(struct socket *sock)
 		break;
 	}
 
+	dev_put(rose->device);
 	sock->sk = NULL;
 	release_sock(sk);
 	sock_put(sk);
@@ -721,7 +725,6 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	struct rose_sock *rose = rose_sk(sk);
 	struct sockaddr_rose *addr = (struct sockaddr_rose *)uaddr;
 	unsigned char cause, diagnostic;
-	struct net_device *dev;
 	ax25_uid_assoc *user;
 	int n, err = 0;
 
@@ -778,9 +781,12 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	}
 
 	if (sock_flag(sk, SOCK_ZAPPED)) {	/* Must bind first - autobinding in this may or may not work */
+		struct net_device *dev;
+
 		sock_reset_flag(sk, SOCK_ZAPPED);
 
-		if ((dev = rose_dev_first()) == NULL) {
+		dev = rose_dev_first();
+		if (!dev) {
 			err = -ENETUNREACH;
 			goto out_release;
 		}
@@ -788,6 +794,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 		user = ax25_findbyuid(current_euid());
 		if (!user) {
 			err = -EINVAL;
+			dev_put(dev);
 			goto out_release;
 		}
 
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 1027f52a45ab..25c6d1fa22f3 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -614,6 +614,8 @@ struct net_device *rose_dev_first(void)
 			if (first == NULL || strncmp(dev->name, first->name, 3) < 0)
 				first = dev;
 	}
+	if (first)
+		dev_hold(first);
 	rcu_read_unlock();
 
 	return first;
-- 
2.35.1



