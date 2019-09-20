Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44FD4B9312
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392784AbfITOhc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:37:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35788 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388031AbfITOZA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0004x6-1e; Fri, 20 Sep 2019 15:24:58 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007qo-UQ; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "John Garry" <john.garry@huawei.com>,
        "Kefeng Wang" <wangkefeng.wang@huawei.com>,
        "Guenter Roeck" <linux@roeck-us.net>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.32155718@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 028/132] hwmon: (f71805f) Use request_muxed_region
 for Super-IO accesses
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 73e6ff71a7ea924fb7121d576a2d41e3be3fc6b5 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/f71805f.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

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
@@ -1562,7 +1568,7 @@ exit:
 static int __init f71805f_find(int sioaddr, unsigned short *address,
 			       struct f71805f_sio_data *sio_data)
 {
-	int err = -ENODEV;
+	int err;
 	u16 devid;
 
 	static const char * const names[] = {
@@ -1570,8 +1576,11 @@ static int __init f71805f_find(int sioad
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

