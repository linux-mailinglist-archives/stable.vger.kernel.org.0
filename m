Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3604CD7A5
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 20:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbfJFRco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbfJFRcn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:32:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9D6221479;
        Sun,  6 Oct 2019 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570383162;
        bh=AQXNI7teH9zY0Nt9DoZxtSd3C3DNrzzuqdtfyzz2xB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IQ1G4bbIy0w9pybsGVjT4oh5YHFH+WbaiLaSnmgWAsfH1OrKgcJFxiS0b+sbthtVX
         G+QaXDErUhVSyonlEwdvaXP3XdEuL4UshmkqZAfLA6+w7jA/2CrDcp12kTcPY3N1/x
         3yJjGm5+o93tM6mXCLOUoMTty0SdNiyiVd0x0LOw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 087/106] net: Unpublish sk from sk_reuseport_cb before call_rcu
Date:   Sun,  6 Oct 2019 19:21:33 +0200
Message-Id: <20191006171159.147815837@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171124.641144086@linuxfoundation.org>
References: <20191006171124.641144086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit 8c7138b33e5c690c308b2a7085f6313fdcb3f616 ]

The "reuse->sock[]" array is shared by multiple sockets.  The going away
sk must unpublish itself from "reuse->sock[]" before making call_rcu()
call.  However, this unpublish-action is currently done after a grace
period and it may cause use-after-free.

The fix is to move reuseport_detach_sock() to sk_destruct().
Due to the above reason, any socket with sk_reuseport_cb has
to go through the rcu grace period before freeing it.

It is a rather old bug (~3 yrs).  The Fixes tag is not necessary
the right commit but it is the one that introduced the SOCK_RCU_FREE
logic and this fix is depending on it.

Fixes: a4298e4522d6 ("net: add SOCK_RCU_FREE socket flag")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1563,8 +1563,6 @@ static void __sk_destruct(struct rcu_hea
 		sk_filter_uncharge(sk, filter);
 		RCU_INIT_POINTER(sk->sk_filter, NULL);
 	}
-	if (rcu_access_pointer(sk->sk_reuseport_cb))
-		reuseport_detach_sock(sk);
 
 	sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
 
@@ -1587,7 +1585,14 @@ static void __sk_destruct(struct rcu_hea
 
 void sk_destruct(struct sock *sk)
 {
-	if (sock_flag(sk, SOCK_RCU_FREE))
+	bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
+
+	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
+		reuseport_detach_sock(sk);
+		use_call_rcu = true;
+	}
+
+	if (use_call_rcu)
 		call_rcu(&sk->sk_rcu, __sk_destruct);
 	else
 		__sk_destruct(&sk->sk_rcu);


