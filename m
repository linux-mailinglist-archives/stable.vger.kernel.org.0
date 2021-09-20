Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D13D411AB7
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbhITQve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:51:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229485AbhITQuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:50:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 157E3611ED;
        Mon, 20 Sep 2021 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156530;
        bh=LzuumibSxZczbRCy/9ENplua8GtJNGJLSESXArKcQ2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cz0PbdNrc6+ZCax/41GYwCoVNea4In6mw16OaNLqCeXb/ZHND0gxnBxrRpD91VaIx
         Aqd1O1FLJN1BODOFqET5Rg77cGa9SUAATFgcxW3he1bh1m3qFxSeJ416RMxZdXQbvr
         PN+8zukVbuqdKP3RWnFKVmfb+4dGWJbVch9XyC20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 102/133] xtensa: ISS: dont panic in rs_init
Date:   Mon, 20 Sep 2021 18:43:00 +0200
Message-Id: <20210920163915.968208955@linuxfoundation.org>
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
index 92d785fefb6d..5d264ae517f5 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -186,9 +186,13 @@ static const struct tty_operations serial_ops = {
 
 int __init rs_init(void)
 {
-	tty_port_init(&serial_port);
+	int ret;
 
 	serial_driver = alloc_tty_driver(SERIAL_MAX_NUM_LINES);
+	if (!serial_driver)
+		return -ENOMEM;
+
+	tty_port_init(&serial_port);
 
 	printk ("%s %s\n", serial_name, serial_version);
 
@@ -208,8 +212,15 @@ int __init rs_init(void)
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



