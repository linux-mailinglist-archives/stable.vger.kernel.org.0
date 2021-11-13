Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DAF44F3C1
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 15:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhKMOsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 09:48:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhKMOsx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Nov 2021 09:48:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50E0A6054E;
        Sat, 13 Nov 2021 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636814760;
        bh=wdBtBJgN9pJMHmi9wAeigwDIVMwlNiYOr6yD9PLKBDE=;
        h=Subject:To:Cc:From:Date:From;
        b=GBHYRFDJcpx+kI19apmSit5okTMm2Gnd17QFGsOmwdTj9TUgo65FBn9rigZimN2g4
         9GFRAYYnV/Ge+mFynWERH7LqxOQ3Dcw7PoqniKk1/t7GOHQEfPKdqcnsl47nNy0r8d
         JdiyXG8l2W0aVjzRAOuO4Z++Zkci5QhASiKOaniI=
Subject: FAILED: patch "[PATCH] memory: renesas-rpc-if: Avoid unaligned bus access for" failed to apply to 5.14-stable tree
To:     andrew_gabbasov@mentor.com, krzysztof.kozlowski@canonical.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 13 Nov 2021 15:45:50 +0100
Message-ID: <1636814750230209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1869023e24c0de73a160a424dac4621cefd628ae Mon Sep 17 00:00:00 2001
From: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Date: Wed, 22 Sep 2021 13:48:30 -0500
Subject: [PATCH] memory: renesas-rpc-if: Avoid unaligned bus access for
 HyperFlash

HyperFlash devices in Renesas SoCs use 2-bytes addressing, according
to HW manual paragraph 62.3.3 (which officially describes Serial Flash
access, but seems to be applicable to HyperFlash too). And 1-byte bus
read operations to 2-bytes unaligned addresses in external address space
read mode work incorrectly (returns the other byte from the same word).

Function memcpy_fromio(), used by the driver to read data from the bus,
in ARM64 architecture (to which Renesas cores belong) uses 8-bytes
bus accesses for appropriate aligned addresses, and 1-bytes accesses
for other addresses. This results in incorrect data read from HyperFlash
in unaligned cases.

This issue can be reproduced using something like the following commands
(where mtd1 is a parition on Hyperflash storage, defined properly
in a device tree):

[Correct fragment, read from Hyperflash]

    root@rcar-gen3:~# dd if=/dev/mtd1 of=/tmp/zz bs=32 count=1
    root@rcar-gen3:~# hexdump -C /tmp/zz
    00000000  f4 03 00 aa f5 03 01 aa  f6 03 02 aa f7 03 03 aa  |................|
    00000010  00 00 80 d2 40 20 18 d5  00 06 81 d2 a0 18 a6 f2  |....@ ..........|
    00000020

[Incorrect read of the same fragment: see the difference at offsets 8-11]

    root@rcar-gen3:~# dd if=/dev/mtd1 of=/tmp/zz bs=12 count=1
    root@rcar-gen3:~# hexdump -C /tmp/zz
    00000000  f4 03 00 aa f5 03 01 aa  03 03 aa aa              |............|
    0000000c

Fix this issue by creating a local replacement of the copying function,
that performs only properly aligned bus accesses, and is used for reading
from HyperFlash.

Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Gabbasov <andrew_gabbasov@mentor.com>
Link: https://lore.kernel.org/r/20210922184830.29147-1-andrew_gabbasov@mentor.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

diff --git a/drivers/memory/renesas-rpc-if.c b/drivers/memory/renesas-rpc-if.c
index 77a011d5ff8c..7435baad0007 100644
--- a/drivers/memory/renesas-rpc-if.c
+++ b/drivers/memory/renesas-rpc-if.c
@@ -185,7 +185,6 @@ static int rpcif_reg_read(void *context, unsigned int reg, unsigned int *val)
 
 	*val = readl(rpc->base + reg);
 	return 0;
-
 }
 
 static int rpcif_reg_write(void *context, unsigned int reg, unsigned int val)
@@ -545,6 +544,48 @@ err_out:
 }
 EXPORT_SYMBOL(rpcif_manual_xfer);
 
+static void memcpy_fromio_readw(void *to,
+				const void __iomem *from,
+				size_t count)
+{
+	const int maxw = (IS_ENABLED(CONFIG_64BIT)) ? 8 : 4;
+	u8 buf[2];
+
+	if (count && ((unsigned long)from & 1)) {
+		*(u16 *)buf = __raw_readw((void __iomem *)((unsigned long)from & ~1));
+		*(u8 *)to = buf[1];
+		from++;
+		to++;
+		count--;
+	}
+	while (count >= 2 && !IS_ALIGNED((unsigned long)from, maxw)) {
+		*(u16 *)to = __raw_readw(from);
+		from += 2;
+		to += 2;
+		count -= 2;
+	}
+	while (count >= maxw) {
+#ifdef CONFIG_64BIT
+		*(u64 *)to = __raw_readq(from);
+#else
+		*(u32 *)to = __raw_readl(from);
+#endif
+		from += maxw;
+		to += maxw;
+		count -= maxw;
+	}
+	while (count >= 2) {
+		*(u16 *)to = __raw_readw(from);
+		from += 2;
+		to += 2;
+		count -= 2;
+	}
+	if (count) {
+		*(u16 *)buf = __raw_readw(from);
+		*(u8 *)to = buf[0];
+	}
+}
+
 ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
 {
 	loff_t from = offs & (RPCIF_DIRMAP_SIZE - 1);
@@ -566,7 +607,10 @@ ssize_t rpcif_dirmap_read(struct rpcif *rpc, u64 offs, size_t len, void *buf)
 	regmap_write(rpc->regmap, RPCIF_DRDMCR, rpc->dummy);
 	regmap_write(rpc->regmap, RPCIF_DRDRENR, rpc->ddr);
 
-	memcpy_fromio(buf, rpc->dirmap + from, len);
+	if (rpc->bus_size == 2)
+		memcpy_fromio_readw(buf, rpc->dirmap + from, len);
+	else
+		memcpy_fromio(buf, rpc->dirmap + from, len);
 
 	pm_runtime_put(rpc->dev);
 

