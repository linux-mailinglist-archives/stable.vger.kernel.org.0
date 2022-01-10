Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FFA4891D3
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240749AbiAJHgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:41 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59994 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239591AbiAJHdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:33:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A701EB811F9;
        Mon, 10 Jan 2022 07:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2EAC36AED;
        Mon, 10 Jan 2022 07:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641800003;
        bh=+IgOhsZw0AUTYG+Ut03DuxUF55vMspBPcisC+jUTaIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRGS0kjh2xaEuaaC4sYARBFtC4KyYi8zT7VeYL3flSgIqDEiwhZqmJFaQ1SifbpYh
         s55ygUo1TF2PMK/asr6HvKbgZFhWoRqoMn7z6sOXsKBKXoJ7m+KIZKYXZCVrs313d4
         aD8z/6w+Ie26wld+nMLL36hxCXybi5zDS7eO1RaE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+cdbd40e0c3ca02cae3b7@syzkaller.appspotmail.com,
        Haimin Zhang <tcs_kernel@tencent.com>,
        Jon Maloy <jmaloy@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 46/72] net ticp:fix a kernel-infoleak in __tipc_sendmsg()
Date:   Mon, 10 Jan 2022 08:23:23 +0100
Message-Id: <20220110071823.111741880@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haimin Zhang <tcs_kernel@tencent.com>

commit d6d86830705f173fca6087a3e67ceaf68db80523 upstream.

struct tipc_socket_addr.ref has a 4-byte hole,and __tipc_getname() currently
copying it to user space,causing kernel-infoleak.

BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline]
BUG: KMSAN: kernel-infoleak in instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
BUG: KMSAN: kernel-infoleak in _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
 instrument_copy_to_user include/linux/instrumented.h:121 [inline]
 instrument_copy_to_user include/linux/instrumented.h:121 [inline] lib/usercopy.c:33
 _copy_to_user+0x1c9/0x270 lib/usercopy.c:33 lib/usercopy.c:33
 copy_to_user include/linux/uaccess.h:209 [inline]
 copy_to_user include/linux/uaccess.h:209 [inline] net/socket.c:287
 move_addr_to_user+0x3f6/0x600 net/socket.c:287 net/socket.c:287
 __sys_getpeername+0x470/0x6b0 net/socket.c:1987 net/socket.c:1987
 __do_sys_getpeername net/socket.c:1997 [inline]
 __se_sys_getpeername net/socket.c:1994 [inline]
 __do_sys_getpeername net/socket.c:1997 [inline] net/socket.c:1994
 __se_sys_getpeername net/socket.c:1994 [inline] net/socket.c:1994
 __x64_sys_getpeername+0xda/0x120 net/socket.c:1994 net/socket.c:1994
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 tipc_getname+0x575/0x5e0 net/tipc/socket.c:757 net/tipc/socket.c:757
 __sys_getpeername+0x3b3/0x6b0 net/socket.c:1984 net/socket.c:1984
 __do_sys_getpeername net/socket.c:1997 [inline]
 __se_sys_getpeername net/socket.c:1994 [inline]
 __do_sys_getpeername net/socket.c:1997 [inline] net/socket.c:1994
 __se_sys_getpeername net/socket.c:1994 [inline] net/socket.c:1994
 __x64_sys_getpeername+0xda/0x120 net/socket.c:1994 net/socket.c:1994
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was stored to memory at:
 msg_set_word net/tipc/msg.h:212 [inline]
 msg_set_destport net/tipc/msg.h:619 [inline]
 msg_set_word net/tipc/msg.h:212 [inline] net/tipc/socket.c:1486
 msg_set_destport net/tipc/msg.h:619 [inline] net/tipc/socket.c:1486
 __tipc_sendmsg+0x44fa/0x5890 net/tipc/socket.c:1486 net/tipc/socket.c:1486
 tipc_sendmsg+0xeb/0x140 net/tipc/socket.c:1402 net/tipc/socket.c:1402
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 sock_sendmsg_nosec net/socket.c:704 [inline] net/socket.c:2409
 sock_sendmsg net/socket.c:724 [inline] net/socket.c:2409
 ____sys_sendmsg+0xe11/0x12c0 net/socket.c:2409 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 ___sys_sendmsg net/socket.c:2463 [inline] net/socket.c:2492
 __sys_sendmsg+0x704/0x840 net/socket.c:2492 net/socket.c:2492
 __do_sys_sendmsg net/socket.c:2501 [inline]
 __se_sys_sendmsg net/socket.c:2499 [inline]
 __do_sys_sendmsg net/socket.c:2501 [inline] net/socket.c:2499
 __se_sys_sendmsg net/socket.c:2499 [inline] net/socket.c:2499
 __x64_sys_sendmsg+0xe2/0x120 net/socket.c:2499 net/socket.c:2499
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_x64 arch/x86/entry/common.c:51 [inline] arch/x86/entry/common.c:82
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Local variable skaddr created at:
 __tipc_sendmsg+0x2d0/0x5890 net/tipc/socket.c:1419 net/tipc/socket.c:1419
 tipc_sendmsg+0xeb/0x140 net/tipc/socket.c:1402 net/tipc/socket.c:1402

Bytes 4-7 of 16 are uninitialized
Memory access of size 16 starts at ffff888113753e00
Data copied to user address 0000000020000280

Reported-by: syzbot+cdbd40e0c3ca02cae3b7@syzkaller.appspotmail.com
Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Link: https://lore.kernel.org/r/1640918123-14547-1-git-send-email-tcs.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1461,6 +1461,8 @@ static int __tipc_sendmsg(struct socket
 		msg_set_syn(hdr, 1);
 	}
 
+	memset(&skaddr, 0, sizeof(skaddr));
+
 	/* Determine destination */
 	if (atype == TIPC_SERVICE_RANGE) {
 		return tipc_sendmcast(sock, ua, m, dlen, timeout);


