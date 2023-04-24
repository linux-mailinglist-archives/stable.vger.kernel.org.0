Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50B76ED002
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 16:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjDXOJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 10:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231785AbjDXOJn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 10:09:43 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC52AD03
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:09:21 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-3f19c473b9eso47087235e9.0
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 07:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1682345360; x=1684937360;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cn96K4ewEfXzrj1A/qyaR4zIjE/JZ3DKSqclOjk5uAE=;
        b=VtQgHiN7zilA5np7cKWfqtMpar5F9pvgfc3JUq8HtYsfGvBkRF7BhMGBovzuFxdGX6
         WrsSH8Wsi95jv8Z5/o+CCfwImjQOdfgkMXwyE/S33GFNYdWNJLRT36wXLJ2Lhl5ZVV1S
         eSya6ZVhPp7MrlePG5L6X9rCJb6TyY6wyVVapCAgBiDKu8B9m2qmmIi9Ey1IWoH/AzfD
         AXwlFHHLOcG3P/eFx6V+WOOKm0SJn0Qd5fiHmWLgl8eSamjBIOAn/8pVurXnF9hhKwOt
         Zrt2fs5hjlT9y2dnKPcP3bu0iezf1O1GfRNjLtwa3Y6WdhH0anlcfjxtpynVgMfJalFM
         VmSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682345360; x=1684937360;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cn96K4ewEfXzrj1A/qyaR4zIjE/JZ3DKSqclOjk5uAE=;
        b=QNndU/pfKlQ/bSS6l8JD/3ABvUeUjO7o/7aYdi9LPfG0d1cO0KGKZdzW8dkdFoS3u4
         m6UHoICvTyPksUnXw5/l99FsG4GjH110QG3mM9OWSfejhRzubo8xCbM7WzHdVtXoovzW
         96c9zu1DS8KVFPR9OkqtYg0ggkW0nZZxf9hJ4ovtY236o1sFBdV8+TGXDWgGbZ1p28+C
         sITwB+NSZvILEaPqp7uAYvHSTMv7xoYLx2BfeStiuGVzModzL/WAtpc1EVfcxuUNyXOy
         2h9ugMqhMdA7pltVYdPkbshq/zT+l6lvgPbH/AXG9kFRprfmTkvIrhlcroq8m4MIR2ur
         dkRg==
X-Gm-Message-State: AAQBX9ccfrkPtXEEMQ71oBRpgd86+cD+2Rb/rUNdYeSdC8uNzzovlvqO
        fqel6Lz+F0mxOdLASiv/y1MNoQ==
X-Google-Smtp-Source: AKy350bo3gCSg2hnIiZ47Dx59Pn8o8QojjeXtWAPWVtcay8Lvny2+jNpNx0ae6Hpy3Es1KqlLCufUA==
X-Received: by 2002:a05:600c:d9:b0:3f1:6ead:e396 with SMTP id u25-20020a05600c00d900b003f16eade396mr7476580wmm.17.1682345359750;
        Mon, 24 Apr 2023 07:09:19 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id m6-20020a05600c4f4600b003ee5fa61f45sm15729235wmq.3.2023.04.24.07.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:09:19 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Mon, 24 Apr 2023 16:09:08 +0200
Subject: [PATCH 6.1 1/2] mptcp: stops worker on unaccepted sockets at
 listener close
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230424-upstream-stable-20230424-conflicts-6-1-v1-1-b054457d3646@tessares.net>
References: <20230424-upstream-stable-20230424-conflicts-6-1-v1-0-b054457d3646@tessares.net>
In-Reply-To: <20230424-upstream-stable-20230424-conflicts-6-1-v1-0-b054457d3646@tessares.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        "David S. Miller" <davem@davemloft.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=8093;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=DtyF8ql1cbSXnRlBL89NKeeIZwkoYE+ZEI6rgiyFfx0=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkRo2NyWY3rpwrSMxd1R8bwW0iYQW433TR53622
 GWlVCQMpRuJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZEaNjQAKCRD2t4JPQmmg
 c1UeEACpitOMY2lbaf+AyMQtuiNb7bAjI9EawrWhBexluRCQcaMZIyLNSXyNObp0gQcZbv3aPp4
 NaaPFwNuyPUgGEqZSG2B1fD/AOT+9kvvNrtKytR4GP2qr9b4tLoJ98Pl7F2HVLKBK1NWSrAK/7k
 ohtoD6bChTW3eLEAi0kZ1T1TtvDN6bJDyG1v/Bpd/DjO/iv2GJwSV3Z+Q09OswR4wFMJkhmc3lF
 Ns406OQ+UoDd3lC7Jcx+4ua/83UfvZyhZo49vbLpfr90pJ5vJMIyYgRaucsW4yc/yGSup/ke1/1
 4G1pazuOVEiUI+1NKz3hK/X9jywAZEQUQhM8azU883NuHapdt2vVHdrQihjgg6OgcQ7btltYDDM
 issG1epsKemBHtqJyrxCifaak28meItA0h25O2f3TMn+nQDQxSzTaY0dYrVeuK7+Pye2l3mlCzN
 DOcdeRSHnHVZEXgqMKG5GJEBoCgrB2yEBE4zZnwG3BXEuc7Kf7oeJTGw1DSQQlc27JPdFoAqDXx
 SKzZdBofzjsSKaNgRT4qcWyMAyIw4YeXGGZvsRtdjsveJLCyoMnlE/a0h31IQwYLxD1K6SbjueM
 7rf5xdYqu3j4QOYKSflfBDLVflI4t/7Auk56Ik+bQGeFHznBtJCcfYKIjG84Kunw9YSudAwotQK
 b9m1CLh2gIfbW7Q==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 2a6a870e44dd88f1a6a2893c65ef756a9edfb4c7 ]

  Backports notes: similar to the conflicts with the partially reverted
  commit 5564be74a22a ("mptcp: fix UaF in listener shutdown"), there was
  one simple conflict in net/mptcp/protocol.c with:

    commit f8c9dfbd875b ("mptcp: add pm listener events")

  We just need to omit one line linked to the PM listener event.

This is a partial revert of the blamed commit, with a relevant
change: mptcp_subflow_queue_clean() now just change the msk
socket status and stop the worker, so that the UaF issue addressed
by the blamed commit is not re-introduced.

The above prevents the mptcp worker from running concurrently with
inet_csk_listen_stop(), as such race would trigger a warning, as
reported by Christoph:

RSP: 002b:00007f784fe09cd8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
WARNING: CPU: 0 PID: 25807 at net/ipv4/inet_connection_sock.c:1387 inet_csk_listen_stop+0x664/0x870 net/ipv4/inet_connection_sock.c:1387
RAX: ffffffffffffffda RBX: 00000000006bc050 RCX: 00007f7850afd6a9
RDX: 0000000000000000 RSI: 0000000020000340 RDI: 0000000000000004
Modules linked in:
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006bc05c
R13: fffffffffffffea8 R14: 00000000006bc050 R15: 000000000001fe40

 </TASK>
CPU: 0 PID: 25807 Comm: syz-executor.7 Not tainted 6.2.0-g778e54711659 #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.11.0-2.el7 04/01/2014
RIP: 0010:inet_csk_listen_stop+0x664/0x870 net/ipv4/inet_connection_sock.c:1387
RAX: 0000000000000000 RBX: ffff888100dfbd40 RCX: 0000000000000000
RDX: ffff8881363aab80 RSI: ffffffff81c494f4 RDI: 0000000000000005
RBP: ffff888126dad080 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: ffff888100dfe040
R13: 0000000000000001 R14: 0000000000000000 R15: ffff888100dfbdd8
FS:  00007f7850a2c800(0000) GS:ffff88813bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b32d26000 CR3: 000000012fdd8006 CR4: 0000000000770ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 __tcp_close+0x5b2/0x620 net/ipv4/tcp.c:2875
 __mptcp_close_ssk+0x145/0x3d0 net/mptcp/protocol.c:2427
 mptcp_destroy_common+0x8a/0x1c0 net/mptcp/protocol.c:3277
 mptcp_destroy+0x41/0x60 net/mptcp/protocol.c:3304
 __mptcp_destroy_sock+0x56/0x140 net/mptcp/protocol.c:2965
 __mptcp_close+0x38f/0x4a0 net/mptcp/protocol.c:3057
 mptcp_close+0x24/0xe0 net/mptcp/protocol.c:3072
 inet_release+0x53/0xa0 net/ipv4/af_inet.c:429
 __sock_release+0x4e/0xf0 net/socket.c:651
 sock_close+0x15/0x20 net/socket.c:1393
 __fput+0xff/0x420 fs/file_table.c:321
 task_work_run+0x8b/0xe0 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x113/0x120 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x40 kernel/entry/common.c:296
 do_syscall_64+0x46/0x90 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x72/0xdc
RIP: 0033:0x7f7850af70dc
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f7850af70dc
RDX: 00007f7850a2c800 RSI: 0000000000000002 RDI: 0000000000000003
RBP: 00000000006bd980 R08: 0000000000000000 R09: 00000000000018a0
R10: 00000000316338a4 R11: 0000000000000293 R12: 0000000000211e31
R13: 00000000006bc05c R14: 00007f785062c000 R15: 0000000000211af0

Fixes: 0a3f4f1f9c27 ("mptcp: fix UaF in listener shutdown")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/371
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c |  6 +++++
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 72 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b1bbb0b75a13..a4d5072c6e98 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2380,6 +2380,12 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
+		if (ssk->sk_state == TCP_LISTEN) {
+			tcp_set_state(ssk, TCP_CLOSE);
+			mptcp_subflow_queue_clean(sk, ssk);
+			inet_csk_listen_stop(ssk);
+		}
+
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 051e8022d661..2cddd5b52e8f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -615,6 +615,7 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 125d1f58d6a4..d9bc4bdb94b7 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1758,6 +1758,78 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
+void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
+{
+	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
+	struct mptcp_sock *msk, *next, *head = NULL;
+	struct request_sock *req;
+
+	/* build a list of all unaccepted mptcp sockets */
+	spin_lock_bh(&queue->rskq_lock);
+	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
+		struct mptcp_subflow_context *subflow;
+		struct sock *ssk = req->sk;
+
+		if (!sk_is_mptcp(ssk))
+			continue;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		if (!subflow || !subflow->conn)
+			continue;
+
+		/* skip if already in list */
+		msk = mptcp_sk(subflow->conn);
+		if (msk->dl_next || msk == head)
+			continue;
+
+		sock_hold(subflow->conn);
+		msk->dl_next = head;
+		head = msk;
+	}
+	spin_unlock_bh(&queue->rskq_lock);
+	if (!head)
+		return;
+
+	/* can't acquire the msk socket lock under the subflow one,
+	 * or will cause ABBA deadlock
+	 */
+	release_sock(listener_ssk);
+
+	for (msk = head; msk; msk = next) {
+		struct sock *sk = (struct sock *)msk;
+
+		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
+		next = msk->dl_next;
+		msk->dl_next = NULL;
+
+		/* prevent the stack from later re-schedule the worker for
+		 * this socket
+		 */
+		inet_sk_state_store(sk, TCP_CLOSE);
+		release_sock(sk);
+
+		/* lockdep will report a false positive ABBA deadlock
+		 * between cancel_work_sync and the listener socket.
+		 * The involved locks belong to different sockets WRT
+		 * the existing AB chain.
+		 * Using a per socket key is problematic as key
+		 * deregistration requires process context and must be
+		 * performed at socket disposal time, in atomic
+		 * context.
+		 * Just tell lockdep to consider the listener socket
+		 * released here.
+		 */
+		mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
+		mptcp_cancel_work(sk);
+		mutex_acquire(&listener_sk->sk_lock.dep_map, 0, 0, _RET_IP_);
+
+		sock_put(sk);
+	}
+
+	/* we are still under the listener msk socket lock */
+	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
+}
+
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);

-- 
2.39.2

