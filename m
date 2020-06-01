Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E031EADF7
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729693AbgFASuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:50:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730435AbgFASGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:06:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA53B206E2;
        Mon,  1 Jun 2020 18:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034777;
        bh=zZkMrV8sfL+xm3WaOiI2ZiFlxFU4FE6jKQUP2VeQ53o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbMX4CoIe8eczDfe8M//B3dxdgPXAZOLRY+TiqBtbUKjbQ1072caaxR7ZFOWRV1xD
         sPF53LCp6EI+J3T620S7OgFdG/i6hTHBNukJ8wliyt+XbDHf7kTB3ivyg3xZswS1L6
         awFgQU0820KINuvL0XOrCCbFMYwm/Z0n1lOgr8vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 001/142] ax25: fix setsockopt(SO_BINDTODEVICE)
Date:   Mon,  1 Jun 2020 19:52:39 +0200
Message-Id: <20200601174038.146844345@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 687775cec056b38a4c8f3291e0dd7a9145f7b667 ]

syzbot was able to trigger this trace [1], probably by using
a zero optlen.

While we are at it, cap optlen to IFNAMSIZ - 1 instead of IFNAMSIZ.

[1]
BUG: KMSAN: uninit-value in strnlen+0xf9/0x170 lib/string.c:569
CPU: 0 PID: 8807 Comm: syz-executor483 Not tainted 5.7.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:121
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 strnlen+0xf9/0x170 lib/string.c:569
 dev_name_hash net/core/dev.c:207 [inline]
 netdev_name_node_lookup net/core/dev.c:277 [inline]
 __dev_get_by_name+0x75/0x2b0 net/core/dev.c:778
 ax25_setsockopt+0xfa3/0x1170 net/ax25/af_ax25.c:654
 __compat_sys_setsockopt+0x4ed/0x910 net/compat.c:403
 __do_compat_sys_setsockopt net/compat.c:413 [inline]
 __se_compat_sys_setsockopt+0xdd/0x100 net/compat.c:410
 __ia32_compat_sys_setsockopt+0x62/0x80 net/compat.c:410
 do_syscall_32_irqs_on arch/x86/entry/common.c:339 [inline]
 do_fast_syscall_32+0x3bf/0x6d0 arch/x86/entry/common.c:398
 entry_SYSENTER_compat+0x68/0x77 arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f57dd9
Code: 90 e8 0b 00 00 00 f3 90 0f ae e8 eb f9 8d 74 26 00 89 3c 24 c3 90 90 90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffae8c1c EFLAGS: 00000217 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000101
RDX: 0000000000000019 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Local variable ----devname@ax25_setsockopt created at:
 ax25_setsockopt+0xe6/0x1170 net/ax25/af_ax25.c:536
 ax25_setsockopt+0xe6/0x1170 net/ax25/af_ax25.c:536

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ax25/af_ax25.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -635,8 +635,10 @@ static int ax25_setsockopt(struct socket
 		break;
 
 	case SO_BINDTODEVICE:
-		if (optlen > IFNAMSIZ)
-			optlen = IFNAMSIZ;
+		if (optlen > IFNAMSIZ - 1)
+			optlen = IFNAMSIZ - 1;
+
+		memset(devname, 0, sizeof(devname));
 
 		if (copy_from_user(devname, optval, optlen)) {
 			res = -EFAULT;


