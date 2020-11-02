Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1EBA2A22F3
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 03:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgKBCRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 21:17:19 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:40173 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727689AbgKBCRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 21:17:18 -0500
Received: by mail-io1-f71.google.com with SMTP id v7so7495187ioe.7
        for <stable@vger.kernel.org>; Sun, 01 Nov 2020 18:17:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bX3kU4P8yJuAY82nsfBl0rlgJH/7CdYcGrqPlOLjb6A=;
        b=Ii6/Yz30g3vf/pgvaTQq+UQyngACPQhpdkZ2WOa7s7LR2GWuvuTn0n+980XvV48Gib
         HmBodzVAt7Lnc1iOt1OezwA3A7a/hSNEXk/3KrFrSk6klqTz6E/yYJ/aNdimnUZwg/JU
         FXNjrabSS6MYGNWuVRJGby0GRVsGgaPZlkBI8cbR7YCi4LpYsMwVfO04Ffz8OSQCbjJD
         XZRHj7bRpABJfnYAV7mojNSbfG+ribJeh4m6hJy64hDJq1njW+Kuk/k1N150/UV0qBsy
         0rY5TR8HCxvpGrqFYGAYLyoEaGzcbz1osdFg0EcHUVTvarb7OXR6vbwoRSojtMnl2D0m
         ZtWw==
X-Gm-Message-State: AOAM5332xo098vQRkpqTIwSqVwXVjSJPbgY3axWyQ4vmY20jcBb7Oxh4
        vV3a9SVMJwA8QBT5A8ALynRGwsM5deDzcdgVltqW3iYbQonr
X-Google-Smtp-Source: ABdhPJwULsSw1nWFIVrIGiYn037uYE295gM+Ktp0k2e6asH2TIZtXJtu6z7hccagspKZOHSss24KU1iUY9QXh3Ua/3XwHqAxGA21
MIME-Version: 1.0
X-Received: by 2002:a05:6638:a11:: with SMTP id 17mr10180222jan.59.1604283437871;
 Sun, 01 Nov 2020 18:17:17 -0800 (PST)
Date:   Sun, 01 Nov 2020 18:17:17 -0800
In-Reply-To: <00000000000014370305b1c55370@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006ef8a105b31658b5@google.com>
Subject: Re: UBSAN: array-index-out-of-bounds in alg_bind
From:   syzbot <syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, ebiggers@kernel.org,
        gustavoars@kernel.org, herbert@gondor.apana.org.au,
        jannh@google.com, keescook@chromium.org, lenaptr@google.com,
        linux-api@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        vegard.nossum@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3cea11cd Linux 5.10-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1443bf92500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e791ddf0875adf65
dashboard link: https://syzkaller.appspot.com/bug?extid=92ead4eb8e26a26d465e
compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=145afc2c500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=141ad11a500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+92ead4eb8e26a26d465e@syzkaller.appspotmail.com

================================================================================
UBSAN: array-index-out-of-bounds in crypto/af_alg.c:166:2
index 98 is out of range for type '__u8 [64]'
CPU: 1 PID: 8468 Comm: syz-executor983 Not tainted 5.10.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:118
 ubsan_epilogue lib/ubsan.c:148 [inline]
 __ubsan_handle_out_of_bounds+0xdb/0x130 lib/ubsan.c:356
 alg_bind+0x738/0x740 crypto/af_alg.c:166
 __sys_bind+0x283/0x360 net/socket.c:1656
 __do_sys_bind net/socket.c:1667 [inline]
 __se_sys_bind net/socket.c:1665 [inline]
 __x64_sys_bind+0x76/0x80 net/socket.c:1665
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4402c9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe05301528 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402c9
RDX: 000000000000007b RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ad0
R13: 0000000000401b60 R14: 0000000000000000 R15: 0000000000000000
================================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8468 Comm: syz-executor983 Not tainted 5.10.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x137/0x1be lib/dump_stack.c:118
 panic+0x291/0x800 kernel/panic.c:231
 ubsan_epilogue lib/ubsan.c:162 [inline]
 __ubsan_handle_out_of_bounds+0x12b/0x130 lib/ubsan.c:356
 alg_bind+0x738/0x740 crypto/af_alg.c:166
 __sys_bind+0x283/0x360 net/socket.c:1656
 __do_sys_bind net/socket.c:1667 [inline]
 __se_sys_bind net/socket.c:1665 [inline]
 __x64_sys_bind+0x76/0x80 net/socket.c:1665
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x4402c9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe05301528 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004402c9
RDX: 000000000000007b RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401ad0
R13: 0000000000401b60 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

