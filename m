Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC7360FEE8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 19:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237106AbiJ0RJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 13:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiJ0RJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 13:09:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F77DE87
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 10:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CB8062369
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 17:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4E4C433C1;
        Thu, 27 Oct 2022 17:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666890571;
        bh=bQI947WZrmZ0y6AFX6JTjEJE0mm8+yIlh/YPhcZ+4Gk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JgTzuGwlfpzN4YVkWCdzboTXsuN3ZZk6gPLFRukHn0/hNPc6jyu9Vg1QJwKBxY9gd
         Dpv7lzTZPb/+Yq09fe7KxeVXQo7ajmomhGqNl6upG3rQMxFXSxXv4XgS0btpu/JcwP
         Ls6fYe+MEK8bnC8o4d/Ce57MQ6etBid/iw9Oo7s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alexander Potapenko <glider@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 41/53] tipc: fix an information leak in tipc_topsrv_kern_subscr
Date:   Thu, 27 Oct 2022 18:56:29 +0200
Message-Id: <20221027165051.385954935@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165049.817124510@linuxfoundation.org>
References: <20221027165049.817124510@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Potapenko <glider@google.com>

[ Upstream commit 777ecaabd614d47c482a5c9031579e66da13989a ]

Use a 8-byte write to initialize sub.usr_handle in
tipc_topsrv_kern_subscr(), otherwise four bytes remain uninitialized
when issuing setsockopt(..., SOL_TIPC, ...).
This resulted in an infoleak reported by KMSAN when the packet was
received:

  =====================================================
  BUG: KMSAN: kernel-infoleak in copyout+0xbc/0x100 lib/iov_iter.c:169
   instrument_copy_to_user ./include/linux/instrumented.h:121
   copyout+0xbc/0x100 lib/iov_iter.c:169
   _copy_to_iter+0x5c0/0x20a0 lib/iov_iter.c:527
   copy_to_iter ./include/linux/uio.h:176
   simple_copy_to_iter+0x64/0xa0 net/core/datagram.c:513
   __skb_datagram_iter+0x123/0xdc0 net/core/datagram.c:419
   skb_copy_datagram_iter+0x58/0x200 net/core/datagram.c:527
   skb_copy_datagram_msg ./include/linux/skbuff.h:3903
   packet_recvmsg+0x521/0x1e70 net/packet/af_packet.c:3469
   ____sys_recvmsg+0x2c4/0x810 net/socket.c:?
   ___sys_recvmsg+0x217/0x840 net/socket.c:2743
   __sys_recvmsg net/socket.c:2773
   __do_sys_recvmsg net/socket.c:2783
   __se_sys_recvmsg net/socket.c:2780
   __x64_sys_recvmsg+0x364/0x540 net/socket.c:2780
   do_syscall_x64 arch/x86/entry/common.c:50
   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd arch/x86/entry/entry_64.S:120

  ...

  Uninit was stored to memory at:
   tipc_sub_subscribe+0x42d/0xb50 net/tipc/subscr.c:156
   tipc_conn_rcv_sub+0x246/0x620 net/tipc/topsrv.c:375
   tipc_topsrv_kern_subscr+0x2e8/0x400 net/tipc/topsrv.c:579
   tipc_group_create+0x4e7/0x7d0 net/tipc/group.c:190
   tipc_sk_join+0x2a8/0x770 net/tipc/socket.c:3084
   tipc_setsockopt+0xae5/0xe40 net/tipc/socket.c:3201
   __sys_setsockopt+0x87f/0xdc0 net/socket.c:2252
   __do_sys_setsockopt net/socket.c:2263
   __se_sys_setsockopt net/socket.c:2260
   __x64_sys_setsockopt+0xe0/0x160 net/socket.c:2260
   do_syscall_x64 arch/x86/entry/common.c:50
   do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd arch/x86/entry/entry_64.S:120

  Local variable sub created at:
   tipc_topsrv_kern_subscr+0x57/0x400 net/tipc/topsrv.c:562
   tipc_group_create+0x4e7/0x7d0 net/tipc/group.c:190

  Bytes 84-87 of 88 are uninitialized
  Memory access of size 88 starts at ffff88801ed57cd0
  Data copied to user address 0000000020000400
  ...
  =====================================================

Signed-off-by: Alexander Potapenko <glider@google.com>
Fixes: 026321c6d056a5 ("tipc: rename tipc_server to tipc_topsrv")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/topsrv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 444e1792d02c..b8797ff153e6 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -568,7 +568,7 @@ bool tipc_topsrv_kern_subscr(struct net *net, u32 port, u32 type, u32 lower,
 	sub.seq.upper = upper;
 	sub.timeout = TIPC_WAIT_FOREVER;
 	sub.filter = filter;
-	*(u32 *)&sub.usr_handle = port;
+	*(u64 *)&sub.usr_handle = (u64)port;
 
 	con = tipc_conn_alloc(tipc_topsrv(net));
 	if (IS_ERR(con))
-- 
2.35.1



