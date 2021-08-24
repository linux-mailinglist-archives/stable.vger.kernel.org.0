Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5223F6761
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241423AbhHXRdQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:33:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241301AbhHXRbJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:31:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E585561B93;
        Tue, 24 Aug 2021 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824747;
        bh=+KYZiUeMPqdLPByNhC9Gg99A5cmbDQsf3lauq5Ei3pU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZVCx9df7eywDrOzPmt7b9In8Hm3aCJYqPHOwFeu7kf3yaAIFa0kRn0DnYAUTBsPR
         TQ+CI3YYasumWgVp1gtgrh3snCP75vUohjqkL4y/WVU8KEescQqeA3VjVJNT3duwX3
         ICF0xaXXv4+BzrSYbmcAUrb0nSIRejHe0gtJR6KsQJPw11xXnA6lfz9qYJyXyVYzyh
         zVITLofqm0T7yRQqZm0imBJY25XTKpaasRjq3PNoKpGRSaALHUbWOri28G/+3u6LvX
         96HRmI0r1uCawQjglFz1AVIPqR86aZrOHUi596loojiEQzO+9ETaDFQ+KQ40zS9x+z
         tQXuHJnOJsP8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/64] net: 6pack: fix slab-out-of-bounds in decode_data
Date:   Tue, 24 Aug 2021 13:04:44 -0400
Message-Id: <20210824170457.710623-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit 19d1532a187669ce86d5a2696eb7275310070793 ]

Syzbot reported slab-out-of bounds write in decode_data().
The problem was in missing validation checks.

Syzbot's reproducer generated malicious input, which caused
decode_data() to be called a lot in sixpack_decode(). Since
rx_count_cooked is only 400 bytes and noone reported before,
that 400 bytes is not enough, let's just check if input is malicious
and complain about buffer overrun.

Fail log:
==================================================================
BUG: KASAN: slab-out-of-bounds in drivers/net/hamradio/6pack.c:843
Write of size 1 at addr ffff888087c5544e by task kworker/u4:0/7

CPU: 0 PID: 7 Comm: kworker/u4:0 Not tainted 5.6.0-rc3-syzkaller #0
...
Workqueue: events_unbound flush_to_ldisc
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xd4/0x30b mm/kasan/report.c:374
 __kasan_report.cold+0x1b/0x32 mm/kasan/report.c:506
 kasan_report+0x12/0x20 mm/kasan/common.c:641
 __asan_report_store1_noabort+0x17/0x20 mm/kasan/generic_report.c:137
 decode_data.part.0+0x23b/0x270 drivers/net/hamradio/6pack.c:843
 decode_data drivers/net/hamradio/6pack.c:965 [inline]
 sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]

Reported-and-tested-by: syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/6pack.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 6d4742d10a78..231eaef29266 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -870,6 +870,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
 		return;
 	}
 
+	if (sp->rx_count_cooked + 2 >= sizeof(sp->cooked_buf)) {
+		pr_err("6pack: cooked buffer overrun, data loss\n");
+		sp->rx_count = 0;
+		return;
+	}
+
 	buf = sp->raw_buf;
 	sp->cooked_buf[sp->rx_count_cooked++] =
 		buf[0] | ((buf[1] << 2) & 0xc0);
-- 
2.30.2

