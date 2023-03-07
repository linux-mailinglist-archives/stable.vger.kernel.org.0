Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6E6AF37B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbjCGTF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233604AbjCGTFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:05:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EF7B049F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:50:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A655C6150F
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA71DC4339C;
        Tue,  7 Mar 2023 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215042;
        bh=rhVB0k2mXMfXJ+VCnFWu10vOEWQY7e6nx4oE5rsf8x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qdb8iutkw+Hog2Mjm8g6v/lrJbT+FALSfTFdrh+VCMBMD1lJMPg+2kXQ7eiGftO5Y
         9Ck8uYi+u6Kh4PNmCzXqZO2Y4Lvx026NfEvdO6AVseDD9dNJITxQ1XwNbvCmItqrAY
         S1nyY0L4ZYX9eGhByIauAxu3YuZopBP+/eHd/dPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Pietro Borrello <borrello@diag.uniroma1.it>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/567] net: add sock_init_data_uid()
Date:   Tue,  7 Mar 2023 17:57:49 +0100
Message-Id: <20230307165911.658064794@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit 584f3742890e966d2f0a1f3c418c9ead70b2d99e ]

Add sock_init_data_uid() to explicitly initialize the socket uid.
To initialise the socket uid, sock_init_data() assumes a the struct
socket* sock is always embedded in a struct socket_alloc, used to
access the corresponding inode uid. This may not be true.
Examples are sockets created in tun_chr_open() and tap_open().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h |  7 ++++++-
 net/core/sock.c    | 15 ++++++++++++---
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index cd6f2ae28ecf2..3a4e81399edc6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1847,7 +1847,12 @@ void sk_common_release(struct sock *sk);
  *	Default socket callbacks and setup code
  */
 
-/* Initialise core socket variables */
+/* Initialise core socket variables using an explicit uid. */
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid);
+
+/* Initialise core socket variables.
+ * Assumes struct socket *sock is embedded in a struct socket_alloc.
+ */
 void sock_init_data(struct socket *sock, struct sock *sk);
 
 /*
diff --git a/net/core/sock.c b/net/core/sock.c
index b7ac53e72d1ad..ff7e8fc80731d 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3118,7 +3118,7 @@ void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
 }
 EXPORT_SYMBOL(sk_stop_timer_sync);
 
-void sock_init_data(struct socket *sock, struct sock *sk)
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 {
 	sk_init_common(sk);
 	sk->sk_send_head	=	NULL;
@@ -3137,11 +3137,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 		sk->sk_type	=	sock->type;
 		RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
 		sock->sk	=	sk;
-		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
 	} else {
 		RCU_INIT_POINTER(sk->sk_wq, NULL);
-		sk->sk_uid	=	make_kuid(sock_net(sk)->user_ns, 0);
 	}
+	sk->sk_uid	=	uid;
 
 	rwlock_init(&sk->sk_callback_lock);
 	if (sk->sk_kern_sock)
@@ -3199,6 +3198,16 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	refcount_set(&sk->sk_refcnt, 1);
 	atomic_set(&sk->sk_drops, 0);
 }
+EXPORT_SYMBOL(sock_init_data_uid);
+
+void sock_init_data(struct socket *sock, struct sock *sk)
+{
+	kuid_t uid = sock ?
+		SOCK_INODE(sock)->i_uid :
+		make_kuid(sock_net(sk)->user_ns, 0);
+
+	sock_init_data_uid(sock, sk, uid);
+}
 EXPORT_SYMBOL(sock_init_data);
 
 void lock_sock_nested(struct sock *sk, int subclass)
-- 
2.39.2



