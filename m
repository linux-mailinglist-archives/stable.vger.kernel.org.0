Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE6543A12A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235649AbhJYTh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236432AbhJYTei (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBF8261184;
        Mon, 25 Oct 2021 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190246;
        bh=4qRojGq1/efZNWYMCbmU9TRiIk0DdEoCaOqKrf8hOkQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Uahj9xnvY90Wjmb7TfUhZCrV6YwA9RxaI+hKK6llAaO3BMEeogGzTgGQ3NxrdCu3b
         DfsLld4a7RJI/CirqNDaRrlw2VSwVZBQ1mmkEEx2EeOyw+VIiMQTO+bOIEkPLuXOV6
         fAiwbWVaZl4RWdI56ghiyFAe352aHQ/1wOoKRdo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juhee Kang <claudiajkang@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 12/95] netfilter: xt_IDLETIMER: fix panic that occurs when timer_type has garbage value
Date:   Mon, 25 Oct 2021 21:14:09 +0200
Message-Id: <20211025190958.656785010@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juhee Kang <claudiajkang@gmail.com>

[ Upstream commit 902c0b1887522a099aa4e1e6b4b476c2fe5dd13e ]

Currently, when the rule related to IDLETIMER is added, idletimer_tg timer
structure is initialized by kmalloc on executing idletimer_tg_create
function. However, in this process timer->timer_type is not defined to
a specific value. Thus, timer->timer_type has garbage value and it occurs
kernel panic. So, this commit fixes the panic by initializing
timer->timer_type using kzalloc instead of kmalloc.

Test commands:
    # iptables -A OUTPUT -j IDLETIMER --timeout 1 --label test
    $ cat /sys/class/xt_idletimer/timers/test
      Killed

Splat looks like:
    BUG: KASAN: user-memory-access in alarm_expires_remaining+0x49/0x70
    Read of size 8 at addr 0000002e8c7bc4c8 by task cat/917
    CPU: 12 PID: 917 Comm: cat Not tainted 5.14.0+ #3 79940a339f71eb14fc81aee1757a20d5bf13eb0e
    Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1.1 04/01/2014
    Call Trace:
     dump_stack_lvl+0x6e/0x9c
     kasan_report.cold+0x112/0x117
     ? alarm_expires_remaining+0x49/0x70
     __asan_load8+0x86/0xb0
     alarm_expires_remaining+0x49/0x70
     idletimer_tg_show+0xe5/0x19b [xt_IDLETIMER 11219304af9316a21bee5ba9d58f76a6b9bccc6d]
     dev_attr_show+0x3c/0x60
     sysfs_kf_seq_show+0x11d/0x1f0
     ? device_remove_bin_file+0x20/0x20
     kernfs_seq_show+0xa4/0xb0
     seq_read_iter+0x29c/0x750
     kernfs_fop_read_iter+0x25a/0x2c0
     ? __fsnotify_parent+0x3d1/0x570
     ? iov_iter_init+0x70/0x90
     new_sync_read+0x2a7/0x3d0
     ? __x64_sys_llseek+0x230/0x230
     ? rw_verify_area+0x81/0x150
     vfs_read+0x17b/0x240
     ksys_read+0xd9/0x180
     ? vfs_write+0x460/0x460
     ? do_syscall_64+0x16/0xc0
     ? lockdep_hardirqs_on+0x79/0x120
     __x64_sys_read+0x43/0x50
     do_syscall_64+0x3b/0xc0
     entry_SYSCALL_64_after_hwframe+0x44/0xae
    RIP: 0033:0x7f0cdc819142
    Code: c0 e9 c2 fe ff ff 50 48 8d 3d 3a ca 0a 00 e8 f5 19 02 00 0f 1f 44 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 0f 05 <48> 3d 00 f0 ff ff 77 56 c3 0f 1f 44 00 00 48 83 ec 28 48 89 54 24
    RSP: 002b:00007fff28eee5b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
    RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f0cdc819142
    RDX: 0000000000020000 RSI: 00007f0cdc032000 RDI: 0000000000000003
    RBP: 00007f0cdc032000 R08: 00007f0cdc031010 R09: 0000000000000000
    R10: 0000000000000022 R11: 0000000000000246 R12: 00005607e9ee31f0
    R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000

Fixes: 68983a354a65 ("netfilter: xtables: Add snapshot of hardidletimer target")
Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_IDLETIMER.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 7b2f359bfce4..2f7cf5ecebf4 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -137,7 +137,7 @@ static int idletimer_tg_create(struct idletimer_tg_info *info)
 {
 	int ret;
 
-	info->timer = kmalloc(sizeof(*info->timer), GFP_KERNEL);
+	info->timer = kzalloc(sizeof(*info->timer), GFP_KERNEL);
 	if (!info->timer) {
 		ret = -ENOMEM;
 		goto out;
-- 
2.33.0



