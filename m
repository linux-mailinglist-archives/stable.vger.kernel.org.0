Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECE3411ABE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244952AbhITQvv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237075AbhITQuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A04D61205;
        Mon, 20 Sep 2021 16:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156532;
        bh=YHyLKLJMiC7h8clHrRdJl/BiyZcldiTsutvJw2V/3WY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UzSK7e7+P5hHOzn2PKYK5HsuLVkYjQqN6o2faUM7GUvpLt3/SMY5zKorHs8QACb5m
         1+Ay2qQB4hjjAGpub05KxfFEJoGuMbpsuF/IxeA5VHiGPLa8PUccF2B/lx7ZM9R6wC
         P6RWhIiJU2ChsQGmaMiHIaDqIhWd+Pl/FsGSxGc0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 103/133] hvsi: dont panic on tty_register_driver failure
Date:   Mon, 20 Sep 2021 18:43:01 +0200
Message-Id: <20210920163916.000566299@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a75146f600cb..3e29f5f0d4ca 100644
--- a/drivers/tty/hvc/hvsi.c
+++ b/drivers/tty/hvc/hvsi.c
@@ -1051,7 +1051,7 @@ static const struct tty_operations hvsi_ops = {
 
 static int __init hvsi_init(void)
 {
-	int i;
+	int i, ret;
 
 	hvsi_driver = alloc_tty_driver(hvsi_count);
 	if (!hvsi_driver)
@@ -1082,12 +1082,25 @@ static int __init hvsi_init(void)
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



