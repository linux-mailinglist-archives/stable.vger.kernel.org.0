Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A3E40510D
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348678AbhIIMda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:38688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353665AbhIIM3P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:29:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E25E361B42;
        Thu,  9 Sep 2021 11:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188347;
        bh=76eGioPcotaQYkVwzDjxwSd4GCkgGhVHJKyA11UTrHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RILflNmZvnFbVYdFafs1jU6VnUdQ4a2usNhRQdS0mdAOwSzICngsy2YwJUvxpUXxn
         cSu2IMvGbCGj5dB2xzG955ng+yAHMZ7orUvZyKbqqkUpFk9E+wnQ4fquFX2xqW012q
         DgUuv1JNvTCTiMsz9W3h9RlDZMLO46rsrPajyM4kbNGnF98wUyKlAKD/jeF972wh48
         vkAUSZC4HQ5HrllHJhw5BQ90NopcdGMKmwDRcrx0rK9xWkkcB0dl/rybqcZTFYJ4wZ
         DfAvr/obJnxYltTzF7iJ1TsEO97IrC9z69u+ctUK3JgCGocLDtH5xmWXYRgc/f8Eq1
         aspW+Rd4Nt0yQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 054/176] xtensa: ISS: don't panic in rs_init
Date:   Thu,  9 Sep 2021 07:49:16 -0400
Message-Id: <20210909115118.146181-54-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index af81a62faba6..e7faea3d73d3 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -168,9 +168,13 @@ static const struct tty_operations serial_ops = {
 
 int __init rs_init(void)
 {
-	tty_port_init(&serial_port);
+	int ret;
 
 	serial_driver = alloc_tty_driver(SERIAL_MAX_NUM_LINES);
+	if (!serial_driver)
+		return -ENOMEM;
+
+	tty_port_init(&serial_port);
 
 	pr_info("%s %s\n", serial_name, serial_version);
 
@@ -190,8 +194,15 @@ int __init rs_init(void)
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

