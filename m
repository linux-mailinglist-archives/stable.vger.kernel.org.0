Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F586E036
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfGSD5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:57:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726941AbfGSD5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:57:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 900062184E;
        Fri, 19 Jul 2019 03:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508622;
        bh=0x+K6BU4fDjllyEo+Yimd2GVCgLa5ENbGONnnLzPI4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2D9VwyOWl47q1u0Kjv4dSRZ7izeV395Vq55rBFY2YMN9zIWytlDa+5BVrfutuH8yO
         Gp/t1ffXQ4D3SYkmRty1Z1dETF4fRaVWdGhnPRgMylOp+mzT/Krt18ar1JST30khHP
         ekFbaVf8gM9eJd7AUWDZ2a/OzCtr7h058ehvjeec=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kefeng Wang <wangkefeng.wang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Corey Minyard <cminyard@mvista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 007/171] ipmi_si: fix unexpected driver unregister warning
Date:   Thu, 18 Jul 2019 23:53:58 -0400
Message-Id: <20190719035643.14300-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kefeng Wang <wangkefeng.wang@huawei.com>

[ Upstream commit 2f66353963043e1d8dfacfbdf509acc5d3be7698 ]

If ipmi_si_platform_init()->platform_driver_register() fails,
platform_driver_unregister() called unconditionally will trigger
following warning,

ipmi_platform: Unable to register driver: -12
------------[ cut here ]------------
Unexpected driver unregister!
WARNING: CPU: 1 PID: 7210 at drivers/base/driver.c:193 driver_unregister+0x60/0x70 drivers/base/driver.c:193

Fix it by adding platform_registered variable, only unregister platform
driver when it is already successfully registered.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Message-Id: <20190517101245.4341-1-wangkefeng.wang@huawei.com>

Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_si_platform.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_si_platform.c b/drivers/char/ipmi/ipmi_si_platform.c
index f2a91c4d8cab..0cd849675d99 100644
--- a/drivers/char/ipmi/ipmi_si_platform.c
+++ b/drivers/char/ipmi/ipmi_si_platform.c
@@ -19,6 +19,7 @@
 #include "ipmi_si.h"
 #include "ipmi_dmi.h"
 
+static bool platform_registered;
 static bool si_tryplatform = true;
 #ifdef CONFIG_ACPI
 static bool          si_tryacpi = true;
@@ -469,9 +470,12 @@ void ipmi_si_platform_init(void)
 	int rv = platform_driver_register(&ipmi_platform_driver);
 	if (rv)
 		pr_err("Unable to register driver: %d\n", rv);
+	else
+		platform_registered = true;
 }
 
 void ipmi_si_platform_shutdown(void)
 {
-	platform_driver_unregister(&ipmi_platform_driver);
+	if (platform_registered)
+		platform_driver_unregister(&ipmi_platform_driver);
 }
-- 
2.20.1

