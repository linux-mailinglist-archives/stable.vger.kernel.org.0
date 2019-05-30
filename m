Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FE12F5C9
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729077AbfE3EuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbfE3DLD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:11:03 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 582D7244A6;
        Thu, 30 May 2019 03:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185863;
        bh=gRT0Shxa1/rK5dm70Mz/g1k6F9YNAoErA22I0xm8/9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B31ZjyzqAtr7+2Kf/PAV2LbA0RinTxgPik1Pdh11V+vTEfSiDw0ETni78mBq4AuvV
         71UVmLY3UTjRUt1RpXJ1XudUS9TQ0e4ZGsovjDqUvhupX5kL0jEXqgrGpzhrhFlhq2
         4l/hnBJO+CswR1zbmbXsQk0omeCT8YGgPKr6/CFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 200/405] hwmon: (pc87427) Use request_muxed_region for Super-IO accesses
Date:   Wed, 29 May 2019 20:03:18 -0700
Message-Id: <20190530030551.315685682@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 755a9b0f8aaa5639ba5671ca50080852babb89ce ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pc87427.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pc87427.c b/drivers/hwmon/pc87427.c
index d1a3f2040c007..58eee8fa3e6d6 100644
--- a/drivers/hwmon/pc87427.c
+++ b/drivers/hwmon/pc87427.c
@@ -106,6 +106,13 @@ static const char *logdev_str[2] = { DRVNAME " FMC", DRVNAME " HMC" };
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
@@ -122,6 +129,7 @@ static inline void superio_exit(int sioaddr)
 {
 	outb(0x02, sioaddr);
 	outb(0x02, sioaddr + 1);
+	release_region(sioaddr, 2);
 }
 
 /*
@@ -1195,7 +1203,11 @@ static int __init pc87427_find(int sioaddr, struct pc87427_sio_data *sio_data)
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
-- 
2.20.1



