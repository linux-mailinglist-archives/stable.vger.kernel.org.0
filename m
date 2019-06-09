Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6DE3A8C9
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388214AbfFIRES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388589AbfFIREQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:04:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B997207E0;
        Sun,  9 Jun 2019 17:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099856;
        bh=DjLObwZZ+RDNqaf2WeRU/ZKKUnJDXzMdktihC5/aKoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h37r+TkiYMawl6PKjiupByiCjiiQ6np3ekzckYYj+jm6N1qMRJnojULiA5PjDCaJw
         OaalKus6N41t0iv7+UV3pbRyT38FrUx/qETw0OKoNQpRSfoUoVqooEIOCzwrbR3Q12
         aCJ10y6YQeg9rPGVZKMFiXKVbpb9Nr02+SskL9Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 136/241] hwmon: (f71805f) Use request_muxed_region for Super-IO accesses
Date:   Sun,  9 Jun 2019 18:41:18 +0200
Message-Id: <20190609164151.719533312@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
References: <20190609164147.729157653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 73e6ff71a7ea924fb7121d576a2d41e3be3fc6b5 ]

Super-IO accesses may fail on a system with no or unmapped LPC bus.

Unable to handle kernel paging request at virtual address ffffffbffee0002e
pgd = ffffffc1d68d4000
[ffffffbffee0002e] *pgd=0000000000000000, *pud=0000000000000000
Internal error: Oops: 94000046 [#1] PREEMPT SMP
Modules linked in: f71805f(+) hwmon
CPU: 3 PID: 1659 Comm: insmod Not tainted 4.5.0+ #88
Hardware name: linux,dummy-virt (DT)
task: ffffffc1f6665400 ti: ffffffc1d6418000 task.ti: ffffffc1d6418000
PC is at f71805f_find+0x6c/0x358 [f71805f]

Also, other drivers may attempt to access the LPC bus at the same time,
resulting in undefined behavior.

Use request_muxed_region() to ensure that IO access on the requested
address space is supported, and to ensure that access by multiple
drivers is synchronized.

Fixes: e53004e20a58e ("hwmon: New f71805f driver")
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: John Garry <john.garry@huawei.com>
Cc: John Garry <john.garry@huawei.com>
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/f71805f.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/f71805f.c b/drivers/hwmon/f71805f.c
index facd05cda26da..e8c0898864277 100644
--- a/drivers/hwmon/f71805f.c
+++ b/drivers/hwmon/f71805f.c
@@ -96,17 +96,23 @@ superio_select(int base, int ld)
 	outb(ld, base + 1);
 }
 
-static inline void
+static inline int
 superio_enter(int base)
 {
+	if (!request_muxed_region(base, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x87, base);
 	outb(0x87, base);
+
+	return 0;
 }
 
 static inline void
 superio_exit(int base)
 {
 	outb(0xaa, base);
+	release_region(base, 2);
 }
 
 /*
@@ -1561,7 +1567,7 @@ static int __init f71805f_device_add(unsigned short address,
 static int __init f71805f_find(int sioaddr, unsigned short *address,
 			       struct f71805f_sio_data *sio_data)
 {
-	int err = -ENODEV;
+	int err;
 	u16 devid;
 
 	static const char * const names[] = {
@@ -1569,8 +1575,11 @@ static int __init f71805f_find(int sioaddr, unsigned short *address,
 		"F71872F/FG or F71806F/FG",
 	};
 
-	superio_enter(sioaddr);
+	err = superio_enter(sioaddr);
+	if (err)
+		return err;
 
+	err = -ENODEV;
 	devid = superio_inw(sioaddr, SIO_REG_MANID);
 	if (devid != SIO_FINTEK_ID)
 		goto exit;
-- 
2.20.1



