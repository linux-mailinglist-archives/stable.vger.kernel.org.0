Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64AA4ABB1F
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384233AbiBGL0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379730AbiBGLQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:16:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11CE8C043181;
        Mon,  7 Feb 2022 03:16:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A26E06126D;
        Mon,  7 Feb 2022 11:16:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C46C004E1;
        Mon,  7 Feb 2022 11:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232576;
        bh=a2vDTHOBI49xRFAsoaRVTLreLT9c8ZOaJ3EMq+rDAfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVghLWZULlHoug5Y5TEQpuGHNQBdcoLaF9af+OApUe1QavrXVzpXRQblhFc3jsaWd
         18FNsZTOl4EIo+YByEUCwUVpc/a6kB4d+FZ/psDsiA3wA2Rq16QJD7v3jEXASjvXTT
         bnCaE9fHd24lYrG6LZp9qxNMPMywgpHtcJyIfjjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 53/86] af_packet: fix data-race in packet_setsockopt / packet_setsockopt
Date:   Mon,  7 Feb 2022 12:06:16 +0100
Message-Id: <20220207103759.304646175@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

commit e42e70ad6ae2ae511a6143d2e8da929366e58bd9 upstream.

When packet_setsockopt( PACKET_FANOUT_DATA ) reads po->fanout,
no lock is held, meaning that another thread can change po->fanout.

Given that po->fanout can only be set once during the socket lifetime
(it is only cleared from fanout_release()), we can use
READ_ONCE()/WRITE_ONCE() to document the race.

BUG: KCSAN: data-race in packet_setsockopt / packet_setsockopt

write to 0xffff88813ae8e300 of 8 bytes by task 14653 on cpu 0:
 fanout_add net/packet/af_packet.c:1791 [inline]
 packet_setsockopt+0x22fe/0x24a0 net/packet/af_packet.c:3931
 __sys_setsockopt+0x209/0x2a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

read to 0xffff88813ae8e300 of 8 bytes by task 14654 on cpu 1:
 packet_setsockopt+0x691/0x24a0 net/packet/af_packet.c:3935
 __sys_setsockopt+0x209/0x2a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0x62/0x70 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x0000000000000000 -> 0xffff888106f8c000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 14654 Comm: syz-executor.3 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011

Fixes: 47dceb8ecdc1 ("packet: add classic BPF fanout mode")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Link: https://lore.kernel.org/r/20220201022358.330621-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1730,7 +1730,10 @@ static int fanout_add(struct sock *sk, u
 		err = -ENOSPC;
 		if (refcount_read(&match->sk_ref) < PACKET_FANOUT_MAX) {
 			__dev_remove_pack(&po->prot_hook);
-			po->fanout = match;
+
+			/* Paired with packet_setsockopt(PACKET_FANOUT_DATA) */
+			WRITE_ONCE(po->fanout, match);
+
 			po->rollover = rollover;
 			rollover = NULL;
 			refcount_set(&match->sk_ref, refcount_read(&match->sk_ref) + 1);
@@ -3877,7 +3880,8 @@ packet_setsockopt(struct socket *sock, i
 	}
 	case PACKET_FANOUT_DATA:
 	{
-		if (!po->fanout)
+		/* Paired with the WRITE_ONCE() in fanout_add() */
+		if (!READ_ONCE(po->fanout))
 			return -EINVAL;
 
 		return fanout_set_data(po, optval, optlen);


