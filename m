Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F52B40E769
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347611AbhIPRcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353054AbhIPR3y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:29:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA7360F6B;
        Thu, 16 Sep 2021 16:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810803;
        bh=KMk49yov0aAIJvFdbrdKIwR8Zc6m977asTdDdJtRt4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N6n2ISLtpFSMwnHcLv5JI4ru+zs5jv1GQGDzoSBit/65oLeFxI+RXo3RCYgsFjtxv
         /IOl61LcL5CkGd/vXMGCD0Obh/ryQatqF6nJLKGRY/HsDX0RhTb0LIPwJ+XGgCDUKh
         Gr8qr/V7ivdXiYm5mon/dfFBaWfQOJOxIazGPgfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 231/432] xtensa: ISS: dont panic in rs_init
Date:   Thu, 16 Sep 2021 17:59:40 +0200
Message-Id: <20210916155818.675080589@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

[ Upstream commit 23411c720052ad860b3e579ee4873511e367130a ]

While alloc_tty_driver failure in rs_init would mean we have much bigger
problem, there is no reason to panic when tty_register_driver fails
there. It can fail for various reasons.

So handle the failure gracefully. Actually handle them both while at it.
This will make at least the console functional as it was enabled earlier
by console_initcall in iss_console_init. Instead of shooting down the
whole system.

We move tty_port_init() after alloc_tty_driver(), so that we don't need
to destroy the port in case the latter function fails.

Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-xtensa@linux-xtensa.org
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20210723074317.32690-2-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/platforms/iss/console.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 21184488c277..0108504dfb45 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -136,9 +136,13 @@ static const struct tty_operations serial_ops = {
 
 static int __init rs_init(void)
 {
-	tty_port_init(&serial_port);
+	int ret;
 
 	serial_driver = alloc_tty_driver(SERIAL_MAX_NUM_LINES);
+	if (!serial_driver)
+		return -ENOMEM;
+
+	tty_port_init(&serial_port);
 
 	/* Initialize the tty_driver structure */
 
@@ -156,8 +160,15 @@ static int __init rs_init(void)
 	tty_set_operations(serial_driver, &serial_ops);
 	tty_port_link_device(&serial_port, serial_driver, 0);
 
-	if (tty_register_driver(serial_driver))
-		panic("Couldn't register serial driver\n");
+	ret = tty_register_driver(serial_driver);
+	if (ret) {
+		pr_err("Couldn't register serial driver\n");
+		tty_driver_kref_put(serial_driver);
+		tty_port_destroy(&serial_port);
+
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.30.2



