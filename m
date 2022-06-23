Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5F15584BF
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiFWRtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbiFWRro (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:47:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBB6A17C3;
        Thu, 23 Jun 2022 10:11:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5EC9C61D17;
        Thu, 23 Jun 2022 17:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34430C3411B;
        Thu, 23 Jun 2022 17:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004260;
        bh=XcqgUOtmG2YSo8K7ny1MWdm8vTQZ5dp/OwoIyXFvsOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LA6lJzDlTnk9DKYApTukpCdt5WL7ie/DzUsjbC8tJD+XX3wCfJs+ATIeJn3/3VLCi
         NPSzhtATqgyeoc8bMgjjtOIXo/heDKUJUjB1bIiRRDnLme8FsDRcpW6qQZA8i791f2
         NdrTtV8gYbMKvqNKOhwICalABrG0RSPUmpAAH0fY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 227/237] l2tp: dont use inet_shutdown on ppp session destroy
Date:   Thu, 23 Jun 2022 18:44:21 +0200
Message-Id: <20220623164349.683723980@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

commit 225eb26489d05c679a4c4197ffcb81c81e9dcaf4 upstream.

Previously, if a ppp session was closed, we called inet_shutdown to mark
the socket as unconnected such that userspace would get errors and
then close the socket. This could race with userspace closing the
socket. Instead, leave userspace to close the socket in its own time
(our session will be detached anyway).

BUG: KASAN: use-after-free in inet_shutdown+0x5d/0x1c0
Read of size 4 at addr ffff880010ea3ac0 by task syzbot_347bd5ac/8296

CPU: 3 PID: 8296 Comm: syzbot_347bd5ac Not tainted 4.16.0-rc1+ #91
Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
Call Trace:
 dump_stack+0x101/0x157
 ? inet_shutdown+0x5d/0x1c0
 print_address_description+0x78/0x260
 ? inet_shutdown+0x5d/0x1c0
 kasan_report+0x240/0x360
 __asan_load4+0x78/0x80
 inet_shutdown+0x5d/0x1c0
 ? pppol2tp_show+0x80/0x80
 pppol2tp_session_close+0x68/0xb0
 l2tp_tunnel_closeall+0x199/0x210
 ? udp_v6_flush_pending_frames+0x90/0x90
 l2tp_udp_encap_destroy+0x6b/0xc0
 ? l2tp_tunnel_del_work+0x2e0/0x2e0
 udpv6_destroy_sock+0x8c/0x90
 sk_common_release+0x47/0x190
 udp_lib_close+0x15/0x20
 inet_release+0x85/0xd0
 inet6_release+0x43/0x60
 sock_release+0x53/0x100
 ? sock_alloc_file+0x260/0x260
 sock_close+0x1b/0x20
 __fput+0x19f/0x380
 ____fput+0x1a/0x20
 task_work_run+0xd2/0x110
 exit_to_usermode_loop+0x18d/0x190
 do_syscall_64+0x389/0x3b0
 entry_SYSCALL_64_after_hwframe+0x26/0x9b
RIP: 0033:0x7fe240a45259
RSP: 002b:00007fe241132df8 EFLAGS: 00000297 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fe240a45259
RDX: 00007fe240a45259 RSI: 0000000000000000 RDI: 00000000000000a5
RBP: 00007fe241132e20 R08: 00007fe241133700 R09: 0000000000000000
R10: 00007fe241133700 R11: 0000000000000297 R12: 0000000000000000
R13: 00007ffc49aff84f R14: 0000000000000000 R15: 00007fe241141040

Allocated by task 8331:
 save_stack+0x43/0xd0
 kasan_kmalloc+0xad/0xe0
 kasan_slab_alloc+0x12/0x20
 kmem_cache_alloc+0x144/0x3e0
 sock_alloc_inode+0x22/0x130
 alloc_inode+0x3d/0xf0
 new_inode_pseudo+0x1c/0x90
 sock_alloc+0x30/0x110
 __sock_create+0xaa/0x4c0
 SyS_socket+0xbe/0x130
 do_syscall_64+0x128/0x3b0
 entry_SYSCALL_64_after_hwframe+0x26/0x9b

Freed by task 8314:
 save_stack+0x43/0xd0
 __kasan_slab_free+0x11a/0x170
 kasan_slab_free+0xe/0x10
 kmem_cache_free+0x88/0x2b0
 sock_destroy_inode+0x49/0x50
 destroy_inode+0x77/0xb0
 evict+0x285/0x340
 iput+0x429/0x530
 dentry_unlink_inode+0x28c/0x2c0
 __dentry_kill+0x1e3/0x2f0
 dput.part.21+0x500/0x560
 dput+0x24/0x30
 __fput+0x2aa/0x380
 ____fput+0x1a/0x20
 task_work_run+0xd2/0x110
 exit_to_usermode_loop+0x18d/0x190
 do_syscall_64+0x389/0x3b0
 entry_SYSCALL_64_after_hwframe+0x26/0x9b

Fixes: fd558d186df2c ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")
Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_ppp.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -439,16 +439,6 @@ abort:
  */
 static void pppol2tp_session_close(struct l2tp_session *session)
 {
-	struct sock *sk;
-
-	BUG_ON(session->magic != L2TP_SESSION_MAGIC);
-
-	sk = pppol2tp_session_get_sock(session);
-	if (sk) {
-		if (sk->sk_socket)
-			inet_shutdown(sk->sk_socket, SEND_SHUTDOWN);
-		sock_put(sk);
-	}
 }
 
 /* Really kill the session socket. (Called from sock_put() if


