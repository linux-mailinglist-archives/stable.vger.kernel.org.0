Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF88B9309
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391762AbfITOgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:36:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35846 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388053AbfITOZB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:01 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0004x8-1a; Fri, 20 Sep 2019 15:24:58 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqC-0007qt-VA; Fri, 20 Sep 2019 15:24:56 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "John Garry" <john.garry@huawei.com>,
        "Guenter Roeck" <linux@roeck-us.net>,
        "Kefeng Wang" <wangkefeng.wang@huawei.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.488371457@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 029/132] hwmon: (pc87427) Use request_muxed_region
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

commit 755a9b0f8aaa5639ba5671ca50080852babb89ce upstream.

Super-IO accesses may fail on a system with no or unmapped LPC bus.

Also, other drivers may attempt to access the LPC bus at the same time,
resulting in undefined behavior.

Use request_muxed_region() to ensure that IO access on the requested
address space is supported, and to ensure that access by multiple drivers
is synchronized.

Fixes: ba224e2c4f0a7 ("hwmon: New PC87427 hardware monitoring driver")
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: John Garry <john.garry@huawei.com>
Cc: John Garry <john.garry@huawei.com>
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/pc87427.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -106,6 +106,13 @@ static const char *logdev_str[2] = { DRV
 #define LD_IN		1
 #define LD_TEMP		1
 
+static inline int superio_enter(int sioaddr)
+{
+	if (!request_muxed_region(sioaddr, 2, DRVNAME))
+		return -EBUSY;
+	return 0;
+}
+
 static inline void superio_outb(int sioaddr, int reg, int val)
 {
 	outb(reg, sioaddr);
@@ -122,6 +129,7 @@ static inline void superio_exit(int sioa
 {
 	outb(0x02, sioaddr);
 	outb(0x02, sioaddr + 1);
+	release_region(sioaddr, 2);
 }
 
 /*
@@ -1221,7 +1229,11 @@ static int __init pc87427_find(int sioad
 {
 	u16 val;
 	u8 cfg, cfg_b;
-	int i, err = 0;
+	int i, err;
+
+	err = superio_enter(sioaddr);
+	if (err)
+		return err;
 
 	/* Identify device */
 	val = force_id ? force_id : superio_inb(sioaddr, SIOREG_DEVID);

