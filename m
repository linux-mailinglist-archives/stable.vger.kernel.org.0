Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A659235BCA0
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbhDLIoK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:44:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237606AbhDLIoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:44:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC3E960241;
        Mon, 12 Apr 2021 08:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217029;
        bh=yPuLew2KJnZSOlDbpM4PPAXm/fTfgspcnIv60BuCp+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QaO6vGjHWXG8aH4yoZbX8tkQhD/Vlc1U5o1CLs/uYtq6k8GPfSRtq97YqSB00I1Ek
         r/JKga3+7sYbqCkMQ4zOAepYguhOKY4KG6F26LnQ4ZjVzwqoE3Ht/twSCnm3VvVPtK
         h2ITtf+NpES7rLr2HQ7d2ZqT384CLHtxUR2MVDTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        Lukasz Bartosik <lb@semihalf.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 44/66] clk: fix invalid usage of list cursor in register
Date:   Mon, 12 Apr 2021 10:40:50 +0200
Message-Id: <20210412083959.543477984@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Bartosik <lb@semihalf.com>

[ Upstream commit 8d3c0c01cb2e36b2bf3c06a82b18b228d0c8f5d0 ]

Fix invalid usage of a list_for_each_entry cursor in
clk_notifier_register(). When list is empty or if the list
is completely traversed (without breaking from the loop on one
of the entries) then the list cursor does not point to a valid
entry and therefore should not be used.

The issue was dicovered when running 5.12-rc1 kernel on x86_64
with KASAN enabled:
BUG: KASAN: global-out-of-bounds in clk_notifier_register+0xab/0x230
Read of size 8 at addr ffffffffa0d10588 by task swapper/0/1

CPU: 1 PID: 1 Comm: swapper/0 Not tainted 5.12.0-rc1 #1
Hardware name: Google Caroline/Caroline,
BIOS Google_Caroline.7820.430.0 07/20/2018
Call Trace:
 dump_stack+0xee/0x15c
 print_address_description+0x1e/0x2dc
 kasan_report+0x188/0x1ce
 ? clk_notifier_register+0xab/0x230
 ? clk_prepare_lock+0x15/0x7b
 ? clk_notifier_register+0xab/0x230
 clk_notifier_register+0xab/0x230
 dw8250_probe+0xc01/0x10d4
...
Memory state around the buggy address:
 ffffffffa0d10480: 00 00 00 00 00 03 f9 f9 f9 f9 f9 f9 00 00 00 00
 ffffffffa0d10500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f9 f9
>ffffffffa0d10580: f9 f9 f9 f9 00 00 00 00 00 00 00 00 00 00 00 00
                      ^
 ffffffffa0d10600: 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9 00 00 00 00
 ffffffffa0d10680: 00 00 00 00 00 00 00 00 f9 f9 f9 f9 00 00 00 00
 ==================================================================

Fixes: b2476490ef11 ("clk: introduce the common clock framework")
Reported-by: Lukasz Majczak <lma@semihalf.com>
Signed-off-by: Lukasz Bartosik <lb@semihalf.com>
Link: https://lore.kernel.org/r/20210401225149.18826-1-lb@semihalf.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c5cf9e77fe86..7bb1c6185f20 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3628,20 +3628,19 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
 	/* search the list of notifiers for this clk */
 	list_for_each_entry(cn, &clk_notifier_list, node)
 		if (cn->clk == clk)
-			break;
+			goto found;
 
 	/* if clk wasn't in the notifier list, allocate new clk_notifier */
-	if (cn->clk != clk) {
-		cn = kzalloc(sizeof(*cn), GFP_KERNEL);
-		if (!cn)
-			goto out;
+	cn = kzalloc(sizeof(*cn), GFP_KERNEL);
+	if (!cn)
+		goto out;
 
-		cn->clk = clk;
-		srcu_init_notifier_head(&cn->notifier_head);
+	cn->clk = clk;
+	srcu_init_notifier_head(&cn->notifier_head);
 
-		list_add(&cn->node, &clk_notifier_list);
-	}
+	list_add(&cn->node, &clk_notifier_list);
 
+found:
 	ret = srcu_notifier_chain_register(&cn->notifier_head, nb);
 
 	clk->core->notifier_count++;
-- 
2.30.2



