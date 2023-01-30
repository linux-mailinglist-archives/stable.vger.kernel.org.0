Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332EC68125C
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbjA3OU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237742AbjA3OT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:19:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2023E601
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C8956104A
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDABC433EF;
        Mon, 30 Jan 2023 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088276;
        bh=d83yDMRhfWu2mHNXIQ5Zwj2WzAEprSJTeJ9B8AU63dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCVE0+7wkv2aCfgX64P1Hb9i/UObAzHdK7lN0Z6SrlI2UQjrFCB2bi/TvB3rHzbLF
         bWQWz7GViw9rPvIN3VG9XBJRD05XKb1BvnmY2eiSU/8ASkA9cbGc/hX+HiqlSTj4rS
         mzvzxqAARq9pp0gjNPBLZ6ciGJrlp/47cvc8k9i8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 175/204] netlink: annotate data races around nlk->portid
Date:   Mon, 30 Jan 2023 14:52:20 +0100
Message-Id: <20230130134324.249531738@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c1bb9484e3b05166880da8574504156ccbd0549e ]

syzbot reminds us netlink_getname() runs locklessly [1]

This first patch annotates the race against nlk->portid.

Following patches take care of the remaining races.

[1]
BUG: KCSAN: data-race in netlink_getname / netlink_insert

write to 0xffff88814176d310 of 4 bytes by task 2315 on cpu 1:
netlink_insert+0xf1/0x9a0 net/netlink/af_netlink.c:583
netlink_autobind+0xae/0x180 net/netlink/af_netlink.c:856
netlink_sendmsg+0x444/0x760 net/netlink/af_netlink.c:1895
sock_sendmsg_nosec net/socket.c:714 [inline]
sock_sendmsg net/socket.c:734 [inline]
____sys_sendmsg+0x38f/0x500 net/socket.c:2476
___sys_sendmsg net/socket.c:2530 [inline]
__sys_sendmsg+0x19a/0x230 net/socket.c:2559
__do_sys_sendmsg net/socket.c:2568 [inline]
__se_sys_sendmsg net/socket.c:2566 [inline]
__x64_sys_sendmsg+0x42/0x50 net/socket.c:2566
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff88814176d310 of 4 bytes by task 2316 on cpu 0:
netlink_getname+0xcd/0x1a0 net/netlink/af_netlink.c:1144
__sys_getsockname+0x11d/0x1b0 net/socket.c:2026
__do_sys_getsockname net/socket.c:2041 [inline]
__se_sys_getsockname net/socket.c:2038 [inline]
__x64_sys_getsockname+0x3e/0x50 net/socket.c:2038
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0x00000000 -> 0xc9a49780

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 2316 Comm: syz-executor.2 Not tainted 6.2.0-rc3-syzkaller-00030-ge8f60cd7db24-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 974d32632ef4..1eab80af5112 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -578,7 +578,9 @@ static int netlink_insert(struct sock *sk, u32 portid)
 	if (nlk_sk(sk)->bound)
 		goto err;
 
-	nlk_sk(sk)->portid = portid;
+	/* portid can be read locklessly from netlink_getname(). */
+	WRITE_ONCE(nlk_sk(sk)->portid, portid);
+
 	sock_hold(sk);
 
 	err = __netlink_insert(table, sk);
@@ -1132,7 +1134,8 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
 		nladdr->nl_pid = nlk->dst_portid;
 		nladdr->nl_groups = netlink_group_mask(nlk->dst_group);
 	} else {
-		nladdr->nl_pid = nlk->portid;
+		/* Paired with WRITE_ONCE() in netlink_insert() */
+		nladdr->nl_pid = READ_ONCE(nlk->portid);
 		netlink_lock_table();
 		nladdr->nl_groups = nlk->groups ? nlk->groups[0] : 0;
 		netlink_unlock_table();
-- 
2.39.0



