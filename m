Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCF85290D6
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346523AbiEPTyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348150AbiEPTwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:52:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D78245522;
        Mon, 16 May 2022 12:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B21C60ABE;
        Mon, 16 May 2022 19:48:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3A8C36AE9;
        Mon, 16 May 2022 19:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730496;
        bh=rVTxDUp0zD5Y2PVaO85xOsLUVbOGZCNM+BZKHPNu8RQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yb/6CZvqfu5jufgBjkSZEes62C+vMURxb1ZfuitL7On4BNKXOrGIuHdKv00K+pm4j
         N2ZRAzZMGycZMH2ZhGUgxuRXf1wrZcmFufifYhgieN1AEFZcxekWyjhfkaPqp7hdn7
         ndWu9y6Z/o+c+8WgSsECS/4jE1Tjr5QucbMdJB78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 018/102] netlink: do not reset transport header in netlink_recvmsg()
Date:   Mon, 16 May 2022 21:35:52 +0200
Message-Id: <20220516193624.521951232@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d5076fe4049cadef1f040eda4aaa001bb5424225 ]

netlink_recvmsg() does not need to change transport header.

If transport header was needed, it should have been reset
by the producer (netlink_dump()), not the consumer(s).

The following trace probably happened when multiple threads
were using MSG_PEEK.

BUG: KCSAN: data-race in netlink_recvmsg / netlink_recvmsg

write to 0xffff88811e9f15b2 of 2 bytes by task 32012 on cpu 1:
 skb_reset_transport_header include/linux/skbuff.h:2760 [inline]
 netlink_recvmsg+0x1de/0x790 net/netlink/af_netlink.c:1978
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 __sys_recvfrom+0x204/0x2c0 net/socket.c:2097
 __do_sys_recvfrom net/socket.c:2115 [inline]
 __se_sys_recvfrom net/socket.c:2111 [inline]
 __x64_sys_recvfrom+0x74/0x90 net/socket.c:2111
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff88811e9f15b2 of 2 bytes by task 32005 on cpu 0:
 skb_reset_transport_header include/linux/skbuff.h:2760 [inline]
 netlink_recvmsg+0x1de/0x790 net/netlink/af_netlink.c:1978
 ____sys_recvmsg+0x162/0x2f0
 ___sys_recvmsg net/socket.c:2674 [inline]
 __sys_recvmsg+0x209/0x3f0 net/socket.c:2704
 __do_sys_recvmsg net/socket.c:2714 [inline]
 __se_sys_recvmsg net/socket.c:2711 [inline]
 __x64_sys_recvmsg+0x42/0x50 net/socket.c:2711
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0xffff -> 0x0000

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 32005 Comm: syz-executor.4 Not tainted 5.18.0-rc1-syzkaller-00328-ge1f700ebd6be-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220505161946.2867638-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index fb7f7b17c78c..974d32632ef4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1996,7 +1996,6 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		copied = len;
 	}
 
-	skb_reset_transport_header(data_skb);
 	err = skb_copy_datagram_msg(data_skb, 0, msg, copied);
 
 	if (msg->msg_name) {
-- 
2.35.1



