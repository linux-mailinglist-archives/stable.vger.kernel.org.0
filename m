Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63549CD48F
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 19:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbfJFR1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 13:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbfJFR1H (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Oct 2019 13:27:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE22D2077B;
        Sun,  6 Oct 2019 17:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570382827;
        bh=UFY23L5eLiCo+2aJP3vZWsf8JbVPN0hHJcoBfya3n9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dl9XgafFch6X0W+2NIcIMujWPhvQVCcnAYP5uQQFZCWB1pbEujgTdSn2s5yRYTbzi
         kMWctCJxz2kMmtE+1hTlnkxLXR9fkJi/TPwI87SleEKFVkNqAzsQSzqy9CzM2fzGuJ
         ba2EE4a7+z3xww+PhJgu+pKGgNI51FCbHp3ifc+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 55/68] net: Unpublish sk from sk_reuseport_cb before call_rcu
Date:   Sun,  6 Oct 2019 19:21:31 +0200
Message-Id: <20191006171133.399020893@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191006171108.150129403@linuxfoundation.org>
References: <20191006171108.150129403@linuxfoundation.org>
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
@@ -1561,8 +1561,6 @@ static void __sk_destruct(struct rcu_hea
 		sk_filter_uncharge(sk, filter);
 		RCU_INIT_POINTER(sk->sk_filter, NULL);
 	}
-	if (rcu_access_pointer(sk->sk_reuseport_cb))
-		reuseport_detach_sock(sk);
 
 	sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
 
@@ -1585,7 +1583,14 @@ static void __sk_destruct(struct rcu_hea
 
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


