Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA6B404E65
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238729AbhIIMLe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348083AbhIIMJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:09:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2449619E8;
        Thu,  9 Sep 2021 11:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188084;
        bh=HJZadhkc3lcjE7AapxAuKY6kRDDcL5N6KsyajWYJPs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YBssv2GLFsoH14fuVM1xuBnFjBpFlYl8hHqoHVk32UKhtc7UeWv2nL9r9hFjc0HsK
         zJBBe5+Ceid8+TlgyOkK/RCPf7tzFDlLTcD6vnJA3Y8bPnqrzFuzGj3A/LbIQQJ+JZ
         1KPe6fP0aiO/HSj2l7fsOwjBiQ7RSTLT7Jmu32E6XgZtfD6Bu5d7HTGFgO89SlKlxC
         2qjep1kiGadNWWOlx4RKUE0WaAwQwi7UEcBa9iSPeTnWxFRq6gQ7fHMUlc50MQIvF2
         TjNe0XELYRtCSUFrRql/ZagJXPzGytmQz3nJ6rpyY447oZ8WEiJPMjP5GHxRS0SMth
         o9Tl/WbwZlGmg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>, linuxppc-dev@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.13 069/219] hvsi: don't panic on tty_register_driver failure
Date:   Thu,  9 Sep 2021 07:44:05 -0400
Message-Id: <20210909114635.143983-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 7ccbdcc4d08a6d7041e4849219bbb12ffa45db4c ]

The alloc_tty_driver failure is handled gracefully in hvsi_init. But
tty_register_driver is not. panic is called if that one fails.

So handle the failure of tty_register_driver gracefully too. This will
keep at least the console functional as it was enabled earlier by
console_initcall in hvsi_console_init. Instead of shooting down the
whole system.

This means, we disable interrupts and restore hvsi_wait back to
poll_for_state().

Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210723074317.32690-3-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvsi.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/hvc/hvsi.c b/drivers/tty/hvc/hvsi.c
index e8c58f9bd263..d6afaae1729a 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1038,7 +1038,7 @@ static const struct tty_operations hvsi_ops = {
 
 static int __init hvsi_init(void)
 {
-	int i;
+	int i, ret;
 
 	hvsi_driver = alloc_tty_driver(hvsi_count);
 	if (!hvsi_driver)
@@ -1069,12 +1069,25 @@ static int __init hvsi_init(void)
 	}
 	hvsi_wait = wait_for_state; /* irqs active now */
 
-	if (tty_register_driver(hvsi_driver))
-		panic("Couldn't register hvsi console driver\n");
+	ret = tty_register_driver(hvsi_driver);
+	if (ret) {
+		pr_err("Couldn't register hvsi console driver\n");
+		goto err_free_irq;
+	}
 
 	printk(KERN_DEBUG "HVSI: registered %i devices\n", hvsi_count);
 
 	return 0;
+err_free_irq:
+	hvsi_wait = poll_for_state;
+	for (i = 0; i < hvsi_count; i++) {
+		struct hvsi_struct *hp = &hvsi_ports[i];
+
+		free_irq(hp->virq, hp);
+	}
+	tty_driver_kref_put(hvsi_driver);
+
+	return ret;
 }
 device_initcall(hvsi_init);
 
-- 
2.30.2

