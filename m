Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C398627EF0
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 13:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbiKNMxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 07:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiKNMxe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 07:53:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADDF2BCB
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 04:53:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BEEC06109A
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 12:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DEDC433C1;
        Mon, 14 Nov 2022 12:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430412;
        bh=+nPvoQzhrZBO9LeCZKH9gIjAg0JhSoFYgsMg4Hg9E3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeHcyisCy8QZktczWFYRkZLvYQok0bWGzfpsNNN/zoWQ65Wg0AeSpEfAKBZD6za0H
         pADJhIamZDm+wRa+sMuLxC7DvqW9S9LzelsOmbS6uxmdSeQSS/oy63GH3U+KRbF7e4
         /zrq9yCLEEdgcI074ctjffIV/B61k0c4WbLdMmTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stanislav Fomichev <sdf@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/131] bpf, sock_map: Move cancel_work_sync() out of sock lock
Date:   Mon, 14 Nov 2022 13:44:49 +0100
Message-Id: <20221114124449.574142755@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

[ Upstream commit 8bbabb3fddcd0f858be69ed5abc9b470a239d6f2 ]

Stanislav reported a lockdep warning, which is caused by the
cancel_work_sync() called inside sock_map_close(), as analyzed
below by Jakub:

psock->work.func = sk_psock_backlog()
  ACQUIRE psock->work_mutex
    sk_psock_handle_skb()
      skb_send_sock()
        __skb_send_sock()
          sendpage_unlocked()
            kernel_sendpage()
              sock->ops->sendpage = inet_sendpage()
                sk->sk_prot->sendpage = tcp_sendpage()
                  ACQUIRE sk->sk_lock
                    tcp_sendpage_locked()
                  RELEASE sk->sk_lock
  RELEASE psock->work_mutex

sock_map_close()
  ACQUIRE sk->sk_lock
  sk_psock_stop()
    sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED)
    cancel_work_sync()
      __cancel_work_timer()
        __flush_work()
          // wait for psock->work to finish
  RELEASE sk->sk_lock

We can move the cancel_work_sync() out of the sock lock protection,
but still before saved_close() was called.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Reported-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Link: https://lore.kernel.org/bpf/20221102043417.279409-1-xiyou.wangcong@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skmsg.h | 2 +-
 net/core/skmsg.c      | 7 ++-----
 net/core/sock_map.c   | 7 ++++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index ee7c67d8442d..ba015a77238a 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -382,7 +382,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
-void sk_psock_stop(struct sk_psock *psock, bool wait);
+void sk_psock_stop(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 680f51f8974a..f562f7e2bdc7 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -797,16 +797,13 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
 	}
 }
 
-void sk_psock_stop(struct sk_psock *psock, bool wait)
+void sk_psock_stop(struct sk_psock *psock)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
 	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
-
-	if (wait)
-		cancel_work_sync(&psock->work);
 }
 
 static void sk_psock_done_strp(struct sk_psock *psock);
@@ -844,7 +841,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 6eef46eafb3e..4f4bc163a223 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1541,7 +1541,7 @@ void sock_map_destroy(struct sock *sk)
 	saved_destroy = psock->saved_destroy;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 	sk_psock_put(sk, psock);
 	saved_destroy(sk);
 }
@@ -1564,9 +1564,10 @@ void sock_map_close(struct sock *sk, long timeout)
 	saved_close = psock->saved_close;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, true);
-	sk_psock_put(sk, psock);
+	sk_psock_stop(psock);
 	release_sock(sk);
+	cancel_work_sync(&psock->work);
+	sk_psock_put(sk, psock);
 	saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
-- 
2.35.1



