Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19363627FD0
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbiKNNCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237769AbiKNNBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:01:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3159E29C9D
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7DB4B80EC1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15247C433C1;
        Mon, 14 Nov 2022 13:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430906;
        bh=ywUqRfja3BsmiipVRY0LH7HupLgSa8FaDtq3sp9um1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AmZ+GQF3/gSq8pKoxy0TdnhyVAm8rVV3IVZealHd1pbNvRHpHM8izTbzlslA1cAUt
         nzPEQIDxBvBlMrtl8o2fj3gDUrGDp45VZPVNW2F1pWCFOiMaZHsDSkjcxHxOXBNa80
         WXawfa9paFUzGeGCCWBXxGbaECevYu/MxrTA+TOA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stanislav Fomichev <sdf@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 030/190] bpf, sock_map: Move cancel_work_sync() out of sock lock
Date:   Mon, 14 Nov 2022 13:44:14 +0100
Message-Id: <20221114124500.066476099@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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
index 48f4b645193b..70d6cb94e580 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -376,7 +376,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node);
-void sk_psock_stop(struct sk_psock *psock, bool wait);
+void sk_psock_stop(struct sk_psock *psock);
 
 #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
 int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1efdc47a999b..e6b9ced3eda8 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -803,16 +803,13 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
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
@@ -850,7 +847,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock *psock)
 		sk_psock_stop_verdict(sk, psock);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 
 	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
 	queue_rcu_work(system_wq, &psock->rwork);
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 9a9fb9487d63..632df0c52562 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1596,7 +1596,7 @@ void sock_map_destroy(struct sock *sk)
 	saved_destroy = psock->saved_destroy;
 	sock_map_remove_links(sk, psock);
 	rcu_read_unlock();
-	sk_psock_stop(psock, false);
+	sk_psock_stop(psock);
 	sk_psock_put(sk, psock);
 	saved_destroy(sk);
 }
@@ -1619,9 +1619,10 @@ void sock_map_close(struct sock *sk, long timeout)
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



