Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2744ABA94
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383912AbiBGLYD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352110AbiBGLLw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:11:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F4DC043188;
        Mon,  7 Feb 2022 03:11:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4CAA6113B;
        Mon,  7 Feb 2022 11:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81607C004E1;
        Mon,  7 Feb 2022 11:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232311;
        bh=Vcyy/cmLPqFA7zBx2oZ50VqQZKrAlADhGuLNEobL6M0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dB3tlQC2pI88XH58i58VDynXZ7NnE6q0/HH/i5m3fKy61Aa80d/GAJO3NoW5jrjtF
         bkeaMHBOLhWZSS9oHu8/3YwYNjyVxaOA+ym20uj/MGSPqZIBHu/HD4pSVaJDQN7IWE
         GjlbRjG4ZN2rSmoELJPz/ZY4OuUx6+3I8ADplRuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 36/69] ipv4: raw: lock the socket in raw_bind()
Date:   Mon,  7 Feb 2022 12:05:58 +0100
Message-Id: <20220207103756.812573501@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 153a0d187e767c68733b8e9f46218eb1f41ab902 ]

For some reason, raw_bind() forgot to lock the socket.

BUG: KCSAN: data-race in __ip4_datagram_connect / raw_bind

write to 0xffff8881170d4308 of 4 bytes by task 5466 on cpu 0:
 raw_bind+0x1b0/0x250 net/ipv4/raw.c:739
 inet_bind+0x56/0xa0 net/ipv4/af_inet.c:443
 __sys_bind+0x14b/0x1b0 net/socket.c:1697
 __do_sys_bind net/socket.c:1708 [inline]
 __se_sys_bind net/socket.c:1706 [inline]
 __x64_sys_bind+0x3d/0x50 net/socket.c:1706
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff8881170d4308 of 4 bytes by task 5468 on cpu 1:
 __ip4_datagram_connect+0xb7/0x7b0 net/ipv4/datagram.c:39
 ip4_datagram_connect+0x2a/0x40 net/ipv4/datagram.c:89
 inet_dgram_connect+0x107/0x190 net/ipv4/af_inet.c:576
 __sys_connect_file net/socket.c:1900 [inline]
 __sys_connect+0x197/0x1b0 net/socket.c:1917
 __do_sys_connect net/socket.c:1927 [inline]
 __se_sys_connect net/socket.c:1924 [inline]
 __x64_sys_connect+0x3d/0x50 net/socket.c:1924
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000000 -> 0x0003007f

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 5468 Comm: syz-executor.5 Not tainted 5.17.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/raw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 261a9813b88cd..9c4b2c0dc68ae 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -721,6 +721,7 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	int ret = -EINVAL;
 	int chk_addr_ret;
 
+	lock_sock(sk);
 	if (sk->sk_state != TCP_CLOSE || addr_len < sizeof(struct sockaddr_in))
 		goto out;
 
@@ -740,7 +741,9 @@ static int raw_bind(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 		inet->inet_saddr = 0;  /* Use device */
 	sk_dst_reset(sk);
 	ret = 0;
-out:	return ret;
+out:
+	release_sock(sk);
+	return ret;
 }
 
 /*
-- 
2.34.1



