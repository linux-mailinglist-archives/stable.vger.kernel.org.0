Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448283F6820
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240946AbhHXRkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:40:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:42932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241949AbhHXRip (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:38:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 01A3361BF9;
        Tue, 24 Aug 2021 17:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824886;
        bh=Ld9cC3vC7UbftXhipV+KeF52WmK47HMNV0ey/W3GKkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mphQ2uSt2KFMnE5vTfhS7M60VGRV4rT3dsJAmGJTqZZnsm9neJZKw/hBMY4SFp7Y2
         V9u5Aec3guW8Gb6iZ65g6CgTkrTRzjt+6Ycn0KOcgMvM7qasuQKdupVk71cfZ1wjh1
         CS1UihXQKRT7bC9tly//Yl2LzVhg6aSHP2rPmqEiATvAcji9vRHzILGqr9TjZwZCJi
         V+3Sv5vscYtE/tdqCScSB9ILoCVkKDwezdxTRLb1H7n1VNVW5vVEdFkdI6LEt8S4/P
         gNzItqti1mCuF5Dn7wHWN7fusNuUf2BEQC4nW+Ji5WWDLYQwIhBbEgaBI2fwfF9aSp
         4GPspXmOpxrKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+fc8cd9a673d4577fb2e4@syzkaller.appspotmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 23/31] net: 6pack: fix slab-out-of-bounds in decode_data
Date:   Tue, 24 Aug 2021 13:07:35 -0400
Message-Id: <20210824170743.710957-24-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170743.710957-1-sashal@kernel.org>
References: <20210824170743.710957-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.282-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.282-rc1
X-KernelTest-Deadline: 2021-08-26T17:07+00:00
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
index 732c68ed166a..cce901add654 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -874,6 +874,12 @@ static void decode_data(struct sixpack *sp, unsigned char inbyte)
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

