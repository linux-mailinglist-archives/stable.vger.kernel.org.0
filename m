Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0D3615918
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKBDEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiKBDE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:04:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 340C822286
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:04:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84D64B82062
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:04:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D306C433C1;
        Wed,  2 Nov 2022 03:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667358262;
        bh=iPTNaIOKOeogkoDNPgGoG5HMfFdyf9khzwDrNKMR8Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KF9nSbH7eblYXvrVARY+mUa35+rD0M/T/FCa1/ov9iMTPtvBJWvfLzGzAk78mcg50
         Csr/bJE+LRbwWudvZADM5+NwoQ5QdsxO5eb3h3QisG3LYKnYJR0DP9FnR/VAeDhjAZ
         7sB/kcJqfnNdDON5E/zvBj9jKLRdufrlrz7zE6wA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/132] tipc: fix a null-ptr-deref in tipc_topsrv_accept
Date:   Wed,  2 Nov 2022 03:32:54 +0100
Message-Id: <20221102022101.390130052@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 82cb4e4612c633a9ce320e1773114875604a3cce ]

syzbot found a crash in tipc_topsrv_accept:

  KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
  Workqueue: tipc_rcv tipc_topsrv_accept
  RIP: 0010:kernel_accept+0x22d/0x350 net/socket.c:3487
  Call Trace:
   <TASK>
   tipc_topsrv_accept+0x197/0x280 net/tipc/topsrv.c:460
   process_one_work+0x991/0x1610 kernel/workqueue.c:2289
   worker_thread+0x665/0x1080 kernel/workqueue.c:2436
   kthread+0x2e4/0x3a0 kernel/kthread.c:376
   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306

It was caused by srv->listener that might be set to null by
tipc_topsrv_stop() in net .exit whereas it's still used in
tipc_topsrv_accept() worker.

srv->listener is protected by srv->idr_lock in tipc_topsrv_stop(), so add
a check for srv->listener under srv->idr_lock in tipc_topsrv_accept() to
avoid the null-ptr-deref. To ensure the lsock is not released during the
tipc_topsrv_accept(), move sock_release() after tipc_topsrv_work_stop()
where it's waiting until the tipc_topsrv_accept worker to be done.

Note that sk_callback_lock is used to protect sk->sk_user_data instead of
srv->listener, and it should check srv in tipc_topsrv_listener_data_ready()
instead. This also ensures that no more tipc_topsrv_accept worker will be
started after tipc_conn_close() is called in tipc_topsrv_stop() where it
sets sk->sk_user_data to null.

Fixes: 0ef897be12b8 ("tipc: separate topology server listener socket from subcsriber sockets")
Reported-by: syzbot+c5ce866a8d30f4be0651@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Link: https://lore.kernel.org/r/4eee264380c409c61c6451af1059b7fb271a7e7b.1666120790.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 14fd05fd6107..d92ec92f0b71 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -450,12 +450,19 @@ static void tipc_conn_data_ready(struct sock *sk)
 static void tipc_topsrv_accept(struct work_struct *work)
 {
 	struct tipc_topsrv *srv = container_of(work, struct tipc_topsrv, awork);
-	struct socket *lsock = srv->listener;
-	struct socket *newsock;
+	struct socket *newsock, *lsock;
 	struct tipc_conn *con;
 	struct sock *newsk;
 	int ret;
 
+	spin_lock_bh(&srv->idr_lock);
+	if (!srv->listener) {
+		spin_unlock_bh(&srv->idr_lock);
+		return;
+	}
+	lsock = srv->listener;
+	spin_unlock_bh(&srv->idr_lock);
+
 	while (1) {
 		ret = kernel_accept(lsock, &newsock, O_NONBLOCK);
 		if (ret < 0)
@@ -489,7 +496,7 @@ static void tipc_topsrv_listener_data_ready(struct sock *sk)
 
 	read_lock_bh(&sk->sk_callback_lock);
 	srv = sk->sk_user_data;
-	if (srv->listener)
+	if (srv)
 		queue_work(srv->rcv_wq, &srv->awork);
 	read_unlock_bh(&sk->sk_callback_lock);
 }
@@ -699,8 +706,9 @@ static void tipc_topsrv_stop(struct net *net)
 	__module_get(lsock->sk->sk_prot_creator->owner);
 	srv->listener = NULL;
 	spin_unlock_bh(&srv->idr_lock);
-	sock_release(lsock);
+
 	tipc_topsrv_work_stop(srv);
+	sock_release(lsock);
 	idr_destroy(&srv->conn_idr);
 	kfree(srv);
 }
-- 
2.35.1



