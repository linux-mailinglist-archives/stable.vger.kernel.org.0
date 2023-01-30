Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F36681331
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:29:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237653AbjA3O3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237783AbjA3O2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:28:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FB642BF0
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:27:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A7C1B811BD
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:27:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CA0C433D2;
        Mon, 30 Jan 2023 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088827;
        bh=kZ93ADt5CS9BMDSH+OYoNfbEJXlXrHGuaSx56q1wTmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIMKu8NIfDz8DEGiIqhVa9plv0+SsY0pPANRyiNZRux8hcgvw5dCXZMkNsMi70hoD
         AGNUpJYQx3x8oH1/R4Uk1U2UXboR5MwBTQWjDOKvXbm9Lw2YZrtcclrR9eChpLigl9
         uLKZMRjFx5S4o+/A8CG5SL/zmVBe8I0hEf0Q/mj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/143] netlink: annotate data races around nlk->portid
Date:   Mon, 30 Jan 2023 14:52:57 +0100
Message-Id: <20230130134311.794311505@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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
index d96a610929d9..438f45222ca5 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -570,7 +570,9 @@ static int netlink_insert(struct sock *sk, u32 portid)
 	if (nlk_sk(sk)->bound)
 		goto err;
 
-	nlk_sk(sk)->portid = portid;
+	/* portid can be read locklessly from netlink_getname(). */
+	WRITE_ONCE(nlk_sk(sk)->portid, portid);
+
 	sock_hold(sk);
 
 	err = __netlink_insert(table, sk);
@@ -1124,7 +1126,8 @@ static int netlink_getname(struct socket *sock, struct sockaddr *addr,
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



