Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E44411C3A
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346426AbhITRHM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:07:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346126AbhITRFC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:05:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD5961371;
        Mon, 20 Sep 2021 16:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156878;
        bh=3nBlNC0oa4+ec5C6EVkNiBlmrpmCOdwiQ3UX1CZGy/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guODSutVvLN58rgPF5x92HqdHfCz9DEMIn+3i5SWWpdgZ3lvK6TP1VlpLE0mKSRPC
         NNWuOhDpN7Yms7tOLFBPkahSrJN/kyOSSu8d/M2d9KN72G0Vl/khEicUUpAm9hUGFp
         NQwn+mrJRdzPhGipMv7Iew2fys3LKUrRZcMkiOHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 127/175] hvsi: dont panic on tty_register_driver failure
Date:   Mon, 20 Sep 2021 18:42:56 +0200
Message-Id: <20210920163922.233640691@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
index 96ce6bd1cc6f..4b6f93067ae4 100644
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



