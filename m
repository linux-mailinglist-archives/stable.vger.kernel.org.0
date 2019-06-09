Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06FD73A88F
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732571AbfFIRBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 13:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:39222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388124AbfFIRBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 13:01:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2E1207E0;
        Sun,  9 Jun 2019 17:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099704;
        bh=zabL5YfqfgkOhrTRcXafw5T08OQA8mRkWoJ70DYQGDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kE5D3TfyrsAqYY1oJtbF7qFJG7fx+Lw49/Ayb1jHMZesVcwT+eW34MyBu+Yd0bt5i
         h8Dj9EJRxIP2gdA6NbAabGULto4g98alzf7VbPffvfIHo0scKm2mlbjqV1usjc+kkI
         EaSArS0lP7XoXAoq4F6eHvoNK87eck+aCJDT8t7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 134/241] hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses
Date:   Sun,  9 Jun 2019 18:41:16 +0200
Message-Id: <20190609164151.662324680@linuxfoundation.org>
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

[ Upstream commit 8c0826756744c0ac1df600a5e4cca1a341b13101 ]

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
 drivers/hwmon/smsc47b397.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/smsc47b397.c b/drivers/hwmon/smsc47b397.c
index 6bd2007565603..cbdb5c4991ae3 100644
--- a/drivers/hwmon/smsc47b397.c
+++ b/drivers/hwmon/smsc47b397.c
@@ -72,14 +72,19 @@ static inline void superio_select(int ld)
 	superio_outb(0x07, ld);
 }
 
-static inline void superio_enter(void)
+static inline int superio_enter(void)
 {
+	if (!request_muxed_region(REG, 2, DRVNAME))
+		return -EBUSY;
+
 	outb(0x55, REG);
+	return 0;
 }
 
 static inline void superio_exit(void)
 {
 	outb(0xAA, REG);
+	release_region(REG, 2);
 }
 
 #define SUPERIO_REG_DEVID	0x20
@@ -300,8 +305,12 @@ static int __init smsc47b397_find(void)
 	u8 id, rev;
 	char *name;
 	unsigned short addr;
+	int err;
+
+	err = superio_enter();
+	if (err)
+		return err;
 
-	superio_enter();
 	id = force_id ? force_id : superio_inb(SUPERIO_REG_DEVID);
 
 	switch (id) {
-- 
2.20.1



