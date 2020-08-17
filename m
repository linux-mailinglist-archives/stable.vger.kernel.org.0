Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D1C2469BA
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbgHQPZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbgHQPZG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:25:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDA0E238E1;
        Mon, 17 Aug 2020 15:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597677906;
        bh=+SNz0pCTYmrs+U/VrvZz0yH8yLa9j5TIF237NZBy0Bg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mSOAxHLpyIdwk385Uc6ClYjjxJ2moiD8nwyRf2IVsG7PmWV8NJSfUYdi2401cXlSU
         OxuWfs2AYdoWH31OiZv96TlUKZXMU167Q45xE8P6f2iapZvev0QEOVaDxOvjdqxh2V
         QXD/d1YNOTPAX0NTLqlBPYd4GR/HBErBPW5OcU+4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Dejin Zheng <zhengdejin5@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@osdl.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 150/464] console: newport_con: fix an issue about leak related system resources
Date:   Mon, 17 Aug 2020 17:11:43 +0200
Message-Id: <20200817143840.995160676@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dejin Zheng <zhengdejin5@gmail.com>

[ Upstream commit fd4b8243877250c05bb24af7fea5567110c9720b ]

A call of the function do_take_over_console() can fail here.
The corresponding system resources were not released then.
Thus add a call of iounmap() and release_mem_region()
together with the check of a failure predicate. and also
add release_mem_region() on device removal.

Fixes: e86bb8acc0fdc ("[PATCH] VT binding: Make newport_con support binding")
Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200423164251.3349-1-zhengdejin5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/console/newport_con.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/newport_con.c b/drivers/video/console/newport_con.c
index 504cda38763e0..df3c52d721597 100644
--- a/drivers/video/console/newport_con.c
+++ b/drivers/video/console/newport_con.c
@@ -31,6 +31,8 @@
 #include <linux/linux_logo.h>
 #include <linux/font.h>
 
+#define NEWPORT_LEN	0x10000
+
 #define FONT_DATA ((unsigned char *)font_vga_8x16.data)
 
 /* borrowed from fbcon.c */
@@ -42,6 +44,7 @@
 static unsigned char *font_data[MAX_NR_CONSOLES];
 
 static struct newport_regs *npregs;
+static unsigned long newport_addr;
 
 static int logo_active;
 static int topscan;
@@ -701,7 +704,6 @@ const struct consw newport_con = {
 static int newport_probe(struct gio_device *dev,
 			 const struct gio_device_id *id)
 {
-	unsigned long newport_addr;
 	int err;
 
 	if (!dev->resource.start)
@@ -711,7 +713,7 @@ static int newport_probe(struct gio_device *dev,
 		return -EBUSY; /* we only support one Newport as console */
 
 	newport_addr = dev->resource.start + 0xF0000;
-	if (!request_mem_region(newport_addr, 0x10000, "Newport"))
+	if (!request_mem_region(newport_addr, NEWPORT_LEN, "Newport"))
 		return -ENODEV;
 
 	npregs = (struct newport_regs *)/* ioremap cannot fail */
@@ -719,6 +721,11 @@ static int newport_probe(struct gio_device *dev,
 	console_lock();
 	err = do_take_over_console(&newport_con, 0, MAX_NR_CONSOLES - 1, 1);
 	console_unlock();
+
+	if (err) {
+		iounmap((void *)npregs);
+		release_mem_region(newport_addr, NEWPORT_LEN);
+	}
 	return err;
 }
 
@@ -726,6 +733,7 @@ static void newport_remove(struct gio_device *dev)
 {
 	give_up_console(&newport_con);
 	iounmap((void *)npregs);
+	release_mem_region(newport_addr, NEWPORT_LEN);
 }
 
 static struct gio_device_id newport_ids[] = {
-- 
2.25.1



