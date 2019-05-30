Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6258D2EF46
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730357AbfE3DyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731883AbfE3DTY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:24 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B9B247F7;
        Thu, 30 May 2019 03:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186364;
        bh=CLNvXd+bHDw5o9XKvwpl1iSa3ZtiTufxn3+Q/WLnUZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0WCMu3YJguVXsP+oJyGEWHuMsUvLbXbJxT0pAhPsiznS87sRiiJNFjoEtRzpRSKd
         81gv44otu+uBltMAzRiCr4ayRcB6dgSzFsZQfhqBfsgLBaKCnp66YUS0LUErcFtZSD
         93+VfPfG5k5FLS7Vkm6hOjmWQF6JEV3dwqBSTsYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 112/193] hwmon: (smsc47m1) Use request_muxed_region for Super-IO accesses
Date:   Wed, 29 May 2019 20:06:06 -0700
Message-Id: <20190530030504.389851432@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d6410408ad2a798c4cc685252c1baa713be0ad69 ]

Super-IO accesses may fail on a system with no or unmapped LPC bus.

Also, other drivers may attempt to access the LPC bus at the same time,
resulting in undefined behavior.

Use request_muxed_region() to ensure that IO access on the requested
address space is supported, and to ensure that access by multiple drivers
is synchronized.

Fixes: 8d5d45fb1468 ("I2C: Move hwmon drivers (2/3)")
Reported-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reported-by: John Garry <john.garry@huawei.com>
Cc: John Garry <john.garry@huawei.com>
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/smsc47m1.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/smsc47m1.c b/drivers/hwmon/smsc47m1.c
index c7b6a425e2c02..5eeac9853d0ae 100644
--- a/drivers/hwmon/smsc47m1.c
+++ b/drivers/hwmon/smsc47m1.c
@@ -73,16 +73,21 @@ superio_inb(int reg)
 /* logical device for fans is 0x0A */
 #define superio_select() superio_outb(0x07, 0x0A)
 
-static inline void
+static inline int
 superio_enter(void)
 {
+	if (!request_muxed_region(REG, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x55, REG);
+	return 0;
 }
 
 static inline void
 superio_exit(void)
 {
 	outb(0xAA, REG);
+	release_region(REG, 2);
 }
 
 #define SUPERIO_REG_ACT		0x30
@@ -531,8 +536,12 @@ static int __init smsc47m1_find(struct smsc47m1_sio_data *sio_data)
 {
 	u8 val;
 	unsigned short addr;
+	int err;
+
+	err = superio_enter();
+	if (err)
+		return err;
 
-	superio_enter();
 	val = force_id ? force_id : superio_inb(SUPERIO_REG_DEVID);
 
 	/*
@@ -608,13 +617,14 @@ static int __init smsc47m1_find(struct smsc47m1_sio_data *sio_data)
 static void smsc47m1_restore(const struct smsc47m1_sio_data *sio_data)
 {
 	if ((sio_data->activate & 0x01) == 0) {
-		superio_enter();
-		superio_select();
-
-		pr_info("Disabling device\n");
-		superio_outb(SUPERIO_REG_ACT, sio_data->activate);
-
-		superio_exit();
+		if (!superio_enter()) {
+			superio_select();
+			pr_info("Disabling device\n");
+			superio_outb(SUPERIO_REG_ACT, sio_data->activate);
+			superio_exit();
+		} else {
+			pr_warn("Failed to disable device\n");
+		}
 	}
 }
 
-- 
2.20.1



