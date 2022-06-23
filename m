Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C78558254
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiFWRNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiFWRMf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:12:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A9616589;
        Thu, 23 Jun 2022 09:58:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ABBC2B8248F;
        Thu, 23 Jun 2022 16:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1810FC341C4;
        Thu, 23 Jun 2022 16:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003479;
        bh=BXkjfYxr3lkW1bEpadcD6TBXeKgFtxzBQzeT47lMS+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/8be4yeNQ9yte9pr60HCFGIdidkQZB5d6CI1P1QROuG1lykr8D//qbbil2YWqaFa
         hHXNBZfF/e7R1WnVFwb19sST6GQdlgkj9ni39C1NTHn8bhcdNkxlEALsu+dJ7HY1NZ
         xKfp6TqhKgtr14UXCFtLbb/JfN9aCxKPzmLDff7c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 251/264] l2tp: fix race in pppol2tp_release with session object destroy
Date:   Thu, 23 Jun 2022 18:44:04 +0200
Message-Id: <20220623164351.170045598@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Chapman <jchapman@katalix.com>

commit d02ba2a6110c530a32926af8ad441111774d2893 upstream.

pppol2tp_release uses call_rcu to put the final ref on its socket. But
the session object doesn't hold a ref on the session socket so may be
freed while the pppol2tp_put_sk RCU callback is scheduled. Fix this by
having the session hold a ref on its socket until the session is
destroyed. It is this ref that is dropped via call_rcu.

Sessions are also deleted via l2tp_tunnel_closeall. This must now also put
the final ref via call_rcu. So move the call_rcu call site into
pppol2tp_session_close so that this happens in both destroy paths. A
common destroy path should really be implemented, perhaps with
l2tp_tunnel_closeall calling l2tp_session_delete like pppol2tp_release
does, but this will be looked at later.

ODEBUG: activate active (active state 1) object type: rcu_head hint:           (null)
WARNING: CPU: 3 PID: 13407 at lib/debugobjects.c:291 debug_print_object+0x166/0x220
Modules linked in:
CPU: 3 PID: 13407 Comm: syzbot_19c09769 Not tainted 4.16.0-rc2+ #38
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
RIP: 0010:debug_print_object+0x166/0x220
RSP: 0018:ffff880013647a00 EFLAGS: 00010082
RAX: dffffc0000000008 RBX: 0000000000000003 RCX: ffffffff814d3333
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff88001a59f6d0
RBP: ffff880013647a40 R08: 0000000000000000 R09: 0000000000000001
R10: ffff8800136479a8 R11: 0000000000000000 R12: 0000000000000001
R13: ffffffff86161420 R14: ffffffff85648b60 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88001a580000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020e77000 CR3: 0000000006022000 CR4: 00000000000006e0
Call Trace:
 debug_object_activate+0x38b/0x530
 ? debug_object_assert_init+0x3b0/0x3b0
 ? __mutex_unlock_slowpath+0x85/0x8b0
 ? pppol2tp_session_destruct+0x110/0x110
 __call_rcu.constprop.66+0x39/0x890
 ? __call_rcu.constprop.66+0x39/0x890
 call_rcu_sched+0x17/0x20
 pppol2tp_release+0x2c7/0x440
 ? fcntl_setlk+0xca0/0xca0
 ? sock_alloc_file+0x340/0x340
 sock_release+0x92/0x1e0
 sock_close+0x1b/0x20
 __fput+0x296/0x6e0
 ____fput+0x1a/0x20
 task_work_run+0x127/0x1a0
 do_exit+0x7f9/0x2ce0
 ? SYSC_connect+0x212/0x310
 ? mm_update_next_owner+0x690/0x690
 ? up_read+0x1f/0x40
 ? __do_page_fault+0x3c8/0xca0
 do_group_exit+0x10d/0x330
 ? do_group_exit+0x330/0x330
 SyS_exit_group+0x22/0x30
 do_syscall_64+0x1e0/0x730
 ? trace_hardirqs_off_thunk+0x1a/0x1c
 entry_SYSCALL_64_after_hwframe+0x42/0xb7
RIP: 0033:0x7f362e471259
RSP: 002b:00007ffe389abe08 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f362e471259
RDX: 00007f362e471259 RSI: 000000000000002e RDI: 0000000000000000
RBP: 00007ffe389abe30 R08: 0000000000000000 R09: 00007f362e944270
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000400b60
R13: 00007ffe389abf50 R14: 0000000000000000 R15: 0000000000000000
Code: 8d 3c dd a0 8f 64 85 48 89 fa 48 c1 ea 03 80 3c 02 00 75 7b 48 8b 14 dd a0 8f 64 85 4c 89 f6 48 c7 c7 20 85 64 85 e
8 2a 55 14 ff <0f> 0b 83 05 ad 2a 68 04 01 48 83 c4 18 5b 41 5c 41 5d 41 5e 41

Fixes: ee40fb2e1eb5b ("l2tp: protect sock pointer of struct pppol2tp_session with RCU")
Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |   52 +++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -435,10 +435,28 @@ abort:
  * Session (and tunnel control) socket create/destroy.
  *****************************************************************************/
 
+static void pppol2tp_put_sk(struct rcu_head *head)
+{
+	struct pppol2tp_session *ps;
+
+	ps = container_of(head, typeof(*ps), rcu);
+	sock_put(ps->__sk);
+}
+
 /* Called by l2tp_core when a session socket is being closed.
  */
 static void pppol2tp_session_close(struct l2tp_session *session)
 {
+	struct pppol2tp_session *ps;
+
+	ps = l2tp_session_priv(session);
+	mutex_lock(&ps->sk_lock);
+	ps->__sk = rcu_dereference_protected(ps->sk,
+					     lockdep_is_held(&ps->sk_lock));
+	RCU_INIT_POINTER(ps->sk, NULL);
+	if (ps->__sk)
+		call_rcu(&ps->rcu, pppol2tp_put_sk);
+	mutex_unlock(&ps->sk_lock);
 }
 
 /* Really kill the session socket. (Called from sock_put() if
@@ -458,14 +476,6 @@ static void pppol2tp_session_destruct(st
 	}
 }
 
-static void pppol2tp_put_sk(struct rcu_head *head)
-{
-	struct pppol2tp_session *ps;
-
-	ps = container_of(head, typeof(*ps), rcu);
-	sock_put(ps->__sk);
-}
-
 /* Called when the PPPoX socket (session) is closed.
  */
 static int pppol2tp_release(struct socket *sock)
@@ -489,26 +499,17 @@ static int pppol2tp_release(struct socke
 	sock_orphan(sk);
 	sock->sk = NULL;
 
+	/* If the socket is associated with a session,
+	 * l2tp_session_delete will call pppol2tp_session_close which
+	 * will drop the session's ref on the socket.
+	 */
 	session = pppol2tp_sock_to_session(sk);
-
-	if (session != NULL) {
-		struct pppol2tp_session *ps;
-
+	if (session) {
 		l2tp_session_delete(session);
-
-		ps = l2tp_session_priv(session);
-		mutex_lock(&ps->sk_lock);
-		ps->__sk = rcu_dereference_protected(ps->sk,
-						     lockdep_is_held(&ps->sk_lock));
-		RCU_INIT_POINTER(ps->sk, NULL);
-		mutex_unlock(&ps->sk_lock);
-		call_rcu(&ps->rcu, pppol2tp_put_sk);
-
-		/* Rely on the sock_put() call at the end of the function for
-		 * dropping the reference held by pppol2tp_sock_to_session().
-		 * The last reference will be dropped by pppol2tp_put_sk().
-		 */
+		/* drop the ref obtained by pppol2tp_sock_to_session */
+		sock_put(sk);
 	}
+
 	release_sock(sk);
 
 	/* This will delete the session context via
@@ -817,6 +818,7 @@ static int pppol2tp_connect(struct socke
 
 out_no_ppp:
 	/* This is how we get the session context from the socket. */
+	sock_hold(sk);
 	sk->sk_user_data = session;
 	rcu_assign_pointer(ps->sk, sk);
 	mutex_unlock(&ps->sk_lock);


