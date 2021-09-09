Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE954057C4
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354395AbhIINmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356437AbhIIMzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A518613CF;
        Thu,  9 Sep 2021 11:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188679;
        bh=76eGioPcotaQYkVwzDjxwSd4GCkgGhVHJKyA11UTrHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A+0ufstVzXoVKlW9/sRAPMZg+JeDvhaZ1u+LsafuclRs377tTUss3rYLM7kBKWH/V
         oQ8ohkKw6JzY24GczRhXRfIuBHSGWkmTp+qpVcqb/GjfnU7zjVhuAMUM7qoRR0q614
         IwxL0n3HIiIPy9A7NBNZxWv8yP6g8Izj4JJbodAivVkAhvsD1ZtY+z97jS4R03NrOD
         Z0dd1j5ogrnzKfgwmRT6S6Ej06RyWfHYPUJbwPTkiCqN1OXHBvpOAchVegEOv7itGt
         MMXd1OyGZj4LW2XG05uaVUGvmjigF1sS0GpJaMatdV8JM2tdEro8pEeCf7Uu/sjFdF
         7JbnQHt/g+Phg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Slaby <jslaby@suse.cz>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 26/74] xtensa: ISS: don't panic in rs_init
Date:   Thu,  9 Sep 2021 07:56:38 -0400
Message-Id: <20210909115726.149004-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115726.149004-1-sashal@kernel.org>
References: <20210909115726.149004-1-sashal@kernel.org>
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

