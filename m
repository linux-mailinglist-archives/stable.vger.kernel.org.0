Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741EA2EE19
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbfE3DoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732397AbfE3DU7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:59 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D12C249A0;
        Thu, 30 May 2019 03:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186458;
        bh=zabL5YfqfgkOhrTRcXafw5T08OQA8mRkWoJ70DYQGDc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4TvQxcKwdQALmGRJM+koAToXob8SHAn6wYH54WVAaqJCJtx4fOJ0pwx4vzsKjLy0
         XRiLJz24iZB4D7ApGgmAZAU0BkLbmm3TWI4HcIOK7G0Z7WRxCmX59URP5KbsFWSZ2b
         1XZLXI0XHWhobzl8LXkMyNOYXKip4VVH4g45EWwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kefeng Wang <wangkefeng.wang@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 074/128] hwmon: (smsc47b397) Use request_muxed_region for Super-IO accesses
Date:   Wed, 29 May 2019 20:06:46 -0700
Message-Id: <20190530030447.969984888@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
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



