Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA43C360C9D
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhDOOwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhDOOva (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1897613B7;
        Thu, 15 Apr 2021 14:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498266;
        bh=rqb5Q7z0UyJBQEDy03SP4fu5yDVD6BF6zCzSK2Dkrwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5oFtB8zCfuyXsr2yu21SkblBUs8YrlKDLtOMOHdoWHw/15GFpl+FVnGXqRnReRXn
         UpI5lj/7lyoZIsAv8qx+lKU3TiJy9Ma1NzfT/F2pRDtFFzeFaft8whxHI9WxLWv94E
         NlgDGmG3LWzgXlX12uSL8v5v4Nvypc8Vv2nSSJNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Majczak <lma@semihalf.com>,
        Lukasz Bartosik <lb@semihalf.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 22/47] clk: fix invalid usage of list cursor in unregister
Date:   Thu, 15 Apr 2021 16:47:14 +0200
Message-Id: <20210415144414.167647563@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Bartosik <lb@semihalf.com>

[ Upstream commit 7045465500e465b09f09d6e5bdc260a9f1aab97b ]

Fix invalid usage of a list_for_each_entry cursor in
clk_notifier_unregister(). When list is empty or if the list
is completely traversed (without breaking from the loop on one
of the entries) then the list cursor does not point to a valid
entry and therefore should not be used. The patch fixes a logical
bug that hasn't been seen in pratice however it is analogus
to the bug fixed in clk_notifier_register().

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
Link: https://lore.kernel.org/r/20210401225149.18826-2-lb@semihalf.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index af4f2ffc4fc5..9d60b3f219f6 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2990,32 +2990,28 @@ EXPORT_SYMBOL_GPL(clk_notifier_register);
  */
 int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb)
 {
-	struct clk_notifier *cn = NULL;
-	int ret = -EINVAL;
+	struct clk_notifier *cn;
+	int ret = -ENOENT;
 
 	if (!clk || !nb)
 		return -EINVAL;
 
 	clk_prepare_lock();
 
-	list_for_each_entry(cn, &clk_notifier_list, node)
-		if (cn->clk == clk)
-			break;
-
-	if (cn->clk == clk) {
-		ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);
+	list_for_each_entry(cn, &clk_notifier_list, node) {
+		if (cn->clk == clk) {
+			ret = srcu_notifier_chain_unregister(&cn->notifier_head, nb);
 
-		clk->core->notifier_count--;
+			clk->core->notifier_count--;
 
-		/* XXX the notifier code should handle this better */
-		if (!cn->notifier_head.head) {
-			srcu_cleanup_notifier_head(&cn->notifier_head);
-			list_del(&cn->node);
-			kfree(cn);
+			/* XXX the notifier code should handle this better */
+			if (!cn->notifier_head.head) {
+				srcu_cleanup_notifier_head(&cn->notifier_head);
+				list_del(&cn->node);
+				kfree(cn);
+			}
+			break;
 		}
-
-	} else {
-		ret = -ENOENT;
 	}
 
 	clk_prepare_unlock();
-- 
2.30.2



