Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6A835BEB5
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237756AbhDLJBn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:01:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238731AbhDLI5K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:57:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E18536109E;
        Mon, 12 Apr 2021 08:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217788;
        bh=h/E3/eSN70dveWVnv125Bc17TEw0NwoT78li7FhZbN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7vIMPiFHo1lDvLdVii3N9e75zpqDCndTCAuw8G1Js2PX6d+S2paMjNROO/yNpBJr
         ovHnHg6g4Jt5ZlhVgw7x6JT8/i9VITNMqerhCUMoPfaMRrFsqNY1dN5/E3MzAyt5OW
         Y8E65ZDyEvzILFNjI/HA52yvX0IBKidehEItM/3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        Lukasz Bartosik <lb@semihalf.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/188] clk: fix invalid usage of list cursor in register
Date:   Mon, 12 Apr 2021 10:41:00 +0200
Message-Id: <20210412084018.479273518@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
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
index f83dac54ed85..dae090124263 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -4262,20 +4262,19 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb)
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



