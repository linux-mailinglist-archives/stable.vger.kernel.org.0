Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E924F68118D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbjA3OOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237267AbjA3OO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:14:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5734B1BAEC
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:14:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD5AB6102E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED1CC433D2;
        Mon, 30 Jan 2023 14:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088066;
        bh=ffzel8X/qV7MnDhW26+rmNDsh9ooM5L26oNnOs9qV/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xNONLbgDfPoGsADhm0x8/UcNnOzVzOUl2Ee91X0H0+7y43NcRI6IWnlYEeV7URsly
         dl1eVWpx556EuwQJqUfxrMYVapE4ul8aCGEn0q/GG2K0Z559/Qa6W7/r1bJ7N5vw1o
         1yKV53FkXxT+oySNELq8jvQIOMvl0HPMbfioceQ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/204] l2tp: prevent lockdep issue in l2tp_tunnel_register()
Date:   Mon, 30 Jan 2023 14:50:38 +0100
Message-Id: <20230130134319.545869747@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b9fb10d131b8c84af9bb14e2078d5c63600c7dea ]

lockdep complains with the following lock/unlock sequence:

     lock_sock(sk);
     write_lock_bh(&sk->sk_callback_lock);
[1]  release_sock(sk);
[2]  write_unlock_bh(&sk->sk_callback_lock);

We need to swap [1] and [2] to fix this issue.

Fixes: 0b2c59720e65 ("l2tp: close all race conditions in l2tp_tunnel_register()")
Reported-by: syzbot+bbd35b345c7cab0d9a08@syzkaller.appspotmail.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/netdev/20230114030137.672706-1-xiyou.wangcong@gmail.com/T/#m1164ff20628671b0f326a24cb106ab3239c70ce3
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 4c5227048be4..a2b13e213e06 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1485,10 +1485,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	lock_sock(sk);
 	write_lock_bh(&sk->sk_callback_lock);
 	ret = l2tp_validate_socket(sk, net, tunnel->encap);
-	if (ret < 0) {
-		release_sock(sk);
+	if (ret < 0)
 		goto err_inval_sock;
-	}
 	rcu_assign_sk_user_data(sk, tunnel);
 	write_unlock_bh(&sk->sk_callback_lock);
 
@@ -1525,6 +1523,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 err_inval_sock:
 	write_unlock_bh(&sk->sk_callback_lock);
+	release_sock(sk);
 
 	if (tunnel->fd < 0)
 		sock_release(sock);
-- 
2.39.0



