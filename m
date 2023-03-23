Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89BD86C6FA9
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 18:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjCWRtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 13:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjCWRtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 13:49:15 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113FC31BCE
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:49:13 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id r29so21470013wra.13
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 10:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1679593751;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fiuLdZpjuG0HQD+1vefGYXnEvP4jmAqSFBj5lWODCIg=;
        b=H0ZUqj6NVHgEnT162OT1jRFD+CCI/VkTbHJ+wrUpK4b/xRQ+jG9S8iUB+eEnxWeLna
         MfN7Y2f7If7QbEvT0K6b0ZWcTPUADU08/rSlvaTY0WdvrT+OyZxj8q2cx4H19dT1fzLV
         +DV/G0xb1BimjRqzE/9QqPnMZW4RrwtMX6Du3bfJVJDvm52YCIRe6DgmhuP0easud82s
         siSnddw15mbGypoZcTksSRGZjdz3Ml1YvJFJ2GmVMIqN/U4ma+mMGREmiajg/VPABTFd
         +Fk/fpMkTPV1ZZP9o7J3UrKcSKeu0S1pQAIKEM/5m1jdPPWbIXoT6oQevXe5GNcTjQ9V
         foog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679593751;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fiuLdZpjuG0HQD+1vefGYXnEvP4jmAqSFBj5lWODCIg=;
        b=1271btm9M7KPvh/q8M0wUv04IwCwatibn/NpIfUBZBHOXFunJRFqkeHbI694XALw9D
         0botPkti4gKG6Syno5O5q5AJRitVVp3p3aw09LsRFWdKBbeDwqxBoYHilhiiXPg2CM70
         /DDbKqNmun+mrfMpQ/zx7hwBV4nnu7UF/t/B+fOCceX6kuPZThlDHCHBYRA1US5SQYmC
         IdGVsAG/2KhM1JTh0VwY6mo8dLTfvQB/jsAp6t0OLmGrf5Oy2cGvSgBiMQOeFqknHCS9
         fAR4YmaJQbKifZBzZm5M5evcLPtr9pxyZRQVvLW46tSj3yH2A035Qg0G8ErT+WZ6iTBz
         vnSA==
X-Gm-Message-State: AAQBX9fguZcVpk9NvWMp3KoYl/PtRZ+2gb6UHxCiai1zzdR78psb8Pq8
        aVGhSPx2bcKaqLe0p6CVzNvjXUzOCeDAOqR1PP/19l43
X-Google-Smtp-Source: AKy350bpPRyM5VRTz5Po1/Xsv2QtKdZIROaL1tIJw9PiRzW/nNodA22AbTWNNviT5eyo7ovBwGIuPg==
X-Received: by 2002:adf:e2c6:0:b0:2ce:a1a6:d721 with SMTP id d6-20020adfe2c6000000b002cea1a6d721mr570wrj.67.1679593751346;
        Thu, 23 Mar 2023 10:49:11 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id a10-20020a056000050a00b002d78a96cf5fsm9534483wrf.70.2023.03.23.10.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 10:49:11 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 23 Mar 2023 18:49:02 +0100
Subject: [PATCH 6.1 2/2] mptcp: fix UaF in listener shutdown
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230323-upstream-stable-conflicts-6-1-v1-2-ef2a6180eaf3@tessares.net>
References: <20230323-upstream-stable-conflicts-6-1-v1-0-ef2a6180eaf3@tessares.net>
In-Reply-To: <20230323-upstream-stable-conflicts-6-1-v1-0-ef2a6180eaf3@tessares.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, stable@vger.kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Christoph Paasch <cpaasch@apple.com>,
        Jakub Kicinski <kuba@kernel.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=6728;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=sJn0BTts+nPdaj6HqOpzebHLPJkm+ftIKBAPaxdik7o=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkHJEUU21YODHKRh6jb82xS4noV1+aJOB+rF+lb
 lD6+ZRaRxqJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZByRFAAKCRD2t4JPQmmg
 c4rWD/0Wz0el7MnGkz69XralvYkDEyAgnGsOaNhUhaveL19IGONwenJnq01Z62cUtRjNVPWT4gG
 wGlYWhI9JIyTPeqRBak5fSNkRk4NMaXDQyC5pkX6FG/cVdL0xSmmm8+uN6UNdhsjFUQbGc5Hfe+
 iHDG3CzwaDpXh/5VaZeh1US0EY0jJvEpKZBbI+HC6DDfShvPYz286KoQmpZARIKZy3NJpB5es+f
 XdegFbxxPh/L99KxvB/nQy0n6UzKZ0ugtHLziudjfCP5wJgDpetbqHBXo1diYoFxnTNHSBPlWnc
 yWdh9pLb0eODM/rT4OunQ6kQqyZsyrreZWlsNWFfHiISthX0xfB/IyKCaLgJj3gkttr9m7+B0T8
 jHroU0qWh5Z/RGIpdXmTgnGdnbHOzeOcuurHPHrhsY0CqX5wLdPmE1VZqKP+7v/fRb/ijVgPRqr
 nk1EQZZhh/fUOX0zlus36LqVXL+DjM4eHylskXd3OpoCAwIeW5HkVsPDg00CFgm4ACoXK9ZSlOT
 WooK5N57wXI7PFPDrO/d3YcgV7i9xSCt9FINh7iZ2YBXbU2IDYVdSJKtTqy2vQmTYr/nidfPJ3H
 0drv8dPtaLW/8tAJj26OcjNxSEChkBnbmHuQvR20J2jK5KQx4p3jXO3ghx+EYxBX6YMVGxPbJGT
 pQB2VhkQo33KJ+Q==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 0a3f4f1f9c27215e4ddcd312558342e57b93e518 ]

  Backports notes: one simple conflict in net/mptcp/protocol.c with:

    commit f8c9dfbd875b ("mptcp: add pm listener events")

  Where one commit removes code in __mptcp_close_ssk() while the other
  one adds one line at the same place. We can simply remove the whole
  condition because this extra instruction is not present in v6.1.

As reported by Christoph after having refactored the passive
socket initialization, the mptcp listener shutdown path is prone
to an UaF issue.

  BUG: KASAN: use-after-free in _raw_spin_lock_bh+0x73/0xe0
  Write of size 4 at addr ffff88810cb23098 by task syz-executor731/1266

  CPU: 1 PID: 1266 Comm: syz-executor731 Not tainted 6.2.0-rc59af4eaa31c1f6c00c8f1e448ed99a45c66340dd5 #6
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x6e/0x91
   print_report+0x16a/0x46f
   kasan_report+0xad/0x130
   kasan_check_range+0x14a/0x1a0
   _raw_spin_lock_bh+0x73/0xe0
   subflow_error_report+0x6d/0x110
   sk_error_report+0x3b/0x190
   tcp_disconnect+0x138c/0x1aa0
   inet_child_forget+0x6f/0x2e0
   inet_csk_listen_stop+0x209/0x1060
   __mptcp_close_ssk+0x52d/0x610
   mptcp_destroy_common+0x165/0x640
   mptcp_destroy+0x13/0x80
   __mptcp_destroy_sock+0xe7/0x270
   __mptcp_close+0x70e/0x9b0
   mptcp_close+0x2b/0x150
   inet_release+0xe9/0x1f0
   __sock_release+0xd2/0x280
   sock_close+0x15/0x20
   __fput+0x252/0xa20
   task_work_run+0x169/0x250
   exit_to_user_mode_prepare+0x113/0x120
   syscall_exit_to_user_mode+0x1d/0x40
   do_syscall_64+0x48/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

The msk grace period can legitly expire in between the last
reference count dropped in mptcp_subflow_queue_clean() and
the later eventual access in inet_csk_listen_stop()

After the previous patch we don't need anymore special-casing
msk listener socket cleanup: the mptcp worker will process each
of the unaccepted msk sockets.

Just drop the now unnecessary code.

Please note this commit depends on the two parent ones:

  mptcp: refactor passive socket initialization
  mptcp: use the workqueue to destroy unaccepted sockets

Fixes: 6aeed9045071 ("mptcp: fix race on unaccepted mptcp sockets")
Cc: stable@vger.kernel.org
Reported-and-tested-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/346
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c |  5 ----
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  | 72 ----------------------------------------------------
 3 files changed, 78 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b679e8a430a8..f0cde2d7233d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2380,11 +2380,6 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		mptcp_subflow_drop_ctx(ssk);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
-		if (ssk->sk_state == TCP_LISTEN) {
-			tcp_set_state(ssk, TCP_CLOSE);
-			mptcp_subflow_queue_clean(sk, ssk);
-			inet_csk_listen_stop(ssk);
-		}
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 2cddd5b52e8f..051e8022d661 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -615,7 +615,6 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
-void mptcp_subflow_queue_clean(struct sock *sk, struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 459621a0410c..fc876c248002 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1764,78 +1764,6 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
-void mptcp_subflow_queue_clean(struct sock *listener_sk, struct sock *listener_ssk)
-{
-	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
-	struct mptcp_sock *msk, *next, *head = NULL;
-	struct request_sock *req;
-
-	/* build a list of all unaccepted mptcp sockets */
-	spin_lock_bh(&queue->rskq_lock);
-	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
-		struct mptcp_subflow_context *subflow;
-		struct sock *ssk = req->sk;
-		struct mptcp_sock *msk;
-
-		if (!sk_is_mptcp(ssk))
-			continue;
-
-		subflow = mptcp_subflow_ctx(ssk);
-		if (!subflow || !subflow->conn)
-			continue;
-
-		/* skip if already in list */
-		msk = mptcp_sk(subflow->conn);
-		if (msk->dl_next || msk == head)
-			continue;
-
-		msk->dl_next = head;
-		head = msk;
-	}
-	spin_unlock_bh(&queue->rskq_lock);
-	if (!head)
-		return;
-
-	/* can't acquire the msk socket lock under the subflow one,
-	 * or will cause ABBA deadlock
-	 */
-	release_sock(listener_ssk);
-
-	for (msk = head; msk; msk = next) {
-		struct sock *sk = (struct sock *)msk;
-		bool do_cancel_work;
-
-		lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
-		next = msk->dl_next;
-		msk->first = NULL;
-		msk->dl_next = NULL;
-
-		do_cancel_work = __mptcp_close(sk, 0);
-		release_sock(sk);
-		if (do_cancel_work) {
-			/* lockdep will report a false positive ABBA deadlock
-			 * between cancel_work_sync and the listener socket.
-			 * The involved locks belong to different sockets WRT
-			 * the existing AB chain.
-			 * Using a per socket key is problematic as key
-			 * deregistration requires process context and must be
-			 * performed at socket disposal time, in atomic
-			 * context.
-			 * Just tell lockdep to consider the listener socket
-			 * released here.
-			 */
-			mutex_release(&listener_sk->sk_lock.dep_map, _RET_IP_);
-			mptcp_cancel_work(sk);
-			mutex_acquire(&listener_sk->sk_lock.dep_map,
-				      SINGLE_DEPTH_NESTING, 0, _RET_IP_);
-		}
-		sock_put(sk);
-	}
-
-	/* we are still under the listener msk socket lock */
-	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
-}
-
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);

-- 
2.39.2

